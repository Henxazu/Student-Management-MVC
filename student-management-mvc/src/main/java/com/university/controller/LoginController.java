package com.university.controller;

import java.io.IOException;
import java.util.UUID;

import com.university.dao.AuditLogger;
import com.university.dao.UserDAO;
import com.university.model.User;
import com.university.util.CookieUtil;
import com.university.util.LoginAttemptTracker;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    /**
     * GET /login — display the login form. If the user already has an
     * authenticated session, skip the form and redirect.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); // do not create a new session
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    /**
     * POST /login — process the login form submission.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Server-side validation — never rely on the browser alone
        if (username == null || username.isBlank()
                || password == null || password.isBlank()) {
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }

        // Check for too many failed login attempts
        if (LoginAttemptTracker.isBlocked(username)) {
            request.setAttribute("error", "Account temporarily locked. Try again later.");
            request.setAttribute("username", username); // pre-fill username field
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.authenticate(username.trim(), password);
        Integer userId = (user != null) ? user.getId() : null;

        if (user != null) {
            AuditLogger.log(userId, "LOGIN_SUCCESS", "User logged in successfully", request);
            // reset failed attempts on successful login
            LoginAttemptTracker.reset(username);

            if ("on".equals(request.getParameter("remember"))) {
                String token = UUID.randomUUID().toString();
                int maxAge = 30 * 24 * 60 * 60; // 30 days
                java.sql.Timestamp expiry = java.sql.Timestamp.from(
                        java.time.Instant.now().plusSeconds(maxAge));
                userDAO.saveToken(user.getId(), token, expiry);
                CookieUtil.set(response, "remember_token", token, maxAge);
            }
            // --- Session fixation protection ---
            // If a session exists from before login (anonymous browsing),
            // destroy it so the attacker cannot reuse the pre-login session ID.
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }

            // Create a brand-new session with a fresh, unpredictable ID
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());
            session.setAttribute("fullName", user.getFullName());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes of inactivity
            session.setAttribute("csrfToken", UUID.randomUUID().toString());

            // Role-based redirect
            String redirect = user.isAdmin() ? "/dashboard" : "/student?action=list";
            response.sendRedirect(request.getContextPath() + redirect);
        } else {
            AuditLogger.log(userId, "LOGIN_FAILURE", "Invalid username or password", request);
            LoginAttemptTracker.recordFailure(username);
            request.setAttribute("error", "Invalid username or password");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}
