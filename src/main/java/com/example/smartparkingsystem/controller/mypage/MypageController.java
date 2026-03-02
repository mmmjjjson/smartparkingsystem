package com.example.smartparkingsystem.controller.mypage;

import com.example.smartparkingsystem.dto.auth.AdminDTO;
import com.example.smartparkingsystem.dto.auth.ValidationDTO;
import com.example.smartparkingsystem.service.auth.AdminService;
import com.example.smartparkingsystem.service.auth.ValidationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.time.LocalDateTime;

@Log4j2
@WebServlet("/main/mypage")
public class MypageController extends HttpServlet {
    private final AdminService adminService = AdminService.INSTANCE;
    private final ValidationService validationService = ValidationService.INSTANCE;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/login/myPage.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String adminId = (String) session.getAttribute("adminId");
        String password = req.getParameter("password");
        String newPassword = req.getParameter("newPassword");
        String newPasswordBCrypt = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));
        String email = adminService.getAdminById(adminId).getAdminEmail();


        log.info("Box2 Admin id : {}", adminId);
        log.info("Box2 Password : {}", password);
        log.info("Box2 New Password : {}", newPassword);
        log.info("Box2 New Password BCrypt : {}", newPasswordBCrypt);
        log.info("Box2 Email : {}", email);


        if (password == null || newPassword == null) { // 굳이 필요할까?
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // 암호화된 비밀번호와 사용자가 입력한 비밀번호 비교
        boolean checkPw = BCrypt.checkpw(password, adminService.getAdminById(adminId).getPassword());

        // DB비밀번호와 일치함
        if (checkPw) {

            AdminDTO adminDTO = AdminDTO.builder()
                    .adminId(adminId)
                    .password(newPasswordBCrypt) // 변경
                    .adminEmail(email)
                    .isPasswordReset(false) // 변경
                    .build();

            adminService.modifyAdmin(adminDTO);
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
        }
    }
}
