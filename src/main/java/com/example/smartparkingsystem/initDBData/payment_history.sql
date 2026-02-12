DELETE FROM payment_history;
ALTER TABLE payment_history AUTO_INCREMENT = 1;

-- 1. 활성화된 정책 정보 로드 (변수 할당)
SELECT
    @p_no := pno,
    @f_time := free_time,
    @b_time := basic_time,
    @e_time := extra_time,
    @b_charge := basic_charge,
    @e_charge := extra_charge,
    @m_charge := max_charge,
    @s_disc := small_car_discount,
    @d_disc := disabled_discount
FROM payment_info
WHERE is_active = TRUE
LIMIT 1;

-- 2. 결제 이력 데이터 삽입
INSERT INTO payment_history
(parking_area, car_num, entry_time, exit_time, total_minutes, total_charge,
 mno, pno, park_no, discount_amount, final_charge, is_paid, payment_time)
SELECT
    ph.parking_area,
    ph.car_num,
    ph.entry_time,
    ph.exit_time,
    ph.total_minutes,
    -- 원가 계산 (회차 무료, 기본요금, 추가요금, 일일최대 적용)
    @raw_fee := (
        CASE
            WHEN ph.total_minutes <= @f_time THEN 0
            WHEN ph.total_minutes <= @b_time THEN @b_charge
            ELSE LEAST(@m_charge, @b_charge + (CEIL((ph.total_minutes - @b_time) / @e_time) * @e_charge))
            END
        ) AS total_charge,
    m.mno,
    @p_no AS pno,
    ph.park_no,
    -- 할인액 계산 (월정액 무료 > 장애인 > 경차 순)
    @discount := (
        CASE
            WHEN ph.is_member = TRUE THEN @raw_fee
            WHEN ph.car_type = '장애인' THEN @raw_fee * @d_disc
            WHEN ph.car_type = '경차' THEN @raw_fee * @s_disc
            ELSE 0
            END
        ) AS discount_amount,
    -- 최종 결제액
    (@raw_fee - @discount) AS final_charge,
    TRUE AS is_paid,
    ph.exit_time AS payment_time
FROM parking_history ph
         LEFT JOIN members m ON ph.car_num = m.car_num
    AND ph.entry_time BETWEEN m.start_date AND m.end_date;