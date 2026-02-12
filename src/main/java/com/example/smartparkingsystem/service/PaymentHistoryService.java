package com.example.smartparkingsystem.service;

import com.example.smartparkingsystem.dao.MembersDAO;
import com.example.smartparkingsystem.dao.ParkingHistoryDAO;
import com.example.smartparkingsystem.dao.PaymentHistoryDAO;
import com.example.smartparkingsystem.dao.PaymentInfoDAO;
import com.example.smartparkingsystem.dto.PaymentHistoryDTO;
import com.example.smartparkingsystem.util.MapperUtil;
import com.example.smartparkingsystem.vo.MembersVO;
import com.example.smartparkingsystem.vo.ParkingHistoryVO;
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

    public PaymentHistoryDTO calculateFinalCharge(String carNum) { // PaymentHistoryDTO에 넣는 메서드
        // 총 요금에서 할인된 요금 계산 메서드 실행
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
                .mno(mno) // null 이면 ?
                .pno(paymentInfoVO.getPno())
                .parkNo(parkingHistoryVO.getParkNo())
                .discountAmount(discountAmount)
                .finalCharge(finalCharge)
                .isPaid(true)
                .build();
        paymentHistoryDAO.insertPaymentHistory(paymentHistoryVO);

        return null;
    }

    private void calculateDiscountAmount(String carNum) {
        log.info("calculateDiscountAmount");

        // 총 요금 계산 메서드 실행
        calculateTotalCharge(carNum);

        // 할인 금액 계산(discount_amount), 멤버인지 확인 후 멤버면 0원
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
            return;
        } else if (carType.equals("장애인")) {
            discountAmount = (int) (totalCharge * disabledDiscount);
            return;
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
        int extraTime = paymentInfoVO.getBasicCharge(); // 초과 시간(분)
        int extraCharge = paymentInfoVO.getExtraCharge(); // 초과 시간 당 추가 요금
        int maxCharge = paymentInfoVO.getMaxCharge(); // 일일 최대 요금

        LocalDateTime entyTime = parkingHistoryDAO.selectRecentParking(carNum).getEntryTime(); // 입차 시간
        exitTime = LocalDateTime.now(); // 출차 시간 (정산 시간 -> 현 시간)
        log.info(entyTime);

        // 입차 시간 - 출차 시간
        totalMinutes = Duration.between(entyTime, exitTime).toMinutes();

        // 주차일수
        int dayCount = (int) totalMinutes / 1440;

        if (totalMinutes <= freeTime) {
            totalCharge = 0; // 무료 회차시간 적용 요금
        } else {
            // 24시간 이하 요금 & 24시간 초과시 (24시간 제외 후) 남은 시간에 대한 요금
            int restTimeCharge = ((((int) (totalMinutes % 1440) - basicTime) / extraTime) * extraCharge) + basicCharge;
            // 일일 최대 요금 초과시 일일 최대 요금으로 변경
            restTimeCharge = Math.min(restTimeCharge, maxCharge);

            // 24시간 넘는 경우 총 요금
            totalCharge = dayCount > 0 ? restTimeCharge + (dayCount * maxCharge) : restTimeCharge;
        }
    }

















//    public PaymentHistoryDTO calculateParkingCharge(String carNum) {
//        PaymentInfoVO paymentInfoVO = paymentInfoDAO.selectInfo();
//        log.info("paymentInfoVO: " + paymentInfoVO);
//
//        // 1. 정책 설정
//        int freeTime = paymentInfoVO.getFreeTime();
//        int basicTime = paymentInfoVO.getBasicTime();
//        int extraTime = paymentInfoVO.getBasicCharge();
//        int extraCharge = paymentInfoVO.getExtraCharge();
//        double smallCarDiscount = paymentInfoVO.getSmallCarDiscount();
//        double disabledDiscount = paymentInfoVO.getDisabledDiscount();
//        int maxCharge = paymentInfoVO.getMaxCharge();
//        int basicCharge = paymentInfoVO.getBasicCharge();
//        int finalCharge = 0;
//        String carType = parkingHistoryDAO.selectRecentParking(carNum).getCarType();
//
//        LocalDateTime inDate = parkingHistoryDAO.selectRecentParking(carNum).getEntryTime();
//        LocalDateTime outDate = LocalDateTime.now();
//
//        // 2. 날짜 차이 계산 (당일 0, 다음날 1...)
//        long diffDays = ChronoUnit.DAYS.between(inDate.toLocalDate(), outDate.toLocalDate());
//
//        int preTotal = 0;
//
//        // 3. 상황별 요금 계산
//        log.info("diffDays: " + diffDays);
//        if (diffDays == 0) {
//            // [주차 기간이 하루 이내]
//            long diffMins = Duration.between(inDate, outDate).toMinutes();
//
//            // 요금 계산 로직 (내부 로직 직접 구현)
//            int fee = 0;
//            if (diffMins > freeTime) {
//                fee = basicCharge;
//                if (diffMins > basicTime) {
//                    fee += Math.ceil((double) (diffMins - basicTime) / extraTime) * extraCharge;
//                }
//            }
//            preTotal = Math.min(fee, maxCharge);
//
//        } else {
//            // [자정 넘긴 장기 주차]
//
//            // 1) 첫날 요금 (입차 시각부터 당일 자정까지)
//            long day1Time = 1440 - (inDate.getHour() * 60 + inDate.getMinute());
//            double day1Fee = 0;
//            if (day1Time > freeTime) {
//                day1Fee = basicCharge;
//                if (day1Time > basicTime) {
//                    day1Fee += Math.ceil((double) (day1Time - basicTime) / extraTime) * extraCharge;
//                }
//            }
//            preTotal += Math.min(day1Fee, maxCharge);
//
//            // 2) 중간 요금 (풀로 주차한 일수)
//            if (diffDays > 1) {
//                preTotal += (diffDays - 1) * maxCharge;
//            }
//
//            // 3) 마지막날 요금 (자정부터 출차 시각까지)
//            long lastDayTime = outDate.getHour() * 60 + outDate.getMinute();
//            double lastDayFee = 0;
//            if (lastDayTime > freeTime) {
//                lastDayFee = basicCharge;
//                if (lastDayTime > basicTime) {
//                    lastDayFee += Math.ceil((double) (lastDayTime - basicTime) / extraTime) * extraCharge;
//                }
//            }
//            preTotal += Math.min(lastDayFee, maxCharge);
//        }
//
//        // 4. 영수증용 데이터 정리
//        int base = (preTotal == 0) ? 0 : basicCharge;
//        int extra = Math.max(0, preTotal - base);
//
//        // 5. 할인 적용
//        int discount = 0;
//        String discountName = "";
//
////        if ("월정액".equals(carType)) {
////            discount = preTotal;
////            discountName = "월정액 회원 할인 (100%)";
//        if ("장애인".equals(carType)) {
//            discount = (int) (preTotal * disabledDiscount);
//            discountName = "장애인 할인 (" + (int) (disabledDiscount * 100) + "%)";
//        } else if ("경차".equals(carType)) {
//            discount = (int) (preTotal * smallCarDiscount);
//            discountName = "경차 할인 (" + (int) (smallCarDiscount * 100) + "%)";
//        }
//
//        finalCharge = (int) (preTotal - discount);
//
//        if (membersDAO.selectOneMember(carNum) != null) {
//            preTotal = 0;
//            discount = 0;
//            finalCharge = 0;
//        }
//
//        // 6. 결과 출력 (또는 Map 반환)
//        Map<String, Object> result = new HashMap<>();
//        result.put("total", preTotal);
//        result.put("base", base);
//        result.put("extra", extra);
//        result.put("discount", discount);
//        result.put("finalCharge", finalCharge);
//        result.put("discountName", discountName);
//        result.put("duration", Duration.between(inDate, outDate).toMinutes());
//
//        PaymentHistoryDTO paymentHistoryDTO = PaymentHistoryDTO.builder()
//                .parkingArea(parkingHistoryDAO.selectRecentParking(carNum).getParkingArea())
//                .parkingArea(parkingHistoryDAO.selectRecentParking(carNum).getParkingArea())
//                .carNum(parkingHistoryDAO.selectRecentParking(carNum).getCarNum())
//                .entryTime(parkingHistoryDAO.selectRecentParking(carNum).getEntryTime())
//                .exitTime(parkingHistoryDAO.selectRecentParking(carNum).getExitTime())
//                .totalMinutes(parkingHistoryDAO.selectRecentParking(carNum).getTotalMinutes())
//                .totalCharge(preTotal)
//                .mno(membersDAO.selectOneMember(carNum).getMno())
//                .pno(paymentInfoDAO.selectInfo().getPno())
//                .parkNo(parkingHistoryDAO.selectRecentParking(carNum).getParkNo())
//                .discountAmount(discount)
//                .finalCharge((Integer) result.get("finalCharge"))
//                .isPaid(true)
//                .paymentTime(LocalDateTime.now())
//                .build();
//        log.info("paymentHistoryDTO" + paymentHistoryDTO);
//        return paymentHistoryDTO;
//    }
//
//    public void addPaymentHistory(PaymentHistoryDTO paymentHistoryDTO) {
//        log.info(paymentHistoryDTO);
//        PaymentHistoryVO paymentHistoryVO = modelMapper.map(paymentHistoryDTO, PaymentHistoryVO.class);
//        paymentHistoryDAO.insertPaymentHistory(paymentHistoryVO);
//    }
}
