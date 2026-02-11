package com.example.smartparkingsystem.service;

import com.example.smartparkingsystem.dao.MembersDAO;
import com.example.smartparkingsystem.dao.ParkingHistoryDAO;
import com.example.smartparkingsystem.dao.PaymentHistoryDAO;
import com.example.smartparkingsystem.util.MapperUtil;
import lombok.extern.log4j.Log4j2;
import org.modelmapper.ModelMapper;

@Log4j2
public class PaymentHistoryService {
    private final PaymentHistoryDAO paymentHistoryDAO = PaymentHistoryDAO.getInstance();
    private ParkingHistoryDAO parkingHistoryDAO;
    private MembersDAO membersDAO;
    private final ModelMapper modelMapper = MapperUtil.INSTANCE.getInstance();

    private static PaymentHistoryService instance;

    public PaymentHistoryService() {}

    public static PaymentHistoryService getInstance() {
        if(instance == null) {
            instance = new PaymentHistoryService();
        }
        return instance;
    }

    

}
