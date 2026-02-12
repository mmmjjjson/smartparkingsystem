<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<%
    String email = request.getParameter("email");
%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>이메일 인증</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <script src="/web/js/myPage.js"></script>
    <style>
        body {
            padding: 20px;
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="card">
        <div class="card-header bg-primary text-white text-center">
            <h5 class="mb-0">이메일 인증</h5>
        </div>
        <div class="card-body">
            <p class="text-center mb-3">
                <strong><%=email%>
                </strong><br>
                으로 인증번호를 전송했습니다.
            </p>
            <div class="text-center mb-3">
                <span class="badge bg-info" id="timer">03:00</span>
            </div>

            <form id="verifyForm" onsubmit="verifyOTP(event)">
                <div class="mb-3">
                    <label class="form-label">인증번호 (6자리)</label>
                    <input type="text"
                           class="form-control"
                           id="otpCode"
                           maxlength="6"
                           pattern="[0-9]{6}"
                           placeholder="123456"
                    <%--required--%>>
                </div>

                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary" id="verifyBtn">인증 확인</button>
                    <button type="button" class="btn btn-outline-secondary">
                        인증번호 재전송
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>
<script>

    // 타이머
    let timeLeft = 180; // 3분

    function startTimer() {
        const timerEl = document.getElementById("timer");

        const timer = setInterval(function () {

            const minutes = Math.floor(timeLeft / 60);
            const seconds = timeLeft % 60;

            timerEl.innerText =
                "남은 시간: " + minutes + ":" +
                (seconds < 10 ? "0" : "") + seconds;

            timeLeft--;

            // 1분 이하 빨간색으로 변경
            if (timeLeft <= 60) {
                document.getElementById('timer').classList.remove('bg-info');
                document.getElementById('timer').classList.add('bg-danger');
            }

            if (timeLeft <= 0) {
                clearInterval(timer);
                alert("인증 시간이 만료되었습니다.");
                document.getElementById('otpCode').disabled = true;
                document.getElementById('verifyBtn').disabled = true;
            }

        }, 1000 / 10);
    }

    window.onload = startTimer;


    // 이메일 팝업창
    function verifyOTP(event) {
        event.preventDefault();

        const otpCode = document.getElementById("otpCode").value;

        if (otpCode.length !== 6) {
            alert('6자리 인증번호를 입력해주세요.')
            return;
        }

        fetch("/main/mypage", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: 'box=1&otpCode=' + otpCode
        })
            .then(res => {
                if (res.status === 200) {
                    alert('인증이 완료되었습니다.')
                    if (window.opener && window.opener.onEmailVerified) {
                        window.opener.onEmailVerified();
                    }
                    window.close();
                } else {
                    alert('인증번호가 일치하지 않습니다.')
                }
            })
    }
</script>