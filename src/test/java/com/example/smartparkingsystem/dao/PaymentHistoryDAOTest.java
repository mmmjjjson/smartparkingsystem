//package com.example.smartparkingsystem.dao;
//
//import com.example.smartparkingsystem.dto.ParkingHistoryDTO;
//import com.example.smartparkingsystem.dto.MonthlyData;
//import com.example.smartparkingsystem.vo.ParkingHistoryVO;
//import org.junit.jupiter.api.*;
//
//import java.time.LocalDate;
//import java.util.List;
//import java.util.Map;
//
//import static org.junit.jupiter.api.Assertions.*;
//
//@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
//class PaymentHistoryDAOTest {
//
//    private PaymentHistoryDAO dao;
//
//    @BeforeEach
//    void setUp() {
//        dao = new PaymentHistoryDAO();
//    }
//
//
//    /* selectGroupedByYearMonth 테스트 */
//    @Test
//    // 연도/월별 그룹화 테스트 - 데이터가 있는 경우
//    void testSelectGroupedByYearMonth_WithData() {
//        // when
//        Map<Integer, List<MonthlyData>> result = dao.selectGroupedByYearMonth();
//
//        // then
//        assertNotNull(result, "결과가 null이면 안됨");
//
//        // 결과 출력
//        System.out.println("=== 그룹화 결과 ===");
//        result.forEach((year, monthlyDataList) -> {
//            System.out.println("Year: " + year);
//            monthlyDataList.forEach(monthlyData -> {
//                System.out.println("  Month: " + monthlyData.getMonth()
//                        + ", Records: " + monthlyData.getRecords().size());
//            });
//        });
//    }
//
//    @Test
//    // 연도/월별 그룹화 테스트 - 데이터 구조 검증
//    void testSelectGroupedByYearMonth_Structure() {
//        // when
//        Map<Integer, List<MonthlyData>> result = dao.selectGroupedByYearMonth();
//
//        // then
//        if (!result.isEmpty()) {
//            // 연도별 데이터 확인
//            result.forEach((year, monthlyDataList) -> {
//                assertTrue(year >= 2000 && year <= 2100, "연도 범위가 올바르지 않음");
//                assertNotNull(monthlyDataList, "월별 데이터 리스트가 null이면 안됨");
//
//                // 월별 데이터 확인
//                monthlyDataList.forEach(monthlyData -> {
//                    assertTrue(monthlyData.getMonth() >= 1 && monthlyData.getMonth() <= 12,
//                            "월 범위가 1~12여야 함");
//                    assertNotNull(monthlyData.getRecords(), "레코드 리스트가 null이면 안됨");
//
//                    // 각 레코드 검증
//                    monthlyData.getRecords().forEach(record -> {
//                        assertNotNull(record.getParkNo(), "parkNo가 null이면 안됨");
//                        assertNotNull(record.getCarNum(), "차량번호가 null이면 안됨");
//                        assertNotNull(record.getEntryTime(), "입차시간이 null이면 안됨");
//                        assertNotNull(record.getExitTime(), "출차시간이 null이면 안됨");
//                        assertTrue(record.getTotalMinutes() >= 0, "주차시간은 0 이상이어야 함");
//                    });
//                });
//            });
//        }
//    }
//
//    @Test
//    // 연도/월별 그룹화 테스트 - 회원/비회원 구분
//    void testSelectGroupedByYearMonth_MemberCheck() {
//        // when
//        Map<Integer, List<MonthlyData>> result = dao.selectGroupedByYearMonth();
//
//        // then
//        int memberCount = 0;
//        int nonMemberCount = 0;
//
//        for (List<MonthlyData> monthlyDataList : result.values()) {
//            for (MonthlyData monthlyData : monthlyDataList) {
//                for (ParkingHistoryDTO record : monthlyData.getRecords()) {
//                    if (record.isMember()) {
//                        memberCount++;
//                    } else {
//                        nonMemberCount++;
//                    }
//                }
//            }
//        }
//
//        System.out.println("회원: " + memberCount + "건, 비회원: " + nonMemberCount + "건");
//        assertTrue(memberCount >= 0 && nonMemberCount >= 0, "회원/비회원 카운트는 0 이상이어야 함");
//    }
//
//    @Test
//    // 연도/월별 그룹화 테스트 - 정렬 순서 확인
//    void testSelectGroupedByYearMonth_OrderCheck() {
//        // when
//        Map<Integer, List<MonthlyData>> result = dao.selectGroupedByYearMonth();
//
//        // then
//        if (result.size() >= 2) {
//            Integer[] years = result.keySet().toArray(new Integer[0]);
//
//            // 연도가 내림차순으로 정렬되어 있는지 확인
//            for (int i = 0; i < years.length - 1; i++) {
//                assertTrue(years[i] >= years[i + 1],
//                        "연도가 내림차순으로 정렬되어야 함");
//            }
//
//            // 각 연도의 월별 데이터도 내림차순인지 확인
//            result.forEach((year, monthlyDataList) -> {
//                if (monthlyDataList.size() >= 2) {
//                    for (int i = 0; i < monthlyDataList.size() - 1; i++) {
//                        assertTrue(monthlyDataList.get(i).getMonth() >= monthlyDataList.get(i + 1).getMonth(),
//                                "월이 내림차순으로 정렬되어야 함");
//                    }
//                }
//            });
//        }
//    }
//
//    @Test
//    // 특정 연도/월 데이터 조회 테스트
//    void testSelectGroupedByYearMonth_SpecificYearMonth() {
//        // when
//        Map<Integer, List<MonthlyData>> result = dao.selectGroupedByYearMonth();
//
//        // then
//        if (!result.isEmpty()) {
//            // 2025년 2월 데이터가 있는지 확인
//            List<MonthlyData> year2025Data = result.get(2025);
//
//            if (year2025Data != null) {
//                MonthlyData february = year2025Data.stream()
//                        .filter(m -> m.getMonth() == 2)
//                        .findFirst()
//                        .orElse(null);
//
//                if (february != null) {
//                    System.out.println("2025년 2월 데이터: " + february.getRecords().size() + "건");
//                    assertFalse(february.getRecords().isEmpty(), "2025년 2월 데이터가 있어야 함");
//                }
//            }
//        }
//    }
//
//
//    /* selectByDate 테스트 */
//
//    @Test
//    // 특정 날짜 데이터 조회 테스트
//    void testSelectByDate() {
//        // given
//        LocalDate testDate = LocalDate.of(2025, 2, 12);  // 오늘 날짜 또는 테스트 날짜
//
//        // when
//        List<ParkingHistoryVO> records = dao.s
//
//        // then
//        System.out.println("조회된 데이터: " + records.size() + "건");
//        records.forEach(record -> {
//            System.out.println("차량번호: " + record.getCarNum()
//                    + ", 입차시간: " + record.getEntryTime());
//
//            // 모든 레코드의 입차 날짜가 testDate와 일치하는지 확인
//            assertEquals(testDate, record.getEntryTime().toLocalDate());
//        });
//    }
//
//    @Test
//    // 오늘 날짜 데이터 조회 테스트
//    void testSelectByDate_Today() {
//        // given
//        LocalDate today = LocalDate.now();
//
//        // when
//        List<ParkingHistoryVO> records = dao.selectByDate(today);
//
//        // then
//        System.out.println("오늘 데이터: " + records.size() + "건");
//        assertNotNull(records);
//    }
//
//
//
//
//
//}