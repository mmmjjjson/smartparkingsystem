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

    <%-- 템플릿 수정 css --%>
    <style>
        /* 배경색 */
        body {
            background-color: #f0f2f5;
        }

        /* step 박스 */
        .auth-stepper {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 20px;
            margin-top: 10px;
        }

        /* step 안쪽 스타일 */
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

        /*  step 활성화 */
        .step-item.active {
            background-color: #0d6efd;
            color: #fff;
        }

        /* step 선 */
        .step-line {
            width: 40px;
            height: 2px;
            background-color: #dee2e6;
        }
    </style>
</head>
<%-- 아이콘 --%>
<link rel="icon" href="data:,">

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
                                    <div class="step-line"></div>
                                    <div id="step3Circle" class="step-item">3</div>
                                </div>
                            </div>

                            <!-- BODY -->
                            <div class="card-body px-4">

                                <!-- STEP 1 -->
                                <div id="step1">
                                    <form id="loginForm" onsubmit="submitStep1(event); return false;">
                                        <div class="form-floating mb-3">
                                            <input class="form-control"
                                                   type="text"
                                                   name="adminId"
                                                   id="adminId"
                                                   placeholder="admin"
                                                   <%--required--%>>
                                            <label>관리자 아이디</label>
                                        </div>

                                        <div class="form-floating mb-3">
                                            <input class="form-control"
                                                   type="password"
                                                   name="password"
                                                   id="password"
                                                   placeholder="password"
                                            <%--required--%>>
                                            <label>비밀번호</label>
                                        </div>

                                        <div class="form-check mb-3">
                                            <input class="form-check-input" type="checkbox" id="rememberMe">
                                            <label class="form-check-label" for="rememberMe">
                                                로그인 상태 유지
                                            </label>
                                        </div>

                                        <div class="d-flex justify-content-between align-items-center">
                                            <a class="small" href="password.jsp">비밀번호 재설정</a>
                                            <button type="submit" class="btn btn-primary px-4">
                                                다음
                                            </button>
                                        </div>
                                    </form>
                                </div>

                                <!-- STEP 2 (이메일 입력) -->
                                <div id="step2" class="d-none">
                                    <form onsubmit="submitEmailStep(event); return false;">
                                        <div class="form-floating mb-3">
                                            <input class="form-control" id="email" type="email"
                                                   placeholder="name@example.com" <%--required--%>>
                                            <label for="email">이메일</label>
                                        </div>
                                        <div class="d-flex gap-2">
                                            <button type="button"
                                                    class="btn btn-secondary flex-fill"
                                                    onclick="goBackToStep1()">
                                                이전
                                            </button>
                                            <button type="submit" class="btn btn-primary flex-fill">
                                                다음
                                            </button>
                                        </div>
                                    </form>
                                </div>

                                <!-- STEP 3 (OTP 인증) -->
                                <div id="step3" class="d-none">
                                    <div class="text-center mb-3">
                                        <i class="fas fa-envelope fa-3x text-primary mb-2"></i>
                                        <p class="small text-muted">
                                            등록된 이메일로 전송된 인증번호를 입력하세요.
                                        </p>
                                    </div>

                                    <form id="otpForm" onsubmit="submitStep3(event); return false;">
                                        <div class="form-floating mb-3">
                                            <input class="form-control"
                                                   type="text"
                                                   id="otpCode"
                                                   maxlength="6"
                                                   pattern="[0-9]{6}"
                                                   placeholder="123456"
                                            <%--required--%>>
                                            <label>인증번호 (6자리)</label>
                                        </div>

                                        <div class="d-flex gap-2">
                                            <button type="button"
                                                    class="btn btn-secondary flex-fill"
                                                    onclick="goBackToStep2()">
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
    const contextPath = "${pageContext.request.contextPath}"; // 절대 경로

    // Step 2로 이동
    function goStep2() {
        console.log("✅ Step 2로 이동");
        document.getElementById("step1").classList.add("d-none");
        document.getElementById("step2").classList.remove("d-none");
        document.getElementById("step1Circle").classList.remove("active");
        document.getElementById("step2Circle").classList.add("active");
        document.getElementById("email").focus();
    }

    // Step 3로 이동
    function goStep3() {
        console.log("✅ Step 3로 이동");
        document.getElementById("step2").classList.add("d-none");
        document.getElementById("step3").classList.remove("d-none");
        document.getElementById("step2Circle").classList.remove("active");
        document.getElementById("step3Circle").classList.add("active");
        document.getElementById("otpCode").focus();
    }

    // Step 1로 돌아가기
    function goBackToStep1() {
        console.log("⬅️ Step 1로 돌아가기");
        document.getElementById("step2").classList.add("d-none");
        document.getElementById("step1").classList.remove("d-none");
        document.getElementById("step2Circle").classList.remove("active");
        document.getElementById("step1Circle").classList.add("active");
        document.getElementById("email").value = '';
    }

    // Step 2로 돌아가기
    function goBackToStep2() {
        console.log("⬅️ Step 2로 돌아가기");
        document.getElementById("step3").classList.add("d-none");
        document.getElementById("step2").classList.remove("d-none");
        document.getElementById("step3Circle").classList.remove("active");
        document.getElementById("step2Circle").classList.add("active");
        document.getElementById("otpCode").value = '';
    }

    // Step 1 제출 (아이디/비밀번호) - 테스트용
    function submitStep1(event) {
        event.preventDefault(); // 새로고침 방지

        const adminId = document.getElementById('adminId').value;
        const password = document.getElementById('password').value;

        if (!adminId || !password) {
            alert("아이디와 비밀번호를 입력해주세요.");
            return;
        }

        // Servlet 연동
        fetch(contextPath + "/login", {
            method: "POST",
            credentials: "same-origin",
            headers: { // form값이 전송하는 파라미터를 받기위해 설정
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "step=1&adminId=" + adminId + "&password=" + password
        })
            .then(res => {
                if (res.status === 200) {
                    goStep2();
                } else {
                    alert("아이디 또는 비밀번호가 잘못 되었습니다. 아이디와 비밀번호를 정확히 입력해 주세요.")
                }
            })
    }

    // Step 2 제출 (이메일 확인) - 테스트용
    function submitEmailStep(event) {
        event.preventDefault();

        const email = document.getElementById('email').value;
        if (!email) {
            alert("이메일을 입력해주세요.");
            return;
        }

        fetch(contextPath + "/login", {
            method: "POST",
            credentials: "same-origin",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "step=2&email=" + email
        })
            .then(res => {
                if (res.status === 200) {
                    goStep3();
                } else {
                    alert('등록된 이메일과 일치하지 않습니다.')
                }
            })
    }

    // Step 3 제출 (OTP 인증) - 테스트용
    function submitStep3(event) {
        event.preventDefault();

        const otpCode = document.getElementById('otpCode').value;

        console.log("========== OTP 인증 요청 (테스트 모드) ==========");
        console.log("OTP 입력:", otpCode);

        if (otpCode.length !== 6) {
            alert("6자리 인증번호를 입력해주세요.");
            return;
        }

        fetch(contextPath + "/login", {
            method: "POST",
            credentials: "same-origin",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "step=3&otpCode=" + otpCode
        })
        .then(res => {
            if (res.status === 200) {
                alert("OTP 인증 성공")
                window.location.href = "../web/main/main.jsp";
            } else {
                alert("OTP Error 인증번호 오류")
            }
        })

    }

    // 숫자만 입력 (필터링)
    document.addEventListener('DOMContentLoaded', function() {
        const otpInput = document.getElementById('otpCode');
        if (otpInput) {
            otpInput.addEventListener('input', function(e) {  // 화살표 함수 대신 일반 function 사용
                this.value = this.value.replace(/[^0-9]/g, '');
            });
        }
    });

    //============================= JS 하드코딩 =============================

    <%--// 테스트용 계정 정보--%>
    <%--const TEST_ACCOUNT = {--%>
    <%--    username: 'admin',--%>
    <%--    password: 'admin1234',--%>
    <%--    email: 'admin@example.com',--%>
    <%--    otp: '123456'--%>
    <%--};--%>
    <%--// Step 1 제출 (아이디/비밀번호) - 테스트용--%>
    <%--function submitStep1(event) {--%>
    <%--    event.preventDefault();--%>

    <%--    const username = document.getElementById('username').value;--%>
    <%--    const password = document.getElementById('password').value;--%>

    <%--    console.log("========== 로그인 요청 시작 (테스트 모드) ==========");--%>

    <%--    // 테스트용: 하드코딩된 값과 비교--%>
    <%--    if (username === TEST_ACCOUNT.username && password === TEST_ACCOUNT.password) {--%>
    <%--        console.log("✅ 인증 성공! Step 2로 이동");--%>
    <%--        goStep2();--%>
    <%--    } else {--%>
    <%--        alert("아이디 또는 비밀번호가 일치하지 않습니다.");--%>
    <%--        console.log("❌ 인증 실패!");--%>
    <%--    }--%>

    <%--    console.log("========== 요청 처리 완료 ==========");--%>
    <%--}--%>

    <%--// Step 2 제출 (이메일 확인) - 테스트용--%>
    <%--function submitEmailStep(event) {--%>
    <%--    event.preventDefault();--%>

    <%--    const email = document.getElementById('email').value;--%>

    <%--    console.log("========== 이메일 확인 요청 (테스트 모드) ==========");--%>
    <%--    console.log("Email:", email);--%>

    <%--    if (!email) {--%>
    <%--        alert("이메일을 입력해주세요.");--%>
    <%--        return;--%>
    <%--    }--%>

    <%--    // 테스트용: 하드코딩된 이메일과 비교--%>
    <%--    if (email === TEST_ACCOUNT.email) {--%>
    <%--        console.log("✅ 이메일 확인 완료");--%>
    <%--        console.log("📧 OTP 전송됨 (테스트용):", TEST_ACCOUNT.otp);--%>
    <%--        alert(`인증번호가 ${email}로 전송되었습니다.\n(테스트용 OTP: ${TEST_ACCOUNT.otp})`);--%>
    <%--        goStep3();--%>
    <%--    } else {--%>
    <%--        alert("등록되지 않은 이메일입니다.");--%>
    <%--        console.log("❌ 이메일 불일치");--%>
    <%--    }--%>
    <%--}--%>

    <%--// Step 3 제출 (OTP 인증) - 테스트용--%>
    <%--function submitStep3(event) {--%>
    <%--    event.preventDefault();--%>

    <%--    const otpCode = document.getElementById('otpCode').value;--%>

    <%--    console.log("========== OTP 인증 요청 (테스트 모드) ==========");--%>
    <%--    console.log("OTP 입력:", otpCode);--%>

    <%--    if (otpCode.length !== 6) {--%>
    <%--        alert("6자리 인증번호를 입력해주세요.");--%>
    <%--        return;--%>
    <%--    }--%>

    <%--    // 테스트용: 하드코딩된 OTP와 비교--%>
    <%--    if (otpCode === TEST_ACCOUNT.otp) {--%>
    <%--        console.log("✅ OTP 인증 성공!");--%>
    <%--        alert("로그인 성공!");--%>
    <%--        window.location.href = '../web/main/main.jsp';--%>
    <%--    } else {--%>
    <%--        alert("인증번호가 일치하지 않습니다.");--%>
    <%--        console.log("❌ OTP 불일치");--%>
    <%--    }--%>
    <%--}--%>

    <%--// 숫자만 입력--%>
    <%--document.addEventListener('DOMContentLoaded', function() {--%>
    <%--    const otpInput = document.getElementById('otpCode');--%>
    <%--    if (otpInput) {--%>
    <%--        otpInput.addEventListener('input', function(e) {--%>
    <%--            this.value = this.value.replace(/[^0-9]/g, '');--%>
    <%--        });--%>
    <%--    }--%>
    <%--});--%>
</script>

</body>
</html>