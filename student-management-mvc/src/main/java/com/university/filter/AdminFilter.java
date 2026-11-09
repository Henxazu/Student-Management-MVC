package com.university.filter;

import com.university.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * AdminFilter — applied only to /student requests.
 * Certain actions (create, update, delete) require the admin role.
 * Read-only actions (list, view, search) are available to all authenticated
 * users.
 */
@WebFilter(filterName = "AdminFilter", urlPatterns = { "/student" })
public class AdminFilter implements Filter {
    private static final List<String> WRITE_ACTIONS = Arrays.asList(
            "new", "insert", "edit", "update", "delete");

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
        if (user != null && user.isAdmin()) {
            chain.doFilter(request, response);
        } else {
            // Block and redirect with an error message
            String redirectUrl = httpReq.getContextPath() +
                    "/student?action=list&error=Access+denied:+admin+privileges+required";
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