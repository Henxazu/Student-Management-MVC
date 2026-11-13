package com.university.controller;

import java.io.IOException;

import com.university.dao.AuditLogger;
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
        // getSession(false) returns null if no session exists — avoids creating one
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // destroys all session data on the server
        }
        // Remove the "remember_me" cookie by setting its max age to 0
        CookieUtil.delete(response, "remember_me");

        // Redirect to login, passing a success message as a query parameter
        response.sendRedirect(
            request.getContextPath() + "/login?message=You+have+been+logged+out");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuditLogger.log(null, "LOGOUT", "User logged out", request);
        HttpSession session = request.getSession(false);
        if (session != null) {
            String sessionToken = (String) session.getAttribute("csrfToken");
            String formToken = request.getParameter("csrfToken");
            if (sessionToken != null && sessionToken.equals(formToken)) {
                session.invalidate();
            }
        }

        CookieUtil.delete(response, "remember_me");

        response.sendRedirect(
            request.getContextPath() + "/login?message=You+have+been+logged+out");
    }
}
