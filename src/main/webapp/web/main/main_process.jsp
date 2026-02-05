<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- 비로그인 접근 제한 --%>
<%
    String adminId = (String) session.getAttribute("adminId");
    System.out.println(session.getId());
    System.out.println(adminId);
    if (adminId == null) {
        response.sendRedirect("/login");
        return;
    }
%>
