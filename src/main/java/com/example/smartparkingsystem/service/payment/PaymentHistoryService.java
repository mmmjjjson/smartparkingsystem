package com.example.smartparkingsystem.service.payment;

import com.example.smartparkingsystem.dao.member.MembersDAO;
import com.example.smartparkingsystem.dao.main.ParkingHistoryDAO;
import com.example.smartparkingsystem.dao.payment.PaymentHistoryDAO;
import com.example.smartparkingsystem.dao.setting.PaymentInfoDAO;
import com.example.smartparkingsystem.dto.payment.PaymentHistoryDTO;
import com.example.smartparkingsystem.service.statistic.StatisticService;
import com.example.smartparkingsystem.util.MapperUtil;
import com.example.smartparkingsystem.vo.member.MembersVO;
import com.example.smartparkingsystem.vo.main.ParkingHistoryVO;
import com.example.smartparkingsystem.vo.payment.PaymentHistoryVO;
import com.example.smartparkingsystem.vo.setting.PaymentInfoVO;
import lombok.extern.log4j.Log4j2;
import org.modelmapper.ModelMapper;

import java.time.Duration;
import java.time.LocalDateTime;

@Log4j2
public class PaymentHistoryService {
    private final PaymentHistoryDAO paymentHistoryDAO;
    private final ParkingHistoryDAO parkingHistoryDAO;
    private final MembersDAO membersDAO;
    private final PaymentInfoDAO paymentInfoDAO;
    private final PaymentInfoVO paymentInfoVO;
    private final ModelMapper modelMapper;
    private static PaymentHistoryService instance;

    private PaymentHistoryService() {
        paymentHistoryDAO = new PaymentHistoryDAO();
        parkingHistoryDAO = new ParkingHistoryDAO();
        membersDAO = new MembersDAO();
        paymentInfoDAO = new PaymentInfoDAO();
        modelMapper = MapperUtil.INSTANCE.getInstance();
        paymentInfoVO = paymentInfoDAO.selectInfo();
    }

    public static PaymentHistoryService getInstance() {
        if (instance == null) {
            instance = new PaymentHistoryService();
        }
        return instance;
    }

    private final LocalDateTime exitTime = LocalDateTime.now();

    public long getTotalMinutes(String carNum) {
        LocalDateTime entryTime = parkingHistoryDAO.selectRecentParking(carNum).getEntryTime();
        return Duration.between(entryTime, exitTime).toMinutes();
    }

    private int calculateTotalCharge(String carNum) {
        log.info("calculateTotalCharge");
        int freeTime = paymentInfoVO.getFreeTime();
        int basicCharge = paymentInfoVO.getBasicCharge();
        int basicTime = paymentInfoVO.getBasicTime();
        int extraTime = paymentInfoVO.getExtraTime();
        int extraCharge = paymentInfoVO.getExtraCharge();
        int maxCharge = paymentInfoVO.getMaxCharge();
        long totalMinutes = getTotalMinutes(carNum);
        int totalCharge;

        int dayCount = (int) totalMinutes / 1440;

        if (totalMinutes <= freeTime) {
            totalCharge = 0;
        } else if (totalMinutes <= basicTime) {
            totalCharge = basicCharge;
        } else {
            int restTimeCharge = ((int)(((totalMinutes % 1440) - basicTime) / extraTime) * extraCharge) + basicCharge;
            restTimeCharge = Math.min(restTimeCharge, maxCharge);
            totalCharge = dayCount > 0 ? restTimeCharge + (dayCount * maxCharge) : restTimeCharge;
        }

        return totalCharge;
    }

    private int calculateDiscountAmount(String carNum) {
        log.info("calculateDiscountAmount");
        int totalCharge = calculateTotalCharge(carNum);
        int discountAmount = 0;

        double smallCarDiscount = paymentInfoVO.getSmallCarDiscount();
        double disabledDiscount = paymentInfoVO.getDisabledDiscount();

        String carType = parkingHistoryDAO.selectRecentParking(carNum).getCarType();

        if (carType.equals("경차")) {
            discountAmount = (int) (totalCharge * smallCarDiscount);
        } else if (carType.equals("장애인")) {
            discountAmount = (int) (totalCharge * disabledDiscount);
        }

        return discountAmount;
    }

    public void calculateFinalCharge(String carNum) {
        if (parkingHistoryDAO.selectRecentParking(carNum).getCarNum() == null) {
            return;
        }
        log.info("calculateFinalCharge 시작 - carNum: " + carNum);

        ParkingHistoryVO recent = parkingHistoryDAO.selectRecentParking(carNum);
        log.info("selectRecentParking 결과: " + recent);

        if (recent == null || recent.getCarNum() == null) {
            log.info("차량 없음으로 return");
            return;
        }

        int totalCharge = calculateTotalCharge(carNum);
        int discountAmount = calculateDiscountAmount(carNum);
        long totalMinutes = getTotalMinutes(carNum);
        int finalCharge;

        if (membersDAO.selectOneMember(carNum) != null) {
            totalCharge = 0;
            discountAmount = 0;
            finalCharge = 0;
        }

        finalCharge = totalCharge - discountAmount;

        ParkingHistoryVO parkingHistoryVO = parkingHistoryDAO.selectRecentParking(carNum);
        MembersVO membersVO = membersDAO.selectOneMember(carNum);
        Long mno = membersVO == null ? null : membersVO.getMno();

        PaymentHistoryVO paymentHistoryVO = PaymentHistoryVO.builder()
                .parkingArea(parkingHistoryVO.getParkingArea())
                .carNum(carNum)
                .entryTime(parkingHistoryVO.getEntryTime())
                .exitTime(exitTime)
                .totalMinutes(totalMinutes)
                .totalCharge(totalCharge)
                .mno(mno)
                .pno(paymentInfoVO.getPno())
                .parkNo(parkingHistoryVO.getParkNo())
                .discountAmount(discountAmount)
                .finalCharge(finalCharge)
                .isPaid(true)
                .build();

        paymentHistoryDAO.insertPaymentHistory(paymentHistoryVO);
        log.info("insert 완료");

        // 결제 캐시 갱신 (입차 시간 기준 연/월)
        int entryYear = parkingHistoryVO.getEntryTime().getYear();
        int entryMonth = parkingHistoryVO.getEntryTime().getMonthValue();
        StatisticService.INSTANCE.onPaymentDataChanged(entryYear, entryMonth);

        PaymentHistoryVO check = paymentHistoryDAO.selectRecentPayment(carNum);
        log.info("selectRecentPayment 결과: " + check);
    }

    public PaymentHistoryDTO getRecentPayment(String carNum) {
        PaymentHistoryVO paymentHistoryVO = paymentHistoryDAO.selectRecentPayment(carNum);
        if (paymentHistoryVO == null) {
            return null;
        }
        return modelMapper.map(paymentHistoryVO, PaymentHistoryDTO.class);
    }
}