package com.example.smartparkingsystem.service;

import com.example.smartparkingsystem.dto.member.MembersDTO;
import com.example.smartparkingsystem.service.member.MembersService;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;

class MembersServiceTest {
    public MembersService membersService = MembersService.INSTANCE;

    @Test
    public void insert() {
        membersService.addMember(MembersDTO.builder()
                .carNum("12가1234")
                .memberName("123")
                .memberPhone("1234")
                .startDate(LocalDate.of(2026, 2, 13))
                .endDate(LocalDate.of(2026, 3, 12))
                .build());
    }
}