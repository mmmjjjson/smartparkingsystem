package com.example.smartparkingsystem.dao;

import com.example.smartparkingsystem.vo.ParkingHistoryVO;
import com.example.smartparkingsystem.vo.PaymentHistoryVO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;

class PaymentHistoryDAOTest {
    PaymentHistoryDAO paymentHistoryDAO;

    @BeforeEach
    public void ready() {
        paymentHistoryDAO = PaymentHistoryDAO.getInstance();
    }

    @Test
    public void insertPaymentHistory() {
        PaymentHistoryVO paymentHistoryVO = PaymentHistoryVO.builder()
                .payNo(1)
                .parkingArea("A-1")
                .carNum("11가1001")
                .entryTime(LocalDateTime.now())
                .exitTime(LocalDateTime.now())
                .totalMinutes(2026021112)
                .totalCharge(10000)
                .mno(2)
                .pno(5)
                .parkNo(1)
                .discountAmount(2000)
                .finalCharge(8000)
                .isPaid(true)
                .build();
        paymentHistoryDAO.insertPaymentHistory(paymentHistoryVO);
    }

}