package com.example.smartparkingsystem.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;

@WebServlet("/login-step1")
public class LoginStep1Servlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // 인코딩 설정
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        // 파라미터 받기
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 로그 출력 (영어)
        System.out.println("==========================================");
        System.out.println("LoginStep1Servlet Called!");
        System.out.println("Method: " + request.getMethod());
        System.out.println("Content-Type: " + request.getContentType());
        System.out.println("Username: " + username);
        System.out.println("Password: " + password);
        System.out.println("==========================================");

        PrintWriter out = response.getWriter();

        // null 체크
        if (username == null || password == null) {
            System.out.println("ERROR: Parameters are null!");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);

            out.write("{\"success\": false, \"message\": \"Missing parameters\"}");
            out.flush();
            return;
        }

        // 빈 문자열 체크
        if (username.trim().isEmpty() || password.trim().isEmpty()) {
            System.out.println("ERROR: Parameters are empty!");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"success\": false, \"message\": \"Empty parameters\"}");
            out.flush();
            return;
        }

        // 인증 검증
        if ("admin".equals(username) && "1234".equals(password)) {

            // OTP 생성
            String otp = generateOTP();

            // 세션에 저장
            HttpSession session = request.getSession();
            session.setAttribute("otp", otp);
            session.setAttribute("username", username);
            session.setAttribute("otpExpireTime", System.currentTimeMillis() + 180000); // 3분

            System.out.println("SUCCESS! Generated OTP: " + otp);

            // 성공 응답
            response.setStatus(HttpServletResponse.SC_OK);
            out.write("{\"success\": true, \"message\": \"Login successful\", \"otp\": \"" + otp + "\"}");

        } else {
            System.out.println("FAIL! Invalid credentials!");

            // 실패 응답
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"success\": false, \"message\": \"Invalid username or password\"}");
        }

        out.flush();
    }

    // OTP 생성 메서드
    private String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000); // 100000 ~ 999999
        return String.valueOf(otp);
    }
}