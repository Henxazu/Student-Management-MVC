package com.university.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import org.mindrot.jbcrypt.BCrypt;

import com.university.model.User;

public class UserDAO {

    private static final String DB_URL
            = "jdbc:mysql://localhost:3306/student_management";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "210606anhph@n";
    private static final String SQL_AUTH
            = "SELECT * FROM users WHERE username = ? AND is_active = TRUE";
    private static final String SQL_UPDATE_LOGIN
            = "UPDATE users SET last_login = NOW() WHERE id = ?";
    private static final String SQL_BY_ID
            = "SELECT * FROM users WHERE id = ?";

    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC driver not found", e);
        }
    }

    //Token management for "Remember Me" functionality
    public void saveToken(int userId, String token, Timestamp expiry) {
        String sql = "INSERT INTO remember_tokens (user_id, token, expires_at) VALUES (?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.setTimestamp(3, expiry);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public User findUserByToken(String token) {
        String sql = "SELECT u.* FROM users u "
                + "JOIN remember_tokens rt ON u.id = rt.user_id "
                + "WHERE rt.token = ? AND rt.expires_at > NOW() AND u.is_active = TRUE";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void deleteToken(String token) {
        String sql = "DELETE FROM remember_tokens WHERE token = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Verify username and password. Returns the User object if authentication
     * succeeds; null otherwise.
     *
     * The method never reveals whether the username or the password was wrong —
     * returning null for both cases prevents username enumeration attacks.
     */
    public User authenticate(String username, String password) {
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_AUTH)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password");
                    // BCrypt.checkpw extracts the salt from the hash automatically
                    if (BCrypt.checkpw(password, storedHash)) {
                        User user = mapRow(rs);
                        updateLastLogin(user.getId());
                        return user;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // authentication failed
    }

    /**
     * Record the timestamp of a successful login. Called internally by
     * authenticate().
     */
    private void updateLastLogin(int userId) {
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_UPDATE_LOGIN)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Retrieve a user by primary key. Used to restore a User object from a
     * session that stores only the ID.
     */
    public User getUserById(int id) {
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_BY_ID)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();

        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setFullName(rs.getString("full_name"));
        u.setRole(rs.getString("role"));
        u.setActive(rs.getBoolean("is_active"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        u.setLastLogin(rs.getTimestamp("last_login"));

        return u;
    }
}
