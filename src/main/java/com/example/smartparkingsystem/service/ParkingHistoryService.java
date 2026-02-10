package com.example.smartparkingsystem.service;

import com.example.smartparkingsystem.dao.ParkingHistoryDAO;
import com.example.smartparkingsystem.dto.ParkingHistoryDTO;
import com.example.smartparkingsystem.util.MapperUtil;
import com.example.smartparkingsystem.vo.ParkingHistoryVO;
import lombok.extern.log4j.Log4j2;
import org.modelmapper.ModelMapper;

@Log4j2
public enum ParkingHistoryService {
    INSTANCE;

    ParkingHistoryDAO parkingHistoryDAO;
    ModelMapper modelMapper;

    ParkingHistoryService() {
        parkingHistoryDAO = new ParkingHistoryDAO();
        modelMapper = MapperUtil.INSTANCE.getInstance();
    }

    /* 입차 등록 */
    public void registerEntry(ParkingHistoryDTO parkingHistoryDTO) {
        ParkingHistoryVO parkingHistoryVO = modelMapper.map(parkingHistoryDTO, ParkingHistoryVO.class);
        log.info(parkingHistoryVO);
        parkingHistoryDAO.insertEntry(parkingHistoryVO);
    }

    /* 기록 조회 */
    public ParkingHistoryDTO getParkingHistory(long parkNo) {
        return modelMapper.map(parkingHistoryDAO.selectParkingHistory(parkNo), ParkingHistoryDTO.class);
    }

    /* 주차 상태 변경 */

    /* 회원 여부 판단 */


    /* 출차 처리 */
    public void registerExit(ParkingHistoryDTO parkingHistoryDTO) {
        ParkingHistoryVO parkingHistoryVO = modelMapper.map(parkingHistoryDTO, ParkingHistoryVO.class);
        parkingHistoryDAO.updateExit(parkingHistoryVO);
    }

}
