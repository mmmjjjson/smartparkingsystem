    package com.example.smartparkingsystem.service;

    import com.example.smartparkingsystem.dao.MembersDAO;
    import com.example.smartparkingsystem.dao.ParkingHistoryDAO;
    import com.example.smartparkingsystem.dao.PaymentHistoryDAO;
    import com.example.smartparkingsystem.dto.ParkingHistoryDTO;
    import com.example.smartparkingsystem.dto.MonthlyData;
    import com.example.smartparkingsystem.vo.MembersVO;
    import com.example.smartparkingsystem.vo.ParkingHistoryVO;
    import lombok.extern.log4j.Log4j2;

    import java.time.LocalDate;
    import java.time.LocalDateTime;
    import java.util.*;


    @Log4j2
    public enum StatisticService1 {
        INSTANCE;

        // DAO 객체들 (팀원들이 만든 것 사용)
        private final PaymentHistoryDAO paymentHistoryDAO;
        private final MembersDAO membersDAO;
        private final ParkingHistoryDAO parkingHistoryDAO;

        // ========== 캐싱 변수 ==========
        private Map<Integer, List<MonthlyData>> cachedParkingData = null;
        private long lastCacheTime = 0;
        private static final long CACHE_DURATION = 5 * 60 * 1000; // 5분 캐시 유지

        // ========== 요금 정책 상수 ==========
        private static final int BASIC_TIME = 60;           // 기본 시간 (분)
        private static final int EXTRA_TIME = 30;           // 추가 단위 시간 (분)
        private static final int BASIC_CHARGE = 2000;       // 기본 요금
        private static final int EXTRA_CHARGE = 1000;       // 추가 요금
        private static final int MAX_CHARGE = 15000;        // 최대 요금
        private static final double SMALL_CAR_DISCOUNT = 0.3;     // 경차 할인율
        private static final double DISABLED_DISCOUNT = 0.5;      // 장애인 할인율
        private static final int MEMBERSHIP_PRICE = 10000;  // 회원권 가격
        private static final int FREE_MINUTES = 10;         // 무료 시간 (분)

        /**
         * 생성자 - 서비스 최초 생성 시 DAO 초기화
         */
        StatisticService1() {
            paymentHistoryDAO = new PaymentHistoryDAO();
            membersDAO = new MembersDAO();
            parkingHistoryDAO = new ParkingHistoryDAO();
        }

        /**
         * 캐싱된 주차 데이터 조회
         * - 5분마다 갱신
         */
        private Map<Integer, List<MonthlyData>> getCachedParkingData() {
            long currentTime = System.currentTimeMillis();

            // 캐시가 없거나 5분 지났으면 새로 조회
            if (cachedParkingData == null || (currentTime - lastCacheTime) > CACHE_DURATION) {
                log.info("캐시 갱신 - DB에서 데이터 조회");
                cachedParkingData = paymentHistoryDAO.selectGroupedByYearMonth();
                lastCacheTime = currentTime;
            } else {
                log.info("캐시 사용 - DB 조회 생략");
            }

            return cachedParkingData;
        }

        /**
         * 캐시 강제 갱신 (데이터 변경 시 호출)
         */
        public void refreshCache() {
            log.info("캐시 강제 갱신");
            cachedParkingData = null;
            lastCacheTime = 0;
        }

        // ========================================================
        // 기존 메서드들 (Map으로 변경)
        // ========================================================

        /**
         * 통계 페이지용 전체 데이터 조회
         *
         * @return Map<String, Object> - parkingDataByYear, memberStats, totalCount 포함
         */
        public Map<String, Object> getAllStatisticsData() {
            log.info("전체 통계 데이터 조회 시작");

            // 1. 캐싱된 데이터 조회
            Map<Integer, List<MonthlyData>> parkingDataByYear = getCachedParkingData();

            // 2. 회원 정보 조회
            List<MembersVO> allMembers = membersDAO.selectAllMembers();

            // 3. 전체 카운트 계산
            int totalCount = 0;
            for (List<MonthlyData> monthlyDataList : parkingDataByYear.values()) {
                for (MonthlyData monthlyData : monthlyDataList) {
                    totalCount += monthlyData.getRecords().size();
                }
            }

            log.info("총 데이터: " + totalCount + "건");
            log.info("회원: " + allMembers.size() + "명");

            // 4. 회원 통계 계산 (Map 반환)
            Map<String, Object> memberStats = calculateMemberStats(allMembers);

            // 5. 결과를 Map에 담아서 반환
            Map<String, Object> result = new HashMap<>();
            result.put("parkingDataByYear", parkingDataByYear);
            result.put("memberStats", memberStats);
            result.put("totalCount", totalCount);

            log.info("전체 통계 데이터 조회 완료");
            return result;
        }

        /**
         * 회원 통계 계산 (Map 반환)
         * - 총 회원 수
         * - 활성 회원 수 (end_date >= 오늘)
         * - 비활성 회원 수 (end_date < 오늘)
         *
         * @param members 전체 회원 리스트
         * @return Map<String, Object> 회원 통계
         */
        private Map<String, Object> calculateMemberStats(List<MembersVO> members) {
            log.info("회원 통계 계산 시작");

            LocalDate today = LocalDate.now();

            int totalCount = members.size();
            int activeCount = 0;

            // 활성 회원 수 계산 (회원권이 아직 유효한 회원)
            for (MembersVO member : members) {
                LocalDate endDate = member.getEndDate();

                // 종료일이 오늘 이후이거나 오늘이면 활성 회원
                if (endDate.isAfter(today) || endDate.isEqual(today)) {
                    activeCount++;
                }
            }

            // 비활성 회원 수 계산
            int inactiveCount = totalCount - activeCount;

            Map<String, Object> result = new HashMap<>();
            result.put("totalCount", totalCount);
            result.put("activeCount", activeCount);
            result.put("inactiveCount", inactiveCount);

            log.info("회원 통계: 총 " + totalCount + "명, 활성 " + activeCount + "명, 비활성 " + inactiveCount + "명");
            return result;
        }

        /**
         * 오늘 날짜 요약 통계 (Map 반환)
         * - 일일 총 매출액
         * - 일일 입차 대수
         * - 누적 차량 대수
         *
         * @return Map<String, Object> 일일 요약 통계
         */




        public Map<String, Object> getTodaySummary() {
            log.info("오늘 날짜 요약 통계 조회 시작");

            Map<Integer, List<MonthlyData>> parkingDataByYear = getCachedParkingData();
            LocalDate today = LocalDate.now();

            // 오늘 날짜 입차만 하고 출차는 안한 차량까지 포함
            List<ParkingHistoryVO> todayRecords = parkingHistoryDAO.selectByDate(today);
            int dailyCount = todayRecords.size();
            int totalCount = parkingHistoryDAO.getTotalCount();
            int dailySales = 0;


            Map<String, Object> summary = new HashMap<>();
            summary.put("dailySales", dailySales);
            summary.put("dailyCount", dailyCount);
            summary.put("totalCount", totalCount);

            log.info("오늘 요약: 입차 " + dailyCount + "대, 매출 " + dailySales + "원, 누적 " + totalCount + "대");
            return summary;
        }

        /**
         * 회원 통계만 조회 (AJAX용, Map 반환)
         *
         * @return Map<String, Object> 회원 통계
         */
        public Map<String, Object> getMemberStats() {
            log.info("회원 통계 조회");
            List<MembersVO> allMembers = membersDAO.selectAllMembers();
            return calculateMemberStats(allMembers);
        }

        // ========================================================
        // 새로 추가되는 계산 메서드들 (JSP에서 이관)
        // ========================================================

        /**
         * 주차 시간 계산 (분 단위)
         * LocalDateTime 타입으로 받음
         */
        private int calculateSpendingTime(LocalDateTime entryTime, LocalDateTime exitTime) {
            long seconds = java.time.Duration.between(entryTime, exitTime).getSeconds();
            return (int) Math.ceil(seconds / 60.0);
        }

        /**
         * 주차 요금 계산 (JSP의 calculateFee 함수와 동일)
         * @param record 주차 기록
         * @return 계산된 요금
         */
        private int calculateFee(ParkingHistoryDTO record) {
            // 회원은 요금 0
            if (record.isMember()) {
                return 0;
            }

            int minutes = calculateSpendingTime(record.getEntryTime(), record.getExitTime());

            // 10분 이하 무료
            if (minutes <= FREE_MINUTES) {
                return 0;
            }

            // 기본 요금
            int charge = BASIC_CHARGE;

            // 초과 시간 계산
            if (minutes > BASIC_TIME) {
                int extraMinutes = minutes - BASIC_TIME;
                int extraUnits = (int) Math.ceil((double) extraMinutes / EXTRA_TIME);
                charge += extraUnits * EXTRA_CHARGE;
            }

            // 차종별 할인 적용
            String carType = record.getCarType();
            if ("경차".equals(carType)) {
                charge = (int) (charge * (1 - SMALL_CAR_DISCOUNT));
            } else if ("장애인".equals(carType)) {
                charge = (int) (charge * (1 - DISABLED_DISCOUNT));
            }

            // 최대 요금 제한
            if (charge > MAX_CHARGE) {
                charge = MAX_CHARGE;
            }

            return charge;
        }

        /**
         * 1. 월별 매출 통계 (년도별 12개월 or 특정 월의 일별)
         * JSP의 drawMonthlySalesChart 함수 로직
         *
         * @param year 조회 년도
         * @param month 조회 월 (null이면 전체 월)
         * @param includeMembership 회원권 매출 포함 여부
         * @return 차트용 데이터
         */
        public Map<String, Object> getMonthlySales(int year, Integer month, boolean includeMembership) {
            log.info("월별 매출 통계 조회: year={}, month={}, includeMembership={}", year, month, includeMembership);

            Map<Integer, List<MonthlyData>> parkingDataByYear = getCachedParkingData();
            List<MonthlyData> yearData = parkingDataByYear.get(year);

            if (yearData == null) {
                log.warn("해당 년도 데이터 없음: {}", year);
                return new HashMap<>();
            }

            Map<String, Object> response = new HashMap<>();

            if (month == null) {
                // 전체 월 조회 (월별 집계)
                calculateMonthlyAggregation(yearData, includeMembership, response);
            } else {
                // 특정 월 조회 (일별 집계)
                calculateDailyAggregation(year, month, yearData, includeMembership, response);
            }

            return response;
        }

        /**
         * 월별 집계 (1월~12월)
         */
        private void calculateMonthlyAggregation(List<MonthlyData> yearData, boolean includeMembership, Map<String, Object> response) {
            List<String> categories = new ArrayList<>();
            List<Integer> normalSales = new ArrayList<>();
            List<Integer> memberSales = new ArrayList<>();

            for (MonthlyData monthData : yearData) {
                categories.add(monthData.getMonth() + "월");

                int normalSum = 0;
                int memberSum = 0;

                for (ParkingHistoryDTO record : monthData.getRecords()) {
                    if (record.isMember()) {
                        memberSum += MEMBERSHIP_PRICE;
                    } else {
                        normalSum += calculateFee(record);
                    }
                }

                normalSales.add(normalSum);
                memberSales.add(memberSum);
            }

            response.put("categories", categories);
            response.put("normalSales", normalSales);
            response.put("memberSales", memberSales);
            response.put("includeMembership", includeMembership);
        }

        /**
         * 일별 집계 (특정 월의 1일~말일)
         */
        private void calculateDailyAggregation(int year, int month, List<MonthlyData> yearData, boolean includeMembership, Map<String, Object> response) {
            MonthlyData monthData = yearData.stream()
                    .filter(m -> m.getMonth() == month)
                    .findFirst()
                    .orElse(null);

            if (monthData == null) {
                log.warn("해당 월 데이터 없음: {}월", month);
                return;
            }

            int daysInMonth = LocalDate.of(year, month, 1).lengthOfMonth();
            List<String> categories = new ArrayList<>();
            int[] dailyNormal = new int[daysInMonth];
            int[] dailyMember = new int[daysInMonth];

            // 카테고리 생성
            for (int i = 1; i <= daysInMonth; i++) {
                categories.add(i + "일");
            }

            // 일별 집계
            for (ParkingHistoryDTO record : monthData.getRecords()) {
                int day = extractDay(record.getEntryTime());
                if (day >= 1 && day <= daysInMonth) {
                    if (record.isMember()) {
                        dailyMember[day - 1] += MEMBERSHIP_PRICE;
                    } else {
                        dailyNormal[day - 1] += calculateFee(record);
                    }
                }
            }

            response.put("categories", categories);
            response.put("normalSales", toList(dailyNormal));
            response.put("memberSales", toList(dailyMember));
            response.put("includeMembership", includeMembership);
        }

        /**
         * 2. 누적 매출 통계
         * JSP의 drawCumulativeSalesChart 함수 로직
         *
         * @param year 조회 년도
         * @param month 조회 월 (null이면 월별 누적, 값이 있으면 일별 누적)
         * @param includeMembership 회원권 매출 포함 여부
         * @return 누적 차트용 데이터
         */
        public Map<String, Object> getCumulativeSales(int year, Integer month, boolean includeMembership) {
            log.info("누적 매출 통계 조회: year={}, month={}, includeMembership={}", year, month, includeMembership);

            Map<Integer, List<MonthlyData>> parkingDataByYear = getCachedParkingData();
            List<MonthlyData> yearData = parkingDataByYear.get(year);

            if (yearData == null) {
                log.warn("해당 년도 데이터 없음: {}", year);
                return new HashMap<>();
            }

            Map<String, Object> response = new HashMap<>();

            if (month == null) {
                // 월별 누적
                calculateMonthlyCumulative(yearData, includeMembership, response);
                response.put("title", year + "년 누적 매출 현황");
            } else {
                // 일별 누적
                calculateDailyCumulative(year, month, yearData, includeMembership, response);
                response.put("title", month + "월 일별 누적 매출 현황");
            }

            return response;
        }

        /**
         * 월별 누적 계산
         */
        private void calculateMonthlyCumulative(List<MonthlyData> yearData, boolean includeMembership, Map<String, Object> response) {
            List<String> categories = new ArrayList<>();
            List<Integer> cumNormal = new ArrayList<>();
            List<Integer> cumMember = new ArrayList<>();

            int runningNormal = 0;
            int runningMember = 0;

            for (MonthlyData monthData : yearData) {
                categories.add(monthData.getMonth() + "월");

                int normalSum = 0;
                int memberSum = 0;

                for (ParkingHistoryDTO record : monthData.getRecords()) {
                    if (record.isMember()) {
                        memberSum += MEMBERSHIP_PRICE;
                    } else {
                        normalSum += calculateFee(record);
                    }
                }

                runningNormal += normalSum;
                runningMember += memberSum;

                cumNormal.add(runningNormal);
                cumMember.add(runningMember);
            }

            response.put("categories", categories);
            response.put("cumulativeNormal", cumNormal);
            response.put("cumulativeMember", cumMember);
            response.put("includeMembership", includeMembership);
        }

        /**
         * 일별 누적 계산
         */
        private void calculateDailyCumulative(int year, int month, List<MonthlyData> yearData, boolean includeMembership, Map<String, Object> response) {
            MonthlyData monthData = yearData.stream()
                    .filter(m -> m.getMonth() == month)
                    .findFirst()
                    .orElse(null);

            if (monthData == null) {
                log.warn("해당 월 데이터 없음: {}월", month);
                return;
            }

            int daysInMonth = LocalDate.of(year, month, 1).lengthOfMonth();
            List<String> categories = new ArrayList<>();
            int[] dailyNormal = new int[daysInMonth];
            int[] dailyMember = new int[daysInMonth];

            // 일별 매출 계산
            for (int i = 1; i <= daysInMonth; i++) {
                categories.add(i + "일");
            }

            for (ParkingHistoryDTO record : monthData.getRecords()) {
                int day = extractDay(record.getEntryTime());
                if (day >= 1 && day <= daysInMonth) {
                    if (record.isMember()) {
                        dailyMember[day - 1] += MEMBERSHIP_PRICE;
                    } else {
                        dailyNormal[day - 1] += calculateFee(record);
                    }
                }
            }

            // 누적 계산
            List<Integer> cumNormal = new ArrayList<>();
            List<Integer> cumMember = new ArrayList<>();
            int runningNormal = 0;
            int runningMember = 0;

            for (int i = 0; i < daysInMonth; i++) {
                runningNormal += dailyNormal[i];
                runningMember += dailyMember[i];
                cumNormal.add(runningNormal);
                cumMember.add(runningMember);
            }

            response.put("categories", categories);
            response.put("cumulativeNormal", cumNormal);
            response.put("cumulativeMember", cumMember);
            response.put("includeMembership", includeMembership);
        }

        /**
         * 3. 차종별 통계 (파이 차트)
         * JSP의 drawCarTypePie 함수 로직
         *
         * @param year 조회 년도
         * @param month 조회 월 (null이면 전체)
         * @return 파이 차트용 데이터
         */
        public Map<String, Object> getCarTypeStats(int year, Integer month) {
            log.info("차종별 통계 조회: year={}, month={}", year, month);

            Map<Integer, List<MonthlyData>> parkingDataByYear = getCachedParkingData();
            List<MonthlyData> yearData = parkingDataByYear.get(year);

            if (yearData == null) {
                log.warn("해당 년도 데이터 없음: {}", year);
                return new HashMap<>();
            }

            List<ParkingHistoryDTO> records = new ArrayList<>();

            if (month == null) {
                // 전체 월
                for (MonthlyData monthData : yearData) {
                    records.addAll(monthData.getRecords());
                }
            } else {
                // 특정 월
                MonthlyData monthData = yearData.stream()
                        .filter(m -> m.getMonth() == month)
                        .findFirst()
                        .orElse(null);

                if (monthData != null) {
                    records.addAll(monthData.getRecords());
                }
            }

            // 차종별 카운트
            Map<String, Integer> countMap = new HashMap<>();
            for (ParkingHistoryDTO record : records) {
                String carType = record.getCarType();
                countMap.put(carType, countMap.getOrDefault(carType, 0) + 1);
            }

            int total = records.size();
            List<Map<String, Object>> pieData = new ArrayList<>();

            for (Map.Entry<String, Integer> entry : countMap.entrySet()) {
                Map<String, Object> data = new HashMap<>();
                data.put("name", entry.getKey());
                data.put("y", entry.getValue());
                data.put("percentage", total > 0 ? String.format("%.1f", (entry.getValue() * 100.0 / total)) : "0.0");
                pieData.add(data);
            }

            Map<String, Object> response = new HashMap<>();
            response.put("data", pieData);
            response.put("total", total);

            log.info("차종별 통계: 총 {}대", total);
            return response;
        }

        /**
         * 4. 피크 시간대 분석
         * JSP의 drawPeakTimeChart 함수 로직
         *
         * @return 시간대별 입차 대수
         */
        public Map<String, Object> getPeakTimeStats() {
            log.info("피크 시간대 분석 조회");

            Map<Integer, List<MonthlyData>> parkingDataByYear = getCachedParkingData();
            int[] hourlyCount = new int[24];

            // 모든 데이터 순회
            for (List<MonthlyData> yearData : parkingDataByYear.values()) {
                for (MonthlyData monthData : yearData) {
                    for (ParkingHistoryDTO record : monthData.getRecords()) {
                        int hour = extractHour(record.getEntryTime());
                        if (hour >= 0 && hour < 24) {
                            hourlyCount[hour]++;
                        }
                    }
                }
            }

            List<String> categories = new ArrayList<>();
            for (int i = 0; i < 24; i++) {
                categories.add(i + "시");
            }

            Map<String, Object> response = new HashMap<>();
            response.put("categories", categories);
            response.put("hourlyCount", toList(hourlyCount));

            log.info("피크 시간대 분석 완료");
            return response;
        }

        /**
         * 5. 오늘 요약 통계 (계산 포함 버전)
         * JSP의 updateSummary 함수 로직
         *
         */
        public Map<String, Object> getTodaySummaryCalculated() {
            log.info("오늘 요약 통계 조회 (계산 포함)");

            LocalDate today = LocalDate.now();

            Map<Integer, List<MonthlyData>> parkingDataByYear = getCachedParkingData();

            int dailySales = 0;
            int dailyCount = 0;
            int totalCount = 0;

            // 전체 데이터 순회
            for (List<MonthlyData> yearData : parkingDataByYear.values()) {
                for (MonthlyData monthData : yearData) {
                    for (ParkingHistoryDTO record : monthData.getRecords()) {
                        totalCount++;

                        // 오늘 날짜 데이터만 처리
                        if (record.getEntryTime().toLocalDate().equals(today)) {
                            dailyCount++;

                            // 비회원만 매출 계산 (회원은 이미 회원권 결제)
                            if (!record.isMember()) {
                                dailySales += calculateFee(record);
                            }
                        }
                    }
                }
            }

            Map<String, Object> summary = new HashMap<>();
            summary.put("dailySales", dailySales);
            summary.put("dailyCount", dailyCount);
            summary.put("totalCount", totalCount);

            log.info("오늘 요약: 입차 {}대, 매출 {}원, 누적 {}대", dailyCount, dailySales, totalCount);
            return summary;
        }

        // ========================================================
        // 유틸리티 메서드들
        // ========================================================

        /*
         * LocalDateTime에서 일(day) 추출
         */
        private int extractDay(LocalDateTime datetime) {
            return datetime.getDayOfMonth();
        }

        /*
         * LocalDateTime에서 시간(hour) 추출
         */
        private int extractHour(LocalDateTime datetime) {
            return datetime.getHour();
        }

        /*
         * int 배열을 List<Integer>로 변환
         */
        private List<Integer> toList(int[] array) {
            List<Integer> list = new ArrayList<>();
            for (int value : array) {
                list.add(value);
            }
            return list;
        }
    }