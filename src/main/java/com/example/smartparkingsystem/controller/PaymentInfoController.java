package com.example.smartparkingsystem.controller;

import com.example.smartparkingsystem.dto.PaymentInfoDTO;
import com.example.smartparkingsystem.service.PaymentInfoService;
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
@WebServlet(name = "setting", value = "/setting")
public class PaymentInfoController extends HttpServlet {
    private final PaymentInfoService paymentInfoService = PaymentInfoService.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        PaymentInfoDTO paymentInfoDTO = paymentInfoService.getInfo();
        log.info(paymentInfoDTO);

        req.setAttribute("paymentInfoDTO", paymentInfoDTO);

        req.getRequestDispatcher("/WEB-INF/setting/setting.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        log.info("setting post");
        PaymentInfoDTO paymentInfoDTO = PaymentInfoDTO.builder()
                .freeTime(Integer.parseInt(req.getParameter("free_time")))
                .basicTime(Integer.parseInt(req.getParameter("basic_time")))
                .extraTime(Integer.parseInt(req.getParameter("extra_time")))
                .basicCharge(Integer.parseInt(req.getParameter("basic_charge")))
                .extraCharge(Integer.parseInt(req.getParameter("extra_charge")))
                .maxCharge(Integer.parseInt(req.getParameter("max_charge")))
                .memberCharge(Integer.parseInt(req.getParameter("member_charge")))
                .smallCarDiscount(Double.parseDouble(req.getParameter("small_car_discount")))
                .disabledDiscount(Double.parseDouble(req.getParameter("disabled_discount")))
                .adminId((String) session.getAttribute("adminId"))
                .build();
        log.info(paymentInfoDTO);
        paymentInfoService.addInfo(paymentInfoDTO);

        resp.sendRedirect("/setting");
    }
}