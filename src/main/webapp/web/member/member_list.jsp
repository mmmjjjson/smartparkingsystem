<%@ page import="com.example.smartparkingsystem.dao.MembersDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.smartparkingsystem.dto.MembersDTO" %>
<%@ page import="com.example.smartparkingsystem.vo.MembersVO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 관리</title>
</head>
<body>
<%-- 회원 전체 목록 --%>
<%
    MembersDAO membersDAO = new MembersDAO();
    List<MembersVO> members = membersDAO.selectAllMembers();
%>

<%
    if (members.isEmpty()) {
%>
<tr>
    <td colspan="5" style="text-align: center;">
        등록된 회원이 없습니다
    </td>
</tr>
<%
} else {
    for (MembersVO member : members) {
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
    }
%>
</body>
</html>
