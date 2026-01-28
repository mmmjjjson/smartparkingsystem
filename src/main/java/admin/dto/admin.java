package admin.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class admin {
    private String adminId; // 관리자 id
    private String password; // 관리자 비밀번호
    private String adminName; // 관리자 이름
    private String birth; // 관리자 생년월일 6자리
    private String adminPhone; // 관리자 연락처
}

