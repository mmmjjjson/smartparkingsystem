package com.example.smartparkingsystem.member.model;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class MembersDTO {
    private String carNum;              // 차량 번호
    private String memberName;          // 회원 이름
    private LocalDateTime startDate;    // 이용 시작일
    private LocalDateTime endDate;      // 이용 만료일
    private boolean isActive;           // 이용일 만료일 여부
    private LocalDateTime createdAt;    // 최초 등록일
    private LocalDateTime updatedDate;  // 업데이트일
    private String memberPhone;         // 회원 전화번호
}
