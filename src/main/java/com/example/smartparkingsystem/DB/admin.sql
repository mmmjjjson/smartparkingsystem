CREATE TABLE IF NOT EXISTS `admin`
(
    admin_id      VARCHAR(20) PRIMARY KEY COMMENT '관리자 아이디',
    password      VARCHAR(50) NOT NULL COMMENT '관리자 비밀번호',
    admin_name    VARCHAR(20) NOT NULL COMMENT '관리자 이름',
    birth         VARCHAR(6)  NOT NULL COMMENT '관리자 생년월일 6자리',
    admin_email   VARCHAR(50) NOT NULL UNIQUE COMMENT '이메일',
    is_active     BOOLEAN  DEFAULT TRUE COMMENT '사용여부 True 사용중, False 사용중지',
    last_login    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '마지막 로그인 날짜',
    last_login_ip VARCHAR(45) NULL COMMENT '마지막 로그인 IP (보안용)',
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '계정 생성일'
) COMMENT '관리자';