<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.smartparkingsystem.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="com.example.smartparkingsystem.dao.MembersDAO" %>
<%@ page import="com.example.smartparkingsystem.dto.MembersDTO" %>
<%-- 신규 회원 등록 --%>
<%
    String carNum = request.getParameter("carNum");
    String memberName = request.getParameter("memberName");
    String memberPhone = request.getParameter("memberPhone");
    String startDateStr = request.getParameter("startDate");

    // 필수값 검증
    if (carNum == null || carNum.isBlank() ||
            memberName == null || memberName.isBlank() ||
            memberPhone == null || memberPhone.isBlank() ||
            startDateStr == null || startDateStr.isBlank()) {

        response.sendRedirect("member.jsp");
        return;
    }

    // 차량 번호 형식 검증
    if (!carNum.matches("^[0-9]{2,3}[가-힣][0-9]{4}$")) {
        session.setAttribute("flashMsg", "차량 번호 형식이 올바르지 않습니다.");
        response.sendRedirect("member.jsp");
        return;
    }

    // 연락처 형식 검증
    if (!memberPhone.matches("^[0-9]{3}-[0-9]{4}-[0-9]{4}$")) {
        session.setAttribute("flashMsg", "연락처 형식은 000-0000-0000 입니다.");
        response.sendRedirect("member.jsp");
        return;
    }

    // 만료일 1개월 자동 계산
    LocalDate startDate = LocalDate.parse(startDateStr);
    LocalDate endDate = startDate.plusMonths(1).minusDays(1);

    try {
        MembersDTO member = MembersDTO.builder()
                .carNum(carNum)
                .memberName(memberName)
                .memberPhone(memberPhone)
                .startDate(startDate.atStartOfDay())
                .endDate(endDate.atStartOfDay())
                .build();

        MembersDAO membersDAO = new MembersDAO();
        membersDAO.insertMember(member);

        // 회원 등록 성공 메시지
        session.setAttribute("flashMsg", "회원이 등록되었습니다.");
    } catch (Exception e) {
        // 회원 등록 실패 메시지
        session.setAttribute("flashType", "error");
        session.setAttribute("flashMsg", "회원 등록에 실패했습니다.");
    }

    response.sendRedirect("member.jsp");
    return;
%>