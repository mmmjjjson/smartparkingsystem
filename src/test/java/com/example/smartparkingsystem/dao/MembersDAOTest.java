package com.example.smartparkingsystem.dao;

import com.example.smartparkingsystem.vo.MembersVO;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class MembersDAOTest {
    private static final Logger log = LogManager.getLogger(MembersDAOTest.class);
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
                    .startDate(LocalDate.now().plusDays(i))
                    .endDate(LocalDate.now().plusDays(i).plusMonths(1))
                    .build();
            membersDAO.insertMember(membersVO);
        }
    }

    @Test
    public void select() {
        var members = membersDAO.selectMembers(1, 10, "name", "2", null);
        log.info(members);
    }

    @Test
    public void count() {
        int count = membersDAO.selectMemberCount("name", "2", null);
        log.info(count);

    }

}