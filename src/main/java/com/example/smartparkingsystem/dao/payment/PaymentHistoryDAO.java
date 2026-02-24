package com.example.smartparkingsystem.dao.payment;

import com.example.smartparkingsystem.util.ConnectionUtil;
import com.example.smartparkingsystem.vo.payment.PaymentHistoryVO;
import lombok.Cleanup;
import lombok.extern.log4j.Log4j2;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.*;

@Log4j2
public class PaymentHistoryDAO {

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

    public PaymentHistoryVO selectRecentPayment(String carNum) {
        PaymentHistoryVO paymentHistoryVO = null;
        String sql = "SELECT * FROM payment_history WHERE car_num = ?" +
                "ORDER BY entry_time DESC LIMIT 1";

        try {
            @Cleanup Connection connection = ConnectionUtil.INSTANCE.getConnection();
            @Cleanup PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, carNum);
            @Cleanup ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                paymentHistoryVO = PaymentHistoryVO.builder()
                        .payNo(resultSet.getLong("pay_no"))
                        .parkingArea(resultSet.getString("parking_area"))
                        .carNum(resultSet.getString("car_num"))
                        .entryTime(resultSet.getObject("entry_time", LocalDateTime.class))
                        .exitTime(resultSet.getObject("exit_time", LocalDateTime.class))
                        .totalMinutes(resultSet.getInt("total_minutes"))
                        .totalCharge(resultSet.getInt("total_charge"))
                        .mno(resultSet.getLong("mno"))
                        .pno(resultSet.getLong("pno"))
                        .parkNo(resultSet.getLong("park_no"))
                        .discountAmount(resultSet.getInt("discount_amount"))
                        .finalCharge(resultSet.getInt("final_charge"))
                        .isPaid(resultSet.getBoolean("is_paid"))
                        .paymentTime(resultSet.getObject("payment_time", LocalDateTime.class))
                        .build();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return paymentHistoryVO;
    }

    /*
     * 통계용 결제 데이터 전체 조회 (초기 캐시 로드용)
     */
    public Map<Integer, Map<Integer, List<PaymentHistoryVO>>> selectOrderByYearMonth() {
        Map<Integer, Map<Integer, List<PaymentHistoryVO>>> result = new TreeMap<>(Collections.reverseOrder());

        String sql = "SELECT YEAR(entry_time) as year, " +
                "MONTH(entry_time) as month, " +
                "pay_no, parking_area, car_num, entry_time, exit_time, " +
                "total_minutes, final_charge, mno " +
                "FROM payment_history " +
                "WHERE is_paid = TRUE " +
                "ORDER BY year DESC, month DESC";

        try {
            @Cleanup Connection connection = ConnectionUtil.INSTANCE.getConnection();
            @Cleanup PreparedStatement preparedStatement = connection.prepareStatement(sql);
            @Cleanup ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                int year = resultSet.getInt("year");
                int month = resultSet.getInt("month");

                PaymentHistoryVO vo = PaymentHistoryVO.builder()
                        .payNo(resultSet.getLong("pay_no"))
                        .parkingArea(resultSet.getString("parking_area"))
                        .carNum(resultSet.getString("car_num"))
                        .entryTime(resultSet.getTimestamp("entry_time").toLocalDateTime())
                        .exitTime(resultSet.getTimestamp("exit_time").toLocalDateTime())
                        .totalMinutes(resultSet.getInt("total_minutes"))
                        .finalCharge(resultSet.getInt("final_charge"))
                        .mno(resultSet.getObject("mno", Long.class))
                        .build();

                result.computeIfAbsent(year, k -> new TreeMap<>(Collections.reverseOrder()))
                        .computeIfAbsent(month, k -> new ArrayList<>())
                        .add(vo);
            }
            return result;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    /*
     * 통계용 특정 연월 결제 데이터 조회 (이벤트 기반 부분 캐시 갱신용)
     */
    public List<PaymentHistoryVO> selectByYearMonth(int year, int month) {
        List<PaymentHistoryVO> result = new ArrayList<>();

        String sql = "SELECT pay_no, parking_area, car_num, entry_time, exit_time, " +
                "total_minutes, final_charge, mno " +
                "FROM payment_history " +
                "WHERE is_paid = TRUE " +
                "AND YEAR(entry_time) = ? AND MONTH(entry_time) = ? " +
                "ORDER BY entry_time DESC";

        try {
            @Cleanup Connection connection = ConnectionUtil.INSTANCE.getConnection();
            @Cleanup PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, year);
            preparedStatement.setInt(2, month);
            @Cleanup ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                result.add(PaymentHistoryVO.builder()
                        .payNo(resultSet.getLong("pay_no"))
                        .parkingArea(resultSet.getString("parking_area"))
                        .carNum(resultSet.getString("car_num"))
                        .entryTime(resultSet.getTimestamp("entry_time").toLocalDateTime())
                        .exitTime(resultSet.getTimestamp("exit_time").toLocalDateTime())
                        .totalMinutes(resultSet.getInt("total_minutes"))
                        .finalCharge(resultSet.getInt("final_charge"))
                        .mno(resultSet.getObject("mno", Long.class))
                        .build());
            }
            return result;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}