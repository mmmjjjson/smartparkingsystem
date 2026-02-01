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
    </style>
</head>
<body>
<!-- 공통 header 구역 -->
<%@ include file="../common/header_2.jsp"%>

<!-- 메인 페이지 -->
<div class="container-fluid mt-4">
    <!-- 차량 검색 영역 -->
    <!-- *** 추후 검색 기능 (필터링) 추가 해야 함 !!! *** -->
    <div class="row justify-content-center my-4">
        <div class="col-md-6 d-flex">
            <input type="text" class="form-control" placeholder="검색할 차량번호 마지막 4자리를 입력하세요." style="margin-right:20px;">
            <button class="btn btn-secondary px-4 text-nowrap">검색</button>
        </div>
    </div>

    <hr>

    <!-- 주차 현황 요약 -->
    <!-- *** 추후 주차된 차량 수 반영 기능 추가해야 함 !!! *** --->
    <h3>주차 현황</h3>
    <p>현재 <b>0대</b>의 차량이 주차되어 있습니다.</p>

    <!-- 주차 구역 메인 보드 -->
    <div id="parking-board">
        <div class="layout-wrapper">
            <!-- 좌측 주차 구역 A1 ~ A5 (세로 정렬) -->
            <div class="column">
                <% for(int i=1;i<=5;i++){
                    request.setAttribute("id","A-"+i);
                    // 목업 데이터
                    // *** 추후 DB 값 대체 !!! ***
                    if (i == 4) {
                        request.setAttribute("status","occupied");
                        request.setAttribute("car", "34가5678"); // 테스트 해보니 차량 번호 공백 없어야 할듯
                        request.setAttribute("time", "08:41");
                    } else {
                        //
                        request.setAttribute("status","available");
                        request.setAttribute("car", null);
                        request.setAttribute("time", null);
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
                            request.setAttribute("id","A-"+i);
                            // 목업 데이터
                            // *** 추후 DB 값 대체 !!! ***
                            if (i == 8) {
                                request.setAttribute("status","occupied");
                                request.setAttribute("car", "12나3456");
                                request.setAttribute("time", "09:05");
                            } else {
                                request.setAttribute("status","available");
                                request.setAttribute("car", null);
                                request.setAttribute("time", null);
                            }
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
                    // 목업 데이터
                    // *** 추후 DB 값 대체 !!! ***
                    if (i == 19) {
                        request.setAttribute("status","occupied");
                        request.setAttribute("car", "23다2345");
                        request.setAttribute("time", "10:41");
                    } else {
                        request.setAttribute("status","available");
                        request.setAttribute("car", null);
                        request.setAttribute("time", null);
                    }
                %>
                <%@ include file="parking_card.jsp" %>
                <% } %>
            </div>
        </div>
    </div>
</div>

<!-- 주차 상태 처리 모달 -->
<!-- *** 추후 DB 연동 및 추가 작업 필요 *** -->
<!--- *** 싹 갈아엎고 싶음 ㅜㅜ *** --->
<div class="modal fade" id="parkingModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <!-- 모달 헤더 -->
            <div class="modal-header">
                <h5 class="modal-title">주차 처리</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- 모달 본문 -->
            <div class="modal-body">
                <p id="modal-id"></p>
                <p id="modal-car"></p>
                <p id="modal-time"></p>
            </div>

            <!-- 모달 버튼 -->
            <div class="modal-footer">
                <button type="button" class="btn btn-success" id="modal-action"></button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

<!-- 공통 footer 구역 -->
<%--<%@ include file="../common/footer.jsp"%>--%>

<!-- bootstrap JS (모달 동작용) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    /* 모달 관련 객체 선언
    모달 객체 불러와 정보 가져오기 (주차 구역, 차량 번호, 주차 시간, 주차 구역 상태)
     */
    const modal = new bootstrap.Modal(document.getElementById('parkingModal'));
    const modalTitle = document.getElementById('modal-id');
    const modalCar = document.getElementById('modal-car');
    const modalTime = document.getElementById('modal-time');
    const modalAction = document.getElementById('modal-action');

    // 주차 구역 클릭 이벤트 (클릭 시 정보 모달 팝업)
    document.querySelectorAll('.parking-card').forEach(card => {
        card.addEventListener('click', () => {
            const id = card.querySelector('.box-id').innerText;
            const car = card.querySelector('.box-car').innerText;
            const time = card.querySelector('.box-time').innerText;

            modalTitle.innerText = "구역: " + id;
            modalCar.innerText = car==="사용 가능" ? "빈 자리" : "차량: "+car;
            modalTime.innerText = time || "";

            // 주차 상태에 따른 버튼 변경
            if(car==="사용 가능") {
                modalAction.innerText = "입차 처리";
                modalAction.classList.replace('btn-danger','btn-success');
            } else {
                modalAction.innerText = "출차 처리";
                modalAction.classList.replace('btn-success','btn-danger');
            }

            modal.show();
        });
    });

    // 입차, 출차 처리 버튼
    // *** 추후 AJAX(화면 새로고침 없이 상태 변경) + 서버 연동 ***
    modalAction.addEventListener('click', () => {
        // 여기에 입차/출차 처리 로직 연결
        alert(modalAction.innerText + " 완료 (여기서 AJAX 호출 가능)");
        modal.hide();
    });
</script>
</body>
</html>
