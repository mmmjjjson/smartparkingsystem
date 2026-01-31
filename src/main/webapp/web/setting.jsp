<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>스마트 주차 관리 시스템 - 설정</title>
    <style>
        :root {
            --main-color: #4a76c5;
            --bg-color: #f8f9fa;
            --border-color: #ced4da;
        }

        body {
            font-family: 'Malgun Gothic', sans-serif;
            background-color: var(--bg-color);
            margin: 0;
            padding: 0;
            color: #333;
        }

        /* 상단 네비게이션 */
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
        }
        .nav li.active {
            background-color: var(--main-color);
            color: white;
            border-color: var(--main-color);
        }

        .logout-btn { border: 1px solid #333; background: #fff; padding: 5px 15px; cursor: pointer; }

        /* 컨텐츠 레이아웃 */
        .container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: 1.8fr 1fr;
            gap: 30px;
            font-size: 1.1rem;
        }

        .title-bar {
            grid-column: span 2;
            background-color: #e9ecef;
            padding: 12px 20px;
            border: 1px solid var(--border-color);
            font-weight: bold;
            color: #444;
        }

        .card { background: white; border: 2.5px solid var(--border-color); padding: 17px 28px 28px; margin-bottom: 25px; }
        .card-label { display: inline-block; background: white; padding: 4px 12px 4px 0; border: 1px solid white; font-size: 17px; margin-bottom: 15px; font-weight: bold; }

        /* 클릭시 박스 하이라이트 */
        .card:hover { border: 2.5px solid var(--main-color); margin-bottom: 25px; }

        .input-row { display: flex; gap: 15px; }
        .input-item { flex: 1; border: 1px solid var(--border-color); padding: 20px; background: #fafafa; text-align: center; }
        .input-item label { display: block; font-size: 15px; color: #666; margin-bottom: 12px; font-weight: bold; }
        .input-item input { width: 90%; padding: 12px; border: 1px solid #ccc; text-align: right; font-size: 16px; }

        /* 우측 미리보기 및 저장 */
        .btn-area { text-align: right; margin-bottom: 15px; }
        .save-btn { background-color: var(--main-color); color: white; padding: 10px 50px; border: none; font-weight: bold; cursor: pointer; border-radius: 3px; font-size: 16px; }

        .preview-box { background: white; border: 2.5px solid var(--main-color); padding: 35px; position: relative; }
        .preview-title { font-weight: bold; margin-bottom: 20px; display: block; border-bottom: 1px solid #eee; padding-bottom: 10px; }
        .preview-row { display: flex; justify-content: space-between; margin-bottom: 20px; font-size: 17px; }
        .preview-row b { color: var(--main-color); }

        .update-info { margin-top: 30px; color: var(--main-color); font-weight: bold; font-size: 14px; line-height: 1.6; }
    </style>
</head>
<body>

<div class="header">
    <h1>스마트 주차 관리 시스템</h1>
    <ul class="nav">
        <li>대시보드</li>
        <li>회원 관리</li>
        <li class="active">설정 관리</li>
        <li>통계</li>
    </ul>
    <button class="logout-btn">로그아웃</button>
</div>

<div class="container">
    <div class="title-bar">설정 관리 - 요금 및 할인 정책</div>

    <form action="save_process.jsp" method="post" id="parkingForm" class="setup-area">
        <div class="card">
            <span class="card-label">기본 요금 설정</span>
            <div class="input-row">
                <div class="input-item">
                    <label>기본 주차 요금 수정란 (default: 2,000원)</label>
                    <input type="number" name="baseFee" id="baseFee" placeholder="3000" oninput="syncPreview()">
                </div>
                <div class="input-item">
                    <label>기본 주차 시간 수정란 (default: 60분)</label>
                    <input type="number" name="baseTime" id="baseTime" placeholder="60" oninput="syncPreview()">
                </div>
            </div>
        </div>

        <div class="card">
            <span class="card-label">추가 요금 설정</span>
            <div class="input-row">
                <div class="input-item">
                    <label>추가 요금 수정란 (default: 1,000원)</label>
                    <input type="number" name="addFee" id="addFee" placeholder="1000" oninput="syncPreview()">
                </div>
                <div class="input-item">
                    <label>추가 요금 기준 시간 수정란 (default: 30분)</label>
                    <input type="number" name="addTime" id="addTime" placeholder="30" oninput="syncPreview()">
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
            <span style="color: var(--main-color); font-weight: bold; margin-right: 15px;"></span>
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

            <div class="update-info">

            </div>
        </div>
    </div>
</div>

<script>
    // 입력값에 따라 우측 미리보기를 업데이트하는 함수
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

        // 소수점을 퍼센트로 변환 (예: 0.3 -> 30%)
        document.getElementById('p-discountCompact').innerText = Math.round(parseFloat(compact) * 100);
        document.getElementById('p-discountDisabled').innerText = Math.round(parseFloat(disabled) * 100);
    }

    function submitForm() {
        if(confirm("설정 내용을 저장하시겠습니까?")) {
            alert("데이터베이스에 성공적으로 업데이트되었습니다.");
            // document.getElementById('parkingForm').submit(); // 실제 서버 연동 시 주석 해제
        }
    }
</script>

</body>
</html>