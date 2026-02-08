package com.example.smartparkingsystem.controller;

import com.example.smartparkingsystem.dto.AdminDTO;
import com.example.smartparkingsystem.service.AdminService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;

import java.io.IOException;
import java.util.UUID;

@Log4j2
@WebServlet("/password")
public class LoginPasswordController extends HttpServlet {
    private final AdminService adminService = AdminService.INSTANCE;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login/password.jsp").forward(req,resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String step = req.getParameter("step");

        if (step == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400
            return;
        }
        log.info("step: {}", step);
        switch (step) {
            case "1" -> step1(req, resp);
            case "2" -> step2(req, resp);
            case "3" -> step3(req, resp);
            default -> resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        }
    }
    public void step1(HttpServletRequest req, HttpServletResponse resp) {
        String adminId = req.getParameter("adminId");
        if (adminId == null || adminId.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        log.info("adminId: {}", adminId);

        if (adminIdValid(adminId)) {
            HttpSession session = req.getSession();
            session.setAttribute("logAdminId", adminId); // 임시 세션 생성
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        }
    }
    public void step2(HttpServletRequest req, HttpServletResponse resp) {
        HttpSession session = req.getSession();
        String adminId = (String) session.getAttribute("logAdminId");
        String email = req.getParameter("email");
        log.info("step2 adminId: {}", adminId);
        log.info("email: {}", email);
        if (emailValid(adminId, email)) {
            session.setAttribute("logEmail", email);
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        }
    }
    public void step3(HttpServletRequest req, HttpServletResponse resp) {
        HttpSession session = req.getSession(false);
        String adminId = (String) session.getAttribute("logAdminId");
        String otpCode = req.getParameter("otpCode");
        log.info("otpCode: {}", otpCode);
        if (optValid(otpCode)) {

            // 12자리 랜덤 UUID 생성
            String newPassword = UUID.randomUUID().toString().replace("-", "").substring(0, 12);
            adminService.changePassword(adminId, newPassword);

            // TODO 비밀번호 랜덤키로 변경후 로그인 다음 페이지는 바로 비밀번호 변경페이지로 이동
            session.removeAttribute("logAdminId");
            session.removeAttribute("logEmail");
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        }
    }
    private boolean adminIdValid(String adminId) {
        return adminService.getAdminById(adminId) != null;
    }
    private boolean emailValid(String adminId, String email) {
        AdminDTO admin = adminService.getAdminById(adminId);
        return admin != null && admin.getAdminEmail().equals(email);
    }

    // TODO 여기도 OTP 인증만 하면 끝
    private boolean optValid(String otpCode) {
        return "123456".equals(otpCode);
    }
}
