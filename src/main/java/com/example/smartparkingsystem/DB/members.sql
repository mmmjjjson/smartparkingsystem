CREATE TABLE IF NOT EXISTS `members`
(
    `mno`          BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '인덱스',
    `car_num`      VARCHAR(10) NOT NULL COMMENT '차량 번호',
    `member_name`  VARCHAR(20) NOT NULL COMMENT '이름',
    `member_phone` VARCHAR(15) NOT NULL COMMENT '연락처',
    `start_date`   DATE        NOT NULL COMMENT '이용 시작일',
    `end_date`     DATE        NOT NULL COMMENT '이용 만료일',
    INDEX idx_date (`start_date`, `end_date`)
) COMMENT '회원';