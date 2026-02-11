<%@ page import="com.example.smartparkingsystem.service.AdminService" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<%
    AdminService adminService = AdminService.INSTANCE;
    String adminId = (String) session.getAttribute("adminId");
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

%>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>Title</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="/web/css/styles.css" rel="stylesheet"/>
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <script src="/web/js/myPage.js"></script>

    <style>
        #margin {
            margin-top: 30px;
        }

        .row {
            margin-top: 30px;
        }
    </style>
</head>
<body>
<div class="container-fluid px-4">
    <%-- TODO 조건문 --%>
    <%
        if (adminService.getAdminById(adminId).isPasswordReset()) {
    %>
    <div class="alert alert-warning" id="margin">
        🔐 최초 로그인입니다. 보안을 위해 비밀번호를 변경해주세요.
    </div>
    <%
        }
    %>
    <div class="row">
        <!-- 기본 정보 -->
        <div class="col-lg-6">
            <div class="card mb-4">
                <div class="card-header">
                    <i class="fas fa-user me-1"></i>
                    기본 정보
                </div>
                <form class="card-body">
                    <div>
                        <div class="mb-3">
                            <label class="form-label">아이디</label>
                            <input type="text" class="form-control" value="<%=adminId%>" disabled>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">이름</label>
                            <input type="text" class="form-control"
                                   value="<%=adminService.getAdminById(adminId).getAdminName()%>" disabled>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">이메일</label>
                            <input type="email" class="form-control"
                                   value="<%=adminService.getAdminById(adminId).getAdminEmail()%>">
                        </div>
                        <button class="btn btn-primary">정보 수정</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- 비밀번호 변경 -->
        <form class="col-lg-6" onsubmit="updatePassword(event);return false;">
            <div>
                <div class="card mb-4 border-warning">
                    <div class="card-header bg-warning text-dark">
                        <i class="fas fa-key me-1"></i>
                        비밀번호 변경
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label class="form-label">현재 비밀번호</label>
                            <input type="password" class="form-control" id="password">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">새 비밀번호</label>
                            <input type="password" class="form-control" id="newPassword">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">새 비밀번호 확인</label>
                            <input type="password" class="form-control" id="newPasswordCheck">
                        </div>
                        <button type="submit" class="btn btn-warning w-100">비밀번호 변경</button>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <!-- 로그인 정보 -->
    <div class="card mb-4">
        <div class="card-header">
            <i class="fas fa-clock me-1"></i>
            로그인 정보
        </div>
        <div class="card-body">
            <table class="table table-bordered">
                <tr>
                    <th style="width:30%">최근 로그인</th>
                    <td><%=adminService.getAdminById(adminId).getLastLogin().format(formatter)%>
                    </td>
                </tr>
                <tr>
                    <th>최근 로그인 IP</th>
                    <td><%=adminService.getAdminById(adminId).getLastLoginIp()%>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</div>
</body>
</html>
<script>
    function updatePassword(event) {
        event.preventDefault(); // 새로고침 방지

        const password = document.getElementById("password").value;
        const newPassword = document.getElementById("newPassword").value;
        const newPasswordCheck = document.getElementById("newPasswordCheck").value;

        if (!password) {
            alert('현재 비밀번호를 입력해주세요.')
            return;
        }
        if (!newPassword || !newPasswordCheck) {
            alert('변경하실 비밀번호를 입력해주세요.')
            return;
        }
        if (newPassword !== newPasswordCheck) {
            alert('비밀번호가 일치하지 않습니다.')
            return;
        }

        fetch("/main/mypage", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "password=" + password + "&newPassword=" + newPassword + "&newPasswordCheck=" + newPasswordCheck
        })
            .then(res => {
                if (res.status === 200) {
                    alert("정보 수정 완료")
                    window.location.href = "../../web/main/main.jsp"
                } else {
                    alert("정보가 일치 하지 않습니다.")
                }
            })
    }
</script>
