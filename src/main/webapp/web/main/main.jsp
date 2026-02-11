<%@ page import="com.example.smartparkingsystem.dto.ParkingHistoryDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.smartparkingsystem.service.ParkingHistoryService" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    ParkingHistoryService parkingHistoryService = ParkingHistoryService.INSTANCE;
    List<ParkingHistoryDTO> occupiedList = parkingHistoryService.getOccupied();

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
    <link rel="stylesheet" href="mainboard.css">

    <!-- 영수증 css -->
    <link rel="stylesheet" href="receipt.css">
</head>
<body>
<!-- 공통 header 구역 -->
<%@ include file="../common/header_main.jsp"%>

<!-- 메인 페이지 -->
<div class="container-fluid mt-4">
    <!-- 주차 현황 요약 -->
    <div class="section-header">
        <h3 class="section-title">주차 현황</h3>
        <p>현재 <b></b>의 차량이 주차되어 있습니다.</p>
    </div>

    <!-- 차량 검색 영역 -->
    <!-- *** 추후 검색 기능 (필터링) 추가 해야 함 !!! *** -->
    <div class="row justify-content-center my-4">
        <div class="col-md-6 d-flex">
            <input type="text" class="form-control" id="inputCarNum" placeholder="차량번호 마지막 4자리를 입력하세요." style="margin-right:20px;">
            <button class="btn btn-secondary px-4 text-nowrap" id="btnCarSearch">검색</button>
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
                <%@ include file="parking_card.jsp" %>
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
                        <%@ include file="parking_card.jsp" %>
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
                        <%@ include file="parking_card.jsp" %>
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
                <%@ include file="parking_card.jsp" %>
                <% } %>
            </div>
        </div>
    </div>
</div>

<!-- 주차 상태 처리 모달 -->
<%@ include file="parking_modal.jsp"%>
<%@include file="membershipPayModal.jsp"%>

<!-- 공통 footer 구역 -->
<%--<%@ include file="../common/footer.jsp"%>--%>

<!-- bootstrap JS (모달 동작용) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- 함수(날짜 형식, 주차 현황 숫자) 로직 JS -->
<script src="main_function.js"></script>

<!-- 검색 모달 JS -->
<script src="main_search.js"></script>

<!-- 요금 계산 로직 JS -->
<script src="main_parking_charge_logic.js"></script>

<!-- 메인 모달 JS -->
<script src="main_modal.js"></script>

<!-- 회원권 결제 모달 JS -->
<script src="main_membershipPay.js"></script>

</body>
</html>