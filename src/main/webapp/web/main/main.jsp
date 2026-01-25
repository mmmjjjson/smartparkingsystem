<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>반월당 스마트 주차 관리 시스템</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 20px;
            font-family: Arial, sans-serif;
        }
        #parking-board {
            display: flex;
            justify-content: space-between;
            height: 80%;
            flex-wrap: nowrap;
            overflow-x: auto;
        }
        .column {
            display: flex;
            flex-direction: column;
            gap: 10px;
            flex-shrink: 0;
        }
        .central-column {
            display: flex;
            flex-direction: column;
            justify-content: space-between; /* 상단/하단 붙이기 */
            flex-shrink: 0;
        }
        .row {
            display: flex;
            flex-direction: row;
            gap: 10px;
            flex-shrink: 0;
        }
        .parking-card { width: 120px; height: 80px; border: 2px solid #333; border-radius: 8px; display: flex; justify-content: center; align-items: center; font-weight: bold; text-align: center; cursor: pointer; }
        .parking-card.available { background-color: #d4edda; }
        .parking-card.occupied { background-color: #f8d7da; }
    </style>
</head>
<body>
    <%@ include file="../common/header.jsp"%>
    <div class="container mt-4">
        <!-- 검색 페이지 -->
        <div class="row justify-content-center my-4">
            <div class="col-md-6 d-flex">
                <input type="text" class="form-control"
                       placeholder="검색할 차량번호 마지막 4자리를 입력하세요." style="margin-right: 20px;">›
                <button class="btn btn-secondary">검색</button>
            </div>
        </div>

        <!-- 주차 현황 메인 보드 -->
        <hr>
        <h3>주차 현황</h3>
        <p>현재 <b>0대</b>의 차량이 주차되어 있습니다.</p>

        <!-- 주차 구역 카드 -->
        <div id="parking-board">
            <!-- 좌측 구역 -->
            <div class="column">
                <%
                    for(int i=1;i<=5;i++){
                        request.setAttribute("id", i);
                        request.setAttribute("number", i);
                        request.setAttribute("status", i%2==1 ? "available" : "occupied");
                %><jsp:include page="parking_card.jsp" /><%
                }
            %>
            </div>
            <!-- 중앙 상단 구역 -->
            <div class="central-column">
                <div class="row">
                    <%
                        for(int i=6;i<=10;i++){
                            request.setAttribute("id", i);
                            request.setAttribute("number", i);
                            request.setAttribute("status", i%2==1 ? "available" : "occupied");
                    %><jsp:include page="parking_card.jsp" /><%
                    }
                %>
                </div>
                <!-- 중앙 하단 구역-->
                <div class="row">
                    <%
                        for(int i=11;i<=15;i++){
                            request.setAttribute("id", i);
                            request.setAttribute("number", i);
                            request.setAttribute("status", i%2==1 ? "available" : "occupied");
                    %><jsp:include page="parking_card.jsp" /><%
                    }
                %>
                </div>
            </div>
            <!-- 우측 구역-->
            <div class="column">
                <%
                    for(int i=16;i<=20;i++){
                        request.setAttribute("id", i);
                        request.setAttribute("number", i);
                        request.setAttribute("status", i%2==1 ? "available" : "occupied");
                %><jsp:include page="parking_card.jsp" /><%
                }
            %>
            </div>
            </div>
        </div>

        <script src="main.js"></script>
    </div>
    <%@ include file="../common/footer.jsp"%>
</body>
</html>