<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container-fluid px-4">
        <!-- 타이틀 -->
        <!-- 로고 만들어서 이미지 넣어도 좋을듯 -->
        <a class="navbar-brand fw-bold me-6" href="#"><b>스마트 주차 관리 시스템</b></a>

        <!-- 모바일 토글 -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMenu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- collapse 안에 전체를 좌우로 나눔 -->
        <div class="collapse navbar-collapse w-100 d-flex justify-content-between" id="navbarMenu">

            <!-- 왼쪽 그룹: 메뉴 -->
            <ul class="navbar-nav gap-3">
                <li class="nav-item"><a class="nav-link active" href="#">대시보드</a></li>
                <li class="nav-item"><a class="nav-link" href="#">회원관리</a></li>
                <li class="nav-item"><a class="nav-link" href="#">설정관리</a></li>
                <li class="nav-item"><a class="nav-link" href="#">통계</a></li>
            </ul>

            <!-- 오른쪽 그룹 -->
            <div class="d-flex align-items-center">
                <!-- 현재 시각 -->
                <div class="text-secondary small" style="margin-right: 16px;">
                    <%
                        LocalDateTime now = LocalDateTime.now();

                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("hh:mm:ss a");

                        String currentTime = now.format(formatter);
                        out.println("현재 접속 시각: " + currentTime);
                    %>
                </div>
                <!-- 로그아웃 버튼 -->
                <button class="btn btn-outline-light btn-sm">로그아웃</button>
            </div>

        </div>
    </div>
</nav>
