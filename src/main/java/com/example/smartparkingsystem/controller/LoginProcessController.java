package com.example.smartparkingsystem.controller;

import com.example.smartparkingsystem.dao.AdminDAO;
import com.example.smartparkingsystem.dto.AdminDTO;
import com.example.smartparkingsystem.service.AdminService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginProcessController extends HttpServlet {
    private final AdminService adminService = AdminService.INSTANCE;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login/login.jsp").forward(req,resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String step = req.getParameter("step");

        if (step == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 (값 자체가 없음, 요청 자체가 이상할때만)
            return;
        }

        switch (step) {
            case "1" -> step1(req, resp);
            case "2" -> step2(req, resp);
            case "3" -> step3(req, resp);
            default -> resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 (정보를 찾을 수 없음)
        }
    }

    // Step1 세션
    private void step1(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String adminId = req.getParameter("adminId");
        String password = req.getParameter("password");

        // 로그인 실패
        if (!adminDB(adminId, password)) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 (실패)
            return;
        }

        // 사용여부 False
        if (!adminService.getAdminById(adminId).is_active()) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403 (접근 제한)
            return;
        }

        // 로그인 성공시 임시 세션
        HttpSession session = req.getSession();
        session.setAttribute("tempAdminId", adminId);
        resp.setStatus(HttpServletResponse.SC_OK); // 200 (승인)
    }

    // Step2 등록된 이메일 확인
    private void step2(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");

        HttpSession session = req.getSession();
        String tempAdminId = (String) session.getAttribute("tempAdminId");
        // step1의 임시세션에 아이디 없으면 400에러
        if (tempAdminId == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400
            return;
        }

        // 같은 레코드에 이메일인지 확인
        if (emailDB(tempAdminId, email)) {
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        }
    }

    // Step3 OTP 확인
    private void step3(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String otpCode = req.getParameter("otpCode");

        System.out.println("otpCode: " + otpCode);

        // OTP 완료시 임시 세션 변경
        if (otpDB(otpCode)) {
            HttpSession session = req.getSession();
            String adminId = (String) session.getAttribute("tempAdminId"); // adminId로 변경
            session.setAttribute("adminId", adminId); // 최종 로그인 세션 적용
            session.removeAttribute("tempAdminId"); // 임시 세션 제거
            adminService.renewalLog(adminId, req.getRemoteAddr()); // 로그인 날짜, IP

            System.out.println("adminId 세션 생성 완료: " + session.getId());
            System.out.println("adminId 값 " + session.getAttribute("adminId"));
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        }
    }

    private boolean adminDB(String adminId, String password) {
        return adminService.AuthenticateAdmin(adminId, password);
    }

    private boolean emailDB(String adminId, String email) {
        AdminDTO admin = adminService.getAdminById(adminId);
        return admin != null && admin.getAdminEmail().equals(email);
    }

    // TODO: OTP연동만 하면 끝
    private boolean otpDB(String otpCode) {
        return "123456".equals(otpCode);
    }
}