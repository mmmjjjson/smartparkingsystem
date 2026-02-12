package com.example.smartparkingsystem.dao;

import com.example.smartparkingsystem.vo.MembersVO;
import com.example.smartparkingsystem.vo.ParkingHistoryVO;
import com.example.smartparkingsystem.vo.PaymentHistoryVO;
import com.example.smartparkingsystem.vo.PaymentInfoVO;
import lombok.Cleanup;
import lombok.extern.slf4j.Slf4j;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@Slf4j
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
        log.info("insertPaymentHistory: ");
        log.info(paymentHistoryVO.toString());
        String sql = "insert into payment_history (parking_area, car_num, entry_time, exit_time, total_minutes, " +
                "total_charge, mno, pno, park_no, discount_amount, " +
                "final_charge, is_paid, payment_time) values (?, ?, ?, ?, ?, " +
                "?, ?, ?, ?, ?, " +
                "?, ?, now())";

        try {
            @Cleanup Connection connection = ConnectionUtil.INSTANCE.getConnection();
            @Cleanup PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, paymentHistoryVO.getParkingArea());
            preparedStatement.setString(2, paymentHistoryVO.getCarNum());
            preparedStatement.setObject(3, paymentHistoryVO.getEntryTime());
            preparedStatement.setObject(4, paymentHistoryVO.getExitTime());
            preparedStatement.setLong(5, paymentHistoryVO.getTotalMinutes());
            preparedStatement.setInt(6, paymentHistoryVO.getTotalCharge());
            preparedStatement.setObject(7, paymentHistoryVO.getMno());
            preparedStatement.setLong(8, paymentHistoryVO.getPno());
            preparedStatement.setLong(9, paymentHistoryVO.getParkNo());
            preparedStatement.setInt(10, paymentHistoryVO.getDiscountAmount());
            preparedStatement.setInt(11, paymentHistoryVO.getFinalCharge());
            preparedStatement.setBoolean(12, paymentHistoryVO.isPaid());
            preparedStatement.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
