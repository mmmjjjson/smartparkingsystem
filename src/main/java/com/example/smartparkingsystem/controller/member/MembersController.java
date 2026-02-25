package com.example.smartparkingsystem.controller.member;

import com.example.smartparkingsystem.dao.setting.PaymentInfoDAO;
import com.example.smartparkingsystem.dto.member.MembersDTO;
import com.example.smartparkingsystem.dto.member.PageRequestDTO;
import com.example.smartparkingsystem.dto.member.PageResponseDTO;
import com.example.smartparkingsystem.service.main.ParkingHistoryService;
import com.example.smartparkingsystem.service.member.MembersService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;

import java.io.IOException;
import java.time.LocalDate;

@Log4j2
@WebServlet(name = "membersController", value = {
        "/member_list",
        "/member_check",
        "/member_add",
        "/member_modify"
})
public class MembersController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        MembersService membersService = MembersService.INSTANCE;
        PaymentInfoDAO paymentInfoDAO = new PaymentInfoDAO();
        ParkingHistoryService parkingService = ParkingHistoryService.INSTANCE;
        String requestURI = req.getRequestURI(); // 요청 URI
        String contextPath = req.getContextPath(); // 컨텍스트 경로
        String command = requestURI.substring(contextPath.length()); // 요청 URI에서 컨텍스트 경로를 제거한 명령어

        log.info("requestURI: {}", requestURI);
        log.info("contextPath: {}", contextPath);
        log.info("command: {}", command); // 파일 경로에서 이름을 불러오기 위한 명령어

        HttpSession session = req.getSession();
        // 세션에서 로그인 여부 가져오기
//        String adminId = (String) session.getAttribute("adminId");

        switch (command) {
            case "/member_list" -> { // 회원 관리 메인 목록
                log.info("회원 메인 목록");

                // 로그인을 안 했을 시 -> filter 있으므로 불필요
//                if (adminId == null || adminId.trim().isEmpty()) {
//                    resp.sendRedirect("/login");
//                    return;
//                }

                String pageNumStr = req.getParameter("pageNum");

                if (pageNumStr == null) {
                    String status = req.getParameter("status");
                    String searchType = req.getParameter("searchType");
                    String keyword = req.getParameter("keyword");
                    String from = req.getParameter("from");
                    String carNum = req.getParameter("carNum");

                    StringBuilder redirectURL = new StringBuilder("/member_list?pageNum=1");

                    if (status != null) redirectURL.append("&status=").append(status);
                    if (searchType != null) redirectURL.append("&searchType=").append(searchType);
                    if (keyword != null) redirectURL.append("&keyword=").append(keyword);
                    if (from != null) redirectURL.append("&from=").append(from);
                    if (carNum != null) redirectURL.append("&carNum=").append(carNum);

                    resp.sendRedirect(req.getContextPath() + redirectURL.toString());
                    return;
                }

                String searchType = req.getParameter("searchType");
                String keyword = req.getParameter("keyword");
                String status = req.getParameter("status");

                int pageNum = 1;

                if (req.getParameter("pageNum") != null) {
                    pageNum = Integer.parseInt(req.getParameter("pageNum"));
                }

                // 가져온 파라미터 확인
                log.info("pageNum: {}", pageNum);
                log.info("searchType: {}", searchType);
                log.info("keyword: {}", keyword);
                log.info("status: {}", status);

                PageRequestDTO pageRequestDTO = PageRequestDTO.builder()
                        .searchType(searchType)
                        .keyword(keyword)
                        .status(status)
                        .pageNum(pageNum)
                        .build();

                log.info("회원 목록 조회 서비스 호출");
                PageResponseDTO pageResponseDTO = membersService.getMemberList(pageRequestDTO);
                req.setAttribute("pageResponseDTO", pageResponseDTO);
                log.info("회원 목록 조회 완료 - 총 개수: {}", pageResponseDTO.getTotalCount());

                String openNewMemberModal = req.getParameter("openNewMemberModal");
                String carNum = req.getParameter("carNum");

                req.setAttribute("openNewMemberModal", openNewMemberModal);
                req.setAttribute("prefillCarNum", carNum);

                // 결제 정보 가져오기
                log.info("회원권 요금 조회 시도");

                var paymentInfo = paymentInfoDAO.selectInfo();

                if (paymentInfo != null) {
                    int memberCharge = paymentInfo.getMemberCharge();
                    req.setAttribute("memberCharge", memberCharge);
                    log.info("회원권 요금 조회 성공 - {}", memberCharge);
                } else {
                    log.warn("결제 정보가 존재하지 않습니다.");
                    req.setAttribute("memberCharge", 0);
                }

                RequestDispatcher requestDispatcher = req.getRequestDispatcher("/WEB-INF/members/member_list.jsp");
                requestDispatcher.forward(req, resp);
            }

            case "/member_check" -> { // 기존 회원 여부 확인
                log.info("기존 회원 여부 확인");

                String carNum = req.getParameter("carNum");

                log.info("회원 조회 요청 - 차량번호: {}", carNum);
                MembersDTO membersDTO = membersService.getMemberOne(carNum);

                if (membersDTO != null) {
                    // 기존 회원 있음
                    session.setAttribute("checkResult", "found");
                    session.setAttribute("memberDTO", membersDTO);
                } else {
                    // 기존 회원 없음
                    session.setAttribute("checkResult", "notFound");
                    session.setAttribute("searchCarNum", carNum);
                }

                if (membersDTO != null) {
                    log.info("기존 회원 존재 - 이름: {}", membersDTO.getMemberName());
                } else {
                    log.info("기존 회원 없음");
                }

                resp.sendRedirect(req.getContextPath() + "/member_list?pageNum=1");
            }

            case "/member_add" -> { // 신규 회원 등록
                log.info("신규 회원 등록");

                String carNum = req.getParameter("carNum");
                String memberName = req.getParameter("memberName");
                String memberPhone = req.getParameter("memberPhone");
                LocalDate startDate = LocalDate.parse(req.getParameter("startDate"));
                LocalDate endDate = LocalDate.parse(req.getParameter("endDate"));
                MembersDTO membersDTO = MembersDTO.builder()
                        .carNum(carNum)
                        .memberName(memberName)
                        .memberPhone(memberPhone)
                        .startDate(startDate)
                        .endDate(endDate)
                        .build();

                log.info("회원 등록 요청 - carNum: {}, name: {}, start: {}, end: {}", carNum, memberName, startDate, endDate);

                membersService.addMember(membersDTO);
                parkingService.changeIsMemberState(carNum);

                session = req.getSession();
                session.removeAttribute("searchCarNum");

                log.info("회원 등록 완료");

                String message = "true".equals(req.getParameter("isExistingMember"))
                        ? "회원권이 연장되었습니다."
                        : "회원이 등록되었습니다.";
                session.setAttribute("flashMsg", message);

                resp.sendRedirect(req.getContextPath() + "/member_list");
            }

            case "/member_modify" -> { // 회원 정보 수정
                log.info("회원 정보 수정");

                Long mno = Long.parseLong(req.getParameter("mno"));
                String carNum = req.getParameter("carNum");
                String memberName = req.getParameter("memberName");
                String memberPhone = req.getParameter("memberPhone");

                MembersDTO membersDTO = MembersDTO.builder()
                        .mno(mno)
                        .carNum(carNum)
                        .memberName(memberName)
                        .memberPhone(memberPhone)
                        .build();

                log.info("회원 수정 요청 - mno: {}, carNum: {}", mno, carNum);

                membersService.modifyMember(membersDTO);

                session = req.getSession();
                session.setAttribute("flashMsg", "회원 정보가 수정되었습니다.");

                log.info("회원 수정 완료 - mno: {}", mno);

                resp.sendRedirect(req.getContextPath() + "/member_list");
            }

            default -> {
                log.warn("정의되지 않은 요청: {}", command);
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        }
    }
}