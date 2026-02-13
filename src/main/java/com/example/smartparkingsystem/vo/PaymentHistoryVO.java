package com.example.smartparkingsystem.vo;

import lombok.*;

import java.time.LocalDateTime;

@Data
@Builder
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class PaymentHistoryVO {
    private int id;
    private String parking_area;
    private String car_num;
    private String entry_time;
    private String exit_time;
    private int total_minutes;
    private int total_charge;
    private int mno;
    private int pno;
    private int park_no;
    private int discount_amount;
    private int final_charge;
    private int is_paid;
    LocalDateTime payment_time;
}
