create table payment_info
(
    basic_charge       int    default 2000 null comment '기본요금',
    extra_charge       int    default 1000 null comment '추가요금',
    small_car_discount double default 30   not null comment '경차할인율',
    disabled_discount  double default 50   not null comment '장애인할인율',
    basic_time         int    default 60   null comment '기본시간',
    extra_time         int    default 30   null comment '초과 시간'
)
    comment '정산 정보';