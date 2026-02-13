<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>통계 | 스마트 주차 관리 시스템</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="statistic3.css">
</head>
<body>

<div class="container">
    <%@ include file="../common/header_other.jsp" %>

    <div class="content">
        <div class="info-box">

            <form action="/statistic" method="get">
                <div class="filter-container">
                    <div class="filter-row">
                        <label>통계 유형</label>
                        <select name="type" onchange="this.form.submit()">
                            <option value="monthly_sales" ${param.type == 'monthly_sales' ? 'selected' : ''}>
                                년도 / 월별 매출
                            </option>
                            <option value="cumulative_sales" ${param.type == 'cumulative_sales' ? 'selected' : ''}>
                                누적 매출
                            </option>
                            <option value="car_type_pie" ${param.type == 'car_type_pie' ? 'selected' : ''}>
                                차종별 통계
                            </option>
                            <option value="peak_time" ${param.type == 'peak_time' ? 'selected' : ''}>
                                피크 시간대
                            </option>
                            <option value="member_stats" ${param.type == 'member_stats' ? 'selected' : ''}>
                                회원 통계
                            </option>
                        </select>
                    </div>

                    <div class="filter-row">
                        <label>상세 조건</label>
                        <select name="year" onchange="this.form.submit()">
                            <option value="2024" ${param.year == '2024' ? 'selected' : ''}>2024년</option>
                            <option value="2025" ${param.year == '2025' ? 'selected' : ''}>2025년</option>
                            <option value="2026" ${param.year == '2026' ? 'selected' : ''}>2026년</option>
                        </select>

                        <select name="month" onchange="this.form.submit()">
                            <option value="all" ${param.month == 'all' ? 'selected' : ''}>전체</option>
                            <option value="1" ${param.month == '1' ? 'selected' : ''}>1월</option>
                            <option value="2" ${param.month == '2' ? 'selected' : ''}>2월</option>
                            <option value="3" ${param.month == '3' ? 'selected' : ''}>3월</option>
                            <option value="4" ${param.month == '4' ? 'selected' : ''}>4월</option>
                            <option value="5" ${param.month == '5' ? 'selected' : ''}>5월</option>
                            <option value="6" ${param.month == '6' ? 'selected' : ''}>6월</option>
                            <option value="7" ${param.month == '7' ? 'selected' : ''}>7월</option>
                            <option value="8" ${param.month == '8' ? 'selected' : ''}>8월</option>
                            <option value="9" ${param.month == '9' ? 'selected' : ''}>9월</option>
                            <option value="10" ${param.month == '10' ? 'selected' : ''}>10월</option>
                            <option value="11" ${param.month == '11' ? 'selected' : ''}>11월</option>
                            <option value="12" ${param.month == '12' ? 'selected' : ''}>12월</option>
                        </select>

                        <label>
                            <input type="checkbox" name="includeMembership"
                            ${param.includeMembership == 'true' ? 'checked' : ''}
                                   onchange="this.form.submit()">
                            회원권 매출 포함
                        </label>
                    </div>
                </div>
            </form>

            <!-- 서버에서 완성된 차트 HTML을 받아서 표시 -->
            <div id="chart_container">
                ${chartHtml}
            </div>

        </div>

        <div class="info-box2">
            <div class="section-title">통계 요약</div>
            <div class="summary">
                <div class="summary-box">
                    일일 총 매출액: ${todaySummary.dailySales}원
                </div>
                <div class="summary-box">
                    일일 입차 대수: ${todaySummary.dailyCount}대
                </div>
                <div class="summary-box">
                    누적 차량 대수: ${todaySummary.totalCount}대
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
