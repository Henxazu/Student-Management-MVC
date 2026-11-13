package com.university.controller;

import java.io.IOException;

import com.university.dao.AuditLogger;
import com.university.dao.UserDAO;
import com.university.model.User;
import com.university.util.CookieUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Block GET requests to state-changing logout endpoint
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Logout requires POST");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String sessionToken = (String) session.getAttribute("csrfToken");
        String formToken = request.getParameter("csrfToken");
        if (sessionToken == null || !sessionToken.equals(formToken)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
            return;
        }

        User user = (User) session.getAttribute("user");
        Integer userId = (user != null) ? user.getId() : null;

        String rememberToken = CookieUtil.get(request, "remember_token");
        if (rememberToken != null) {
            new UserDAO().deleteToken(rememberToken);
        }
        CookieUtil.delete(response, "remember_token");

        session.invalidate();
        AuditLogger.log(userId, "LOGOUT", "User logged out", request);

        response.sendRedirect(
                request.getContextPath() + "/login?message=You+have+been+logged+out");
    }
}
