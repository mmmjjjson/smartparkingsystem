    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="ko">
    <head>
        <meta charset="UTF-8">
        <title>통계 | 스마트 주차 관리 시스템</title>
        <link rel="stylesheet" href="statistic.css">
        <style>
            .info-box { min-height: 500px; padding: 20px; }

            /* 필터 영역 레이아웃 수정 */
            .filter-container {
                display: flex;
                flex-direction: column; /* 세로 배치 */
                gap: 15px;
                margin-bottom: 25px;
                padding: 15px;
                background: #f9f9f9;
                border-radius: 8px;
            }

            .filter-row {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .member-summary { display: flex; gap: 20px; margin-top: 20px; }
            .member-summary-box {
                flex: 1; background: #f8f9fa; padding: 20px;
                border-radius: 8px; text-align: center; font-size: 16px;
                font-weight: 500; border: 1px solid #e0e0e0;
            }
            select, input { padding: 5px; border-radius: 4px; border: 1px solid #ccc; }
        </style>
    </head>

    <script src="${pageContext.request.contextPath}/web/statistic/parkingData.js"></script>
    <%-- 수정(위에거 주석처리) --%>
    <%--<script>const parkingDataByYear = ${parkingDataJson};</script>--%>
    <%--<script>const memberStats = ${memberStatsJson};</script>--%>

    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <script src="https://code.highcharts.com/modules/export-data.js"></script>
    <script src="https://code.highcharts.com/modules/annotations.js"></script>

    <body>

    <div class="container">
<%--        <%@ include file="../common/header_statistic.jsp" %>--%>

        <div class="content">
            <div class="info-box">

                <div class="filter-container">
                    <div class="filter-row">
                        <label style="font-weight: bold; min-width: 80px;">통계 유형</label>
                        <select id="statisticTypeSelect" style="min-width: 200px;">
                            <option value="monthly_sales">년도 / 월별 매출</option>
                            <option value="cumulative_sales">누적 매출</option>
                            <option value="car_type_pie">차종별 통계 (파이차트)</option>
                            <option value="peak_time">피크 시간대 분석</option>
                            <option value="member_stats">회원 통계</option>
                        </select>
                    </div>

                    <div class="filter-row" id="salesFilters">
                        <label style="font-weight: bold; min-width: 80px;">상세 조건</label>
                        <select id="yearSelect2"></select>
                        <select id="monthSelect2">
                            <option value="all">전체</option>
                        </select>
                        <label style="margin-left: 15px; cursor: pointer;">
                            <input type="checkbox" id="membershipCheckbox"> 회원권 매출 포함
                        </label>
                    </div>

                    <div class="filter-row" id="carTypeFilters" style="display: none;">
                        <label style="font-weight: bold; min-width: 80px;">기간 선택</label>
                        <select id="yearSelect3"></select>
                        <select id="monthSelect3">
                            <option value="all">전체</option>
                        </select>
                    </div>
                </div>

                <div id="monthly_sales" class="graph_placeholder"></div>
                <div id="cumulative_sales_chart" class="graph_placeholder" style="display: none;"></div>
                <div id="pie_chart" class="graph_placeholder" style="display: none;"></div>
                <div id="peak_time_chart" class="graph_placeholder" style="display: none;"></div>

                <div id="member_stats_view" style="display: none;">
                    <div class="member-summary">
                        <div class="member-summary-box" id="total-members-box">총 누적 회원수: 계산 중...</div>
                        <div class="member-summary-box" id="active-members-box">활성 회원수: 계산 중...</div>
                        <div class="member-summary-box" id="inactive-members-box">비활성 회원수: 계산 중...</div>
                    </div>
                </div>
            </div>

            <div class="info-box2">
                <div class="section-title">통계 요약</div>
                <div class="summary">
                    <div class="summary-box" id="summary-daily-sales"></div>
                    <div class="summary-box" id="summary-daily-count"></div>
                    <div class="summary-box" id="summary-total-count"></div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // 기존 함수들
        function spendingTime(entry, exit) {
            const start = new Date(entry.replace(' ', 'T'));
            const end = new Date(exit.replace(' ', 'T'));
            return Math.ceil((end - start) / (1000 * 60));
        }

        const paymentInfo = { basicTime: 60, extraTime: 30, basicCharge: 2000, extraCharge: 1000, maxCharge: 15000 };
        const paymentDiscount = { smallCarDiscount: 0.3, disabledDiscount: 0.5 };

        function getAllRecords() {
            const allRecords = [];
            for (const year in parkingDataByYear) {
                parkingDataByYear[year].forEach(monthData => { allRecords.push(...monthData.records); });
            }
            return allRecords;
        }

        function populateYearSelect() {
            const yearSelect = document.getElementById('yearSelect2');
            const monthSelect = document.getElementById('monthSelect2');
            const yearSelect3 = document.getElementById('yearSelect3');
            const monthSelect3 = document.getElementById('monthSelect3');

            if(!yearSelect) return;

            // 현재 날짜 정보 가져오기
            const today = new Date();
            const currentYear = today.getFullYear().toString();
            const currentMonth = (today.getMonth() + 1).toString(); // 0-based이므로 +1

            yearSelect.innerHTML = '';
            yearSelect3.innerHTML = '';

            const years = Object.keys(parkingDataByYear).sort((a, b) => b - a);
            years.forEach(year => {
                const option = document.createElement('option');
                option.value = year;
                option.textContent = year + '년';
                yearSelect.appendChild(option);

                const option3 = document.createElement('option');
                option3.value = year;
                option3.textContent = year + '년';
                yearSelect3.appendChild(option3);
            });

            // 현재 년도를 선택 (데이터에 존재하는 경우)
            if (years.includes(currentYear)) {
                yearSelect.value = currentYear;
                yearSelect3.value = currentYear;
            }

            monthSelect.innerHTML = '<option value="all">전체</option>';
            monthSelect3.innerHTML = '<option value="all">전체</option>';

            for (let i = 1; i <= 12; i++) {
                const option = document.createElement('option');
                option.value = i;
                option.textContent = i + '월';
                monthSelect.appendChild(option);

                const option3 = document.createElement('option');
                option3.value = i;
                option3.textContent = i + '월';
                monthSelect3.appendChild(option3);
            }

            // 현재 월을 선택
            monthSelect.value = currentMonth;
            monthSelect3.value = currentMonth;
        }

        // 매출액 계산 함수 공통화
        function calculateFee(rec) {
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
            return charge;
        }

        // 월별 매출 차트
        function drawMonthlySalesChart(year, month, includeMembership) {
            const yearData = parkingDataByYear[year];
            if (!yearData) return;
            if (month === 'all') drawMonthlyChart(year, yearData, includeMembership);
            else drawDailyChartForMonth(year, month, yearData, includeMembership);
        }

        function drawMonthlyChart(year, yearData, includeMembership) {
            let monthlyNormalSales = [];
            let monthlyMemberSales = [];

            for (let monthData of yearData) {
                let nSum = 0;
                let mSum = 0;
                for (let rec of monthData.records) {
                    if (rec.is_member === 1) mSum += 10000;
                    else nSum += calculateFee(rec);
                }
                monthlyNormalSales.push(nSum);
                monthlyMemberSales.push(mSum);
            }

            let series = [{
                type: 'column',
                name: '일반 매출',
                data: monthlyNormalSales,
                color: '#34A853'
            }];

            if (includeMembership) {
                series.push({
                    type: 'column',
                    name: '회원권 매출',
                    data: monthlyMemberSales,
                    color: '#EA4335'
                });
            }

            Highcharts.chart('monthly_sales', {
                chart: { type: 'column' },
                title: { text: '' },
                xAxis: { categories: yearData.map(d => d.month + '월') },
                yAxis: {
                    title: { text: '매출액 (원)' },
                    labels: { format: '{value:,.0f}원' }
                },
                plotOptions: {
                    column: {
                        stacking: 'normal'
                    }
                },
                tooltip: {
                    shared: true,
                    valueSuffix: '원'
                },
                credits: { enabled: false },
                series: series
            });
        }

        function drawDailyChartForMonth(year, month, yearData, includeMembership) {
            const monthData = yearData.find(m => m.month == month);
            if (!monthData) return;
            const daysInMonth = new Date(year, month, 0).getDate();

            const dailyNormal = new Array(daysInMonth).fill(0);
            const dailyMember = new Array(daysInMonth).fill(0);

            monthData.records.forEach(rec => {
                const day = parseInt(rec.entry_time.split(' ')[0].split('-')[2]);
                if (rec.is_member === 1) {
                    dailyMember[day-1] += 10000;
                } else {
                    dailyNormal[day-1] += calculateFee(rec);
                }
            });

            let series = [{
                name: '일반 매출',
                data: dailyNormal,
                color: '#34A853'
            }];

            if (includeMembership) {
                series.push({
                    name: '회원권 매출',
                    data: dailyMember,
                    color: '#EA4335'
                });
            }

            Highcharts.chart('monthly_sales', {
                chart: { type: 'column' },
                title: { text: '' },
                xAxis: { categories: Array.from({length: daysInMonth}, (_, i) => (i+1) + '일') },
                yAxis: {
                    title: { text: '매출액 (원)' },
                    labels: { format: '{value:,.0f}원' }
                },
                plotOptions: {
                    column: {
                        stacking: 'normal'
                    }
                },
                tooltip: { shared: true, valueSuffix: '원' },
                credits: { enabled: false },
                series: series
            });
        }

        // 누적 매출 차트 컨트롤러
        function drawCumulativeSalesChart(year, month, includeMembership) {
            const yearData = parkingDataByYear[year];
            if (!yearData) return;

            if (month === 'all') drawCumulativeMonthly(year, yearData, includeMembership);
            else drawCumulativeDaily(year, month, yearData, includeMembership);
        }

        // 연간 월별 누적 (1월 ~ 12월)
        function drawCumulativeMonthly(year, yearData, includeMembership) {
            let categories = yearData.map(d => d.month + '월');
            let cumNormal = [];
            let cumMember = [];

            let runningNormal = 0;
            let runningMember = 0;
            yearData.forEach(monthData => {
                let nSum = 0;
                let mSum = 0;
                monthData.records.forEach(rec => {
                    if (rec.is_member === 1) mSum += 10000;
                    else nSum += calculateFee(rec);
                });
                runningNormal += nSum;
                runningMember += mSum;

                cumNormal.push(runningNormal);
                cumMember.push(runningMember);
            });
            renderStackedCumChart('cumulative_sales_chart', categories, cumNormal, cumMember, includeMembership, year + '년 누적 매출 현황');
        }

        // 특정 월의 일별 누적 (1일 ~ 마지막일)
        function drawCumulativeDaily(year, month, yearData, includeMembership) {
            const mData = yearData.find(m => m.month == month);
            if (!mData) return;

            const daysInMonth = new Date(year, month, 0).getDate();
            let categories = Array.from({length: daysInMonth}, (_, i) => (i+1) + '일');

            let dailyNormal = new Array(daysInMonth).fill(0);
            let dailyMember = new Array(daysInMonth).fill(0);

            mData.records.forEach(rec => {
                const day = parseInt(rec.entry_time.split(' ')[0].split('-')[2]);
                if (rec.is_member === 1) dailyMember[day-1] += 10000;
                else dailyNormal[day-1] += calculateFee(rec);
            });

            let cumNormal = [];
            let cumMember = [];
            let rNormal = 0;
            let rMember = 0;
            for(let i=0; i<daysInMonth; i++) {
                rNormal += dailyNormal[i];
                rMember += dailyMember[i];
                cumNormal.push(rNormal);
                cumMember.push(rMember);
            }
            renderStackedCumChart('cumulative_sales_chart', categories, cumNormal, cumMember, includeMembership, month + '월 일별 누적 매출 현황');
        }

        // [공통] 누적 차트 렌더링 함수
        function renderStackedCumChart(targetId, categories, normalData, memberData, includeMem, titleText) {
            let series = [{
                name: '일반 매출(누적)',
                data: normalData,
                color: '#34A853'
            }];
            if (includeMem) {
                series.push({
                    name: '회원권 매출(누적)',
                    data: memberData,
                    color: '#EA4335'
                });
            }
            Highcharts.chart(targetId, {
                chart: { type: 'column' },
                title: { text: titleText },
                xAxis: { categories: categories },
                yAxis: { title: { text: '누적 금액 (원)' }, labels: { format: '{value:,.0f}원' } },
                plotOptions: { column: { stacking: 'normal' } },
                tooltip: {
                    shared: true,
                    valueSuffix: '원',
                    formatter: function() {
                        let total = 0;
                        let tooltipText = '<b>' + this.x + '</b><br/>';

                        this.points.forEach(point => {
                            tooltipText += '<span style="color:' + point.color + '">\u25CF</span> ' +
                                point.series.name + ': <b>' +
                                point.y.toLocaleString() + '원</b><br/>';
                            total += point.y;
                        });

                        if (this.points.length > 1) {
                            tooltipText += '<br/><b>합계: ' + total.toLocaleString() + '원</b>';
                        }

                        return tooltipText;
                    }
                },
                credits: { enabled: false },
                series: series
            });
        }

        // 차종통계
        function drawCarTypePie(year, month) {
            let records = [];

            if (month === 'all') {
                // 해당 연도 전체
                const yearData = parkingDataByYear[year];
                if (yearData) {
                    yearData.forEach(monthData => {
                        records.push(...monthData.records);
                    });
                }
            } else {
                // 특정 월
                const yearData = parkingDataByYear[year];
                if (yearData) {
                    const monthData = yearData.find(m => m.month == month);
                    if (monthData) {
                        records = monthData.records;
                    }
                }
            }

            const countMap = {};
            records.forEach(r => {
                countMap[r.car_type] = (countMap[r.car_type] || 0) + 1;
            });

            const total = records.length;
            const seriesData = Object.entries(countMap).map(([name, y]) => ({
                name: name,
                y: y,
                percentage: ((y / total) * 100).toFixed(1)
            }));

            Highcharts.chart('pie_chart', {
                chart: { type: 'pie' },
                title: { text: '차종별 통계' },
                credits: { enabled: false },
                plotOptions: {
                    pie: {
                        dataLabels: {
                            enabled: true,
                            format: '<b>{point.name}</b><br>{point.y}대 ({point.percentage:.1f}%)',
                            style: {
                                fontSize: '13px'
                            }
                        }
                    }
                },
                tooltip: {
                    enabled: false
                },
                series: [{
                    name: '차종',
                    colorByPoint: true,
                    data: seriesData
                }]
            });
        }

        function drawPeakTimeChart() {
            const hourlyCount = new Array(24).fill(0);
            getAllRecords().forEach(rec => {
                const hour = parseInt(rec.entry_time.split(' ')[1].split(':')[0]);
                hourlyCount[hour]++;
            });

            Highcharts.chart('peak_time_chart', {
                chart: {type: 'line'},
                title: {text: '피크 시간대 분석'},
                xAxis: { categories: Array.from({length: 24}, (_, i) => i + '시') },
                credits: {enabled: false},
                series: [{ name: '입차 대수', data: hourlyCount, color: '#0073e6' }]
            });
        }

        function updateMemberStats() {

                const allRecs = getAllRecords();
                const memberRecords = allRecs.filter(r => r.is_member === 1);
                const totalMembers = memberRecords.length;

                console.log('회원 레코드 수:', totalMembers);

                const memberBoxes = document.querySelectorAll('.member-summary-box');
                console.log('memberBoxes 개수:', memberBoxes.length);

                if (memberBoxes.length >= 3) {
                        memberBoxes[0].textContent = '총 누적 회원수: ' + totalMembers.toLocaleString() + '명';
                        console.log('회원 Box 0 업데이트 완료');

                        memberBoxes[1].textContent = '활성 회원수: ' + Math.floor(totalMembers * 0.7).toLocaleString() + '명';
                        console.log('회원 Box 1 업데이트 완료');


                        memberBoxes[2].textContent = '비활성 회원수: ' + Math.floor(totalMembers * 0.3).toLocaleString() + '명';
                        console.log('회원 Box 2 업데이트 완료');

                    console.log('회원 통계 업데이트 완료!');
                } else {
                    console.error('member-summary-box를 찾을 수 없습니다!');
                }
        }
        // 수정 (위에거 주석처리)
        // function updateMemberStats() {
        //     try {
        //         const memberBoxes = document.querySelectorAll('.member-summary-box');
        //
        //         if (memberBoxes.length >= 3) {
        //             memberBoxes[0].textContent = '총 누적 회원수: ' + memberStats.totalCount.toLocaleString() + '명';
        //             memberBoxes[1].textContent = '활성 회원수: ' + memberStats.activeCount.toLocaleString() + '명';
        //             memberBoxes[2].textContent = '비활성 회원수: ' + memberStats.inactiveCount.toLocaleString() + '명';
        //         }
        //     } catch(error) {
        //         console.error('updateMemberStats 에러:', error);
        //     }
        // }


        function switchStatisticType(type) {
            const views = ['monthly_sales', 'cumulative_sales_chart', 'pie_chart', 'peak_time_chart', 'member_stats_view'];
            views.forEach(v => document.getElementById(v).style.display = 'none');

            const salesFilters = document.getElementById('salesFilters');
            const carTypeFilters = document.getElementById('carTypeFilters');

            // 모든 필터 숨기기
            salesFilters.style.display = 'none';
            carTypeFilters.style.display = 'none';

            if (type === 'monthly_sales') {
                salesFilters.style.display = 'flex';
                document.getElementById('monthly_sales').style.display = 'block';
                const year = document.getElementById('yearSelect2').value;
                const month = document.getElementById('monthSelect2').value;
                const includeMem = document.getElementById('membershipCheckbox').checked;
                drawMonthlySalesChart(year, month, includeMem);
            } else if (type === 'cumulative_sales') {
                salesFilters.style.display = 'flex';
                document.getElementById('cumulative_sales_chart').style.display = 'block';
                const year = document.getElementById('yearSelect2').value;
                const month = document.getElementById('monthSelect2').value;
                const includeMem = document.getElementById('membershipCheckbox').checked;
                drawCumulativeSalesChart(year, month, includeMem);
            } else if (type === 'car_type_pie') {
                carTypeFilters.style.display = 'flex';
                document.getElementById('pie_chart').style.display = 'block';
                const year = document.getElementById('yearSelect3').value;
                const month = document.getElementById('monthSelect3').value;
                drawCarTypePie(year, month);
            } else if (type === 'peak_time') {
                document.getElementById('peak_time_chart').style.display = 'block';
                drawPeakTimeChart();
            } else if (type === 'member_stats') {
                document.getElementById('member_stats_view').style.display = 'block';
                updateMemberStats();
            }
        }

        let dailySales = 0;
        let dailyCount = 0;
        let totalCount = 0;

        function updateSummary() {
            console.log('=== updateSummary 시작 ===');
            console.log('parkingDataByYear:', parkingDataByYear);

            const today = new Date();
            const todayStr = today.toISOString().slice(0,10);
            console.log('오늘 날짜:', todayStr);



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
        // 이벤트 리스너 통합
        window.addEventListener('load', function() {
            populateYearSelect();
            updateSummary();
            switchStatisticType('monthly_sales'); // 초기값 실행
        });

        document.addEventListener('DOMContentLoaded', function() {
            // 유형 변경
            document.getElementById('statisticTypeSelect').addEventListener('change', function() {
                switchStatisticType(this.value);
            });

            // 월별/누적 매출 필터 변경시 즉시 갱신
            const refreshChart = () => {
                const type = document.getElementById('statisticTypeSelect').value;
                const year = document.getElementById('yearSelect2').value;
                const month = document.getElementById('monthSelect2').value;
                const includeMem = document.getElementById('membershipCheckbox').checked;

                if (type === 'monthly_sales') {
                    drawMonthlySalesChart(year, month, includeMem);
                } else if (type === 'cumulative_sales') {
                    drawCumulativeSalesChart(year, month, includeMem);
                }
            };

            document.getElementById('yearSelect2').addEventListener('change', refreshChart);
            document.getElementById('monthSelect2').addEventListener('change', refreshChart);
            document.getElementById('membershipCheckbox').addEventListener('change', refreshChart);

            // 차종 필터 변경시 즉시 갱신
            const refreshCarTypePie = () => {
                const year = document.getElementById('yearSelect3').value;
                const month = document.getElementById('monthSelect3').value;
                drawCarTypePie(year, month);
            };

            document.getElementById('yearSelect3').addEventListener('change', refreshCarTypePie);
            document.getElementById('monthSelect3').addEventListener('change', refreshCarTypePie);
        });


    </script>

    </body>
    </html>