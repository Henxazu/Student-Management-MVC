<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Dashboard - Student Management System</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            <style>
                body.dark-theme .navbar {
                    background: #1e293b;
                    border-bottom: 1px solid #334155;
                }

                body.dark-theme .welcome-card,
                body.dark-theme .stat-card,
                body.dark-theme .actions-card {
                    background: #1e293b;
                    color: #f8fafc;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.4);
                }

                body.dark-theme .welcome-card h1,
                body.dark-theme .stat-card .number,
                body.dark-theme .actions-card h2 {
                    color: #f8fafc;
                }

                body.dark-theme .welcome-card p,
                body.dark-theme .stat-card .label {
                    color: #94a3b8;
                }
            </style>
        </head>

        <body class="${cookie.user_theme.value eq 'dark' ? 'dark-theme' : ''}">
            <div class="navbar">
                <h2>Student Management System</h2>
                <div class="nav-right">
                    <span>${sessionScope.fullName}</span>
                    <span class="role-badge role-${sessionScope.role}">${sessionScope.role}</span>
                    <form action="logout" method="post" style="display:inline;">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                        <button type="submit" class="btn-logout">Logout</button>
                    </form>
                    <a href="theme?mode=${cookie.user_theme.value eq 'dark' ? 'light' : 'dark'}">
                        ${cookie.user_theme.value eq 'dark' ? '☀️ Light' : '🌙 Dark'}
                    </a>
                </div>
            </div>
            <div class="container">
                <div class="welcome-card">
                    <h1>${welcomeMessage}</h1>
                    <p>You are signed in as <strong>${sessionScope.role}</strong>.</p>
                </div>
                <div class="stats-row">
                    <div class="stat-card">
                        <div class="number">${totalStudents}</div>
                        <div class="label">Total Students</div>
                    </div>
                </div>
                <div class="actions-card">
                    <h2>Quick Actions</h2>
                    <div class="actions-grid">
                        <a href="student?action=list" class="action-btn action-blue">
                            View All Students
                        </a>
                        <a href="student?action=search" class="action-btn action-orange">
                            Search Students
                        </a>
                        <%-- Add Student is visible only to admin --%>
                            <c:if test="${sessionScope.role eq 'admin'}">
                                <a href="student?action=new" class="action-btn action-green">
                                    Add New Student
                                </a>
                            </c:if>
                    </div>
                </div>
            </div>
        </body>

        </html>