package com.example.smartparkingsystem.dto;

import lombok.*;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminDTO {
    private String admin_id; // 관리자 아이디
    private String password; // 관리자 비밀번호
    private String birth; // 생년월일
    private String adminName; // 관리자 이름
    private String adminEmail; // 관리자 이메일
    private boolean is_active; // 활동 여부 (계정활동 허용, 비허용)
    private LocalDateTime last_login; // 마지막 로그인 날짜
    private String last_login_ip; // 마지막 로그인 아이피
//    private LocalDateTime created_at; // 계정 생성일(사용하지 않아서 주석 없애는게 좋을지도?)
}
