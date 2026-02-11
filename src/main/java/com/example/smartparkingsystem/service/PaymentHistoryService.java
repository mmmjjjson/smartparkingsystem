package com.example.smartparkingsystem.service;

import com.example.smartparkingsystem.dao.MembersDAO;
import com.example.smartparkingsystem.dao.ParkingHistoryDAO;
import com.example.smartparkingsystem.dao.PaymentHistoryDAO;
import com.example.smartparkingsystem.dao.PaymentInfoDAO;
import com.example.smartparkingsystem.dto.PaymentHistoryDTO;
import com.example.smartparkingsystem.dto.PaymentInfoDTO;
import com.example.smartparkingsystem.util.MapperUtil;
import com.example.smartparkingsystem.vo.PaymentHistoryVO;
import com.example.smartparkingsystem.vo.PaymentInfoVO;
import lombok.Data;
import lombok.extern.log4j.Log4j2;
import org.modelmapper.ModelMapper;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Date;

@Log4j2
public class PaymentHistoryService {
    private final PaymentHistoryDAO paymentHistoryDAO = PaymentHistoryDAO.getInstance();
    private ParkingHistoryDAO parkingHistoryDAO;
    private MembersDAO membersDAO;
    private PaymentInfoDAO paymentInfoDAO;
    private final ModelMapper modelMapper = MapperUtil.INSTANCE.getInstance();

    private static PaymentHistoryService instance;

    public PaymentHistoryService() {}

    public static PaymentHistoryService getInstance() {
        if(instance == null) {
            instance = new PaymentHistoryService();
        }
        return instance;
    }

    /*
    입출차 시간 계산

    LocalDateTime exitTime = parkingVO.getExitTime() != null ? parkingVO.getExitTime() : LocalDateTime.now();
    long totalMinutes = java.time.Duration.between(parkingVO.getEntryTime(), exitTime).toMinutes();
    log.info("totalMinutes: " + totalMinutes);
     */

    public void addPaymentHistory(PaymentHistoryDTO paymentHistoryDTO) {
        log.info(paymentHistoryDTO);
        PaymentHistoryVO paymentHistoryVO = modelMapper.map(paymentHistoryDTO, PaymentHistoryVO.class);
        paymentHistoryDAO.insertPaymentHistory(paymentHistoryVO);
    }

    public int calculateTotalCharge(String carNum) {
        PaymentInfoVO paymentInfoVO = paymentInfoDAO.selectInfo();
        LocalDateTime getEntyTime = parkingHistoryDAO.selectRecentParking(carNum).getEntryTime();
        LocalDateTime getExitTime = LocalDateTime.now();
        Duration duration = Duration.between(getEntyTime, getExitTime);
        long totalMinutes = duration.toMinutes(); // 총 시간 (분 단위)

        int basicCharge = paymentInfoVO.getBasicCharge();
        int extraCharge = paymentInfoVO.getExtraCharge();
        int totalCharge = 0;

        int diffDays = (int) totalMinutes / 86400000;

        if (diffDays == 0) {
            int diffMis =
        }
    }

}
