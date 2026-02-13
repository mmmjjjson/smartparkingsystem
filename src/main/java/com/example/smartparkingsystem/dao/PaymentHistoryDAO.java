package com.example.smartparkingsystem.dao;

import com.example.smartparkingsystem.dto.MonthlyData;
import com.example.smartparkingsystem.dto.ParkingHistoryDTO;
import com.example.smartparkingsystem.util.ConnectionUtil;
import com.example.smartparkingsystem.vo.PaymentHistoryVO;
import lombok.Cleanup;
import lombok.extern.slf4j.Slf4j;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.*;

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

    public PaymentHistoryVO selectRecentPayment(String carNum) {
        PaymentHistoryVO paymentHistoryVO = null;
        String sql = "SELECT * FROM payment_history WHERE car_num = ? AND exit_time IS NULL " +
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

    /* 년월필터링 */
    public Map<Integer, List<MonthlyData>> selectGroupedByYearMonth() {
        Map<Integer, List<MonthlyData>> result = new TreeMap<>(Collections.reverseOrder());

        String sql = "SELECT YEAR(entry_time) as year, " +
                "MONTH(entry_time) as month, " +
                "pay_no, parking_area, car_num, entry_time, exit_time, " +
                "total_minutes, final_charge, mno " +
                "FROM payment_history " +
                "WHERE is_paid = TRUE " +  //  결제 완료된 것만 (선택사항)
                "ORDER BY year DESC, month DESC";

        try {
            @Cleanup Connection connection = ConnectionUtil.INSTANCE.getConnection();
            @Cleanup PreparedStatement preparedStatement = connection.prepareStatement(sql);
            @Cleanup ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                int year = resultSet.getInt("year");
                int month = resultSet.getInt("month");

                // ParkingHistoryDTO 생성 및 매핑
                ParkingHistoryDTO record = new ParkingHistoryDTO();
                record.setParkNo(resultSet.getLong("pay_no"));
                record.setParkingArea(resultSet.getString("parking_area"));
                record.setCarNum(resultSet.getString("car_num"));
                record.setEntryTime(resultSet.getTimestamp("entry_time").toLocalDateTime());
                record.setExitTime(resultSet.getTimestamp("exit_time").toLocalDateTime());
                record.setTotalMinutes(resultSet.getInt("total_minutes"));
                record.setFinalCharge(resultSet.getInt("final_charge"));

                Long mno = resultSet.getLong("mno");
                record.setMember(resultSet.wasNull() ? false : true);
                record.setCarType(null);

                // 연도별로 그룹핑
                result.computeIfAbsent(year, k -> new ArrayList<>());

                // 해당 연도의 월 데이터 찾기 또는 생성
                List<MonthlyData> monthlyList = result.get(year);
                MonthlyData monthlyData = monthlyList.stream()
                        .filter(m -> m.getMonth() == month)
                        .findFirst()
                        .orElse(null);

                if (monthlyData == null) {
                    monthlyData = new MonthlyData();
                    monthlyData.setMonth(month);
                    monthlyData.setRecords(new ArrayList<>());
                    monthlyList.add(monthlyData);
                }

                monthlyData.getRecords().add(record);
            }

            // 각 연도의 월 데이터를 내림차순 정렬
            result.forEach((year, monthlyList) -> {
                monthlyList.sort((m1, m2) -> Integer.compare(m2.getMonth(), m1.getMonth()));
            });

            return result;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
