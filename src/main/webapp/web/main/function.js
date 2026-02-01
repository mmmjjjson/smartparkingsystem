// 날짜 객체를 "YYYY-MM-DD HH:mm" 형식으로 변환
function formatDateTime(dateStr) {
    if (!dateStr) return "-";
    const d = new Date(dateStr);
    const z = (n) => n.toString().padStart(2, '0'); // 10 미만 숫자 앞에 0 붙이기

    return d.getFullYear() + "-" + z(d.getMonth() + 1) + "-" + z(d.getDate()) +
        " " + z(d.getHours()) + ":" + z(d.getMinutes());
}

// 주차 현황 숫자 업데이트 함수
function updateParkingCount() {
    const occupiedCount = document.querySelectorAll('.parking-card.occupied').length;
    const displayCount = document.querySelector('h3 + p b');
    if (displayCount) {
        displayCount.innerText = occupiedCount + "대";
    }
}