package com.example.smartparkingsystem.service;

import com.example.smartparkingsystem.dao.MembersDAO;
import com.example.smartparkingsystem.dto.MembersDTO;
import com.example.smartparkingsystem.dto.PageRequestDTO;
import com.example.smartparkingsystem.dto.PageResponseDTO;
import com.example.smartparkingsystem.util.MapperUtil;
import com.example.smartparkingsystem.vo.MembersVO;
import lombok.Lombok;
import lombok.extern.log4j.Log4j2;
import org.modelmapper.ModelMapper;

import java.util.ArrayList;
import java.util.List;

@Log4j2
public enum MembersService {
    INSTANCE;

    private final MembersDAO membersDAO;
    private final ModelMapper modelMapper;
    private final int pagePerCount = 10;

    MembersService() {
        membersDAO = new MembersDAO();
        modelMapper = MapperUtil.INSTANCE.getInstance();
    }

    // 회원 목록 페이징
    public PageResponseDTO getMemberList(PageRequestDTO pageRequestDTO) {
        int limit = pagePerCount;

        int count = membersDAO.selectMemberCount(pageRequestDTO.getSearchType(), pageRequestDTO.getKeyword(), pageRequestDTO.getStatus());
        List<MembersVO> membersVOList = membersDAO.selectMembers(pageRequestDTO.getPageNum(), limit, pageRequestDTO.getSearchType(), pageRequestDTO.getKeyword(), pageRequestDTO.getStatus());

        List<MembersDTO> membersDTOList = membersVOList.stream().map(membersVO -> modelMapper.map(membersVO, MembersDTO.class)).toList();
        
        int totalPage;
        
        if (count % limit == 0) {
            totalPage = count / limit;
        } else {
            totalPage = count / limit + 1;
        }
        
        return PageResponseDTO.builder()
                .membersDTOList(membersDTOList)
                .pageNum(pageRequestDTO.getPageNum())
                .totalCount(count)
                .totalPage(totalPage)
                .build();
    }


    // 신규 회원 등록
    public void addMember(MembersDTO membersDTO) {
        MembersVO membersVO = modelMapper.map(membersDTO, MembersVO.class);
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

    // 회원 검색 조회
    public List<MembersDTO> getMembers(int pageNum, int limit, String searchType, String keyword, String status) {
        List<MembersVO> membersVOList = membersDAO.selectMembers(pageNum, limit, searchType, keyword, status);

        List<MembersDTO> membersDTOList = membersVOList.stream()
                .map(membersVO -> modelMapper.map(membersVO, MembersDTO.class))
                .toList();

        return membersDTOList;
    }
}
