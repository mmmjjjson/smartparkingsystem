<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>반월당 스마트 주차 관리 시스템</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* 기본 폰트 설정 */
        body { font-family: Arial, sans-serif;}

        /* 전체 주차 보드 (큰 구역) */
        #parking-board { width:100%; display:flex; justify-content:center; }

        /* 주차장 전체 레이아웃 (도면용) */
        .layout-wrapper {
            width:100%; max-width:1400px; height:65vh; min-height:600px;
            display:flex; justify-content:space-between; align-items:stretch;
            padding:40px; box-sizing:border-box;
        }

        /* 주차장 좌/우 구역 */
        .column { height:100%; display:flex; flex-direction:column; justify-content:space-between; }

        /* 주차장 좌/우 구역 주차 공간 */
        .column .parking-card { width:160px; height:80px; cursor:pointer; }

        /* 주차장 중앙 구역 레이아웃 */
        .center-wrapper { width: calc(5*80px + 4*12px); }

        /* 주차장 중앙 상/하단 구역 */
        .central-column { height:100%; display:flex; flex-direction:column; justify-content:space-between; }
        .center-row { display:flex; gap:12px; }

        /* 주차장 중앙 구역 주차 공간 */
        .central-column .parking-card { width:80px; height:160px; cursor:pointer; }

        /* 공통 (parking_card.jsp) */
        .parking-card { position:relative; border:2px solid #333; border-radius:8px; box-sizing:border-box; display:flex; flex-direction:column; justify-content:center; align-items:center; }
        .box-id { position:absolute; top:6px; left:6px; font-size:11px; } /* 주차 구역 (A-1 ~ A-20) */
        .box-car { position:absolute; top:50%; left:50%; transform:translate(-50%,-50%); font-size:18px; font-weight:bold; } /* 차량 번호 */
        .box-time { position:absolute; bottom:6px; left:50%; transform:translateX(-50%); font-size:10px; color:#555; } /* 주차 시간 */

        /* 주차 공간 상태별 배경 색*/
        .available { background-color: #e1e0e0; }
        .occupied { background-color: #bded8f; }

        /* 영수증 출력 화면 */
        @media print {
            /* 1. 화면의 모든 요소를 아예 제거 (공간도 차지하지 않음) */
            body > * {
                display: none !important;
            }

            /* 2. 모달창과 영수증 영역만 강제로 살려내기 */
            #parkingModal,
            #parkingModal .modal-dialog,
            #parkingModal .modal-content,
            #parkingModal .modal-body,
            #section-receipt,
            #receipt-print-area {
                display: block !important;
                visibility: visible !important;
                position: static !important;
                width: 100% !important;
                margin: 0 !important;
                padding: 0 !important;
                border: none !important;
                box-shadow: none !important;
            }

            /* 3. 영수증 내부의 텍스트와 라인들만 보이게 */
            #receipt-print-area * {
                display: inline-block; /* 레이아웃 유지 */
                visibility: visible !important;
            }

            .d-flex { display: flex !important; } /* 레이아웃 깨짐 방지 */

            /* 4. 불필요한 버튼, 헤더 등은 절대 안 나오게 숨김 */
            .modal-header, .modal-footer, .btn, .d-print-none, .btn-close {
                display: none !important;
            }
        }
    </style>
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
            <input type="text" class="form-control" placeholder="차량번호 마지막 4자리를 입력하세요." style="margin-right:20px;">
            <button class="btn btn-secondary px-4 text-nowrap">검색</button>
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
<%@ include file="../common/footer.jsp"%>

<!-- bootstrap JS (모달 동작용) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- 함수(날짜 형식, 주차 현황 숫자) 로직 JS -->
<script src="main_function.js"></script>

<!-- 메인 모달 JS -->
<script src="main_modal.js"></script>

<!-- 요금 계산 로직 JS -->
<script src="main_parking_charge_logic.js"></script>

</body>
</html>