package com.university.filter;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import com.university.dao.AuditLogger;
import com.university.model.User;

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
 * AdminFilter — applied only to /student requests. Certain actions (create,
 * update, delete) require the admin role. Read-only actions (list, view,
 * search) are available to all authenticated users.
 */
@WebFilter(filterName = "AdminFilter", urlPatterns = {"/student"})
public class AdminFilter implements Filter {

    private static final List<String> WRITE_ACTIONS = Arrays.asList(
            "new", "insert", "edit", "update", "delete",
            "confirmDelete", "confirmBulkDelete", "bulkDelete");

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpReq = (HttpServletRequest) request;
        HttpServletResponse httpResp = (HttpServletResponse) response;
        String action = httpReq.getParameter("action");

        if (!isWriteAction(action)) {
            // Read-only action — allow any authenticated user (AuthFilter already
            // verified that a session exists, so no need to check again)
            chain.doFilter(request, response);
            return;
        }

        // Write action — must be admin
        HttpSession session = httpReq.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        Integer userId = (user != null) ? user.getId() : null;

        if (user != null && user.isAdmin()) {
            chain.doFilter(request, response);
        } else {
            AuditLogger.log(userId, "UNAUTHORIZED_ACCESS", "Attempted to perform admin action: " + action, httpReq);
            // Block and redirect with an error message
            String username = (user != null) ? user.getUsername() : "anonymous";
            System.err.printf("[AUDIT] %s | UNAUTHORIZED | user=%s | action=%s%n",
                    java.time.LocalDateTime.now(), username, action);

            String redirectUrl = httpReq.getContextPath()
                    + "/student?action=list&error=Access+denied:+admin+privileges+required";
            httpResp.sendRedirect(redirectUrl);
        }
    }

    private boolean isWriteAction(String action) {
        return action != null && WRITE_ACTIONS.contains(action);
    }

    @Override
    public void init(FilterConfig filterConfig) {
        System.out.println("[AdminFilter] initialized");
    }

    @Override
    public void destroy() {
        System.out.println("[AdminFilter] destroyed");
    }
}
