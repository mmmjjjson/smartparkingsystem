<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>2단계 인증 로그인</title>

  <!-- SB Admin / Bootstrap 5 -->
  <link href="${pageContext.request.contextPath}/css/styles.css" rel="stylesheet">

  <script defer>
    function moveToStep2() {
      document.getElementById("step1").classList.add("d-none");
      document.getElementById("step2").classList.remove("d-none");
    }

    function loginStep1() {
      const email = document.getElementById("email").value;
      const password = document.getElementById("password").value;

      fetch("/auth/login-step1", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, password })
      })
              .then(res => {
                if (res.ok) {
                  moveToStep2();
                } else {
                  alert("아이디 또는 비밀번호가 올바르지 않습니다.");
                }
              });
    }

    function verifyOTP() {
      const otp = document.getElementById("otp").value;

      fetch("/auth/login-step2", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ otp })
      })
              .then(res => {
                if (res.ok) {
                  location.href = "/main";
                } else {
                  alert("인증번호가 올바르지 않습니다.");
                }
              });
    }
  </script>
</head>

<body class="bg-primary">

<div id="layoutAuthentication">
  <div id="layoutAuthentication_content">
    <main>
      <div class="container">
        <div class="row justify-content-center">
          <div class="col-lg-5">
            <div class="card shadow-lg border-0 rounded-lg mt-5">

              <div class="card-header">
                <h3 class="text-center font-weight-light my-4">
                  로그인
                </h3>
              </div>

              <div class="card-body">

                <!-- STEP 1 -->
                <div id="step1">
                  <form onsubmit="event.preventDefault(); loginStep1();">
                    <div class="form-floating mb-3">
                      <input class="form-control" id="email" type="email"
                             placeholder="name@example.com" required>
                      <label for="email">이메일</label>
                    </div>

                    <div class="form-floating mb-3">
                      <input class="form-control" id="password" type="password"
                             placeholder="Password" required>
                      <label for="password">비밀번호</label>
                    </div>

                    <div class="d-flex align-items-center justify-content-between mt-4 mb-0">
                      <button class="btn btn-primary w-100" type="submit">
                        로그인
                      </button>
                    </div>
                  </form>
                </div>

                <!-- STEP 2 -->
                <div id="step2" class="d-none">
                  <div class="small mb-3 text-muted">
                    이메일로 전송된 인증번호를 입력하세요.
                  </div>

                  <form onsubmit="event.preventDefault(); verifyOTP();">
                    <div class="form-floating mb-3">
                      <input class="form-control" id="otp" type="text"
                             placeholder="123456" maxlength="6" required>
                      <label for="otp">인증번호 (6자리)</label>
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                      <button class="btn btn-success w-100" type="submit">
                        인증 완료
                      </button>
                    </div>
                  </form>
                </div>

              </div>

              <div class="card-footer text-center py-3">
                <div class="small">
                  © Your Project
                </div>
              </div>

            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</div>

</body>
</html>
