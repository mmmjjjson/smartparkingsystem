// ===================== 상수 및 초기화 =====================
const ELEMENTS = {
    newMemberBtn: 'newMemberBtn',
    newMemberModal: 'newMemberModal',
    checkMemberBtn: 'btn-check-member',
    btnMembershipPay: 'btnMembershipPay',
    paySubmitBtn: 'btn-membership-submit',
    receiptCloseBtn: 'btn-receipt-close-final',
    flashMessage: 'flashMessage',
    newCarNumber: 'newCarNumber',
    checkResult: 'checkResult',
    isExistingMember: 'isExistingMember'
};

// ===================== 회원 정보 입력 검증 상수 =====================
const VALIDATION = {
    carPattern: /^[0-9]{2,3}[가-힣][0-9]{4}$/,
    phonePattern: /^[0-9]{3}-[0-9]{4}-[0-9]{4}$/
};

// ===================== 회원 확인 여부 =====================
let isMemberChecked = false;

// ===================== 페이지 로드 =====================
document.addEventListener('DOMContentLoaded', () => {
    initializeEventListeners();
    handlePageLoadCheckResult();
    showFlashMessage();
});

// ===================== 이벤트 리스너 초기화 =====================
function initializeEventListeners() {
    const elements = {
        newMemberBtn: document.getElementById(ELEMENTS.newMemberBtn),
        newMemberModal: document.getElementById(ELEMENTS.newMemberModal),
        checkMemberBtn: document.getElementById(ELEMENTS.checkMemberBtn),
        btnMembershipPay: document.getElementById(ELEMENTS.btnMembershipPay),
        paySubmitBtn: document.getElementById(ELEMENTS.paySubmitBtn),
        receiptCloseBtn: document.getElementById(ELEMENTS.receiptCloseBtn),
        carNumberInput: document.getElementById(ELEMENTS.newCarNumber)
    };

    // 신규 회원 등록 버튼
    elements.newMemberBtn?.addEventListener('click', () => {
        clearNewMemberInputs();
        isMemberChecked = false;
        new bootstrap.Modal(elements.newMemberModal).show();
    });

    // 모달 닫힐 때 회원 정보 초기화
    elements.newMemberModal?.addEventListener('hidden.bs.modal', () => {
        document.getElementById(ELEMENTS.newCarNumber).value = '';
        clearNewMemberInputs();
        isMemberChecked = false;
    });

    // 회원 확인 버튼
    elements.checkMemberBtn?.addEventListener('click', handleMemberCheck);
    elements.carNumberInput?.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') handleMemberCheck();
    });

    // 차량번호 변경 시 플래그 초기화
    elements.carNumberInput?.addEventListener('input', () => {
        isMemberChecked = false;
    });

    // 회원권 결제 버튼
    elements.btnMembershipPay?.addEventListener('click', () => {
        if (!isMemberChecked) {
            alert('회원 확인을 진행해주세요.');
            return;
        }
        openMembershipModal();
    });

    // 결제 버튼
    elements.paySubmitBtn?.addEventListener('click', handlePaymentSubmit);

    // 영수증 닫기 버튼
    elements.receiptCloseBtn?.addEventListener('click', () => {
        document.getElementById('newMemberForm').submit();
    });
}

// ===================== 페이지 로드 시 회원 확인 결과 처리 =====================
function handlePageLoadCheckResult() {
    const checkResult = document.getElementById(ELEMENTS.checkResult)?.value;
    if (checkResult === 'found' || checkResult === 'notFound') {
        handleMemberCheckResult(checkResult);
        isMemberChecked = true;
    }
}

// ===================== 회원 확인 결과 처리 =====================
function handleMemberCheckResult(result) {
    const modal = new bootstrap.Modal(document.getElementById(ELEMENTS.newMemberModal));
    const isFound = result === 'found';

    if (isFound) {
        fillExistingMemberData(); // 기존 회원 데이터 입력
    } else {
        fillNewMemberData(); // 신규 회원 데이터 입력
    }

    document.getElementById(ELEMENTS.isExistingMember).value = isFound;
    modal.show();

    const message = isFound ? '등록된 회원 정보가 있습니다. 기존 정보로 입력을 진행합니다.' : '등록된 정보가 없습니다. 신규 회원 정보를 입력해주세요.';
    alert(message);

    if (!isFound) {
        document.getElementById('newName').focus();
    }
}

// ===================== 기존 회원 데이터 입력 =====================
function fillExistingMemberData() {
    const memberData = {
        car: document.getElementById('memberCar').value,
        name: document.getElementById('memberName').value,
        phone: document.getElementById('memberPhone').value,
        end: document.getElementById('memberEnd').value
    };

    // 기존 회원 정보 설정
    setElementValue('newCarNumber', memberData.car);
    setElementValue('newName', memberData.name);
    setElementValue('newPhone', memberData.phone);

    // 시작일 설정 (가장 최근 만료일 + 1일)
    const startDate = getNextDay(memberData.end);
    const startEl = document.getElementById('newStartDate');
    startEl.value = startDate;
    startEl.min = startDate;
    startEl.disabled = false;

    // 만료일 자동 계산
    setEndDateBy30Days('newStartDate', 'newExpireDate');

    // 입력 필드 활성화
    enableElements(['newName', 'newPhone']);
}

// ===================== 신규 회원 데이터 입력 =====================
function fillNewMemberData() {
    const today = getTodayString();

    setElementValue('newStartDate', today);
    enableElements(['newName', 'newPhone', 'newStartDate', 'newExpireDate']);
    setEndDateBy30Days('newStartDate', 'newExpireDate');
}

// ===================== 회원 확인 요청 =====================
function handleMemberCheck() {
    const carInput = document.getElementById(ELEMENTS.newCarNumber);
    const carNum = carInput.value.trim();

    const validationMsg = validateCarNumber(carNum);
    if (validationMsg) {
        alert(validationMsg);
        carInput.focus();
        return;
    }

    submitForm('/member_check.do', {carNum});
}

// ===================== 회원권 결제 모달 =====================
function openMembershipModal() {
    const formData = getFormData();
    const validationMsg = validateMemberData(formData);

    if (validationMsg) {
        alert(validationMsg);
        return;
    }

    fillPaymentModal(formData);
    new bootstrap.Modal(document.getElementById('membershipPayModal')).show();
}

// ===================== 결제 제출 처리 =====================
function handlePaymentSubmit(e) {
    e.preventDefault();

    const formData = getFormData();
    fillHiddenInputs(formData);
    showMembershipReceipt();
}

// ===================== 영수증 표시 =====================
function showMembershipReceipt() {
    const receiptData = {
        car: document.getElementById('memCarNum').value,
        name: document.getElementById('memName').value,
        phone: document.getElementById('memPhone').value,
        startDate: document.getElementById('memStartDate').value,
        endDate: document.getElementById('memEndDate').value,
        price: document.getElementById('memPrice').value
    };

    document.getElementById('res-car').textContent = receiptData.car;
    document.getElementById('res-user').textContent = `${receiptData.name} / ${receiptData.phone}`;
    document.getElementById('res-period').textContent = `${receiptData.startDate} ~ ${receiptData.endDate}`;
    document.getElementById('res-price').textContent = receiptData.price;

    toggleReceiptView(true);
}

// ===================== 회원 상세 모달 =====================
function openViewModal(mno, car, name, phone, start, end, charge) {
    const viewModalEl = document.getElementById('viewMemberModal');
    const fields = {
        '#mno': mno,
        '#viewCarNumber': car,
        '#viewName': name,
        '#viewPhone': phone,
        '#viewStartDate': start,
        '#viewExpireDate': end,
        '#viewCharge': charge
    };

    // Object.entries: object(fields)의 key와 value을 한 쌍의 배열 형태로 꺼내는 메서드
    Object.entries(fields).forEach(([selector, value]) => {
        const element = viewModalEl.querySelector(selector);
        if (element.tagName === 'INPUT') {
            element.value = value; // INPUT 태그 요소의 값 설정
        } else {
            element.textContent = value;
        }
    });

    new bootstrap.Modal(viewModalEl).show();
}

// ===================== 회원 수정 모달 =====================
function openEditModal() {
    const viewModalEl = document.getElementById('viewMemberModal');
    const editModalEl = document.getElementById('editMemberModal');

    // 회원 상세 모달 닫기
    bootstrap.Modal.getInstance(viewModalEl)?.hide();

    // 데이터 전달
    const fieldMapping = {
        '#mno': '#editMno',
        '#viewCarNumber': '#editCarNumber',
        '#viewName': '#editName',
        '#viewPhone': '#editPhone',
        '#viewStartDate': '#editStartDate',
        '#viewExpireDate': '#editExpireDate'
    };

    Object.entries(fieldMapping).forEach(([viewSelector, editSelector]) => {
        const viewEl = viewModalEl.querySelector(viewSelector);
        const editEl = editModalEl.querySelector(editSelector);
        const value = viewEl.tagName === 'INPUT' ? viewEl.value : viewEl.textContent;
        editEl.value = value;
    });

    new bootstrap.Modal(editModalEl).show();
}

// ===================== 유틸리티 함수 =====================
// 오늘 날짜를 'YYYY-MM-DD' 형식의 문자열로 반환
function getTodayString() {
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

// 특정 날짜의 다음날을 'YYYY-MM-DD' 형식으로 반환
function getNextDay(dateString) {
    const date = new Date(dateString);
    date.setDate(date.getDate() + 1);
    return date.toISOString().slice(0, 10);
}

// 특정 요소의 값을 설정 (요소가 존재하는 경우)
function setElementValue(id, value) {
    const element = document.getElementById(id); // 요소 ID
    if (element) element.value = value; // 설정 값
}

// 특정 입력 요소들을 활성화
function enableElements(ids) {
    ids.forEach(id => {
        const element = document.getElementById(id); // 요소 ID
        if (element) element.disabled = false; // 입력 요소 활성화
    });
}

// 신규 회원 등록 폼의 모든 데이터를 객체로 반환
function getFormData() {
    return {
        carNum: document.getElementById('newCarNumber')?.value.trim() || '',
        name: document.getElementById('newName')?.value.trim() || '',
        phone: document.getElementById('newPhone')?.value.trim() || '',
        startDate: document.getElementById('newStartDate')?.value.trim() || '',
        endDate: document.getElementById('newExpireDate')?.value.trim() || '',
        isExistingMember: document.getElementById(ELEMENTS.isExistingMember)?.value || ''
    };
}

// 회원권 결제 모달에 회원 정보 입력
function fillPaymentModal(data) {
    const fields = {
        memCarNum: data.carNum,
        memName: data.name,
        memPhone: data.phone,
        memStartDate: data.startDate,
        memEndDate: data.endDate
    };

    Object.entries(fields).forEach(([id, value]) => {
        setElementValue(id, value);
    });
}

// 폼 제출을 위한 hidden input 필드에 데이터 입력
function fillHiddenInputs(data) {
    const hiddenFields = {
        newCarNumberHidden: data.carNum,
        newNameHidden: data.name,
        newPhoneHidden: data.phone,
        newStartDateHidden: data.startDate,
        newExpireDateHidden: data.endDate,
        isExistingMemberHidden: data.isExistingMember
    };

    Object.entries(hiddenFields).forEach(([id, value]) => {
        setElementValue(id, value);
    });
}

// 회원권 결제 모달에서 입력 섹션과 영수증 섹션 표시/숨김 전환
function toggleReceiptView(showReceipt) {
    document.getElementById('mem-input-section').style.display = showReceipt ? 'none' : 'block';
    document.getElementById('mem-receipt-section').style.display = showReceipt ? 'block' : 'none';
    document.getElementById('mem-footer').style.display = showReceipt ? 'none' : 'block';
}

// 동적으로 폼을 생성 -> POST 요청 전송
function submitForm(action, data) {
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = action;

    Object.entries(data).forEach(([name, value]) => {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = name;
        input.value = value;
        form.appendChild(input);
    });

    document.body.appendChild(form);
    form.submit();
}

// 신규 회원 입력 필드 초기화 (차량 번호 제외)
function clearNewMemberInputs() {
    const today = getTodayString();
    const inputs = ['newName', 'newPhone', 'newStartDate', 'newExpireDate'];

    inputs.forEach(id => {
        const el = document.getElementById(id);
        if (el) {
            el.value = '';
            el.disabled = true;
        }
    });

    setElementValue('newStartDate', today); // 모든 입력 필드 비우고 비활성화
    setEndDateBy30Days('newStartDate', 'newExpireDate');
    setElementValue(ELEMENTS.isExistingMember, '');
}

// 서버에서 설정한 플래시 메시지를 alert로 표시
function showFlashMessage() {
    const flash = document.getElementById(ELEMENTS.flashMessage);
    if (flash?.dataset.msg) {
        alert(flash.dataset.msg);
    }
}

// ===================== 검증 함수 =====================
function validateCarNumber(carNum) {
    if (!carNum) return '차량 번호를 입력해주세요.';
    if (!VALIDATION.carPattern.test(carNum)) return '차량 번호 형식이 올바르지 않습니다.';
    return null;
}

function validateMemberData(data) {
    const carMsg = validateCarNumber(data.carNum);
    if (carMsg) return carMsg;

    if (!data.name || !data.phone || !data.startDate) {
        return '필수 항목을 입력해주세요.';
    }

    if (!VALIDATION.phonePattern.test(data.phone)) {
        return '연락처 형식이 올바르지 않습니다.';
    }

    return null;
}

// ===================== 폼 제출 검증 =====================
function handleNewMemberSubmit() {
    const formData = getFormData();
    const msg = validateMemberData(formData);

    if (msg) {
        alert(msg);
        return false;
    }
    return true;
}

function handleEditSubmit() {
    const data = {
        carNum: document.getElementById('editCarNumber')?.value.trim() || '',
        name: document.getElementById('editName')?.value.trim() || '',
        phone: document.getElementById('editPhone')?.value.trim() || '',
        startDate: document.getElementById('editStartDate')?.value.trim() || ''
    };

    const msg = validateMemberData(data);
    if (msg) {
        alert(msg);
        return false;
    }
    return true;
}

// ===================== 기타 기능 =====================
// 연락처 자동 하이픈 입력
function autoHyphenPhone(input) {
    let v = input.value.replace(/\D/g, '').slice(0, 11);
    if (v.length >= 8) {
        input.value = v.replace(/(\d{3})(\d{4})(\d+)/, '$1-$2-$3');
    } else if (v.length >= 4) {
        input.value = v.replace(/(\d{3})(\d+)/, '$1-$2');
    } else {
        input.value = v;
    }
}

// 만료일 자동 설정 (시작일 기준 +30일)
function setEndDateBy30Days(startId, endId) {
    const startValue = document.getElementById(startId).value;
    if (!startValue) return;

    const [year, month, day] = startValue.split('-').map(Number);
    const date = new Date(year, month - 1, day);
    date.setDate(date.getDate() + 30);

    const endYear = date.getFullYear();
    const endMonth = String(date.getMonth() + 1).padStart(2, '0');
    const endDay = String(date.getDate()).padStart(2, '0');

    setElementValue(endId, `${endYear}-${endMonth}-${endDay}`);
}

// 결제 영수증 출력
function printReceipt() {
    const receiptSection = document.getElementById('mem-receipt-section');
    receiptSection.classList.add('receipt-print-area');
    window.print();
    receiptSection.classList.remove('receipt-print-area');
}


// document.addEventListener('DOMContentLoaded', () => {
//     const newMemberBtn = document.getElementById('newMemberBtn');
//     const newMemberModal = document.getElementById('newMemberModal');
//     const checkMemberBtn = document.getElementById('btn-check-member');
//     const btnMembershipPay = document.getElementById('btnMembershipPay');
//     const paySubmitBtn = document.getElementById('btn-membership-submit');
//     const receiptCloseBtn = document.getElementById('btn-receipt-close-final');
//     const flash = document.getElementById('flashMessage');
//
//     // 회원 확인 완료 여부
//     let isMemberChecked = false;
//
//     // 페이지 로드 시 회원 확인 결과 처리
//     const checkResult = document.getElementById('checkResult').value;
//     if (checkResult === 'found' || checkResult === 'notFound') {
//         handleMemberCheckResult(checkResult);
//         isMemberChecked = true;
//     }
//
//     // 신규 회원 등록 버튼
//     if (newMemberBtn) newMemberBtn.addEventListener('click', () => {
//         clearNewMemberInputs();
//         isMemberChecked = false;
//         new bootstrap.Modal(document.getElementById('newMemberModal')).show();
//     });
//
//     // 모달이 닫힐 때 모든 입력 필드 초기화
//     if (newMemberModal) {
//         newMemberModal.addEventListener('hidden.bs.modal', () => {
//             // 차량번호 포함 모든 필드 초기화
//             document.getElementById('newCarNumber').value = '';
//             clearNewMemberInputs();
//             isMemberChecked = false;
//         });
//     }
//
//     // 기존 회원 확인 버튼
//     if (checkMemberBtn) {
//         checkMemberBtn.addEventListener('click', () => {
//             handleMemberCheck();
//             // handleMemberCheck 내부에서 form submit되므로,
//             // 회원 확인 완료는 페이지 리로드 후 checkResult로 판단됨
//         });
//         document.getElementById('newCarNumber')
//             ?.addEventListener('keydown', (e) => {
//                 if (e.key === 'Enter') handleMemberCheck();
//             });
//     }
//
//     // 차량번호 입력 필드 변경 시 플래그 초기화
//     const carNumberInput = document.getElementById('newCarNumber');
//     if (carNumberInput) {
//         carNumberInput.addEventListener('input', () => {
//             isMemberChecked = false; // 차량번호 변경 시 재확인 필요
//         });
//     }
//
//     // 회원권 결제 버튼
//     if (btnMembershipPay) btnMembershipPay.addEventListener('click', () => {
//         // 회원 확인 여부 체크 추가
//         if (!isMemberChecked) {
//             alert('회원 확인을 진행해주세요.');
//             return;
//         }
//         openMembershipModal();
//     });
//
//     // 결제 버튼 클릭 → 영수증 보여주기 (form 제출은 닫기 버튼에서)
//     if (paySubmitBtn) {
//         paySubmitBtn.addEventListener('click', (e) => {
//             e.preventDefault(); // form 제출 막기
//
//             // 원본 값 가져오기
//             const carNum = document.getElementById('newCarNumber')?.value || '';
//             const name = document.getElementById('newName')?.value || '';
//             const phone = document.getElementById('newPhone')?.value || '';
//             const startDate = document.getElementById('newStartDate')?.value || '';
//             const expireDate = document.getElementById('newExpireDate')?.value || '';
//             const existingMember = document.getElementById('isExistingMember')?.value || '';
//
//             // hidden input 채우기
//             const newCarNumberHidden = document.getElementById('newCarNumberHidden');
//             const newNameHidden = document.getElementById('newNameHidden');
//             const newPhoneHidden = document.getElementById('newPhoneHidden');
//             const newStartDateHidden = document.getElementById('newStartDateHidden');
//             const newExpireDateHidden = document.getElementById('newExpireDateHidden');
//             const isExistingMemberHidden = document.getElementById('isExistingMemberHidden');
//
//             // null 체크 및 값 설정
//             if (newCarNumberHidden) newCarNumberHidden.value = carNum;
//             if (newNameHidden) newNameHidden.value = name;
//             if (newPhoneHidden) newPhoneHidden.value = phone;
//             if (newStartDateHidden) newStartDateHidden.value = startDate;
//             if (newExpireDateHidden) newExpireDateHidden.value = expireDate;
//             if (isExistingMemberHidden) isExistingMemberHidden.value = existingMember;
//
//             // 영수증 표시
//             showMembershipReceipt();
//         });
//     }
//
//     // 영수증 닫기 버튼 클릭 → form submit + 모달 닫기
//     if (receiptCloseBtn) {
//         receiptCloseBtn.addEventListener('click', () => {
//             document.getElementById('newMemberForm').submit(); // 서버 제출
//         });
//     }
//
//     // flash 메시지 alert
//     if (flash && flash.dataset.msg) alert(flash.dataset.msg);
// })
//
// /* ===================== 회원 확인 결과 처리 ===================== */
// function handleMemberCheckResult(result) {
//     const modal = new bootstrap.Modal(document.getElementById('newMemberModal'));
//
//     if (result === 'found') {
//         // 기존 회원 있음
//         const memberCar = document.getElementById('memberCar').value;
//         const memberName = document.getElementById('memberName').value;
//         const memberPhone = document.getElementById('memberPhone').value;
//         const memberEnd = document.getElementById('memberEnd').value;
//
//         document.getElementById('newCarNumber').value = memberCar;
//         document.getElementById('newName').value = memberName;
//         document.getElementById('newPhone').value = memberPhone;
//
//         // 기존 회원 플래그 설정
//         document.getElementById('isExistingMember').value = 'true';
//
//         const lastEnd = new Date(memberEnd);
//         lastEnd.setDate(lastEnd.getDate() + 1);
//         const nextDate = lastEnd.toISOString().slice(0, 10);
//
//         const startEl = document.getElementById('newStartDate');
//         startEl.value = nextDate;
//         startEl.min = nextDate;
//         startEl.disabled = false;
//
//         setEndDateBy30Days('newStartDate', 'newExpireDate');
//
//         ['newName', 'newPhone'].forEach(id => {
//             const el = document.getElementById(id);
//             if (el) el.disabled = false;
//         });
//
//         modal.show();
//         alert('등록된 회원 정보가 있습니다. 기존 정보로 입력을 진행합니다.');
//
//     } else if (result === 'notFound') {
//         // 기존 회원 없음
//         // 신규 회원 플래그 설정
//         document.getElementById('isExistingMember').value = 'false';
//
//         ['newName', 'newPhone', 'newStartDate', 'newExpireDate'].forEach(id => {
//             const el = document.getElementById(id);
//             if (el) {
//                 el.disabled = false;
//                 if (id === 'newStartDate') {
//                     // 오늘 날짜를 로컬 시간 기준으로 설정
//                     const today = new Date();
//                     const year = today.getFullYear();
//                     const month = String(today.getMonth() + 1).padStart(2, '0');
//                     const day = String(today.getDate()).padStart(2, '0');
//                     el.value = `${year}-${month}-${day}`;
//                 }
//             }
//         });
//
//         setEndDateBy30Days('newStartDate', 'newExpireDate');
//
//         modal.show();
//         document.getElementById('newName').focus();
//         alert('등록된 정보가 없습니다. 신규 회원 정보를 입력해주세요.');
//     }
// }
//
// /* ===================== 기존 회원 여부 확인 결과 ===================== */
// function handleMemberCheck() {
//     const carInput = document.getElementById('newCarNumber');
//     const carNum = carInput.value.trim();
//
//     // validateMember 함수 활용 (차량번호만 검증)
//     const msg = validateMember(carNum);
//     if (msg) {
//         alert(msg);
//         carInput.focus();
//         return;
//     }
//
//     // 폼 제출로 서버에 요청
//     const form = document.createElement('form');
//     form.method = 'POST';
//     form.action = '/member_check.do';
//
//     const input = document.createElement('input');
//     input.type = 'hidden';
//     input.name = 'carNum';
//     input.value = carNum;
//
//     form.appendChild(input);
//     document.body.appendChild(form);
//     form.submit();
// }
//
// /* ===================== 회원 선택 시 상세 모달 ===================== */
// function openViewModal(mno, car, name, phone, start, end, charge) {
//     const viewModalEl = document.getElementById('viewMemberModal');
//     viewModalEl.querySelector('#mno').value = mno;
//     viewModalEl.querySelector('#viewCarNumber').textContent = car;
//     viewModalEl.querySelector('#viewName').textContent = name;
//     viewModalEl.querySelector('#viewPhone').textContent = phone;
//     viewModalEl.querySelector('#viewStartDate').textContent = start;
//     viewModalEl.querySelector('#viewExpireDate').textContent = end;
//     viewModalEl.querySelector('#viewCharge').textContent = charge;
//
//     new bootstrap.Modal(viewModalEl).show();
// }
//
// /* ===================== 신규 회원 입력 초기화 ===================== */
// function clearNewMemberInputs() {
//     // 오늘 날짜를 로컬 시간 기준으로 가져오기
//     const today = new Date();
//     const year = today.getFullYear();
//     const month = String(today.getMonth() + 1).padStart(2, '0');
//     const day = String(today.getDate()).padStart(2, '0');
//     const todayString = `${year}-${month}-${day}`;
//
//     const inputs = ['newName', 'newPhone', 'newStartDate', 'newExpireDate'];
//
//     // 차량번호를 제외한 나머지만 초기화
//     inputs.forEach(id => {
//         const el = document.getElementById(id);
//         if (el) {
//             el.value = '';
//             el.disabled = true;  // 회원 확인 전 비활성화
//         }
//     });
//
//     document.getElementById('newStartDate').value = todayString;
//     setEndDateBy30Days('newStartDate', 'newExpireDate');
//
//     // 플래그 초기화
//     document.getElementById('isExistingMember').value = '';
// }
//
// /* ===================== 회원권 결제 모달 ===================== */
// function openMembershipModal() {
//     const carNum = document.getElementById('newCarNumber').value.trim();
//
//     // 차량번호가 없으면 먼저 체크
//     if (!carNum) {
//         alert('선택된 차량 정보가 없습니다.');
//         document.getElementById('newCarNumber').focus();
//         return;
//     }
//
//     // validateMember 함수로 전체 검증
//     const msg = validateMember(
//         document.getElementById('newCarNumber').value.trim(),
//         document.getElementById('newName').value.trim(),
//         document.getElementById('newPhone').value.trim(),
//         document.getElementById('newStartDate').value.trim()
//     );
//
//     if (msg) {
//         alert(msg);
//         return;
//     }
//
//     const memModalEl = document.getElementById('membershipPayModal');
//     memModalEl.querySelector('#memCarNum').value = document.getElementById("newCarNumber").value;
//     memModalEl.querySelector('#memName').value = document.getElementById("newName").value;
//     memModalEl.querySelector('#memPhone').value = document.getElementById("newPhone").value;
//     memModalEl.querySelector('#memStartDate').value = document.getElementById("newStartDate").value;
//     memModalEl.querySelector('#memEndDate').value = document.getElementById("newExpireDate").value;
//
//     new bootstrap.Modal(memModalEl).show();
// }
//
// /* ===================== 회원권 결제 영수증 모달 ===================== */
// function showMembershipReceipt() {
//     document.getElementById("res-car").textContent = document.getElementById("memCarNum").value;
//     document.getElementById("res-user").textContent =
//         `${document.getElementById("memName").value} / ${document.getElementById("memPhone").value}`;
//     document.getElementById("res-period").textContent =
//         `${document.getElementById("memStartDate").value} ~ ${document.getElementById("memEndDate").value}`;
//     document.getElementById("res-price").textContent = document.getElementById("memPrice").value;
//
//     document.getElementById("mem-input-section").style.display = "none";
//     document.getElementById("mem-receipt-section").style.display = "block";
//     document.getElementById("mem-footer").style.display = "none";
// }
//
// /* ===================== 영수증 출력 ===================== */
// function printReceipt() {
//     // 영수증 영역에 print용 class 추가
//     const receiptSection = document.getElementById("mem-receipt-section");
//     receiptSection.classList.add("receipt-print-area");
//
//     // 출력
//     window.print();
//
//     // 출력 후 class 제거 (선택사항)
//     receiptSection.classList.remove("receipt-print-area");
// }
//
// /* ===================== 회원 정보 수정 모달 ===================== */
// function openEditModal() {
//     const viewModalEl = document.getElementById('viewMemberModal');
//     const editModalEl = document.getElementById('editMemberModal');
//
//     // 회원 상세 모달 닫기
//     const viewModal = bootstrap.Modal.getInstance(viewModalEl);
//     if (viewModal) viewModal.hide();
//
//     editModalEl.querySelector('#editMno').value = viewModalEl.querySelector('#mno').value;
//     editModalEl.querySelector('#editCarNumber').value = viewModalEl.querySelector('#viewCarNumber').textContent;
//     editModalEl.querySelector('#editName').value = viewModalEl.querySelector('#viewName').textContent;
//     editModalEl.querySelector('#editPhone').value = viewModalEl.querySelector('#viewPhone').textContent;
//     editModalEl.querySelector('#editStartDate').value = viewModalEl.querySelector('#viewStartDate').textContent;
//     editModalEl.querySelector('#editExpireDate').value = viewModalEl.querySelector('#viewExpireDate').textContent;
//
//     new bootstrap.Modal(editModalEl).show();
// }
//
// /* ===================== 자동 하이픈 ===================== */
// function autoHyphenPhone(input) {
//     let v = input.value.replace(/\D/g, '').slice(0, 11);
//     if (v.length >= 8)
//         input.value = v.replace(/(\d{3})(\d{4})(\d+)/, '$1-$2-$3');
//     else if (v.length >= 4)
//         input.value = v.replace(/(\d{3})(\d+)/, '$1-$2');
//     else
//         input.value = v;
// }
//
// /* ===================== 만료일 자동 계산 ===================== */
// function setEndDateBy30Days(startId, endId) {
//     const s = document.getElementById(startId).value;
//     if (!s) return;
//
//     const parts = s.split('-');
//     const d = new Date(parts[0], parts[1] - 1, parts[2]); // 로컬 기준 생성
//
//     d.setDate(d.getDate() + 30);
//
//     const year = d.getFullYear();
//     const month = String(d.getMonth() + 1).padStart(2, '0');
//     const day = String(d.getDate()).padStart(2, '0');
//
//     document.getElementById(endId).value = `${year}-${month}-${day}`;
// }
//
// /* ===================== 회원 정보 입력 검증 ===================== */
// function validateMember(carNum, name, phone, start, end = true) {
//     const carPattern = /^[0-9]{2,3}[가-힣][0-9]{4}$/;
//     const phonePattern = /^[0-9]{3}-[0-9]{4}-[0-9]{4}$/;
//
//     // 차량번호 미입력 시
//     if (!carNum) return '차량 번호를 입력해주세요.';
//
//     // 차량번호 형식 오류
//     if (!carPattern.test(carNum)) return '차량 번호 형식이 올바르지 않습니다.';
//
//     // 나머지 필수값 검사 (회원권 결제용)
//     if (name !== undefined && phone !== undefined && start !== undefined) {
//         if (!name || !phone || !start) return '필수 항목을 입력해주세요.';
//         if (!phonePattern.test(phone)) return '연락처 형식이 올바르지 않습니다.';
//     }
//     return null;
// }
//
// /* ===================== 신규/수정 제출 검증 ===================== */
// function handleNewMemberSubmit() {
//     const msg = validateMember(
//         document.getElementById('newCarNumber').value.trim(),
//         document.getElementById('newName').value.trim(),
//         document.getElementById('newPhone').value.trim(),
//         document.getElementById('newStartDate').value.trim()
//     );
//     if (msg) {
//         alert(msg);
//         return false;
//     }
//     return true;
// }
//
// /* ===================== 회원 정보 수정 ===================== */
// function handleEditSubmit() {
//     const msg = validateMember(
//         document.getElementById('editCarNumber').value.trim(),
//         document.getElementById('editName').value.trim(),
//         document.getElementById('editPhone').value.trim(),
//         document.getElementById('editStartDate').value.trim()
//     );
//     if (msg) {
//         alert(msg);
//         return false;
//     }
//     return true;
// }
