package com.example.smartparkingsystem.service;

import com.example.smartparkingsystem.dto.MembersDTO;
import com.example.smartparkingsystem.dto.PageRequestDTO;
import lombok.extern.log4j.Log4j2;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@Log4j2
class MembersServiceTest {
    private final MembersService membersService = MembersService.INSTANCE;

    @Test
    public void getMembers() {
        String searchType = "name";
        String keyword = "2";
        List<MembersDTO> membersDTOList = membersService.getMembers(2, 10, searchType, keyword, null);
        log.info(membersDTOList);
    }

    @Test
    public void getMemberList() {
        PageRequestDTO pageRequestDTO = PageRequestDTO.builder()
                .pageNum(1)
                .searchType("name")
                .keyword("2")
                .status("")
                .build();
        var memberList = membersService.getMemberList(pageRequestDTO);
        log.info(memberList);
    }

}