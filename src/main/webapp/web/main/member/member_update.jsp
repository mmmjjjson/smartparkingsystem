<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.example.smartparkingsystem.member.model.*" %>
<%@ page import="java.time.LocalDate" %>
<%-- 회원 정보 수정 --%>
<%
    String originCarNum = request.getParameter("originCarNum");

    MembersDTO membersDTO = MembersDTO.builder()
            .carNum(request.getParameter("carNum"))
            .memberName(request.getParameter("memberName"))
            .memberPhone(request.getParameter("memberPhone"))
            .startDate(LocalDate.parse(request.getParameter("startDate")).atStartOfDay())
            .endDate(LocalDate.parse(request.getParameter("endDate")).atStartOfDay())
            .build();

    MembersDAO membersDAO = new MembersDAO();
    membersDAO.updateMember(originCarNum, membersDTO);

    response.sendRedirect("member.jsp");
%>
