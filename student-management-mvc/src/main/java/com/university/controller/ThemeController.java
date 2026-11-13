package com.university.controller;
import java.io.IOException;

import com.university.util.CookieUtil;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/theme")
public class ThemeController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String mode = request.getParameter("mode");
        if ("light".equals(mode) || "dark".equals(mode)) {
            CookieUtil.set(response, "user_theme", mode, 365 * 24 * 60 * 60); // 365 days in seconds
        }
        String referer = request.getHeader("Referer");
        response.sendRedirect(referer != null ? referer : request.getContextPath() + "/dashboard");
    }
}