DELETE FROM parking_history;
ALTER TABLE parking_history AUTO_INCREMENT = 1;

-- 정책변경된 더미데이터 생성하기
-- 1. parking_history의 24년 12월까지(첫 번째)의 더미데이터만 생성한다.
-- 2. payment_info의 첫 번째 정책을 생성한다
-- 3.   payment_history의 정책 정보 로드를 실행하고 insert를 실행한다.
-- 4. parking_history의 두 번째 더미데이터를 생성한다
-- 5. payment_info의 첫번째 정책의 is_active = false하고 두 번째 정책을 생성한다
-- 6.   payment_history의 정책 정보 로드를 실행하고 insert를 실행한다.
-- 7. payment_history.sql의 최하단의 24 ~ 25년도 데이터를 삭제한다
-- 끝



-- 24.01 ~ 24.12
INSERT INTO parking_history
(parking_area, car_num, car_type, is_member, entry_time, exit_time, total_minutes)
SELECT
    parking_area, car_num,
    CASE
        WHEN (ABS(CAST(CONV(SUBSTRING(MD5(car_num), 1, 8), 16, 10) AS SIGNED)) % 100) < 85 THEN '일반'
        WHEN (ABS(CAST(CONV(SUBSTRING(MD5(car_num), 1, 8), 16, 10) AS SIGNED)) % 100) < 97 THEN '경차'
        ELSE '장애인'
        END AS car_type,
    is_member, entry_time,
    TIMESTAMPADD(MINUTE, total_minutes, entry_time) AS exit_time,
    total_minutes
FROM (
         -- [A] 회원 데이터 (3,000건)
         (SELECT
              CONCAT('A', FLOOR(RAND() * 20 + 1)) AS parking_area,
              m.car_num,
              TRUE AS is_member,
              TIMESTAMP(
                      LEAST(m.start_date + INTERVAL FLOOR(RAND() * DATEDIFF(LEAST(m.end_date, '2024-12-31'), m.start_date)) DAY, '2024-12-31'),
                      SEC_TO_TIME(FLOOR(RAND() * 86400))
              ) AS entry_time,
              CASE WHEN RAND() < 0.9 THEN FLOOR(RAND() * 240 + 30) ELSE FLOOR(RAND() * 1440 + 240) END AS total_minutes
          FROM members m
                   CROSS JOIN (SELECT 1 UNION SELECT 2) AS t -- 멤버가 1500명이므로 2번 복제하여 3000건 생성
          WHERE m.start_date <= '2024-12-31'
          LIMIT 3000)

         UNION ALL

         -- [B] 비회원 데이터 (7,000건)
         (SELECT
              CONCAT('B', FLOOR(RAND() * 20 + 1)) AS parking_area,
              CONCAT(LPAD(FLOOR(RAND() * 100), 2, '0'), CHAR(FLOOR(RAND() * 26) + 65), FLOOR(RAND() * 9000 + 1000)) AS car_num,
              FALSE AS is_member,
              TIMESTAMP('2024-01-01' + INTERVAL FLOOR(RAND() * 365) DAY, SEC_TO_TIME(FLOOR(RAND() * 86400))) AS entry_time,
              CASE WHEN RAND() < 0.9 THEN FLOOR(RAND() * 180 + 20) ELSE FLOOR(RAND() * 1200 + 180) END AS total_minutes
          FROM information_schema.columns
          LIMIT 7000)
     ) AS combined_2024;



-- 25 ~ 26.02.11
INSERT INTO parking_history
(parking_area, car_num, car_type, is_member, entry_time, exit_time, total_minutes)
SELECT
    parking_area, car_num,
    CASE
        WHEN (ABS(CAST(CONV(SUBSTRING(MD5(car_num), 1, 8), 16, 10) AS SIGNED)) % 100) < 85 THEN '일반'
        WHEN (ABS(CAST(CONV(SUBSTRING(MD5(car_num), 1, 8), 16, 10) AS SIGNED)) % 100) < 97 THEN '경차'
        ELSE '장애인'
        END AS car_type,
    is_member, entry_time,
    TIMESTAMPADD(MINUTE, total_minutes, entry_time) AS exit_time,
    total_minutes
FROM (
         -- [A] 회원 데이터 (3,000건)
         (SELECT
              CONCAT('A', FLOOR(RAND() * 20 + 1)) AS parking_area,
              m.car_num,
              TRUE AS is_member,
              TIMESTAMP(
                      GREATEST('2025-01-01', m.start_date) +
                      INTERVAL FLOOR(RAND() * DATEDIFF(LEAST(m.end_date, '2026-02-11'), GREATEST('2025-01-01', m.start_date))) DAY,
                      SEC_TO_TIME(FLOOR(RAND() * 86400))
              ) AS entry_time,
              CASE WHEN RAND() < 0.9 THEN FLOOR(RAND() * 240 + 30) ELSE FLOOR(RAND() * 1440 + 240) END AS total_minutes
          FROM members m
                   CROSS JOIN (SELECT 1 UNION SELECT 2) AS t
          WHERE m.end_date >= '2025-01-01' AND m.start_date <= '2026-02-11'
          LIMIT 3000)

         UNION ALL

         -- [B] 비회원 데이터 (7,000건)
         (SELECT
              CONCAT('B', FLOOR(RAND() * 20 + 1)) AS parking_area,
              CONCAT(LPAD(FLOOR(RAND() * 100), 2, '0'), CHAR(FLOOR(RAND() * 26) + 65), FLOOR(RAND() * 9000 + 1000)) AS car_num,
              FALSE AS is_member,
              -- 2025-01-01부터 약 407일간 (2026-02-11까지)
              TIMESTAMP('2025-01-01' + INTERVAL FLOOR(RAND() * 407) DAY, SEC_TO_TIME(FLOOR(RAND() * 86400))) AS entry_time,
              CASE WHEN RAND() < 0.9 THEN FLOOR(RAND() * 180 + 20) ELSE FLOOR(RAND() * 1200 + 180) END AS total_minutes
          FROM information_schema.columns
          LIMIT 7000)
     ) AS combined_2025_2026;