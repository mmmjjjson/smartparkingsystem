package com.example.smartparkingsystem.filter;

import com.example.smartparkingsystem.service.AdminService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;

import java.io.IOException;

@Log4j2
@WebFilter("/*")
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        AdminService adminService = AdminService.INSTANCE;
        String uri = req.getRequestURI();
        String loginPath = "/login";
        String passwordPath = "/password";
        String mypagePath = "/main/mypage";

        if (uri.endsWith(".css") || uri.endsWith(".js") ||
                uri.endsWith(".png") || uri.endsWith(".jpg") ||
                uri.endsWith(".ico")) {
            chain.doFilter(request, response);
            return;
        }

        // 제외 폴더 지정
        if (uri.startsWith(loginPath) || uri.startsWith(passwordPath)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            log.info("인증된 세션이 없음 접근 제한");
            resp.sendRedirect(loginPath);
            return;
        }

        String adminId = (String) session.getAttribute("adminId");
        if (adminService.getAdminById(adminId).isPasswordReset()) {
            if (!uri.startsWith(mypagePath)) {
                resp.sendRedirect(mypagePath);
                return;
            }
        }

        chain.doFilter(request, response);
    }
}
