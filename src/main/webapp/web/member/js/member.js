document.addEventListener('DOMContentLoaded', () => {
    /* ===================== 버튼 이벤트 ===================== */
    // 신규 회원 등록 버튼
    const newMemberBtn = document.getElementById('newMemberBtn');
    if (newMemberBtn) {
        newMemberBtn.addEventListener('click', () => {
            clearNewMemberInputs();
            new bootstrap.Modal(document.getElementById('newMemberModal')).show();
        });
    }

    // 기존 회원 여부 확인 버튼
    const checkMemberBtn = document.getElementById('btn-check-member');
    if (checkMemberBtn) checkMemberBtn.addEventListener('click', checkExistingMember);

    // 회원 확인 전 입력창 접근 제한
    ['newName', 'newPhone', 'newStartDate'].forEach(id => {
        const el = document.getElementById(id);
        if (el) {
            el.addEventListener('focus', () => {
                if (el.disabled) {
                    alert('먼저 회원 확인을 진행해주세요.');
                    document.getElementById('newCarNumber').focus();
                }
            });
        }
    });

    // 회원권 결제 버튼
    const btnMembershipPayRemote = document.getElementById('btnMembershipPay');
    if (btnMembershipPayRemote) btnMembershipPayRemote.addEventListener('click', openMembershipModal);

    // 회원권 결제 영수증 버튼
    const payBtn = document.getElementById("btn-membership-submit");
    if (payBtn) {
        payBtn.addEventListener("click", function () {
            // form submit 전에 hidden input에 값 넣고 제출
            document.getElementById('newCarNumberHidden').value = document.getElementById('newCarNumber').value;
            document.getElementById('newNameHidden').value = document.getElementById('newName').value;
            document.getElementById('newPhoneHidden').value = document.getElementById('newPhone').value;
            document.getElementById('newStartDateHidden').value = document.getElementById('newStartDate').value;
            document.getElementById('newExpireDateHidden').value = document.getElementById('newExpireDate').value;

            document.getElementById('newMemberForm').submit();
        });
    }

    // 회원권 결제 영수증 닫기 버튼
    const receiptCloseBtn = document.getElementById("btn-receipt-close-final");

    // 회원권 결제 모달
    const membershipModal = new bootstrap.Modal(document.getElementById("membershipPayModal"));

    // 회원권 결제 후 닫기 버튼
    if (receiptCloseBtn) {
        receiptCloseBtn.addEventListener("click", () => {
            alert("회원권 결제가 완료되었습니다");
            membershipModal.hide(); // 모달 닫기
            // 모달 상태 초기화
            document.getElementById("mem-input-section").style.display = "block";
            document.getElementById("mem-receipt-section").style.display = "none";
            document.getElementById("mem-footer").style.display = "flex";
        });
    }

    // 결과 메시지 표시
    const flash = document.getElementById('flashMessage');
    if (flash && flash.dataset.msg) alert(flash.dataset.msg);
});

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

/* ===================== 회원권 결제 모달 ===================== */
function openMembershipModal() {
    // 신규 회원 모달에서 호출된 경우 검증
    const newCar = document.getElementById("newCarNumber");
    const newCarValue = newCar ? newCar.value.trim() : "";

    const memModalEl = document.getElementById('membershipPayModal');

    // 신규 회원 모달에서 호출된 경우
    if (newCarValue !== "") {
        const msg = validateMember(
            newCarValue,
            document.getElementById("newName").value.trim(),
            document.getElementById("newPhone").value.trim(),
            document.getElementById("newStartDate").value.trim()
        );

        if (msg) {
            alert(msg);
            return;
        }

        memModalEl.querySelector('#memMno').value = "";
        memModalEl.querySelector('#memCarNum').value = newCar.value;
        memModalEl.querySelector('#memName').value = document.getElementById("newName").value;
        memModalEl.querySelector('#memPhone').value = document.getElementById("newPhone").value;
        memModalEl.querySelector('#memStartDate').value = document.getElementById("newStartDate").value;
        memModalEl.querySelector('#memEndDate').value = document.getElementById("newExpireDate").value;

        new bootstrap.Modal(memModalEl).show();
        return;
    }

    // 기존 회원 상세 모달에서 호출된 경우
    const viewModalEl = document.getElementById('viewMemberModal');
    const mno = viewModalEl.querySelector('#mno').value.trim();
    const carNum = viewModalEl.querySelector('#viewCarNumber').textContent.trim();

    if (!mno || !carNum) {
        alert("선택된 차량 정보가 없습니다.");
        return;
    }

    bootstrap.Modal.getInstance(viewModalEl)?.hide();

    memModalEl.querySelector('#memMno').value = mno;
    memModalEl.querySelector('#memCarNum').value = carNum;
    memModalEl.querySelector('#memName').value = viewModalEl.querySelector('#viewName').textContent;
    memModalEl.querySelector('#memPhone').value = viewModalEl.querySelector('#viewPhone').textContent;
    memModalEl.querySelector('#memStartDate').value = viewModalEl.querySelector('#viewStartDate').textContent;
    memModalEl.querySelector('#memEndDate').value = viewModalEl.querySelector('#viewExpireDate').textContent;
    memModalEl.querySelector('#memPrice').value = Number(viewModalEl.querySelector('#viewCharge').textContent).toLocaleString() + "원";

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
    const inputs = ['newName', 'newPhone', 'newStartDate'];

    // 모든 입력창 초기화 및 비활성화
    ['newCarNumber', ...inputs].forEach(id => {
        const el = document.getElementById(id);
        if (el) {
            el.value = '';
            if (inputs.includes(id)) el.disabled = true; // 회원 확인 전 비활성화
        }
    });

    const startEl = document.getElementById('newStartDate');
    const endEl = document.getElementById('newExpireDate');

    if (startEl) startEl.value = today; // 시작일 오늘 날짜
    if (endEl && startEl) setEndDateBy30Days('newStartDate', 'newExpireDate'); // 만료일 자동 계산
}

/* ===================== 기존 회원 여부 확인 버튼 클릭 ===================== */
function checkExistingMember() {
    const carNum = document.getElementById('newCarNumber').value.trim();
    const carInput = document.getElementById('newCarNumber');

    // 차량번호 미입력 검사 추가
    const msg = validateMember(carNum);
    if (msg) {
        alert(msg);
        carInput.focus();
        return;
    }

    const mockMembers = [
        {carNum: "12가3456", name: "홍길동", phone: "010-1111-2222"},
        {carNum: "99나9999", name: "김철수", phone: "010-9999-8888"},
        {carNum: "10가5678", name: "회원10", phone: "010-1111-1110"}
    ];

    const member = mockMembers.find(m => m.carNum === carNum);

    // 회원 확인 후 입력창 활성화
    ['newName', 'newPhone', 'newStartDate'].forEach(id => {
        const el = document.getElementById(id);
        if (el) el.disabled = false;
    });

    if (member) {
        alert('등록된 회원 정보가 있습니다. 기존 정보로 입력을 진행합니다.')
        document.getElementById('newName').value = member.name;
        document.getElementById('newPhone').value = member.phone;
    } else {
        alert("등록된 정보가 없습니다. 신규 회원 정보를 입력해주세요.");
        document.getElementById('newName').focus();
    }
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
