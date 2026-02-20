package com.example.smartparkingsystem.service;

import com.example.smartparkingsystem.service.auth.MailService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class MailServiceTest {
    private MailService mailService;
    @BeforeEach
    void setUp() {
        mailService = MailService.INSTANCE;
    }

    @Test
    void sendMail() {
        mailService.sendAuthEmail("vcg258@naver.com", "123456");
    }

}