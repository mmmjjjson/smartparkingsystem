package com.example.smartparkingsystem.service;


import com.example.smartparkingsystem.dao.ValidationDAO;
import com.example.smartparkingsystem.util.MapperUtil;
import org.modelmapper.ModelMapper;

public enum ValidationService {
    INSTANCE;

    private ValidationDAO validationDAO;
    private ModelMapper modelMapper;

    ValidationService() {
        validationDAO = new ValidationDAO();
        modelMapper = MapperUtil.INSTANCE.getInstance();
    }


}
