<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>통계 | 스마트 주차 관리 시스템</title>
    <link rel="stylesheet" href="statistic.css">
    <style>
        /* info-box 세로 길이 증가 */
        .info-box {
            min-height: 500px;
        }

        /* 회원 통계 summary 스타일 */
        .member-summary {
            display: flex;
            gap: 20px;
            margin-top: 20px;
        }

        .member-summary-box {
            flex: 1;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            font-size: 16px;
            font-weight: 500;
            border: 1px solid #e0e0e0;
        }
    </style>
</head>

<!-- parkingData.js 불러오기 -->
<script src="${pageContext.request.contextPath}/web/statistic/parkingData.js"></script>

<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/exporting.js"></script>
<script src="https://code.highcharts.com/modules/export-data.js"></script>
<script src="https://code.highcharts.com/modules/annotations.js"></script>

<body>

<div class="container">

    <%@ include file="../common/header_statistic.jsp" %> <!-- 헤더 불러오기 -->

    <!-- 콘텐츠 -->
    <div class="content">

        <!-- *** 통합 통계 박스 *** -->
        <div class="info-box">
            <div class="section-title1">통계 분석</div>

            <!-- 통계 유형 선택 -->
            <div class="filter-box">
                <label style="font-weight: bold; margin-right: 10px;">통계 유형:</label>
                <select id="statisticTypeSelect" style="margin-right: 30px;">
                    <option value="monthly_sales">월별 매출</option>
                    <option value="car_type_pie">차종별 통계 (파이차트)</option>
                    <option value="peak_time">피크 시간대 분석</option>
                    <option value="member_stats">회원 통계</option>
                </select>

                <!-- 월별 매출 필터 (기본 표시) -->
                <span id="salesFilters">
                    <select id="yearSelect2"></select>
                    <select id="monthSelect2">
                        <option value="all">전체</option>
                    </select>
                    <label style="margin-left: 20px;">
                        <input type="checkbox" id="membershipCheckbox"> 회원권 매출 추가
                    </label>
                </span>
            </div>

            <!-- 그래프 영역 -->
            <div id="monthly_sales" class="graph_placeholder"></div>
            <div id="pie_chart" class="graph_placeholder" style="display: none;"></div>
            <div id="peak_time_chart" class="graph_placeholder" style="display: none;"></div>

            <!-- 회원 통계 영역 -->
            <div id="member_stats_view" style="display: none;">
                <div class="member-summary">
                    <div class="member-summary-box" id="total-members-box">총 누적 회원수: 계산 중...</div>
                    <div class="member-summary-box" id="active-members-box">활성 회원수: 계산 중...</div>
                    <div class="member-summary-box" id="inactive-members-box">비활성 회원수: 계산 중...</div>
                </div>
            </div>
        </div>

        <!-- 요약 -->
        <div class="info-box">
            <div class="section-title">통계 요약</div>

            <div class="summary">
                <div class="summary-box" id="summary-daily-sales">일일 총 매출액: 계산 중...</div>
                <div class="summary-box" id="summary-daily-count">일일 입차 대수: 계산 중...</div>
                <div class="summary-box" id="summary-total-count">누적 차량 대수: 계산 중...</div>
            </div>
        </div>

    </div>
</div>

<script>
    // ========== 공통 함수 ==========
    function spendingTime(entry, exit) {
        const start = new Date(entry.replace(' ', 'T'));
        const end = new Date(exit.replace(' ', 'T'));
        return Math.ceil((end - start) / (1000 * 60));
    }

    const paymentInfo = {
        basicTime: 60,
        extraTime: 30,
        basicCharge: 2000,
        extraCharge: 1000,
        maxCharge: 15000
    };
    const paymentDiscount = {smallCarDiscount: 0.3, disabledDiscount: 0.5};

    function getAllRecords() {
        const allRecords = [];
        for (const year in parkingDataByYear) {
            parkingDataByYear[year].forEach(monthData => {
                allRecords.push(...monthData.records);
            });
        }
        return allRecords;
    }

    // ========== 월별 매출 관련 함수 ==========
    function populateYearSelect() {
        const yearSelect = document.getElementById('yearSelect2');
        const monthSelect = document.getElementById('monthSelect2');

        yearSelect.innerHTML = '';

        const years = Object.keys(parkingDataByYear).sort((a, b) => b - a);

        years.forEach(year => {
            const option = document.createElement('option');
            option.value = year;
            option.textContent = year + '년';
            yearSelect.appendChild(option);
        });

        monthSelect.innerHTML = '<option value="all">전체</option>';
        for (let i = 1; i <= 12; i++) {
            const option = document.createElement('option');
            option.value = i;
            option.textContent = i + '월';
            monthSelect.appendChild(option);
        }
    }

    function drawMonthlySalesChart(year, month, includeMembership) {
        const yearData = parkingDataByYear[year];

        if (!yearData) {
            document.getElementById('monthly_sales').innerHTML = '<p>선택한 연도의 데이터가 없습니다.</p>';
            return;
        }

        if (month === 'all') {
            drawMonthlyChart(year, yearData, includeMembership);
        } else {
            drawDailyChartForMonth(year, month, yearData, includeMembership);
        }
    }

    function drawMonthlyChart(year, yearData, includeMembership) {
        let monthlySales = [];
        let membershipSales = [];

        for (let monthData of yearData) {
            let monthSum = 0;
            for (let rec of monthData.records) {
                let charge = 0;
                if (rec.is_member !== 1) {
                    const minutes = spendingTime(rec.entry_time, rec.exit_time);
                    if (minutes > 10) {
                        charge = paymentInfo.basicCharge;
                        if (minutes > paymentInfo.basicTime) {
                            let extraUnits = Math.ceil((minutes - paymentInfo.basicTime) / paymentInfo.extraTime);
                            charge += extraUnits * paymentInfo.extraCharge;
                        }
                        if (rec.car_type === "경차") charge *= (1 - paymentDiscount.smallCarDiscount);
                        if (rec.car_type === "장애인") charge *= (1 - paymentDiscount.disabledDiscount);
                        if (charge > paymentInfo.maxCharge) charge = paymentInfo.maxCharge;
                        charge = Math.floor(charge);
                    }
                }
                monthSum += charge;
            }

            monthlySales.push(monthSum);

            const memberCount = monthData.records.filter(r => r.is_member === 1).length;
            membershipSales.push(memberCount * 10000);
        }

        let chartNormalCharge = [];
        let chartMembershipCharge = [];
        let sumNormal = 0;
        let sumMembership = 0;

        for (let i = 0; i < monthlySales.length; i++) {
            sumNormal += monthlySales[i];
            sumMembership += membershipSales[i];
            chartNormalCharge.push(sumNormal);
            chartMembershipCharge.push(sumMembership);
        }

        let totalMonthlySales = monthlySales.map((val, idx) =>
            includeMembership ? val + membershipSales[idx] : val
        );

        let series = [
            {
                type: 'line',
                name: '월별 매출',
                data: totalMonthlySales,
                yAxis: 0,
                color: '#0073e6',
                zIndex: 2
            }
        ];

        if (includeMembership) {
            series.push({
                type: 'column',
                name: '일반 매출 (누적)',
                data: chartNormalCharge,
                yAxis: 1,
                color: '#ffd2a9',
                stack: 'cumulative',
                zIndex: 0
            });
            series.push({
                type: 'column',
                name: '회원권 매출 (누적)',
                data: chartMembershipCharge,
                yAxis: 1,
                color: '#ff6b6b',
                stack: 'cumulative',
                zIndex: 1
            });
        } else {
            series.push({
                type: 'column',
                name: '누적 매출',
                data: chartNormalCharge,
                yAxis: 1,
                color: '#ffd2a9',
                opacity: 0.8,
                zIndex: 0
            });
        }

        Highcharts.chart('monthly_sales', {
            chart: {zoomType: 'xy'},
            title: {text: ''},
            xAxis: {
                categories: yearData.map(d => d.month + '월'),
            },
            yAxis: [
                {
                    title: {text: '월별 매출액 (원)'},
                    labels: {
                        formatter: function () {
                            return this.value.toLocaleString() + '원';
                        }
                    }
                },
                {
                    title: {text: '누적 매출액 (원)'},
                    labels: {
                        formatter: function () {
                            return this.value.toLocaleString() + '원';
                        }
                    },
                    opposite: true
                }
            ],
            tooltip: {shared: true, valueSuffix: ' 원'},
            credits: {enabled: false},
            legend: {enabled: includeMembership},
            plotOptions: {
                column: {
                    stacking: includeMembership ? 'normal' : undefined
                }
            },
            series: series
        });
    }

    function drawDailyChartForMonth(year, month, yearData, includeMembership) {
        const monthData = yearData.find(m => m.month == month);

        if (!monthData) {
            document.getElementById('monthly_sales').innerHTML = '<p>선택한 월의 데이터가 없습니다.</p>';
            return;
        }

        const dailySales = {};

        for (let rec of monthData.records) {
            const date = rec.entry_time.split(' ')[0];
            const day = date.split('-')[2];

            if (!dailySales[day]) {
                dailySales[day] = 0;
            }

            let charge = 0;
            if (rec.is_member !== 1) {
                const minutes = spendingTime(rec.entry_time, rec.exit_time);
                if (minutes > 10) {
                    charge = paymentInfo.basicCharge;
                    if (minutes > paymentInfo.basicTime) {
                        let extraUnits = Math.ceil((minutes - paymentInfo.basicTime) / paymentInfo.extraTime);
                        charge += extraUnits * paymentInfo.extraCharge;
                    }
                    if (rec.car_type === "경차") charge *= (1 - paymentDiscount.smallCarDiscount);
                    if (rec.car_type === "장애인") charge *= (1 - paymentDiscount.disabledDiscount);
                    if (charge > paymentInfo.maxCharge) charge = paymentInfo.maxCharge;
                    charge = Math.floor(charge);
                }
            }
            dailySales[day] += charge;
        }

        if (includeMembership) {
            monthData.records.forEach(rec => {
                if (rec.is_member === 1) {
                    const date = rec.entry_time.split(' ')[0];
                    const day = date.split('-')[2];
                    if (!dailySales[day]) {
                        dailySales[day] = 0;
                    }
                    dailySales[day] += 10000;
                }
            });
        }

        const daysInMonth = new Date(year, month, 0).getDate();
        const categories = [];
        const salesData = [];

        for (let day = 1; day <= daysInMonth; day++) {
            const dayStr = day.toString().padStart(2, '0');
            categories.push(day + '일');
            salesData.push(dailySales[dayStr] || 0);
        }

        Highcharts.chart('monthly_sales', {
            accessibility: {enabled: false},
            chart: {type: 'line'},
            title: {text: ''},
            xAxis: {categories: categories},
            yAxis: {
                title: {text: '매출액 (원)'},
                labels: {
                    formatter: function () {
                        return this.value.toLocaleString() + '원';
                    }
                }
            },
            tooltip: {valueSuffix: ' 원'},
            credits: {enabled: false},
            legend: {enabled: false},
            series: [{
                name: '일별 매출',
                data: salesData,
                color: '#0073e6'
            }]
        });
    }

    // ========== 차종 통계 관련 함수 ==========
    function getCarTypeCountAll() {
        const records = getAllRecords();
        const result = {};
        records.forEach(r => {
            const type = r.car_type;
            result[type] = (result[type] || 0) + 1;
        });
        return result;
    }

    function drawCarTypePieAll() {
        const countMap = getCarTypeCountAll();
        const seriesData = Object.entries(countMap).map(
            ([name, y]) => ({name, y})
        );

        Highcharts.chart('pie_chart', {
            chart: {type: 'pie'},
            title: {text: '차종별 통계'},
            tooltip: {pointFormat: '<b>{point.percentage:.1f}%</b> ({point.y}대)'},
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {enabled: true, format: '{point.name}: {point.y}'}
                }
            },
            credits: {enabled: false},
            series: [{name: '차종', data: seriesData}]
        });
    }

    function drawPeakTimeChart() {
        const records = getAllRecords();
        const hourlyCount = new Array(24).fill(0);

        records.forEach(rec => {
            const time = rec.entry_time.split(' ')[1];
            const hour = parseInt(time.split(':')[0]);
            hourlyCount[hour]++;
        });

        const categories = [];
        for (let i = 0; i < 24; i++) {
            categories.push(i + '시');
        }

        Highcharts.chart('peak_time_chart', {
            accessibility: {enabled: false},
            chart: {type: 'line'},
            title: {text: '피크 시간대 분석'},
            xAxis: {categories: categories},
            yAxis: {
                title: {text: '입차 대수 (대)'},
                labels: {
                    formatter: function () {
                        return this.value + '대';
                    }
                }
            },
            tooltip: {valueSuffix: ' 대'},
            credits: {enabled: false},
            legend: {enabled: false},
            series: [{
                name: '입차 대수',
                data: hourlyCount,
                color: '#0073e6'
            }]
        });
    }

    // ========== 회원 통계 업데이트 ==========
    function updateMemberStats() {
        console.log('회원 통계 업데이트 시작');

        if (!parkingDataByYear) {
            console.error('parkingDataByYear가 정의되지 않았습니다!');
            return;
        }

        const memberSet = new Set();
        const today = new Date();

        for (let y of Object.keys(parkingDataByYear)) {
            const yearData = parkingDataByYear[y];
            for (let monthData of yearData) {
                for (let rec of monthData.records) {
                    if (rec.is_member === 1 && rec.car_number) {
                        memberSet.add(rec.car_number);
                    }
                }
            }
        }

        const totalMembers = memberSet.size;

        // 활성/비활성 회원 구분 (최근 30일 이내 이용 기록이 있으면 활성)
        const thirtyDaysAgo = new Date();
        thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

        const recentMemberSet = new Set();

        for (let y of Object.keys(parkingDataByYear)) {
            const yearData = parkingDataByYear[y];
            for (let monthData of yearData) {
                for (let rec of monthData.records) {
                    if (rec.is_member === 1 && rec.car_number) {
                        const entryDate = new Date(rec.entry_time.replace(' ', 'T'));
                        if (entryDate >= thirtyDaysAgo) {
                            recentMemberSet.add(rec.car_number);
                        }
                    }
                }
            }
        }

        const activeMembers = recentMemberSet.size;
        const inactiveMembers = totalMembers - activeMembers;

        console.log('총 회원:', totalMembers);
        console.log('활성 회원:', activeMembers);
        console.log('비활성 회원:', inactiveMembers);

        // 화면 업데이트
        document.getElementById('total-members-box').textContent = `총 누적 회원수: ${totalMembers.toLocaleString()}명`;
        document.getElementById('active-members-box').textContent = `활성 회원수: ${activeMembers.toLocaleString()}명`;
        document.getElementById('inactive-members-box').textContent = `비활성 회원수: ${inactiveMembers.toLocaleString()}명`;
    }

    // ========== 통계 유형 전환 함수 ==========
    function switchStatisticType(type) {
        // 모든 그래프 숨기기
        document.getElementById('monthly_sales').style.display = 'none';
        document.getElementById('pie_chart').style.display = 'none';
        document.getElementById('peak_time_chart').style.display = 'none';
        document.getElementById('member_stats_view').style.display = 'none';

        // 월별 매출 필터 숨기기/보이기
        const salesFilters = document.getElementById('salesFilters');

        if (type === 'monthly_sales') {
            salesFilters.style.display = 'inline';
            document.getElementById('monthly_sales').style.display = 'block';
            const year = document.getElementById('yearSelect2').value;
            const month = document.getElementById('monthSelect2').value;
            const includeMembership = document.getElementById('membershipCheckbox').checked;
            drawMonthlySalesChart(year, month, includeMembership);
        } else if (type === 'car_type_pie') {
            salesFilters.style.display = 'none';
            document.getElementById('pie_chart').style.display = 'block';
            drawCarTypePieAll();
        } else if (type === 'peak_time') {
            salesFilters.style.display = 'none';
            document.getElementById('peak_time_chart').style.display = 'block';
            drawPeakTimeChart();
        } else if (type === 'member_stats') {
            salesFilters.style.display = 'none';
            document.getElementById('member_stats_view').style.display = 'block';
            updateMemberStats();
        }
    }

    // ========== 통계 요약 업데이트 ==========
    function updateSummary() {
        console.log('updateSummary 시작');

        const today = new Date();
        const todayStr = today.toISOString().slice(0, 10);
        console.log('오늘 날짜:', todayStr);

        let dailySales = 0;
        let dailyCount = 0;
        let totalCount = 0;

        if (!parkingDataByYear) {
            console.error('parkingDataByYear가 정의되지 않았습니다!');
            return;
        }

        for (let y of Object.keys(parkingDataByYear)) {
            const yearData = parkingDataByYear[y];
            for (let monthData of yearData) {
                for (let rec of monthData.records) {
                    totalCount++;

                    if (rec.entry_time.startsWith(todayStr)) {
                        dailyCount++;

                        if (rec.is_member !== 1) {
                            const minutes = spendingTime(rec.entry_time, rec.exit_time);
                            if (minutes > 10) {
                                let charge = paymentInfo.basicCharge;
                                if (minutes > paymentInfo.basicTime) {
                                    let extraUnits = Math.ceil((minutes - paymentInfo.basicTime) / paymentInfo.extraTime);
                                    charge += extraUnits * paymentInfo.extraCharge;
                                }
                                if (rec.car_type === "경차") charge *= (1 - paymentDiscount.smallCarDiscount);
                                if (rec.car_type === "장애인") charge *= (1 - paymentDiscount.disabledDiscount);
                                if (charge > paymentInfo.maxCharge) charge = paymentInfo.maxCharge;
                                charge = Math.floor(charge);
                                dailySales += charge;
                            }
                        }
                    }
                }
            }
        }

        console.log('일일 매출:', dailySales);
        console.log('일일 입차:', dailyCount);
        console.log('누적 차량:', totalCount);

        // ID로 직접 업데이트
        document.getElementById('summary-daily-sales').textContent = `일일 총 매출액: ${dailySales.toLocaleString()}원`;
        document.getElementById('summary-daily-count').textContent = `일일 입차 대수: ${dailyCount}대`;
        document.getElementById('summary-total-count').textContent = `누적 차량 대수: ${totalCount}대`;

        console.log('updateSummary 완료');
    }

    // 페이지 로드 후 모든 초기화 실행
    window.addEventListener('load', function() {
        console.log('페이지 로드 완료');

        // 1. 연도/월 선택 옵션 생성
        populateYearSelect();

        // 2. 초기 차트 그리기
        const currentYear = document.getElementById('yearSelect2').value;
        const currentMonth = document.getElementById('monthSelect2').value;
        const includeMembership = document.getElementById('membershipCheckbox').checked;
        drawMonthlySalesChart(currentYear, currentMonth, includeMembership);

        // 3. 통계 요약 업데이트
        updateSummary();

        // 4. 회원 통계 미리 계산 (선택 시 바로 표시하기 위해)
        updateMemberStats();
    });

    // 통계 유형 변경 이벤트
    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('statisticTypeSelect').addEventListener('change', function() {
            switchStatisticType(this.value);
        });

        // 월별 매출 필터 변경 이벤트
        document.getElementById('yearSelect2').addEventListener('change', function () {
            const month = document.getElementById('monthSelect2').value;
            const includeMembership = document.getElementById('membershipCheckbox').checked;
            drawMonthlySalesChart(this.value, month, includeMembership);
        });

        document.getElementById('monthSelect2').addEventListener('change', function () {
            const year = document.getElementById('yearSelect2').value;
            const includeMembership = document.getElementById('membershipCheckbox').checked;
            drawMonthlySalesChart(year, this.value, includeMembership);
        });

        document.getElementById('membershipCheckbox').addEventListener('change', function () {
            const year = document.getElementById('yearSelect2').value;
            const month = document.getElementById('monthSelect2').value;
            drawMonthlySalesChart(year, month, this.checked);
        });
    });

</script>

</body>
</html>