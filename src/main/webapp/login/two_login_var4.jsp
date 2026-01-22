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

    <style>
        body {
            background-color: #f0f2f5;
        }

        .auth-stepper {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 20px;
            margin-top: 10px;
        }
        .step-item {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            background-color: #dee2e6;
            color: #6c757d;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
        }
        .step-item.active {
            background-color: #0d6efd;
            color: #fff;
        }
        .step-line {
            width: 40px;
            height: 2px;
            background-color: #dee2e6;
        }
    </style>
</head>

<body>

<div id="layoutAuthentication">
    <div id="layoutAuthentication_content">
        <main>
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-xl-4 col-lg-5 col-md-7">
                        <div class="card shadow-lg border-0 rounded-lg mt-5">

                            <!-- HEADER -->
                            <div class="card-header text-center py-4">
                                <h4 class="mb-1">관리자 로그인</h4>

                                <!-- Stepper -->
                                <div class="auth-stepper">
                                    <div id="step1Circle" class="step-item active">1</div>
                                    <div class="step-line"></div>
                                    <div id="step2Circle" class="step-item">2</div>
                                </div>
                            </div>

                            <!-- BODY -->
                            <div class="card-body px-4">

                                <!-- STEP 1 -->
                                <div id="step1">
                                    <!-- ✅ form 태그로 감싸고 onsubmit 추가 -->
                                    <form id="loginForm" onsubmit="submitStep1(event); return false;">
                                        <div class="form-floating mb-3">
                                            <input class="form-control"
                                                   type="text"
                                                   name="username"
                                                   id="username"
                                                   placeholder="admin"
                                                   required>
                                            <label>관리자 아이디</label>
                                        </div>

                                        <div class="form-floating mb-3">
                                            <input class="form-control"
                                                   type="password"
                                                   name="password"
                                                   id="password"
                                                   placeholder="password"
                                                   required>
                                            <label>비밀번호</label>
                                        </div>

                                        <div class="form-check mb-3">
                                            <input class="form-check-input" type="checkbox" id="rememberMe">
                                            <label class="form-check-label" for="rememberMe">
                                                로그인 상태 유지
                                            </label>
                                        </div>

                                        <div class="d-flex justify-content-between align-items-center">
                                            <a class="small" href="password.jsp">비밀번호 찾기</a>
                                            <!-- ✅ type="submit"으로 변경 -->
                                            <button type="submit" class="btn btn-primary px-4">
                                                다음
                                            </button>
                                        </div>
                                    </form>
                                </div>

                                <!-- STEP 3 -->
                                <div id="step3" class="d-none">
                                    <div class="text-center mb-3">
                                        <i class="fas fa-envelope fa-3x text-primary mb-2"></i>
                                        <p class="small text-muted">
                                            등록된 이메일로 전송된 인증번호를 입력하세요.
                                        </p>
                                    </div>

                                    <form id="otpForm" onsubmit="submitStep2(event); return false;">
                                        <div class="form-floating mb-3">
                                            <input class="form-control"
                                                   type="text"
                                                   id="otpCode"
                                                   maxlength="6"
                                                   pattern="[0-9]{6}"
                                                   placeholder="123456"
                                                   required>
                                            <label>인증번호 (6자리)</label>
                                        </div>

                                        <div class="d-flex gap-2">
                                            <button type="button"
                                                    class="btn btn-secondary flex-fill"
                                                    onclick="goBackToStep1()">
                                                이전
                                            </button>
                                            <button type="submit" class="btn btn-success flex-fill">
                                                인증 완료
                                            </button>
                                        </div>
                                    </form>
                                </div>

                            </div>

                            <!-- FOOTER -->
                            <div class="card-footer text-center py-3 small text-muted">
                                🔒 보안을 위해 2단계 인증이 활성화되어 있습니다
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Step 2로 이동
    function goStep2() {
        console.log("✅ Step 2로 이동");
        document.getElementById("step1").classList.add("d-none");
        document.getElementById("step2").classList.remove("d-none");
        document.getElementById("step1Circle").classList.remove("active");
        document.getElementById("step2Circle").classList.add("active");
        document.getElementById("otpCode").focus();
    }

    // Step 1로 돌아가기
    function goBackToStep1() {
        console.log("⬅️ Step 1로 돌아가기");
        document.getElementById("step2").classList.add("d-none");
        document.getElementById("step1").classList.remove("d-none");
        document.getElementById("step2Circle").classList.remove("active");
        document.getElementById("step1Circle").classList.add("active");
        document.getElementById("otpCode").value = '';
    }

    // Step 1 제출 (아이디/비밀번호)
    function submitStep1(event) {
        // ✅ 반드시 preventDefault 호출!
        event.preventDefault();

        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;

        console.log("========== 로그인 요청 시작 ==========");
        console.log("Username:", username);
        console.log("Password:", password);

        if (!username || !password) {
            alert("아이디와 비밀번호를 입력해주세요.");
            return;
        }

        // ✅ URLSearchParams 사용
        const params = new URLSearchParams();
        params.append('username', username);
        params.append('password', password);

        console.log("Params:", params.toString());

        const url = '${pageContext.request.contextPath}/login-step1';
        console.log("Request URL:", url);

        fetch(url, {
            method: 'POST',  // ✅ POST 명시
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: params.toString()
        })
            .then(response => {
                console.log("Response Status:", response.status);
                console.log("Response OK:", response.ok);

                if (response.ok) {
                    console.log("✅ 인증 성공!");
                    return response.json();
                } else {
                    console.log("❌ 인증 실패!");
                    throw new Error('Authentication failed');
                }
            })
            .then(data => {
                console.log("Response Data:", data);
                if (data.success) {
                    console.log("OTP:", data.otp);
                    goStep2();
                } else {
                    alert(data.message || "인증에 실패했습니다.");
                }
            })
            .catch(error => {
                console.error("Error:", error);
                alert("서버 통신 중 오류가 발생했습니다.");
            });

        console.log("========== 요청 전송 완료 ==========");
    }

    // Step 2 제출 (OTP 인증)
    function submitStep2(event) {
        event.preventDefault();

        const otpCode = document.getElementById('otpCode').value;

        console.log("OTP 입력:", otpCode);

        if (otpCode.length !== 6) {
            alert("6자리 인증번호를 입력해주세요.");
            return;
        }

        // TODO: 서버에 OTP 검증 요청
        alert("로그인 성공! (OTP 검증은 추후 구현)");
        window.location.href = '${pageContext.request.contextPath}/index.jsp';
    }

    // 숫자만 입력
    document.addEventListener('DOMContentLoaded', function() {
        const otpInput = document.getElementById('otpCode');
        if (otpInput) {
            otpInput.addEventListener('input', function(e) {
                this.value = this.value.replace(/[^0-9]/g, '');
            });
        }
    });
</script>

</body>
</html>