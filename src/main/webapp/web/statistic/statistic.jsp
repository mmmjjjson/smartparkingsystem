<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>통계 | 스마트 주차 관리 시스템</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/web/statistic/statistic3.css">

  <!-- Highcharts 라이브러리 -->
  <script src="https://code.highcharts.com/highcharts.js"></script>
  <script src="https://code.highcharts.com/modules/exporting.js"></script>

</head>
<body>

<div class="container">
<%--  <%@ include file="../common/header_other.jsp" %>--%>

  <div class="content">
    <div class="info-box">

      <!-- 필터 폼 (AJAX 방식으로 변경) -->
      <div class="filter-container">
        <div class="filter-row">
          <label>통계 유형</label>
          <select id="chartType">
            <option value="monthly_sales">년도 / 월별 매출</option>
            <option value="cumulative_sales">누적 매출</option>
            <option value="car_type_pie">차종별 통계</option>
            <option value="peak_time">피크 시간대</option>
            <option value="member_stats">회원 통계</option>
          </select>
        </div>

        <div class="filter-row">
          <label>상세 조건</label>
          <select id="year">
            <option value="2024">2024년</option>
            <option value="2025">2025년</option>
            <option value="2026" selected>2026년</option>
          </select>

          <select id="month">
            <option value="all">전체</option>
            <option value="1">1월</option>
            <option value="2" selected>2월</option>
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

          <label>
            <input type="checkbox" id="includeMembership">
            회원권 매출 포함
          </label>

          <button class="btn btn-primary" onclick="loadChart()">조회</button>
        </div>
      </div>

      <!-- 차트 컨테이너 -->
      <div id="chart_container" style="min-height: 400px;">
        <div class="text-center p-5">
          <p>조회 버튼을 클릭하여 통계를 확인하세요.</p>
        </div>
      </div>

    </div>

    <div class="info-box2">
      <div class="section-title">통계 요약</div>
      <div class="summary">
        <div class="summary-box">
          일일 총 매출액: <span id="dailySales">${todaySummary.dailySales}</span>원
        </div>
        <div class="summary-box">
          일일 입차 대수: <span id="dailyCount">${todaySummary.dailyCount}</span>대
        </div>
        <div class="summary-box">
          누적 차량 대수: <span id="totalCount">${todaySummary.totalCount}</span>대
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  // ========================================
  // 전역 변수
  // ========================================
  const CONTEXT_PATH = '<%= request.getContextPath() %>';
  let currentChartType = 'monthly_sales';

  // ========================================
  // 페이지 로드 시 초기화
  // ========================================
  window.onload = function() {
    console.log(CONTEXT_PATH);
    console.log('통계 페이지 로드 완료');
    console.log('Context Path:', CONTEXT_PATH);

    // 초기 차트 로드
    loadChart();

    // 이벤트 리스너 등록
    document.getElementById('chartType').addEventListener('change', function() {
      currentChartType = this.value;
      loadChart();
    });
  };

  // ========================================
  // 차트 로드 메인 함수
  // ========================================
  function loadChart() {
    const chartType = document.getElementById('chartType').value;
    const year = parseInt(document.getElementById('year').value);
    const month = document.getElementById('month').value;
    const includeMembership = document.getElementById('includeMembership').checked;

    console.log('차트 로드:', {chartType, year, month, includeMembership});

    // 로딩 표시
    showLoading();

    // 차트 타입별 API 호출
    switch(chartType) {
      case 'monthly_sales':
        loadMonthlySales(year, month, includeMembership);
        break;
      case 'cumulative_sales':
        loadCumulativeSales(year, month, includeMembership);
        break;
      case 'car_type_pie':
        loadCarTypePie(year, month);
        break;
      case 'peak_time':
        loadPeakTime();
        break;
      case 'member_stats':
        loadMemberStats();
        break;
    }
  }
  document.getElementById('year')
  document.getElementById('month')
  document.getElementById('includeMembership')
  // ========================================
  // 1. 월별 매출 통계
  // ========================================
  function loadMonthlySales(year, month, includeMembership) {
    const monthParam = month === 'all' ? '' : month;
    const url = (CONTEXT_PATH === '' ? '' : CONTEXT_PATH) +
            '/statistic/api/monthly-sales?year=' + year +
            '&month=' + monthParam +
            '&includeMembership=' + includeMembership;

    console.log('API 호출:', url);
    console.log('파라미터:', {year, month, monthParam, includeMembership});

    fetch(url)
            .then(response => {
              console.log('응답 상태:', response.status);
              if (!response.ok) {
                throw new Error('HTTP error! status: ' + response.status);
              }
              return response.json();
            })
            .then(data => {
              console.log('월별 매출 데이터:', data);
              drawMonthlySalesChart(data);
            })
            .catch(error => {
              console.error('월별 매출 로드 실패:', error);
              showError('월별 매출 데이터를 불러오는데 실패했습니다. ' + error.message);
            });
  }
  function drawMonthlySalesChart(data) {
    console.log("받은 데이터:", data);
    if (data.error) {
      showError('서버 오류: ' + data.message + ' (' + data.cause + ')');
      return;
    }
    // 데이터 없음 체크
    if (!data.categories || data.categories.length === 0) {
      showError('해당 기간의 데이터가 없습니다.');
      return;
    }
    // normalSales가 없거나 빈 배열인 경우
    if (!data.normalSales || data.normalSales.length === 0) {
      showError('매출 데이터가 없습니다.');
      return;
    }

    const series = [];

    // 일반 매출
    series.push({
      name: '일반 매출',
      data: data.normalSales,
      color: '#4472C4'
    });

    // 회원권 매출 (포함된 경우)
    if (data.includeMembership) {
      series.push({
        name: '회원권 매출',
        data: data.memberSales,
        color: '#70AD47'
      });
    }

    Highcharts.chart('chart_container', {
      chart: {
        type: 'column'
      },
      title: {
        text: data.categories.length > 12 ? '일별 매출 현황' : '월별 매출 현황'
      },
      xAxis: {
        categories: data.categories
      },
      yAxis: {
        min: 0,
        title: {
          text: '매출액 (원)'
        }
      },
      tooltip: {
        pointFormat: '<b>{point.y:,.0f}원</b>'
      },
      plotOptions: {
        column: {
          stacking: 'normal'
        }
      },
      series: series
    });
  }

  // ========================================
  // 2. 누적 매출 통계
  // ========================================
  function loadCumulativeSales(year, month, includeMembership) {
    const monthParam = month === 'all' ? '' : month;
    const url = CONTEXT_PATH + '/statistic/api/cumulative-sales?year=' + year +
            '&month=' + monthParam + '&includeMembership=' + includeMembership;

    console.log('API 호출:', url);

    fetch(url)
            .then(response => {
              if (!response.ok) throw new Error('HTTP error! status: ' + response.status);
              return response.json();
            })
            .then(data => {
              console.log('누적 매출 데이터:', data);
              drawCumulativeSalesChart(data);
            })
            .catch(error => {
              console.error('누적 매출 로드 실패:', error);
              showError('누적 매출 데이터를 불러오는데 실패했습니다. ' + error.message);
            });
  }

  function drawCumulativeSalesChart(data) {
    if (!data.categories || data.categories.length === 0) {
      showError('해당 기간의 데이터가 없습니다.');
      return;
    }

    const series = [];

    // 일반 누적 매출
    series.push({
      name: '일반 누적',
      data: data.cumulativeNormal,
      color: '#4472C4'
    });

    // 회원 누적 매출 (포함된 경우)
    if (data.includeMembership) {
      series.push({
        name: '회원 누적',
        data: data.cumulativeMember,
        color: '#70AD47'
      });
    }

    Highcharts.chart('chart_container', {
      chart: {
        type: 'column'
      },
      title: {
        text: data.title || '누적 매출 현황'
      },
      xAxis: {
        categories: data.categories
      },
      yAxis: {
        min: 0,
        title: {
          text: '누적 매출액 (원)'
        }
      },
      tooltip: {
        pointFormat: '<b>{point.y:,.0f}원</b>'
      },
      series: series
    });
  }

  // ========================================
  // 3. 차종별 통계 (파이 차트)
  // ========================================
  function loadCarTypePie(year, month) {
    const monthParam = month === 'all' ? '' : month;
    const url = CONTEXT_PATH + '/statistic/api/car-type-stats?year=' + year +
            '&month=' + monthParam;

    console.log('API 호출:', url);

    fetch(url)
            .then(response => {
              if (!response.ok) throw new Error('HTTP error! status: ' + response.status);
              return response.json();
            })
            .then(data => {
              console.log('차종별 통계 데이터:', data);
              drawCarTypePie(data);
            })
            .catch(error => {
              console.error('차종별 통계 로드 실패:', error);
              showError('차종별 통계 데이터를 불러오는데 실패했습니다. ' + error.message);
            });
  }

  function drawCarTypePie(data) {
    if (!data.data || data.data.length === 0) {
      showError('해당 기간의 데이터가 없습니다.');
      return;
    }

    Highcharts.chart('chart_container', {
      chart: {
        type: 'pie'
      },
      title: {
        text: '차종별 통계'
      },
      tooltip: {
        pointFormat: '<b>{point.y}대 ({point.percentage:.1f}%)</b>'
      },
      plotOptions: {
        pie: {
          allowPointSelect: true,
          cursor: 'pointer',
          dataLabels: {
            enabled: true,
            format: '<b>{point.name}</b>: {point.percentage:.1f}%'
          }
        }
      },
      series: [{
        name: '차종',
        colorByPoint: true,
        data: data.data
      }]
    });
  }

  // ========================================
  // 4. 피크 시간대 분석
  // ========================================
  function loadPeakTime() {
    const url = CONTEXT_PATH + '/statistic/api/peak-time';

    console.log('API 호출:', url);

    fetch(url)
            .then(response => {
              if (!response.ok) throw new Error('HTTP error! status: ' + response.status);
              return response.json();
            })
            .then(data => {
              console.log('피크 시간대 데이터:', data);
              drawPeakTimeChart(data);
            })
            .catch(error => {
              console.error('피크 시간대 로드 실패:', error);
              showError('피크 시간대 데이터를 불러오는데 실패했습니다. ' + error.message);
            });
  }

  function drawPeakTimeChart(data) {
    Highcharts.chart('chart_container', {
      chart: {
        type: 'column'
      },
      title: {
        text: '시간대별 입차 현황'
      },
      xAxis: {
        categories: data.categories
      },
      yAxis: {
        min: 0,
        title: {
          text: '입차 대수'
        }
      },
      tooltip: {
        pointFormat: '<b>{point.y}대</b>'
      },
      series: [{
        name: '입차 대수',
        data: data.hourlyCount,
        color: '#ED7D31'
      }]
    });
  }

  // ========================================
  // 5. 회원 통계
  // ========================================
  function loadMemberStats() {
    const url = CONTEXT_PATH + '/statistic/api/member-stats';

    console.log('API 호출:', url);

    fetch(url)
            .then(response => {
              if (!response.ok) throw new Error('HTTP error! status: ' + response.status);
              return response.json();
            })
            .then(data => {
              console.log('회원 통계 데이터:', data);
              drawMemberStatsChart(data);
            })
            .catch(error => {
              console.error('회원 통계 로드 실패:', error);
              showError('회원 통계 데이터를 불러오는데 실패했습니다. ' + error.message);
            });
  }

  function drawMemberStatsChart(data) {
    const pieData = [
      {
        name: '활성 회원',
        y: data.activeCount,
        color: '#70AD47'
      },
      {
        name: '비활성 회원',
        y: data.inactiveCount,
        color: '#FFC000'
      }
    ];

    Highcharts.chart('chart_container', {
      chart: {
        type: 'pie'
      },
      title: {
        text: '회원 현황 (총 ' + data.totalCount + '명)'
      },
      tooltip: {
        pointFormat: '<b>{point.y}명 ({point.percentage:.1f}%)</b>'
      },
      plotOptions: {
        pie: {
          allowPointSelect: true,
          cursor: 'pointer',
          dataLabels: {
            enabled: true,
            format: '<b>{point.name}</b>: {point.y}명 ({point.percentage:.1f}%)'
          }
        }
      },
      series: [{
        name: '회원',
        colorByPoint: true,
        data: pieData
      }]
    });
  }

  // ========================================
  // 유틸리티 함수
  // ========================================
  function showLoading() {
    document.getElementById('chart_container').innerHTML = `
        <div class="text-center p-5">
            <div class="spinner-border" role="status">
                <span class="visually-hidden">로딩중...</span>
            </div>
            <p class="mt-3">데이터를 불러오는 중입니다...</p>
        </div>
    `;
  }

  function showError(message) {
    document.getElementById('chart_container').innerHTML = `
        <div class="alert alert-warning text-center p-5" role="alert">
            ${message}
        </div>
    `;
  }

  // 오늘 요약 갱신 (옵션)
  function refreshTodaySummary() {
    fetch(CONTEXT_PATH + '/statistic/api/today-summary')
            .then(response => response.json())
            .then(data => {
              document.getElementById('dailySales').textContent = data.dailySales.toLocaleString();
              document.getElementById('dailyCount').textContent = data.dailyCount;
              document.getElementById('totalCount').textContent = data.totalCount;
            })
            .catch(error => {
              console.error('오늘 요약 갱신 실패:', error);
            });
  }
</script>

</body>
</html>
