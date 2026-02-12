<%--<%@ page import="java.util.List" %>--%>
<%--<%@ page import="java.time.LocalDate" %>--%>
<%--<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>--%>
<%--<!DOCTYPE html>--%>
<%--<html>--%>
<%--<head>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <meta name="viewport" content="width=device-width, initial-scale=1.0">--%>
<%--    <title>스마트 주차관리 시스템 - 회원 관리</title>--%>

<%--    <!-- Bootstrap CSS / JS -->--%>
<%--    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">--%>
<%--    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>--%>

<%--    <!-- Custom CSS -->--%>
<%--    &lt;%&ndash;    <link rel="stylesheet" href="css/member.css">&ndash;%&gt;--%>
<%--    &lt;%&ndash;    <link rel="stylesheet" href="../../login/css/styles.css">&ndash;%&gt;--%>

<%--    <script src="js/member.js" defer></script>--%>
<%--    <script src="../main/main_membershipPay.js" defer></script>--%>
<%--</head>--%>
<%--<body class="bg-light">--%>
<%--<%@ include file="../common/header_member.jsp" %>--%>
<%--<div class="container-fluid mt-4">--%>
<%--    <!-- 콘텐츠 -->--%>
<%--    <div class="content">--%>
<%--        <div class="d-flex justify-content-between align-items-center mb-3">--%>
<%--            <h4 class="fw-bold">회원 관리 - 월정액 회원 정보 관리</h4>--%>
<%--            <div class="d-flex gap-2">--%>
<%--                <button class="btn btn-primary" id="newMemberBtn">신규 회원 등록</button>--%>
<%--            </div>--%>
<%--        </div>--%>

<%--        <!-- 회원 정보 검색 -->--%>
<%--        <form method="get" action="@member.jsp" class="row g-2 mb-3 align-items-center">--%>
<%--            <input type="hidden" name="status"--%>
<%--                   value="<%= request.getParameter("status") == null ? "" : request.getParameter("status") %>">--%>
<%--            <div class="col-auto">--%>
<%--                <select id="searchType" name="searchType" class="form-select">--%>
<%--                    <option value="carNum" <%= "carNum".equals(request.getParameter("searchType")) ? "selected" : "" %>>--%>
<%--                        차량--%>
<%--                        번호--%>
<%--                    </option>--%>
<%--                    <option value="name" <%= "name".equals(request.getParameter("searchType")) ? "selected" : "" %>>이름--%>
<%--                    </option>--%>
<%--                    <option value="phone" <%= "phone".equals(request.getParameter("searchType")) ? "selected" : "" %>>--%>
<%--                        연락처--%>
<%--                    </option>--%>
<%--                </select>--%>
<%--            </div>--%>
<%--            <div class="col-auto flex-grow-1">--%>
<%--                <input type="text" name="keyword" id="keyword" class="form-control"--%>
<%--                       value="<%= request.getParameter("keyword") == null ? "" : request.getParameter("keyword") %>"--%>
<%--                       placeholder="검색어를 입력하세요">--%>
<%--            </div>--%>
<%--            <div class="col-auto">--%>
<%--                <button type="submit" class="btn btn-dark">검색</button>--%>
<%--            </div>--%>
<%--        </form>--%>

<%--        <!-- 비회원 / 회원 버튼 -->--%>
<%--        <div class="mb-3">--%>
<%--            <a href="@member.jsp?status=expired"--%>
<%--               class="btn btn-outline-secondary <%= "expired".equals(request.getParameter("status")) ? "active" : "" %>">비회원</a>--%>
<%--            <a href="@member.jsp"--%>
<%--               class="btn btn-outline-primary <%= request.getParameter("status") == null ? "active" : "" %>">회원</a>--%>
<%--        </div>--%>

<%--        <!-- 회원 목록 테이블 -->--%>
<%--        <div class="table-responsive">--%>
<%--            <table>--%>
<%--                <%@ include file="../../WEB-INF/members/member_list.jsp" %>--%>
<%--            </table>--%>
<%--        </div>--%>
<%--    </div>--%>

<%--    <!-- ===================== 신규 회원 등록 모달 ===================== -->--%>
<%--    <div class="modal fade" id="newMemberModal" tabindex="-1">--%>
<%--        <div class="modal-dialog modal-lg modal-dialog-centered">--%>
<%--            <div class="modal-content">--%>
<%--                <form action="../../WEB-INF/members/member_add.jsp" method="post" onsubmit="return handleNewMemberSubmit()">--%>
<%--                    <div class="modal-header">--%>
<%--                        <h5 class="modal-title fw-bold">회원 정보 입력</h5>--%>
<%--                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>--%>
<%--                    </div>--%>
<%--                    <div class="modal-body">--%>
<%--                        <div class="mb-3">--%>
<%--                            <label class="form-label">차량 번호 (필수)</label>--%>
<%--                            <input type="text" name="carNum" placeholder="예: 12가3456" maxlength="8" class="form-control"--%>
<%--                                   id="newCarNumber">--%>
<%--                        </div>--%>
<%--                        <div class="mb-3">--%>
<%--                            <label class="form-label">이름 (필수)</label>--%>
<%--                            <input type="text" name="memberName" placeholder="이름을 입력하세요" class="form-control"--%>
<%--                                   id="newName">--%>
<%--                        </div>--%>
<%--                        <div class="mb-3">--%>
<%--                            <label class="form-label">연락처 (필수)</label>--%>
<%--                            <input type="tel" name="memberPhone" placeholder="예: 010-1234-5678" maxlength="13"--%>
<%--                                   oninput="autoHyphenPhone(this)" class="form-control" id="newPhone">--%>
<%--                        </div>--%>
<%--                        <div class="row g-2">--%>
<%--                            <div class="col-md-6 mb-3">--%>
<%--                                <label class="form-label">시작일 (필수)</label>--%>
<%--                                <input type="date" name="startDate" class="form-control" id="newStartDate"--%>
<%--                                       onchange="setEndDateByOneMonth('newStartDate', 'newExpireDate')">--%>
<%--                            </div>--%>
<%--                            <div class="col-md-6 mb-3">--%>
<%--                                <label class="form-label">만료일</label>--%>
<%--                                <input type="date" name="endDate" class="form-control" id="newExpireDate" readonly>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                    <div class="modal-footer d-flex justify-content-end">--%>
<%--                        <button type="submit" class="btn btn-primary">등록</button>--%>
<%--                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>--%>
<%--                    </div>--%>
<%--                </form>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>

<%--    <!-- ===================== 회원 상세 정보 모달 ===================== -->--%>
<%--    <div class="modal fade" id="viewMemberModal" tabindex="-1">--%>
<%--        <div class="modal-dialog modal-lg modal-dialog-centered">--%>
<%--            <div class="modal-content p-3">--%>
<%--                <div class="modal-header">--%>
<%--                    <h5 class="modal-title fw-bold">회원 상세 정보</h5>--%>
<%--                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>--%>
<%--                </div>--%>
<%--                <div class="modal-body">--%>
<%--                    <input type="hidden" id="mno">--%>
<%--                    <div class="mb-3 row">--%>
<%--                        <label class="col-sm-3 col-form-label">차량 번호:</label>--%>
<%--                        <div class="col-sm-9 form-control-plaintext" id="viewCarNumber"></div>--%>
<%--                    </div>--%>
<%--                    <div class="mb-3 row">--%>
<%--                        <label class="col-sm-3 col-form-label">이름:</label>--%>
<%--                        <div class="col-sm-9 form-control-plaintext" id="viewName"></div>--%>
<%--                    </div>--%>
<%--                    <div class="mb-3 row">--%>
<%--                        <label class="col-sm-3 col-form-label">연락처:</label>--%>
<%--                        <div class="col-sm-9 form-control-plaintext" id="viewPhone"></div>--%>
<%--                    </div>--%>
<%--                    <div class="mb-3 row">--%>
<%--                        <label class="col-sm-3 col-form-label">시작일:</label>--%>
<%--                        <div class="col-sm-9 form-control-plaintext" id="viewStartDate"></div>--%>
<%--                    </div>--%>
<%--                    <div class="mb-3 row">--%>
<%--                        <label class="col-sm-3 col-form-label">만료일:</label>--%>
<%--                        <div class="col-sm-9 form-control-plaintext" id="viewExpireDate"></div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--                <div class="modal-footer d-flex justify-content-between">--%>
<%--                    <button class="btn btn-primary" onclick="openEditModal()">수정</button>--%>
<%--                    <button class="btn btn-danger" onclick="handleDelete()">삭제</button>--%>
<%--                    <button class="btn btn-success" id="btnMembershipPay">회원권 결제</button>--%>
<%--                    <button class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기</button>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>

<%--    <!-- ===================== 회원권 결제 모달 ===================== -->--%>
<%--    <div class="modal fade" id="membershipPayModal" tabindex="-1" aria-hidden="true">--%>
<%--        <div class="modal-dialog modal-lg modal-dialog-centered">--%>
<%--            <div class="modal-content">--%>
<%--                <div class="modal-header bg-primary text-white">--%>
<%--                    <h5 class="modal-title fw-bold">신규 회원권 결제</h5>--%>
<%--                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>--%>
<%--                </div>--%>
<%--                <div class="modal-body">--%>
<%--                    <div id="mem-input-section">--%>
<%--                        <input type="hidden" name="mno" id="memMno">--%>

<%--                        <div class="mb-3">--%>
<%--                            <label class="form-label fw-bold">차량 번호</label>--%>
<%--                            <input type="text" id="memCarNum" class="form-control" readonly>--%>
<%--                        </div>--%>

<%--                        <div class="mb-3">--%>
<%--                            <label class="form-label fw-bold">이름</label>--%>
<%--                            <input type="text" id="memName" class="form-control" readonly>--%>
<%--                        </div>--%>

<%--                        <div class="mb-3">--%>
<%--                            <label class="form-label fw-bold">연락처</label>--%>
<%--                            <input type="text" id="memPhone" class="form-control" readonly>--%>
<%--                        </div>--%>

<%--                        <div class="row">--%>
<%--                            <div class="col-6 mb-3">--%>
<%--                                <label class="form-label fw-bold">시작일</label>--%>
<%--                                <input type="date" id="memStartDate" class="form-control" readonly>--%>
<%--                            </div>--%>
<%--                            <div class="col-6 mb-3">--%>
<%--                                <label class="form-label fw-bold">만료일</label>--%>
<%--                                <input type="date" id="memEndDate" class="form-control" readonly>--%>
<%--                            </div>--%>
<%--                        </div>--%>

<%--                        <div class="mb-3">--%>
<%--                            <label class="form-label fw-bold">총 결제 요금</label>--%>
<%--                            <input type="text" id="memPrice" class="form-control fw-bold text-primary" value="100,000원"--%>
<%--                                   readonly>--%>
<%--                        </div>--%>
<%--                    </div>--%>

<%--                    <div id="mem-receipt-section" style="display: none;">--%>
<%--                        <div class="p-4 border border-2 border-dark rounded bg-light">--%>
<%--                            <h4 class="text-center fw-bold mb-4">회원권 결제 영수증</h4>--%>
<%--                            <div class="d-flex justify-content-between mb-2"><span>차량번호:</span><span id="res-car"--%>
<%--                                                                                                     class="fw-bold"></span>--%>
<%--                            </div>--%>
<%--                            <div class="d-flex justify-content-between mb-2"><span>성함/연락처:</span><span--%>
<%--                                    id="res-user"></span>--%>
<%--                            </div>--%>
<%--                            <hr>--%>
<%--                            <div class="d-flex justify-content-between mb-2"><span>권종:</span><span>정기 정액권 (30일)</span>--%>
<%--                            </div>--%>
<%--                            <div class="d-flex justify-content-between mb-2"><span>유효기간:</span><span id="res-period"--%>
<%--                                                                                                     class="text-primary"></span>--%>
<%--                            </div>--%>
<%--                            <hr>--%>
<%--                            <div class="d-flex justify-content-between fs-5 fw-bold"><span>결제금액:</span><span--%>
<%--                                    id="res-price"--%>
<%--                                    class="text-danger"></span>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <div class="mt-3 d-grid gap-2">--%>
<%--                            <button class="btn btn-dark w-100" onclick="window.print()">영수증 출력</button>--%>
<%--                            <button type="button" id="btn-receipt-close-final" class="btn btn-secondary w-100">닫기--%>
<%--                            </button>--%>
<%--                        </div>--%>
<%--                    </div>--%>

<%--                    <div class="modal-footer" id="mem-footer">--%>
<%--                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>--%>
<%--                        <button type="button" class="btn btn-primary" id="btn-membership-submit">결제하기</button>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>

<%--    <!-- ===================== 회원 정보 수정 모달 ===================== -->--%>
<%--    <div class="modal fade" id="editMemberModal" tabindex="-1">--%>
<%--        <div class="modal-dialog modal-lg modal-dialog-centered">--%>
<%--            <div class="modal-content">--%>
<%--                <form action="../../WEB-INF/members/member_modify.jsp" method="post" onsubmit="return handleEditSubmit()">--%>
<%--                    <div class="modal-header">--%>
<%--                        <h5 class="modal-title fw-bold">회원 정보 수정</h5>--%>
<%--                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>--%>
<%--                    </div>--%>
<%--                    <div class="modal-body">--%>
<%--                        <input type="hidden" id="editMno" name="mno">--%>
<%--                        <div class="mb-3">--%>
<%--                            <label class="form-label">차량 번호 (필수)</label>--%>
<%--                            <input type="text" name="carNum" class="form-control" id="editCarNumber">--%>
<%--                        </div>--%>
<%--                        <div class="mb-3">--%>
<%--                            <label class="form-label">이름 (필수)</label>--%>
<%--                            <input type="text" name="memberName" class="form-control" id="editName">--%>
<%--                        </div>--%>
<%--                        <div class="mb-3">--%>
<%--                            <label class="form-label">연락처 (필수)</label>--%>
<%--                            <input type="tel" name="memberPhone" class="form-control" maxlength="13"--%>
<%--                                   oninput="autoHyphenPhone(this)" id="editPhone">--%>
<%--                        </div>--%>
<%--                        <div class="row g-2">--%>
<%--                            <div class="col-md-6 mb-3">--%>
<%--                                <label class="form-label">시작일</label>--%>
<%--                                <input type="date" name="startDate" class="form-control" id="editStartDate" readonly>--%>
<%--                            </div>--%>
<%--                            <div class="col-md-6 mb-3">--%>
<%--                                <label class="form-label">만료일</label>--%>
<%--                                <input type="date" name="endDate" class="form-control" id="editExpireDate" readonly>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                    <div class="modal-footer d-flex justify-content-end">--%>
<%--                        <button type="submit" class="btn btn-primary">수정 완료</button>--%>
<%--                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>--%>
<%--                    </div>--%>
<%--                </form>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>

<%--    <!-- ===================== 회원 삭제 모달 ===================== -->--%>
<%--    <div class="modal fade" id="deleteConfirmModal" tabindex="-1">--%>
<%--        <div class="modal-dialog modal-md modal-dialog-centered">--%>
<%--            <div class="modal-content">--%>
<%--                <form action="../../WEB-INF/members/@member_delete.jsp" method="post">--%>
<%--                    <input type="hidden" id="deleteMno" name="mno">--%>
<%--                    <div class="modal-header">--%>
<%--                        <h5 class="modal-title fw-bold">회원 삭제</h5>--%>
<%--                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>--%>
<%--                    </div>--%>
<%--                    <div class="modal-body">--%>
<%--                        <p class="fw-bold text-center">정말 삭제 하시겠습니까?</p>--%>
<%--                    </div>--%>
<%--                    <div class="modal-footer d-flex justify-content-between">--%>
<%--                        <button type="submit" class="btn btn-danger">삭제</button>--%>
<%--                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>--%>
<%--                    </div>--%>
<%--                </form>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>

<%--    <!-- 결과 안내 모달 -->--%>
<%--        <%--%>
<%--    String flashMsg = (String) session.getAttribute("flashMsg");--%>
<%--    if (flashMsg != null) {--%>
<%--%>--%>
<%--    <div id="flashMessage" data-msg="<%= flashMsg %>"></div>--%>
<%--        <%--%>
<%--        session.removeAttribute("flashMsg");--%>
<%--    }--%>
<%--%>--%>

<%--    <%@ include file="../common/footer.jsp" %>--%>
<%--</body>--%>
<%--</html>--%>
