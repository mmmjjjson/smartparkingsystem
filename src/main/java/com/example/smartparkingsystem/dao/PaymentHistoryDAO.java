package com.example.smartparkingsystem.dao;

import com.example.smartparkingsystem.vo.MembersVO;
import com.example.smartparkingsystem.vo.ParkingHistoryVO;
import com.example.smartparkingsystem.vo.PaymentHistoryVO;
import com.example.smartparkingsystem.vo.PaymentInfoVO;
import lombok.Cleanup;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class PaymentHistoryDAO {
    private static PaymentHistoryDAO instance;

    private PaymentHistoryDAO() {}

    public static PaymentHistoryDAO getInstance() {
        if (instance == null) {
            instance = new PaymentHistoryDAO();
        }
        return instance;
    }
//
//    public List<ParkingHistoryVO> selectAllParkingHistory() {
//        List<ParkingHistoryVO> parkingHistoryVOList = new ArrayList<>();
//        String sql = "SELECT * from parking_history";
//
//        try {
//            @Cleanup Connection connection = ConnectionUtil.INSTANCE.getConnection();
//            @Cleanup PreparedStatement preparedStatement = connection.prepareStatement(sql);
//            @Cleanup ResultSet resultSet = preparedStatement.executeQuery();
//
//            while (resultSet.next()) {
//                ParkingHistoryVO parkingHistoryVO = ParkingHistoryVO.builder()
//                        .parkNo(resultSet.getLong("park_no"))
//                        .parkingArea(resultSet.getString("parking_area"))
//                        .carNum(resultSet.getString("car_num"))
//                        .carType(resultSet.getString("car_type"))
//                        .isMember(resultSet.getBoolean("is_member"))
//                        .entryTime(resultSet.getObject("entry_time", LocalDateTime.class))
//                        .exitTime(resultSet.getObject("exit_time", LocalDateTime.class))
//                        .totalMinutes(resultSet.getInt("total_minutes"))
//                        .build();
//                parkingHistoryVOList.add(parkingHistoryVO);
//            }
//        } catch (SQLException e) {
//            throw new RuntimeException(e);
//        }
//        return parkingHistoryVOList;
//    }
//
//    public List<MembersVO> selectMembers() {
//        List<MembersVO> membersVOList = new ArrayList<>();
//        String sql = "";
//
//        try {
//            @Cleanup Connection connection = ConnectionUtil.INSTANCE.getConnection();
//            @Cleanup PreparedStatement preparedStatement = connection.prepareStatement(sql);
//            @Cleanup ResultSet resultSet = preparedStatement.executeQuery();
//
//            while (resultSet.next()) {
//                MembersVO membersVO = MembersVO.builder()
//                        .mno(resultSet.getLong("mno"))
//                        .carNum(resultSet.getString("car_num"))
//                        .memberName(resultSet.getString("member_name"))
//                        .memberPhone(resultSet.getString("member_phone"))
//                        .startDate(resultSet.getObject("start_date", LocalDate.class))
//                        .endDate(resultSet.getObject("end_date", LocalDate.class))
//                        .build();
//                membersVOList.add(membersVO);
//            }
//
//        } catch (SQLException e) {
//            throw new RuntimeException(e);
//        }
//        return membersVOList;
//    }

    public void insertPaymentHistory(ParkingHistoryVO parkingHistoryVO,PaymentHistoryVO paymentHistoryVO, PaymentInfoVO paymentInfoVO, MembersVO membersVO) {
        String sql = "insert into payment_history values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now())";

        try {
            @Cleanup Connection connection = ConnectionUtil.INSTANCE.getConnection();
            @Cleanup PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setLong(1, parkingHistoryVO.getParkNo());
            preparedStatement.setString(2, parkingHistoryVO.getParkingArea());
            preparedStatement.setString(3, parkingHistoryVO.getCarNum());
            preparedStatement.setObject(4, parkingHistoryVO.getEntryTime());
            preparedStatement.setObject(5, parkingHistoryVO.getExitTime());
            preparedStatement.setInt(6, parkingHistoryVO.getTotalMinutes());
            preparedStatement.setInt(7, paymentHistoryVO.getTotalCharge());
            preparedStatement.setLong(8, membersVO.getMno());
            preparedStatement.setLong(9, paymentInfoVO.getPno());
            preparedStatement.setLong(10, parkingHistoryVO.getParkNo());
            preparedStatement.setInt(11, paymentHistoryVO.getDiscountAmount());
            preparedStatement.setInt(12, paymentHistoryVO.getFinalCharge());
            preparedStatement.setBoolean(13, paymentHistoryVO.isPaid());

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
