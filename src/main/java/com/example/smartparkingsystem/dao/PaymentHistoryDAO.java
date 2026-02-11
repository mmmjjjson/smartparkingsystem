package com.example.smartparkingsystem.dao;

import com.example.smartparkingsystem.vo.ParkingHistoryVO;
import com.example.smartparkingsystem.vo.PaymentHistoryVO;
import lombok.Cleanup;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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

    public List<ParkingHistoryVO> selectAllParkingHistory() {
        List<ParkingHistoryVO> parkingHistoryVOList = new ArrayList<>();
        String sql = "SELECT * from parking_history";

        try {
            @Cleanup Connection connection = ConnectionUtil.INSTANCE.getConnection();
            @Cleanup PreparedStatement preparedStatement = connection.prepareStatement(sql);
            @Cleanup ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                ParkingHistoryVO parkingHistoryVO = ParkingHistoryVO.builder()
                        .parkNo(resultSet.getLong("park_no"))
                        .parkingArea(resultSet.getString("parking_area"))
                        .carNum(resultSet.getString("car_num"))
                        .carType(resultSet.getString("car_type"))
                        .isMember(resultSet.getBoolean("is_member"))
                        .entryTime(resultSet.getObject("entry_time", LocalDateTime.class))
                        .exitTime(resultSet.getObject("exit_time", LocalDateTime.class))
                        .totalMinutes(resultSet.getInt("total_minutes"))
                        .build();
                parkingHistoryVOList.add(parkingHistoryVO);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return parkingHistoryVOList;
    }

    public void insertPaymentHistory() {
        String sql = "insert into payment_history values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            @Cleanup Connection connection = ConnectionUtil.INSTANCE.getConnection();
            @Cleanup PreparedStatement preparedStatement = connection.prepareStatement(sql);



        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
