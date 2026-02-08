package com.example.smartparkingsystem.service;

import com.example.smartparkingsystem.dao.MembersDAO;
import com.example.smartparkingsystem.dto.MembersDTO;
import com.example.smartparkingsystem.util.MapperUtil;
import com.example.smartparkingsystem.vo.MembersVO;
import lombok.Lombok;
import lombok.extern.log4j.Log4j2;
import org.modelmapper.ModelMapper;

import java.util.List;

@Log4j2
public enum MembersService {
    INSTANCE;

    private final MembersDAO membersDAO;
    private final ModelMapper modelMapper;

    MembersService() {
        membersDAO = new MembersDAO();
        modelMapper = MapperUtil.INSTANCE.getInstance();
    }

    // 신규 회원 등록
    public void addMember(MembersDTO membersDTO) {
        MembersVO membersVO = modelMapper.map(membersDTO, MembersVO.class);
        log.info(membersVO);
        membersDAO.insertMember(membersVO);
    }

    // 회원 정보 수정
    public void modifyMember(MembersDTO membersDTO) {
        membersDAO.updateMember(modelMapper.map(membersDTO, MembersVO.class));
    }

    // 회원 삭제
    public void removeMember(Long mno) {
        membersDAO.deleteMember(mno);
    }

    // 회원 목록 조회
    public List<MembersDTO> getAllMembers() {
        List<MembersVO> membersVOList = membersDAO.selectAllMembers();

        List<MembersDTO> membersDTOList = membersVOList.stream()
                .map(membersVO -> modelMapper.map(membersVO, MembersDTO.class))
                .toList();

        return membersDTOList;
    }

    // 해당 회원 조회
    public  MembersDTO getOneMember(Long mno) {
        return modelMapper.map(membersDAO.selectOneMember(mno), MembersDTO.class);
    }
}
