create table members
(
    car_num      varchar(10)                            not null comment '차량번호'
        primary key,
    member_name  varchar(20)                            not null comment '회원 이름',
    start_date   date                                   not null comment '이용 시작일',
    end_date     date                                   not null comment '이용 만료일',
    is_active    tinyint(1) default 1                   not null comment '이용일 만료 여',
    created_at   datetime   default current_timestamp() null comment '최초 등록일',
    updated_at   datetime                               null on update current_timestamp() comment '업데이트된 날짜',
    member_phone varchar(15)                            not null comment '회원 전화번호',
    constraint user_phone
        unique (member_phone)
)
    comment '회원정보';