package com.example.smartparkingsystem.service.setting;

import com.example.smartparkingsystem.dao.setting.PaymentInfoDAO;

import com.example.smartparkingsystem.dto.setting.PaymentInfoDTO;
import com.example.smartparkingsystem.util.MapperUtil;
import com.example.smartparkingsystem.vo.setting.PaymentInfoVO;
import lombok.extern.log4j.Log4j2;
import org.modelmapper.ModelMapper;

import java.time.LocalDateTime;

@Log4j2
public class PaymentInfoService {
    private final PaymentInfoDAO paymentInfoDAO = new PaymentInfoDAO();
    private final ModelMapper modelMapper = MapperUtil.INSTANCE.getInstance();

    private static PaymentInfoService instance;

    private PaymentInfoService () {}

    public static PaymentInfoService getInstance() {
        if (instance == null) {
            instance = new PaymentInfoService();
        }
        return instance;
    }

    // setting 등록
    public void addInfo(PaymentInfoDTO paymentInfoDTO) {
        log.info(paymentInfoDTO);
        PaymentInfoVO paymentInfoVO = modelMapper.map(paymentInfoDTO, PaymentInfoVO.class);
        paymentInfoDAO.insertInfo(paymentInfoVO);
    }

    // setting 조회
    public PaymentInfoDTO getInfo() {
        return modelMapper.map(paymentInfoDAO.selectInfo(), PaymentInfoDTO.class);
    }

    // mainboard 요금 계산용 입차 시간 기준 정책 조회
    public PaymentInfoDTO getInfoByEntryTime(LocalDateTime entryTime) {
        return modelMapper.map(paymentInfoDAO.selectInfoByEntryTime(entryTime), PaymentInfoDTO.class);
    }
}
