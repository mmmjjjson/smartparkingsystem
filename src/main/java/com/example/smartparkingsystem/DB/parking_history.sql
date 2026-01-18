create table parking_history
(
    no           int(10) auto_increment comment '인덱스'
        primary key,
    parking_area varchar(10)                           not null comment '주차구역',
    car_num      varchar(10)                           not null comment '차량번호',
    car_type     enum ('일반', '경차', '장애인') default '일반' not null comment '분류',
    is_member    tinyint(1)                            not null comment '회원유무',
    entry_time   datetime                              not null comment '입차시간',
    exit_time    datetime                              null comment '출차시간'
)
    comment '주차내역';