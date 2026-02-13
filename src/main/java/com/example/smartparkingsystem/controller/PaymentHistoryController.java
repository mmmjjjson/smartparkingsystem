package com.example.smartparkingsystem.controller;

import com.example.smartparkingsystem.service.PaymentHistoryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.log4j.Log4j2;

import java.io.IOException;

@Log4j2
@WebServlet(name = "paymentHistory", value = "/main")
public class PaymentHistoryController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        req.setAttribute("", );

        req.getRequestDispatcher("/web/main_modal.js");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        log.info("paymentHistory post");

        PaymentHistoryService paymentHistoryService = PaymentHistoryService.getInstance();

        paymentHistoryService.calculateFinalCharge();
    }
}
