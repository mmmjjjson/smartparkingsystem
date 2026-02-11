<%@ page import="com.example.smartparkingsystem.dao.MembersDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.smartparkingsystem.vo.MembersVO" %>
<%@ page import="com.example.smartparkingsystem.dto.PageResponseDTO" %>
<%@ page import="com.example.smartparkingsystem.dto.MembersDTO" %>
<%@ page import="com.example.smartparkingsystem.service.MembersService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    PageResponseDTO pageResponseDTO = (PageResponseDTO) request.getAttribute("pageResponseDTO");
    List<MembersDTO> membersDTOList = pageResponseDTO.getMembersDTOList();
    int pageNum = pageResponseDTO.getPageNum();
    int totalCount = pageResponseDTO.getTotalCount();
    int totalPage = pageResponseDTO.getTotalPage();
    int limit = 10;

    int n = totalCount - 10 * (pageNum - 1);

    if (request.getParameter("pageNum") != null) {
        pageNum = Integer.parseInt(request.getParameter("pageNum"));
    }

    String searchType = request.getParameter("searchType");
    String keyword = request.getParameter("keyword");
    String status = request.getParameter("status");

    MembersService membersService = MembersService.INSTANCE;

    boolean isSearch = keyword != null && !keyword.isEmpty() && searchType != null && !searchType.isEmpty();

    if (isSearch) {
        // 검색이면 status 무시
        membersDTOList = membersService.getMembers(pageNum, limit, searchType, keyword.trim(), null);
        totalCount = membersService.getMemberList(pageResponseDTO.getMembersDTOList());
    } else {
        // 검색 없으면 status 적용
        membersDTOList = membersService.getMembers(pageNum, limit, null, null, status);
        totalCount = membersDAO.selectMemberCount(null, null, status);
    }
%>

<!-- 회원 목록 -->
<table class="table table-hover table-bordered align-middle text-center mb-0" id="memberTableBody">
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
    <tbody>
    <%
        if (membersList.isEmpty()) {
    %>
    <tr>
        <td colspan="5" style="text-align: center;">
            등록된 회원이 없습니다
        </td>
    </tr>
    <%
    } else {
        for (MembersVO member : membersList) {
    %>
    <tr onclick="openViewModal(
        <%= member.getMno() %>,
            `<%= member.getCarNum() %>`,
            `<%= member.getMemberName() %>`,
            `<%= member.getMemberPhone() %>`,
            `<%= member.getStartDate() %>`,
            `<%= member.getEndDate() %>`
            )">
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
<div align="center">
    <%
        int pagePerBlock = 10; // 한 블럭에 나올 페이지 수
        // 전체 블럭 수
        int totalBlock = totalPage % pagePerBlock == 0 ? totalPage / pagePerBlock : totalPage / pagePerBlock + 1;

        // 현재 블럭 ex) 8page -> 2, 30page -> 6
        int thisBlock = (pageNum - 1) / pagePerBlock + 1;

        // 현재 블럭의 첫 페이지 ex) 3block -> 11, 6block -> 26
        int firstPage = (thisBlock - 1) * pagePerBlock + 1;

        // 현재 블럭의 마지막 페이지
        int lastPage = thisBlock * pagePerBlock; // firstPage + pagePerBlock - 1

        // 마지막 블럭의 마지막 페이지
//                lastPage = (lastPage  > totalPage) ? totalPage : lastPage;
        lastPage = Math.min(lastPage, totalPage);
    %>
    <%
        if (firstPage != 1) {
    %>
    <a href="./member_list.jsp?pageNum=<%=(firstPage - 1)%>&searchType=<%=searchType%>&keyword=<%=keyword%>">[ 이전 ]</a>
    <%
        }
    %>
    <%
        for (int i = firstPage; i <= lastPage; i++) {
    %>
    <a href="./member_list.jsp?pageNum=<%=i%>&searchType=<%=searchType%>&keyword=<%=keyword%>">
        <%
            if (pageNum == i) {
        %>
        <font color='4C5317'><b> [<%= i %>] </b></font>
        <%
        } else {
        %>
        <font color='4C5317'> [<%= i %>] </font>
        <%
            }
        %>
    </a>
    <%
        }
    %>
    <%
        if (lastPage != totalPage) {
    %>
    <a href="./member_list.jsp?pageNum=<%=(lastPage + 1)%>&searchType=<%=searchType%>&keyword=<%=keyword%>">[ 다음 ]</a>
    <%
        }
    %>
</div>