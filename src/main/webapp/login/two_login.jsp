<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <title>로그인 - 관리자 시스템</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="css/styles.css" rel="stylesheet"/>
  <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
  <style>
    body {
      background-color: #f0f2f5;
    }
    .otp-input-group {
      display: flex;
      gap: 10px;
      justify-content: center;
    }
    .otp-input {
      width: 50px;
      height: 50px;
      text-align: center;
      font-size: 24px;
      font-weight: bold;
      border: 2px solid #ced4da;
      border-radius: 8px;
    }
    .otp-input:focus {
      border-color: #0d6efd;
      box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
      outline: none;
    }
    .step-indicator {
      display: flex;
      justify-content: center;
      margin-bottom: 30px;
      gap: 10px;
    }
    .step {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      background-color: #e9ecef;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: bold;
      color: #6c757d;
    }
    .step.active {
      background-color: #0d6efd;
      color: white;
    }
    .step.completed {
      background-color: #198754;
      color: white;
    }
    .step-line {
      width: 60px;
      height: 2px;
      background-color: #e9ecef;
      margin-top: 19px;
    }
    .step-line.active {
      background-color: #198754;
    }
    #step2 {
      display: none;
    }
    .timer {
      color: #dc3545;
      font-weight: bold;
    }
  </style>
</head>
<body>
<div id="layoutAuthentication">
  <div id="layoutAuthentication_content">
    <main>
      <div class="container">
        <div class="row justify-content-center">
          <div class="col-lg-5">
            <div class="card shadow-lg border-0 rounded-lg mt-5">
              <div class="card-header">
                <h3 class="text-center font-weight-light my-4">관리자 로그인</h3>

                <!-- 단계 표시 -->
                <div class="step-indicator">
                  <div class="step active" id="stepNum1">1</div>
                  <div class="step-line" id="stepLine1"></div>
                  <div class="step" id="stepNum2">2</div>
                </div>
              </div>

              <div class="card-body">
                <!-- STEP 1: 기본 로그인 -->
                <div id="step1">
                  <form id="loginForm">
                    <div class="form-floating mb-3">
                      <input class="form-control" id="inputEmail" type="email"
                             placeholder="name@example.com" required/>
                      <label for="inputEmail">관리자 아이디</label>
                    </div>
                    <div class="form-floating mb-3">
                      <input class="form-control" id="inputPassword" type="password"
                             placeholder="Password" required/>
                      <label for="inputPassword">비밀번호</label>
                    </div>
                    <div class="form-check mb-3">
                      <input class="form-check-input" id="inputRememberPassword" type="checkbox"/>
                      <label class="form-check-label" for="inputRememberPassword">로그인 상태 유지</label>
                    </div>
                    <div class="d-flex align-items-center justify-content-between mt-4 mb-0">
                      <a class="small" href="password.jsp">비밀번호 찾기</a>
                      <button class="btn btn-primary" type="submit">다음</button>
                    </div>
                  </form>
                </div>

                <!-- STEP 2: OTP 인증 -->
                <div id="step2">
                  <div class="text-center mb-4">
                    <i class="fas fa-shield-alt fa-3x text-primary mb-3"></i>
                    <h5>2차 인증</h5>
                    <p class="text-muted small">
                      등록된 이메일/SMS로 전송된<br/>
                      6자리 인증코드를 입력해주세요
                    </p>
                    <p class="small">
                      남은 시간: <span class="timer" id="timer">03:00</span>
                    </p>
                  </div>

                  <form id="otpForm">
                    <div class="otp-input-group mb-4">
                      <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required/>
                      <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required/>
                      <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required/>
                      <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required/>
                      <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required/>
                      <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required/>
                    </div>

                    <div class="text-center mb-3">
                      <button type="button" class="btn btn-link small" id="resendOtp">
                        인증코드 재전송
                      </button>
                    </div>

                    <div class="d-flex gap-2">
                      <button class="btn btn-secondary flex-fill" type="button" id="backBtn">
                        이전
                      </button>
                      <button class="btn btn-primary flex-fill" type="submit">
                        로그인
                      </button>
                    </div>
                  </form>
                </div>
              </div>
            </div>

            <!-- 2차 인증 방법 선택 옵션 (선택사항) -->
            <div class="text-center mt-3">
              <small class="text-muted">
                <i class="fas fa-lock"></i> 보안을 위해 2단계 인증이 활성화되어 있습니다
              </small>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>

  <div id="layoutAuthentication_footer">
    <footer class="py-4 bg-light mt-auto">
      <div class="container-fluid px-4">
        <div class="d-flex align-items-center justify-content-between small">
          <div class="text-muted">Copyright &copy; Admin System 2026</div>
          <div>
            <a href="#">Privacy Policy</a>
            &middot;
            <a href="#">Terms &amp; Conditions</a>
          </div>
        </div>
      </div>
    </footer>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Step 1: 로그인 폼 제출
  document.getElementById('loginForm').addEventListener('submit', function(e) {
    e.preventDefault();

    const email = document.getElementById('inputEmail').value;
    const password = document.getElementById('inputPassword').value;

    // TODO: 실제로는 서버에 로그인 요청을 보내야 합니다
    // Ajax로 서버에 인증 요청 후 성공하면 OTP 전송

    // 데모: 로그인 성공 시뮬레이션
    if (email && password) {
      // OTP 전송 (실제로는 서버에서 처리)
      sendOTP(email);

      // Step 2로 이동
      moveToStep2();
    }
  });

  // Step 2로 이동
  function moveToStep2() {
    document.getElementById('step1').style.display = 'none';
    document.getElementById('step2').style.display = 'block';

    // 단계 표시 업데이트
    document.getElementById('stepNum1').classList.remove('active');
    document.getElementById('stepNum1').classList.add('completed');
    document.getElementById('stepLine1').classList.add('active');
    document.getElementById('stepNum2').classList.add('active');

    // 타이머 시작
    startTimer();
  }

  // OTP 입력 자동 포커스
  const otpInputs = document.querySelectorAll('.otp-input');
  otpInputs.forEach((input, index) => {
    input.addEventListener('input', function(e) {
      if (this.value.length === 1) {
        // 다음 입력칸으로 이동
        if (index < otpInputs.length - 1) {
          otpInputs[index + 1].focus();
        }
      }
    });

    input.addEventListener('keydown', function(e) {
      // Backspace 시 이전 칸으로 이동
      if (e.key === 'Backspace' && !this.value && index > 0) {
        otpInputs[index - 1].focus();
      }
    });

    // 숫자만 입력 가능
    input.addEventListener('keypress', function(e) {
      if (!/[0-9]/.test(e.key)) {
        e.preventDefault();
      }
    });

    // 붙여넣기 지원
    input.addEventListener('paste', function(e) {
      e.preventDefault();
      const pastedData = e.clipboardData.getData('text').slice(0, 6);
      if (/^\d+$/.test(pastedData)) {
        pastedData.split('').forEach((char, i) => {
          if (otpInputs[i]) {
            otpInputs[i].value = char;
          }
        });
        if (pastedData.length < 6) {
          otpInputs[pastedData.length].focus();
        }
      }
    });
  });

  // OTP 폼 제출
  document.getElementById('otpForm').addEventListener('submit', function(e) {
    e.preventDefault();

    // OTP 값 수집
    let otpValue = '';
    otpInputs.forEach(input => {
      otpValue += input.value;
    });

    if (otpValue.length === 6) {
      // TODO: 서버에 OTP 검증 요청
      console.log('OTP 검증:', otpValue);

      // 데모: 성공 시뮬레이션
      alert('로그인 성공!');
      window.location.href = 'index.html';
    } else {
      alert('6자리 인증코드를 모두 입력해주세요.');
    }
  });

  // 이전 버튼
  document.getElementById('backBtn').addEventListener('click', function() {
    document.getElementById('step2').style.display = 'none';
    document.getElementById('step1').style.display = 'block';

    document.getElementById('stepNum2').classList.remove('active');
    document.getElementById('stepNum1').classList.remove('completed');
    document.getElementById('stepNum1').classList.add('active');
    document.getElementById('stepLine1').classList.remove('active');

    // OTP 입력 초기화
    otpInputs.forEach(input => input.value = '');

    // 타이머 중지
    if (timerInterval) {
      clearInterval(timerInterval);
    }
  });

  // OTP 재전송
  document.getElementById('resendOtp').addEventListener('click', function() {
    const email = document.getElementById('inputEmail').value;
    sendOTP(email);
    alert('인증코드가 재전송되었습니다.');

    // 타이머 재시작
    if (timerInterval) {
      clearInterval(timerInterval);
    }
    startTimer();
  });

  // OTP 전송 함수 (실제로는 서버 API 호출)
  function sendOTP(email) {
    console.log('OTP 전송:', email);
    // TODO: Ajax로 서버에 OTP 전송 요청
    /*
    fetch('/api/auth/send-otp', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({email: email})
    });
    */
  }

  // 타이머
  let timerInterval;
  function startTimer() {
    let timeLeft = 180; // 3분
    const timerElement = document.getElementById('timer');

    timerInterval = setInterval(function() {
      timeLeft--;

      const minutes = Math.floor(timeLeft / 60);
      const seconds = timeLeft % 60;
      timerElement.textContent =
              String(minutes).padStart(2, '0') + ':' +
              String(seconds).padStart(2, '0');

      if (timeLeft <= 0) {
        clearInterval(timerInterval);
        alert('인증 시간이 만료되었습니다. 다시 시도해주세요.');
        document.getElementById('backBtn').click();
      }
    }, 1000);
  }
</script>
</body>
</html>