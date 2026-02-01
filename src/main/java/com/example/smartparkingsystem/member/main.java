package com.example.smartparkingsystem.member;

import com.example.smartparkingsystem.member.model.MembersDAO;
import com.example.smartparkingsystem.member.model.MembersDTO;

import java.time.LocalDateTime;
import java.util.List;

public class main {
    public static void main(String[] args) {
        test();
    }

    private static void test() {
        MembersDAO membersDAO = new MembersDAO();

        // 회원 등록
        MembersDTO member1 = MembersDTO.builder()
                .carNum("12나 5678")
                .memberName("홍길동")
                .memberPhone("010-1122-3344")
                .startDate(LocalDateTime.now())
                .endDate(LocalDateTime.now().plusMonths(6))
                .build();

        membersDAO.insertMember(member1);

        System.out.println("회원 등록 완료");
        printMembers(membersDAO.selectAllMembers());

        System.out.println();

        // 회원 수정
        MembersDTO updateMember = MembersDTO.builder()
                .carNum("12나 5678")
                .memberName("홍길동(수정)")
                .memberPhone("010-3344-1122")
                .startDate(LocalDateTime.now())
                .endDate(LocalDateTime.now().plusMonths(12))
                .build();

        membersDAO.updateMember(updateMember);

        System.out.println("회원 수정");
        printMembers(membersDAO.selectAllMembers());

        System.out.println();

        // 회원 삭제
        membersDAO.deleteMember("12나 5678");

        System.out.println("회원 삭제");
        printMembers(membersDAO.selectAllMembers());
    }


    // 회원 목록 출력용 메서드
    private static void printMembers(List<MembersDTO> members) {
        if (members.isEmpty()) {
            System.out.println("회원 없음");
            return;
        }

        for (MembersDTO m : members) {
            System.out.println(
                    "차량번호: " + m.getCarNum() +
                            " | 이름: " + m.getMemberName() +
                            " | 연락처: " + m.getMemberPhone() +
                            " | 시작일: " + m.getStartDate() +
                            " | 만료일: " + m.getEndDate()
            );
        }
    }
}
