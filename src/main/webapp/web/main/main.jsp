<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
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
    <!-- 차량 검색 영역 -->
    <!-- *** 추후 검색 기능 (필터링) 추가 해야 함 !!! *** -->
    <div class="row justify-content-center my-4">
        <div class="col-md-6 d-flex">
            <input type="text" class="form-control" id="inputCarNum" placeholder="차량번호 마지막 4자리를 입력하세요." style="margin-right:20px;">
            <button class="btn btn-secondary px-4 text-nowrap" id="btnCarSearch">검색</button>
        </div>
    </div>

    <hr>

    <!-- 주차 현황 요약 -->
    <!-- *** 추후 주차된 차량 수 반영 기능 추가해야 함 !!! *** --->
    <h3>주차 현황</h3>
    <p>현재 <b></b>의 차량이 주차되어 있습니다.</p>

    <!-- 주차 구역 메인 보드 -->
    <div id="parking-board">
        <div class="layout-wrapper">
            <!-- 좌측 주차 구역 A1 ~ A5 (세로 정렬) -->
            <div class="column">
                <% for(int i=1;i<=5;i++){
                    request.setAttribute("id","A-"+i);
                    // *** 추후 DB 값 대체 !!! ***
                    request.setAttribute("status", "available");
                    request.setAttribute("car", null);
                    request.setAttribute("time", null);
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
                            request.setAttribute("id","A-"+i);
                            // *** 추후 DB 값 대체 !!! ***
                            request.setAttribute("status", "available");
                            request.setAttribute("car", null);
                            request.setAttribute("time", null);
                        %>
                        <%@ include file="parking_card.jsp" %>
                        <% } %>
                    </div>
                    <!-- 중앙 주차 하단 구역 A11 ~ A15 -->
                    <div class="center-row">
                        <% for(int i=11;i<=15;i++){
                            // *** 추후 DB 값 대체 !!! ***
                            request.setAttribute("id","A-"+i);
                            request.setAttribute("status","available");
                            request.setAttribute("car", null);
                            request.setAttribute("time", null);
                        %>
                        <%@ include file="parking_card.jsp" %>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- 우측 주차 구역 A16 ~ A20 -->
            <div class="column">
                <% for (int i = 16; i <= 20; i++){
                    request.setAttribute("id","A-"+i);
                    request.setAttribute("status", "available");
                    request.setAttribute("car", null);
                    request.setAttribute("time", null);
                %>
                <%@ include file="parking_card.jsp" %>
                <% } %>
            </div>
        </div>
    </div>
</div>

<!-- 주차 상태 처리 모달 -->
<%@ include file="parking_modal.jsp"%>

<!-- 공통 footer 구역 -->
<%--<%@ include file="../common/footer.jsp"%>--%>

<!-- bootstrap JS (모달 동작용) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- 함수(날짜 형식, 주차 현황 숫자) 로직 JS -->
<script src="main_function.js"></script>

<!-- 검색 모달 JS -->
<script src="main_search.js"></script>

<!-- 메인 모달 JS -->
<script src="main_modal.js"></script>

<!-- 요금 계산 로직 JS -->
<script src="main_parking_charge_logic.js"></script>

</body>
</html>