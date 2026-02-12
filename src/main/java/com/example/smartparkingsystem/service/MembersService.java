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
        int pageNum = pageRequestDTO.getPageNum();
        int limit = pagePerCount;

        String searchType = pageRequestDTO.getSearchType();
        String keyword = pageRequestDTO.getKeyword();
        String status = pageRequestDTO.getStatus();

        // 검색 여부 판단
        boolean isSearch = keyword != null && !keyword.isEmpty() && searchType != null && !searchType.isEmpty();

        List<MembersVO> membersVOList;

        if (isSearch) { // 검색 키워드가 있을 시 회원 + 만료 회원 전체 조회
            membersVOList = membersDAO.selectAllMembers();

            membersVOList = membersVOList.stream()
                    .filter(vo -> {
                        switch (searchType) {
                            case "carNum":
                                return vo.getCarNum().contains(keyword);
                            case "name":
                                return vo.getMemberName().contains(keyword);
                            case "phone":
                                return vo.getMemberPhone().contains(keyword);
                            default:
                                return false;
                        }
                    }).toList();
        } else { // 검색 키워드가 없을 시 회원 or 만료 회원 따로 조회
            if ("expired".equals(status)) {
                membersVOList = membersDAO.selectIsNotMembers();
            } else {
                membersVOList = membersDAO.selectIsMembers();
            }
        }

        int count = membersVOList.size();

        // 하나의 페이지에 출력할 데이터 자르기
        int fromIndex = (pageNum - 1) * limit; // 시작 인덱스 (하나의 페이지에 출력되는 첫 번째 인덱스)
        // Math.min(value1, value2): 두 값 중 더 작은 값을 반환
        int toIndex = Math.min(fromIndex + limit, count); // 마지막 인덱스 (조회할 데이터의 개수 + 1)

        if (fromIndex < count) {
            membersVOList = membersVOList.subList(fromIndex, toIndex);
        }

        List<MembersDTO> membersDTOList = membersVOList.stream().map(membersVO -> modelMapper.map(membersVO, MembersDTO.class)).toList();

        // 페이지 계산
        int totalPage;
        if (count % limit == 0) { // 전체 게시글 개수가 페이지 당 게시글 수로 나누어 떨어질 때
            totalPage = count / limit;
        } else { // 나누어 떨어지지 않을 때
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
//    public void removeMember(Long mno) {
//        membersDAO.deleteMember(mno);
//    }
}
