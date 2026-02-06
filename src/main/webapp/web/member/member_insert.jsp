<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.smartparkingsystem.member.model.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="com.example.smartparkingsystem.dao.MembersDAO" %>
<%@ page import="com.example.smartparkingsystem.dto.MembersDTO" %>
<%-- 신규 회원 등록 --%>
<%
    MembersDTO member = MembersDTO.builder()
            .carNum(request.getParameter("carNum"))
            .memberName(request.getParameter("memberName"))
            .memberPhone(request.getParameter("memberPhone"))
            .startDate(LocalDate.parse(request.getParameter("startDate")).atStartOfDay())
            .endDate(LocalDate.parse(request.getParameter("endDate")).atStartOfDay())
            .build();

    MembersDAO membersDAO = new MembersDAO();
    membersDAO.insertMember(member);

    response.sendRedirect("member.jsp");
%>