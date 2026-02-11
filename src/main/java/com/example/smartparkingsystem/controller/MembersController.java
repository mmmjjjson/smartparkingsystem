//package com.example.smartparkingsystem.controller;
//
//import com.example.smartparkingsystem.service.MembersService;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import lombok.extern.log4j.Log4j2;
//
//import java.io.IOException;
//
//@Log4j2
//@WebServlet(name = "membersController", value = {"*.jsp"})
//public class MembersController extends HttpServlet {
//    @Override
//    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        doPost(req, resp);
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        MembersService membersService = MembersService.INSTANCE;
//        String requestURI = req.getRequestURI(); // 요청 URI
//        String contextPath = req.getContextPath(); // 컨텍스트 경로
//        String command = requestURI.substring(contextPath.length()); // 요청 URI에서 컨텍스트 경로를 제거한 명령어
//
//        log.info("requestURI: {}", requestURI);
//        log.info("contextPath: {}", contextPath);
//        log.info("command: {}", command); // 파일 경로에서 이름을 불러오기 위한 명령어
//
//        // 세션에서 로그인 여부 가져오기
//        HttpSession session = req.getSession();
//        String tempAdminId = (String) session.getAttribute("tempAdminId");
//
//        switch (command) {
//            case "/member/member.jsp" -> { // 회원 관리 메인 목록
//                log.info("회원 메인 목록");
//
//                String searchType = req.getParameter("searchType");
//                String keyword = req.getParameter("keyword");
//                String status = req.getParameter("status");
//
//                int pageNum = 1;
//
//                if (req.getParameter("pageNum") != null) {
//                    pageNum = Integer.parseInt(req.getParameter("pageNum"));
//                }
//
//
//
//            }
//        }
//    }
//}
