<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduManage - University Student Management Portal</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>
    <!-- Top Navigation -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/index.jsp" class="nav-brand">
                <span class="nav-brand-icon"><i class="bi bi-mortarboard-fill"></i></span>
                <span>EduManage</span>
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
                <div class="hero-content">
                    <div class="hero-badge">
                        <i class="bi bi-stars"></i> Next-Gen Academic Administration
                    </div>
                    <h1>Empowering University Management</h1>
                    <p>An enterprise-grade Model-View-Controller web platform designed for seamless student enrollment, real-time database tracking, bulk actions, and academic performance analytics.</p>
                    <div class="hero-actions">
                        <a href="${pageContext.request.contextPath}/student?action=list" class="btn btn-primary" style="background:#fff; color:var(--primary); font-weight:700; box-shadow:0 4px 14px rgba(0,0,0,0.15);">
                            <i class="bi bi-people-fill"></i> Launch Student Directory
                        </a>
                        <a href="${pageContext.request.contextPath}/student?action=new" class="btn btn-secondary" style="background:rgba(255,255,255,0.15); color:#fff; border-color:rgba(255,255,255,0.3); backdrop-filter:blur(8px);">
                            <i class="bi bi-person-plus-fill"></i> Enroll New Student
                        </a>
                        <a href="${pageContext.request.contextPath}/student?action=dashboard" class="btn btn-secondary" style="background:rgba(255,255,255,0.15); color:#fff; border-color:rgba(255,255,255,0.3); backdrop-filter:blur(8px);">
                            <i class="bi bi-graph-up-arrow"></i> View Analytics
                        </a>
                    </div>
                </div>
            </div>

            <!-- Quick Feature Cards Grid -->
            <div class="features-grid">
                <a href="${pageContext.request.contextPath}/student?action=list" class="feature-card">
                    <div class="feature-icon feature-icon-blue">
                        <i class="bi bi-table"></i>
                    </div>
                    <h3>Student Directory</h3>
                    <p>Instant search with keyword matching, sortable table columns, configurable page sizes, and full CRUD controls.</p>
                </a>

                <a href="${pageContext.request.contextPath}/student?action=new" class="feature-card">
                    <div class="feature-icon feature-icon-green">
                        <i class="bi bi-person-badge"></i>
                    </div>
                    <h3>Fast Enrollment</h3>
                    <p>Robust client & server validation ensuring strict student code formatting, email verifications, and major selections.</p>
                </a>

                <a href="${pageContext.request.contextPath}/student?action=dashboard" class="feature-card">
                    <div class="feature-icon feature-icon-purple">
                        <i class="bi bi-pie-chart-fill"></i>
                    </div>
                    <h3>Interactive Analytics</h3>
                    <p>Real-time Chart.js visual statistics tracking major distributions and historical monthly enrollment velocity.</p>
                </a>

                <a href="${pageContext.request.contextPath}/student?action=export&format=csv" class="feature-card">
                    <div class="feature-icon feature-icon-amber">
                        <i class="bi bi-file-earmark-arrow-down"></i>
                    </div>
                    <h3>UTF-8 CSV Export</h3>
                    <p>Export complete university records with one click, encoded with UTF-8 BOM for full compatibility with MS Excel.</p>
                </a>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="app-footer">
        <div class="container">
            <p>&copy; 2026 EduManage System &bull; Enterprise MVC Architecture &bull; Jakarta EE &amp; JSTL</p>
        </div>
    </footer>
</body>

</html>
