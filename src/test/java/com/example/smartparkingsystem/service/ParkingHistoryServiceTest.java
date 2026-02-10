package com.example.smartparkingsystem.service;

import com.example.smartparkingsystem.dto.ParkingHistoryDTO;
import lombok.extern.log4j.Log4j2;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

@Log4j2
class ParkingHistoryServiceTest {
    private ParkingHistoryService parkingHistoryService;

    @BeforeEach
    public void ready() {
        parkingHistoryService = ParkingHistoryService.INSTANCE;
    }

    @Test
    public void registerEntryTest() {
        ParkingHistoryDTO parkingHistoryDTO = ParkingHistoryDTO.builder()
                .parkingArea("A-11")
                .carNum("99하4433")
                .carType("장애인").build();
        parkingHistoryService.registerEntry(parkingHistoryDTO);
    }

    @Test
    public void getParkingHistory() {
        long parkNo = 1;
        log.info(parkingHistoryService.getParkingHistory(parkNo));
    }

    @Test
    void changeIsMemberState() {
        long parkNo = 20;
        ParkingHistoryDTO parkingHistoryDTO = parkingHistoryService.getParkingHistory(parkNo);
        parkingHistoryService.changeIsMemberState(parkingHistoryDTO);
    }

    @Test
    public void registerExitTest() {
        long parkNo = 2;
        parkingHistoryService.registerExit(parkingHistoryService.getParkingHistory(parkNo));
        log.info(parkingHistoryService.getParkingHistory(parkNo));
    }
}