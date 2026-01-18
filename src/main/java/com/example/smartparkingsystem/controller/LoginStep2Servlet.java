package com.example.smartparkingsystem.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login/login-step2")
public class LoginStep2Servlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        String inputOTP = request.getParameter("otpCode");

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"세션이 만료되었습니다.\"}");
            return;
        }

        String savedOTP = (String) session.getAttribute("otp");
        Long expireTime = (Long) session.getAttribute("otpExpireTime");

        // OTP 만료 확인
        if (expireTime == null || System.currentTimeMillis() > expireTime) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"OTP가 만료되었습니다.\"}");
            return;
        }

        // OTP 검증
        if (savedOTP != null && savedOTP.equals(inputOTP)) {
            // 로그인 성공
            session.setAttribute("authenticated", true);
            session.removeAttribute("otp"); // OTP 삭제 (재사용 방지)
            session.removeAttribute("otpExpireTime");

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"success\": true, \"message\": \"로그인 성공\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"인증번호가 올바르지 않습니다.\"}");
        }
    }
}