//package com.example.smartparkingsystem.controller;
//
//import com.example.smartparkingsystem.dto.ParkingHistoryDTO;
//import com.example.smartparkingsystem.dto.PaymentHistoryDTO;
//import com.example.smartparkingsystem.dto.PaymentInfoDTO;
//import com.example.smartparkingsystem.service.ParkingHistoryService;
//import com.example.smartparkingsystem.service.PaymentHistoryService;
//import com.example.smartparkingsystem.service.PaymentInfoService;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import lombok.extern.log4j.Log4j2;
//
//import java.io.IOException;
//
//@Log4j2
//@WebServlet("/payment")  // 단순 경로로!
//public class PaymentHistoryController extends HttpServlet {
//    private final ParkingHistoryService parkingService = ParkingHistoryService.INSTANCE;
//    private final PaymentHistoryService paymentHistoryService = PaymentHistoryService.getInstance();
//    private final PaymentInfoService paymentInfoService = PaymentInfoService.getInstance();
//
//    @Override
//    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//
//
//        log.info("PaymentController post...");
//        resp.setContentType("application/json;charset=UTF-8");
//
//        try {
//            String parkNoStr = req.getParameter("parkNo");
//            log.info("받은 parkNo: " + parkNoStr);
//
//            if (parkNoStr == null || parkNoStr.isEmpty()) {
//                log.warn("parkNo가 없습니다");
//                resp.setStatus(400);
//                resp.getWriter().write("{\"success\": false, \"message\": \"parkNo가 필요합니다\"}");
//                return;
//            }
//
//            Long parkNo = Long.valueOf(parkNoStr);
//            log.info("변환된 parkNo: " + parkNo);
//
//            // 주차 정보 조회
//            log.info("주차 정보 조회 중...");
//            ParkingHistoryDTO parking = parkingService.getParkingHistory(parkNo);
//
//            if (parking == null) {
//                log.error("주차 정보 없음! parkNo: " + parkNo);
//                resp.setStatus(404);
//                resp.getWriter().write("{\"success\": false, \"message\": \"주차 정보를 찾을 수 없습니다\"}");
//                return;
//            }
//
//            String carNum = parking.getCarNum();
//            log.info("조회된 차량번호: " + carNum);
//
//            // 결제 계산
//            log.info("결제 계산 시작...");
//            paymentHistoryService.calculateFinalCharge(carNum);
//            log.info("결제 계산 완료");
//
//            // 결제 정보 조회
//            PaymentHistoryDTO paymentHistoryDTO = paymentHistoryService.getRecentPayment(carNum);
//
//            if (paymentHistoryDTO == null) {
//                log.error("결제 정보 조회 실패!");
//                resp.setStatus(500);
//                resp.getWriter().write("{\"success\": false, \"message\": \"결제 정보 조회 실패\"}");
//                return;
//            }
//
//            // 기본 요금 정보
//            PaymentInfoDTO paymentInfoDTO = paymentInfoService.getInfo();
//
//            if (paymentInfoDTO == null) {
//                log.error("기본 요금 정보 없음!");
//                resp.setStatus(500);
//                resp.getWriter().write("{\"success\": false, \"message\": \"기본 요금 정보 조회 실패\"}");
//                return;
//            }
//
//            // 성공 응답
//            String jsonResponse = String.format(
//                    "{\"success\": true, \"carNum\": \"%s\", \"entryTime\": \"%s\", " +
//                            "\"exitTime\": \"%s\", \"totalMinutes\": %d, \"basicCharge\": %d, " +
//                            "\"extraCharge\": %d, \"discountAmount\": %d, \"totalCharge\": %d}",
//                    carNum,
//                    paymentHistoryDTO.getEntryTime(),
//                    paymentHistoryDTO.getExitTime(),
//                    paymentHistoryDTO.getTotalMinutes(),
//                    paymentInfoDTO.getBasicCharge(),
//                    (paymentHistoryDTO.getTotalCharge() - paymentInfoDTO.getBasicCharge()),
//                    paymentHistoryDTO.getDiscountAmount(),
//                    paymentHistoryDTO.getTotalCharge()
//            );
//
//            log.info("응답: " + jsonResponse);
//            resp.getWriter().write(jsonResponse);
//            log.info("============ PaymentController 완료 ============");
//
//        } catch (NumberFormatException e) {
//            log.error("parkNo 형식 오류", e);
//            resp.setStatus(400);
//            resp.getWriter().write("{\"success\": false, \"message\": \"parkNo 형식이 올바르지 않습니다\"}");
//        } catch (Exception e) {
//            log.error("결제 처리 중 예상치 못한 오류!", e);
//            e.printStackTrace();
//            resp.setStatus(500);
//            resp.getWriter().write("{\"success\": false, \"message\": \"서버 오류: " + e.getMessage() + "\"}");
//        }
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        doPost(req, resp);
//    }
//}