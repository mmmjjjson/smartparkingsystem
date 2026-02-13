CREATE TABLE IF NOT EXISTS `payment_history`
(
    `pay_no`          BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '요금 기록 인덱스',
    `parking_area`    VARCHAR(10) NOT NULL COMMENT '주차 구역 (A1 ~ A20)',
    `car_num`         VARCHAR(10) NOT NULL COMMENT '차량번호',
    `entry_time`      DATETIME    NOT NULL COMMENT '입차 시간',
    `exit_time`       DATETIME    NOT NULL COMMENT '출차 시간',
    `total_minutes`   INT         NOT NULL COMMENT '총 주차 시간',
    `total_charge`    INT      DEFAULT 0 COMMENT '총 요금',
    `mno`             BIGINT COMMENT '회원 번호',
    `pno`             BIGINT COMMENT '요금 정책 번호',
    `park_no`         BIGINT COMMENT '주차 기록 번호',
    `discount_amount` INT      DEFAULT 0 COMMENT '할인 금액',
    `final_charge`    INT      DEFAULT 0 COMMENT '결제 요금',
    `is_paid`         BOOLEAN  DEFAULT FALSE COMMENT '결제 여부',
    `payment_time`    DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '결제 시간',
    CONSTRAINT `chk_total_minutes` CHECK (`total_minutes` >= 0),
    CONSTRAINT `chk_total_charge` CHECK (`total_charge` >= 0),
    CONSTRAINT `chk_discount_amount` CHECK (`discount_amount` >= 0),
    CONSTRAINT `chk_final_charge` CHECK (`final_charge` >= 0),
    CONSTRAINT `fk_mno` FOREIGN KEY (`mno`) REFERENCES members (`mno`),
    CONSTRAINT `fk_pno` FOREIGN KEY (`pno`) REFERENCES payment_info (`pno`),
    CONSTRAINT `fk_park_no` FOREIGN KEY (`park_no`) REFERENCES parking_history (`park_no`)
) COMMENT '주차 요금';


