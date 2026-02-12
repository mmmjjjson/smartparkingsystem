document.addEventListener('DOMContentLoaded', () => {
    // 신규 회원 등록 버튼
    const newMemberBtn = document.getElementById('newMemberBtn');
    if (newMemberBtn) {
        newMemberBtn.addEventListener('click', () => {
            clearNewMemberInputs();
            new bootstrap.Modal(document.getElementById('newMemberModal')).show();
        });
    }

    // 회원권 결제 버튼
    const btnMembershipPayRemote = document.getElementById('btnMembershipPay');
    if (btnMembershipPayRemote) {
        btnMembershipPayRemote.addEventListener('click', openMembershipModal);
    }

    // 회원권 결제 영수증 버튼
    const payBtn = document.getElementById("btn-membership-submit");
    payBtn.addEventListener("click", function() {
        showMembershipReceipt();
    });

    // 회원권 결제 영수증 닫기 버튼
    const receiptCloseBtn = document.getElementById("btn-receipt-close-final");

    // 회원권 결제 모달
    const membershipModal = new bootstrap.Modal(document.getElementById("membershipPayModal"));

    // 회원권 결제 후 닫기 버튼
    receiptCloseBtn.addEventListener("click", function() {
        // 1. 알림
        alert("회원권 결제가 완료되었습니다");

        // 2. 모달 닫기
        membershipModal.hide();

        // 3. 모달 상태 초기화 (입력 영역 다시 보여주고, 영수증 영역 숨기기)
        document.getElementById("mem-input-section").style.display = "block";
        document.getElementById("mem-receipt-section").style.display = "none";
        document.getElementById("mem-footer").style.display = "flex"; // 기존 버튼 다시 보여주기
    });

    // 결과 메시지 표시
    const flash = document.getElementById('flashMessage');
    if (flash) {
        const msg = flash.dataset.msg;
        if (msg) alert(msg);
    }
});

/* ===================== 회원 선택 시 상세 모달 ===================== */
function openViewModal(mno, car, name, phone, start, end) {
    const viewModalEl = document.getElementById('viewMemberModal');
    viewModalEl.querySelector('#mno').value = mno;
    viewModalEl.querySelector('#viewCarNumber').textContent = car;
    viewModalEl.querySelector('#viewName').textContent = name;
    viewModalEl.querySelector('#viewPhone').textContent = phone;
    viewModalEl.querySelector('#viewStartDate').textContent = start;
    viewModalEl.querySelector('#viewExpireDate').textContent = end;

    new bootstrap.Modal(viewModalEl).show();
}

/* ===================== 회원권 결제 모달 ===================== */
function openMembershipModal() {
    const viewModalEl = document.getElementById('viewMemberModal');
    const mno = viewModalEl.querySelector('#mno').value;
    if (!mno) {
        alert('회원을 먼저 선택해주세요.');
        return;
    }

    // 회원 상세 모달 닫기
    const viewModal = bootstrap.Modal.getInstance(viewModalEl);
    if(viewModal) viewModal.hide();

    const memModalEl = document.getElementById('membershipPayModal');
    memModalEl.querySelector('#memMno').value = mno;
    memModalEl.querySelector('#memCarNum').value = viewModalEl.querySelector('#viewCarNumber').textContent;
    memModalEl.querySelector('#memName').value = viewModalEl.querySelector('#viewName').textContent;
    memModalEl.querySelector('#memPhone').value = viewModalEl.querySelector('#viewPhone').textContent;
    memModalEl.querySelector('#memStartDate').value = viewModalEl.querySelector('#viewStartDate').textContent;
    memModalEl.querySelector('#memEndDate').value = viewModalEl.querySelector('#viewExpireDate').textContent;
    memModalEl.querySelector('#memPrice').value = '100,000원';

    new bootstrap.Modal(memModalEl).show();
}

/* ===================== 회원권 결제 영수증 모달 ===================== */
function showMembershipReceipt() {
    // 1. 모달에서 입력값 가져오기
    const carNum = document.getElementById("memCarNum").value;
    const name = document.getElementById("memName").value;
    const phone = document.getElementById("memPhone").value;
    const startDate = document.getElementById("memStartDate").value;
    const endDate = document.getElementById("memEndDate").value;
    const price = document.getElementById("memPrice").value;

    // 2. 영수증 영역에 데이터 채우기
    document.getElementById("res-car").textContent = carNum;
    document.getElementById("res-user").textContent = `${name} / ${phone}`;
    document.getElementById("res-period").textContent = `${startDate} ~ ${endDate}`;
    document.getElementById("res-price").textContent = price;

    // 3. 입력 영역 숨기고 영수증 영역 표시
    document.getElementById("mem-input-section").style.display = "none";
    document.getElementById("mem-receipt-section").style.display = "block";

    // 4. 모달 푸터 버튼도 필요하면 숨기기
    document.getElementById("mem-footer").style.display = "none";
}

/* ===================== 신규 회원 입력 초기화 ===================== */
function clearNewMemberInputs() {
    const today = new Date().toISOString().slice(0, 10);
    ['newCarNumber', 'newName', 'newPhone'].forEach(id => {
        const el = document.getElementById(id);
        if(el) el.value = '';
    });

    const startEl = document.getElementById('newStartDate');
    const endEl = document.getElementById('newExpireDate');

    if(startEl) startEl.value = today; // 시작일 오늘 날짜
    if(endEl && startEl) {
        setEndDateByOneMonth('newStartDate', 'newExpireDate'); // 만료일 자동 계산
    }
}

/* ===================== 회원 정보 수정 버튼 ===================== */
function openEditModal() {
    const viewModalEl = document.getElementById('viewMemberModal');
    const editModalEl = document.getElementById('editMemberModal');

    // 회원 상세 모달 닫기
    const viewModal = bootstrap.Modal.getInstance(viewModalEl);
    if(viewModal) viewModal.hide();

    editModalEl.querySelector('#editMno').value = viewModalEl.querySelector('#mno').value;
    editModalEl.querySelector('#editCarNumber').value = viewModalEl.querySelector('#viewCarNumber').textContent;
    editModalEl.querySelector('#editName').value = viewModalEl.querySelector('#viewName').textContent;
    editModalEl.querySelector('#editPhone').value = viewModalEl.querySelector('#viewPhone').textContent;
    editModalEl.querySelector('#editStartDate').value = viewModalEl.querySelector('#viewStartDate').textContent;
    editModalEl.querySelector('#editExpireDate').value = viewModalEl.querySelector('#viewExpireDate').textContent;

    new bootstrap.Modal(editModalEl).show();
}

/* ===================== 회원 삭제 모달 ===================== */
// function handleDelete() {
//     const viewModalEl = document.getElementById('viewMemberModal');
//     const deleteModalEl = document.getElementById('deleteConfirmModal');
//     deleteModalEl.querySelector('#deleteMno').value = viewModalEl.querySelector('#mno').value;
//     new bootstrap.Modal(deleteModalEl).show();
// }

/* ===================== 자동 하이픈 ===================== */
function autoHyphenPhone(input) {
    let v = input.value.replace(/\D/g, '').slice(0, 11);
    if (v.length >= 8)
        input.value = v.replace(/(\d{3})(\d{4})(\d+)/, '$1-$2-$3');
    else if (v.length >= 4)
        input.value = v.replace(/(\d{3})(\d+)/, '$1-$2');
    else
        input.value = v;
}

/* ===================== 만료일 자동 계산 ===================== */
function setEndDateByOneMonth(startId, endId) {
    const s = document.getElementById(startId).value;
    if (!s) return;
    const d = new Date(s);
    d.setMonth(d.getMonth() + 1);
    d.setDate(d.getDate() - 1);
    document.getElementById(endId).value = d.toISOString().slice(0, 10);
}

/* ===================== 회원 정보 입력 검증 ===================== */
function validateMember(carNum, name, phone, start, end = true) {
    const carPattern = /^[0-9]{2,3}[가-힣][0-9]{4}$/;
    const phonePattern = /^[0-9]{3}-[0-9]{4}-[0-9]{4}$/;

    if (!carNum || !name || !phone || !start) return '필수 항목을 입력해주세요.';
    if (!carPattern.test(carNum)) return '차량 번호 형식이 올바르지 않습니다.';
    if (!phonePattern.test(phone)) return '연락처 형식이 올바르지 않습니다.';
    return null;
}

/* ===================== 신규/수정 제출 검증 ===================== */
function handleNewMemberSubmit() {
    const msg = validateMember(
        document.getElementById('newCarNumber').value.trim(),
        document.getElementById('newName').value.trim(),
        document.getElementById('newPhone').value.trim(),
        document.getElementById('newStartDate').value.trim()
    );
    if (msg) { alert(msg); return false; }
    return true;
}

/* ===================== 회원 정보 수정 ===================== */
function handleEditSubmit() {
    const msg = validateMember(
        document.getElementById('editCarNumber').value.trim(),
        document.getElementById('editName').value.trim(),
        document.getElementById('editPhone').value.trim(),
        document.getElementById('editStartDate').value.trim()
    );
    if (msg) { alert(msg); return false; }
    return true;
}
