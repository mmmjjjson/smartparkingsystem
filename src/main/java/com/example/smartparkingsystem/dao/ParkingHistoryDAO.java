package com.example.smartparkingsystem.dao;

import com.example.smartparkingsystem.util.ConnectionUtil;
import com.example.smartparkingsystem.vo.ParkingHistoryVO;
import lombok.Cleanup;
import lombok.extern.log4j.Log4j2;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Duration;
import java.time.LocalDateTime;

@Log4j2
public class ParkingHistoryDAO {
    /* 입차 등록 */
    public void insertEntry(ParkingHistoryVO parkingHistoryVO) {
        String sql = "INSERT INTO parking_history (parking_area, car_num, car_type, entry_time) " +
                "VALUES (?, ?, ?, now())";

        try {
            @Cleanup Connection connection = ConnectionUtil.INSTANCE.getConnection();
            @Cleanup PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, parkingHistoryVO.getParkingArea());
            preparedStatement.setString(2, parkingHistoryVO.getCarNum());
            preparedStatement.setString(3, parkingHistoryVO.getCarType());
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public ParkingHistoryVO selectParkingHistory(long parkNo) {
        ParkingHistoryVO parkingHistoryVO = null;
        String sql = "SELECT * FROM parking_history WHERE park_no = ?";

        try {
            @Cleanup Connection connection = ConnectionUtil.INSTANCE.getConnection();
            @Cleanup PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setLong(1, parkNo);
            @Cleanup ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                parkingHistoryVO = ParkingHistoryVO.builder()
                        .parkNo(resultSet.getLong("park_no"))
                        .parkingArea(resultSet.getString("parking_area"))
                        .carNum(resultSet.getString("car_num"))
                        .carType(resultSet.getString("car_type"))
                        .entryTime(resultSet.getObject("entry_time", LocalDateTime.class))
                        .exitTime(resultSet.getObject("exit_time", LocalDateTime.class))
                        .totalMinutes(resultSet.getInt("total_minutes"))
                        .build();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return parkingHistoryVO;
    }

    /* 출차 등록 */
    public void updateExit(ParkingHistoryVO parkingHistoryVO) {
        ParkingHistoryVO dbVO = selectParkingHistory(parkingHistoryVO.getParkNo());
        if (dbVO == null || dbVO.getEntryTime() == null) {
            throw new IllegalStateException("입차 기록 없음");
        }

        String sql = "UPDATE parking_history SET exit_time = now(), total_minutes = ? WHERE park_no = ?";
        LocalDateTime now = LocalDateTime.now();
        int totalMinutes = (int) Duration.between(parkingHistoryVO.getEntryTime(), now).toMinutes();

        try {
            @Cleanup Connection connection = ConnectionUtil.INSTANCE.getConnection();
            @Cleanup PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, totalMinutes);
            preparedStatement.setLong(2, parkingHistoryVO.getParkNo());
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
