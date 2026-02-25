package com.example.smartparkingsystem.service;

import com.example.smartparkingsystem.service.statistic.StatisticService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

class StatisticServiceTest {

    private StatisticService service;
    private final int currentYear = LocalDate.now().getYear();
    private final int currentMonth = LocalDate.now().getMonthValue();

    @BeforeEach
    void setUp() {
        service = StatisticService.INSTANCE;
    }

    // ========================================
    // 1. 오늘 요약 통계
    // ========================================

    @Test
    @DisplayName("오늘 요약 통계 조회")
    void testGetTodaySummary() {
        Map<String, Object> summary = service.getTodaySummary();

        assertNotNull(summary);
        assertTrue(summary.containsKey("dailySales"));
        assertTrue(summary.containsKey("dailyCount"));
        assertTrue(summary.containsKey("totalCount"));

        int dailySales = (int) summary.get("dailySales");
        int dailyCount = (int) summary.get("dailyCount");
        int totalCount = (int) summary.get("totalCount");

        assertTrue(dailySales >= 0);
        assertTrue(dailyCount >= 0);
        assertTrue(totalCount >= 0);
        assertTrue(totalCount >= dailyCount, "누적 대수는 오늘 입차보다 크거나 같아야 함");

        System.out.println("=== 오늘 요약 ===");
        System.out.println("일일 매출: " + dailySales + "원");
        System.out.println("일일 입차: " + dailyCount + "대");
        System.out.println("누적 대수: " + totalCount + "대");
    }

    // ========================================
    // 2. 회원 통계
    // ========================================

    @Test
    @DisplayName("회원 통계 - 특정 월 조회")
    void testGetMemberStats_Monthly() {
        Map<String, Object> result = service.getMemberStats(currentYear, currentMonth);

        assertNotNull(result);
        assertTrue(result.containsKey("totalCount"));
        assertTrue(result.containsKey("activeCount"));
        assertTrue(result.containsKey("inactiveCount"));
        assertTrue(result.containsKey("nonMemberUsageCount"));

        int totalCount = (int) result.get("totalCount");
        int activeCount = (int) result.get("activeCount");
        int inactiveCount = (int) result.get("inactiveCount");
        int nonMemberUsageCount = (int) result.get("nonMemberUsageCount");

        assertEquals(totalCount, activeCount + inactiveCount, "전체 = 활성 + 비활성");
        assertTrue(totalCount >= 0);
        assertTrue(activeCount >= 0);
        assertTrue(inactiveCount >= 0);
        assertTrue(nonMemberUsageCount >= 0);

        System.out.println("=== 회원 통계 (" + currentYear + "년 " + currentMonth + "월) ===");
        System.out.println("총 회원: " + totalCount + "명");
        System.out.println("활성 회원: " + activeCount + "명");
        System.out.println("비활성 회원: " + inactiveCount + "명");
        System.out.println("비회원 이용: " + nonMemberUsageCount + "건");
    }

    @Test
    @DisplayName("회원 통계 - 연도 전체 조회")
    void testGetMemberStats_Yearly() {
        Map<String, Object> result = service.getMemberStats(currentYear, null);

        assertNotNull(result);
        int totalCount = (int) result.get("totalCount");
        int activeCount = (int) result.get("activeCount");
        int inactiveCount = (int) result.get("inactiveCount");

        assertEquals(totalCount, activeCount + inactiveCount, "전체 = 활성 + 비활성");

        System.out.println("=== 회원 통계 (" + currentYear + "년 전체) ===");
        System.out.println("총 회원: " + totalCount + "명");
        System.out.println("활성 회원: " + activeCount + "명");
        System.out.println("비활성 회원: " + inactiveCount + "명");
    }

    // ========================================
    // 3. 월별 매출 통계
    // ========================================

    @Test
    @DisplayName("월별 매출 - 연도 전체 조회 (회원권 포함)")
    void testGetMonthlySales_YearlyWithMembership() {
        Map<String, Object> result = service.getMonthlySales(currentYear, null, true);

        assertNotNull(result);

        if (!result.isEmpty()) {
            List<String> categories = (List<String>) result.get("categories");
            List<Integer> normalSales = (List<Integer>) result.get("normalSales");
            List<Integer> memberSales = (List<Integer>) result.get("memberSales");

            assertEquals(categories.size(), normalSales.size());
            assertEquals(categories.size(), memberSales.size());
            assertTrue((boolean) result.get("includeMembership"));
            normalSales.forEach(v -> assertTrue(v >= 0));
            memberSales.forEach(v -> assertTrue(v >= 0));

            System.out.println("=== " + currentYear + "년 월별 매출 (회원권 포함) ===");
            for (int i = 0; i < categories.size(); i++) {
                System.out.printf("%s - 일반: %d원, 회원: %d원%n",
                        categories.get(i), normalSales.get(i), memberSales.get(i));
            }
        } else {
            System.out.println(currentYear + "년 데이터 없음");
        }
    }

    @Test
    @DisplayName("월별 매출 - 연도 전체 조회 (회원권 미포함)")
    void testGetMonthlySales_YearlyWithoutMembership() {
        Map<String, Object> result = service.getMonthlySales(currentYear, null, false);

        assertNotNull(result);

        if (!result.isEmpty()) {
            assertFalse((boolean) result.get("includeMembership"));
            List<Integer> normalSales = (List<Integer>) result.get("normalSales");
            normalSales.forEach(v -> assertTrue(v >= 0));

            List<String> categories = (List<String>) result.get("categories");
            System.out.println("=== " + currentYear + "년 월별 매출 (회원권 미포함) ===");
            for (int i = 0; i < categories.size(); i++) {
                System.out.printf("%s - 일반: %d원%n", categories.get(i), normalSales.get(i));
            }
        }
    }

    @Test
    @DisplayName("월별 매출 - 특정 월 일별 조회")
    void testGetMonthlySales_Daily() {
        Map<String, Object> result = service.getMonthlySales(currentYear, currentMonth, true);

        assertNotNull(result);

        if (!result.isEmpty()) {
            List<String> categories = (List<String>) result.get("categories");
            List<Integer> normalSales = (List<Integer>) result.get("normalSales");
            List<Integer> memberSales = (List<Integer>) result.get("memberSales");

            assertTrue(categories.size() >= 28 && categories.size() <= 31, "일별 데이터는 28~31개");
            assertEquals(categories.size(), normalSales.size());
            assertEquals(categories.size(), memberSales.size());

            System.out.println("=== " + currentYear + "년 " + currentMonth + "월 일별 매출 ===");
            for (int i = 0; i < Math.min(5, categories.size()); i++) {
                System.out.printf("%s - 일반: %d원, 회원: %d원%n",
                        categories.get(i), normalSales.get(i), memberSales.get(i));
            }
            System.out.println("... (총 " + categories.size() + "일)");
        }
    }

    @Test
    @DisplayName("월별 매출 - 존재하지 않는 년도")
    void testGetMonthlySales_InvalidYear() {
        Map<String, Object> result = service.getMonthlySales(1999, null, true);

        assertNotNull(result);
        assertTrue(result.isEmpty(), "존재하지 않는 년도는 빈 결과");

        System.out.println("존재하지 않는 년도 테스트 통과");
    }

    // ========================================
    // 4. 누적 매출 통계
    // ========================================

    @Test
    @DisplayName("누적 매출 - 연도 전체 조회")
    void testGetCumulativeSales_Yearly() {
        Map<String, Object> result = service.getCumulativeSales(currentYear, null, true);

        assertNotNull(result);

        if (!result.isEmpty()) {
            assertTrue(result.containsKey("title"));
            List<Integer> cumNormal = (List<Integer>) result.get("cumulativeNormal");
            List<Integer> cumMember = (List<Integer>) result.get("cumulativeMember");

            for (int i = 1; i < cumNormal.size(); i++) {
                assertTrue(cumNormal.get(i) >= cumNormal.get(i - 1), "누적 매출은 감소하면 안됨");
            }

            System.out.println("=== " + result.get("title") + " ===");
            List<String> categories = (List<String>) result.get("categories");
            for (int i = 0; i < categories.size(); i++) {
                System.out.printf("%s - 일반 누적: %d원, 회원 누적: %d원%n",
                        categories.get(i), cumNormal.get(i), cumMember.get(i));
            }
        }
    }

    @Test
    @DisplayName("누적 매출 - 특정 월 일별 조회")
    void testGetCumulativeSales_Daily() {
        Map<String, Object> result = service.getCumulativeSales(currentYear, currentMonth, true);

        assertNotNull(result);

        if (!result.isEmpty()) {
            List<Integer> cumNormal = (List<Integer>) result.get("cumulativeNormal");

            for (int i = 1; i < cumNormal.size(); i++) {
                assertTrue(cumNormal.get(i) >= cumNormal.get(i - 1), "누적 매출은 감소하면 안됨");
            }

            System.out.println("=== " + result.get("title") + " ===");
            System.out.println("일별 누적 데이터 수: " + cumNormal.size());
        }
    }

    // ========================================
    // 5. 차종별 통계
    // ========================================

    @Test
    @DisplayName("차종별 통계 - 연도 전체 조회")
    void testGetCarTypeStats_Yearly() {
        Map<String, Object> result = service.getCarTypeStats(currentYear, null);

        assertNotNull(result);
        assertTrue(result.containsKey("data"));
        assertTrue(result.containsKey("total"));

        List<Map<String, Object>> pieData = (List<Map<String, Object>>) result.get("data");
        int total = (int) result.get("total");

        int sum = 0;
        for (Map<String, Object> data : pieData) {
            assertTrue(data.containsKey("name"));
            assertTrue(data.containsKey("y"));
            assertTrue(data.containsKey("percentage"));
            sum += (int) data.get("y");
        }
        assertEquals(total, sum, "전체 합계가 일치해야 함");

        System.out.println("=== " + currentYear + "년 차종별 통계 ===");
        System.out.println("총 대수: " + total);
        for (Map<String, Object> data : pieData) {
            System.out.printf("%s: %d대 (%s%%)%n", data.get("name"), data.get("y"), data.get("percentage"));
        }
    }

    @Test
    @DisplayName("차종별 통계 - 특정 월 조회")
    void testGetCarTypeStats_Monthly() {
        Map<String, Object> result = service.getCarTypeStats(currentYear, currentMonth);

        assertNotNull(result);
        assertTrue(result.containsKey("data"));
        assertTrue(result.containsKey("total"));
        assertTrue((int) result.get("total") >= 0);

        System.out.println("=== " + currentYear + "년 " + currentMonth + "월 차종별 통계 ===");
        System.out.println("총 대수: " + result.get("total"));
    }

    // ========================================
    // 6. 피크 시간대 분석
    // ========================================

    @Test
    @DisplayName("피크 시간대 - 특정 월 조회")
    void testGetPeakTimeStats_Monthly() {
        Map<String, Object> result = service.getPeakTimeStats(currentYear, currentMonth);

        assertNotNull(result);
        assertTrue(result.containsKey("categories"));
        assertTrue(result.containsKey("hourlyCount"));

        List<String> categories = (List<String>) result.get("categories");
        List<Integer> hourlyCount = (List<Integer>) result.get("hourlyCount");

        assertEquals(24, categories.size(), "24시간 카테고리");
        assertEquals(24, hourlyCount.size(), "24시간 카운트");
        hourlyCount.forEach(v -> assertTrue(v >= 0));

        int maxCount = Collections.max(hourlyCount);
        int peakHour = hourlyCount.indexOf(maxCount);

        System.out.println("=== 피크 시간대 (" + currentYear + "년 " + currentMonth + "월) ===");
        System.out.println("피크 시간: " + peakHour + "시 (" + maxCount + "대)");
    }

    @Test
    @DisplayName("피크 시간대 - 연도 전체 조회")
    void testGetPeakTimeStats_Yearly() {
        Map<String, Object> result = service.getPeakTimeStats(currentYear, null);

        assertNotNull(result);

        List<String> categories = (List<String>) result.get("categories");
        List<Integer> hourlyCount = (List<Integer>) result.get("hourlyCount");

        assertEquals(24, categories.size());
        assertEquals(24, hourlyCount.size());

        System.out.println("=== 피크 시간대 (" + currentYear + "년 전체) ===");
        for (int i = 0; i < 24; i++) {
            if (hourlyCount.get(i) > 0) {
                System.out.printf("%s: %d대%n", categories.get(i), hourlyCount.get(i));
            }
        }
    }
}