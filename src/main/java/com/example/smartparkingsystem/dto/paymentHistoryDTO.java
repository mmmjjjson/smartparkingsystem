package com.example.smartparkingsystem.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class paymentHistoryDTO {
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
