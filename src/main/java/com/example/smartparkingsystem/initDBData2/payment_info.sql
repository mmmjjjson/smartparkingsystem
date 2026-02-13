DELETE FROM payment_info;
ALTER TABLE payment_info AUTO_INCREMENT = 1;

-- 기본 정책
INSERT INTO payment_info
(free_time, basic_time, extra_time, basic_charge, extra_charge, max_charge, small_car_discount, disabled_discount, is_active, admin_id)
VALUES
    (10, 60, 30, 2000, 1000, 15000, 0.3, 0.5, TRUE, 'admin1');



-- 수정 정책
UPDATE payment_info SET is_active = false WHERE pno = 1;

INSERT INTO payment_info
(free_time, basic_time, extra_time, basic_charge, extra_charge, max_charge, small_car_discount, disabled_discount, is_active, admin_id)
VALUES
    (10, 60, 30, 3000, 2000, 15000, 0.3, 0.5, TRUE, 'admin1');

UPDATE payment_info SET member_charge = 100000 where pno = 2;
