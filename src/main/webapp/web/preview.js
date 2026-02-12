function formatNumber(val) {
    if (!val) return "";
    let num = val.toString().replace(/[^0-9.]/g, '');
    return num.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function liveUpdate() {
    const feeIds = ['in-base-fee', 'in-add-fee', 'in-monthly-fee'];
    feeIds.forEach(id => {
        let input = document.getElementById(id);
        input.value = formatNumber(input.value);
    });

    const freeTime = document.getElementById('in-free-time').value;
    const baseFee = document.getElementById('in-base-fee').value;
    const baseTime = document.getElementById('in-base-time').value;
    const addFee = document.getElementById('in-add-fee').value;
    const addTime = document.getElementById('in-add-time').value;
    const monthlyFee = document.getElementById('in-monthly-fee').value;
    const lightDis = document.getElementById('in-light-dis').value;
    const disabledDis = document.getElementById('in-disabled-dis').value;

    document.getElementById('pre-free').textContent = freeTime + "분 이내 무료";
    document.getElementById('pre-base').innerHTML = '<span class="highlight">' + baseFee + '</span>원 / ' + baseTime + '분';
    document.getElementById('pre-add').innerHTML = '<span class="highlight">' + addFee + '</span>원 / ' + addTime + '분';
    document.getElementById('pre-monthly').innerHTML = '<span class="highlight">' + monthlyFee + '</span>원';

    let lightPer = Math.round(parseFloat(lightDis) * 100);
    let disabledPer = Math.round(parseFloat(disabledDis) * 100);

    document.getElementById('pre-light').textContent = (isNaN(lightPer) ? 0 : lightPer) + "%";
    document.getElementById('pre-disabled').textContent = (isNaN(disabledPer) ? 0 : disabledPer) + "%";
}

function saveSettings() {
    alert('설정이 안전하게 저장되었습니다.');
}

window.onload = liveUpdate;







function formatNumber(val) {
    if (!val) return "";
    let num = val.toString().replace(/[^0-9.]/g, '');
    return num.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function formatFeeInputs() { //
    const feeIds = ['in-base-fee', 'in-addInfo-fee', 'in-monthly-fee', 'in-day-max-fee'];
    feeIds.forEach(id => {
        let input = document.getElementById(id);
        if(input) input.value = formatNumber(input.value);
    });
}

function saveSettings() {
    const data = {
        baseFee: document.getElementById('in-base-fee').value.replace(/,/g, ''),
        baseTime: document.getElementById('in-base-time').value,
        dayMaxFee: document.getElementById('in-day-max-fee').value.replace(/,/g, ''),
        addFee: document.getElementById('in-addInfo-fee').value.replace(/,/g, ''),
        addTime: document.getElementById('in-addInfo-time').value,
        freeTime: document.getElementById('in-free-time').value,
        lightDis: document.getElementById('in-light-dis').value,
        disabledDis: document.getElementById('in-disabled-dis').value,
        monthlyFee: document.getElementById('in-monthly-fee').value.replace(/,/g, '')
    };

    console.log("저장될 데이터:", data);
    alert('설정이 성공적으로 변경되었습니다.');
}

window.onload = formatFeeInputs;