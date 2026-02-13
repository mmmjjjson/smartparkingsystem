package com.example.smartparkingsystem.controller;

import com.example.smartparkingsystem.dto.AdminDTO;
import com.example.smartparkingsystem.dto.ValidationDTO;
import com.example.smartparkingsystem.service.AdminService;
import com.example.smartparkingsystem.service.ValidationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;

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
        String box = req.getParameter("box");

        if (box == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        switch (box) {
            case "1" -> box1(req, resp);
            case "2" -> box2(req, resp);
            default -> resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    // 첫번째 박스 (이메일 수정칸)
    private void box1 (HttpServletRequest req, HttpServletResponse resp) throws ServletException,IOException {
    /*
    TODO 이메일 변경도 구현 (팝업창 띄워서 이메일 인증하는 형식 + 3분 타이머 추가)
     OTP연결시 제한시간 3분 (내일 이메일 인증칸 타이머 다 넣기)
     현재 팝업창에서 otpCode 가져온거 비교해서 하드코딩된 otpCode 비교 해야함
    */
        HttpSession session = req.getSession(false);
        String adminId = (String) session.getAttribute("adminId");
        String otpCode = req.getParameter("otpCode");
        String newEmail = req.getParameter("newEmail");

        log.info("Box1 New Email : {}", newEmail);
        log.info("Box1 OTP Code : {}", otpCode);

        // OTP발송 (인증하기 누르면 발송하도록 JS연결)
        if ((newEmail == null || newEmail.trim().isEmpty()) && (otpCode == null || otpCode.trim().isEmpty())) {
            validationService.otpShipment(adminId);
            resp.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        // OTP코드 인증 여부

        if (newEmail == null && otpCode != null) {
            String resultOTP = validateOtp(adminId, otpCode);

            if ("Success".equals(resultOTP)) {
                resp.setStatus(HttpServletResponse.SC_OK);
            } else if ("Expired".equals(resultOTP)) {
                resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            } else {
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            }
            return;
        }


        // 이메일 변경
        if (newEmail != null && otpCode == null) {
            AdminDTO adminDTO = AdminDTO.builder()
                    .adminId(adminId)
                    .password(adminService.getAdminById(adminId).getPassword())
                    .adminEmail(newEmail) // 변경
                    .isPasswordReset(false)
                    .build();
            adminService.modifyAdmin(adminDTO);
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
        }
    }

    // 두번째 박스 (비밀번호 변경 칸)
    private void box2 (HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String adminId = (String) session.getAttribute("adminId");
        String password = req.getParameter("password");
        String newPassword = req.getParameter("newPassword");
        String email = adminService.getAdminById(adminId).getAdminEmail();
//        String newEmail = (String) session.getAttribute("email"); // 이거 왜 했지 세션


        log.info("Box2 Admin id : {}", adminId);
        log.info("Box2 Password : {}", password);
        log.info("Box2 New Password : {}", newPassword);
        log.info("Box2 Email : {}", email);


        if (password == null || newPassword == null) { // 굳이 필요할까?
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
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
    }

    // OTP 인증 헬퍼 메서드
    private String validateOtp(String adminId, String otpCode) {
        ValidationDTO validationDTO = validationService.getOTP(adminId);
        String otp = validationDTO.getOtpCode();

        if (LocalDateTime.now().isAfter(validationDTO.getExpiredTime())) {
            return "Expired"; // 만료
        }

        // OTP 승인
        if (validationDTO.getOtpCode().equals(otpCode)) {
            return "Success";
        } else { // 실패
            return "Fail";
        }
    }
}
