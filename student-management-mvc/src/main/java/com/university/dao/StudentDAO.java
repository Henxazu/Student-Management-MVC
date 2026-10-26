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

    //DB config
    private static final String DB_URL = 
    "jdbc:mysql://localhost:3306/student_management?useSSL=false";
    private static final String DB_USER =
    "root";
    private static final String DB_PASSWORD =
    "180706anhph@n";

    // SQL queries
    private static final String SELECT_ALL =
    "SELECT * FROM students ORDER BY student_code";
    private static final String SELECT_BY_ID =
    "SELECT * FROM students WHERE id = ?";
    private static final String INSERT_STUDENT =
    "INSERT INTO students (student_code, full_name, email, major) VALUES (?, ?, ?,?)";
    private static final String UPDATE_STUDENT =
    "UPDATE students SET student_code=?, full_name=?, email=?, major=? WHERE id=?";
    private static final String DELETE_STUDENT =
    "DELETE FROM students WHERE id=?";

    //DB Conn
    private Connection getConnection() throws SQLException {
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");   
        }catch (ClassNotFoundException e){
            throw  new SQLException ("MySQL Server not found" , e);
        }
        return DriverManager.getConnection(DB_URL,DB_USER,DB_PASSWORD);
    }

    // Get all students
    public List<Student> getAllStudent() throws SQLException{
        List<Student> students = new ArrayList<>();

        try(Connection conn = getConnection();
            PreparedStatement stmt = conn.prepareStatement(SELECT_ALL);
            ResultSet rs = stmt .executeQuery()){
                while(rs.next()){
                    students.add(extractStudentFromResultSet(rs));
                }
            }
        
        return students;
    }

    // Get student by id
    public Student getStudentById(int id) throws SQLException{
        Student student = null;

        try(Connection conn = getConnection();
            PreparedStatement stmt = conn.prepareStatement(SELECT_BY_ID)){

            stmt.setInt(1, id);
            try(ResultSet rs = stmt.executeQuery()){
                if (rs.next()) {
                    student = extractStudentFromResultSet(rs);
                }
            }
        }
        return student;
    }

    //INSERT
    public boolean insertStudent(Student s) throws SQLException{  
        try(Connection conn = getConnection();
            PreparedStatement stmt = conn.prepareStatement(INSERT_STUDENT)){
                stmt.setString(1, s.getStudentCode());
                stmt.setString(2, s.getFullName());
                stmt.setString(3, s.getEmail());
                stmt.setString(4, s.getMajor());
                
                return stmt.executeUpdate() > 0;
            }
    }

    //INSERT
    public boolean deleteStudent(int id) throws SQLException{
        try(Connection conn = getConnection();
            PreparedStatement stmt = conn.prepareStatement(DELETE_STUDENT)){
                stmt.setInt(1,id);
                return stmt.executeUpdate() > 0;
            }
    }

    //UPDATE
    public boolean updateStudent(Student s) throws SQLException{
        try(Connection conn = getConnection();
            PreparedStatement stmt = conn.prepareStatement(UPDATE_STUDENT)){
                stmt.setString(1,s.getStudentCode());
                stmt.setString(1,s.getFullName());
                stmt.setString(1,s.getEmail());
                stmt.setString(1,s.getMajor());
                stmt.setInt(5,s.getId());
                return stmt.executeUpdate() > 0;
            }
    }


    // Extract Stu form RS
    private Student extractStudentFromResultSet(ResultSet rs) throws SQLException{
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