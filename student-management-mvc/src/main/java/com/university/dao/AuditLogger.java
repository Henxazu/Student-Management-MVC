package com.university.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;

import jakarta.servlet.http.HttpServletRequest;

public class AuditLogger {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/student_management?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "210606anhph@n";
    
    private static final String SQL_INSERT
            = "INSERT INTO audit_log (user_id, action_type, description, ip_address) VALUES (?, ?, ?, ?)";

    public static void log(Integer userId, String actionType, String description, HttpServletRequest request) {
        String ipAddress = extractClientIp(request);
        String safeDesc = (description != null && description.length() > 255)
                ? description.substring(0, 255)
                : description;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS); PreparedStatement ps = conn.prepareStatement(SQL_INSERT)) {

                if (userId != null) {
                    ps.setInt(1, userId);
                } else {
                    ps.setNull(1, Types.INTEGER);
                }
                ps.setString(2, actionType);
                ps.setString(3, safeDesc != null ? safeDesc : "");
                ps.setString(4, ipAddress);
                ps.executeUpdate();
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }

    private static String extractClientIp(HttpServletRequest request) {
        if (request == null) {
            return "unknown";
        }
        String forwarded = request.getHeader("X-Forwarded-For");
        if (forwarded != null && !forwarded.isBlank()) {
            return forwarded.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }
}
