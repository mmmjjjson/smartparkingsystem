document.addEventListener('DOMContentLoaded', () => {

    // 신규 회원 버튼
    const newMemberBtn = document.getElementById('newMemberBtn');
    if (newMemberBtn) {
        newMemberBtn.addEventListener('click', openNewMemberModal);
    }

    // flash 메시지 표시
    showFlashMessage();

    // 조회 모달 요소들 (전역 변수로 연결)
    window.viewCarNumber = document.getElementById('viewCarNumber');
    window.viewName = document.getElementById('viewName');
    window.viewPhone = document.getElementById('viewPhone');
    window.viewStartDate = document.getElementById('viewStartDate');
    window.viewExpireDate = document.getElementById('viewExpireDate');

    // 신규 회원 입력 요소
    window.newCarNumber = document.getElementById('newCarNumber');
    window.newName = document.getElementById('newName');
    window.newPhone = document.getElementById('newPhone');
    window.newStartDate = document.getElementById('newStartDate');

    // 수정 / 삭제용
    window.mnoValue = document.getElementById('mno');
    window.editMno = document.getElementById('editMno');
    window.deleteMno = document.getElementById('deleteMno');

    window.editCarNumber = document.getElementById('editCarNumber');
    window.editName = document.getElementById('editName');
    window.editPhone = document.getElementById('editPhone');
    window.editStartDate = document.getElementById('editStartDate');
    window.editExpireDate = document.getElementById('editExpireDate');

});

/* ===================== 공통 모달 제어 ===================== */
function closeAllModals() {
    document.querySelectorAll('.modal')
        .forEach(m => m.classList.remove('active'));
}

function openModal(id) {
    closeAllModals();
    document.getElementById(id).classList.add('active');
}

/* ===================== 신규 회원 등록 모달 ===================== */
function openNewMemberModal() {
    ['newCarNumber', 'newName', 'newPhone', 'newStartDate', 'newExpireDate']
        .forEach(id => document.getElementById(id).value = '');

    openModal('newMemberModal');
}

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

    document.getElementById(endId).value =
        d.toISOString().slice(0, 10);
}

/* ===================== 신규 회원 등록 ===================== */
function handleNewMemberSubmit() {
    const msg = validateMember(
        newCarNumber.value.trim(),
        newName.value.trim(),
        newPhone.value.trim(),
        newStartDate.value.trim()
    );

    if (msg) {
        alert(msg);
        return false;
    }

    return true; // 서버로 submit
}

/* ===================== 회원 상세 모달 ===================== */
function openViewModal(mno, car, name, phone, start, end) {
    document.getElementById("deleteMno").value = mno;
    document.getElementById("editMno").value = mno;

    mnoValue.value = mno;
    viewCarNumber.textContent = car;
    viewName.textContent = name;
    viewPhone.textContent = phone;
    viewStartDate.textContent = start.substring(0, 10);
    viewExpireDate.textContent = end.substring(0, 10);

    openModal('viewMemberModal');
}

/* ===================== 회원 정보 수정 모달 ===================== */
function openEditModal() {
    editMno.value = mnoValue.value;

    // 조회 모달에 표시된 값 가져오기
    editCarNumber.value = viewCarNumber.textContent;
    editName.value = viewName.textContent;
    editPhone.value = viewPhone.textContent;
    editStartDate.value = viewStartDate.textContent;
    editExpireDate.value = viewExpireDate.textContent;

    openModal('editMemberModal');
}

/* ===================== 회원 정보 수정 ===================== */
function handleEditSubmit() {
    const msg = validateMember(
        editCarNumber.value.trim(),
        editName.value.trim(),
        editPhone.value.trim(),
        editStartDate.value.trim(),
        editExpireDate.value.trim()
    );

    if (msg) {
        alert(msg);
        return false;
    }

    return true;
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

/* ===================== 회원 삭제 모달 ===================== */
function handleDelete() {
    deleteMno.value = mnoValue.value;
    openModal('deleteConfirmModal');
}

/* ===================== 결과 안내 모달 ===================== */
function showFlashMessage() {
    const flash = document.getElementById('flashMessage');
    if (!flash) return;

    const msg = flash.dataset.msg;
    if (!msg) return;

    alert(msg);
}
