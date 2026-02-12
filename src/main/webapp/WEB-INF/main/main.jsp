<%@ page import="com.example.smartparkingsystem.dto.ParkingHistoryDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.smartparkingsystem.service.ParkingHistoryService" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    ParkingHistoryService parkingHistoryService = ParkingHistoryService.INSTANCE;
    List<ParkingHistoryDTO> occupiedList = (List<ParkingHistoryDTO>) request.getAttribute("occupiedList");

    Map<String, ParkingHistoryDTO> occupiedMap = new HashMap<>();
    if (occupiedList != null) {
        for (ParkingHistoryDTO dto : occupiedList) {
            occupiedMap.put(dto.getParkingArea(), dto);
        }
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%-- 아이콘 --%>
    <link rel="icon" href="data:,">
    <%--    <%@include file="/web/main/main_process.jsp"%>--%>

    <meta charset="UTF-8">
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
    <title>반월당 스마트 주차 관리 시스템</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- 메인보드 css -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/main/mainboard.css">

    <!-- 영수증 css -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/main/receipt.css">
    <style>
        /* 입차 모달 전용 스타일 */
        #input-carNum:focus {
            border-color: #0d6efd !important;
            box-shadow: 0 0 0 0.25 margin-bottom rgba(13, 110, 253, 0.1) !important;
        }

        /* 라디오 버튼(차종 선택) 커스텀 */
        .btn-check:checked + .btn-outline-primary {
            background-color: #e7f1ff !important;
            color: #0d6efd !important;
            border-color: #0d6efd !important;
            box-shadow: 0 4px 10px rgba(13, 110, 253, 0.1);
        }

        .btn-outline-primary {
            border: 2px solid #eee !important;
            color: #666;
            transition: all 0.2s ease;
        }

        .btn-outline-primary:hover {
            background-color: #f8f9fa !important;
            border-color: #ccc !important;
            color: #333;
        }

        /* 모달 내부 간격 및 스타일 개선 */
        #parkingModal .modal-body {
            padding: 2rem !important; /* 내부 여백 대폭 확대 */
        }

        /* 출차 정보 리스트 (Table 대체 스타일) */
        .info-list {
            display: flex;
            flex-direction: column;
            gap: 15px; /* 항목 간 간격 */
            margin-bottom: 20px;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #f0f0f0;
            padding-bottom: 10px;
        }

        .info-label {
            margin-top: 15px;
            display: block;
            font-size: 1.15rem !important;
            font-weight: 650 !important;
            color: #333 !important;
            margin-bottom: 12px !important;
        }

        .info-value {
            font-weight: 600;
            text-align: right;
        }

        .info-value

        /* 총 요금 강조 */
        #info-totalPrice {
            font-size: 1.4rem;
            letter-spacing: -0.5px;
        }

        /* 버튼 디자인 개선 */
        .modal-footer {
            border-top: none !important;
            padding: 0 2rem 2rem 2rem !important;
        }

        .modal-footer .btn {
            padding: 12px 25px;
            border-radius: 12px;
            font-weight: bold;
        }
    </style>
</head>
<body>
<!-- 공통 header 구역 -->
<%@ include file="/web/common/header_main.jsp"%>

<!-- 메인 페이지 -->
<div class="container-fluid mt-4">
    <!-- 주차 현황 요약 -->
    <div class="section-header d-flex justify-content-between align-items-end">
        <div>
            <h3 class="section-title">주차 현황</h3>
            <p class="mb-0">현재 <b>6대</b>의 차량이 주차되어 있습니다.</p>
        </div>

        <!-- 차량 검색 창 -->
        <div class="d-flex" style="gap: 10px; margin-bottom: 5px;">
            <input type="text" class="form-control" id="inputCarNum"
                   placeholder="검색할 차량번호 4자리를 입력하세요."
                   style="width: 450px; height: 38px;">
            <button class="btn btn-secondary px-4 text-nowrap" id="btnCarSearch" style="height: 38px;">검색</button>
        </div>
    </div>

    <!-- 주차 구역 메인 보드 -->
    <div id="parking-board">
        <div class="layout-wrapper">
            <!-- 좌측 주차 구역 A1 ~ A5 (세로 정렬) -->
            <div class="column">
                <% for(int i=1;i<=5;i++){
                    String currentId = "A-" + i;
                    ParkingHistoryDTO occupiedInfo = occupiedMap.get(currentId);
                    request.setAttribute("id", currentId);

                    if (occupiedInfo != null) {
                        request.setAttribute("status", "occupied");
                        request.setAttribute("car", occupiedInfo.getCarNum());
                        request.setAttribute("time", occupiedInfo.getEntryTime());
                        request.setAttribute("type", occupiedInfo.getCarType());
                        request.setAttribute("parkNo", occupiedInfo.getParkNo());
                        request.setAttribute("isMember", occupiedInfo.isMember());
                    } else {
                        request.setAttribute("status", "available");
                        request.setAttribute("car", null);
                        request.setAttribute("time", null);
                        request.setAttribute("type", null);
                        request.setAttribute("parkNo", null);
                        request.setAttribute("isMember", null);
                    }
                %>
                <%@ include file="/web/main/parking_card.jsp" %>
                <% } %>
            </div>

            <!-- 중앙 주차 구역 -->
            <div class="center-wrapper">
                <div class="central-column">
                    <!-- 중앙 상단 주차 구역 A6 ~ A10 -->
                    <div class="center-row">
                        <% for(int i=6;i<=10;i++){
                            String currentId = "A-" + i;
                            ParkingHistoryDTO occupiedInfo = occupiedMap.get(currentId);
                            request.setAttribute("id", currentId);

                            if (occupiedInfo != null) {
                                request.setAttribute("status", "occupied");
                                request.setAttribute("car", occupiedInfo.getCarNum());
                                request.setAttribute("time", occupiedInfo.getEntryTime());
                                request.setAttribute("type", occupiedInfo.getCarType());
                                request.setAttribute("parkNo", occupiedInfo.getParkNo());
                                request.setAttribute("isMember", occupiedInfo.isMember());
                            } else {
                                request.setAttribute("status", "available");
                                request.setAttribute("car", null);
                                request.setAttribute("time", null);
                                request.setAttribute("type", null);
                                request.setAttribute("parkNo", null);
                                request.setAttribute("isMember", null);
                            }
                        %>
                        <%@ include file="/web/main/parking_card.jsp" %>
                        <% } %>
                    </div>
                    <!-- 중앙 주차 하단 구역 A11 ~ A15 -->
                    <div class="center-row">
                        <% for(int i=11;i<=15;i++){
                            String currentId = "A-" + i;
                            ParkingHistoryDTO occupiedInfo = occupiedMap.get(currentId);
                            request.setAttribute("id", currentId);

                            if (occupiedInfo != null) {
                                request.setAttribute("status", "occupied");
                                request.setAttribute("car", occupiedInfo.getCarNum());
                                request.setAttribute("time", occupiedInfo.getEntryTime());
                                request.setAttribute("type", occupiedInfo.getCarType());
                                request.setAttribute("parkNo", occupiedInfo.getParkNo());
                                request.setAttribute("isMember", occupiedInfo.isMember());
                            } else {
                                request.setAttribute("status", "available");
                                request.setAttribute("car", null);
                                request.setAttribute("time", null);
                                request.setAttribute("type", null);
                                request.setAttribute("parkNo", null);
                                request.setAttribute("isMember", null);
                            }
                        %>
                        <%@ include file="/web/main/parking_card.jsp" %>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- 우측 주차 구역 A16 ~ A20 -->
            <div class="column">
                <% for (int i = 16; i <= 20; i++){
                    String currentId = "A-" + i;
                    ParkingHistoryDTO occupiedInfo = occupiedMap.get(currentId);
                    request.setAttribute("id", currentId);

                    if (occupiedInfo != null) {
                        request.setAttribute("status", "occupied");
                        request.setAttribute("car", occupiedInfo.getCarNum());
                        request.setAttribute("time", occupiedInfo.getEntryTime());
                        request.setAttribute("type", occupiedInfo.getCarType());
                        request.setAttribute("parkNo", occupiedInfo.getParkNo());
                        request.setAttribute("isMember", occupiedInfo.isMember());
                    } else {
                        request.setAttribute("status", "available");
                        request.setAttribute("car", null);
                        request.setAttribute("time", null);
                        request.setAttribute("type", null);
                        request.setAttribute("parkNo", null);
                        request.setAttribute("isMember", null);
                    }
                %>
                <%@ include file="/web/main/parking_card.jsp" %>
                <% } %>
            </div>
        </div>
    </div>
</div>

<!-- 주차 상태 처리 모달 -->
<%@ include file="/web/main/parking_modal.jsp"%>
<%@include file="/web/main/membershipPayModal.jsp"%>

<!-- 공통 footer 구역 -->
<%@ include file="/web/common/footer.jsp"%>

<!-- bootstrap JS (모달 동작용) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- 함수(날짜 형식, 주차 현황 숫자) 로직 JS -->
<script src="${pageContext.request.contextPath}/web/main/main_function.js"></script>

<!-- 검색 모달 JS -->
<script src="${pageContext.request.contextPath}/web/main/main_search.js"></script>

<!-- 요금 계산 로직 JS -->
<script src="${pageContext.request.contextPath}/web/main/main_parking_charge_logic.js"></script>

<!-- 메인 모달 JS -->
<script src="${pageContext.request.contextPath}/web/main/main_modal.js"></script>

<!-- 회원권 결제 모달 JS -->
<script src="${pageContext.request.contextPath}/web/main/main_membershipPay.js"></script>

</body>
</html>