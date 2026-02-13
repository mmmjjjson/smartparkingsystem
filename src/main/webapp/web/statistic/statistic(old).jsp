<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>통계 | 스마트 주차 관리 시스템</title>

    <style>
        /* 기본 설정 */
        * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
        }

        /* 전체 페이지 스타일 */
        body {
          font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
          background-color: #f5f5f5;
          padding: 20px;
        }

        /* 전체 레이아웃 컨테이너 */
        .container {
          max-width: 1400px;
          margin: 0 auto;
          background-color: #fff;
          border-radius: 8px;
          box-shadow: 0 2px 8px rgba(0,0,0,0.1);
          overflow: hidden;
        }

        /* 헤더 */
        .header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          padding: 20px 30px;
          border-bottom: 3px solid #333;
        }

        .header-title {
          font-size: 16px;
          font-weight: bold;
          color: #333;
        }

        /* 메뉴 버튼 영역 */
        .nav-buttons {
          display: flex;
          gap: 10px;
        }

        .nav-btn {
          padding: 8px 16px;
          border: 1px solid #ddd;
          background: #fff;
          cursor: pointer;
        }

        /* 현재 페이지 표시 */
        .nav-btn.active {
          background-color: #4472c4;
          color: #fff;
          border-color: #4472c4;
        }
        /* 로그아웃 버튼 */
        .logout-btn {
          padding: 8px 16px;
          border: 1px solid #ddd;
          background: #fff;
          cursor: pointer;
        }

        /* 콘텐츠 영역 */
        .content {
          padding: 30px;
        }

        /* 섹션 제목 */
        .section-title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 15px;
        }

        .section-title1 {
          font-size: 16px;
          font-weight: bold;
          margin-bottom: 15px;
            width: 500px;
            float: left;
        }

        /* 통계 블록 공통 박스 */
        .info-box {
          border: 1px solid #ddd;
          padding: 20px;
          margin-bottom: 40px;
          background: #fafafa;
        }

        /* 기간 선택 */
        .filter-box {
          display: flex;
          justify-content: flex-end;
          margin-bottom: 15px;
          gap: 10px;
        }

        .filter-box select {
          padding: 6px 10px;
        }

        /* 그래프 영역 */
        .graph_placeholder {
          height: 330px;
          border: 2px dashed #ccc;
          display: flex;
          align-items: center;
          justify-content: center;
          font-weight: bold;
          color: #666;
          background: #fff;
        }

        /* 차종 통계 */
        .car-type-section {
          display: grid;
          grid-template-columns: 2fr 1fr;
          gap: 20px;
        }
        #car-type {
        }
        .right-section {
          border: 2px solid #4472c4;
          padding: 20px;
          border-radius: 4px;
          text-align: center;
        }

        #pie_chart {
            width: 100%;
            height: 260px;   /* 또는 300px */
            float: left;
        }

        /* 요약 */
        .summary {
          display: grid;
          grid-template-columns: repeat(3, 1fr);
          gap: 20px;
        }

        .summary-box {
          border: 1px solid #ddd;
          padding: 20px;
          text-align: center;
          background: #fff;
          font-weight: bold;
            font-size: 14px;
            color: #333;
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

    <!-- 헤더 -->
    <!-- <div class="header">
        <div class="header-title">스마트 주차 관리 시스템</div>

        <div class="nav-buttons">
            <button class="nav-btn">대시보드</button>
            <button class="nav-btn">회원 관리</button>
            <button class="nav-btn">설정 관리</button>
            <button class="nav-btn active">통계</button>
        </div>

        <button class="logout-btn">로그아웃</button>
    </div>
-->


    <%@ include file="../common/header_other.jsp" %>



    <!-- 콘텐츠 -->
    <div class="content">


<!-- *** 일별 매출 *** -->
<div class="info-box">
    <div class="section-title1">일별 매출 선 그래프</div>

    <div class="filter-box">
        <select id="yearSelect">
        </select>
        <select id="monthSelect">
        </select>
    </div>

    <div id="daily-sales" class="graph_placeholder">
        <script>
        // 입차/출차 시간 계산 (공통 함수)
        function spendingTime(entry, exit) {
            const start = new Date(entry.replace(' ', 'T'));
            const end = new Date(exit.replace(' ', 'T'));
            return Math.ceil((end - start) / (1000 * 60));
        }

        // 요금 정책 (공통)
        const paymentInfo = { basicTime: 60, extraTime: 30, basicCharge: 2000, extraCharge: 1000, maxCharge: 15000 };
        const paymentDiscount = { smallCarDiscount: 0.3, disabledDiscount: 0.5 };

// 일별 매출 SELECT 옵션 자동 생성
function populateDailySelects() {
    const yearSelect = document.getElementById('yearSelect');
    const monthSelect = document.getElementById('monthSelect');

    yearSelect.innerHTML = '';
    monthSelect.innerHTML = '';

    // 연도 옵션 생성
    const years = Object.keys(parkingDataByYear).sort((a, b) => b - a);
    years.forEach(year => {
        const option = document.createElement('option');
        option.value = year;
        option.textContent = year + '년';
        yearSelect.appendChild(option);
    });

    // 월 옵션 생성
    for (let i = 1; i <= 12; i++) {
        const option = document.createElement('option');
        option.value = i;
        option.textContent = i + '월';
        monthSelect.appendChild(option);
    }
}

// 일별 매출 차트 그리기
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

    // 일별로 데이터 그룹화
    const dailySales = {};

    for (let rec of monthData.records) {
        const date = rec.entry_time.split(' ')[0]; // "2024-01-03"
        const day = date.split('-')[2]; // "03"

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

    // 해당 월의 일수 구하기
    const daysInMonth = new Date(year, month, 0).getDate();

    // 모든 날짜에 대한 데이터 생성 (데이터 없는 날은 0)
    const categories = [];
    const salesData = [];

    for (let day = 1; day <= daysInMonth; day++) {
        const dayStr = day.toString().padStart(2, '0');
        categories.push(day + '일');
        salesData.push(dailySales[dayStr] || 0);
    }

    Highcharts.chart('daily-sales', {
        accessibility: { enabled: false },
        chart: { type: 'line' },
        title: { text: ''},
        xAxis: {
            categories: categories,
        },
        yAxis: {
            title: { text: '매출액 (원)' },
            labels: { formatter: function() { return this.value.toLocaleString() + '원'; } }
        },
        tooltip: {
            valueSuffix: ' 원',
            valuePrefix: ''
        },
        credits: { // 오른쪽 하단 출처 링크
            enabled: false
        },
        legend: { // 범례 표시 여부
            enabled: false
        },

        series: [{
            name: '일별 매출',
            data: salesData,
            color: '#0073e6'
        }]
    });
}

// 초기 실행
populateDailySelects();

// 현재 날짜로 실행
const now = new Date();
const nowYear = now.getFullYear();
const nowMonth = now.getMonth() + 1;

// 기본값 후보
let defaultYear;
let defaultMonth;

// 현재 연도 데이터가 있는지 확인
if (parkingDataByYear[nowYear]) {
    const months = parkingDataByYear[nowYear].map(m => m.month);

    // 현재 월 데이터가 있으면 사용
    if (months.includes(nowMonth)) {
        defaultYear = nowYear;
        defaultMonth = nowMonth;
    } else {
        // 현재 연도는 있지만 해당 월은 없음 → 가장 최신 월
        defaultYear = nowYear;
        defaultMonth = Math.max(...months);
    }
} else {
    // 현재 연도 자체가 없음 → 전체 데이터 중 최신 연/월
    const years = Object.keys(parkingDataByYear).sort((a, b) => b - a);
    defaultYear = years[0];
    defaultMonth = Math.max(
        ...parkingDataByYear[defaultYear].map(m => m.month)
    );
}

// select 반영
document.getElementById('yearSelect').value = defaultYear;
document.getElementById('monthSelect').value = defaultMonth;

// 초기 차트
drawDailyChart(defaultYear, defaultMonth);

// 현재 년월로 설정
// const now = new Date();
// const currentYear = now.getFullYear();
// const currentMonth = now.getMonth() + 1;

// document.getElementById('yearSelect').value = currentYear;
// document.getElementById('monthSelect').value = currentMonth;



// select 변경 시 차트 업데이트
document.getElementById('yearSelect').addEventListener('change', function() {
    drawDailyChart(this.value, document.getElementById('monthSelect').value);
});

document.getElementById('monthSelect').addEventListener('change', function() {
    drawDailyChart(document.getElementById('yearSelect').value, this.value);
});
        </script>
    </div>
</div>








<!-- *** 월별 매출 *** -->


<div class="info-box">
    <div class="section-title1">월별 매출 바 그래프</div>
    <div class="filter-box">
        <select id="yearSelect2">
        </select>
    </div>

    <div id="monthly_sales" class="graph_placeholder">
        <script>
// 월별 매출 SELECT 옵션 자동 생성
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
        chart: { zoomType: 'xy' },
        title: { text: ''},
        xAxis: {
            categories: yearData.map(d => d.month + '월'),
        },
        yAxis: [
            { title: { text: '월별 매출액 (원)' },
              labels: { formatter: function() { return this.value.toLocaleString() + '원'; } }
            },
            { title: { text: '누적 매출액 (원)' },
              labels: { formatter: function() { return this.value.toLocaleString() + '원'; } },
              opposite: true
            }
        ],
        tooltip: { shared: true, valueSuffix: ' 원' },
        credits: { // 오른쪽 하단 출처 링크
            enabled: false
        },
        // exporting: { // 오른쪽 상단 메뉴 버튼
        //     enabled: false
        // },
        legend: { // 범례 표시 여부
            enabled: false
        },

        series: [
            { type: 'line', name: '월별 매출', data: monthlySales, yAxis: 0, color: '#0073e6', zIndex: 1 },
            { type: 'column', name: '누적 매출', data: chartAllCharge, yAxis: 1, color: '#ffd2a9', opacity: 0.8, zIndex: 0 }
        ]
    });
}

// 초기 실행
populateYearSelect();
drawChart(document.getElementById('yearSelect2').value);

// select 변경 시 차트 업데이트
document.getElementById('yearSelect2').addEventListener('change', function() {
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

        <div class="right-section">
            통계 결과
        </div>
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
// 전체 데이터에서 모든 records 가져오기
function getAllRecords() {
    const allRecords = [];
    for (const year in parkingDataByYear) {
        parkingDataByYear[year].forEach(monthData => {
            allRecords.push(...monthData.records);
        });
    }
    return allRecords;
}

// 차종별 카운트
function getCarTypeCountAll() {
    const records = getAllRecords();
    const result = {};
    records.forEach(r => {
        const type = r.car_type;
        result[type] = (result[type] || 0) + 1;
    });
    return result;
}

// 파이차트
function drawCarTypePieAll() {
    const countMap = getCarTypeCountAll();
    const seriesData = Object.entries(countMap).map(
        ([name, y]) => ({ name, y })
    );

    Highcharts.chart('pie_chart', {
        chart: { type: 'pie' },
        title: { text: `` },
        tooltip: { pointFormat: '<b>{point.percentage:.1f}%</b> ({point.y}대)' },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: { enabled: true, format: '{point.name}: {point.y}' }
            }
        },
        credits: { // 오른쪽 하단 출처 링크
            enabled: false
        },

        series: [{ name: '차종', data: seriesData }]
    });
}

// 최초 실행
drawCarTypePieAll();
</script>

<script>
    // 통계 요약 업데이트 함수
    function updateSummary() {
        console.log('updateSummary 함수 시작');
        console.log('parkingDataByYear:', parkingDataByYear); // 데이터 확인!

        const today = new Date();
        const todayStr = today.toISOString().slice(0,10);

        console.log('오늘 날짜:', todayStr);

        let dailySales = 0;
        let dailyCount = 0;
        let totalCount = 0;

        // parkingDataByYear가 undefined인지 체크
        if (!parkingDataByYear) {
            console.error('parkingDataByYear가 정의되지 않았습니다!');
            return;
        }

        // 전체 연도 순회
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
                                    let extraUnits = Math.ceil((minutes - paymentInfo.basicTime)/paymentInfo.extraTime);
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

        console.log('계산 결과 - dailySales:', dailySales);
        console.log('계산 결과 - dailyCount:', dailyCount);
        console.log('계산 결과 - totalCount:', totalCount);

        const summaryBoxes = document.querySelectorAll('.summary-box');
        console.log('summaryBoxes 개수:', summaryBoxes.length);

        if (summaryBoxes.length >= 3) {
            // 각각 개별적으로 업데이트하면서 에러 체크
            try {
                summaryBoxes[0].textContent = '일일 총 매출액 (오늘): ' + dailySales.toLocaleString() + '원';
                console.log('Box 0 업데이트 완료');
            } catch(e) {
                console.error('Box 0 에러:', e);
            }

            try {
                summaryBoxes[1].textContent = '일일 입차 대수 (오늘): ' + dailyCount + '대';
                console.log('Box 1 업데이트 완료');
            } catch(e) {
                console.error('Box 1 에러:', e);
            }

            try {
                summaryBoxes[2].textContent = '누적 차량 대수: ' + totalCount + '대';
                console.log('Box 2 업데이트 완료');
            } catch(e) {
                console.error('Box 2 에러:', e);
            }

            console.log('화면 업데이트 완료!');
        } else {
            console.error('summary-box를 찾을 수 없습니다!');
        }
    }

    // 페이지 로드 후 실행
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', updateSummary);
    } else {
        // 이미 로드된 경우
        updateSummary();
    }
</script>
