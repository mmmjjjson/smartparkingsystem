<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <title>관리자 로그인</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="css/styles.css" rel="stylesheet"/>
  <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>

  <script defer>
    // 테스트용 계정 정보
    const TEST_ACCOUNTS = [
      { email: "admin@test.com", password: "admin1234", otp: "123456" },
      { email: "user@test.com", password: "user1234", otp: "654321" },
      { email: "test@example.com", password: "test1234", otp: "111111" }
    ];

    let currentUser = null;

    function moveToStep2() {
      document.getElementById("step1").classList.add("d-none");
      document.getElementById("step2").classList.remove("d-none");
    }

    function loginStep1() {
      const email = document.getElementById("email").value;
      const password = document.getElementById("password").value;

      // Mock API - 실제 fetch 대신 테스트용 계정 확인
      const user = TEST_ACCOUNTS.find(acc => acc.email === email && acc.password === password);

      if (user) {
        currentUser = user;
        alert(`인증번호가 이메일로 전송되었습니다.\n(테스트용 OTP: ${user.otp})`);
        moveToStep2();
      } else {
        alert("아이디 또는 비밀번호가 올바르지 않습니다.");
      }

      /* 실제 서버 연동 시 주석 해제
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
      */
    }

    function verifyOTP() {
      const otp = document.getElementById("otp").value;

      // Mock API - 실제 fetch 대신 저장된 사용자의 OTP 확인
      if (currentUser && currentUser.otp === otp) {
        alert("로그인 성공!");
        // location.href = "/main";
        console.log("로그인 완료:", currentUser.email);
      } else {
        alert("인증번호가 올바르지 않습니다.");
      }

      /* 실제 서버 연동 시 주석 해제
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
      */
    }

    // 페이지 로드 시 테스트 계정 정보 표시
    window.addEventListener('DOMContentLoaded', () => {
      console.log("=== 테스트 계정 정보 ===");
      TEST_ACCOUNTS.forEach((acc, idx) => {
        console.log(`${idx + 1}. 이메일: ${acc.email} / 비밀번호: ${acc.password} / OTP: ${acc.otp}`);
      });
    });
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

                <!-- 테스트 계정 안내 -->
                <div class="alert alert-info alert-dismissible fade show" role="alert">
                  <strong>테스트 계정</strong>
                  <ul class="mb-0 mt-2 small">
                    <li>admin@test.com / admin1234</li>
                    <li>user@test.com / user1234</li>
                    <li>test@example.com / test1234</li>
                  </ul>
                  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>

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
                    <div class="d-flex justify-content-between align-items-center">
                      <a class="small" href="password.jsp">비밀번호 찾기</a>
                      <button type="submit" class="btn btn-primary px-4">
                        다음
                      </button>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>