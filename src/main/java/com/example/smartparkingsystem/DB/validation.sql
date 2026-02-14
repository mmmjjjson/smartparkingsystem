create table validation
(
    no           int auto_increment comment '인덱스'
        primary key,
    admin_id     varchar(20) not null comment 'FK 관리자 아이디',
    otp_code     char(6)     not null comment 'OTP',
    admin_email  varchar(50) not null comment '관리자 이메일 (OTP보낸 이메일)',
    expired_time datetime    not null comment '만료시간',
    constraint fk_admin_id_otp
        foreign key (admin_id) references admin (admin_id)
)
    comment 'OTP 로그';