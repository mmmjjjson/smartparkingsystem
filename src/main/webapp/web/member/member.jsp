<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Pretendard 폰트 -->
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
    <title>스마트 주차관리 시스템 - 회원 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="member.css">
</head>
<body>
<div class="member-wrap"> <!-- 디자인 통합 위해 container -> member-wrap으로 바꾸었습니다 -->
    <!-- 헤더 -->
    <%@ include file="../common/header_other.jsp" %>
    <!-- 콘텐츠 -->
    <div class="content">
        <div class="section-header">
            <div class="section-title">회원 관리 - 월정액 회원 정보 관리</div>
            <button class="add-btn" id="newMemberBtn">신규 회원 등록</button>
        </div>

        <!-- 회원 목록 테이블 -->
        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th>차량 번호</th>
                    <th>이름</th>
                    <th>연락처</th>
                    <th>시작일</th>
                    <th>만료일</th>
                </tr>
                </thead>
                <tbody id="memberTableBody">
                <%@ include file="member_list.jsp" %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- 신규 등록 모달 -->
<div class="modal" id="newMemberModal">
    <div class="modal-content">
        <form action="member_insert.jsp" method="post">
            <div class="modal-header">회원 정보 입력</div>

            <div class="form-group">
                <label class="form-label">차량 번호 (필수)</label>
                <input type="text" name="carNum" class="form-input" id="newCarNumber" placeholder="예: 12가 3456">
            </div>

            <div class="form-group">
                <label class="form-label">이름 (필수)</label>
                <input type="text" name="memberName" class="form-input" id="newName" placeholder="이름을 입력하세요">
            </div>

            <div class="form-group">
                <label class="form-label">연락처 (필수)</label>
                <input type="tel" name="memberPhone" class="form-input" id="newPhone" placeholder="예: 010-1234-5678">
            </div>

            <div class="form-group">
                <label class="form-label">시작일 (필수)</label>
                <input type="date" name="startDate" class="form-input" id="newStartDate">
            </div>

            <div class="form-group">
                <label class="form-label">만료일 (필수)</label>
                <input type="date" name="endDate" class="form-input" id="newExpireDate">
            </div>

            <div class="modal-buttons">
                <button type="submit" class="modal-btn btn-confirm" onclick="handleNewMemberSubmit()">등록</button>
                <button type="button" class="modal-btn btn-cancel" onclick="closeNewMemberModal()">취소</button>
            </div>
        </form>
    </div>
</div>

<!-- 회원 상세 정보 모달 -->
<div class="modal" id="viewMemberModal">
    <div class="modal-content">
        <div class="view-left">
            <div class="modal-header">회원 상세 정보</div>

            <div class="info-box">
                <div class="info-label">차량 번호:</div>
                <div class="info-value" id="viewCarNumber"></div>
            </div>

            <div class="info-box">
                <div class="info-label">이름:</div>
                <div class="info-value" id="viewName"></div>
            </div>

            <div class="info-box">
                <div class="info-label">연락처:</div>
                <div class="info-value" id="viewPhone"></div>
            </div>

            <div class="info-box">
                <div class="info-label">시작일:</div>
                <div class="info-value" id="viewStartDate"></div>
            </div>

            <div class="info-box">
                <div class="info-label">만료일:</div>
                <div class="info-value" id="viewExpireDate"></div>
            </div>

            <div class="modal-buttons">
                <button class="modal-btn btn-confirm" onclick="openEditModal()">수정</button>
                <button class="modal-btn btn-delete" onclick="handleDelete()">삭제</button>
                <button class="modal-btn btn-cancel" onclick="closeViewMemberModal()">닫기</button>
            </div>
        </div>
    </div>
</div>

<!-- 회원 정보 수정 모달 -->
<div class="modal" id="editMemberModal">
    <div class="modal-content">
        <form action="member_update.jsp" method="post">
            <div class="modal-header">회원 정보 수정</div>
            <input type="hidden" name="originCarNum" id="originCarNum">

            <div class="form-group">
                <label class="form-label">차량 번호 (필수)</label>
                <input type="text" name="carNum" class="form-input" id="editCarNumber">
            </div>

            <div class="form-group">
                <label class="form-label">이름 (필수)</label>
                <input type="text" name="memberName" class="form-input" id="editName">
            </div>

            <div class="form-group">
                <label class="form-label">연락처 (필수)</label>
                <input type="tel" name="memberPhone" class="form-input" id="editPhone">
            </div>

            <div class="form-group">
                <label class="form-label">시작일 (필수)</label>
                <input type="date" name="startDate" class="form-input" id="editStartDate">
            </div>

            <div class="form-group">
                <label class="form-label">만료일 (필수)</label>
                <input type="date" name="endDate" class="form-input" id="editExpireDate">
            </div>

            <div class="modal-buttons">
                <button type="submit" class="modal-btn btn-confirm" onclick="handleEditSubmit()">수정 완료</button>
                <button type="button" class="modal-btn btn-cancel" onclick="closeEditModal()">취소</button>
            </div>
        </form>
    </div>
</div>

<!-- 회원 삭제 모달 -->
<div class="modal" id="deleteConfirmModal">
    <div class="modal-content">
        <form action="member_delete.jsp" method="post">
            <input type="hidden" name="carNum" id="deleteCarNum">
            <div class="modal-header">회원 삭제</div>
            <div class="confirm-message">정말 삭제 하시겠습니까?</div>
            <div class="modal-buttons">
                <button type="submit" class="modal-btn btn-delete" onclick="confirmDelete()">삭제</button>
                <button type="button" class="modal-btn btn-cancel" onclick="closeDeleteConfirmModal()">취소</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openModal(carNumber, name, phone, startDate, expireDate) {
        document.getElementById('viewCarNumber').textContent = carNumber;
        document.getElementById('viewName').textContent = name;
        document.getElementById('viewPhone').textContent = phone;
        document.getElementById('viewStartDate').textContent = startDate.substring(0, 10);
        document.getElementById('viewExpireDate').textContent = expireDate.substring(0, 10);
        document.getElementById('viewMemberModal').classList.add('active');
    }

    function closeViewMemberModal() {
        document.getElementById('viewMemberModal').classList.remove('active');
    }

    function closeNewMemberModal() {
        document.getElementById('newMemberModal').classList.remove('active');
    }

    function closeEditModal() {
        document.getElementById('editMemberModal').classList.remove('active');
    }

    function openNewMemberModal() {
        document.getElementById('newCarNumber').value = '';
        document.getElementById('newName').value = '';
        document.getElementById('newPhone').value = '';
        document.getElementById('newStartDate').value = '';
        document.getElementById('newExpireDate').value = '';
        document.getElementById('newMemberModal').classList.add('active');
    }

    function openEditModal() {
        const originCarNum = document.getElementById('viewCarNumber').textContent;
        document.getElementById('originCarNum').value = originCarNum;
        document.getElementById('editCarNumber').value = originCarNum;
        document.getElementById('editName').value = document.getElementById('viewName').textContent;
        document.getElementById('editPhone').value = document.getElementById('viewPhone').textContent;
        document.getElementById('editStartDate').value = document.getElementById('viewStartDate').textContent;
        document.getElementById('editExpireDate').value = document.getElementById('viewExpireDate').textContent;
        closeViewMemberModal();
        document.getElementById('editMemberModal').classList.add('active');
    }

    function handleNewMemberSubmit() {
        const carNumber = document.getElementById('newCarNumber').value.trim();
        const name = document.getElementById('newName').value.trim();
        const phone = document.getElementById('newPhone').value.trim();
        const startDate = document.getElementById('newStartDate').value.trim();
        const expireDate = document.getElementById('newExpireDate').value.trim();

        if (!carNumber || !name || !phone || !startDate || !expireDate) {
            alert('모든 필드를 입력해주세요.');
            return;
        }

        const tableBody = document.getElementById('memberTableBody');
        if (!tableBody) {
            alert('테이블을 찾을 수 없습니다.');
            return;
        }

        const newRow = document.createElement('tr');
        newRow.onclick = function () {
            openModal(carNumber, name, phone, startDate, expireDate);
        };
        newRow.innerHTML = `
            <td>${carNumber}</td>
            <td>${name}</td>
            <td>${phone}</td>
            <td>${startDate}</td>
            <td>${expireDate}</td>
        `;
        tableBody.appendChild(newRow);

        alert('회원이 등록되었습니다.');
        closeNewMemberModal();
    }

    function handleEditSubmit() {
        alert('회원 정보가 수정되었습니다.');
        closeEditModal();
    }

    function handleDelete() {
        const carNum = document.getElementById('viewCarNumber').textContent;
        document.getElementById('deleteCarNum').value = carNum;
        closeViewMemberModal();
        document.getElementById('deleteConfirmModal').classList.add('active');
    }

    function confirmDelete() {
        alert('회원이 삭제되었습니다.');
        closeDeleteConfirmModal();
    }

    function closeDeleteConfirmModal() {
        document.getElementById('deleteConfirmModal').classList.remove('active');
    }

    document.getElementById('newMemberBtn').addEventListener('click', function (e) {
        e.preventDefault();
        openNewMemberModal();
    });

    window.onclick = function (event) {
        var newModal = document.getElementById('newMemberModal');
        var viewModal = document.getElementById('viewMemberModal');
        var editModal = document.getElementById('editMemberModal');
        var deleteModal = document.getElementById('deleteConfirmModal');

        if (event.target === newModal) newModal.classList.remove('active');
        if (event.target === viewModal) viewModal.classList.remove('active');
        if (event.target === editModal) editModal.classList.remove('active');
        if (event.target === deleteModal) deleteModal.classList.remove('active');
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<%@ include file="../common/footer.jsp" %>
</body>
</html>
