// Step 2로 이동
function goStep2() {
    console.log("✅ Step 2로 이동");
    document.getElementById("step1").classList.add("d-none");
    document.getElementById("step2").classList.remove("d-none");
    document.getElementById("inputEmail").focus();
}

// Step 3로 이동
function goStep3() {
    console.log("✅ Step 3로 이동");
    document.getElementById("step2").classList.add("d-none");
    document.getElementById("step3").classList.remove("d-none");
    document.getElementById("inputVerificationCode").focus();
}

// ClearStep 로 이동
function ClearStep() {
    console.log("✅ Clear Step");
    document.getElementById("step3").classList.add("d-none");
    document.getElementById("clearStep").classList.remove("d-none");
}

// Step 1로 돌아가기
function goBackToStep1() {
    document.getElementById("step2").classList.add("d-none");
    document.getElementById("step1").classList.remove("d-none");
    document.getElementById("inputEmail").value = '';
}

// Step 2로 돌아가기
function goBackToStep2() {
    document.getElementById("step3").classList.add("d-none");
    document.getElementById("step2").classList.remove("d-none");
    document.getElementById("inputVerificationCode").value = '';
}

// Step 1 제출 (아이디 확인)
function submitStep1(event) {
    event.preventDefault();

    const adminId = document.getElementById('inputAdminId').value;

    if (!adminId) {
        alert("관리자 아이디를 입력해주세요.");
        return;
    }

    fetch("/password", {
        method: "POST",
        headers: {
            "Content-Type" : "application/x-www-form-urlencoded"
        },
        body: "step=1&adminId=" + adminId
    })
    goStep2();
}

// Step 2 제출 (이메일 입력 및 인증번호 발송)
function submitStep2(event) {
    event.preventDefault();

    const email = document.getElementById('inputEmail').value;
    const adminId = document.getElementById('inputAdminId').value;

    if (!email) {
        alert("이메일을 입력해주세요.");
        return;
    }

    fetch("/password", {
        method: "POST",
        headers: {
            "Content-Type" : "application/x-www-form-urlencoded"
        },
        body: "step=2&admin=" + adminId + "&email=" + email
    })
        .then(res => {
            if (res.status === 200) {
                document.getElementById("emailText").innerText = email + "로 인증번호를 발송했습니다.";
                goStep3();
            } else {
                alert('입력하신 정보가 일치하지 않습니다.')
            }
        })
}

// Step 3 제출 (인증번호 확인 및 비밀번호 재설정)
function submitStep3(event) {
    event.preventDefault();

    // const email = document.getElementById('verificationForm').value;
    const otpCode = document.getElementById('inputVerificationCode').value;

    if (otpCode.length !== 6) {
        alert("6자리 인증번호를 입력해주세요.");
        return;
    }

    fetch("/password", {
        method: "POST",
        headers: {
            "Content-Type" : "application/x-www-form-urlencoded"
        },
        body: "step=3&otpCode=" + otpCode
    })
        .then(res => {
            if (res.status === 200) {
                ClearStep()
            } else {
                alert('OTP Error 인증번호 오류')
            }
        })
}

// 숫자만 입력 (필터링)
document.addEventListener('DOMContentLoaded', function() {
    const codeInput = document.getElementById('inputVerificationCode');
    if (codeInput) {
        codeInput.addEventListener('input', function(e) {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    }
});