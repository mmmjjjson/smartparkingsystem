<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<%--<%@include file="/web/main/main_process.jsp"%>--%>
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
<body>

<div class="container">

  <!-- 헤더 -->
  <div class="header">
    <div class="header-title">스마트 주차 관리 시스템</div>

    <div class="nav-buttons">
      <button class="nav-btn">대시보드</button>
      <button class="nav-btn">회원 관리</button>
      <button class="nav-btn">설정 관리</button>
      <button class="nav-btn active">통계</button>
    </div>

    <button class="logout-btn">로그아웃</button>
  </div>

  <!-- 콘텐츠 -->
  <div class="content">

    <!-- 일별 매출 -->
    <div class="info-box">
      <div class="section-title">일별 매출 선 그래프</div>

      <div class="filter-box">
        <select>
          <option>2026년</option>
          <option>2025년</option>
          <option>2024년</option>
          <option>2023년</option>
          <option>2022년</option>
          <option>2021년</option>
          <option>2020년</option>
        </select>
        <select>
          <option>1월</option>
          <option>2월</option>
          <option>3월</option>
          <option>4월</option>
          <option>5월</option>
          <option>6월</option>
          <option>7월</option>
          <option>8월</option>
          <option>9월</option>
          <option>10월</option>
          <option>11월</option>
          <option>12월</option>
        </select>
        <select>
          <option>1일</option>
          <option>2일</option>
          <option>3일</option>
          <option>4일</option>
          <option>5일</option>
          <option>6일</option>
          <option>7일</option>
          <option>8일</option>
          <option>9일</option>
          <option>10일</option>
          <option>11일</option>
          <option>12일</option>
          <option>13일</option>
          <option>14일</option>
          <option>15일</option>
          <option>16일</option>
          <option>17일</option>
          <option>18일</option>
          <option>19일</option>
          <option>20일</option>
          <option>21일</option>
          <option>22일</option>
          <option>23일</option>
          <option>24일</option>
          <option>25일</option>
          <option>26일</option>
          <option>27일</option>
          <option>28일</option>
          <option>29일</option>
          <option>30일</option>
          <option>31일</option>
        </select>

      </div>

      <div class="graph-placeholder">
        일별 매출 선 그래프
      </div>
    </div>

    <!-- 월별 매출 -->
    <div class="info-box">
      <div class="section-title">월별 매출 바 그래프</div>

      <div class="filter-box">
        <select>
          <option>2026년</option>
          <option>2025년</option>
          <option>2024년</option>
          <option>2023년</option>
          <option>2022년</option>
          <option>2021년</option>
          <option>2020년</option>
        </select>
          <select>
              <option>1월</option>
              <option>2월</option>
              <option>3월</option>
              <option>4월</option>
              <option>5월</option>
              <option>6월</option>
              <option>7월</option>
              <option>8월</option>
              <option>9월</option>
              <option>10월</option>
              <option>11월</option>
              <option>12월</option>
          </select>
      </div>

      <div class="graph-placeholder">
        월별 매출 바 그래프
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

</body>
</html>
