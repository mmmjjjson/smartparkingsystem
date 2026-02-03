<%@ page import="com.example.smartparkingsystem.member.model.MembersDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.smartparkingsystem.member.model.MembersDTO" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
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
    List<MembersDTO> members = membersDAO.selectAllMembers();
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
    for (MembersDTO member : members) {
%>
<tr onclick="openModal(
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
    <td><%=member.getStartDate().toLocalDate()%>
    </td>
    <td><%=member.getEndDate().toLocalDate()%>
    </td>
</tr>
<%
        }
    }
%>
</body>
</html>
