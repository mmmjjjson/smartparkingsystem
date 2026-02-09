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

    MembersVO member = MembersVO.builder()
            .carNum(carNum)
            .memberName(memberName)
            .memberPhone(memberPhone)
            .startDate(LocalDate.parse(startDate))
            .endDate(LocalDate.parse(endDate))
            .build();

    MembersDAO membersDAO = new MembersDAO();
    membersDAO.insertMember(member);

    // 회원 등록 성공 메시지
    session.setAttribute("flashMsg", "회원이 등록되었습니다.");

    response.sendRedirect("member.jsp");
    return;
%>