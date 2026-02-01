function calculateBaseFeeOnly(minutes, policy) {
    if (minutes <= policy.freeTime) return 0;
    if (minutes <= policy.basicTime) return policy.basicCharge;
    const extraMinutes = minutes - policy.basicTime;
    const extraCharge = Math.ceil(extraMinutes / policy.extraTime) * policy.extraCharge;
    return policy.basicCharge + extraCharge;
}

function calculateParkingCharge(inDate, outDate, carType) {
    // 1. 요금 정책
    // *** 추후 DB(payment_info)에서 끌고 와야 함!!! ***
    // *** freeTime, maxCharge는 테이블에 없는데 있는 게 좋을지?
    // *** 설정 관리에 없는 옵션이라 테이블에서 뺀 건데 추후 생길 걸 예상하고 테이블에 넣어두어야 할지
    const policy = {
        freeTime: 10, // ***
        basicTime: 60,
        extraTime: 30,
        basicCharge: 2000,
        extraCharge: 1000,
        smallCarDiscount: 0.3,
        disabledDiscount: 0.5,
        maxCharge: 15000 // ***
    };

    let total = 0; // 총 요금
    let base = 0;  // 기본 요금
    let extra = 0; // 추가 요금
    const [inHour, inMin] = inTime.split(':').map(Number);
    const [outHour, outMin] = outTime.split(':').map(Number);

    // 2. 시간별 요금 계산
    if ((outHour * 60 + outMin) < (inHour * 60 + inMin)) { // 자정이 지났다면
        // 1) 전날 요금
        const day1Time = 1440 - (inHour * 60 + inMin); // 전날 주차한 시간
        let day1Charge = calculateBaseFeeOnly(day1Time, policy);
        day1Charge = Math.min(day1Charge, policy.maxCharge);

        // 2) 다음날 요금
        const day2Time = (outHour * 60 + outMin); // 오늘 주차한 시간
        let day2Charge = calculateBaseFeeOnly(day2Time, policy);
        day2Charge = Math.min(day2Charge, policy.maxCharge);

        total = day1Charge + day2Charge
    }
    if (diffMinutes <= policy.freeTime) { // 회차 시간(10분) 이내
        return {total: 0, base: 0, extra: 0, discount: 0}
    } else if (diffMinutes <= policy.basicTime) { // 10분 초과 60분 이내
        base = policy.basicCharge;
    } else { // 60분 초과
        const extraMinutes = diffMinutes - policy.basicTime;
        base = policy.basicCharge;
        extra = Math.ceil(extraMinutes / policy.extraTime) * policy.extraCharge;
    }
    total = base + extra;

    if (total > policy.maxCharge) { // 일일 최대 요금 이상이 되면
        total = policy.maxCharge;
        base = policy.maxCharge;
        extra = 0;
    }

    // 3. 할인 혜택 적용
    let discount = 0;
    let discountName = "";
    if (carType === "월정액") {
        discount = total; // 100% 할인
        discountName = "월정액 회원 할인 (100%)"
    } else if (carType === "장애인") {
        discount = total * 0.5;
        discountName = `장애인 할인 (\${policy.disabledDiscount * 100}%)`
    } else if (carType === "경차") {
        discount = total * 0.3;
        discountName = "경차 할인 (\${policy.smallCarDiscount * 100}%)"
    }
    total = total - discount;
    return {total, base, extra, discount, discountName};
}