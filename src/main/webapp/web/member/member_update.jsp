<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.smartparkingsystem.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="com.example.smartparkingsystem.dao.MembersDAO" %>
<%@ page import="com.example.smartparkingsystem.dto.MembersDTO" %>
<%@ page import="com.example.smartparkingsystem.vo.MembersVO" %>
<%-- 회원 정보 수정 --%>
<%
    MembersVO membersVO = MembersVO.builder()
            .mno(Long.parseLong(request.getParameter("mno")))
            .carNum(request.getParameter("carNum"))
            .memberName(request.getParameter("memberName"))
            .memberPhone(request.getParameter("memberPhone"))
            .startDate(LocalDate.parse(request.getParameter("startDate")))
            .endDate(LocalDate.parse(request.getParameter("endDate")))
            .build();

    MembersDAO membersDAO = new MembersDAO();
    membersDAO.updateMember(membersVO);

    // 회원 정보 수정 완료 메시지
    session.setAttribute("flashMsg", "회원 정보가 수정되었습니다.");

    response.sendRedirect("member.jsp");
%>
