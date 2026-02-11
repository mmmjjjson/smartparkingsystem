package com.example.smartparkingsystem.dao;

import com.example.smartparkingsystem.vo.PaymentHistoryVO;
import lombok.Cleanup;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;
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

    public List<PaymentHistoryVO> selectHistory() {
        List<PaymentHistoryVO> paymentHistoryVOList = new ArrayList<>();
        String sql = "select ";

        try {
            @Cleanup Connection connection = ConnectionUtil.INSTANCE.getConnection();
            @Cleanup PreparedStatement preparedStatement = connection.prepareStatement(sql);
            @Cleanup ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                PaymentHistoryVO paymentHistoryVO = PaymentHistoryVO.builder()
                        .payNo(resultSet.getLong("pay_no"))
                        .entryTime(resultSet.getObject("entry_time", LocalDateTime.class))
                        .exitTime(resultSet.getObject("exit_time", LocalDateTime.class))
                        .pno(resultSet.getLong(""))
                        .build();
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return paymentHistoryVOList;
    }

    public void insertPaymentHistory() {
        String sql = "insert into payment_history () values ()";

        try {
            @Cleanup Connection connection = ConnectionUtil.INSTANCE.getConnection();
            @Cleanup PreparedStatement preparedStatement = connection.prepareStatement(sql);


        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
