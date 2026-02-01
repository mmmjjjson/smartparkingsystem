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
                    <option value="0">0월</option>
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

            <div class="graph-placeholder">
                일별 매출 선 그래프
            </div>
        </div>

        <!-- 월별 매출 -->
        <div class="info-box">
            <div class="section-title">월별 매출 바 그래프</div>

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
/* select 현재 년월로 설정 */
<script>
    const now = new Date();

    const currentYear = now.getFullYear();
    const currentMonth = now.getMonth() + 1;

    document.getElementById('yearSelect').value = currentYear;
    document.getElementById('monthSelect').value = currentMonth;
</script>




<!-- *** DB임시 데이터 *** -->
<!-- 1. admin -->
<!--
INSERT INTO admin (
  admin_id,
  password,
  admin_name,
  birth,
  admin_phone
) VALUES (
  'admin01',
  '1234',
  '김준홍',
  '900315',
  '010-1234-5678'
);
-->


<!-- 2. member -->
<!--
INSERT INTO members (
  car_num,
  member_name,
  member_phone,
  start_date,
  end_date,
  is_active,
  created_at,
  updated_at
) VALUES
('12가3456', '김민수', '010-1111-2222', '2025-12-01', '2026-02-28', 1, '2025-12-01 09:10:00', '2025-12-01 09:10:00'),
('34나7890', '이서연', '010-2222-3333', '2025-10-01', '2025-12-31', 0, '2025-10-01 08:30:00', '2026-01-01 00:00:00'),
('56다1234', '박준호', '010-3333-4444', '2026-01-01', '2026-03-31', 1, '2026-01-01 07:55:00', '2026-01-10 12:20:00'),
('78라5678', '정유진', '010-4444-5555', '2025-11-15', '2026-01-15', 1, '2025-11-15 10:05:00', '2025-12-20 14:00:00'),
('90마9012', '오세훈', '010-5555-6666', '2025-09-01', '2025-11-30', 0, '2025-09-01 09:00:00', '2025-12-01 00:00:00'),
('11바2345', '한지민', '010-6666-7777', '2026-01-05', '2026-04-04', 1, '2026-01-05 08:40:00', '2026-01-05 08:40:00'),
('22사6789', '윤태호', '010-7777-8888', '2025-08-01', '2025-10-31', 0, '2025-08-01 09:20:00', '2025-11-01 00:00:00'),
('33아0123', '김소연', '010-8888-9999', '2025-12-20', '2026-02-19', 1, '2025-12-20 11:10:00', '2025-12-20 11:10:00'),
('44자4567', '최민호', '010-9999-0000', '2025-07-01', '2025-09-30', 0, '2025-07-01 08:50:00', '2025-10-01 00:00:00'),
('55차8901', '문채원', '010-1212-3434', '2026-01-10', '2026-03-10', 1, '2026-01-10 09:30:00', '2026-01-12 16:45:00');
-->


<!-- 3. parking_history -->
<!--
INSERT INTO parking_history (
  no,
  parking_area,
  car_num,
  car_type,
  is_member,
  entry_time,
  exit_time
) VALUES
(1,  'A1', '12가3456', '일반', 1, '2026-01-01 08:10:00', '2026-01-01 10:30:00'),
(2,  'A2', '34나7890', '일반', 1, '2026-01-01 09:00:00', '2026-01-01 12:15:00'),
(3,  'B1', '88허1234', '일반', 0, '2026-01-01 10:20:00', '2026-01-01 11:00:00'),
(4,  'B2', '56다1234', '경차', 1, '2026-01-02 07:50:00', '2026-01-02 09:10:00'),
(5,  'C1', '99허5678', '일반', 0, '2026-01-02 08:40:00', '2026-01-02 13:00:00'),
(6,  'A1', '78라5678', '일반', 1, '2026-01-03 11:30:00', '2026-01-03 14:20:00'),
(7,  'A2', '11바2345', '일반', 1, '2026-01-03 09:10:00', '2026-01-03 18:00:00'),
(8,  'B1', '22사6789', '일반', 1, '2026-01-04 08:00:00', '2026-01-04 09:00:00'),
(9,  'B2', '77허9999', '장애인', 0, '2026-01-04 10:10:00', '2026-01-04 12:00:00'),
(10, 'C1', '33아0123', '일반', 1, '2026-01-05 13:40:00', '2026-01-05 16:10:00'),

(11, 'A1', '44자4567', '일반', 1, '2025-12-28 09:00:00', '2025-12-28 10:20:00'),
(12, 'A2', '66허2222', '일반', 0, '2025-12-28 11:10:00', '2025-12-28 15:30:00'),
(13, 'B1', '55차8901', '일반', 1, '2025-12-29 08:30:00', '2025-12-29 11:00:00'),
(14, 'B2', '12가3456', '일반', 1, '2025-12-29 14:00:00', '2025-12-29 17:40:00'),
(15, 'C1', '88허7777', '일반', 0, '2025-12-30 10:50:00', '2025-12-30 12:10:00'),

(16, 'A1', '11바2345', '일반', 1, '2026-02-01 09:10:00', '2026-02-01 11:30:00'),
(17, 'A2', '90마9012', '일반', 1, '2026-02-01 12:00:00', '2026-02-01 15:00:00'),
(18, 'B1', '77허1111', '일반', 0, '2026-02-02 08:20:00', '2026-02-02 09:40:00'),
(19, 'B2', '56다1234', '경차', 1, '2026-02-02 10:00:00', '2026-02-02 13:00:00'),
(20, 'C1', '33아0123', '일반', 1, '2026-02-03 16:10:00', '2026-02-03 18:30:00');
-->


<!-- 4. payment_info -->
<!--
INSERT INTO payment_info
(basic_charge, extra_charge, small_car_discount, disabled_discount, basic_time, extra_time)
VALUES
(2000, 1000, 0.3, 0.5, 60, 30);
-->
</body>
</html>
