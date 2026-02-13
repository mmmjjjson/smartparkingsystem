// 타이머
let timeLeft = 240; // 4분

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

    }, 1000);
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
            } else if (res.status === 401) {
                alert("OTP가 일치하지 않음")
            } else if (res.status === 403) {
                alert("OTP 만료")
            } else {
                alert("[ERROR] 알 수 없는 오류")
            }
        })
}