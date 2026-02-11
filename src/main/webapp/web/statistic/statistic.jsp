<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <!-- Pretendard 폰트 -->
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
    <title>통계 | 스마트 주차 관리 시스템</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="statistic.css">
</head>

<script src="${pageContext.request.contextPath}/web/statistic/parkingData.js"></script>
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/exporting.js"></script>
<script src="https://code.highcharts.com/modules/export-data.js"></script>
<script src="https://code.highcharts.com/modules/annotations.js"></script>

<body>
<div class="page-wrap">
    <%@ include file="../common/header_other.jsp" %>

    <div class="content">

        <!-- 일별 매출 -->
        <div class="info-box">
            <div class="section-title1">일별 매출 선 그래프</div>

            <div class="filter-box">
                <select id="yearSelect"></select>
                <select id="monthSelect"></select>
            </div>

            <div id="daily-sales" class="graph_placeholder">
                <script>
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

                    function populateDailySelects() {
                        const yearSelect = document.getElementById('yearSelect');
                        const monthSelect = document.getElementById('monthSelect');
                        yearSelect.innerHTML = '';
                        monthSelect.innerHTML = '';

                        const years = Object.keys(parkingDataByYear).sort((a, b) => b - a);
                        years.forEach(year => {
                            const option = document.createElement('option');
                            option.value = year;
                            option.textContent = year + '년';
                            yearSelect.appendChild(option);
                        });

                        for (let i = 1; i <= 12; i++) {
                            const option = document.createElement('option');
                            option.value = i;
                            option.textContent = i + '월';
                            monthSelect.appendChild(option);
                        }
                    }

                    function drawDailyChart(year, month) {
                        const yearData = parkingDataByYear[year];
                        if (!yearData) {
                            document.getElementById('daily-sales').innerHTML = '<p>선택한 연도의 데이터가 없습니다.</p>';
                            return;
                        }

                        const monthData = yearData.find(m => m.month == month);
                        if (!monthData) {
                            document.getElementById('daily-sales').innerHTML = '<p>선택한 월의 데이터가 없습니다.</p>';
                            return;
                        }

                        const dailySales = {};
                        for (let rec of monthData.records) {
                            const date = rec.entry_time.split(' ')[0];
                            const day = date.split('-')[2];
                            if (!dailySales[day]) dailySales[day] = 0;

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

                        const daysInMonth = new Date(year, month, 0).getDate();
                        const categories = [];
                        const salesData = [];
                        for (let day = 1; day <= daysInMonth; day++) {
                            const dayStr = day.toString().padStart(2, '0');
                            categories.push(day + '일');
                            salesData.push(dailySales[dayStr] || 0);
                        }

                        Highcharts.chart('daily-sales', {
                            accessibility: {enabled: false},
                            chart: {type: 'line'},
                            title: {text: ''},
                            xAxis: {categories: categories},
                            yAxis: {
                                title: {text: '매출액 (원)'},
                                labels: {formatter: function () { return this.value.toLocaleString() + '원'; }}
                            },
                            tooltip: {valueSuffix: ' 원'},
                            credits: {enabled: false},
                            legend: {enabled: false},
                            series: [{name: '일별 매출', data: salesData, color: '#4a76c5'}]
                        });
                    }

                    populateDailySelects();

                    const now = new Date();
                    const nowYear = now.getFullYear();
                    const nowMonth = now.getMonth() + 1;
                    let defaultYear, defaultMonth;

                    if (parkingDataByYear[nowYear]) {
                        const months = parkingDataByYear[nowYear].map(m => m.month);
                        if (months.includes(nowMonth)) {
                            defaultYear = nowYear;
                            defaultMonth = nowMonth;
                        } else {
                            defaultYear = nowYear;
                            defaultMonth = Math.max(...months);
                        }
                    } else {
                        const years = Object.keys(parkingDataByYear).sort((a, b) => b - a);
                        defaultYear = years[0];
                        defaultMonth = Math.max(...parkingDataByYear[defaultYear].map(m => m.month));
                    }

                    document.getElementById('yearSelect').value = defaultYear;
                    document.getElementById('monthSelect').value = defaultMonth;
                    drawDailyChart(defaultYear, defaultMonth);

                    document.getElementById('yearSelect').addEventListener('change', function () {
                        drawDailyChart(this.value, document.getElementById('monthSelect').value);
                    });
                    document.getElementById('monthSelect').addEventListener('change', function () {
                        drawDailyChart(document.getElementById('yearSelect').value, this.value);
                    });
                </script>
            </div>
        </div>

        <!-- 월별 매출 -->
        <div class="info-box">
            <div class="section-title1">월별 매출 바 그래프</div>
            <div class="filter-box">
                <select id="yearSelect2"></select>
            </div>

            <div id="monthly_sales" class="graph_placeholder">
                <script>
                    function populateYearSelect() {
                        const yearSelect = document.getElementById('yearSelect2');
                        yearSelect.innerHTML = '';
                        const years = Object.keys(parkingDataByYear).sort((a, b) => b - a);
                        years.forEach(year => {
                            const option = document.createElement('option');
                            option.value = year;
                            option.textContent = year + '년';
                            yearSelect.appendChild(option);
                        });
                    }

                    function drawChart(year) {
                        const yearData = parkingDataByYear[year];
                        if (!yearData) {
                            document.getElementById('monthly_sales').innerHTML = '<p>선택한 연도의 데이터가 없습니다.</p>';
                            return;
                        }

                        let monthlySales = [];
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
                        }

                        let chartAllCharge = [];
                        let sum = 0;
                        for (let val of monthlySales) {
                            sum += val;
                            chartAllCharge.push(sum);
                        }

                        Highcharts.chart('monthly_sales', {
                            chart: {zoomType: 'xy'},
                            title: {text: ''},
                            xAxis: {categories: yearData.map(d => d.month + '월')},
                            yAxis: [
                                {
                                    title: {text: '월별 매출액 (원)'},
                                    labels: {formatter: function () { return this.value.toLocaleString() + '원'; }}
                                },
                                {
                                    title: {text: '누적 매출액 (원)'},
                                    labels: {formatter: function () { return this.value.toLocaleString() + '원'; }},
                                    opposite: true
                                }
                            ],
                            tooltip: {shared: true, valueSuffix: ' 원'},
                            credits: {enabled: false},
                            legend: {enabled: false},
                            series: [
                                {type: 'line', name: '월별 매출', data: monthlySales, yAxis: 0, color: '#4a76c5', zIndex: 1},
                                {type: 'column', name: '누적 매출', data: chartAllCharge, yAxis: 1, color: '#a8c0e8', opacity: 0.8, zIndex: 0}
                            ]
                        });
                    }

                    populateYearSelect();
                    drawChart(document.getElementById('yearSelect2').value);

                    document.getElementById('yearSelect2').addEventListener('change', function () {
                        drawChart(this.value);
                    });
                </script>
            </div>
        </div>

        <!-- 차종 통계 -->
        <div id="car-type" class="info-box">
            <div class="section-title">차종 통계</div>
            <div class="car-type-section">
                <div id="pie_chart" class="graph-placeholder"></div>
                <div class="right-section">통계 결과</div>
            </div>
        </div>

        <!-- 요약 -->
        <div class="info-box">
            <div class="section-title">통계 요약</div>
            <div class="summary">
                <div class="summary-box">일일 총 매출액 (현재)</div>
                <div class="summary-box">일일 입차 대수</div>
                <div class="summary-box">누적 차량 대수</div>
            </div>
        </div>
    </div>
</div>

<script>
    function getAllRecords() {
        const allRecords = [];
        for (const year in parkingDataByYear) {
            parkingDataByYear[year].forEach(monthData => {
                allRecords.push(...monthData.records);
            });
        }
        return allRecords;
    }

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
        const seriesData = Object.entries(countMap).map(([name, y]) => ({name, y}));
        Highcharts.chart('pie_chart', {
            chart: {type: 'pie'},
            title: {text: ''},
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

    drawCarTypePieAll();
</script>

<script>
    function updateSummary() {
        const today = new Date();
        const todayStr = today.toISOString().slice(0, 10);

        let dailySales = 0;
        let dailyCount = 0;
        let totalCount = 0;

        if (!parkingDataByYear) return;

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

        const summaryBoxes = document.querySelectorAll('.summary-box');
        if (summaryBoxes.length >= 3) {
            summaryBoxes[0].textContent = '일일 총 매출액 (오늘): ' + dailySales.toLocaleString() + '원';
            summaryBoxes[1].textContent = '일일 입차 대수 (오늘): ' + dailyCount + '대';
            summaryBoxes[2].textContent = '누적 차량 대수: ' + totalCount + '대';
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', updateSummary);
    } else {
        updateSummary();
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
