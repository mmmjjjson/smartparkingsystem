package com.example.smartparkingsystem.dao;

import lombok.extern.log4j.Log4j2;
import org.junit.jupiter.api.Test;

import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.*;

@Log4j2
class ConnectionUtilTest {
    @Test
    void getConnection() throws SQLException {
        log.info(ConnectionUtil.INSTANCE.getConnection());
    }
}