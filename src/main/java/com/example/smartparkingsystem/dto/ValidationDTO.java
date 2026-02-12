package com.example.smartparkingsystem.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ValidationDTO {
//    private String no; // 인덱스
    private String adminId; // PK 관리자 아이디
    private String otpCode; // OTP
    private String adminEmail; // OTP 보낸 관리자 이메일
    private LocalDateTime expiredTime; // OTP 만료시간 (유효시간 4분)
}
