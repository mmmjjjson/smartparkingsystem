package com.example.smartparkingsystem.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginProcessServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String step = req.getParameter("step");

        if (step == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400
            return;
        }

        // TODO : 그냥 파라미터 받아서 리다이렉트형식으로 하려니까 새로고침으로 넘어가야해서 그냥 AJAX로 만들어봄 (좀 어설플 수 있음)
        switch (step) {
            case "1":
                step1(req, resp);
                break;
            case "2":
                step2(req, resp);
                break;
            case "3":
                step3(req, resp);
                break;
            default:
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        }
    }

    // Step1 세션
    private void step1(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String adminId = req.getParameter("adminId");
        String password = req.getParameter("password");

        // 로그인 성공시 임시 세션
        if (adminDB(adminId, password)) {
            HttpSession session = req.getSession();
            session.setAttribute("tempAdminId", adminId);
            resp.setStatus(HttpServletResponse.SC_OK); // 200
        } else {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    // Step2 등록된 이메일 확인
    private void step2(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");

        if (emailDB(email)) {
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
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

            System.out.println("adminId 세션 생성 완료: " + session.getId());
            System.out.println("adminId 값 " + session.getAttribute("adminId"));
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    // TODO: 나중에 DB연동시 수정
    private boolean adminDB (String adminId, String password) {
        return "admin".equals(adminId) && "1234".equals(password);
    }
    private boolean emailDB (String email) {
        return "admin@naver.com".equals(email);
    }
    private boolean otpDB (String otp) {
        return "123456".equals(otp);
    }
}