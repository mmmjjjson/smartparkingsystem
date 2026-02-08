<%@ page import="com.example.smartparkingsystem.dao.MembersDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- 회원 삭제 --%>
<%
    String carNum = request.getParameter("carNum");

    if (carNum != null && !carNum.isEmpty()) {
        MembersDAO membersDAO = new MembersDAO();
        membersDAO.deleteMember(carNum);
    }

    // 회원 정보 삭제 완료 메시지
    session.setAttribute("flashMsg", "회원 정보가 삭제되었습니다.");

    response.sendRedirect("member.jsp");
%>