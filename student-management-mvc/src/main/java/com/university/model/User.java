package com.university.model;
import java.sql.Timestamp;

public class User {

    private int id;
    private String username;
    private String password; // stores hash only; never expose in responses
    private String fullName;
    private String role; // "admin" or "user"
    private boolean isActive;
    private Timestamp createdAt;
    private Timestamp lastLogin;

    public User() {}

    public User(String username, String password, String fullName, String role) {
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.role = role;
    }

    // Utility methods — avoids string comparison in every JSP and controller
    public boolean isAdmin() {
        return "admin".equalsIgnoreCase(this.role);
    }

    public boolean isUser() {
        return "user".equalsIgnoreCase(this.role);
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String v) { this.username = v; }
    public String getPassword() { return password; }
    public void setPassword(String v) { this.password = v; }
    public String getFullName() { return fullName; }
    public void setFullName(String v) { this.fullName = v; }
    public String getRole() { return role; }
    public void setRole(String v) { this.role = v; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean v) { this.isActive = v; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp v) { this.createdAt = v; }
    public Timestamp getLastLogin() { return lastLogin; }
    public void setLastLogin(Timestamp v) { this.lastLogin = v; }

    @Override
    public String toString() {
        // password deliberately excluded
        return "User{id=" + id + ", username='" + username +
        "', role='" + role + "', isActive=" + isActive + "}";
    }   
}
