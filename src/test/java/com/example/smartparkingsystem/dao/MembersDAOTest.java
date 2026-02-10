package com.example.smartparkingsystem.dao;

import com.example.smartparkingsystem.vo.MembersVO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class MembersDAOTest {
    private MembersDAO membersDAO;

    @BeforeEach
    public void ready() {
        membersDAO = new MembersDAO();
    }

    @Test
    public void insert() {
        for (int i = 10; i <= 90; i++) {
            MembersVO membersVO = MembersVO.builder()
                    .carNum(i + "가1234")
                    .memberName("회원" + i)
                    .memberPhone("010-1111-11" + i)
                    .startDate(LocalDate.now())
                    .endDate(LocalDate.now())
                    .build();
            membersDAO.insertMember(membersVO);
        }
    }

}