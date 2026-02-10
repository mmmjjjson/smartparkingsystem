<%@ page import="com.example.smartparkingsystem.dao.MembersDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.smartparkingsystem.vo.MembersVO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 관리</title>
    <link rel="stylesheet" href="css/member.css">
</head>
<body>
<%
    String searchType = request.getParameter("searchType");
    String keyword = request.getParameter("keyword");
    String status = request.getParameter("status");

    MembersDAO membersDAO = new MembersDAO();
    List<MembersVO> membersList;

    if (keyword != null && !keyword.trim().isEmpty() && searchType != null && !searchType.isEmpty()) {
        membersList = membersDAO.selectMembers(searchType, keyword.trim());
    } else {
        membersList = membersDAO.selectAllMembers();
    }
%>

<!-- 회원 목록 -->
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
    boolean hasData = false;

    for (MembersVO member : membersList) {
        if (status == null && !member.isMember()) continue;

        if ("expired".equals(status) && member.isMember()) continue;

        hasData = true;
%>
<tr onclick="openViewModal(
    <%=member.getMno()%>,
        '<%= member.getCarNum() %>',
        '<%= member.getMemberName() %>',
        '<%= member.getMemberPhone() %>',
        '<%= member.getStartDate() %>',
        '<%= member.getEndDate() %>'
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
    if (!hasData) {
%>
<tr>
    <td colspan="5" style="text-align:center;">
        <%= "expired".equals(status) ? "비회원이 없습니다" : "등록된 비회원이 없습니다" %>
    </td>
</tr>
<%
        }
    }
%>
</tbody>
</body>
</html>
