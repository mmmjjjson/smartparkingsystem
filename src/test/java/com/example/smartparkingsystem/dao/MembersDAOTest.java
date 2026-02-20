package com.example.smartparkingsystem.dao;

import com.example.smartparkingsystem.dao.member.MembersDAO;
import com.example.smartparkingsystem.vo.member.MembersVO;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;

class MembersDAOTest {
    @Test
    public void insertMemberTest() {
        MembersDAO dao = new MembersDAO();

        String carNum = "12가9999";

        MembersVO membersVO = MembersVO.builder()
                .carNum(carNum)
                .memberName("테스트회원")
                .memberPhone("010-9999-9999")
                .startDate(LocalDate.now())
                .endDate(LocalDate.now().plusDays(30))
                .memberCharge(100000)
                .build();

        dao.insertMember(membersVO);

        MembersVO result = dao.selectOneMember(carNum);

        Assertions.assertNotNull(result);
        Assertions.assertEquals("테스트회원", result.getMemberName());
    }

    @Test
    public void selectOneMemberTest() {
        MembersDAO dao = new MembersDAO();

        MembersVO result = dao.selectOneMember("12가9999");

        Assertions.assertNotNull(result);
        Assertions.assertEquals("테스트회원", result.getMemberName());
    }

    @Test
    public void updateMemberTest() {
        MembersDAO dao = new MembersDAO();

        MembersVO membersVO = dao.selectOneMember("12가9999");
        Assertions.assertNotNull(membersVO);

        MembersVO updatedVO = MembersVO.builder()
                .memberName("수정회원")
                .build();

        dao.updateMember(updatedVO);

        MembersVO updated = dao.selectOneMember("12가9999");

        Assertions.assertEquals("수정회원", updated.getMemberName());
    }

    @Test
    public void selectMemberCountTest() {
        MembersDAO dao = new MembersDAO();

        int count = dao.selectMemberCount(null, null, "active");

        Assertions.assertTrue(count > 0);
    }

    @Test
    public void selectMemberListPagingTest() {
        MembersDAO dao = new MembersDAO();

        var list = dao.selectMemberList(null, null, null, 0, 10);

        Assertions.assertEquals(10, list.size());
    }


//    @Test
//    public void insertDummyMembersTest() {
//        MembersDAO dao = new MembersDAO();
//
//        int count = 100;
//
//        for (int i = 1; i <= count; i++) {
//            String carNum = String.format("99가%04d", i);
//            String memberName = "회원" + i;
//            String memberPhone = "010-1111-" + String.format("%04d", i);
//
//            LocalDate startDate = LocalDate.now().minusDays(i);
//            LocalDate endDate;
//
//            // 짝수는 활성, 홀수는 만료
//            if (i % 2 == 0) {
//                endDate = LocalDate.now().plusDays(30);
//            } else {
//                endDate = LocalDate.now().minusDays(30);
//            }
//
//            dao.insertMember(
//                    MembersVO.builder()
//                            .carNum(carNum)
//                            .memberName(memberName)
//                            .memberPhone(memberPhone)
//                            .startDate(startDate)
//                            .endDate(endDate)
//                            .memberCharge(100000)
//                            .build()
//            );
//        }
//    }
}