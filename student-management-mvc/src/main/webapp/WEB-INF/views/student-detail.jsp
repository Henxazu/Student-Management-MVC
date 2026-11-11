<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Profile: ${student.fullName} - EduManage</title>
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
            <c:choose>
                <c:when test="${not empty student}">
                    <div class="detail-card">
                        <!-- Profile Header Banner -->
                        <div class="detail-banner">
                            <div class="detail-avatar">
                                <c:choose>
                                    <c:when test="${not empty student.fullName}">
                                        ${fn:toUpperCase(fn:substring(student.fullName, 0, 1))}
                                    </c:when>
                                    <c:otherwise>S</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="detail-header-info">
                                <h2><c:out value="${student.fullName}" /></h2>
                                <p>
                                    <span style="font-family:'JetBrains Mono', monospace; font-weight:600; background:rgba(255,255,255,0.18); padding:3px 10px; border-radius:6px;">
                                        <i class="bi bi-hash"></i>${student.studentCode}
                                    </span>
                                    <span><i class="bi bi-envelope-fill" style="opacity:0.7;"></i> ${student.email}</span>
                                </p>
                            </div>
                        </div>

                        <!-- Profile Body Details Grid -->
                        <div class="detail-body">
                            <div class="detail-grid">
                                <div class="detail-item">
                                    <div class="detail-label"><i class="bi bi-key-fill" style="margin-right:4px;"></i> System Identifier</div>
                                    <div class="detail-value">#${student.id}</div>
                                </div>

                                <div class="detail-item">
                                    <div class="detail-label"><i class="bi bi-person-vcard-fill" style="margin-right:4px;"></i> Student Code</div>
                                    <div class="detail-value" style="font-family:'JetBrains Mono', monospace; color:var(--primary);">
                                        ${student.studentCode}
                                    </div>
                                </div>

                                <div class="detail-item">
                                    <div class="detail-label"><i class="bi bi-person-fill" style="margin-right:4px;"></i> Full Name</div>
                                    <div class="detail-value"><c:out value="${student.fullName}" /></div>
                                </div>

                                <div class="detail-item">
                                    <div class="detail-label"><i class="bi bi-envelope-at-fill" style="margin-right:4px;"></i> Contact Email</div>
                                    <div class="detail-value">
                                        <a href="mailto:${student.email}" style="color:var(--primary); text-decoration:none;">
                                            <c:out value="${student.email}" />
                                        </a>
                                    </div>
                                </div>

                                <div class="detail-item" style="grid-column: 1 / -1;">
                                    <div class="detail-label"><i class="bi bi-mortarboard-fill" style="margin-right:4px;"></i> Academic Program &amp; Major</div>
                                    <div class="detail-value" style="margin-top: 6px;">
                                        <c:choose>
                                            <c:when test="${student.major == 'Computer Science'}">
                                                <span class="badge badge-cs" style="font-size: 0.95rem; padding: 7px 16px;"><i class="bi bi-laptop"></i> ${student.major}</span>
                                            </c:when>
                                            <c:when test="${student.major == 'Information Technology'}">
                                                <span class="badge badge-it" style="font-size: 0.95rem; padding: 7px 16px;"><i class="bi bi-cpu"></i> ${student.major}</span>
                                            </c:when>
                                            <c:when test="${student.major == 'Software Engineering'}">
                                                <span class="badge badge-se" style="font-size: 0.95rem; padding: 7px 16px;"><i class="bi bi-code-slash"></i> ${student.major}</span>
                                            </c:when>
                                            <c:when test="${student.major == 'Data Science'}">
                                                <span class="badge badge-ds" style="font-size: 0.95rem; padding: 7px 16px;"><i class="bi bi-graph-up"></i> ${student.major}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-default" style="font-size: 0.95rem; padding: 7px 16px;"><i class="bi bi-bookmark"></i> ${student.major}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <!-- Actions -->
                            <div class="form-actions" style="justify-content: space-between; margin-top: 36px;">
                                <a href="${pageContext.request.contextPath}/student?action=list" class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> Return to Directory
                                </a>
                                <div style="display: flex; gap: 10px;">
                                    <a href="${pageContext.request.contextPath}/student?action=edit&id=${student.id}" class="btn btn-primary">
                                        <i class="bi bi-pencil-square"></i> Edit Profile
                                    </a>
                                    <a href="${pageContext.request.contextPath}/student?action=confirmDelete&id=${student.id}" class="btn btn-danger">
                                        <i class="bi bi-trash3"></i> Delete Record
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="card empty-state">
                        <div class="empty-icon"><i class="bi bi-exclamation-triangle"></i></div>
                        <h3 class="empty-title">Student Not Found</h3>
                        <p class="empty-desc">The requested student record could not be found or has been removed from the university database.</p>
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
            <p>&copy; 2026 EduManage System &bull; University Student Registry</p>
        </div>
    </footer>
</body>

</html>
