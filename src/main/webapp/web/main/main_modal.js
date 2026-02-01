/* 모달 관련 객체 선언
모달 객체 불러와 정보 가져오기 (주차 구역, 차량 번호, 주차 시간, 주차 구역 상태)
*/
const modal = new bootstrap.Modal(document.getElementById('parkingModal'));
const modalTitle = document.getElementById('modal-id');
const modalCar = document.getElementById('modal-car');
const modalTime = document.getElementById('modal-time');
const modalAction = document.getElementById('modal-action');

// 주차 구역 클릭 이벤트 (클릭 시 정보 모달 팝업)
let currentCard = null;
document.querySelectorAll('.parking-card').forEach(card => {
    card.addEventListener('click', () => {
        // 클릭된 주차 구역 정보 변수 저장
        currentCard = card;

        document.getElementById('section-entry').style.display = 'none';
        document.getElementById('section-exit').style.display = 'none';
        document.getElementById('section-receipt').style.display = 'none';
        modalAction.style.display = 'block';
        document.querySelector('#parkingModal .modal-footer button[data-bs-dismiss="modal"]').style.display = 'block';

        const status = card.dataset.status;
        const id = card.dataset.id;
        const car = card.dataset.carNum;
        const time = card.dataset.time;
        const type = card.dataset.carType;

        if (status === 'available') {
            modalTitle.innerText = id + " 입차 관리";
            // 입차 처리 세팅
            document.getElementById('section-entry').style.display = 'block';
            document.getElementById('section-exit').style.display = 'none';
            modalAction.innerText = "입차 등록";
        } else {
            modalTitle.innerText = id + " 출차 관리";
            // 출차 처리 세팅
            document.getElementById('section-entry').style.display = 'none';
            document.getElementById('section-exit').style.display = 'block';

            const now = new Date();
            const inFullTime = currentCard.dataset.inFullTime;
            const outFullTime = now.toISOString();
            const chargeResult = calculateParkingCharge(inFullTime, outFullTime, type);
            // 데이터 매핑
            document.getElementById('info-car').innerText = car; // 차량 번호
            document.getElementById('info-type').innerText = type; // 차종
            document.getElementById('info-inTime').innerText = formatDateTime(inFullTime); // 주차 시간
            document.getElementById('info-outTime').innerText = formatDateTime(outFullTime); // 출차 시간

            const infoTotalPrice = document.getElementById('info-totalPrice');
            if (infoTotalPrice) {
                infoTotalPrice.innerText = chargeResult.total.toLocaleString() + "원";
            }
            modalAction.innerText = "결제하기";
            modalAction.className = "btn btn-danger";
        }
        modal.show();
    });
});

// '입차 등록', '결제하기' 버튼
modalAction.addEventListener('click', () => {
    if (modalAction.innerText === "입차 등록") {
        const carNum = document.getElementById('input-carNum').value; // input-carNum : 사용자 입력 차량번호
        const carType = document.querySelector('input[name="carType"]:checked').value;
        if (!carNum) {
            alert("차량 번호를 입력해 주세요");
            return;
        }

        // 현재 시간 생성
        const now = new Date();
        const fullTime = now.toISOString();
        const displayTime = now.getHours().toString().padStart(2, '0') + ":" +
            now.getMinutes().toString().padStart(2, '0');

        currentCard.dataset.status = 'occupied'; // 데이터 바꾸기
        currentCard.dataset.carNum = carNum; // 차량 번호
        currentCard.dataset.inFullTime = fullTime; // 주차 시간
        currentCard.dataset.carType = carType; // 차종

        // UI 업데이트
        currentCard.classList.replace('available', 'occupied'); // 배경색 변경
        currentCard.querySelector('.box-car').innerText = carNum;
        currentCard.querySelector('.box-time').innerText = "00:00";

        alert(carNum + " 차량 입차 완료!")
        modal.hide();
        updateParkingCount();
        document.getElementById('input-carNum').value = ""; // 입력창 초기화
    } else if (modalAction.innerText === "결제하기") {
        // 출차 -> 영수증
        const inFullTime = currentCard.dataset.inFullTime;
        const outFullTime = new Date().toISOString();
        const carType = currentCard.dataset.carType;
        const carNum = currentCard.dataset.carNum;

        const chargeResult = calculateParkingCharge(inFullTime, outFullTime, carType);

        // 영수증 데이터 매핑
        document.getElementById('rec-car').innerText = carNum;
        document.getElementById('rec-in').innerText = formatDateTime(inFullTime);
        document.getElementById('rec-out').innerText = formatDateTime(outFullTime);

        document.getElementById('rec-totalTime').innerText = chargeResult.duration + "분";
        document.getElementById('rec-basePrice').innerText = chargeResult.base.toLocaleString() + "원";
        document.getElementById('rec-extraPrice').innerText = chargeResult.extra.toLocaleString() + "원";

        // 할인 표시
        const discountText = chargeResult.discount > 0 ?
            "-" + chargeResult.discount.toLocaleString() + "원 (" + chargeResult.discountName + ")" : "0원";
        document.getElementById('rec-discount').innerText = discountText;

        // 최종 금액
        document.getElementById('rec-totalPrice').innerText = chargeResult.total.toLocaleString() + "원";

        // UI 전환
        document.getElementById('section-exit').style.display = 'none';
        document.getElementById('section-receipt').style.display = 'block';

        // 하단 버튼 숨기기
        modalAction.style.display = 'none';
        const footerCloseBtn = document.querySelector('#parkingModal .modal-footer button[data-bs-dismiss="modal"]');
        if (footerCloseBtn) footerCloseBtn.style.display = 'none';
    }
});

// main.jsp 스크립트 하단에 추가
document.getElementById('btn-close-final').addEventListener('click', () => {
    if (!currentCard) return;

    // 1. 데이터 초기화
    currentCard.dataset.status = 'available';
    currentCard.dataset.carNum = "";
    currentCard.dataset.inFullTime = "";
    currentCard.dataset.carType = "";
    currentCard.dataset.time = "";

    // 2. UI 초기화
    currentCard.classList.replace('occupied', 'available');
    currentCard.querySelector('.box-car').innerText = "사용 가능";
    currentCard.querySelector('.box-time').innerText = "";

    // 3. 모달 닫기
    modal.hide();
    updateParkingCount();
    alert("정산이 완료되어 출차 처리되었습니다.");
});

/* 창 닫힐 때 섹션 리셋 */
document.getElementById('parkingModal').addEventListener('hidden.bs.modal', function () {
    document.getElementById('section-receipt').style.display = 'none';
    modalAction.style.display = 'block';
    const footerCloseBtn = document.querySelector('#parkingModal .modal-footer button[data-bs-dismiss="modal"]');
    if (footerCloseBtn) footerCloseBtn.style.display = 'block';
    document.getElementById('input-carNum').value = "";
})

setInterval(() => {
    const now = new Date();
    document.querySelectorAll('.parking-card.occupied').forEach(card => {
        const inFullTime = card.dataset.inFullTime;
        if (inFullTime) {
            const inDate = new Date(inFullTime);
            const diffMins = Math.floor((now - inDate) / 60000);
            const hours = Math.floor(diffMins / 60);
            const mins = diffMins % 60;
            const timeStr = String(hours).padStart(2, '0') + ":" + String(mins).padStart(2, '0');
            const timeBox = card.querySelector('.box-time');
            if (timeBox) timeBox.innerText = timeStr;
        }
    });
    updateParkingCount();
}, 60000);

updateParkingCount();
