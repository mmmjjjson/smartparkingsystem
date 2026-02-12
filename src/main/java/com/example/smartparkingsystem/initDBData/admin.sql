DELETE FROM admin;

INSERT INTO admin
(admin_id, password, admin_name, birth, admin_email, is_active, last_login_ip)
VALUES
    ('admin1', '1234', '관리자', '850101', 'admin@parking.com', TRUE, '127.0.0.1');