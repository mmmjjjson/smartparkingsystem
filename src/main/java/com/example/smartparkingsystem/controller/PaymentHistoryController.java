package com.example.smartparkingsystem.controller;

import com.example.smartparkingsystem.dto.PaymentHistoryDTO;
import com.example.smartparkingsystem.dto.PaymentInfoDTO;
import com.example.smartparkingsystem.service.PaymentHistoryService;
import com.example.smartparkingsystem.service.PaymentInfoService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.log4j.Log4j2;

import java.io.IOException;

@Log4j2
public class PaymentHistoryController extends HttpServlet {
    private final PaymentHistoryService paymentHistoryService = PaymentHistoryService.getInstance();
    private final PaymentInfoService paymentInfoService = PaymentInfoService.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        log.info("paymentHistory post");
        resp.setContentType("application/json;charset=UTF-8"); // 응답 형식 JSON화 (js에서 읽을 수 있도록)
        String action = req.getPathInfo();

        if (action.equals("/payment")) {
            String carNum = req.getParameter("carNum");
            paymentHistoryService.calculateFinalCharge(carNum);
            PaymentHistoryDTO paymentHistoryDTO = paymentHistoryService.getRecentPayment(carNum);
            PaymentInfoDTO paymentInfoDTO = paymentInfoService.getInfo();
            if (paymentHistoryDTO == null) {
                // 여기가 터지면 DB Insert는 됐는데 Select가 안되는 상황
                resp.setStatus(500);
                resp.getWriter().write("{\"success\": false, \"message\": \"DB 조회 실패\"}");
                return;
            }

            // 4. [응답] 날짜 변환 및 JSON 전송
            String entryTimeStr = String.valueOf(paymentHistoryDTO.getEntryTime()).replace(" ", "T");
            resp.getWriter().write(
                    "{\"success\": true" +
//                            ", \"payNo\": \"" + paymentHistoryDTO.getPayNo() + "\"" +
                            ", \"carNum\": \"" + carNum + "\"" +
                            ", \"entryTime\": \"" + paymentHistoryDTO.getEntryTime() + "\"" +
                            ", \"exitTime\": \"" + paymentHistoryDTO.getExitTime() + "\"" +
                            ", \"totalMinutes\": \"" + paymentHistoryDTO.getTotalMinutes() + "\"" +
                            ", \"basicCharge\": \"" + paymentInfoDTO.getBasicCharge() + "\"" +
                            ", \"extraCharge\": \"" + (paymentHistoryDTO.getTotalCharge() - paymentInfoDTO.getBasicCharge()) + "\"" +
                            ", \"discountAmount\": \"" + paymentHistoryDTO.getDiscountAmount() + "\"" +
                            ", \"totalCharge\": " + paymentHistoryDTO.getTotalCharge() + "}"
            );

        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND); // 404 에러
        }

    }
}
