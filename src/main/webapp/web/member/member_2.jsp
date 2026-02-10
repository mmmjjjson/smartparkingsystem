<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>스마트 주차관리 시스템 - 회원 관리</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- 기존 CSS / JS 유지 -->
<%--    <link rel="stylesheet" href="css/member.css">--%>
<%--    <link rel="stylesheet" href="../../login/css/styles.css">--%>

    <script src="js/member.js" defer></script>
    <script src="../main/main_membershipPay.js" defer></script>
</head>

<body class="bg-light">

<div class="container-fluid px-4">
    <%@ include file="../common/header_member.jsp" %>

    <!-- 제목 + 버튼 -->
    <div class="d-flex justify-content-between align-items-center mt-4 mb-3">
        <h4 class="fw-bold mb-0">회원 관리 - 월정액 회원 정보 관리</h4>
        <div class="d-flex gap-2">
            <button class="btn btn-primary" id="newMemberBtn">신규 회원 등록</button>
            <button class="btn btn-outline-primary" id="btnMembershipPay">회원권 결제</button>
        </div>
    </div>

    <!-- 검색 / 필터 -->
    <div class="card mb-3">
        <div class="card-body d-flex justify-content-between align-items-center flex-wrap gap-3">

            <form method="get" action="member.jsp" class="d-flex gap-2">
                <select name="searchType" class="form-select">
                    <option value="carNum" <%= "carNum".equals(request.getParameter("searchType")) ? "selected" : "" %>>차량 번호</option>
                    <option value="name" <%= "name".equals(request.getParameter("searchType")) ? "selected" : "" %>>이름</option>
                    <option value="phone" <%= "phone".equals(request.getParameter("searchType")) ? "selected" : "" %>>연락처</option>
                </select>

                <input type="text" name="keyword" class="form-control"
                       value="<%= request.getParameter("keyword") == null ? "" : request.getParameter("keyword") %>">

                <button class="btn btn-dark">검색</button>
            </form>

            <div class="btn-group">
                <a href="member.jsp"
                   class="btn btn-outline-primary <%= request.getParameter("status") == null ? "active" : "" %>">
                    회원
                </a>
                <a href="member.jsp?status=expired"
                   class="btn btn-outline-secondary <%= "expired".equals(request.getParameter("status")) ? "active" : "" %>">
                    비회원
                </a>
            </div>
        </div>
    </div>

    <!-- 회원 목록 -->
    <div class="card">
        <div class="table-responsive">
            <table class="table table-hover table-bordered align-middle text-center mb-0">
                <%@ include file="member_list.jsp" %>
            </table>
        </div>
    </div>
</div>

<!-- ========================= 회원권 결제 모달 ========================= -->
<div class="modal fade" id="membershipPayModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <form action="membership_pay.jsp" method="post">
                <input type="hidden" name="mno" id="memMno">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">회원권 결제</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">차량 번호</label>
                        <input type="text" class="form-control" id="memCarNum" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">이름</label>
                        <input type="text" class="form-control" id="memName" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">연락처</label>
                        <input type="text" class="form-control" id="memPhone" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">시작일</label>
                        <input type="text" class="form-control" id="memStartDate" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">만료일</label>
                        <input type="text" class="form-control" id="memEndDate" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">결제금액</label>
                        <input type="text" class="form-control" id="memPrice" readonly>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-primary">결제</button>
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
                </div>
            </form>
        </div>
    </div>
</div>


<!-- ========================= 신규 회원 모달 ========================= -->
<div class="modal fade" id="newMemberModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <form action="member_insert.jsp" method="post" onsubmit="return handleNewMemberSubmit()">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">신규 회원 등록</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold">차량 번호</label>
                        <input type="text" name="carNum" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">이름</label>
                        <input type="text" name="memberName" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">연락처</label>
                        <input type="tel" name="memberPhone" class="form-control">
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">시작일</label>
                            <input type="date" name="startDate" class="form-control">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">만료일</label>
                            <input type="date" name="endDate" class="form-control">
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button class="btn btn-primary">등록</button>
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ========================= 회원 상세 모달 ========================= -->
<div class="modal fade" id="viewMemberModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">회원 상세 정보</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <input type="hidden" id="mno">
                <ul class="list-group">
                    <li class="list-group-item"><strong>차량 번호 :</strong> <span id="viewCarNumber"></span></li>
                    <li class="list-group-item"><strong>이름 :</strong> <span id="viewName"></span></li>
                    <li class="list-group-item"><strong>연락처 :</strong> <span id="viewPhone"></span></li>
                    <li class="list-group-item"><strong>시작일 :</strong> <span id="viewStartDate"></span></li>
                    <li class="list-group-item"><strong>만료일 :</strong> <span id="viewExpireDate"></span></li>
                </ul>
            </div>

            <div class="modal-footer">
                <button class="btn btn-primary" onclick="openEditModal()">수정</button>
                <button class="btn btn-danger" onclick="handleDelete()">삭제</button>
                <button class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

<!-- ========================= 회원 수정 모달 ========================= -->
<div class="modal fade" id="editMemberModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <form action="member_update.jsp" method="post">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">회원 정보 수정</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <input type="hidden" name="mno" id="editMno">

                    <div class="mb-3">
                        <label class="form-label fw-bold">차량 번호</label>
                        <input type="text" name="carNum" class="form-control" id="editCarNumber">
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">이름</label>
                        <input type="text" name="memberName" class="form-control" id="editName">
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">연락처</label>
                        <input type="tel" name="memberPhone" class="form-control" id="editPhone">
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">시작일</label>
                            <input type="date" name="startDate" class="form-control" id="editStartDate">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">만료일</label>
                            <input type="date" name="endDate" class="form-control" id="editExpireDate">
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button class="btn btn-primary">수정 완료</button>
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ========================= 회원 삭제 모달 ========================= -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="member_delete.jsp" method="post">
                <input type="hidden" name="mno" id="deleteMno">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold text-danger">회원 삭제</h5>
                </div>
                <div class="modal-body text-center">
                    정말 삭제하시겠습니까?
                </div>
                <div class="modal-footer">
                    <button class="btn btn-danger">삭제</button>
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
</body>
</html>
