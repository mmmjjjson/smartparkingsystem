package com.example.smartparkingsystem.service;

import com.example.smartparkingsystem.dao.AdminDAO;
import com.example.smartparkingsystem.dto.AdminDTO;
import com.example.smartparkingsystem.util.MapperUtil;
import com.example.smartparkingsystem.vo.AdminVO;
import org.modelmapper.ModelMapper;

import java.util.ArrayList;
import java.util.List;

public enum AdminService {
    INSTANCE;

    private AdminDAO adminDAO;
    private ModelMapper modelMapper;

    AdminService() {
        adminDAO = new AdminDAO();
        modelMapper = MapperUtil.INSTANCE.getInstance();
    }

    // 전체 조회
    public List<AdminDTO> getAdminAll() {
        List<AdminDTO> adminDTOList = new ArrayList<>();
        List<AdminVO> adminVOList = adminDAO.selectAllAdmin();

        for (AdminVO adminVO : adminVOList) {
            adminDTOList.add(modelMapper.map(adminVO, AdminDTO.class));
        }
        return adminDTOList;
    }

    // 아이디로 하나 조회
    public AdminDTO getAdminById(String adminId) {
        AdminVO adminVO = adminDAO.selectAdminById(adminId);
        if (adminVO == null) {
            return null;
        }
        return modelMapper.map(adminVO, AdminDTO.class);
    }

    // 로그인 인증 (활동여부 사용중 True, 사용중지 False)
    public boolean AuthenticateAdmin(String adminId, String password) {
        boolean isAuth = false;
        AdminDTO admin = getAdminById(adminId);
        if (admin != null && admin.getPassword().equals(password)) {
            isAuth = true;
        } return isAuth;
    }

    // 로그
    public void renewalLog(String adminId, String lastLoginIp) {
        adminDAO.updateLog(adminId, lastLoginIp);
    }

    // 비밀번호 변경
//    public void changePassword(String adminId, String password) {
//        adminDAO.updatePassword(password, adminId);
//    }

    // 계정 정보 수정
    public void modifyAdmin(AdminDTO adminDTO) {
        AdminVO adminVO = modelMapper.map(adminDTO, AdminVO.class);
        adminDAO.updateAdmin(adminVO);
    }

    // 계정 삭제
//    public void removeAdmin(String admin_id) {
//        adminDAO.deleteAdmin(admin_id);
//    }
}
