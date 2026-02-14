<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>관리자 로그인</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="/web/css/styles.css" rel="stylesheet"/>
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <script src="/web/js/loading.js"></script>
    <script src="/web/js/login.js"></script>

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

                                        <div class="d-flex justify-content-between align-items-center">
                                            <a class="small" href="/password">비밀번호 재설정</a>
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
                                        <p class="small text-muted" id="emailText">
                                        </p>
                                    </div>
                                    <div class="text-center mb-4">
                                        <span class="badge bg-info" id="timer">남은 시간: 4:00</span>
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
                                            <button type="submit" class="btn btn-success flex-fill" id="loginOtp">
                                                인증 완료
                                            </button>
                                        </div>
                                    </form>
                                </div>

                            </div>

                            <!-- FOOTER -->
                            <div class="card-footer text-center py-3 small text-muted">
                                🔒 보안을 위해 단계별 인증이 활성화되어 있습니다
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
<script>
    // 개발자도구 금지
    (function() {
        // 우클릭 방지
        document.addEventListener('contextmenu', e => e.preventDefault());

        // F12, Ctrl+Shift+I, Ctrl+Shift+J, Ctrl+U 차단
        document.addEventListener('keydown', function(e) {
            if (e.key === 'F12' ||
                (e.ctrlKey && e.shiftKey && e.key === 'I') ||
                (e.ctrlKey && e.shiftKey && e.key === 'J') ||
                (e.ctrlKey && e.key === 'U')) {
                e.preventDefault();
                return false;
            }
        });
    })();
</script>
</html>