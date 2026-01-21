<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
</head>
<body>
    <%@ include file="../common/header.jsp"%>
    <div class="container mt-4">
        <!-- 검색 페이지 -->
        <div class="row justify-content-center my-4">
            <div class="col-md-6 d-flex">
                <input type="text" class="form-control"
                       placeholder="검색할 차량번호 마지막 4자리를 입력하세요." style="margin-right: 20px;">
                <button class="btn btn-secondary">검색</button>
            </div>
        </div>

        <!-- 주차 현황 메인 보드 -->
        <hr>
        <h3>주차 현황</h3>
        <p>현재 <b>0대</b>의 차량이 주차되어 있습니다.</p>
        <div class="row">
            <!-- 주차 좌측 구역 -->
            <div class="col-2">
                <div class="d-flex flex-column gap-3">
                    <!-- parking_box include -->
                </div>
            </div>
            <!-- 주차 중앙 구역 -->
            <div class="col-8">
                <!-- 중앙 상단 구역 -->
                <div class="d-flex justify-content-center gap-3 mb-4">
                    <!-- parking_box include -->
                </div>
                <!-- 중앙 하단 구역 -->
                <div class="d-flex justify-content-center gap-3">
                    <!-- parking_box include -->
                </div>
            </div>
            <!-- 주차 우측 구역 -->
            <div class="col-2">
                <div class="d-flex flex-column gap-3">
                    <!-- parking_box include -->
                </div>
            </div>
        </div>
    </div>
    <%@ include file="../common/footer.jsp"%>
</body>
</html>