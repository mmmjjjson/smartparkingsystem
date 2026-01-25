<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <style>
        /* CSS 스타일: 화면의 디자인을 담당합니다 */
        :root {
            --main-color: #4a76c5; /* 이미지의 강조 파란색 */
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

        /* 상단 바 */
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

        /* 중앙 컨텐츠 레이아웃 */
        .container {
            max-width: 1100px;
            margin: 20px auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: 1.8fr 1fr; /* 좌측 설정 1.8 : 우측 미리보기 1 */
            gap: 25px;
        }

        .title-bar {
            grid-column: span 2;
            background-color: #e9ecef;
            padding: 12px 20px;
            border: 1px solid var(--border-color);
            font-weight: bold;
            margin-bottom: 10px;
        }

        /* 설정 카드 섹션 */
        .card {
            background: white;
            border: 1px solid var(--border-color);
            padding: 20px;
            margin-bottom: 20px;
        }

        .card-label {
            display: inline-block;
            background: #eee;
            padding: 4px 12px;
            border: 1px solid #ccc;
            font-size: 13px;
            margin-bottom: 15px;
        }

        .input-row {
            display: flex;
            gap: 15px;
        }

        .input-item {
            flex: 1;
            border: 1px solid var(--border-color);
            padding: 15px;
            background: #fafafa;
            text-align: center;
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
        }

        /* 우측 미리보기 및 저장 */
        .preview-section {
            display: flex;
            flex-direction: column;
        }

        .btn-area {
            text-align: right;
            margin-bottom: 15px;
        }

        .save-btn {
            background-color: var(--main-color);
            color: white;
            padding: 10px 50px;
            border: none;
            font-weight: bold;
            cursor: pointer;
            border-radius: 3px;
        }

        .preview-box {
            background: white;
            border: 2.5px solid var(--main-color);
            padding: 25px;
        }

        .preview-title {
            font-weight: bold;
            margin-bottom: 20px;
            display: block;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }

        .preview-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 15px;
        }

        .preview-row b { color: #000; }

        .update-info {
            margin-top: 30px;
            color: var(--main-color);
            font-weight: bold;
            text-align: center;
            font-size: 14px;
            line-height: 1.6;
        }
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

    <div class="setup-area">
        <div class="card">
            <span class="card-label">기본 요금 설정</span>
            <div class="input-row">
                <div class="input-item">
                    <label>기본 주차 요금 수정란</label>
                    <input type="text" placeholder="default : 2,000원">
                </div>
                <div class="input-item">
                    <label>기본 주차 시간 수정란</label>
                    <input type="text" placeholder="default : 60분">
                </div>
            </div>
        </div>

        <div class="card">
            <span class="card-label">추가 요금 설정</span>
            <div class="input-row">
                <div class="input-item">
                    <label>추가 요금 수정란</label>
                    <input type="text" placeholder="default : 1,000원">
                </div>
                <div class="input-item">
                    <label>추가 요금 기준 시간 수정란</label>
                    <input type="text" placeholder="default : 30분">
                </div>
            </div>
        </div>

        <div class="card">
            <span class="card-label">할인율 설정</span>
            <div class="input-row">
                <div class="input-item">
                    <label>경차 할인율</label>
                    <input type="text" placeholder="default : 0.3">
                </div>
                <div class="input-item">
                    <label>장애인 할인율</label>
                    <input type="text" placeholder="default : 0.5">
                </div>
            </div>
        </div>
    </div>

    <div class="preview-section">
        <div class="btn-area">
            <button class="save-btn" onclick="alert('데이터베이스에 성공적으로 저장되었습니다.')">저장</button>
        </div>

        <div class="preview-box">
            <span class="preview-title">현재 설정 미리보기</span>
            <div class="preview-row">
                <span>기본 요금 :</span>

            </div>
            <div class="preview-row">
                <span>추가 요금 :</span>

            </div>
            <div class="preview-row">
                <span>경차 할인 :</span>

            </div>
            <div class="preview-row">
                <span>장애인 할인 :</span>

            </div>
        </div>
    </div>
</div>

</body>
</html>