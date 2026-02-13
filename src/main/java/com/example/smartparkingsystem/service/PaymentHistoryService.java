package com.example.smartparkingsystem.service;

import com.example.smartparkingsystem.dao.MembersDAO;
import com.example.smartparkingsystem.dao.PaymentHistoryDAO;
import com.example.smartparkingsystem.dao.PaymentInfoDAO;
import com.example.smartparkingsystem.dto.PaymentHistoryDTO;
import com.example.smartparkingsystem.util.MapperUtil;
import com.example.smartparkingsystem.vo.MembersVO;
import com.example.smartparkingsystem.vo.PaymentHistoryVO;
import com.example.smartparkingsystem.vo.PaymentInfoVO;
import lombok.extern.log4j.Log4j2;
import org.modelmapper.ModelMapper;

import java.time.Duration;
import java.time.LocalDateTime;

@Log4j2
public class PaymentHistoryService {
    // 객체 선언
    private final PaymentHistoryDAO paymentHistoryDAO;
    private final ParkingHistoryDAO parkingHistoryDAO;
    private final MembersDAO membersDAO;
    private final PaymentInfoDAO paymentInfoDAO;
    private final PaymentInfoVO paymentInfoVO;
    private final ModelMapper modelMapper;
    private static PaymentHistoryService instance;

    private PaymentHistoryService() {
        paymentHistoryDAO = PaymentHistoryDAO.getInstance();
        parkingHistoryDAO = new ParkingHistoryDAO();
        membersDAO = new  MembersDAO();
        paymentInfoDAO = PaymentInfoDAO.getInstance();
        modelMapper = MapperUtil.INSTANCE.getInstance();
        paymentInfoVO = paymentInfoDAO.selectInfo();
    }

    public static PaymentHistoryService getInstance() {
        if(instance == null) {
            instance = new PaymentHistoryService();
        }
        return instance;
    }

    // 변수 선언
    LocalDateTime exitTime; // 출차 시간
    long totalMinutes; // 총 시간(분)
    int totalCharge; // 총 요금
    int discountAmount; // 할인 금액
    int finalCharge; // 최종 결제 요금

    public void calculateFinalCharge(String carNum) { // PaymentHistoryVO에 넣는 메서드
        // 잘못된 차량번호 조회?
        if (parkingHistoryDAO.selectRecentParking(carNum).getCarNum() == null) {
            return;
        }

        // 총 요금에서 할인 계산 메서드 실행
        calculateDiscountAmount(carNum);

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
    }

    private void calculateDiscountAmount(String carNum) { // 할인 금액 계산(discount_amount), 멤버인지 확인 후 멤버면 0원
        log.info("calculateDiscountAmount");

        // 총 요금 계산 메서드 실행
        calculateTotalCharge(carNum);

        // 멤버인지 아닌지 확인 후 멤버면 총 요금 0원
        if (membersDAO.selectOneMember(carNum) != null) {
            totalCharge = 0;
            discountAmount = 0;
            finalCharge = 0;
            return;
        }

        // 정책
        double smallCarDiscount = paymentInfoVO.getSmallCarDiscount();
        log.info(smallCarDiscount);
        double disabledDiscount = paymentInfoVO.getDisabledDiscount();

        // 자동차 타입 확인(일반, 경차, 장애인)
        String carType = parkingHistoryDAO.selectRecentParking(carNum).getCarType();

        // 타입 별 할인 금액
        if (carType.equals("경차")) {
            discountAmount = (int) (totalCharge * smallCarDiscount);
        } else if (carType.equals("장애인")) {
            discountAmount = (int) (totalCharge * disabledDiscount);
        }

        // 최종 결제 금액
        finalCharge = totalCharge - discountAmount;
    }

    private void calculateTotalCharge(String carNum) {
        log.info("calculateTotalCharge");
        // 총 요금 (total_charge)
        // 정책
        int freeTime = paymentInfoVO.getFreeTime(); // 무료 회차 시간
        int basicCharge = paymentInfoVO.getBasicCharge(); // 기본 요금
        int basicTime = paymentInfoVO.getBasicTime(); // 기본 요금 시간(분)
        int extraTime = paymentInfoVO.getExtraTime(); // 초과 시간(분)
        int extraCharge = paymentInfoVO.getExtraCharge(); // 초과 시간 당 추가 요금
        int maxCharge = paymentInfoVO.getMaxCharge(); // 일일 최대 요금

        LocalDateTime entyTime = parkingHistoryDAO.selectRecentParking(carNum).getEntryTime(); // 입차 시간
        exitTime = LocalDateTime.now(); // 출차 시간 (정산 시간 -> 현 시간)

        // 입차 시간 - 출차 시간
        totalMinutes = Duration.between(entyTime, exitTime).toMinutes();

        // 주차일수
        int dayCount = (int) totalMinutes / 1440;

        if (totalMinutes <= freeTime) {
            totalCharge = 0; // 무료 회차시간 적용 요금
        } else if (totalMinutes <= basicTime) {
            totalCharge = basicCharge;
        } else {
            // 24시간 이하 요금 & 24시간 초과시 (24시간 제외 후) 남은 시간에 대한 요금
            int restTimeCharge = ((int)(((totalMinutes % 1440) - basicTime) / extraTime) * extraCharge) + basicCharge;
            // 일일 최대 요금 초과시 일일 최대 요금으로 변경
            restTimeCharge = Math.min(restTimeCharge, maxCharge);

            // 24시간 넘는 경우 총 요금
            totalCharge = dayCount > 0 ? restTimeCharge + (dayCount * maxCharge) : restTimeCharge;
        }
    }

    public PaymentHistoryDTO getRecentPayment(String carNum) {
        PaymentHistoryVO paymentHistoryVO = paymentHistoryDAO.selectRecentPayment(carNum);
        if (paymentHistoryVO == null) {
            return null;
        }
        return modelMapper.map(paymentHistoryVO, PaymentHistoryDTO.class);
    }
}
