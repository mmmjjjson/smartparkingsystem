<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.smartparkingsystem.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="com.example.smartparkingsystem.dao.MembersDAO" %>
<%@ page import="com.example.smartparkingsystem.dto.MembersDTO" %>
<%@ page import="com.example.smartparkingsystem.vo.MembersVO" %>
<%-- 신규 회원 등록 --%>
<%
    String carNum = request.getParameter("carNum");
    String memberName = request.getParameter("memberName");
    String memberPhone = request.getParameter("memberPhone");
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");

    LocalDate start = (startDate != null && !startDate.isEmpty())
            ? LocalDate.parse(startDate) : LocalDate.now();
    LocalDate end = (endDate != null && !endDate.isEmpty())
            ? LocalDate.parse(endDate) : start.plusMonths(1).minusDays(1); // 기본 1개월

    MembersVO member = MembersVO.builder()
            .carNum(carNum)
            .memberName(memberName)
            .memberPhone(memberPhone)
            .startDate(start)
            .endDate(end)
            .build();

    MembersDAO membersDAO = new MembersDAO();
    membersDAO.insertMember(member);

    return;
%>