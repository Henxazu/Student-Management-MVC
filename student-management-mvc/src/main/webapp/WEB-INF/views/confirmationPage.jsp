<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="color-scheme" content="light dark">
    <title>Confirm Deletion - EduManage</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/confirmationPage.css">
</head>

<body class="${cookie.user_theme.value eq 'dark' ? 'dark-theme' : ''}">
    <!-- Top Navigation -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-brand">
                <span class="nav-brand-icon"><i class="bi bi-mortarboard-fill"></i></span>
                <span>EduManage</span>
            </a>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/student?action=list" class="nav-link"><i class="bi bi-people"></i> Students</a></li>
                <li><a href="${pageContext.request.contextPath}/student?action=new" class="nav-link"><i class="bi bi-person-plus"></i> Add Student</a></li>
                <li><a href="${pageContext.request.contextPath}/dashboard" class="nav-link"><i class="bi bi-pie-chart"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/student?action=export&format=csv" class="nav-link"><i class="bi bi-file-earmark-spreadsheet"></i> Export</a></li>
                <li><a href="${pageContext.request.contextPath}/theme?mode=${cookie.user_theme.value eq 'dark' ? 'light' : 'dark'}" class="nav-link">${cookie.user_theme.value eq 'dark' ? '☀️ Light' : '🌙 Dark'}</a></li>
            </ul>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container confirm-container">
            <c:choose>
                <%-- Bulk delete confirmation view --%>
                <c:when test="${not empty students}">
                    <div class="page-header">
                        <div class="page-title-group">
                            <h1 class="danger-title"><i class="bi bi-exclamation-triangle-fill"></i> Confirm Bulk Deletion</h1>
                            <p class="page-subtitle">Verify the student records marked for permanent removal</p>
                        </div>
                    </div>

                    <div class="alert alert-danger">
                        <i class="bi bi-shield-exclamation alert-icon"></i>
                        <div>
                            <strong class="alert-heading">
                                Warning: Irreversible Action
                            </strong>
                            You are about to permanently delete <strong>${students.size()}</strong> student record(s).
                            This operation runs within a single database transaction — all selected students will be deleted together, or rolled back if any error occurs.
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
                                            <td><span class="id-badge">#${s.id}</span></td>
                                            <td>
                                                <span class="code-pill">
                                                    <i class="bi bi-hash subtle-icon"></i>${s.studentCode}
                                                </span>
                                            </td>
                                            <td class="name-cell"><c:out value="${s.fullName}" /></td>
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
                        <div class="form-actions">
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
                            <h1 class="danger-title"><i class="bi bi-exclamation-triangle-fill"></i> Confirm Deletion</h1>
                            <p class="page-subtitle">Are you sure you want to delete this student?</p>
                        </div>
                    </div>

                    <div class="alert alert-warning">
                        <i class="bi bi-exclamation-circle-fill alert-icon"></i>
                        <div>
                            <strong>Attention:</strong> Deleting this student will permanently erase all associated academic enrollment records. This action cannot be reversed.
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="bi bi-person-x-fill danger-icon"></i>
                                Student Record Marked for Removal
                            </h3>
                            <span class="badge badge-default">#${student.id}</span>
                        </div>

                        <div class="detail-grid">
                            <div class="detail-item">
                                <div class="detail-label">Student Code</div>
                                <div class="detail-value detail-value-code">
                                    ${student.studentCode}
                                </div>
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

                        <div class="form-actions">
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
                        <p class="empty-desc">No valid student was specified for deletion.</p>
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
            <p>&copy; 2026 EduManage System &bull; Safe Deletion Confirmation</p>
        </div>
    </footer>
</body>

</html>
