<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>비밀번호 재설정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <link href="/web/css/styles.css" rel="stylesheet"/>
    <script src="/web/js/password.js"></script>
</head>
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
                                <h4 class="mb-1">비밀번호 재설정</h4>
                            </div>

                            <!-- BODY -->
                            <div class="card-body px-4">

                                <!-- STEP 1: 아이디 입력 -->
                                <div id="step1">
                                    <div class="text-center mb-3">
                                        <p class="small text-muted">
                                            비밀번호를 재설정할 관리자 아이디를 입력해주세요.
                                        </p>
                                    </div>
                                    <form id="adminIdForm" onsubmit="submitStep1(event); return false;">
                                        <div class="form-floating mb-3">
                                            <input class="form-control"
                                                   type="text"
                                                   id="inputAdminId"
                                                   placeholder="admin"
                                            <%--required--%>>
                                            <label>관리자 아이디</label>
                                        </div>

                                        <div class="d-flex justify-content-between align-items-center">
                                            <a class="small" href="/login">로그인 화면</a>
                                            <button type="submit" class="btn btn-primary px-4">
                                                다음
                                            </button>
                                        </div>
                                    </form>
                                </div>

                                <!-- STEP 2: 이메일 입력 및 인증번호 요청 -->
                                <div id="step2" class="d-none">
                                    <div class="text-center mb-3">
                                        <p class="small text-muted">
                                            등록된 이메일 주소를 입력하면 인증번호를 보내드립니다.
                                        </p>
                                    </div>
                                    <form id="emailForm" onsubmit="submitStep2(event); return false;">
                                        <div class="input-group mb-3">
                                            <input class="form-control"
                                                   type="email"
                                                   name="email"
                                                   id="inputEmail"
                                                   placeholder="이메일"
                                            <%--required--%>>
                                            <button type="submit" class="btn btn-primary px-3">
                                                인증하기
                                            </button>
                                        </div>

                                        <div class="d-flex gap-2">
                                            <button type="button"
                                                    class="btn btn-secondary flex-fill"
                                                    onclick="goBackToStep1()">
                                                이전
                                            </button>
                                        </div>
                                    </form>
                                </div>

                                <!-- STEP 3: 인증번호 입력 -->
                                <div id="step3" class="d-none">
                                    <div class="text-center mb-3">
                                        <i class="fas fa-envelope fa-3x text-primary mb-2"></i>
                                        <p class="small text-muted" id="emailText">
                                        </p>
                                    </div>

                                    <form id="verificationForm" onsubmit="submitStep3(event); return false;">
<%--                                        <div class="form-floating mb-3">--%>
<%--                                            <input class="form-control"--%>
<%--                                                   type="email"--%>
<%--                                                   id="inputEmail2"--%>
<%--                                                   readonly>--%>
<%--                                            <label>이메일</label>--%>
<%--                                        </div>--%>

                                        <div class="form-floating mb-3">
                                            <input class="form-control"
                                                   type="text"
                                                   id="inputVerificationCode"
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
                                                이메일 변경
                                            </button>
                                            <button type="submit" class="btn btn-primary flex-fill">
                                                다음
                                            </button>
                                        </div>
                                    </form>
                                </div>

                                <!-- STEP 4: 완료 -->
                                <div id="clearStep" class="d-none">
                                    <div class="text-center mb-3">
                                        <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                                        <h5 class="text-success mb-2">비밀번호가 재설정되었습니다!</h5>
                                        <p class="small text-muted">
                                            무작위로 생성된 비밀번호를 등록된 이메일로 발송했습니다.<br>
                                            이메일을 확인하신 후 로그인해주세요.
                                        </p>
                                    </div>

                                    <div class="d-grid">
                                        <a href="/login" class="btn btn-primary">
                                            로그인 화면으로
                                        </a>
                                    </div>
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
<script>

//    // Step 2로 이동
//    function goStep2() {
//        console.log("✅ Step 2로 이동");
//        document.getElementById("step1").classList.add("d-none");
//        document.getElementById("step2").classList.remove("d-none");
//        document.getElementById("inputEmail").focus();
//    }
//
//    // Step 3로 이동
//    function goStep3() {
//        console.log("✅ Step 3로 이동");
//        document.getElementById("step2").classList.add("d-none");
//        document.getElementById("step3").classList.remove("d-none");
//        document.getElementById("inputVerificationCode").focus();
//    }
//
//    // ClearStep 로 이동
//    function ClearStep() {
//        console.log("✅ Clear Step");
//        document.getElementById("step3").classList.add("d-none");
//        document.getElementById("clearStep").classList.remove("d-none");
//    }
//
//    // Step 1로 돌아가기
//    function goBackToStep1() {
//        document.getElementById("step2").classList.add("d-none");
//        document.getElementById("step1").classList.remove("d-none");
//        document.getElementById("inputEmail").value = '';
//    }
//
//    // Step 2로 돌아가기
//    function goBackToStep2() {
//        document.getElementById("step3").classList.add("d-none");
//        document.getElementById("step2").classList.remove("d-none");
//        document.getElementById("inputVerificationCode").value = '';
//    }
//
//    // Step 1 제출 (아이디 확인)
//    function submitStep1(event) {
//        event.preventDefault();
//
//        const adminId = document.getElementById('inputAdminId').value;
//
//        if (!adminId) {
//            alert("관리자 아이디를 입력해주세요.");
//            return;
//        }
//
//        fetch("/password", {
//            method: "POST",
//            headers: {
//                "Content-Type" : "application/x-www-form-urlencoded"
//            },
//            body: "step=1&adminId=" + adminId
//        })
//        goStep2();
//    }
//
//    // Step 2 제출 (이메일 입력 및 인증번호 발송)
//    function submitStep2(event) {
//        event.preventDefault();
//
//        const email = document.getElementById('inputEmail').value;
//        const adminId = document.getElementById('inputAdminId').value;
//
//        if (!email) {
//            alert("이메일을 입력해주세요.");
//            return;
//        }
//
//        fetch("/password", {
//            method: "POST",
//            headers: {
//                "Content-Type" : "application/x-www-form-urlencoded"
//            },
//            body: "step=2&admin=" + adminId + "&email=" + email
//        })
//            .then(res => {
//                if (res.status === 200) {
//                    document.getElementById("emailText").innerText = email + "로 인증번호를 발송했습니다.";
//                    goStep3();
//                } else {
//                    alert('입력하신 정보가 일치하지 않습니다.')
//                }
//            })
//    }
//
//    // Step 3 제출 (인증번호 확인 및 비밀번호 재설정)
//    function submitStep3(event) {
//        event.preventDefault();
//
//        // const email = document.getElementById('verificationForm').value;
//        const otpCode = document.getElementById('inputVerificationCode').value;
//
//        if (otpCode.length !== 6) {
//            alert("6자리 인증번호를 입력해주세요.");
//            return;
//        }
//
//        fetch("/password", {
//            method: "POST",
//            headers: {
//                "Content-Type" : "application/x-www-form-urlencoded"
//            },
//            body: "step=3&otpCode=" + otpCode
//        })
//            .then(res => {
//                if (res.status === 200) {
//                    ClearStep()
//                } else {
//                    alert('OTP Error 인증번호 오류')
//                }
//            })
//    }
//
//    // 숫자만 입력 (필터링)
//    document.addEventListener('DOMContentLoaded', function() {
//        const codeInput = document.getElementById('inputVerificationCode');
//        if (codeInput) {
//            codeInput.addEventListener('input', function(e) {
//                this.value = this.value.replace(/[^0-9]/g, '');
//            });
//        }
//    });

</script>

</body>
</html>