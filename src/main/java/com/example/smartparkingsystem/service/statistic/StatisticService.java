package com.example.smartparkingsystem.service.statistic;

import com.example.smartparkingsystem.dao.member.MembersDAO;
import com.example.smartparkingsystem.dao.main.ParkingHistoryDAO;
import com.example.smartparkingsystem.dao.payment.PaymentHistoryDAO;
import com.example.smartparkingsystem.dao.setting.PaymentInfoDAO;
import com.example.smartparkingsystem.vo.member.MembersVO;
import com.example.smartparkingsystem.vo.main.ParkingHistoryVO;
import com.example.smartparkingsystem.vo.payment.PaymentHistoryVO;
import lombok.extern.log4j.Log4j2;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.*;


@Log4j2
public enum StatisticService {
    INSTANCE;

    private final PaymentHistoryDAO paymentHistoryDAO;
    private final MembersDAO membersDAO;
    private final ParkingHistoryDAO parkingHistoryDAO;
    private final PaymentInfoDAO paymentInfoDAO = new PaymentInfoDAO();

    // ========== 캐시 ==========
    // 결제 테이블 기반 캐시: 월별 매출, 누적 매출, 피크 시간대
    private Map<Integer, Map<Integer, List<PaymentHistoryVO>>> cachedPaymentData = null;

    // 입출차 테이블 기반 캐시: 차종별 통계
    private Map<Integer, Map<Integer, List<ParkingHistoryVO>>> cachedParkingData = null;

    private final int MEMBERSHIP_PRICE_PER_30DAYS = paymentInfoDAO.selectInfo().getMemberCharge();

    StatisticService() {
        paymentHistoryDAO = new PaymentHistoryDAO();
        membersDAO = new MembersDAO();
        parkingHistoryDAO = new ParkingHistoryDAO();
    }

    // ========================================================
    // 이벤트 기반 캐시 갱신 메서드
    // ========================================================

    /**
     * 결제 데이터 변경 시 호출 (결제 완료 시)
     * 해당 연/월 결제 캐시만 갱신
     */
    public void onPaymentDataChanged(int year, int month) {
        log.info("결제 캐시 갱신: {}년 {}월", year, month);
        if (cachedPaymentData == null) {
            cachedPaymentData = new TreeMap<>(Collections.reverseOrder());
        }
        List<PaymentHistoryVO> freshData = paymentHistoryDAO.selectByYearMonth(year, month);
        cachedPaymentData
                .computeIfAbsent(year, k -> new TreeMap<>(Collections.reverseOrder()))
                .put(month, freshData);
    }

    /**
     * 입출차 데이터 변경 시 호출 (입차/출차 시)
     * 해당 연/월 입출차 캐시만 갱신
     */
    public void onParkingDataChanged(int year, int month) {
        log.info("입출차 캐시 갱신: {}년 {}월", year, month);
        if (cachedParkingData == null) {
            cachedParkingData = new TreeMap<>(Collections.reverseOrder());
        }
        List<ParkingHistoryVO> freshData = parkingHistoryDAO.selectByYearMonth(year, month);
        cachedParkingData
                .computeIfAbsent(year, k -> new TreeMap<>(Collections.reverseOrder()))
                .put(month, freshData);
    }

    // ========================================================
    // 캐시 초기화 (최초 조회 시 전체 로드)
    // ========================================================

    private Map<Integer, Map<Integer, List<PaymentHistoryVO>>> getPaymentData() {
        if (cachedPaymentData == null) {
            log.info("결제 캐시 초기화 - 전체 데이터 로드");
            cachedPaymentData = paymentHistoryDAO.selectOrderByYearMonth();
        }
        return cachedPaymentData;
    }

    private Map<Integer, Map<Integer, List<ParkingHistoryVO>>> getParkingData() {
        if (cachedParkingData == null) {
            log.info("입출차 캐시 초기화 - 전체 데이터 로드");
            cachedParkingData = parkingHistoryDAO.selectAllByYearMonth();
        }
        return cachedParkingData;
    }

    // ========================================================
    // 회원권 매출 계산
    // ========================================================

    private int calculateMembershipRevenue(LocalDate startDate, LocalDate endDate) {
        long days = ChronoUnit.DAYS.between(startDate, endDate);
        int periods = (int) Math.ceil(days / 30.0);
        return periods * MEMBERSHIP_PRICE_PER_30DAYS;
    }

    // ========================================================
    // 통계 조회 메서드들
    // ========================================================

    /**
     * 오늘 요약 통계 - 항상 실시간 조회
     */
    public Map<String, Object> getTodaySummary() {
        log.info("오늘 날짜 요약 통계 조회");

        LocalDate today = LocalDate.now();
        List<ParkingHistoryVO> todayRecords = parkingHistoryDAO.selectByDate(today);
        int dailyCount = todayRecords.size();
        int totalCount = parkingHistoryDAO.getTotalCount();
        int dailySales = calculateDailySales(today);

        Map<String, Object> summary = new HashMap<>();
        summary.put("dailySales", dailySales);
        summary.put("dailyCount", dailyCount);
        summary.put("totalCount", totalCount);

        log.info("오늘 요약: 입차 {}대, 매출 {}원, 누적 {}대", dailyCount, dailySales, totalCount);
        return summary;
    }

    private int calculateDailySales(LocalDate date) {
        Map<Integer, Map<Integer, List<PaymentHistoryVO>>> paymentData = getPaymentData();
        int year = date.getYear();
        int month = date.getMonthValue();

        Map<Integer, List<PaymentHistoryVO>> monthMap = paymentData.get(year);
        if (monthMap == null) return 0;

        List<PaymentHistoryVO> records = monthMap.get(month);
        if (records == null) return 0;

        int dailySales = 0;
        for (PaymentHistoryVO record : records) {
            if (record.getEntryTime().toLocalDate().equals(date)) {
                dailySales += record.getFinalCharge();
            }
        }
        return dailySales;
    }

    /**
     * 회원 통계 (AJAX용) - 항상 실시간 조회
     */
    public Map<String, Object> getMemberStats(int year, Integer month) {
        log.info("회원 통계 조회: year={}, month={}", year, month);

        LocalDate periodStart = month != null
                ? LocalDate.of(year, month, 1)
                : LocalDate.of(year, 1, 1);
        LocalDate periodEnd = month != null
                ? LocalDate.of(year, month, periodStart.lengthOfMonth())
                : LocalDate.of(year, 12, 31);

        List<MembersVO> allMembers = membersDAO.selectAllMembers();
        int totalCount = allMembers.size();
        int activeCount = 0;

        for (MembersVO member : allMembers) {
            LocalDate startDate = member.getStartDate();
            LocalDate endDate = member.getEndDate();
            if (!startDate.isAfter(periodEnd) && !endDate.isBefore(periodStart)) {
                activeCount++;
            }
        }

        int inactiveCount = totalCount - activeCount;
        int nonMemberUsageCount = parkingHistoryDAO.getNonMemberCountByPeriod(periodStart, periodEnd);

        Map<String, Object> result = new HashMap<>();
        result.put("totalCount", totalCount);
        result.put("activeCount", activeCount);
        result.put("inactiveCount", inactiveCount);
        result.put("nonMemberUsageCount", nonMemberUsageCount);

        log.info("회원 통계: 총{}명, 활성{}명, 비활성{}명, 비회원이용{}건",
                totalCount, activeCount, inactiveCount, nonMemberUsageCount);
        return result;
    }

    // ========================================================
    // 차트용 통계 메서드들
    // ========================================================

    /**
     * 1. 월별 매출 통계 - 결제 캐시 사용
     */
    public Map<String, Object> getMonthlySales(int year, Integer month, boolean includeMembership) {
        log.info("월별 매출 통계 조회: year={}, month={}, includeMembership={}", year, month, includeMembership);

        Map<Integer, Map<Integer, List<PaymentHistoryVO>>> paymentData = getPaymentData();
        Map<Integer, List<PaymentHistoryVO>> yearMap = paymentData.get(year);

        if (yearMap == null) {
            log.warn("해당 년도 데이터 없음: {}", year);
            return new HashMap<>();
        }

        Map<String, Object> response = new HashMap<>();
        if (month == null) {
            calculateMonthlyAggregation(year, yearMap, includeMembership, response);
        } else {
            calculateDailyAggregation(year, month, yearMap, includeMembership, response);
        }
        return response;
    }

    private void calculateMonthlyAggregation(int year, Map<Integer, List<PaymentHistoryVO>> yearMap,
                                             boolean includeMembership, Map<String, Object> response) {
        List<String> categories = new ArrayList<>();
        List<Integer> normalSales = new ArrayList<>();
        List<Integer> memberSales = new ArrayList<>();

        Map<Integer, Integer> monthlyMembershipRevenue = new HashMap<>();
        if (includeMembership) {
            List<MembersVO> allMembers = membersDAO.selectAllMembers();
            for (MembersVO member : allMembers) {
                if (member.getStartDate().getYear() == year) {
                    int m = member.getStartDate().getMonthValue();
                    int revenue = calculateMembershipRevenue(member.getStartDate(), member.getEndDate());
                    monthlyMembershipRevenue.put(m, monthlyMembershipRevenue.getOrDefault(m, 0) + revenue);
                }
            }
        }

        List<Integer> sortedMonths = new ArrayList<>(yearMap.keySet());
        Collections.sort(sortedMonths);

        for (int m : sortedMonths) {
            categories.add(m + "월");
            List<PaymentHistoryVO> records = yearMap.get(m);

            int normalSum = 0;
            for (PaymentHistoryVO record : records) {
                if (record.getMno() == null) {
                    normalSum += record.getFinalCharge();
                }
            }
            normalSales.add(normalSum);
            memberSales.add(monthlyMembershipRevenue.getOrDefault(m, 0));
        }

        response.put("categories", categories);
        response.put("normalSales", normalSales);
        response.put("memberSales", memberSales);
        response.put("includeMembership", includeMembership);
    }

    private void calculateDailyAggregation(int year, int month, Map<Integer, List<PaymentHistoryVO>> yearMap,
                                           boolean includeMembership, Map<String, Object> response) {
        List<PaymentHistoryVO> records = yearMap.get(month);
        if (records == null) {
            log.warn("해당 월 데이터 없음: {}월", month);
            return;
        }

        int daysInMonth = LocalDate.of(year, month, 1).lengthOfMonth();
        List<String> categories = new ArrayList<>();
        int[] dailyNormal = new int[daysInMonth];
        int[] dailyMember = new int[daysInMonth];

        for (int i = 1; i <= daysInMonth; i++) {
            categories.add(i + "일");
        }

        if (includeMembership) {
            List<MembersVO> allMembers = membersDAO.selectAllMembers();
            for (MembersVO member : allMembers) {
                LocalDate startDate = member.getStartDate();
                if (startDate.getYear() == year && startDate.getMonthValue() == month) {
                    int day = startDate.getDayOfMonth();
                    if (day >= 1 && day <= daysInMonth) {
                        int revenue = calculateMembershipRevenue(member.getStartDate(), member.getEndDate());
                        dailyMember[day - 1] += revenue;
                    }
                }
            }
        }

        for (PaymentHistoryVO record : records) {
            int day = record.getEntryTime().getDayOfMonth();
            if (day >= 1 && day <= daysInMonth && record.getMno() == null) {
                dailyNormal[day - 1] += record.getFinalCharge();
            }
        }

        response.put("categories", categories);
        response.put("normalSales", toList(dailyNormal));
        response.put("memberSales", toList(dailyMember));
        response.put("includeMembership", includeMembership);
    }

    /**
     * 2. 누적 매출 통계 - 결제 캐시 사용
     */
    public Map<String, Object> getCumulativeSales(int year, Integer month, boolean includeMembership) {
        log.info("누적 매출 통계 조회: year={}, month={}, includeMembership={}", year, month, includeMembership);

        Map<Integer, Map<Integer, List<PaymentHistoryVO>>> paymentData = getPaymentData();
        Map<Integer, List<PaymentHistoryVO>> yearMap = paymentData.get(year);

        if (yearMap == null) {
            log.warn("해당 년도 데이터 없음: {}", year);
            return new HashMap<>();
        }

        Map<String, Object> response = new HashMap<>();
        if (month == null) {
            calculateMonthlyCumulative(year, yearMap, includeMembership, response);
            response.put("title", year + "년 누적 매출 현황");
        } else {
            calculateDailyCumulative(year, month, yearMap, includeMembership, response);
            response.put("title", month + "월 일별 누적 매출 현황");
        }
        return response;
    }

    private void calculateMonthlyCumulative(int year, Map<Integer, List<PaymentHistoryVO>> yearMap,
                                            boolean includeMembership, Map<String, Object> response) {
        List<String> categories = new ArrayList<>();
        List<Integer> cumNormal = new ArrayList<>();
        List<Integer> cumMember = new ArrayList<>();
        int runningNormal = 0;
        int runningMember = 0;

        Map<Integer, Integer> monthlyMembershipRevenue = new HashMap<>();
        if (includeMembership) {
            List<MembersVO> allMembers = membersDAO.selectAllMembers();
            for (MembersVO member : allMembers) {
                if (member.getStartDate().getYear() == year) {
                    int m = member.getStartDate().getMonthValue();
                    int revenue = calculateMembershipRevenue(member.getStartDate(), member.getEndDate());
                    monthlyMembershipRevenue.put(m, monthlyMembershipRevenue.getOrDefault(m, 0) + revenue);
                }
            }
        }

        List<Integer> sortedMonths = new ArrayList<>(yearMap.keySet());
        Collections.sort(sortedMonths);

        for (int m : sortedMonths) {
            categories.add(m + "월");
            List<PaymentHistoryVO> records = yearMap.get(m);

            int normalSum = 0;
            for (PaymentHistoryVO record : records) {
                if (record.getMno() == null) {
                    normalSum += record.getFinalCharge();
                }
            }
            runningNormal += normalSum;
            runningMember += monthlyMembershipRevenue.getOrDefault(m, 0);
            cumNormal.add(runningNormal);
            cumMember.add(runningMember);
        }

        response.put("categories", categories);
        response.put("cumulativeNormal", cumNormal);
        response.put("cumulativeMember", cumMember);
        response.put("includeMembership", includeMembership);
    }

    private void calculateDailyCumulative(int year, int month, Map<Integer, List<PaymentHistoryVO>> yearMap,
                                          boolean includeMembership, Map<String, Object> response) {
        List<PaymentHistoryVO> records = yearMap.get(month);
        if (records == null) {
            log.warn("해당 월 데이터 없음: {}월", month);
            return;
        }

        int daysInMonth = LocalDate.of(year, month, 1).lengthOfMonth();
        List<String> categories = new ArrayList<>();
        int[] dailyNormal = new int[daysInMonth];
        int[] dailyMember = new int[daysInMonth];

        for (int i = 1; i <= daysInMonth; i++) {
            categories.add(i + "일");
        }

        if (includeMembership) {
            List<MembersVO> allMembers = membersDAO.selectAllMembers();
            for (MembersVO member : allMembers) {
                LocalDate startDate = member.getStartDate();
                if (startDate.getYear() == year && startDate.getMonthValue() == month) {
                    int day = startDate.getDayOfMonth();
                    if (day >= 1 && day <= daysInMonth) {
                        int revenue = calculateMembershipRevenue(member.getStartDate(), member.getEndDate());
                        dailyMember[day - 1] += revenue;
                    }
                }
            }
        }

        for (PaymentHistoryVO record : records) {
            int day = record.getEntryTime().getDayOfMonth();
            if (day >= 1 && day <= daysInMonth && record.getMno() == null) {
                dailyNormal[day - 1] += record.getFinalCharge();
            }
        }

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
     * 3. 차종별 통계 - 입출차 캐시 사용
     */
    public Map<String, Object> getCarTypeStats(int year, Integer month) {
        log.info("차종별 통계 조회: year={}, month={}", year, month);

        Map<Integer, Map<Integer, List<ParkingHistoryVO>>> parkingData = getParkingData();
        Map<Integer, List<ParkingHistoryVO>> yearMap = parkingData.get(year);

        Map<String, Integer> countMap = new HashMap<>();

        if (yearMap != null) {
            if (month != null) {
                List<ParkingHistoryVO> records = yearMap.get(month);
                if (records != null) {
                    for (ParkingHistoryVO record : records) {
                        String carType = record.getCarType();
                        countMap.put(carType, countMap.getOrDefault(carType, 0) + 1);
                    }
                }
            } else {
                for (List<ParkingHistoryVO> records : yearMap.values()) {
                    for (ParkingHistoryVO record : records) {
                        String carType = record.getCarType();
                        countMap.put(carType, countMap.getOrDefault(carType, 0) + 1);
                    }
                }
            }
        }

        int total = countMap.values().stream().mapToInt(Integer::intValue).sum();
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
     * 4. 피크 시간대 분석 - 결제 캐시 사용
     */
    public Map<String, Object> getPeakTimeStats(int year, Integer month) {
        log.info("피크 시간대 분석 조회: year={}, month={}", year, month);

        Map<Integer, Map<Integer, List<PaymentHistoryVO>>> paymentData = getPaymentData();
        int[] hourlyCount = new int[24];

        Map<Integer, List<PaymentHistoryVO>> yearMap = paymentData.get(year);
        if (yearMap != null) {
            for (Map.Entry<Integer, List<PaymentHistoryVO>> entry : yearMap.entrySet()) {
                if (month != null && !entry.getKey().equals(month)) continue;
                for (PaymentHistoryVO record : entry.getValue()) {
                    int hour = record.getEntryTime().getHour();
                    if (hour >= 0 && hour < 24) hourlyCount[hour]++;
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

    // ===============
    // 유틸리티
    // ===============

    private List<Integer> toList(int[] array) {
        List<Integer> list = new ArrayList<>();
        for (int value : array) {
            list.add(value);
        }
        return list;
    }
}