<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirm Deletion - Student Management</title>
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
        <div class="container" style="max-width: 860px;">
            <c:choose>
                <%-- Bulk delete confirmation view --%>
                <c:when test="${not empty students}">
                    <div class="page-header">
                        <div class="page-title-group">
                            <h1 style="color:var(--danger);"><i class="bi bi-exclamation-triangle-fill"></i> Confirm Bulk Deletion</h1>
                            <p class="page-subtitle">Review the students selected for deletion before continuing</p>
                        </div>
                    </div>

                    <div class="alert alert-danger">
                        <i class="bi bi-shield-exclamation alert-icon"></i>
                        <div>
                            <strong style="font-size:1.05rem; display:block; margin-bottom:4px;">
                                Warning: Irreversible Action
                            </strong>
                            You are about to permanently delete <strong>${students.size()}</strong> student record(s).
                            This operation runs within a single database transaction — all selected students will be removed together.
                        </div>
                    </div>

                    <div class="table-card">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Student Code</th>
                                        <th>Full Name</th>
                                        <th>Email Address</th>
                                        <th>Major</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${students}" var="s">
                                        <tr>
                                            <td><span style="color:var(--text-muted); font-size:0.875rem;">#${s.id}</span></td>
                                            <td><strong style="font-family: monospace; color:var(--primary);">${s.studentCode}</strong></td>
                                            <td style="font-weight:600;"><c:out value="${s.fullName}" /></td>
                                            <td><c:out value="${s.email}" /></td>
                                            <td>
                                                <span class="badge badge-default">${s.major}</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/student" method="post">
                        <input type="hidden" name="action" value="bulkDelete">
                        <c:forEach items="${students}" var="s">
                            <input type="hidden" name="selectedIds" value="${s.id}">
                        </c:forEach>
                        <div class="form-actions" style="justify-content: flex-end;">
                            <a href="${pageContext.request.contextPath}/student?action=list" class="btn btn-secondary">
                                Cancel
                            </a>
                            <button type="submit" class="btn btn-danger">
                                <i class="bi bi-trash3-fill"></i> Permanently Delete (${students.size()}) Students
                            </button>
                        </div>
                    </form>
                </c:when>

                <%-- Single student confirmation view --%>
                <c:when test="${not empty student}">
                    <div class="page-header">
                        <div class="page-title-group">
                            <h1 style="color:var(--danger);"><i class="bi bi-exclamation-triangle-fill"></i> Confirm Deletion</h1>
                            <p class="page-subtitle">Are you sure you want to delete this student?</p>
                        </div>
                    </div>

                    <div class="alert alert-warning">
                        <i class="bi bi-exclamation-circle-fill alert-icon"></i>
                        <div>
                            <strong>Attention:</strong> Deleting a student removes their entire academic record from the database. This action cannot be undone.
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="bi bi-person-x-fill" style="color:var(--danger);"></i>
                                Student Record to be Deleted
                            </h3>
                            <span class="badge badge-default">#${student.id}</span>
                        </div>

                        <div class="detail-grid" style="margin-top: 10px;">
                            <div class="detail-item">
                                <div class="detail-label">Student Code</div>
                                <div class="detail-value" style="font-family: monospace; color:var(--primary);">${student.studentCode}</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Full Name</div>
                                <div class="detail-value"><c:out value="${student.fullName}" /></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Email Address</div>
                                <div class="detail-value"><c:out value="${student.email}" /></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Major</div>
                                <div class="detail-value"><span class="badge badge-default">${student.major}</span></div>
                            </div>
                        </div>

                        <div class="form-actions" style="justify-content: flex-end; margin-top: 24px;">
                            <a href="${pageContext.request.contextPath}/student?action=list" class="btn btn-secondary">
                                Cancel
                            </a>
                            <a href="${pageContext.request.contextPath}/student?action=delete&id=${student.id}" class="btn btn-danger">
                                <i class="bi bi-trash3-fill"></i> Confirm &amp; Delete Student
                            </a>
                        </div>
                    </div>
                </c:when>

                <%-- Fallback when no student found --%>
                <c:otherwise>
                    <div class="card empty-state">
                        <div class="empty-icon"><i class="bi bi-info-circle"></i></div>
                        <h3 class="empty-title">No Student Selected</h3>
                        <p class="empty-desc">No valid student was selected for deletion.</p>
                        <a href="${pageContext.request.contextPath}/student?action=list" class="btn btn-primary">
                            <i class="bi bi-arrow-left"></i> Return to Student Directory
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <!-- Footer -->
    <footer class="app-footer">
        <div class="container">
            <p>&copy; 2026 Student Management System &bull; Safe Deletion Confirmation</p>
        </div>
    </footer>
</body>

</html>
