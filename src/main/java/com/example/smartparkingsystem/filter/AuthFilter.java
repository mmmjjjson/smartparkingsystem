package com.example.smartparkingsystem.filter;

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

        String uri = req.getRequestURI();
        String loginPath = "/login";
        String passwordPath = "/password";

        // 제외 폴더 지정
        if (uri.startsWith(loginPath) || uri.startsWith(passwordPath)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            log.info("인증된 세션이 없음 접근 제한");
            resp.sendRedirect("/login");
            return;
        }

        chain.doFilter(request, response);
    }
}
