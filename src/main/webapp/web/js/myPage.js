function updatePassword(event) {
    event.preventDefault(); // 새로고침 방지

    const password = document.getElementById("password").value;
    const newPassword = document.getElementById("newPassword").value;
    const newPasswordCheck = document.getElementById("newPasswordCheck").value;

    if (!password) {
        alert('현재 비밀번호를 입력해주세요.')
        return;
    }
    if (!newPassword || !newPasswordCheck) {
        alert('변경하실 비밀번호를 입력해주세요.')
        return;
    }
    if (newPassword !== newPasswordCheck) {
        alert('비밀번호가 일치하지 않습니다.')
        return;
    }

    fetch ("/main/mypage", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: "password=" + password + "&newPassword=" + newPassword + "&newPasswordCheck=" + newPasswordCheck
    })
        .then(res => {
            if (res.status === 200) {
                alert("정보 수정 완료")
                window.location.href = "../../web/main/main.jsp"
            } else {
                alert("정보가 일치 하지 않습니다.")
            }
        })
}