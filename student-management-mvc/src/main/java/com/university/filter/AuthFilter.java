package com.university.filter;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import com.university.dao.UserDAO;
import com.university.model.User;
import com.university.util.CookieUtil;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * AuthFilter — intercepts every request.
 * Requests to public paths are allowed through unconditionally.
 * Requests to protected paths require an authenticated session.
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = { "/*" })
public class AuthFilter implements Filter {
    // Paths that must be accessible without a session
    private static final List<String> PUBLIC_PATHS = Arrays.asList(
            "/login",
            "/logout");

    // File extensions that must never require authentication
    private static final List<String> PUBLIC_EXTENSIONS = Arrays.asList(
            ".css", ".js", ".png", ".jpg", ".jpeg", ".gif", ".ico", ".woff", ".woff2");

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpReq = (HttpServletRequest) request;
        HttpServletResponse httpResp = (HttpServletResponse) response;

        // Strip context path to get the path within the application
        String contextPath = httpReq.getContextPath();
        String requestURI = httpReq.getRequestURI();
        String path = requestURI.substring(contextPath.length());

        // Static resources and public pages pass through immediately
        if (isPublic(path)) {
            chain.doFilter(request, response);
            return;
        }

        // All other paths require authentication
        HttpSession session = httpReq.getSession(false);
        boolean loggedIn = session != null && session.getAttribute("user") != null;

        if (loggedIn) {
            chain.doFilter(request, response);
        } else {
            String token = CookieUtil.get(httpReq, "remember_token");
            if (token != null) {
                UserDAO userDAO = new UserDAO();
                User user = userDAO.findUserByToken(token);
                if (user != null) {
                    // Valid token found, create a new session and set the user
                    session = httpReq.getSession(true);
                    session.setAttribute("user", user);
                    chain.doFilter(request, response);
                    return;
                }
            }
            // Preserve the originally requested URL so the user can be
            // redirected back after a successful login (optional enhancement)
            httpResp.sendRedirect(contextPath + "/login");
        }
    }

    private boolean isPublic(String path) {
        // Check exact public paths (e.g., /login, /logout)
        for (String pub : PUBLIC_PATHS) {
            if (path.startsWith(pub)) {
                return true;
            }
        }

        // Check static file extensions
        for (String ext : PUBLIC_EXTENSIONS) {
            if (path.endsWith(ext)) {
                return true;
            }
        }
        return false;
    }

    @Override
    public void init(FilterConfig filterConfig) {
        System.out.println("[AuthFilter] initialized");
    }

    @Override
    public void destroy() {
        System.out.println("[AuthFilter] destroyed");
    }
}
