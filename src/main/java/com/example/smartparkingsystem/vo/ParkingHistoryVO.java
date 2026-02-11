package com.example.smartparkingsystem.vo;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Builder
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class ParkingHistoryVO {
    private long parkNo; // 주차 기록 인덱스
    private String parkingArea; // 주차 구역 (A1 ~ A20)
    private String carNum; // 차량번호
    private String car_type; // 차량 종류(일반/경차/장애인)
    private Boolean isMember; // 월정액 회원 유무 True(회원) / False(비회원)
    private LocalDateTime entry_time; // 입차 시간
    private LocalDateTime exit_time; // 출차 시간
    private int totalMinutes; // 총 주차 시간
}
