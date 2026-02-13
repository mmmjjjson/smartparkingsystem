<%@ page import="com.example.smartparkingsystem.dto.PaymentInfoDTO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    PaymentInfoDTO paymentInfoDTO = (PaymentInfoDTO) request.getAttribute("paymentInfoDTO");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" as="style" crossorigin
          href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css"/>
    <title>스마트 주차 관리 시스템 - 설정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/web/setting/setting.css">

</head>
<body>
<%@ include file="/web/common/header_other.jsp" %>
<div class="container">
    <form name="setting" action="/setting" method="post" class="setup-area" onsubmit="return prepareSubmit()">
        <div class="title-bar">
            설정 관리 - 요금 및 할인 정책
            <button class="save-btn" type="submit">저장하기</button>
        </div>

        <div class="card">
            <span class="card-label">기본 요금 및 일일 최대 요금 설정</span>
            <div class="input-row">
                <div class="input-item">
                    <label>기본 주차 요금(원)</label>
                    <input type="text" id="in-base-fee" value="<%=paymentInfoDTO.getBasicCharge()%>"
                           name="basic_charge">
                </div>
                <div class="input-item">
                    <label>기본 주차 시간(분)</label>
                    <input type="text" id="in-base-time" value="<%=paymentInfoDTO.getBasicTime()%>" name="basic_time">
                </div>
                <div class="input-item">
                    <label>일일 최대 요금(원)</label>
                    <input type="text" id="in-day-max-fee" value="<%=paymentInfoDTO.getMaxCharge()%>"
                           name="max_charge">
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
                    <input type="text" id="in-add-fee" value="<%=paymentInfoDTO.getExtraCharge()%>"
                           name="extra_charge">
                </div>
                <div class="input-item">
                    <label>추가 요금 기준 시간(분)</label>
                    <input type="text" id="in-add-time" value="<%=paymentInfoDTO.getExtraTime()%>" name="extra_time">
                </div>
            </div>
        </div>

        <div class="card">
            <span class="card-label">할인율 및 월 주차 요금 설정</span>
            <div class="input-row">
                <div class="input-item">
                    <label>경차 할인율</label>
                    <input type="text" id="in-light-dis" value="<%=paymentInfoDTO.getSmallCarDiscount()%>"
                           name="small_car_discount">
                </div>
                <div class="input-item">
                    <label>장애인 할인율</label>
                    <input type="text" id="in-disabled-dis" value="<%=paymentInfoDTO.getDisabledDiscount()%>"
                           name="disabled_discount">
                </div>
                <div class="input-item">
                    <label>월 정액권(원)</label>
                    <input type="text" id="in-monthly-fee" value="<%=paymentInfoDTO.getMemberCharge()%>"
                           name="member_charge">
                </div>
            </div>
        </div>
    </form>
</div>

<script>
    // 콤마를 적용할 대상 ID들 리스트
    const moneyIds = ['in-base-fee', 'in-day-max-fee', 'in-add-fee', 'in-monthly-fee'];

    // 1. 숫자에 콤마를 추가하는 함수
    function formatNumber(e) {
        let value = e.target.value.replace(/[^\d]/g, ""); // 숫자 외 제거
        if (value) {
            e.target.value = Number(value).toLocaleString('ko-KR');
        } else {
            e.target.value = "";
        }
    }

    // 2. 페이지 로드 시 초기값 설정 및 이벤트 바인딩
    window.addEventListener('DOMContentLoaded', function() {
        moneyIds.forEach(id => {
            const input = document.getElementById(id);
            if (input) {
                // 초기값 콤마 처리
                if (input.value) {
                    input.value = Number(input.value.replace(/[^\d]/g, "")).toLocaleString('ko-KR');
                }
                // 입력 시 실시간 처리
                input.addEventListener('input', formatNumber);
            }
        });
    });

    // 3. 전송 전 콤마 제거 함수 (서버 에러 방지)
    function prepareSubmit() {
        alert('설정이 성공적으로 변경되었습니다.')
        moneyIds.forEach(id => {
            const input = document.getElementById(id);
            if (input) {
                input.value = input.value.replace(/,/g, ""); // 콤마 제거 후 전송
            }
        });
        return true; // form 제출 진행
    }
</script>

</body>
</html>