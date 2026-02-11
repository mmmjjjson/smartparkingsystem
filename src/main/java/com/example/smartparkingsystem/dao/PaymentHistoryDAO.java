package com.example.smartparkingsystem.dao;

import com.example.smartparkingsystem.vo.MembersVO;
import com.example.smartparkingsystem.vo.ParkingHistoryVO;
import com.example.smartparkingsystem.vo.PaymentHistoryVO;
import com.example.smartparkingsystem.vo.PaymentInfoVO;
import lombok.Cleanup;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class PaymentHistoryDAO {
    private static PaymentHistoryDAO instance;

    private PaymentHistoryDAO() {}

    public static PaymentHistoryDAO getInstance() {
        if (instance == null) {
            instance = new PaymentHistoryDAO();
        }
        return instance;
    }

    public void insertPaymentHistory(PaymentHistoryVO paymentHistoryVO) {
        String sql = "insert into payment_history values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now())";

        try {
            @Cleanup Connection connection = ConnectionUtil.INSTANCE.getConnection();
            @Cleanup PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setLong(1, paymentHistoryVO.getParkNo());
            preparedStatement.setString(2, paymentHistoryVO.getParkingArea());
            preparedStatement.setString(3, paymentHistoryVO.getCarNum());
            preparedStatement.setObject(4, paymentHistoryVO.getEntryTime());
            preparedStatement.setObject(5, paymentHistoryVO.getExitTime());
            preparedStatement.setLong(6, paymentHistoryVO.getTotalMinutes());
            preparedStatement.setInt(7, paymentHistoryVO.getTotalCharge());
            preparedStatement.setLong(8, paymentHistoryVO.getMno());
            preparedStatement.setLong(9, paymentHistoryVO.getPno());
            preparedStatement.setLong(10, paymentHistoryVO.getParkNo());
            preparedStatement.setInt(11, paymentHistoryVO.getDiscountAmount());
            preparedStatement.setInt(12, paymentHistoryVO.getFinalCharge());
            preparedStatement.setBoolean(13, paymentHistoryVO.isPaid());
            preparedStatement.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
