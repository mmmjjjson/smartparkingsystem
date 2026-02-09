window.closeMemberReceipt = function() {
    const memberReceiptCard = window.currentCard;
    if (memberReceiptCard) {
        const parkingAreaId = memberReceiptCard.dataset.id;
        const carNum = memberReceiptCard.dataset.carNum;

        memberReceiptCard.dataset.status = 'available';
        memberReceiptCard.dataset.carNum = "";
        memberReceiptCard.dataset.inFullTime = "";
        memberReceiptCard.dataset.carType = "";
        memberReceiptCard.dataset.time = "";

        memberReceiptCard.classList.replace('occupied', 'available');
        memberReceiptCard.querySelector('.box-car').innerText = "사용 가능";
        memberReceiptCard.querySelector('.box-time').innerText = "";

        if (typeof updateParkingCount === 'function') {
            updateParkingCount();
        }

        console.log(`${parkingAreaId} 구역 출차 및 ${carNum} 정산 처리 요청`);
        membershipPayModal.hide();
        alert('회원권 결제 및 출차가 완료되었습니다.')
    } else {
        console.log('memberReceiptCard를 찾을 수 없습니다.')
        membershipPayModal.hide();
    }
}

const membershipPayModalElement = document.getElementById('membershipPayModal');
const membershipPayModal = new bootstrap.Modal(membershipPayModalElement);
const btnMembershipPayRemote = document.getElementById('btnMembershipPay');
const btnMembershipSubmit = document.getElementById('btn-membership-submit');

// 목업데이터 추후 삭제
const mockMembers = [
    {carNum: "12가3456", name: "홍길동", phone: "010-1111-2222"},
    {carNum: "99나9999", name: "김철수", phone: "010-9999-8888"}
];

// '회원권 결제 버튼' 클릭
btnMembershipPayRemote.addEventListener('click', () => {
    if (typeof modal !== 'undefined') modal.hide();

    if (!window.currentCard) {
        alert("선택된 차량 정보가 없습니다.");
        return;
    }

    document.getElementById('mem-carNum').value = window.currentCard.dataset.carNum;
    document.getElementById('mem-name').value = "";
    document.getElementById('mem-phone').value = "";

    const now = new Date();
    const future = new Date();
    future.setDate(now.getDate() + 30);
    document.getElementById('mem-startDate').value = now.toISOString().split('T')[0];
    document.getElementById('mem-endDate').value = future.toISOString().split('T')[0];

    membershipPayModal.show();
})

document.getElementById('btn-check-member').addEventListener('click', () => {
    const carNum = document.getElementById('mem-carNum').value.trim();

    let member;
    for (let i = 0; i < mockMembers.length; i++) {
        if (mockMembers[i].carNum === carNum) {
            member = mockMembers[i];
            break;
        }
    }

    if (member) {
        alert('등록된 회원 정보가 있습니다.')
        document.getElementById('mem-name').value = member.name;
        document.getElementById('mem-phone').value = member.phone;
    } else {
        alert("등록된 정보가 없습니다. 신규 회원 정보를 입력해주세요.");
        document.getElementById('mem-name').focus();
    }
})

// 결제하기 버튼 로직
btnMembershipSubmit.addEventListener('click', () => {
    const name = document.getElementById('mem-name').value;
    const phone = document.getElementById('mem-phone').value;
    const carNum = document.getElementById('mem-carNum').value;
    const start = document.getElementById('mem-startDate').value;
    const end = document.getElementById('mem-endDate').value;
    const price = document.getElementById('mem-price').value;

    if (!name || !phone) {
        alert("회원 정보를 모두 입력해 주세요.");
        return;
    }

    // 1. 데이터 매핑
    document.getElementById('res-car').innerText = carNum;
    document.getElementById('res-user').innerText = name + " / " + phone;
    document.getElementById('res-period').innerText = start + " ~ " + end;
    document.getElementById('res-price').innerText = price;

    // 2. 화면 전환 (폼 숨기고 영수증 보이기)
    document.getElementById('mem-input-section').style.display = 'none';
    document.getElementById('mem-receipt-section').style.display = 'block';

    // 3. 하단 결제 버튼 숨기기
    document.getElementById('mem-footer').style.display = 'none';

    alert("결제가 완료되었습니다!");
});