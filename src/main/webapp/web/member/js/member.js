document.addEventListener('DOMContentLoaded', () => {
    const newMemberBtn = document.getElementById('newMemberBtn');
    const newMemberModal = document.getElementById('newMemberModal');
    const checkMemberBtn = document.getElementById('btn-check-member');
    const btnMembershipPay = document.getElementById('btnMembershipPay');
    const paySubmitBtn = document.getElementById('btn-membership-submit');
    const receiptCloseBtn = document.getElementById('btn-receipt-close-final');
    const flash = document.getElementById('flashMessage');

    // 페이지 로드 시 회원 확인 결과 처리
    const checkResult = document.getElementById('checkResult').value;
    if (checkResult === 'found' || checkResult === 'notFound') {
        handleMemberCheckResult(checkResult);
    }

    // 신규 회원 등록 버튼
    if (newMemberBtn) newMemberBtn.addEventListener('click', () => {
        clearNewMemberInputs();
        new bootstrap.Modal(document.getElementById('newMemberModal')).show();
    });

    // 모달이 닫힐 때 모든 입력 필드 초기화
    if (newMemberModal) {
        newMemberModal.addEventListener('hidden.bs.modal', () => {
            // 차량번호 포함 모든 필드 초기화
            document.getElementById('newCarNumber').value = '';
            clearNewMemberInputs();
        });
    }

    // 기존 회원 확인 버튼
    if (checkMemberBtn) {
        checkMemberBtn.addEventListener('click', handleMemberCheck);
        document.getElementById('newCarNumber')
            ?.addEventListener('keydown', (e) => {
                if (e.key === 'Enter') handleMemberCheck();
            });
    }

    // 회원권 결제 버튼
    if (btnMembershipPay) btnMembershipPay.addEventListener('click', openMembershipModal);

    // 결제 버튼 클릭 → 영수증 보여주기 (form 제출은 닫기 버튼에서)
    if (paySubmitBtn) {
        paySubmitBtn.addEventListener('click', (e) => {
            e.preventDefault(); // form 제출 막기

            // 원본 값 가져오기
            const carNum = document.getElementById('newCarNumber')?.value || '';
            const name = document.getElementById('newName')?.value || '';
            const phone = document.getElementById('newPhone')?.value || '';
            const startDate = document.getElementById('newStartDate')?.value || '';
            const expireDate = document.getElementById('newExpireDate')?.value || '';
            const existingMember = document.getElementById('isExistingMember')?.value || '';

            // hidden input 채우기
            const newCarNumberHidden = document.getElementById('newCarNumberHidden');
            const newNameHidden = document.getElementById('newNameHidden');
            const newPhoneHidden = document.getElementById('newPhoneHidden');
            const newStartDateHidden = document.getElementById('newStartDateHidden');
            const newExpireDateHidden = document.getElementById('newExpireDateHidden');
            const isExistingMemberHidden = document.getElementById('isExistingMemberHidden');

            // null 체크 및 값 설정
            if (newCarNumberHidden) newCarNumberHidden.value = carNum;
            if (newNameHidden) newNameHidden.value = name;
            if (newPhoneHidden) newPhoneHidden.value = phone;
            if (newStartDateHidden) newStartDateHidden.value = startDate;
            if (newExpireDateHidden) newExpireDateHidden.value = expireDate;
            if (isExistingMemberHidden) isExistingMemberHidden.value = existingMember;

            // 영수증 표시
            showMembershipReceipt();
        });
    }

    // 영수증 닫기 버튼 클릭 → form submit + 모달 닫기
    if (receiptCloseBtn) {
        receiptCloseBtn.addEventListener('click', () => {
            document.getElementById('newMemberForm').submit(); // 서버 제출
        });
    }

    // flash 메시지 alert
    if (flash && flash.dataset.msg) alert(flash.dataset.msg);
})

/* ===================== 회원 확인 결과 처리 ===================== */
function handleMemberCheckResult(result) {
    const modal = new bootstrap.Modal(document.getElementById('newMemberModal'));

    if (result === 'found') {
        // 기존 회원 있음
        const memberCar = document.getElementById('memberCar').value;
        const memberName = document.getElementById('memberName').value;
        const memberPhone = document.getElementById('memberPhone').value;
        const memberEnd = document.getElementById('memberEnd').value;

        document.getElementById('newCarNumber').value = memberCar;
        document.getElementById('newName').value = memberName;
        document.getElementById('newPhone').value = memberPhone;

        // 기존 회원 플래그 설정
        document.getElementById('isExistingMember').value = 'true';

        const lastEnd = new Date(memberEnd);
        lastEnd.setDate(lastEnd.getDate() + 1);
        const nextDate = lastEnd.toISOString().slice(0, 10);

        const startEl = document.getElementById('newStartDate');
        startEl.value = nextDate;
        startEl.min = nextDate;
        startEl.disabled = false;

        setEndDateBy30Days('newStartDate', 'newExpireDate');

        ['newName', 'newPhone'].forEach(id => {
            const el = document.getElementById(id);
            if (el) el.disabled = false;
        });

        modal.show();
        alert('등록된 회원 정보가 있습니다. 기존 정보로 입력을 진행합니다.');

    } else if (result === 'notFound') {
        // 기존 회원 없음
        // 신규 회원 플래그 설정
        document.getElementById('isExistingMember').value = 'false';

        ['newName', 'newPhone', 'newStartDate', 'newExpireDate'].forEach(id => {
            const el = document.getElementById(id);
            if (el) {
                el.disabled = false;
                if (id === 'newStartDate') {
                    // 오늘 날짜를 로컬 시간 기준으로 설정
                    const today = new Date();
                    const year = today.getFullYear();
                    const month = String(today.getMonth() + 1).padStart(2, '0');
                    const day = String(today.getDate()).padStart(2, '0');
                    el.value = `${year}-${month}-${day}`;
                }
            }
        });

        setEndDateBy30Days('newStartDate', 'newExpireDate');

        modal.show();
        document.getElementById('newName').focus();
        alert('등록된 정보가 없습니다. 신규 회원 정보를 입력해주세요.');
    }
}

/* ===================== 기존 회원 여부 확인 결과 ===================== */
function handleMemberCheck() {
    const carInput = document.getElementById('newCarNumber');
    const carNum = carInput.value.trim();

    if (!carNum) {
        alert('차량 번호를 입력해주세요.');
        carInput.focus();
        return;
    }

    // 폼 제출로 서버에 요청
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '/member_check.do';

    const input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'carNum';
    input.value = carNum;

    form.appendChild(input);
    document.body.appendChild(form);
    form.submit();
}

/* ===================== 회원 선택 시 상세 모달 ===================== */
function openViewModal(mno, car, name, phone, start, end, charge) {
    const viewModalEl = document.getElementById('viewMemberModal');
    viewModalEl.querySelector('#mno').value = mno;
    viewModalEl.querySelector('#viewCarNumber').textContent = car;
    viewModalEl.querySelector('#viewName').textContent = name;
    viewModalEl.querySelector('#viewPhone').textContent = phone;
    viewModalEl.querySelector('#viewStartDate').textContent = start;
    viewModalEl.querySelector('#viewExpireDate').textContent = end;
    viewModalEl.querySelector('#viewCharge').textContent = charge;

    new bootstrap.Modal(viewModalEl).show();
}

/* ===================== 신규 회원 입력 초기화 ===================== */
function clearNewMemberInputs() {
    // 오늘 날짜를 로컬 시간 기준으로 가져오기
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');
    const todayString = `${year}-${month}-${day}`;

    const inputs = ['newName', 'newPhone', 'newStartDate', 'newExpireDate'];

    // 차량번호를 제외한 나머지만 초기화
    inputs.forEach(id => {
        const el = document.getElementById(id);
        if (el) {
            el.value = '';
            el.disabled = true;  // 회원 확인 전 비활성화
        }
    });

    document.getElementById('newStartDate').value = todayString;
    setEndDateBy30Days('newStartDate', 'newExpireDate');

    // 플래그 초기화
    document.getElementById('isExistingMember').value = '';
}

/* ===================== 회원권 결제 모달 ===================== */
function openMembershipModal() {
    // 차량번호 검증
    const carNum = document.getElementById("newCarNumber").value.trim();
    if (!carNum) {
        alert('선택된 차량 정보가 없습니다.');
        document.getElementById('newCarNumber').focus();
        return;
    }

    const memModalEl = document.getElementById('membershipPayModal');
    memModalEl.querySelector('#memCarNum').value = document.getElementById("newCarNumber").value;
    memModalEl.querySelector('#memName').value = document.getElementById("newName").value;
    memModalEl.querySelector('#memPhone').value = document.getElementById("newPhone").value;
    memModalEl.querySelector('#memStartDate').value = document.getElementById("newStartDate").value;
    memModalEl.querySelector('#memEndDate').value = document.getElementById("newExpireDate").value;

    new bootstrap.Modal(memModalEl).show();
}

/* ===================== 회원권 결제 영수증 모달 ===================== */
function showMembershipReceipt() {
    document.getElementById("res-car").textContent = document.getElementById("memCarNum").value;
    document.getElementById("res-user").textContent =
        `${document.getElementById("memName").value} / ${document.getElementById("memPhone").value}`;
    document.getElementById("res-period").textContent =
        `${document.getElementById("memStartDate").value} ~ ${document.getElementById("memEndDate").value}`;
    document.getElementById("res-price").textContent = document.getElementById("memPrice").value;

    document.getElementById("mem-input-section").style.display = "none";
    document.getElementById("mem-receipt-section").style.display = "block";
    document.getElementById("mem-footer").style.display = "none";
}

/* ===================== 회원 정보 수정 모달 ===================== */
function openEditModal() {
    const viewModalEl = document.getElementById('viewMemberModal');
    const editModalEl = document.getElementById('editMemberModal');

    // 회원 상세 모달 닫기
    const viewModal = bootstrap.Modal.getInstance(viewModalEl);
    if (viewModal) viewModal.hide();

    editModalEl.querySelector('#editMno').value = viewModalEl.querySelector('#mno').value;
    editModalEl.querySelector('#editCarNumber').value = viewModalEl.querySelector('#viewCarNumber').textContent;
    editModalEl.querySelector('#editName').value = viewModalEl.querySelector('#viewName').textContent;
    editModalEl.querySelector('#editPhone').value = viewModalEl.querySelector('#viewPhone').textContent;
    editModalEl.querySelector('#editStartDate').value = viewModalEl.querySelector('#viewStartDate').textContent;
    editModalEl.querySelector('#editExpireDate').value = viewModalEl.querySelector('#viewExpireDate').textContent;

    new bootstrap.Modal(editModalEl).show();
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
function setEndDateBy30Days(startId, endId) {
    const s = document.getElementById(startId).value;
    if (!s) return;

    const parts = s.split('-');
    const d = new Date(parts[0], parts[1] - 1, parts[2]); // 로컬 기준 생성

    d.setDate(d.getDate() + 30);

    const year = d.getFullYear();
    const month = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');

    document.getElementById(endId).value = `${year}-${month}-${day}`;
}

/* ===================== 회원 정보 입력 검증 ===================== */
function validateMember(carNum, name, phone, start, end = true) {
    const carPattern = /^[0-9]{2,3}[가-힣][0-9]{4}$/;
    const phonePattern = /^[0-9]{3}-[0-9]{4}-[0-9]{4}$/;

    // 차량번호 미입력 시
    if (!carNum) return '차량 번호를 입력해주세요.';

    // 차량번호 형식 오류
    if (!carPattern.test(carNum)) return '차량 번호 형식이 올바르지 않습니다.';

    // 나머지 필수값 검사 (회원권 결제용)
    if (name !== undefined && phone !== undefined && start !== undefined) {
        if (!name || !phone || !start) return '필수 항목을 입력해주세요.';
        if (!phonePattern.test(phone)) return '연락처 형식이 올바르지 않습니다.';
    }
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
    if (msg) {
        alert(msg);
        return false;
    }
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
    if (msg) {
        alert(msg);
        return false;
    }
    return true;
}
