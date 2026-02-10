<%@ page import="com.example.smartparkingsystem.dto.PaymentInfoDTO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    PaymentInfoDTO paymentInfoDTO = (PaymentInfoDTO) request.getAttribute("paymentInfoDTO");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주차 관리 시스템 - 설정 페이지</title>
    <style>
        :root {
            --main-color: #4a76c5;
            --bg-color: #f8f9fa;
            --border-color: #ced4da;
            --gap: 15px;
        }

        body {
            font-family: 'Malgun Gothic', sans-serif;
            background-color: var(--bg-color);
            margin: 0;
            padding: 0;
            color: #333;
        }

        /* 헤더 영역 */
        .header {
            background-color: #fff;
            border-bottom: 2px solid #222;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 30px;
        }

        .header h1 { font-size: 18px; margin: 0; }

        .nav { display: flex; list-style: none; margin: 0; padding: 0; }
        .nav li {
            padding: 10px 20px;
            border: 1px solid var(--border-color);
            background: #eee;
            margin-left: -1px;
            cursor: pointer;
            font-size: 14px;
            transition: 0.2s;
        }
        .nav li:hover { background: #e0e0e0; }
        .nav li.active {
            background-color: var(--main-color);
            color: white;
            border-color: var(--main-color);
        }

        /* 컨텐츠 영역 */
        .container {
            width: 95%;
            max-width: 1000px;
            margin: 20px auto;
            box-sizing: border-box;
        }

        /* 타이틀 바 수정: 저장 버튼을 우측에 배치하기 위해 flex 적용 */
        .title-bar {
            background-color: #e9ecef;
            padding: 10px 20px;
            border: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: bold;
            margin-bottom: 20px;
            border-radius: 4px;
        }

        .card {
            background: white;
            border: 1px solid var(--border-color);
            padding: 20px;
            margin-bottom: 20px;
            box-sizing: border-box;
            border-radius: 4px;
        }

        .card-label {
            display: inline-block;
            font-size: 14px;
            font-weight: bold;
            color: #333;
            margin-bottom: 15px;
        }

        .input-row {
            display: flex;
            gap: var(--gap);
            flex-wrap: wrap;
        }

        .input-item {
            flex: 1;
            min-width: 250px;
            border: 1px solid var(--border-color);
            padding: 15px;
            background: #fafafa;
            text-align: center;
            min-height: 80px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            box-sizing: border-box;
            border-radius: 4px;
        }

        .input-item label {
            display: block;
            font-size: 12px;
            color: #666;
            margin-bottom: 8px;
        }

        .input-item input {
            width: 80%;
            padding: 8px;
            border: 1px solid #ccc;
            text-align: center;
            margin: 0 auto;
            border-radius: 3px;
        }

        .input-item input:focus {
            outline: 2px solid var(--main-color);
            border-color: transparent;
        }

        /* 우측 상단 저장 버튼 */
        .save-btn {
            background-color: var(--main-color);
            color: white;
            padding: 8px 25px;
            border: none;
            font-weight: bold;
            cursor: pointer;
            border-radius: 4px;
            font-size: 14px;
            transition: background 0.2s;
        }

        .save-btn:hover {
            background-color: #365da3;
        }
    </style>
</head>
<body>

<%@ include file="common/header_setting.jsp"%>

<div class="container">
    <form name="setting" action="/setting" method="post">
    <div class="title-bar">
        <span>설정 관리 - 요금 및 할인 정책</span>
        <button class="save-btn" type="submit">저장하기</button>
    </div>

    <div class="card">
        <span class="card-label">기본 요금 및 일일 최대 요금 설정</span>
        <div class="input-row">
            <div class="input-item">
                <label>기본 주차 요금(원)</label>
                <input type="text" id="in-base-fee" value="<%=paymentInfoDTO.getBasicCharge()%>" oninput="formatFeeInputs()" name="basic_charge">
            </div>
            <div class="input-item">
                <label>기본 주차 시간(분)</label>
                <input type="text" id="in-base-time" value="<%=paymentInfoDTO.getBasicTime()%>" name="basic_time">
            </div>
            <div class="input-item">
                <label>일일 최대 요금(원)</label>
                <input type="text" id="in-day-max-fee" value="<%=paymentInfoDTO.getMaxCharge()%>" oninput="formatFeeInputs()" name="max_charge">
            </div>
        </div>
    </div>

    <div class="card">
        <span class="card-label"> 무료 회차 시간 및 추가 요금 설정</span>
        <div class="input-row">
            <div class="input-item">
                <label>무료 회차 시간(분)</label>
                <input type="text" id="in-free-time" value="<%=paymentInfoDTO.getFreeTime()%>" name="free_time">
            </div>
            <div class="input-item">
                <label>추가 요금(원)</label>
                <input type="text" id="in-add-fee" value="<%=paymentInfoDTO.getExtraCharge()%>" oninput="formatFeeInputs()" name="extra_charge">
            </div>
            <div class="input-item">
                <label>추가 요금 기준 시간(분)</label>
                <input type="text" id="in-add-time" value="<%=paymentInfoDTO.getExtraTime()%>" name="extra_time">
            </div>
        </div>
    </div>

    <div class="card" style="margin-bottom: 0;">
        <span class="card-label">할인율 및 월 주차 요금 설정</span>
        <div class="input-row">
            <div class="input-item">
                <label>경차 할인율</label>
                <input type="text" id="in-light-dis" value="<%=paymentInfoDTO.getSmallCarDiscount()%>" name="small_car_discount">
            </div>
            <div class="input-item">
                <label>장애인 할인율</label>
                <input type="text" id="in-disabled-dis" value="<%=paymentInfoDTO.getDisabledDiscount()%>" name="disabled_discount">
            </div>
            <div class="input-item">
                <label>월 정액권(원)</label>
                <input type="text" id="in-monthly-fee" value="<%=paymentInfoDTO.getMemberCharge()%>" oninput="formatFeeInputs()" name="member_charge">
            </div>
        </div>
    </div>
    </form>
</div>

<script>


    // function formatNumber(val) {
    //     if (!val) return "";
    //     let num = val.toString().replace(/[^0-9.]/g, '');
    //     return num.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    // }
    //
    // function formatFeeInputs() { //
    //     const feeIds = ['in-base-fee', 'in-addInfo-fee', 'in-monthly-fee', 'in-day-max-fee'];
    //     feeIds.forEach(id => {
    //         let input = document.getElementById(id);
    //         if(input) input.value = formatNumber(input.value);
    //     });
    // }
    //
    // function saveSettings() {
    //     const data = {
    //         baseFee: document.getElementById('in-base-fee').value.replace(/,/g, ''),
    //         baseTime: document.getElementById('in-base-time').value,
    //         dayMaxFee: document.getElementById('in-day-max-fee').value.replace(/,/g, ''),
    //         addFee: document.getElementById('in-addInfo-fee').value.replace(/,/g, ''),
    //         addTime: document.getElementById('in-addInfo-time').value,
    //         freeTime: document.getElementById('in-free-time').value,
    //         lightDis: document.getElementById('in-light-dis').value,
    //         disabledDis: document.getElementById('in-disabled-dis').value,
    //         monthlyFee: document.getElementById('in-monthly-fee').value.replace(/,/g, '')
    //     };
    //
    //     console.log("저장될 데이터:", data);
    //     alert('설정이 성공적으로 변경되었습니다.');
    // }
    //
    // window.onload = formatFeeInputs;
</script>

</body>
</html>