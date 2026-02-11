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

// Step 1 제출 (아이디/비밀번호)
function submitStep1(event) {
    event.preventDefault(); // 새로고침 방지

    const adminId = document.getElementById('adminId').value;
    const password = document.getElementById('password').value;

    if (!adminId || !password) {
        alert("아이디와 비밀번호를 입력해주세요.");
        return;
    }

    // Servlet 연동
    fetch("/login", {
        method: "POST",
        credentials: "same-origin",
        headers: { // form값이 전송하는 파라미터를 받기위해 설정
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: "step=1&adminId=" + adminId + "&password=" + password
    })
        .then(res => {
            if (res.status === 403) {
                alert("활동이 중지된 계정입니다.")
                return;
            } else if (res.status === 401) {
                alert("아이디 또는 비밀번호가 잘못 되었습니다. 아이디와 비밀번호를 정확히 입력해 주세요.")
                return;
            }
            goStep2();
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

    fetch("/login", {
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

    fetch("/login", {
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
                window.location.href = "../../web/main/main.jsp";
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
