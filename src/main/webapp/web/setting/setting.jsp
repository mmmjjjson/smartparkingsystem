<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <!-- Pretendard 폰트 -->
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
    <title>스마트 주차 관리 시스템 - 설정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="setting.css">
</head>
<body>
<%@ include file="../common/header_other.jsp"%>

<div class="container">
    <div class="title-bar">설정 관리 - 요금 및 할인 정책</div>

    <form action="save_process.jsp" method="post" id="parkingForm" class="setup-area">
        <div class="card">
            <span class="card-label">기본 요금 설정</span>
            <div class="input-row">
                <div class="input-item">
                    <label>기본 주차 요금 수정란 (default: 2,000원)</label>
                    <input type="text" name="baseFee" id="baseFee" placeholder="3000" oninput="syncPreview()">
                </div>
                <div class="input-item">
                    <label>기본 주차 시간 수정란 (default: 60분)</label>
                    <input type="text" name="baseTime" id="baseTime" placeholder="60" oninput="syncPreview()">
                </div>
            </div>
        </div>

        <div class="card">
            <span class="card-label">추가 요금 설정</span>
            <div class="input-row">
                <div class="input-item">
                    <label>추가 요금 수정란 (default: 1,000원)</label>
                    <input type="text" name="addFee" id="addFee" placeholder="1000" oninput="syncPreview()">
                </div>
                <div class="input-item">
                    <label>추가 요금 기준 시간 수정란 (default: 30분)</label>
                    <input type="text" name="addTime" id="addTime" placeholder="30" oninput="syncPreview()">
                </div>
            </div>
        </div>

        <div class="card">
            <span class="card-label">할인율 설정</span>
            <div class="input-row">
                <div class="input-item">
                    <label>경차 할인율 (default: 0.3)</label>
                    <input type="text" name="discountCompact" id="discountCompact" placeholder="0.3" oninput="syncPreview()">
                </div>
                <div class="input-item">
                    <label>장애인 할인율 (default: 0.5)</label>
                    <input type="text" name="discountDisabled" id="discountDisabled" placeholder="0.5" oninput="syncPreview()">
                </div>
            </div>
        </div>
    </form>

    <div class="preview-section">
        <div class="btn-area">
            <span style="color: #4a76c5; font-weight: bold; margin-right: 15px;"></span>
            <button type="button" class="save-btn" onclick="submitForm()">저장</button>
        </div>

        <div class="preview-box">
            <span class="preview-title">현재 설정 미리보기</span>
            <div class="preview-row">
                <span>기본 요금 :</span>
                <span><b id="p-baseFee">3,000</b>원 / <b id="p-baseTime">60</b>분</span>
            </div>
            <div class="preview-row">
                <span>추가 요금 :</span>
                <span><b id="p-addFee">1,000</b>원 / <b id="p-addTime">30</b>분</span>
            </div>
            <div class="preview-row">
                <span>경차 할인 :</span>
                <span><b id="p-discountCompact">30</b>%</span>
            </div>
            <div class="preview-row">
                <span>장애인 할인 :</span>
                <span><b id="p-discountDisabled">50</b>%</span>
            </div>
            <div class="update-info"></div>
        </div>
    </div>
</div>

<script>
    function syncPreview() {
        const baseFee = document.getElementById('baseFee').value || "3000";
        const baseTime = document.getElementById('baseTime').value || "60";
        const addFee = document.getElementById('addFee').value || "1000";
        const addTime = document.getElementById('addTime').value || "30";
        const compact = document.getElementById('discountCompact').value || "0.3";
        const disabled = document.getElementById('discountDisabled').value || "0.5";

        document.getElementById('p-baseFee').innerText = Number(baseFee).toLocaleString();
        document.getElementById('p-baseTime').innerText = baseTime;
        document.getElementById('p-addFee').innerText = Number(addFee).toLocaleString();
        document.getElementById('p-addTime').innerText = addTime;
        document.getElementById('p-discountCompact').innerText = Math.round(parseFloat(compact) * 100);
        document.getElementById('p-discountDisabled').innerText = Math.round(parseFloat(disabled) * 100);
    }

    function submitForm() {
        if (confirm("설정 내용을 저장하시겠습니까?")) {
            alert("데이터베이스에 성공적으로 업데이트되었습니다.");
            // document.getElementById('parkingForm').submit();
        }
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
