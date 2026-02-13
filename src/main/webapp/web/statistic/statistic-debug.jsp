<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>통계 디버그</title>
    <script src="https://code.highcharts.com/highcharts.js"></script>
</head>
<body>
<h1>통계 API 테스트</h1>

<h2>1. 오늘 요약 (서버 렌더링)</h2>
<pre>
todaySummary.dailySales = ${todaySummary.dailySales}
todaySummary.dailyCount = ${todaySummary.dailyCount}
todaySummary.totalCount = ${todaySummary.totalCount}
</pre>

<h2>2. API 테스트 버튼</h2>
<button onclick="testAPI()">월별 매출 API 테스트</button>
<button onclick="testMemberAPI()">회원 통계 API 테스트</button>

<h2>3. 응답 데이터</h2>
<pre id="result"></pre>

<h2>4. 간단한 차트 테스트</h2>
<div id="chart" style="width: 600px; height: 400px;"></div>

<script>
console.log('페이지 로드됨');

// Highcharts 로드 확인
console.log('Highcharts:', typeof Highcharts);

function testAPI() {
    console.log('API 호출 시작');
    
    const url = '/statistic/api/monthly-sales?year=2025&month=&includeMembership=true';
    console.log('URL:', url);
    
    fetch(url)
        .then(response => {
            console.log('응답 상태:', response.status);
            return response.json();
        })
        .then(data => {
            console.log('받은 데이터:', data);
            document.getElementById('result').textContent = JSON.stringify(data, null, 2);
            
            // 간단한 차트 그리기
            if (data.categories && data.categories.length > 0) {
                Highcharts.chart('chart', {
                    chart: { type: 'column' },
                    title: { text: '테스트 차트' },
                    xAxis: { categories: data.categories },
                    series: [{
                        name: '일반 매출',
                        data: data.normalSales
                    }]
                });
            } else {
                alert('데이터가 없습니다!');
            }
        })
        .catch(error => {
            console.error('에러:', error);
            document.getElementById('result').textContent = 'ERROR: ' + error;
        });
}

function testMemberAPI() {
    console.log('회원 API 호출');
    
    fetch('/statistic/api/member-stats')
        .then(response => response.json())
        .then(data => {
            console.log('회원 데이터:', data);
            document.getElementById('result').textContent = JSON.stringify(data, null, 2);
        })
        .catch(error => {
            console.error('에러:', error);
        });
}
</script>

</body>
</html>
