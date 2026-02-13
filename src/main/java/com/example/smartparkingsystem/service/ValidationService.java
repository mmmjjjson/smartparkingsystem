package com.example.smartparkingsystem.service;


import com.example.smartparkingsystem.dao.ValidationDAO;
import com.example.smartparkingsystem.dto.ValidationDTO;
import com.example.smartparkingsystem.util.MapperUtil;
import com.example.smartparkingsystem.vo.ValidationVO;
import org.modelmapper.ModelMapper;

import java.time.LocalDateTime;

public enum ValidationService {
    INSTANCE;

    private ValidationDAO validationDAO;
    private AdminService adminService;
    private MailService mailService;
    private ModelMapper modelMapper;

    ValidationService() {
        validationDAO = new ValidationDAO();
        adminService = AdminService.INSTANCE;
        modelMapper = MapperUtil.INSTANCE.getInstance();
        mailService = MailService.getINSTANCE();
    }


    public void otpShipment(String adminId) {
        // 발송할 이메일
        String adminEmail = adminService.getAdminById(adminId).getAdminEmail();

        String otpCode = "";
        for (int i = 0; i < 6; i++) {
            otpCode += (int) (Math.random() * 10);
        }

        // 임시로 나한테 보냄
        mailService.sendAuthEmail("vcg258@naver.com", otpCode);
        ValidationVO validationVO = ValidationVO.builder()
                .adminId(adminId)
                .otpCode(otpCode)
                .adminEmail(adminEmail)
                .expiredTime(LocalDateTime.now())
                .build();
        validationDAO.logOTP(validationVO);
    }

    public ValidationDTO getOTP (String adminId) {
        return modelMapper.map(validationDAO.selectOTPOne(adminId), ValidationDTO.class);
    }
}
