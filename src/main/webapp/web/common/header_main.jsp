<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/main"><b>스마트 주차 관리 시스템</b></a>

        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/main">대시보드</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/member_list.do">회원 관리</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/setting">설정 관리</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/statistic">통계</a></li>
            </ul>
        </div>

        <span class="navbar-text">
        <ul class="navbar-nav d-flex flex-row gap-3 p-0 m-0" style="align-items: center;">
            <li class="nav-item">
                <a href="#" class="text-white text-decoration-none">MyPage</a>
            </li>
            <li class="nav-item">
                <a href="#" class="text-white text-decoration-none">로그아웃</a>
            </li>
        </ul>
      </span>
    </div>
</nav>