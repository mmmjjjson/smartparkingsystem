package com.example.smartparkingsystem.dao;

import com.example.smartparkingsystem.dto.ParkingHistoryDTO;
import com.example.smartparkingsystem.vo.ParkingHistoryVO;
import lombok.extern.log4j.Log4j2;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@Log4j2
class ParkingHistoryDAOTest {
    ParkingHistoryDAO parkingHistoryDAO;
    @BeforeEach
    void setUp() {
        parkingHistoryDAO = new ParkingHistoryDAO();
    }

    @Test
    void selectByDate() {
        parkingHistoryDAO = new ParkingHistoryDAO();
        for (ParkingHistoryVO parkingHistoryVO : parkingHistoryDAO.selectByDate(LocalDate.now())){
            log.info(parkingHistoryVO);
        }
    }

}