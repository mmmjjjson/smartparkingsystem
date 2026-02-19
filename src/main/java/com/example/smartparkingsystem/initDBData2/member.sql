
-- Members 테이블: 2024-01-01 ~ 2026-02-11 사이
DELETE FROM members;
ALTER TABLE members AUTO_INCREMENT = 1;

INSERT INTO members (car_num, member_name, member_phone, start_date, end_date)
SELECT
    CONCAT(LPAD(FLOOR(RAND() * 100), 2, '0'), CHAR(FLOOR(RAND() * 26) + 65), FLOOR(RAND() * 9000 + 1000)),
    CONCAT('회원', FLOOR(RAND() * 1000)),
    CONCAT('010-', LPAD(FLOOR(RAND()*10000),4,'0'), '-', LPAD(FLOOR(RAND()*10000),4,'0')),
    start_date,
    DATE_ADD(start_date, INTERVAL 30 * months_purchased DAY)
FROM (
         SELECT
             -- 2024-01-01부터 2026-02-11까지 (약 772일)
             '2024-01-01' + INTERVAL FLOOR(RAND() * 772) DAY AS start_date,
             1 AS months_purchased
         FROM information_schema.tables t1, information_schema.tables t2
         LIMIT 800
     ) AS derived;












-- Members 테이블: 2024-01-01 ~ 2026-02-11 사이
DELETE FROM members;
ALTER TABLE members AUTO_INCREMENT = 1;

INSERT INTO members (car_num, member_name, member_phone, start_date, end_date)
SELECT
    CONCAT(LPAD(FLOOR(RAND() * 100), 2, '0'), CHAR(FLOOR(RAND() * 26) + 65), FLOOR(RAND() * 9000 + 1000)),
    CONCAT('회원', FLOOR(RAND() * 1000)),
    CONCAT('010-', LPAD(FLOOR(RAND()*10000),4,'0'), '-', LPAD(FLOOR(RAND()*10000),4,'0')),
    start_date,
    DATE_ADD(start_date, INTERVAL 30 * months_purchased DAY)
FROM (
         SELECT
             -- 2024-01-01부터 2026-02-11까지 (약 772일)
             '2024-01-01' + INTERVAL FLOOR(RAND() * 772) DAY AS start_date,
             1 AS months_purchased
         FROM information_schema.tables t1, information_schema.tables t2
         LIMIT 1000
     ) AS derived;