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

//    @Test
//    public void insertPaymentHistory() {
//        PaymentHistoryVO paymentHistoryVO = PaymentHistoryVO.builder()
//                .payNo(1)
//                .parkingArea("A20")
//                .carNum("23나1234")
//                .entryTime(LocalDateTime.now())
//                .exitTime(LocalDateTime.now())
//                .totalMinutes()
//                .totalCharge()
//                .mno()
//                .pno()
//                .parkNo()
//                .discountAmount()
//                .finalCharge()
//                .isPaid()
//                .build();
//    }

}