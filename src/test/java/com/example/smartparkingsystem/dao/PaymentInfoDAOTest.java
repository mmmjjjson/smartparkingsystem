package com.example.smartparkingsystem.dao;

import lombok.extern.log4j.Log4j2;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;
@Log4j2
class PaymentInfoDAOTest {
    private PaymentInfoDAO paymentInfoDAO;
    @BeforeEach
    void setUp() {
        paymentInfoDAO = PaymentInfoDAO.getInstance();
    }
    @Test
    void getPaymentHistory() {
        log.info(paymentInfoDAO.selectInfo());

    }
}