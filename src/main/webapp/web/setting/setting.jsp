<%@ page import="com.example.smartparkingsystem.dto.PaymentInfoDTO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    PaymentInfoDTO paymentInfoDTO = (PaymentInfoDTO) request.getAttribute("paymentInfoDTO");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <!-- Pretendard 폰트 -->
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
    <title>스마트 주차 관리 시스템 - 설정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../web/statistic/css/setting.css">

</head>
<body>
<%@ include file="/web/common/header_other.jsp" %>

<div class="container">
    <form name="setting" action="/setting" method="post">
        <div class="title-bar">
            <span>설정 관리 - 요금 및 할인 정책</span>
            <button class="save-btn" type="submit" onclick="saveSetting()">저장하기</button>
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
    function saveSetting() {
        alert('설정이 성공적으로 변경되었습니다.')
    }
</script>

</body>
</html>