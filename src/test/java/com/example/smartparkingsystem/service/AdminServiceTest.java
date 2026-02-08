package com.example.smartparkingsystem.service;

import com.example.smartparkingsystem.dto.AdminDTO;
import lombok.extern.log4j.Log4j2;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

@Log4j2
class AdminServiceTest {
    private AdminService adminService;

    @BeforeEach
    public void ready() {
        adminService = AdminService.INSTANCE;
    }

    @Test
    public void adminServiceSelect() {
        for (AdminDTO adminDTO : adminService.getAdminAll()) {
            log.info(adminDTO);
        }
    }

    @Test
    public void adminServiceId() {
        log.info(adminService.getAdminById("admin"));
    }

    @Test
    public void adminLogin() {
        log.info(adminService.AuthenticateAdmin("test", "1111"));
    }

    @Test
    public void adminServiceUpdate() {
        AdminDTO adminDTO = AdminDTO.builder()
                .admin_id("test1")
                .password("test1")
                .adminName("수정2")
                .birth("950905")
                .adminEmail("수정2@gmail.com")
                .is_active(false)
                .build();
        log.info(adminDTO);
        adminService.modifyAdmin(adminDTO);
    }

    @Test
    public void adminLog() {
        String adminId = "test";
        String lastLoginIp = "192.168.0.1";
        adminService.renewalLog(adminId, lastLoginIp);
    }

    @Test
    public void adminPw() {
        String adminId = "test";
        String password = "test";
        adminService.changePassword(adminId, password);
    }

    @Test
    public void adminServiceDelete() {
        adminService.removeAdmin("test1");
    }
}