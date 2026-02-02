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
        .graph-placeholder {
          height: 280px;
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

        .right-section {
          border: 2px solid #4472c4;
          padding: 20px;
          border-radius: 4px;
          text-align: center;
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
        }


    </style>
</head>
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/exporting.js"></script>
<script src="https://code.highcharts.com/modules/export-data.js"></script>
<script src="https://code.highcharts.com/modules/accessibility.js"></script>
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


    <%@ include file="../common/header_2.jsp" %> <!-- 헤더 불러오기 (css X)-->


    <!-- 콘텐츠 -->
    <div class="content">

        <!-- 일별 매출 -->
        <div class="info-box">
            <div class="section-title">일별 매출 선 그래프</div>

            <div class="filter-box">
                <select id="yearSelect">
                    <option value="2026">2026년</option>
                    <option value="2025">2025년</option>
                    <option value="2024">2024년</option>
                    <option value="2023">2023년</option>
                    <option value="2022">2022년</option>
                    <option value="2021">2021년</option>
                    <option value="2020">2020년</option>
                </select>
                <select id="monthSelect">
                    <option value="1">1월</option>
                    <option value="2">2월</option>
                    <option value="3">3월</option>
                    <option value="4">4월</option>
                    <option value="5">5월</option>
                    <option value="6">6월</option>
                    <option value="7">7월</option>
                    <option value="8">8월</option>
                    <option value="9">9월</option>
                    <option value="10">10월</option>
                    <option value="11">11월</option>
                    <option value="12">12월</option>
                </select>


            </div>

            <div id="daily sales" class="graph-placeholder">
                일별 매출 선 그래프
                <script>
                    Highcharts.chart('daily sales', {

                        title: {
                            text: '일별 매출 선 그래프',
                            align: 'left'
                        },

                        subtitle: {
                            align: 'left'
                        },

                        yAxis: {
                            title: {
                                text: '차량 수'
                            }
                        },

                        xAxis: {
                            accessibility: {
                                rangeDescription: 'Range: 2010 to 2022'
                            }
                        },



                        plotOptions: {
                            series: {
                                label: {
                                    connectorAllowed: false
                                },
                                pointStart: 2010
                            }
                        },

                        series: [{
                            name: 'Installation & Developers',
                            data: [
                                43934, 48656, 65165, 81827, 112143, 142383,
                                171533, 165174, 155157, 161454, 154610, 168960, 171558
                            ]
                        }],

                        responsive: {
                            rules: [{
                                condition: {
                                    maxWidth: 500
                                },
                                chartOptions: {
                                    legend: {
                                        layout: 'horizontal',
                                        align: 'center',
                                        verticalAlign: 'bottom'
                                    }
                                }
                            }]
                        }

                    });
                </script>

            </div>
        </div>

        <!-- 월별 매출 -->
        <div class="info-box">
            <div class="section-title">월별 매출 바 그래프</div>

            <div class="filter-box">
                <select id="yearSelect2">
                    <option value="2026">2026년</option>
                    <option value="2025">2025년</option>
                    <option value="2024">2024년</option>
                    <option value="2023">2023년</option>
                    <option value="2022">2022년</option>
                    <option value="2021">2021년</option>
                    <option value="2020">2020년</option>
                </select>

            </div>

            <div id="monthly-sales" class="graph-placeholder">
                <script>

                    const parkingData2024 = [
                      {
                        "month": 1,
                        "records": [
                          {"parking_area":"A01","car_num":"01가1001","car_type":"일반","is_member":1,"entry_time":"2024-01-03 08:15:00","exit_time":"2024-01-03 12:30:00"},
                          {"parking_area":"B01","car_num":"서울12가3456","car_type":"경차","is_member":0,"entry_time":"2024-01-05 09:20:00","exit_time":"2024-01-05 10:50:00"},
                          {"parking_area":"C01","car_num":"서울34나5678","car_type":"일반","is_member":0,"entry_time":"2024-01-07 11:10:00","exit_time":"2024-01-07 13:00:00"},
                          {"parking_area":"A02","car_num":"서울56다9012","car_type":"일반","is_member":0,"entry_time":"2024-01-10 14:00:00","exit_time":"2024-01-10 17:30:00"},
                          {"parking_area":"B02","car_num":"서울78라1234","car_type":"경차","is_member":0,"entry_time":"2024-01-12 07:50:00","exit_time":"2024-01-12 09:20:00"}
                        ]
                      },
                      {
                        "month": 2,
                        "records": [
                          {"parking_area":"A01","car_num":"02나1002","car_type":"일반","is_member":1,"entry_time":"2024-02-03 08:10:00","exit_time":"2024-02-03 12:20:00"},
                          {"parking_area":"B01","car_num":"서울11가2345","car_type":"경차","is_member":0,"entry_time":"2024-02-05 09:25:00","exit_time":"2024-02-05 11:15:00"},
                          {"parking_area":"C01","car_num":"서울22나3456","car_type":"일반","is_member":0,"entry_time":"2024-02-07 10:30:00","exit_time":"2024-02-07 13:50:00"},
                          {"parking_area":"A02","car_num":"서울33다4567","car_type":"장애인","is_member":0,"entry_time":"2024-02-09 07:40:00","exit_time":"2024-02-09 09:55:00"},
                          {"parking_area":"B02","car_num":"서울44라5678","car_type":"일반","is_member":0,"entry_time":"2024-02-11 14:15:00","exit_time":"2024-02-11 16:30:00"}
                        ]
                      },
                      {
                        "month": 3,
                        "records": [
                          {"parking_area":"A01","car_num":"03다1003","car_type":"일반","is_member":1,"entry_time":"2024-03-03 08:15:00","exit_time":"2024-03-03 12:20:00"},
                          {"parking_area":"B01","car_num":"서울55마6789","car_type":"경차","is_member":0,"entry_time":"2024-03-05 09:25:00","exit_time":"2024-03-05 11:35:00"},
                          {"parking_area":"C01","car_num":"서울66가7890","car_type":"장애인","is_member":0,"entry_time":"2024-03-07 10:35:00","exit_time":"2024-03-07 13:45:00"},
                          {"parking_area":"A02","car_num":"서울77나9012","car_type":"일반","is_member":0,"entry_time":"2024-03-09 07:40:00","exit_time":"2024-03-09 09:50:00"},
                          {"parking_area":"B02","car_num":"서울88다1234","car_type":"일반","is_member":0,"entry_time":"2024-03-11 14:20:00","exit_time":"2024-03-11 16:30:00"}
                        ]
                      },
                      {
                        "month": 4,
                        "records": [
                          {"parking_area":"A01","car_num":"04라1004","car_type":"일반","is_member":1,"entry_time":"2024-04-03 08:10:00","exit_time":"2024-04-03 12:20:00"},
                          {"parking_area":"B01","car_num":"서울11마2345","car_type":"경차","is_member":0,"entry_time":"2024-04-05 09:20:00","exit_time":"2024-04-05 11:30:00"},
                          {"parking_area":"C01","car_num":"서울22가3456","car_type":"일반","is_member":0,"entry_time":"2024-04-07 10:30:00","exit_time":"2024-04-07 13:40:00"},
                          {"parking_area":"A02","car_num":"서울33나4567","car_type":"장애인","is_member":0,"entry_time":"2024-04-09 07:50:00","exit_time":"2024-04-09 09:55:00"},
                          {"parking_area":"B02","car_num":"서울44다5678","car_type":"일반","is_member":0,"entry_time":"2024-04-11 14:10:00","exit_time":"2024-04-11 16:20:00"}
                        ]
                      },
                      {
                        "month": 5,
                        "records": [
                          {"parking_area":"A01","car_num":"05마1005","car_type":"일반","is_member":1,"entry_time":"2024-05-03 08:15:00","exit_time":"2024-05-03 12:30:00"},
                          {"parking_area":"B01","car_num":"서울55라6789","car_type":"경차","is_member":0,"entry_time":"2024-05-05 09:25:00","exit_time":"2024-05-05 11:35:00"},
                          {"parking_area":"C01","car_num":"서울66마7890","car_type":"장애인","is_member":0,"entry_time":"2024-05-07 10:35:00","exit_time":"2024-05-07 13:45:00"},
                          {"parking_area":"A02","car_num":"서울77가9012","car_type":"일반","is_member":0,"entry_time":"2024-05-09 07:40:00","exit_time":"2024-05-09 09:50:00"},
                          {"parking_area":"B02","car_num":"서울88나1234","car_type":"일반","is_member":0,"entry_time":"2024-05-11 14:20:00","exit_time":"2024-05-11 16:30:00"}
                        ]
                      },
                      {
                        month: 6,
                        records: [
                          {"parking_area":"A01","car_num":"06가1006","car_type":"일반","is_member":1,"entry_time":"2024-06-03 02:18:00","exit_time":"2024-06-03 12:25:00"},
                          {"parking_area":"B01","car_num":"서울11다2345","car_type":"경차","is_member":0,"entry_time":"2024-06-05 11:26:00","exit_time":"2024-06-05 11:36:00"},
                          {"parking_area":"C01","car_num":"서울22라3456","car_type":"일반","is_member":0,"entry_time":"2024-06-07 10:33:00","exit_time":"2024-06-07 13:42:00"},
                          {"parking_area":"A02","car_num":"서울33마4567","car_type":"장애인","is_member":0,"entry_time":"2024-06-09 07:46:00","exit_time":"2024-06-09 10:02:00"},
                          {"parking_area":"B02","car_num":"서울44가5678","car_type":"일반","is_member":0,"entry_time":"2024-06-11 14:14:00","exit_time":"2024-06-11 16:18:00"}
                        ]
                      },
                      {
                        month: 7,
                        records: [
                          {"parking_area":"A01","car_num":"07나1007","car_type":"일반","is_member":1,"entry_time":"2024-07-03 08:19:00","exit_time":"2024-07-03 12:31:00"},
                          {"parking_area":"B01","car_num":"서울55나6789","car_type":"경차","is_member":0,"entry_time":"2024-07-05 09:32:00","exit_time":"2024-07-05 11:40:00"},
                          {"parking_area":"C01","car_num":"서울66다7890","car_type":"일반","is_member":0,"entry_time":"2024-07-07 08:39:00","exit_time":"2024-07-07 13:47:00"},
                          {"parking_area":"A02","car_num":"서울77라9012","car_type":"일반","is_member":0,"entry_time":"2024-07-09 07:45:00","exit_time":"2024-07-09 09:53:00"},
                          {"parking_area":"B02","car_num":"서울88마1234","car_type":"장애인","is_member":0,"entry_time":"2024-07-11 12:25:00","exit_time":"2024-07-11 16:33:00"}
                        ]
                      },
                      {
                        month: 8,
                        records: [
                          {"parking_area":"A01","car_num":"08다1008","car_type":"일반","is_member":1,"entry_time":"2024-08-03 08:12:00","exit_time":"2024-08-03 12:23:00"},
                          {"parking_area":"B01","car_num":"서울11라2345","car_type":"경차","is_member":0,"entry_time":"2024-08-05 09:26:00","exit_time":"2024-08-05 11:36:00"},
                          {"parking_area":"C01","car_num":"서울22마3456","car_type":"일반","is_member":0,"entry_time":"2024-08-07 10:38:00","exit_time":"2024-08-07 13:42:00"},
                          {"parking_area":"A02","car_num":"서울33가4567","car_type":"장애인","is_member":0,"entry_time":"2024-08-09 07:53:00","exit_time":"2024-08-09 09:59:00"},
                          {"parking_area":"B02","car_num":"서울44나5678","car_type":"일반","is_member":0,"entry_time":"2024-08-11 14:08:00","exit_time":"2024-08-11 16:21:00"}
                        ]
                      },
                      {
                        "month": 9,
                        "records": [
                          {"parking_area":"A01","car_num":"09라1009","car_type":"일반","is_member":1,"entry_time":"2024-09-03 08:15:00","exit_time":"2024-09-03 12:30:00"},
                          {"parking_area":"B01","car_num":"서울55가6789","car_type":"경차","is_member":0,"entry_time":"2024-09-05 09:25:00","exit_time":"2024-09-05 11:35:00"},
                          {"parking_area":"C01","car_num":"서울66나7890","car_type":"장애인","is_member":0,"entry_time":"2024-09-07 10:35:00","exit_time":"2024-09-07 13:45:00"},
                          {"parking_area":"A02","car_num":"서울77다9012","car_type":"일반","is_member":0,"entry_time":"2024-09-09 07:40:00","exit_time":"2024-09-09 09:50:00"},
                          {"parking_area":"B02","car_num":"서울88라1234","car_type":"일반","is_member":0,"entry_time":"2024-09-11 14:20:00","exit_time":"2024-09-11 16:30:00"}
                        ]
                      },
                      {
                        month: 10,
                        records: [
                          {"parking_area":"A01","car_num":"10마1010","car_type":"일반","is_member":1,"entry_time":"2024-10-03 08:21:00","exit_time":"2024-10-03 15:29:00"},
                          {"parking_area":"B01","car_num":"서울11마2345","car_type":"경차","is_member":0,"entry_time":"2024-10-05 09:18:00","exit_time":"2024-10-05 14:38:00"},
                          {"parking_area":"C01","car_num":"서울22가3456","car_type":"일반","is_member":0,"entry_time":"2024-10-07 10:32:00","exit_time":"2024-10-07 13:46:00"},
                          {"parking_area":"A02","car_num":"서울33나4567","car_type":"장애인","is_member":0,"entry_time":"2024-10-09 07:51:00","exit_time":"2024-10-09 09:57:00"},
                          {"parking_area":"B02","car_num":"서울44다5678","car_type":"일반","is_member":0,"entry_time":"2024-10-11 14:12:00","exit_time":"2024-10-11 16:25:00"}
                        ]
                      },
                      {
                        month: 11,
                        records: [
                          {"parking_area":"A01","car_num":"11가1011","car_type":"일반","is_member":1,"entry_time":"2024-11-03 08:25:00","exit_time":"2024-11-03 12:28:00"},
                          {"parking_area":"B01","car_num":"서울55나6789","car_type":"경차","is_member":0,"entry_time":"2024-11-05 09:30:00","exit_time":"2024-11-05 13:12:00"},
                          {"parking_area":"C01","car_num":"서울66다7890","car_type":"일반","is_member":0,"entry_time":"2024-11-07 08:36:00","exit_time":"2024-11-07 13:44:00"},
                          {"parking_area":"A02","car_num":"서울77라9012","car_type":"일반","is_member":0,"entry_time":"2024-11-09 07:43:00","exit_time":"2024-11-09 09:55:00"},
                          {"parking_area":"B02","car_num":"서울88마1234","car_type":"장애인","is_member":0,"entry_time":"2024-11-11 14:22:00","exit_time":"2024-11-11 16:31:00"}
                        ]
                      },
                      {
                        "month": 12,
                        "records": [
                          {"parking_area":"A01","car_num":"12나1012","car_type":"일반","is_member":1,"entry_time":"2024-12-03 08:10:00","exit_time":"2024-12-03 12:20:00"},
                          {"parking_area":"B01","car_num":"서울11라2345","car_type":"경차","is_member":0,"entry_time":"2024-12-05 09:20:00","exit_time":"2024-12-05 11:30:00"},
                          {"parking_area":"C01","car_num":"서울22마3456","car_type":"일반","is_member":0,"entry_time":"2024-12-07 10:30:00","exit_time":"2024-12-07 13:40:00"},
                          {"parking_area":"A02","car_num":"서울33가4567","car_type":"장애인","is_member":0,"entry_time":"2024-12-09 07:50:00","exit_time":"2024-12-09 09:55:00"},
                          {"parking_area":"B02","car_num":"서울44나5678","car_type":"일반","is_member":0,"entry_time":"2024-12-11 14:10:00","exit_time":"2024-12-11 16:20:00"}
                        ]
                      }
                    ];

                        // 입차/출차 시간 계산
    function spendingTime(entry, exit) {
        const start = new Date(entry.replace(' ', 'T'));
        const end = new Date(exit.replace(' ', 'T'));
        return Math.ceil((end - start) / (1000 * 60)); // 분 단위
    }

    // 요금 정책
    const paymentInfo = { basicTime: 60, extraTime: 30, basicCharge: 2000, extraCharge: 1000, maxCharge: 15000 };
    const paymentDiscount = { smallCarDiscount: 0.3, disabledDiscount: 0.5 };

    function drawChart(year) {
        if (year != "2024") {
            // 2024가 아니면 차트 초기화 또는 숨기기
            document.getElementById('monthly-sales').innerHTML = '<p>선택한 연도의 데이터가 없습니다.</p>';
            return;
        }

        let monthlySales = [];
        for (let monthData of parkingData2024) {
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

        Highcharts.chart('monthly-sales', {
            chart: { zoomType: 'xy' },
            title: { text: year + '년 월별 주차 매출 통계' },
            xAxis: {
                categories: parkingData2024.map(d => d.month + '월'),
                title: { text: '월' }
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
            series: [
                { type: 'line', name: '월별 매출', data: monthlySales, yAxis: 0, color: '#0073e6', zIndex: 1 },
                { type: 'column', name: '누적 매출', data: chartAllCharge, yAxis: 1, color: '#ffd2a9', opacity: 0.8, zIndex: 0 }
            ]
        });
    }

    // 초기 실행 (선택값 불러오기)
    drawChart(document.getElementById('yearSelect2').value);

    // select 변경 시 차트 업데이트
    document.getElementById('yearSelect2').addEventListener('change', function() {
        drawChart(this.value);
    });
                </script>
            </div>
        </div>

        <!-- 차종 통계 -->
        <div class="info-box">
            <div class="section-title">차종 통계</div>

            <div class="car-type-section">
                <div class="graph-placeholder">
                    차종별 통계 파이 그래프
                </div>

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
/* select 현재 년월로 설정 */
<script>
    const now = new Date();

    const currentYear = now.getFullYear();
    const currentMonth = now.getMonth() + 1;

    document.getElementById('yearSelect').value = currentYear;
    document.getElementById('monthSelect').value = currentMonth;
</script>



