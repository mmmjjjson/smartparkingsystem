package com.example.smartparkingsystem.member.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class MembersDAO {
    private static List<MembersDTO> membersDTOList = new ArrayList<>(); // 회원 정보 저장할 리스트 생성

    public void insertMember(MembersDTO membersDTO) { // 회원 등록
        membersDTOList.add(MembersDTO.builder()
                .carNum(membersDTO.getCarNum())
                .memberName(membersDTO.getMemberName())
                .memberPhone(membersDTO.getMemberPhone())
                .startDate(membersDTO.getStartDate())
                .createdAt(LocalDateTime.now())
                .endDate(membersDTO.getEndDate())
                .isActive(true)
                .build());

    }

    public void updateMember(String originCarNum, MembersDTO membersDTO) { // 회원 정보 수정
        for (MembersDTO member : membersDTOList) {
            if (member.getCarNum().equals(originCarNum)) {
                member.setCarNum(membersDTO.getCarNum());
                member.setMemberName(membersDTO.getMemberName());
                member.setMemberPhone(membersDTO.getMemberPhone());
                member.setStartDate(membersDTO.getStartDate());
                member.setEndDate(membersDTO.getEndDate());
                member.setUpdatedDate(LocalDateTime.now());
                break;
            }
        }
    }

    public void deleteMember(String carNum) { // 회원 삭제
        for (int i = 0; i < membersDTOList.size(); i++) {
             if (membersDTOList.get(i).getCarNum().equals(carNum)) {
                 membersDTOList.remove(i);
                 break;
             }
        }
    }

    public List<MembersDTO> selectAllMembers() { // 회원 목록 조회
        return membersDTOList;
    }
}
