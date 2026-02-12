<%@ page import="com.example.smartparkingsystem.dao.MembersDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.smartparkingsystem.vo.MembersVO" %>
<%@ page import="com.example.smartparkingsystem.dto.PageResponseDTO" %>
<%@ page import="com.example.smartparkingsystem.dto.MembersDTO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    PageResponseDTO pageResponseDTO = (PageResponseDTO) request.getAttribute("pageResponseDTO");
    List<MembersDTO> membersDTOList = pageResponseDTO.getMembersDTOList();
    int pageNum = pageResponseDTO.getPageNum();
    int totalPage = pageResponseDTO.getTotalPage();

    int limit = 10; // 한 페이지 당 나올 개수
    int n = (pageNum - 1) * limit + 1; // 데이터의 인덱스

    String searchType = request.getParameter("searchType") == null ? "" : request.getParameter("searchType");
    String keyword = request.getParameter("keyword") == null ? "" : request.getParameter("keyword");
    String status = request.getParameter("status") == null ? "" : request.getParameter("status");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>스마트 주차관리 시스템 - 회원 관리</title>

    <!-- Bootstrap CSS / JS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Custom CSS -->
    <%--    <link rel="stylesheet" href="css/member.css">--%>
    <%--    <link rel="stylesheet" href="../../login/css/styles.css">--%>

    <script src="../../web/member/js/member.js" defer></script>
    <script src="../../web/main/main_membershipPay.js" defer></script>

    <style>
        .custom-table thead th {
            padding-top: 0.6rem;
            padding-bottom: 0.6rem;
        }

        .custom-table tbody td {
            padding-top: 0.9rem;
            padding-bottom: 0.9rem;
        }
    </style>
</head>
<body class="bg-light">
<!-- 헤드 -->
<%@ include file="../../web/common/header_other.jsp" %>
<div class="container-fluid mt-4 px-5">
    <!-- 콘텐츠 -->
    <div class="content">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="fw-bold">회원 관리 - 월정액 회원 정보 관리</h4>
            <div class="d-flex gap-2">
                <button class="btn btn-primary" id="newMemberBtn">신규 회원 등록</button>
            </div>
        </div>

        <!-- 회원 정보 검색 -->
        <form method="get" action="/member_list.do" class="row g-2 mb-3 align-items-center">
            <input type="hidden" name="status"
                   value="<%= request.getParameter("status") == null ? "" : request.getParameter("status") %>">
            <div class="col-auto">
                <!-- 검색 타입 -->
                <select id="searchType" name="searchType" class="form-select">
                    <option value="carNum" <%= "carNum".equals(request.getParameter("searchType")) ? "selected" : "" %>>
                        차량
                        번호
                    </option>
                    <option value="name" <%= "name".equals(request.getParameter("searchType")) ? "selected" : "" %>>
                        이름
                    </option>
                    <option value="phone" <%= "phone".equals(request.getParameter("searchType")) ? "selected" : "" %>>
                        연락처
                    </option>
                </select>
            </div>
            <div class="col-auto flex-grow-1">
                <!-- 검색어 입력 창 -->
                <input type="text" name="keyword" id="keyword" class="form-control"
                       value="<%= request.getParameter("keyword") == null ? "" : request.getParameter("keyword") %>"
                       placeholder="검색어를 입력하세요">
            </div>
            <div class="col-auto">
                <!-- 검색 버튼 -->
                <button type="submit" class="btn btn-dark">검색</button>
            </div>
        </form>

        <!-- 회원 / 만료 회원 버튼 -->
        <div class="mb-3">
            <a href="./member_list.do"
               class="btn btn-outline-primary <%= request.getParameter("status") == null ? "active" : "" %>">회원</a>
            <a href="./member_list.do?status=expired"
               class="btn btn-outline-secondary <%= "expired".equals(request.getParameter("status")) ? "active" : "" %>">만료
                회원</a>
        </div>

        <!-- 회원 목록 테이블 -->
        <div class="table-responsive rounded-4 shadow-sm my-6" style="overflow: hidden;">
            <table class="table table-hover mb-2 text-center align-middle custom-table">
                <!-- 테이블 제목 -->
                <thead class="table-secondary">
                <tr>
                    <th>번호</th>
                    <th>차량 번호</th>
                    <th>이름</th>
                    <th>연락처</th>
                    <th>시작일</th>
                    <th>만료일</th>
                </tr>
                </thead>
                <tbody>
                <%
                    // 등록된 회원이 없으면
                    if (membersDTOList.isEmpty()) {
                %>
                <tr>
                    <td colspan="6" style="text-align: center;">
                        등록된 회원이 없습니다
                    </td>
                </tr>
                <%
                } else {
                    for (MembersDTO member : membersDTOList) {
                %>
                <tr onclick="openViewModal(
                    <%= member.getMno() %>,
                        `<%= member.getCarNum() %>`,
                        `<%= member.getMemberName() %>`,
                        `<%= member.getMemberPhone() %>`,
                        `<%= member.getStartDate() %>`,
                        `<%= member.getEndDate() %>`
                        )">
                    <td><%=n++%>
                    </td>
                    <td><%=member.getCarNum()%>
                    </td>
                    <td><%=member.getMemberName()%>
                    </td>
                    <td><%=member.getMemberPhone()%>
                    </td>
                    <td><%=member.getStartDate()%>
                    </td>
                    <td><%=member.getEndDate()%>
                    </td>
                </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>

            <!-- 페이지 목록 -->
            <div class="text-center mb-2">
                <%
                    // 한 블럭에 나올 페이지 개수
                    int pagePerBlock = 5;

                    // 현재 블럭
                    int thisBlock = (pageNum - 1) / pagePerBlock;

                    // 현재 블럭의 첫 페이지
                    int firstPage = thisBlock * pagePerBlock + 1;

                    // 현재 블럭의 마지막 페이지
                    int lastPage = firstPage + pagePerBlock - 1;

                    // 마지막 블럭의 마지막 페이지
                    lastPage = Math.min(lastPage, totalPage);
                %>
                <%
                    if (firstPage > 1) { // 화면의 첫 번째 페이지 번호가 1보다 크면
                %>
                <a href="./member_list.do?pageNum=<%=(firstPage - 1)%>&searchType=<%=searchType%>&keyword=<%=keyword%>&status=<%=status%>"
                   class="text-decoration-none fs-6 fw-semibold px-2"
                   style="color:#1e3a8a;">[
                    이전 ]</a>
                <%
                    }
                %>
                <%
                    for (int i = firstPage; i <= lastPage; i++) {
                %>
                <a href="./member_list.do?pageNum=<%=i%>&searchType=<%=searchType%>&keyword=<%=keyword%>&status=<%=status%>"
                   class="text-decoration-none fs-6 fw-semibold text-success px-2">
                    <%
                        if (pageNum == i) {
                    %>
                    <font color='4C5317'><b><%= i %>
                    </b></font>
                    <%
                    } else {
                    %>
                    <font color='4C5317'><%= i %>
                    </font>
                    <%
                        }
                    %>
                </a>
                <%
                    }
                %>
                <%
                    if (lastPage < totalPage) { // 화면의 마지막 페이지 번호가 총 페이지 수보다 작으면
                %>
                <a href="./member_list.do?pageNum=<%=(lastPage + 1)%>&searchType=<%=searchType%>&keyword=<%=keyword%>&status=<%=status%>"
                   class="text-decoration-none fs-6 fw-semibold px-2"
                   style="color:#1e3a8a;">[
                    다음 ]</a>
                <%
                    }
                %>
            </div>
        </div>
    </div>
</div>


<!-- ===================== 신규 회원 등록 모달 ===================== -->
<div class="modal fade" id="newMemberModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <form action="/member_add.do" method="post" onsubmit="return handleNewMemberSubmit()">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">회원 정보 입력</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold">차량 번호 (필수)</label>
                        <input type="text" name="carNum" placeholder="예: 12가3456" maxlength="8" class="form-control"
                               id="newCarNumber">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">이름 (필수)</label>
                        <input type="text" name="memberName" placeholder="이름을 입력하세요" class="form-control"
                               id="newName">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">연락처 (필수)</label>
                        <input type="tel" name="memberPhone" placeholder="예: 010-1234-5678" maxlength="13"
                               oninput="autoHyphenPhone(this)" class="form-control" id="newPhone">
                    </div>
                    <div class="row g-2">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">시작일 (필수)</label>
                            <input type="date" name="startDate" class="form-control" id="newStartDate"
                                   onchange="setEndDateByOneMonth('newStartDate', 'newExpireDate')">
                        </div>
                        <!-- '만료일'은 '시작일'에 따라 자동으로 1개월 설정 -->
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">만료일</label>
                            <input type="date" name="endDate" class="form-control" id="newExpireDate" readonly>
                        </div>
                    </div>
                </div>
                <div class="modal-footer d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary">등록</button>
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ===================== 회원 상세 정보 모달 ===================== -->
<div class="modal fade" id="viewMemberModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content p-3">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">회원 상세 정보</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="modal-body">
                    <input type="hidden" id="mno">

                    <div class="row mb-3">
                        <label class="col-sm-3 fw-bold">차량 번호</label>
                        <div class="col-sm-9">
                            <div id="viewCarNumber"
                                 class="form-control-plaintext border rounded px-2 py-1 bg-light"></div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label class="col-sm-3 fw-bold">이름</label>
                        <div class="col-sm-9">
                            <div id="viewName" class="form-control-plaintext border rounded px-2 py-1 bg-light"></div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label class="col-sm-3 fw-bold">연락처</label>
                        <div class="col-sm-9">
                            <div id="viewPhone" class="form-control-plaintext border rounded px-2 py-1 bg-light"></div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label class="col-sm-3 fw-bold">시작일</label>
                        <div class="col-sm-9">
                            <div id="viewStartDate"
                                 class="form-control-plaintext border rounded px-2 py-1 bg-light"></div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label class="col-sm-3 fw-bold">만료일</label>
                        <div class="col-sm-9">
                            <div id="viewExpireDate"
                                 class="form-control-plaintext border rounded px-2 py-1 bg-light"></div>
                        </div>
                    </div>
                </div>

            </div>
            <div class="modal-footer justify-content-center">
                <button class="btn btn-primary px-4 py-2 me-3" onclick="openEditModal()">수정</button>
                <button class="btn btn-success px-4 py-2 me-3" id="btnMembershipPay">회원권 결제</button>
                <button class="btn btn-outline-secondary  px-4 py-2 me-3" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

<!-- ===================== 회원권 결제 모달 ===================== -->
<div class="modal fade" id="membershipPayModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title fw-bold">신규 회원권 결제</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <!-- '회원권 결제' 버튼 클릭 시 모달 -->
                <div id="mem-input-section">
                    <input type="hidden" name="mno" id="memMno">

                    <div class="mb-3">
                        <label class="form-label fw-bold">차량 번호</label>
                        <input type="text" id="memCarNum" class="form-control" readonly>
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
                        <input type="text" id="memPrice" class="form-control fw-bold text-primary" value="100,000원"
                               readonly>
                    </div>
                </div>

                <!-- '결제하기' 버튼 클릭 시 모달 -->
                <div id="mem-receipt-section" style="display: none;">
                    <div class="p-4 border border-2 border-dark rounded bg-light">
                        <h4 class="text-center fw-bold mb-4">회원권 결제 영수증</h4>
                        <div class="d-flex justify-content-between mb-2"><span>차량번호:</span><span id="res-car"
                                                                                                 class="fw-bold"></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2"><span>성함/연락처:</span><span
                                id="res-user"></span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-2"><span>권종:</span><span>정기 정액권 (30일)</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2"><span>유효기간:</span><span id="res-period"
                                                                                                 class="text-primary"></span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between fs-5 fw-bold"><span>결제금액:</span><span
                                id="res-price"
                                class="text-danger"></span>
                        </div>
                    </div>
                    <div class="mt-3 d-grid gap-2">
                        <button class="btn btn-dark w-100" onclick="window.print()">영수증 출력</button>
                        <button type="button" id="btn-receipt-close-final" class="btn btn-secondary w-100">닫기
                        </button>
                    </div>
                </div>

                <div class="modal-footer" id="mem-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                    <button type="button" class="btn btn-primary" id="btn-membership-submit">결제하기</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ===================== 회원 정보 수정 모달 ===================== -->
<div class="modal fade" id="editMemberModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <form action="/member_modify.do" method="post" onsubmit="return handleEditSubmit()">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">회원 정보 수정</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="editMno" name="mno">
                    <div class="mb-3">
                        <label class="form-label fw-bold">차량 번호 (필수)</label>
                        <input type="text" name="carNum" class="form-control" id="editCarNumber">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">이름 (필수)</label>
                        <input type="text" name="memberName" class="form-control" id="editName">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">연락처 (필수)</label>
                        <input type="tel" name="memberPhone" class="form-control" maxlength="13"
                               oninput="autoHyphenPhone(this)" id="editPhone">
                    </div>
                    <!-- '시작일'과 '만료일'은 변경할 수 없음 -->
                    <div class="row g-2">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">시작일</label>
                            <input type="date" name="startDate" class="form-control" id="editStartDate" readonly>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">만료일</label>
                            <input type="date" name="endDate" class="form-control" id="editExpireDate" readonly>
                        </div>
                    </div>
                </div>
                <div class="modal-footer d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary">수정 완료</button>
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ===================== 결과 안내 모달 ===================== -->
<%
    String flashMsg = (String) session.getAttribute("flashMsg");
    if (flashMsg != null) {
%>
<div id="flashMessage" data-msg="<%= flashMsg %>"></div>
<%
        session.removeAttribute("flashMsg");
    }
%>

<%@ include file="../../web/common/footer.jsp" %>
</body>
</html>