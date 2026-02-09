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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="css/member.css">
    <link rel="stylesheet" href="../../login/css/styles.css">
<%--    <link rel="stylesheet" href="../../login/css/styles.css">--%>
    <script src="js/member.js" defer></script>
    <script src="../main/main_membershipPay.js" defer></script>
</head>
<body>
<div class="container">
    <!-- 헤더 -->
    <%@ include file="../common/header_member.jsp" %>

    <!-- 콘텐츠 -->
    <div class="content">
        <div class="section-header">
            <div class="section-title">회원 관리 - 월정액 회원 정보 관리</div>
            <div>
                <button class="btn btn-primary" id="newMemberBtn">신규 회원 등록</button>
                <button class="btn btn-primary" id="btnMembershipPay">회원권 결제</button>
            </div>
        </div>

        <!-- 회원 정보 검색 -->
        <form method="get" action="member.jsp" class="search-bar">
            <select id="searchType" name="searchType">
                <option value="carNum" <%= "carNum".equals(request.getParameter("searchType")) ? "selected" : "" %>>차량 번호</option>
                <option value="name" <%= "name".equals(request.getParameter("searchType")) ? "selected" : "" %>>이름</option>
                <option value="phone" <%= "phone".equals(request.getParameter("searchType")) ? "selected" : "" %>>연락처</option>
            </select>

            <input type="text" name="keyword" value="<%= request.getParameter("keyword") == null ? "" : request.getParameter("keyword") %>">

            <button onclick="searchMember()">검색</button>
        </form>


        <!-- 회원 목록 테이블 -->
        <div class="table-container">
            <table id="memberTableBody">
                <!-- 회원 목록 -->
                <%@ include file="member_list.jsp" %>
            </table>
        </div>
    </div>
</div>

<!-- 회원권 결제 모달 -->
<div class="modal fade" id="membershipPayModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title fw-bold">신규 회원권 결제</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <div id="mem-input-section">
                    <input type="hidden" name="mno" id="memMno">

                    <div class="mb-3">
                        <label class="form-label fw-bold">차량 번호</label>
                        <div class="input-group">
                            <input type="text" id="memCarNum" class="form-control" readonly>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">이름</label>
                        <input type="text" id="memName" class="form-control" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">연락처</label>
                        <input type="text" id="memPhone" class="form-control" readonly>
                    </div>

                    <div class="row">
                        <div class="col-6 mb-3">
                            <label class="form-label fw-bold">시작일</label>
                            <input type="date" id="memStartDate" class="form-control" readonly>
                        </div>
                        <div class="col-6 mb-3">
                            <label class="form-label fw-bold">만료일</label>
                            <input type="date" id="memEndDate" class="form-control" readonly>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">총 결제 요금</label>
                        <input type="text" id="memPrice" class="form-control fw-bold text-primary" value="100,000원" readonly>
                    </div>
                </div>

                <div id="mem-receipt-section" style="display: none;">
                    <div class="p-4 border border-2 border-dark rounded bg-light">
                        <h4 class="text-center fw-bold mb-4">회원권 결제 영수증</h4>
                        <div class="d-flex justify-content-between mb-2">
                            <span>차량번호:</span> <span id="res-car" class="fw-bold"></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>성함/연락처:</span> <span id="res-user"></span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-2">
                            <span>권종:</span> <span>정기 정액권 (30일)</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>유효기간:</span> <span id="res-period" class="text-primary"></span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between fs-5 fw-bold">
                            <span>결제금액:</span> <span id="res-price" class="text-danger"></span>
                        </div>
                    </div>
                    <div class="mt-3">
                        <button class="btn btn-dark w-100" onclick="window.print()">영수증 출력</button>
                    </div>
                    <div class="mt-3">
                        <button type="button" id="btn-receipt-close-final" class="btn btn-secondary w-100">닫기</button>
                    </div>
                </div>

                <div class="modal-footer" id="mem-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                    <button type="button" class="btn btn-primary px-4" id="btn-membership-submit">결제하기</button>
                </div>
            </div>
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
                <input type="text" name="carNum" placeholder="예: 12가3456" maxlength="8" class="input" id="newCarNumber">
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
                <input type="date" name="startDate" class="input" id="editStartDate"
                       onchange="setEndDateByOneMonth('editStartDate', 'editExpireDate')">
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

<%@ include file="../common/footer.jsp" %>
</html>