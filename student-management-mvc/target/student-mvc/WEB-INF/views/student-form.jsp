<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${student != null ? 'Edit Student' : 'Enroll New Student'} - EduManage</title>
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
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
                        <li><a href="${pageContext.request.contextPath}/student?action=list" class="nav-link"><i
                                    class="bi bi-people"></i> Students</a></li>
                        <li><a href="${pageContext.request.contextPath}/student?action=new"
                                class="nav-link ${student == null ? 'active' : ''}"><i class="bi bi-person-plus"></i>
                                Add Student</a></li>
                        <li><a href="${pageContext.request.contextPath}/student?action=dashboard" class="nav-link"><i
                                    class="bi bi-pie-chart"></i> Dashboard</a></li>
                        <li><a href="${pageContext.request.contextPath}/student?action=export&format=csv"
                                class="nav-link"><i class="bi bi-file-earmark-spreadsheet"></i> Export</a></li>
                    </ul>
                </div>
            </nav>

            <!-- Main Content -->
            <main class="main-content">
                <div class="container">
                    <div class="form-card">
                        <div class="card-header"
                            style="border-bottom: 1px solid var(--border); padding-bottom: 16px; margin-bottom: 26px;">
                            <div>
                                <h2 class="card-title">
                                    <i class="bi ${student != null ? 'bi-pencil-square' : 'bi-person-plus-fill'}"
                                        style="color:var(--primary);"></i>
                                    ${student != null ? 'Edit Student Record' : 'Enroll New Student'}
                                </h2>
                                <p style="color:var(--text-secondary); font-size:0.875rem; margin-top:4px;">
                                    ${student != null ? 'Update student demographic and academic information' : 'Fill in
                                    the information below to register a new student'}
                                </p>
                            </div>
                            <a href="${pageContext.request.contextPath}/student?action=list"
                                class="btn btn-sm btn-secondary">
                                <i class="bi bi-arrow-left"></i> Back
                            </a>
                        </div>

                        <form id="student-form" method="post" action="${pageContext.request.contextPath}/student"
                            novalidate>
                            <input type="hidden" name="action" value="${student != null ? 'update' : 'insert'}">

                            <c:if test="${student != null}">
                                <input type="hidden" name="id" value="${student.id}">
                            </c:if>

                            <!-- Student Code -->
                            <div class="form-group">
                                <label for="student_code" class="form-label">
                                    <i class="bi bi-hash" style="color:var(--primary); margin-right:4px;"></i> Student
                                    Code <span class="required">*</span>
                                </label>
                                <input type="text" id="student_code" name="student_code" class="form-control"
                                    value="<c:out value='${student != null ? student.studentCode : \" \"}' />"
                                placeholder="e.g. SV00001, CS10001" required autocomplete="off">
                                <span class="form-help">Pattern: 2 to 6 uppercase letters followed by exactly 5
                                    numbers</span>
                                <span class="form-error" id="errorStudentCode"></span>
                            </div>

                            <!-- Full Name -->
                            <div class="form-group">
                                <label for="full_name" class="form-label">
                                    <i class="bi bi-person" style="color:var(--primary); margin-right:4px;"></i> Full
                                    Name <span class="required">*</span>
                                </label>
                                <input type="text" id="full_name" name="full_name" class="form-control"
                                    value="<c:out value='${student != null ? student.fullName : \" \"}' />"
                                placeholder="e.g. Alexander Hamilton" required autocomplete="name">
                                <span class="form-help">Student's legal full name (2 - 50 characters)</span>
                                <span class="form-error" id="errorFullName"></span>
                            </div>

                            <!-- Email -->
                            <div class="form-group">
                                <label for="email" class="form-label">
                                    <i class="bi bi-envelope" style="color:var(--primary); margin-right:4px;"></i> Email
                                    Address <span class="required">*</span>
                                </label>
                                <input type="email" id="email" name="email" class="form-control"
                                    value="<c:out value='${student != null ? student.email : \" \"}' />"
                                placeholder="e.g. alexander@university.edu" required autocomplete="email">
                                <span class="form-help">Primary email used for academic notifications</span>
                                <span class="form-error" id="errorEmail"></span>
                            </div>

                            <!-- Major -->
                            <div class="form-group">
                                <label for="major" class="form-label">
                                    <i class="bi bi-mortarboard" style="color:var(--primary); margin-right:4px;"></i>
                                    Academic Major <span class="required">*</span>
                                </label>
                                <select id="major" name="major" class="form-control" required>
                                    <option value="">-- Choose Academic Major --</option>
                                    <option value="Computer Science" ${student !=null and
                                        student.major=='Computer Science' ? 'selected' : '' }>
                                        Computer Science (CS)
                                    </option>
                                    <option value="Information Technology" ${student !=null and
                                        student.major=='Information Technology' ? 'selected' : '' }>
                                        Information Technology (IT)
                                    </option>
                                    <option value="Software Engineering" ${student !=null and
                                        student.major=='Software Engineering' ? 'selected' : '' }>
                                        Software Engineering (SE)
                                    </option>
                                    <option value="Data Science" ${student !=null and student.major=='Data Science'
                                        ? 'selected' : '' }>
                                        Data Science (DS)
                                    </option>
                                </select>
                                <span class="form-error" id="errorMajor"></span>
                            </div>

                            <!-- Actions -->
                            <div class="form-actions" style="justify-content: flex-end;">
                                <a href="${pageContext.request.contextPath}/student?action=list"
                                    class="btn btn-secondary">
                                    Cancel
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check2-circle"></i> ${student != null ? 'Save Changes' : 'Enroll
                                    Student'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </main>

            <!-- Footer -->
            <footer class="app-footer">
                <div class="container">
                    <p>&copy; 2026 EduManage System &bull; Secure Student Enrollment Portal</p>
                </div>
            </footer>

            <script src="${pageContext.request.contextPath}/js/validation.js"></script>
        </body>

        </html>