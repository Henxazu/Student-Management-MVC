package com.university.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Student implements Serializable {
    private int id;
    private String studentCode;
    private String fullName;
    private String email;
    private String major;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // No-arg constructor
    public Student() {
    }
    // Parameterized constructor
    public Student(String studentCode, String fullName, 
        String email, String major) {
        this.studentCode = studentCode;
        this.fullName = fullName;
        this.email = email;
        this.major = major;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
    
    public String getStudentCode() {
        return studentCode;
    }

    public void setStudentCode(String studentCode) {
        this.studentCode = studentCode;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMajor() {
        return major;
    }

    public void setMajor(String major) {
        this.major = major;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Student{" +
        "id=" + id +
        ", studentCode='" + studentCode + '\'' +
        ", fullName='" + fullName + '\'' +
        ", email='" + email + '\'' +
        ", major='" + major + '\'' +
        '}';
    }
}
