package com.university.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.university.model.Student;

public class StudentDAO {

    // DB config
    private static final String DB_URL = "jdbc:mysql://localhost:3306/student_management?useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "180706anhph@n";

    // SQL queries
    private static final String SELECT_ALL = "SELECT * FROM students ORDER BY student_code";
    private static final String SELECT_BY_ID = "SELECT * FROM students WHERE id = ?";
    private static final String INSERT_STUDENT = "INSERT INTO students (student_code, full_name, email, major) VALUES (?, ?, ?, ?)";
    private static final String UPDATE_STUDENT = "UPDATE students SET student_code=?, full_name=?, email=?, major=? WHERE id=?";
    private static final String DELETE_STUDENT = "DELETE FROM students WHERE id=?";
    private static final String SEARCH_STUDENT = "SELECT * FROM students WHERE student_code LIKE ? OR full_name LIKE ? OR email LIKE ? OR major LIKE ?";

    // DB Conn
    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL Server not found", e);
        }
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    // Whitelist sort columns to prevent SQL injection
    private String resolveSortColumn(String sortBy) {
        if (sortBy == null) {
            return "student_code";
        }
        switch (sortBy.toLowerCase().trim()) {
            case "name":
            case "full_name":
            case "fullname":
                return "full_name";
            case "email":
                return "email";
            case "major":
                return "major";
            case "id":
                return "id";
            case "student_code":
            case "studentcode":
            default:
                return "student_code";
        }
    }

    // Whitelist sort order to prevent SQL injection
    private String resolveSortOrder(String sortOrder) {
        if ("desc".equalsIgnoreCase(sortOrder)) {
            return "DESC";
        }
        return "ASC";
    }

    // Total student count (with optional search keyword)
    public int getTotalStudents(String keyword) throws SQLException {
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        String sql = hasKeyword
                ? "SELECT COUNT(*) FROM students WHERE student_code LIKE ? OR full_name LIKE ? OR email LIKE ? OR major LIKE ?"
                : "SELECT COUNT(*) FROM students";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (hasKeyword) {
                String pattern = "%" + keyword.trim() + "%";
                stmt.setString(1, pattern);
                stmt.setString(2, pattern);
                stmt.setString(3, pattern);
                stmt.setString(4, pattern);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public int getTotalStudents() throws SQLException {
        return getTotalStudents(null);
    }

    // Requirement 1: Implement getStudents(int page, int pageSize) in DAO using
    // LIMIT and OFFSET
    public List<Student> getStudents(int page, int pageSize) throws SQLException {
        return getStudents(page, pageSize, "student_code", "ASC", null);
    }

    // Combined Pagination + Sorting + Search
    public List<Student> getStudents(int page, int pageSize, String sortBy, String sortOrder, String keyword)
            throws SQLException {
        List<Student> students = new ArrayList<>();

        if (page < 1) {
            page = 1;
        }
        if (pageSize < 1) {
            pageSize = 5;
        }
        int offset = (page - 1) * pageSize;

        String sortCol = resolveSortColumn(sortBy);
        String sortDir = resolveSortOrder(sortOrder);
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

        StringBuilder sql = new StringBuilder("SELECT * FROM students ");
        if (hasKeyword) {
            sql.append("WHERE student_code LIKE ? OR full_name LIKE ? OR email LIKE ? OR major LIKE ? ");
        }
        sql.append("ORDER BY ").append(sortCol).append(" ").append(sortDir).append(" ");
        sql.append("LIMIT ? OFFSET ?");

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (hasKeyword) {
                String pattern = "%" + keyword.trim() + "%";
                stmt.setString(paramIndex++, pattern);
                stmt.setString(paramIndex++, pattern);
                stmt.setString(paramIndex++, pattern);
                stmt.setString(paramIndex++, pattern);
            }
            stmt.setInt(paramIndex++, pageSize);
            stmt.setInt(paramIndex++, offset);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    students.add(extractStudentFromResultSet(rs));
                }
            }
        }
        return students;
    }

    // Searching student
    public List<Student> searchStudent(String query) throws SQLException {
        List<Student> students = new ArrayList<>();

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(SEARCH_STUDENT)) {
            String pattern = "%" + (query != null ? query.trim() : "") + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            stmt.setString(3, pattern);
            stmt.setString(4, pattern);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    students.add(extractStudentFromResultSet(rs));
                }
            }
        }
        return students;
    }

    // Get all students
    public List<Student> getAllStudent() throws SQLException {
        List<Student> students = new ArrayList<>();

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(SELECT_ALL);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                students.add(extractStudentFromResultSet(rs));
            }
        }

        return students;
    }

    // Get student by id
    public Student getStudentById(int id) throws SQLException {
        Student student = null;

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(SELECT_BY_ID)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    student = extractStudentFromResultSet(rs);
                }
            }
        }
        return student;
    }

    // INSERT
    public boolean insertStudent(Student s) throws SQLException {
        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(INSERT_STUDENT)) {
            stmt.setString(1, s.getStudentCode());
            stmt.setString(2, s.getFullName());
            stmt.setString(3, s.getEmail());
            stmt.setString(4, s.getMajor());

            return stmt.executeUpdate() > 0;
        }
    }

    // DELETE
    public boolean deleteStudent(int id) throws SQLException {
        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(DELETE_STUDENT)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    // UPDATE
    public boolean updateStudent(Student s) throws SQLException {
        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(UPDATE_STUDENT)) {
            stmt.setString(1, s.getStudentCode());
            stmt.setString(2, s.getFullName());
            stmt.setString(3, s.getEmail());
            stmt.setString(4, s.getMajor());
            stmt.setInt(5, s.getId());
            return stmt.executeUpdate() > 0;
        }
    }

    // Extract Stu from RS
    private Student extractStudentFromResultSet(ResultSet rs) throws SQLException {
        Student student = new Student();
        student.setId(rs.getInt("id"));
        student.setStudentCode(rs.getString("student_code"));
        student.setFullName(rs.getString("full_name"));
        student.setEmail(rs.getString("email"));
        student.setMajor(rs.getString("major"));
        student.setCreatedAt(rs.getTimestamp("created_at"));
        student.setUpdatedAt(rs.getTimestamp("updated_at"));
        return student;
    }
}