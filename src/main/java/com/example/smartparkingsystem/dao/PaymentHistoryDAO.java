package com.example.smartparkingsystem.dao;

import com.example.smartparkingsystem.dto.ParkingHistoryDTO;
import com.example.smartparkingsystem.dto.MonthlyData;
import com.example.smartparkingsystem.util.ConnectionUtil;
import lombok.Cleanup;
import lombok.extern.log4j.Log4j2;

import java.sql.*;
import java.util.*;

@Log4j2
public class PaymentHistoryDAO {

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
