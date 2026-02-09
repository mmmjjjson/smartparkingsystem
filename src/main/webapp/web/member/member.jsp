<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<%--<%@include file="/web/main/main_process.jsp"%>--%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>스마트 주차관리 시스템 - 회원 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/member.css">
<%--    <link rel="stylesheet" href="../../login/css/styles.css">--%>
    <script src="js/member.js" defer></script>
</head>
<body>
<div class="container">
    <!-- 헤더 -->
    <%@ include file="../common/header_member.jsp" %>

    <!-- 콘텐츠 -->
    <div class="content">
        <div class="section-header">
            <div class="section-title">회원 관리 - 월정액 회원 정보 관리</div>
            <button class="btn btn-primary" id="newMemberBtn">신규 회원 등록</button>
        </div>

        <!-- 회원 목록 테이블 -->
        <div class="table-container">
            <table>
                <!-- 테이블 제목 -->
                <thead>
                <tr>
                    <th>차량 번호</th>
                    <th>이름</th>
                    <th>연락처</th>
                    <th>시작일</th>
                    <th>만료일</th>
                </tr>
                </thead>

                <!-- 회원 목록 -->
                <tbody id="memberTableBody">
                <%@ include file="member_list.jsp" %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- 신규 회원 등록 모달 -->
<div class="modal" id="newMemberModal">
    <div class="modal-box modal-lg">
        <form action="member_insert.jsp" method="post" onsubmit="return handleNewMemberSubmit()">
            <div class="modal-header">회원 정보 입력</div>

            <div class="form-group">
                <label class="label">차량 번호 (필수)</label>
                <input type="text" name="carNum" placeholder="예: 12가3456" maxlength="8" class="input"
                       id="newCarNumber">
            </div>

            <div class="form-group">
                <label class="label">이름 (필수)</label>
                <input type="text" name="memberName" placeholder="이름을 입력하세요" class="input" id="newName">
            </div>

            <div class="form-group">
                <label class="label">연락처 (필수)</label>
                <input type="tel" name="memberPhone" placeholder="예: 010-1234-5678" maxlength="13"
                       oninput="autoHyphenPhone(this)" class="input" id="newPhone">
            </div>

            <div class="form-group">
                <label class="label">시작일 (필수)</label>
                <input type="date" name="startDate" class="input" id="newStartDate"
                       onchange="setEndDateByOneMonth('newStartDate', 'newExpireDate')">
            </div>

            <div class="form-group">
                <label class="label">만료일 (필수)</label>
                <input type="date" name="endDate" class="input" id="newExpireDate" readonly>
            </div>

            <div class="modal-buttons">
                <button type="submit" class="btn btn-primary">등록</button>
                <button type="button" class="btn btn-outline" onclick="closeAllModals()">취소</button>
            </div>
        </form>
    </div>
</div>

<!-- 회원 상세 정보 모달 (조회만) -->
<div class="modal" id="viewMemberModal">
    <div class="modal-box modal-lg">
        <div class="view-left">
            <div class="modal-header">회원 상세 정보</div>
            <input type="hidden" name="mno" id="mno">

            <div class="form-group">
                <div class="label">차량 번호:</div>
                <div class="input" id="viewCarNumber"></div>
            </div>

            <div class="form-group">
                <div class="label">이름:</div>
                <div class="input" id="viewName"></div>
            </div>

            <div class="form-group">
                <div class="label">연락처:</div>
                <div class="input" id="viewPhone"></div>
            </div>

            <div class="form-group">
                <div class="label">시작일:</div>
                <div class="input" id="viewStartDate"></div>
            </div>

            <div class="form-group">
                <div class="label">만료일:</div>
                <div class="input" id="viewExpireDate"></div>
            </div>

            <div class="modal-buttons">
                <button class="btn btn-primary" onclick="openEditModal()">수정</button>
                <button class="btn btn-danger" onclick="handleDelete()">삭제</button>
                <button class="btn btn-outline" onclick="closeAllModals()">닫기</button>
            </div>
        </div>
    </div>
</div>

<!-- 회원 정보 수정 모달 -->
<div class="modal" id="editMemberModal">
    <div class="modal-box modal-lg">
        <form action="member_update.jsp" method="post" onsubmit="return handleEditSubmit()">
            <div class="modal-header">회원 정보 수정</div>
            <input type="hidden" name="mno" id="editMno">

            <div class="form-group">
                <label class="label">차량 번호 (필수)</label>
                <input type="text" name="carNum" class="input" id="editCarNumber">
            </div>

            <div class="form-group">
                <label class="label">이름 (필수)</label>
                <input type="text" name="memberName" class="input" id="editName">
            </div>

            <div class="form-group">
                <label class="label">연락처 (필수)</label>
                <input type="tel" name="memberPhone" class="input" maxlength="13" oninput="autoHyphenPhone(this)"
                       id="editPhone">
            </div>

            <div class="form-group">
                <label class="label">시작일 (필수)</label>
                <input type="date" name="startDate" class="input" id="editStartDate">
            </div>

            <div class="form-group">
                <label class="label">만료일 (필수)</label>
                <input type="date" name="endDate" class="input" id="editExpireDate">
            </div>

            <div class="modal-buttons">
                <button type="submit" class="btn btn-primary">수정 완료</button>
                <button type="button" class="btn btn-outline" onclick="closeAllModals()">취소</button>
            </div>
        </form>
    </div>
</div>

<!-- 회원 삭제 모달 -->
<div class="modal" id="deleteConfirmModal">
    <div class="modal-box modal-md">
        <form action="member_delete.jsp" method="post">
            <input type="hidden" name="mno" id="deleteMno">
            <div class="modal-header">회원 삭제</div>
            <div class="confirm-message">정말 삭제 하시겠습니까?</div>
            <div class="modal-buttons">
                <button type="submit" class="btn btn-danger">삭제</button>
                <button type="button" class="btn btn-outline" onclick="closeAllModals()">취소</button>
            </div>
        </form>
    </div>
</div>

<!-- 결과 안내 모달 -->
<%
    String flashMsg = (String) session.getAttribute("flashMsg");
    if (flashMsg != null) {
%>
<div id="flashMessage" data-msg="<%= flashMsg %>"></div>
<%
        session.removeAttribute("flashMsg");
    }
%>
</body>

<%@ include file="../common/footer.jsp" %>
</html>