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

import java.io.IOException;
import java.time.LocalDateTime;

@Log4j2
@WebServlet("/main/mypage/email")
public class EmailVerifyController extends HttpServlet {
    private final AdminService adminService = AdminService.INSTANCE;
    private final ValidationService validationService = ValidationService.INSTANCE;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/login/emailVerification.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String box = req.getParameter("box");

        if (box == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        switch (box) {
            case "1" -> box(req, resp);
            case "returnOTP" -> returnOTP(req, resp); // OTP 재발송 따로 분리
            default -> resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
        log.info("box {}", box);
    }

    // 첫번째 박스 (이메일 수정칸)
    private void box (HttpServletRequest req, HttpServletResponse resp) throws ServletException,IOException {
        /*
        이메일 변경 구현 (팝업창 띄워서 이메일 인증하는 형식 + 4분 타이머 추가)
        OTP연결시 제한시간 4분
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
        if (newEmail == null) {
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
        if (otpCode == null) {
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

    private void returnOTP (HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        String adminId = (String) session.getAttribute("adminId");
        if (adminId == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        validationService.otpShipment(adminId);
        resp.setStatus(HttpServletResponse.SC_OK);
    }

    // OTP 인증 헬퍼 메서드
    private String validateOtp(String adminId, String otpCode) {
        ValidationDTO validationDTO = validationService.getOTP(adminId);
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
