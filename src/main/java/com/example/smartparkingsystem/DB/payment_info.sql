CREATE TABLE IF NOT EXISTS `payment_info`
(
    `pno`                BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '정책 인덱스',
    `free_time`          INT COMMENT '무료 회차 시간',
    `basic_time`         INT COMMENT '기본 시간',
    `extra_time`         INT COMMENT '초과 시간',
    `basic_charge`       INT COMMENT '기본 요금',
    `extra_charge`       INT COMMENT '초과 시간 당 추가 요금',
    `max_charge`         INT COMMENT '일일 최대 요금',
    `small_car_discount` DOUBLE COMMENT '경차 할인율',
    `disabled_discount`  DOUBLE COMMENT '장애인 할인율',
    `is_active`          BOOLEAN  DEFAULT TRUE COMMENT '정책 활성화 여부 True (현재) / False (이전)',
    `admin_id`           VARCHAR(20) COMMENT '정책 수정한 관리자 아이디',
    `updated_at`         DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '관리자 정책 수정일',
    CONSTRAINT `chk_free_time` CHECK (`free_time` >= 0),
    CONSTRAINT `chk_basic_time` CHECK (`basic_time` >= 0),
    CONSTRAINT `chk_extra_time` CHECK (`extra_time` >= 0),
    CONSTRAINT `chk_basic_charge` CHECK (`basic_charge` >= 0),
    CONSTRAINT `chk_extra_charge` CHECK (`extra_charge` >= 0),
    CONSTRAINT `chk_max_charge` CHECK (`max_charge` >= 0),
    CONSTRAINT `chk_small_car_discount` CHECK (`small_car_discount` >= 0),
    CONSTRAINT `chk_disabled_discount` CHECK (`disabled_discount` >= 0),
    CONSTRAINT `fk_admin_id` FOREIGN KEY (`admin_id`) REFERENCES admin (`admin_id`)
) COMMENT '정책';