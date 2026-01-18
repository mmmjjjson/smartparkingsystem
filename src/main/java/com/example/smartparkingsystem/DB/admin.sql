create table admin
(
    admin_id    varchar(10) not null comment '아이디'
        primary key,
    password    varchar(30) not null comment '비밀번호',
    admin_name  varchar(20) not null comment '관리자 이름',
    birth       varchar(6)  not null comment '생년월일',
    admin_phone varchar(15) not null comment '전화번호',
    constraint admin_phone
        unique (admin_phone)
)
    comment '관리자';