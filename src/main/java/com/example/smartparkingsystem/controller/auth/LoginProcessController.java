package com.example.smartparkingsystem.controller.auth;

import com.example.smartparkingsystem.dto.auth.AdminDTO;
import com.example.smartparkingsystem.dto.auth.ValidationDTO;
import com.example.smartparkingsystem.service.auth.AdminService;
import com.example.smartparkingsystem.service.auth.ValidationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import lombok.extern.log4j.Log4j2;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.UUID;

@Log4j2
@WebServlet("/login")
public class LoginProcessController extends HttpServlet {
    private final AdminService adminService = AdminService.INSTANCE;
    private final ValidationService validationService = ValidationService.INSTANCE;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("rememberMe")) {
                    String uuid = cookie.getValue();
                    AdminDTO adminDTO = adminService.getAdminByUuid(uuid);
                    if (adminDTO != null) {
                        HttpSession session = req.getSession();
                        session.setAttribute("adminId", adminDTO.getAdminId());
                        resp.sendRedirect("/main");
                        return;
                    }
                }
            }
        }
        req.getRequestDispatcher("/WEB-INF/login/login.jsp").forward(req,resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String step = req.getParameter("step");

        if (step == null) {
            log.warn("Step null");
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 (값 자체가 없음, 요청 자체가 이상할때만)
            return;
        }

        switch (step) {
            case "1" -> step1(req, resp);
            case "2" -> step2(req, resp);
            case "3" -> step3(req, resp);
            default -> resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 (정보를 찾을 수 없음)
        }
        log.info("step: {}", step);
    }

    // Step1 세션
    private void step1(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        log.info("Step1");
        String adminId = req.getParameter("adminId").trim();
        String password = req.getParameter("password");
        String remember = req.getParameter("rememberMe");
        boolean rememberMe = remember != null && remember.equals("true");

        log.info("adminId: {}", adminId);
        log.info("password: {}", password);
        log.info("rememberMe: {}", rememberMe);

        // 로그인 실패
        if (!adminDB(adminId, password)) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 (실패)
            log.warn("Step1 401");
            return;
        }

        // 사용여부 False
        if (!adminService.getAdminById(adminId).isActive()) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403 (접근 제한)
            log.warn("Step1 403");
            return;
        }

        // TODO 로그인 상태유지 추가 (유지시간 30분 상의 필요)
        if (rememberMe) {
            String uuid = UUID.randomUUID().toString();

            AdminDTO adminDTO = AdminDTO.builder()
                    .adminId(adminId)
                    .uuid(uuid)
                    .build();

            adminService.modifyUUID(adminDTO);

            Cookie cookie = new Cookie("rememberMe", uuid);
            cookie.setMaxAge(60 * 30);
            cookie.setPath("/");
            resp.addCookie(cookie);
        }

        // 로그인 성공시 임시 세션생성
        HttpSession session = req.getSession();
        session.setAttribute("tempAdminId", adminId);
        log.info("session: {}", session.getId());
        log.info("Step2 go");
        resp.setStatus(HttpServletResponse.SC_OK); // 200 (승인)
    }

    // Step2 등록된 이메일 확인
    private void step2(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        log.info("Step2");
        String email = req.getParameter("email").trim();
        HttpSession session = req.getSession();
        String tempAdminId = (String) session.getAttribute("tempAdminId");

        log.info("tempAdminId: {}", tempAdminId);
        log.info("email: {}", email);
        // step1의 임시세션에 아이디 없으면 400에러
        if (tempAdminId == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400
            log.warn("Step2 400");
            return;
        }

        // 같은 레코드에 이메일인지 확인
        if (emailDB(tempAdminId, email)) {

            // Step2에서 Step3로 넘어오려면 인증하기 버튼을 눌러야하기 때문에
            // Step3로 들어갈때 바로 발송
            validationService.otpShipment(tempAdminId);
            log.info("Step3 go");
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        }
    }

    // Step3 OTP 확인
    private void step3(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        log.info("Step3");
        HttpSession session = req.getSession();
        String tempAdminId = (String) session.getAttribute("tempAdminId"); // 임시 세션
        String otpCode = req.getParameter("otpCode");
        log.info("Step3 otpCode: {}", otpCode);

        String resultOTP = otpDB(tempAdminId, otpCode); // 문자열로 결과 받는 변수

        // OTP 완료시 임시 세션 변경
        switch (resultOTP) {
            case "Success" -> {
                log.warn("OTP Success");

                // adminId로 변경
                session.setAttribute("adminId", tempAdminId); // 최종 로그인 세션 적용

                session.removeAttribute("tempAdminId"); // 임시 세션 제거

                adminService.renewalLog(tempAdminId, req.getRemoteAddr()); // 로그인 날짜, IP

                String adminId = (String) session.getAttribute("adminId");

                log.info("Controller step3 adminId 세션 생성 완료: {}", session.getId());
                log.info("Controller step3 adminId 값 {}", adminId);

                if (adminService.getAdminById(adminId).isPasswordReset()) {
                    resp.sendRedirect("/main/mypage");
                    return;
                }
                resp.setStatus(HttpServletResponse.SC_OK);
            }
            case "Expired" -> {
                log.warn("OTP Expired");
                resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            }
            case "Fail" -> {
                log.warn("OTP Fail");
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            }
            default -> {
                log.warn("OTP Error");
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }
        }
    }

    /**
     * 관리자계정 인증, 헬퍼 메서드
     * @param adminId 관리자 아이디
     * @param password 관리자 비밀번호
     * @return 인증여부
     */
    private boolean adminDB(String adminId, String password) {
        return adminService.AuthenticateAdmin(adminId, password);
    }

    /**
     * 이메일 인증, 헬퍼 메서드
     * @param adminId 관리자 아이디
     * @param email 관리자 이메일
     * @return 등록된 이메일 인증여부
     */
    private boolean emailDB(String adminId, String email) {
        AdminDTO admin = adminService.getAdminById(adminId);
        return admin != null && admin.getAdminEmail().equals(email);
    }

    /**
     * OTP 인증, 발송 헬퍼 메서드
     * @param adminId 관리자 아이디
     * @param otpCode OTP 인증코드
     * @return 인증여부(문자열로 인증받음)
     */
    private String otpDB(String adminId, String otpCode) {
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