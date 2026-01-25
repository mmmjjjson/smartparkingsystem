document.addEventListener('DOMContentLoaded', () => {
    const cards = document.querySelectorAll('.parking-card');

    // 나중에 클릭 이벤트 추가
    cards.forEach(card => {
        card.addEventListener('click', () => {
            const spotId = card.dataset.spotId;
            const status = card.dataset.status;

            console.log(`구역 ${spotId} 클릭됨, 상태: ${status}`);
            // 나중에 입·출차 모듈 연결
        });
    });
});
