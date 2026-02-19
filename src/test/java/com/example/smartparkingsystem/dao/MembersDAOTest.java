package com.example.smartparkingsystem.dao;

import org.junit.jupiter.api.Test;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

class MembersDAOTest {
    @Test
    public void insertDummyMembersTest() {
        MembersDAO dao = new MembersDAO();

        int count = 100;

        for (int i = 1; i <= count; i++) {
            String carNum = String.format("99가%04d", i);
            String memberName = "회원" + i;
            String memberPhone = "010-1111-" + String.format("%04d", i);

            LocalDate startDate = LocalDate.now().minusDays(i);
            LocalDate endDate;

            // 짝수는 활성, 홀수는 만료
            if (i % 2 == 0) {
                endDate = LocalDate.now().plusDays(30);
            } else {
                endDate = LocalDate.now().minusDays(30);
            }

            dao.insertMember(
                    com.example.smartparkingsystem.vo.MembersVO.builder()
                            .carNum(carNum)
                            .memberName(memberName)
                            .memberPhone(memberPhone)
                            .startDate(startDate)
                            .endDate(endDate)
                            .memberCharge(100000)
                            .build()
            );
        }
    }
}