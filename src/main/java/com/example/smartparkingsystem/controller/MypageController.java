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

@Log4j2
@WebServlet("/main/mypage")
public class MypageController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/login/myPage.jsp").forward(req,resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        AdminService adminService = AdminService.INSTANCE;
        HttpSession session = req.getSession(false);
        String adminId = (String) session.getAttribute("adminId");
        String password = req.getParameter("password");
        String newPassword = req.getParameter("newPassword");
        String email = adminService.getAdminById(adminId).getAdminEmail();

        log.info("Admin id : {}", adminId);
        log.info("Password : {}", password);
        log.info("New Password : {}", newPassword);
        log.info("Email : {}", email);

        if (password == null || newPassword == null) { // 굳이 필요할까?
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        if (adminService.getAdminById(adminId).getPassword().equals(password)) {
            // DB비밀번호와 일치함
            AdminDTO adminDTO = AdminDTO.builder()
                    .adminId(adminId)
                    .password(newPassword)
                    .adminEmail(email)
                    .isPasswordReset(false) // 변경
                    .build();
            adminService.modifyAdmin(adminDTO);
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
        }

        // TODO 이메일 변경도 구현?
    }
}
