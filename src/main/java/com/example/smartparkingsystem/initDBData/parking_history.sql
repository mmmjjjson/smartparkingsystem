-- Parking History 테이블: 2024-01-01 ~ 2026-02-11 사이 기록만
DELETE FROM parking_history;
ALTER TABLE parking_history AUTO_INCREMENT = 1;

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
         -- 1. 회원 주차 기록 (3,000건) - 회원 유효 기간 내에서만
         (SELECT
              CONCAT('A', FLOOR(RAND() * 20 + 1)) AS parking_area,
              m.car_num,
              TRUE AS is_member,
              -- 회원 유효 기간 내 랜덤 시간 (단, 2026-02-11을 넘지 않음)
              TIMESTAMP(
                      LEAST(
                              m.start_date + INTERVAL FLOOR(RAND() * DATEDIFF(LEAST(m.end_date, '2026-02-11'), m.start_date)) DAY,
                              '2026-02-11'
                      ),
                      SEC_TO_TIME(FLOOR(RAND() * 86400))
              ) AS entry_time,
              CASE
                  WHEN RAND() < 0.9 THEN FLOOR(RAND() * 240 + 30)
                  ELSE FLOOR(RAND() * 1440 + 240)
                  END AS total_minutes
          FROM members m
                   CROSS JOIN (SELECT 1 UNION SELECT 2 UNION SELECT 3) AS t
          WHERE m.start_date <= '2026-02-11'  -- 2026-02-11 이전에 시작한 회원만
          LIMIT 3000)

         UNION ALL





         -- 2. 비회원 주차 기록 (7,000건) - 2024-01-01 ~ 2026-02-11
         (SELECT
              CONCAT('A', FLOOR(RAND() * 20 + 1)) AS parking_area,
              CONCAT(
                      IF(RAND() > 0.5, FLOOR(RAND() * 90 + 10), FLOOR(RAND() * 900 + 100)),
                      ELT(FLOOR(RAND() * 5) + 1, '가', '나', '다', '라', '마'),
                      LPAD(FLOOR(RAND() * 9000 + 1000), 4, '0')
              ) AS car_num,
              FALSE AS is_member,
              -- 2024-01-01 ~ 2026-02-11 (약 772일 = 1,111,680분)
              TIMESTAMP('2024-01-01 00:00:00' + INTERVAL FLOOR(RAND() * 1111680) MINUTE) AS entry_time,
              CASE
                  WHEN RAND() < 0.9 THEN FLOOR(RAND() * 240 + 30)
                  ELSE FLOOR(RAND() * 1440 + 240)
                  END AS total_minutes
          FROM information_schema.columns c1, information_schema.columns c2
          LIMIT 7000)
     ) AS combined_data
ORDER BY entry_time;



INSERT INTO parking_history
(parking_area, car_num, car_type, is_member, entry_time, exit_time, total_minutes)
VALUES
    ('A1',  '12가1234', '일반', FALSE, '2026-02-12 09:15:00', NULL, NULL),
    ('A2',  '23나2345', '일반', FALSE, '2026-02-13 10:42:00', NULL, NULL),
    ('A3',  '34다3456', '일반', FALSE, '2026-02-14 08:27:00', NULL, NULL),
    ('A4',  '45라4567', '일반', FALSE, '2026-02-15 14:05:00', NULL, NULL),
    ('A5',  '56마5678', '일반', FALSE, '2026-02-16 11:33:00', NULL, NULL),
    ('A6',  '67바6789', '일반', FALSE, '2026-02-17 16:48:00', NULL, NULL),
    ('A7',  '78사7890', '일반', FALSE, '2026-02-18 07:59:00', NULL, NULL),
    ('A8',  '89아8901', '일반', FALSE, '2026-02-19 13:21:00', NULL, NULL),
    ('A9',  '90자9012', '일반', FALSE, '2026-02-20 18:10:00', NULL, NULL),
    ('A10', '11차1122', '일반', FALSE, '2026-02-21 12:44:00', NULL, NULL),
    ('A11', '22카2233', '일반', FALSE, '2026-02-22 09:38:00', NULL, NULL),
    ('A12', '33타3344', '일반', FALSE, '2026-02-23 15:12:00', NULL, NULL),
    ('A13', '44파4455', '일반', FALSE, '2026-02-24 10:55:00', NULL, NULL),
    ('A14', '55하5566', '일반', FALSE, '2026-02-25 17:26:00', NULL, NULL);
