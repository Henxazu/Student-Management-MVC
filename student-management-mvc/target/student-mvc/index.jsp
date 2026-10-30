<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Management System - MVC</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>
    <!-- Top Navigation -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/index.jsp" class="nav-brand">
                <span class="nav-brand-icon"><i class="bi bi-mortarboard-fill"></i></span>
                <span>EduManage MVC</span>
            </a>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/student?action=list" class="nav-link"><i class="bi bi-people"></i> Students</a></li>
                <li><a href="${pageContext.request.contextPath}/student?action=new" class="nav-link"><i class="bi bi-person-plus"></i> Add Student</a></li>
                <li><a href="${pageContext.request.contextPath}/student?action=dashboard" class="nav-link"><i class="bi bi-pie-chart"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/student?action=export&format=csv" class="nav-link"><i class="bi bi-file-earmark-spreadsheet"></i> Export</a></li>
            </ul>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container">
            <!-- Hero Banner -->
            <div class="hero">
                <h1><i class="bi bi-mortarboard-fill"></i> University Student Portal</h1>
                <p>A streamlined Model-View-Controller web application for managing student records, enrollment tracking, bulk actions, and academic analytics.</p>
                <div class="hero-actions">
                    <a href="${pageContext.request.contextPath}/student?action=list" class="btn btn-primary" style="background:#fff; color:var(--primary); font-weight:600;">
                        <i class="bi bi-people-fill"></i> View All Students
                    </a>
                    <a href="${pageContext.request.contextPath}/student?action=new" class="btn btn-secondary" style="background:rgba(255,255,255,0.15); color:#fff; border-color:rgba(255,255,255,0.3);">
                        <i class="bi bi-person-plus-fill"></i> Add New Student
                    </a>
                    <a href="${pageContext.request.contextPath}/student?action=dashboard" class="btn btn-secondary" style="background:rgba(255,255,255,0.15); color:#fff; border-color:rgba(255,255,255,0.3);">
                        <i class="bi bi-graph-up-arrow"></i> Analytics Dashboard
                    </a>
                </div>
            </div>

            <!-- Quick Feature Cards -->
            <div class="features-grid">
                <a href="${pageContext.request.contextPath}/student?action=list" class="feature-card">
                    <div class="feature-icon feature-icon-blue">
                        <i class="bi bi-table"></i>
                    </div>
                    <h3>Student Directory</h3>
                    <p>Search by keyword, sort by column, customize page sizes, and manage full student information with clean pagination.</p>
                </a>

                <a href="${pageContext.request.contextPath}/student?action=new" class="feature-card">
                    <div class="feature-icon feature-icon-green">
                        <i class="bi bi-person-check"></i>
                    </div>
                    <h3>Student Enrollment</h3>
                    <p>Quickly enroll new students with real-time validation for student codes, names, email addresses, and academic majors.</p>
                </a>

                <a href="${pageContext.request.contextPath}/student?action=dashboard" class="feature-card">
                    <div class="feature-icon feature-icon-purple">
                        <i class="bi bi-bar-chart-line"></i>
                    </div>
                    <h3>Analytics Dashboard</h3>
                    <p>Gain insights with interactive Chart.js visualizations for major distributions and historical monthly enrollment trends.</p>
                </a>

                <a href="${pageContext.request.contextPath}/student?action=export&format=csv" class="feature-card">
                    <div class="feature-icon feature-icon-amber">
                        <i class="bi bi-cloud-arrow-down"></i>
                    </div>
                    <h3>Data Export</h3>
                    <p>Download university student records in UTF-8 formatted CSV files compatible with Excel and modern spreadsheet software.</p>
                </a>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="app-footer">
        <div class="container">
            <p>&copy; 2026 Student Management System (MVC Architecture) &bull; Built with Jakarta EE &amp; JSTL</p>
        </div>
    </footer>
</body>

</html>
