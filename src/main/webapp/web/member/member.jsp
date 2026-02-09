<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>스마트 주차관리 시스템 - 회원 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            padding: 20px;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        /* 콘텐츠 */
        .content {
            padding: 30px;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e0e0e0;
        }

        .section-title {
            font-size: 22px;
            font-weight: bold;
            color: #333;
        }

        .add-btn {
            padding: 10px 20px;
            background-color: #4472c4;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s;
            font-size: 18px;
        }

        .add-btn:hover {
            background-color: #3558a0;
        }

        /* 테이블 */
        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            text-align: center;
        }

        th {
            background-color: #f9f9f9;
            padding: 15px;
            text-align: center;
            font-weight: 600;
            color: #333;
            border-bottom: 2px solid #ddd;
            font-size: 18px;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #e0e0e0;
            color: #555;
            font-size: 18px;
        }

        tbody tr {
            cursor: pointer;
        }

        tbody tr:hover {
            background-color: #e8f0f8;
        }

        /* 회원 정보 입력 모달 */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            justify-content: center;
            align-items: center;
        }

        .modal.active {
            display: flex;
        }

        .modal-content {
            background-color: white;
            padding: 40px;
            border-radius: 8px;
            width: 90%;
            max-width: 700px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
            max-height: 90vh;
            overflow-y: auto;
        }

        .modal-header {
            border-bottom: 2px solid #333;
            padding-bottom: 15px;
            margin-bottom: 30px;
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }

        .form-group {
            margin-bottom: 25px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-label { /* 각 라벨 */
            font-weight: 600;
            color: #333;
            font-size: 16px;
            padding: 8px 15px;
            border: 1px solid #333;
            display: inline-block;
            width: fit-content;
        }

        .form-input { /* 각 입력 요소 */
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            color: #333;
        }

        .form-input:focus {
            outline: none;
            border-color: #4472c4;
        }

        .form-input[readonly] {
            background-color: #f5f5f5;
            border: none;
        }

        /* 회원 상세 정보 모달 전용 스타일 */
        #viewMemberModal .modal-content {
            display: flex;
            gap: 40px;
        }

        .view-left {
            flex: 1;
        }

        .info-box {
            border: 1px solid #ddd;
            padding: 20px;
            margin-bottom: 20px;
            background-color: white;
        }

        .info-label {
            display: inline-block;
            width: 100px;
            font-weight: 600;
            color: #333;
            font-size: 18px;
            margin-bottom: 10px;
        }

        .info-value {
            display: inline-block;
            font-size: 18px;
            color: #555;
            line-height: 1.6;
        }

        .modal-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 40px;
        }

        .modal-btn {
            padding: 12px 50px;
            font-size: 18px;
            font-weight: 600;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
            width: auto;
        }

        .btn-confirm {
            background-color: #4472c4;
            color: white;
        }

        .btn-confirm:hover {
            background-color: #3558a0;
        }

        .btn-delete {
            background-color: #ed7d31;
            color: white;
        }

        .btn-delete:hover {
            background-color: #d16b1f;
        }

        .btn-cancel {
            background-color: white;
            color: #333;
            border: 2px solid #ddd;
        }

        .btn-cancel:hover {
            background-color: #f5f5f5;
        }

        /* 삭제 확인 모달 */
        #deleteConfirmModal .modal-content {
            max-width: 500px;
            text-align: center;
        }

        .confirm-message {
            font-size: 22px;
            font-weight: 600;
            color: #333;
            margin: 40px 0;
            line-height: 1.8;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- 헤더 -->
    <%@ include file="../common/header_member.jsp" %>
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
                <input type="text" name="carNum" value="예: 12가 3456" class="form-input" id="newCarNumber">
            </div>

            <div class="form-group">
                <label class="form-label">이름 (필수)</label>
                <input type="text" name="memberName" value="이름을 입력하세요" class="form-input" id="newName">
            </div>

            <div class="form-group">
                <label class="form-label">연락처 (필수)</label>
                <input type="tel" name="memberPhone" value="예: 010-1234-5678" class="form-input" id="newPhone">
            </div>

            <div class="form-group">
                <label class="form-label">시작일 (필수)</label>
                <input type="date" name="startDate" value="예: 2025-01-01" class="form-input" id="newStartDate">
            </div>

            <div class="form-group">
                <label class="form-label">만료일 (필수)</label>
                <input type="date" name="endDate" value="예: 2025-12-31" class="form-input" id="newExpireDate">
            </div>

            <div class="modal-buttons">
                <button type="submit" class="modal-btn btn-confirm" onclick="handleNewMemberSubmit()">등록</button>
                <button type="button" class="modal-btn btn-cancel" onclick="closeNewMemberModal()">취소</button>
            </div>
        </form>
    </div>
</div>

<!-- 회원 상세 정보 모달 (조회만) -->
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
        // 기존 차량 번호
        const originCarNum = document.getElementById('viewCarNumber').textContent;

        // 새로 수정할 차량 번호
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

        if (event.target === newModal) {
            newModal.classList.remove('active');
        }
        if (event.target === viewModal) {
            viewModal.classList.remove('active');
        }
        if (event.target === editModal) {
            editModal.classList.remove('active');
        }
        if (event.target === deleteModal) {
            deleteModal.classList.remove('active');
        }
    }
</script>
</body>
<%@ include file="../common/footer.jsp" %>
</html>