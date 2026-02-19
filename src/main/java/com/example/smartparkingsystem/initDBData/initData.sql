
INSERT INTO admin
(admin_id, password, admin_name, birth, admin_email, is_active, last_login_ip)
VALUES
    ('admin1', '1234', '관리자', '850101', 'admin@parking.com', TRUE, '127.0.0.1');



INSERT INTO members (car_num, member_name, member_phone, start_date, end_date, member_charge)
SELECT
    CONCAT(LPAD(FLOOR(RAND() * 100), 2, '0'), CHAR(FLOOR(RAND() * 26) + 65), FLOOR(RAND() * 9000 + 1000)),
    CONCAT('회원', FLOOR(RAND() * 1000)),
    CONCAT('010-', LPAD(FLOOR(RAND()*10000),4,'0'), '-', LPAD(FLOOR(RAND()*10000),4,'0')),
    start_date,
    DATE_ADD(start_date, INTERVAL 30 * months_purchased DAY),
    100000
FROM (
         SELECT
             -- 2024-01-01부터 2026-02-11까지 (약 772일)
             '2024-01-01' + INTERVAL FLOOR(RAND() * 772) DAY AS start_date,
             1 AS months_purchased
         FROM information_schema.tables t1, information_schema.tables t2
             LIMIT 800
     ) AS derived;


-- 기본 정책
INSERT INTO payment_info
(free_time, basic_time, extra_time, basic_charge, extra_charge, max_charge, small_car_discount, disabled_discount, is_active, admin_id, member_charge)
VALUES
    (10, 60, 30, 2000, 1000, 15000, 0.3, 0.5, TRUE, 'admin1', 100000);






INSERT INTO parking_history
(parking_area, car_num, car_type, is_member, entry_time, exit_time, total_minutes)
SELECT
    parking_area,
    car_num,
    CASE
        WHEN (ABS(CAST(CONV(SUBSTRING(MD5(car_num), 1, 8), 16, 10) AS SIGNED)) % 100) < 85 THEN '일반'
        WHEN (ABS(CAST(CONV(SUBSTRING(MD5(car_num), 1, 8), 16, 10) AS SIGNED)) % 100) < 97 THEN '경차'
        ELSE '장애인'
        END AS car_type,
    is_member,
    entry_time,
    TIMESTAMPADD(MINUTE, total_minutes, entry_time) AS exit_time,
    total_minutes
FROM (
         -- =============================================
         -- 1. 회원 주차 기록 (3,000건)
         -- =============================================
         (SELECT
              parking_area,
              car_num,
              is_member,
              --  외부에서 rand_val 참조 → 행마다 다른 시간대 버킷
              TIMESTAMP(
              date_part,
              SEC_TO_TIME(
              CASE
              WHEN rand_val < 0.03 THEN FLOOR(RAND() * 28800)              -- 3%  : 00~08시 (새벽)
              WHEN rand_val < 0.15 THEN FLOOR(28800 + RAND() * 3600)       -- 12% : 08~09시
              WHEN rand_val < 0.38 THEN FLOOR(32400 + RAND() * 3600)       -- 23% : 09~10시 ★ 피크
              WHEN rand_val < 0.55 THEN FLOOR(36000 + RAND() * 7200)       -- 17% : 10~12시
              WHEN rand_val < 0.68 THEN FLOOR(43200 + RAND() * 10800)      -- 13% : 12~15시
              WHEN rand_val < 0.80 THEN FLOOR(54000 + RAND() * 10800)      -- 12% : 15~18시
              WHEN rand_val < 0.93 THEN FLOOR(64800 + RAND() * 10800)      -- 13% : 18~21시
              ELSE                      FLOOR(75600 + RAND() * 10799)      -- 7%  : 21~24시 (86399초 상한)
              END
              )
         ) AS entry_time,
              total_minutes
          FROM (
                   --  핵심: SELECT 안에 RAND() → 행마다 독립 평가
                   SELECT
                       CONCAT('A', FLOOR(RAND() * 20 + 1))                            AS parking_area,
                       m.car_num                                                        AS car_num,
                       TRUE                                                             AS is_member,
                       RAND()                                                           AS rand_val,  -- ← 행마다 고유값
                       LEAST(
                               m.start_date + INTERVAL FLOOR(RAND() * DATEDIFF(LEAST(m.end_date, '2026-02-11'), m.start_date)) DAY,
                               '2026-02-11'
                       )                                                                AS date_part,
                       CASE
                           WHEN RAND() < 0.9 THEN FLOOR(RAND() * 240 + 30)
                           ELSE FLOOR(RAND() * 1440 + 240)
                           END                                                              AS total_minutes
                   FROM members m
                            CROSS JOIN (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) AS t
                   WHERE m.start_date <= '2026-02-11'
                   LIMIT 3000
               ) AS member_inner)

UNION ALL

-- =============================================
-- 2. 비회원 주차 기록 (7,000건)
-- =============================================
(SELECT
     parking_area,
     car_num,
     is_member,
     TIMESTAMP(
     date_part,
     SEC_TO_TIME(
     CASE
     WHEN rand_val < 0.03 THEN FLOOR(RAND() * 28800)
     WHEN rand_val < 0.15 THEN FLOOR(28800 + RAND() * 3600)
     WHEN rand_val < 0.38 THEN FLOOR(32400 + RAND() * 3600)       -- ★ 피크
     WHEN rand_val < 0.55 THEN FLOOR(36000 + RAND() * 7200)
     WHEN rand_val < 0.68 THEN FLOOR(43200 + RAND() * 10800)
     WHEN rand_val < 0.80 THEN FLOOR(54000 + RAND() * 10800)
     WHEN rand_val < 0.93 THEN FLOOR(64800 + RAND() * 10800)
     ELSE                      FLOOR(75600 + RAND() * 10799)
     END
     )
) AS entry_time,
              total_minutes
          FROM (
                   SELECT
                       CONCAT('A', FLOOR(RAND() * 20 + 1))                            AS parking_area,
                       CONCAT(
                               IF(RAND() > 0.5, FLOOR(RAND() * 90 + 10), FLOOR(RAND() * 900 + 100)),
                               ELT(FLOOR(RAND() * 5) + 1, '가', '나', '다', '라', '마'),
                               LPAD(FLOOR(RAND() * 9000 + 1000), 4, '0')
                       )                                                                AS car_num,
                       FALSE                                                            AS is_member,
                       RAND()                                                           AS rand_val,  -- ← 행마다 고유값
                       DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND() * 772) DAY)        AS date_part,
                       CASE
                           WHEN RAND() < 0.9 THEN FLOOR(RAND() * 240 + 30)
                           ELSE FLOOR(RAND() * 1440 + 240)
                           END                                                              AS total_minutes
                   FROM information_schema.columns c1, information_schema.columns c2
                   LIMIT 7000
               ) AS nonmember_inner)
     ) AS combined_data
ORDER BY entry_time;


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
ORDER BY updated_at DESC
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