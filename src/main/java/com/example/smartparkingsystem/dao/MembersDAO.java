package com.example.smartparkingsystem.dao;

import com.example.smartparkingsystem.dto.MembersDTO;
import com.example.smartparkingsystem.vo.MembersVO;
import lombok.Cleanup;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class MembersDAO {
    private static List<MembersDTO> membersDTOList = new ArrayList<>(); // 회원 정보 저장할 리스트 생성

    // 신규 회원 등록
    public void insertMember(MembersDTO membersDTO) {
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

    // 회원 정보 수정
    public void updateMember(String originCarNum, MembersDTO membersDTO) {
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

    // 회원 삭제
    public void deleteMember(String carNum) {
        for (int i = 0; i < membersDTOList.size(); i++) {
             if (membersDTOList.get(i).getCarNum().equals(carNum)) {
                 membersDTOList.remove(i);
                 break;
             }
        }
    }

    // 회원 목록 조회
//    public List<MembersDTO> selectAllMembers() {
//        return membersDTOList;
//    }

    /**************************************************************************************************/
    // 신규 회원 등록
    public void insertMember(MembersVO membersVO) {
        String sql = "INSERT INTO members (car_num, member_name, member_phone, start_date, end_date) VALUES (?, ?, ?, ?, ?)";

        try {
            @Cleanup Connection connection = ConnectionUtil.INSTANCE.getConnection();
            @Cleanup PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, membersVO.getCarNum());
            preparedStatement.setString(2, membersVO.getMemberName());
            preparedStatement.setString(3, membersVO.getMemberPhone());
            preparedStatement.setDate(4, Date.valueOf(String.valueOf(membersVO.getStartDate())));
            preparedStatement.setDate(5, Date.valueOf(String.valueOf(membersVO.getEndDate())));
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // 회원 정보 수정
    public void updateMember(MembersVO membersVO) {
        String sql = "UPDATE members SET car_num = ?, member_name = ?, member_phone = ?, start_date = ?, end_date = ? WHERE mno = ?";

        try {
            @Cleanup Connection connection = ConnectionUtil.INSTANCE.getConnection();
            @Cleanup PreparedStatement preparedStatement = connection.prepareStatement(sql);

            preparedStatement.setString(1, membersVO.getCarNum());
            preparedStatement.setString(2, membersVO.getMemberName());
            preparedStatement.setString(3, membersVO.getMemberPhone());
            preparedStatement.setDate(4, Date.valueOf(String.valueOf(membersVO.getStartDate())));
            preparedStatement.setDate(5, Date.valueOf(String.valueOf(membersVO.getEndDate())));
            preparedStatement.setLong(6, membersVO.getMno());
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // 회원 삭제
    public void deleteMember(Long mno) {
        String sql = "DELETE FROM members WHERE mno = ?";

        try {
            @Cleanup Connection connection = ConnectionUtil.INSTANCE.getConnection();
            @Cleanup PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setLong(1, mno);
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // 회원 목록 조회
    public List<MembersVO> selectAllMembers() {
        List<MembersVO> membersVOList = new ArrayList<>();

        try {
            @Cleanup Connection connection = ConnectionUtil.INSTANCE.getConnection();
            @Cleanup PreparedStatement preparedStatement = connection.prepareStatement("SELECT * FROM members");
            @Cleanup ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                MembersVO membersVO = MembersVO.builder()
                        .mno(resultSet.getLong("mno"))
                        .carNum(resultSet.getString("car_num"))
                        .memberName(resultSet.getString("member_name"))
                        .memberPhone(resultSet.getString("member_phone"))
                        .startDate(resultSet.getDate("start_date").toLocalDate().atStartOfDay())
                        .endDate(resultSet.getDate("end_date").toLocalDate().atStartOfDay())
                        .build();

                membersVOList.add(membersVO);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return membersVOList;
    }

    // 해당 회원 조회
    public MembersVO selectOneMember(Long mno) {
        String sql = "SELECT * FROM members WHERE mno = ?";

        try {
            @Cleanup Connection connection = ConnectionUtil.INSTANCE.getConnection();
            @Cleanup PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setLong(1, mno);
            @Cleanup ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                MembersVO membersVO = MembersVO.builder()
                        .mno(resultSet.getLong("mno"))
                        .carNum(resultSet.getString("car_num"))
                        .memberName(resultSet.getString("member_name"))
                        .memberPhone(resultSet.getString("member_phone"))
                        .startDate(resultSet.getDate("start_date").toLocalDate().atStartOfDay())
                        .endDate(resultSet.getDate("end_date").toLocalDate().atStartOfDay())
                        .build();
                return membersVO;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }
}
