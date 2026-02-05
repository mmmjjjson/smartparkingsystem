CREATE TABLE IF NOT EXISTS `parking_history`
(
    `park_no`       BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '주차 기록 인덱스',
    `parking_area`  VARCHAR(10) NOT NULL COMMENT '주차 구역 (A1 ~ A20)',
    `car_num`       VARCHAR(10) NOT NULL COMMENT '차량번호',
    `car_type`      ENUM ('일반', '경차', '장애인') DEFAULT '일반' COMMENT '차량 종류(일반/경차/장애인)',
    `is_member`     BOOLEAN     NOT NULL     DEFAULT FALSE COMMENT '월정액 회원 유무 True(회원) / False(비회원)',
    `entry_time`    DATETIME    NOT NULL COMMENT '입차 시간',
    `exit_time`     DATETIME COMMENT '출차 시간',
    `total_minutes` INT COMMENT '총 주차 시간'
) COMMENT '주차';