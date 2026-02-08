<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
            --box-width: 320px;
            --gap: 15px;
        }

        body {
            font-family: 'Malgun Gothic', sans-serif;
            background-color: var(--bg-color);
            margin: 0;
            padding: 0;
            color: #333;
        }

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

        .logout-btn {
            border: 1px solid #333;
            background: #fff;
            padding: 5px 15px;
            cursor: pointer;
        }

        .container {
            width: calc((var(--box-width) * 3) + (var(--gap) * 2) + 42px);
            margin: 20px auto;
            box-sizing: border-box;
        }

        .title-bar {
            background-color: #e9ecef;
            padding: 12px 20px;
            border: 1px solid var(--border-color);
            font-weight: bold;
            margin-bottom: 20px;
        }

        .card {
            background: white;
            border: 1px solid var(--border-color);
            padding: 20px;
            margin-bottom: 20px;
            box-sizing: border-box;
        }

        .card-label {
            display: inline-block;
            font-size: 14px;
            font-weight: bold;
            color: #333;
            margin-bottom: 15px;
            /* 배경과 테두리 삭제 */
            background: none;
            border: none;
            padding: 0;
        }

        .input-row {
            display: flex;
            gap: var(--gap);
        }

        .input-item {
            width: var(--box-width);
            flex: none;
            border: 1px solid var(--border-color);
            padding: 15px;
            background: #fafafa;
            text-align: center;
            min-height: 80px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            box-sizing: border-box;
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
        }

        .content-body {
            display: flex;
            gap: var(--gap);
            width: 100%;
        }

        .setup-area {
            flex: none;
            width: calc((var(--box-width) * 2) + var(--gap) + 42px);
        }

        .preview-section {
            flex: none;
            width: var(--box-width);
        }

        .preview-box {
            background: white;
            border: 2.5px solid var(--main-color);
            padding: 20px;
            margin-bottom: 15px;
            box-sizing: border-box;
        }

        .preview-title {
            font-weight: bold;
            margin-bottom: 15px;
            display: block;
            border-bottom: 1px solid #eee;
            padding-bottom: 8px;
            font-size: 15px;
        }

        .preview-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .preview-row b { color: var(--main-color); }

        .save-btn {
            background-color: var(--main-color);
            color: white;
            padding: 10px 40px;
            border: none;
            font-weight: bold;
            cursor: pointer;
            border-radius: 3px;
            width: 100%;
        }
    </style>
</head>
<body>
<%@ include file="common/header_setting.jsp"%>

<div class="container">
    <div class="title-bar">설정 관리 - 요금 및 할인 정책</div>

    <div class="card">
        <span class="card-label">기본 요금 및 월 주차 설정</span>
        <div class="input-row">
            <div class="input-item">
                <label>기본 주차 요금 수정란</label>
                <input type="text" value="3,000">
            </div>
            <div class="input-item">
                <label>기본 주차 시간 수정란</label>
                <input type="text" value="60">
            </div>
            <div class="input-item">
                <label>월 주차 요금 수정란</label>
                <input type="text" value="100,000">
            </div>
        </div>
    </div>

    <div class="content-body">
        <div class="setup-area">
            <div class="card">
                <span class="card-label">추가 요금 설정</span>
                <div class="input-row">
                    <div class="input-item">
                        <label>추가 요금 수정란</label>
                        <input type="text" value="1,000">
                    </div>
                    <div class="input-item">
                        <label>추가 요금 기준 시간 수정란</label>
                        <input type="text" value="30">
                    </div>
                </div>
            </div>

            <div class="card" style="margin-bottom: 0;">
                <span class="card-label">할인율 설정</span>
                <div class="input-row">
                    <div class="input-item">
                        <label>경차 할인율</label>
                        <input type="text" value="0.3">
                    </div>
                    <div class="input-item">
                        <label>장애인 할인율</label>
                        <input type="text" value="0.5">
                    </div>
                </div>
            </div>
        </div>

        <div class="preview-section">
            <div class="preview-box">
                <span class="preview-title">현재 설정 미리보기</span>
                <div class="preview-row">
                    <span>기본 요금 :</span>
                    <b>3,000원 / 60분</b>
                </div>
                <div class="preview-row">
                    <span>추가 요금 :</span>
                    <b>1,000원 / 30분</b>
                </div>
                <div class="preview-row">
                    <span>월 주차 요금 :</span>
                    <b>100,000원</b>
                </div>
                <div class="preview-row">
                    <span>경차 할인 :</span>
                    <b>30%</b>
                </div>
                <div class="preview-row" style="margin-bottom: 0;">
                    <span>장애인 할인 :</span>
                    <b>50%</b>
                </div>
            </div>
            <button class="save-btn" onclick="alert('저장되었습니다.')">저장</button>
        </div>
    </div>
</div>

</body>
</html>