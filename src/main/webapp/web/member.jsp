<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<%@include file="/web/main/main_process.jsp"%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>스마트 주차관리 시스템 - 회원 관리</title>
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
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        /* 헤더 */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 30px;
            border-bottom: 3px solid #333;
        }

        .header-title {
            font-size: 16px;
            font-weight: bold;
            color: #333;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: #f9f9f9;
        }

        .nav-buttons {
            display: flex;
            gap: 10px;
        }

        .nav-btn {
            padding: 10px 20px;
            border: 1px solid #ddd;
            background-color: white;
            color: #333;
            cursor: pointer;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
        }

        .nav-btn:hover {
            background-color: #f0f0f0;
        }

        .nav-btn.active {
            background-color: #4472c4;
            color: white;
            border-color: #4472c4;
        }

        .logout-btn {
            padding: 10px 20px;
            background-color: white;
            color: #333;
            border: 1px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
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
            font-size: 16px;
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
        }

        th {
            background-color: #f9f9f9;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #333;
            border-bottom: 2px solid #ddd;
            font-size: 14px;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #e0e0e0;
            color: #555;
            font-size: 14px;
        }

        tbody tr {
            cursor: pointer;
        }

        tbody tr:hover {
            background-color: #e8f0f8;
        }

        .empty-message {
            text-align: center;
            padding: 40px 20px;
            color: #999;
            font-size: 16px;
        }

        /* 모달 */
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
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
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

        .form-label {
            font-weight: 600;
            color: #333;
            font-size: 14px;
            padding: 8px 15px;
            border: 1px solid #333;
            display: inline-block;
            width: fit-content;
        }

        .form-input {
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
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

        .view-right {
            width: 250px;
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
            font-size: 14px;
            margin-bottom: 10px;
        }

        .info-value {
            display: inline-block;
            font-size: 14px;
            color: #555;
            line-height: 1.6;
        }

        .right-section {
            border: 2px solid #4472c4;
            padding: 20px;
            border-radius: 4px;
            text-align: center;
        }

        .right-section-label {
            font-size: 12px;
            color: #999;
            margin-bottom: 10px;
        }

        .right-section-value {
            font-size: 16px;
            color: #333;
            font-weight: 600;
        }

        .modal-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 40px;
        }

        .modal-btn {
            padding: 12px 50px;
            font-size: 16px;
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
            font-size: 20px;
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
    <div class="header">
        <div class="header-title">스마트 주차관리 시스템</div>
        <div class="nav-buttons">
            <button class="nav-btn">대시보드</button>
            <button class="nav-btn active">회원 관리</button>
            <button class="nav-btn">설정 관리</button>
            <button class="nav-btn">통계</button>
            <button class="logout-btn">로그아웃</button>
        </div>
    </div>

    <!-- 콘텐츠 -->
    <div class="content">
        <div class="section-header">
            <div class="section-title">회원 관리 - 원정액 회원 정보 관리</div>
            <button class="add-btn" id="newMemberBtn">신규 회원 등록</button>
        </div>

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
                <tr onclick="openModal('12가 3456', '김철수', '010-1234-5678', '2025-01-01', '2025-12-31')">
                    <td>12가 3456</td>
                    <td>김철수</td>
                    <td>010-1234-5678</td>
                    <td>2025-01-01</td>
                    <td>2025-12-31</td>
                </tr>
                <tr onclick="openModal('34나 7890', '이영희', '010-2345-6789', '2025-01-01', '2025-06-30')">
                    <td>34나 7890</td>
                    <td>이영희</td>
                    <td>010-2345-6789</td>
                    <td>2025-01-01</td>
                    <td>2025-06-30</td>
                </tr>
                <tr onclick="openModal('56다 1234', '박민수', '010-3456-7890', '2024-12-01', '2025-11-30')">
                    <td>56다 1234</td>
                    <td>박민수</td>
                    <td>010-3456-7890</td>
                    <td>2024-12-01</td>
                    <td>2025-11-30</td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- 신규 등록 모달 -->
<div class="modal" id="newMemberModal">
    <div class="modal-content">
        <div class="modal-header">회원 정보 입력</div>

        <div class="form-group">
            <label class="form-label">차량 번호 (필수)</label>
            <input type="text" value="예: 12가 3456" class="form-input" id="newCarNumber">
        </div>

        <div class="form-group">
            <label class="form-label">이름 (필수)</label>
            <input type="text" value="이름을 입력하세요" class="form-input" id="newName">
        </div>

        <div class="form-group">
            <label class="form-label">연락처 (필수)</label>
            <input type="tel" value="예: 010-1234-5678" class="form-input" id="newPhone">
        </div>

        <div class="form-group">
            <label class="form-label">시작일 (필수)</label>
            <input type="date" value="예: 2025-01-01" class="form-input" id="newStartDate">
        </div>

        <div class="form-group">
            <label class="form-label">만료일 (필수)</label>
            <input type="date" value="예: 2025-12-31" class="form-input" id="newExpireDate">
        </div>

        <div class="modal-buttons">
            <button class="modal-btn btn-confirm" onclick="handleNewMemberSubmit()">등록</button>
            <button class="modal-btn btn-cancel" onclick="closeNewMemberModal()">취소</button>
        </div>
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
        <div class="modal-header">회원 정보 수정</div>

        <div class="form-group">
            <label class="form-label">차량 번호 (필수)</label>
            <input type="text" class="form-input" id="editCarNumber">
        </div>

        <div class="form-group">
            <label class="form-label">이름 (필수)</label>
            <input type="text" class="form-input" id="editName">
        </div>

        <div class="form-group">
            <label class="form-label">연락처 (필수)</label>
            <input type="tel" class="form-input" id="editPhone">
        </div>

        <div class="form-group">
            <label class="form-label">시작일 (필수)</label>
            <input type="date" class="form-input" id="editStartDate">
        </div>

        <div class="form-group">
            <label class="form-label">만료일 (필수)</label>
            <input type="date" class="form-input" id="editExpireDate">
        </div>

        <div class="modal-buttons">
            <button class="modal-btn btn-confirm" onclick="handleEditSubmit()">수정 완료</button>
            <button class="modal-btn btn-cancel" onclick="closeEditModal()">취소</button>
        </div>
    </div>
</div>

<!-- 삭제 확인 모달 -->
<div class="modal" id="deleteConfirmModal">
    <div class="modal-content">
        <div class="modal-header">회원 삭제</div>
        <div class="confirm-message">정말 삭제 하시겠습니까?</div>
        <div class="modal-buttons">
            <button class="modal-btn btn-delete" onclick="confirmDelete()">삭제</button>
            <button class="modal-btn btn-cancel" onclick="closeDeleteConfirmModal()">취소</button>
        </div>
    </div>
</div>

<script>
    function openModal(carNumber, name, phone, startDate, expireDate) {
        document.getElementById('viewCarNumber').textContent = carNumber;
        document.getElementById('viewName').textContent = name;
        document.getElementById('viewPhone').textContent = phone;
        document.getElementById('viewStartDate').textContent = startDate;
        document.getElementById('viewExpireDate').textContent = expireDate;
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
        document.getElementById('editCarNumber').value = document.getElementById('viewCarNumber').textContent;
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
        newRow.onclick = function() {
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

    document.getElementById('newMemberBtn').addEventListener('click', function(e) {
        e.preventDefault();
        openNewMemberModal();
    });

    window.onclick = function(event) {
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
</html>