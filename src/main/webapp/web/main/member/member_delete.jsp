<%@ page import="com.example.smartparkingsystem.member.model.MembersDAO" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    String carNum = request.getParameter("carNum");

    if (carNum != null && !carNum.isEmpty()) {
        MembersDAO membersDAO = new MembersDAO();
        membersDAO.deleteMember(carNum);
    }

    response.sendRedirect("member.jsp");
%>