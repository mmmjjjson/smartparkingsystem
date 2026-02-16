package com.example.smartparkingsystem.dao;

import com.example.smartparkingsystem.vo.ParkingHistoryVO;
import lombok.extern.log4j.Log4j2;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

@Log4j2
class ParkingHistoryDAOTest {
    private ParkingHistoryDAO parkingHistoryDAO;

    @BeforeEach
    public void ready() {
        parkingHistoryDAO = new ParkingHistoryDAO();
    }

    @Test
    void insertEntryTest() {
        ParkingHistoryVO parkingHistoryVO = ParkingHistoryVO.builder()
                .parkingArea("A-7")
                .carNum("11가1190")
                .carType("일반").build();
        log.info(parkingHistoryVO);
        parkingHistoryDAO.insertEntry(parkingHistoryVO);
    }

    @Test
    void insertDummy() {
        for (int i = 1; i < 10; i++) {
            ParkingHistoryVO parkingHistoryVO = ParkingHistoryVO.builder()
                    .parkingArea("A-"+ i)
                    .carNum("11가100" + i)
                    .carType("일반").build();
            parkingHistoryDAO.insertEntry(parkingHistoryVO);
        }
        for (int i = 1; i < 10; i++) {
            ParkingHistoryVO parkingHistoryVO = ParkingHistoryVO.builder()
                    .parkingArea("A-"+ i)
                    .carNum("22가200" + i)
                    .carType("장애인").build();
            parkingHistoryDAO.insertEntry(parkingHistoryVO);
        }
        for (int i = 1; i < 10; i++) {
            ParkingHistoryVO parkingHistoryVO = ParkingHistoryVO.builder()
                    .parkingArea("A-"+ i)
                    .carNum("33가300" + i)
                    .carType("경차").build();
            parkingHistoryDAO.insertEntry(parkingHistoryVO);
        }
    }

    @Test
    void updateIsMember() {
        long park_no = 3;
        ParkingHistoryVO updateVO = parkingHistoryDAO.selectParkingHistory(park_no);
        parkingHistoryDAO.updateIsMember(updateVO);

        park_no = 5;
        ParkingHistoryVO nonUpdateVO = parkingHistoryDAO.selectParkingHistory(park_no);
        parkingHistoryDAO.updateIsMember(nonUpdateVO);
    }

    @Test
    void selectOccupiedTest() {
        for (ParkingHistoryVO vo : parkingHistoryDAO.selectOccupied()) {
            log.info(vo);
        }
    }

    @Test
    void selectParkingHistoryTest() {
        long parkNo = 1;
        log.info(parkingHistoryDAO.selectParkingHistory(parkNo));
    }

    @Test
    void selectRecentParkingTest() {
        String carNum = "11가1001";
        log.info(parkingHistoryDAO.selectRecentParking(carNum));
    }

    @Test
    void updateExitTest() {
        long parkNo = 1;
        ParkingHistoryVO parkingHistoryVO = parkingHistoryDAO.selectParkingHistory(parkNo);
        parkingHistoryDAO.updateExit(parkingHistoryVO);
    }
}