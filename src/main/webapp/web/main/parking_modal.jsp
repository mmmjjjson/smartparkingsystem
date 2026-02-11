<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="modal fade" id="parkingModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <!-- 모달 헤더 -->
            <div class="modal-header">
                <h5 class="modal-title">주차 처리</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- 모달 본문 -->
            <div class="modal-body">
                <p id="modal-id" class="fw-bold fs-5"></p> <!-- 구역 -->
                <!-- 입차 모달 -->
                <div id="section-entry" style="display: none;">
                    <div class="mb-3">
                        <label class="form-label">차량 번호</label>
                        <input type="text" id="input-carNum" class="form-control" placeholder="전체 차량번호를 입력하세요.">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">차종 선택</label>
                        <div class="btn-group w-100" role="group">
                            <input type="radio" class="btn-check" name="carType" id="type1" value="일반" checked>
                            <label class="btn btn-outline-primary" for="type1">일반</label>
                            <input type="radio" class="btn-check" name="carType" id="type2" value="경차">
                            <label class="btn btn-outline-primary" for="type2">경차</label>
                            <input type="radio" class="btn-check" name="carType" id="type3" value="장애인">
                            <label class="btn btn-outline-primary" for="type3">장애인</label>
                        </div>
                    </div>
                </div>

                <!-- 출차 모달 -->
                <div id="section-exit" style="display: none;">
                    <table class="table table-sm">
                        <tr><th>차량번호</th><td id="info-car"></td></tr>
                        <tr><th>차종</th><td id="info-type"></td></tr>
                        <tr><th>입차시간</th><td id="info-inTime"></td></tr>
                        <tr><th>출차시간</th><td id="info-outTime"></td></tr>
                        <tr>
                            <th>총 요금</th>
                            <td>
                                <span id="info-totalPrice" class="text-danger fw-bold"></span>
                                <span id="info-isMember" class="text-danger fw-bold" style="margin-left: 5px;"></span>
                            </td>
                        </tr>
                    </table>
                </div>

                <!--출차 -> 영수증 모달 -->
                <div id="section-receipt" style="display: none;">
                    <div class="p-3 border bg-light mt-2" id="receipt-print-area">
                        <h5 class="text-center mb-4">주차 이용 영수증</h5>
                        <div class="d-flex justify-content-between">
                            <span>차량번호:</span>
                            <span id="rec-car"></span>
                        </div>
                        <div class="d-flex flex-column gap-1 mb-2">
                            <div class="d-flex justify-content-between">
                                <span class="text-muted">입차시간:</span>
                                <span id="rec-in" class="fw-bold"></span>
                            </div>
                            <div class="d-flex justify-content-between">
                                <span class="text-muted">출차시간:</span>
                                <span id="rec-out" class="fw-bold"></span>
                            </div>
                        </div>
                        <div class="d-flex justify-content-between">
                            <span>총 이용시간:</span>
                            <span id="rec-totalTime"></span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between">
                            <span>기본요금:</span>
                            <span id="rec-basePrice"></span>
                        </div>
                        <div class="d-flex justify-content-between">
                            <span>추가요금:</span>
                            <span id="rec-extraPrice"></span>
                        </div>
                        <div class="d-flex justify-content-between">
                            <span>할인내역:</span>
                            <span id="rec-discount"></span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between fw-bold fs-5">
                            <span>총 요금:</span>
                            <span id="rec-totalPrice" class="text-primary"></span>
                        </div>
                    </div>
                    <div class="mt-3 d-flex gap-2 d-print-none">
                        <button class="btn btn-dark w-100" onclick="window.print()">출력</button>
                        <button class="btn btn-secondary w-100" id="btn-close-final">정산 완료</button>
                    </div>
                </div>
            </div>

            <!-- 모달 버튼 -->
            <div class="modal-footer">
                <button type="button" class="btn btn-warning me-auto" id="btnMembershipPay" style="display: none;">회원권 결제</button>
                <button type="button" class="btn btn-success" id="modal-action"></button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>
