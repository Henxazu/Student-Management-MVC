<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Directory - EduManage</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>
    <%-- Navigation bar — insert at the top of <body> --%>
    <div class="navbar">
        <h2>Student Management System</h2>
        <div class="nav-right">
            <span>Welcome, ${sessionScope.fullName}</span>
            <span class="role-badge role-${sessionScope.role}">${sessionScope.role}</span>
            <a href="dashboard">Dashboard</a>
            <a href="logout" class="btn-logout">Logout</a>
        </div>
    </div>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container">
            <!-- Header Section -->
            <div class="page-header">
                <div class="page-title-group">
                    <h1><i class="bi bi-people-fill" style="color:var(--primary);"></i> Student Directory</h1>
                    <p class="page-subtitle">View, search, sort, and manage all enrolled university students</p>
                </div>
                <div class="page-actions">
                    <c:if test="${not empty param.error}">
                        <div class="alert alert-error">${param.error}</div>
                    </c:if>

                    <c:if test="${sessionScope.role eq 'admin'}">
                        <a href="${pageContext.request.contextPath}/student?action=new" class="btn btn-primary">
                            <i class="bi bi-plus-lg"></i> Add New Student
                        </a>
                    </c:if>
                    
                    <a href="${pageContext.request.contextPath}/student?action=export&format=csv" class="btn btn-success">
                        <i class="bi bi-file-earmark-spreadsheet"></i> Export CSV
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/student?action=dashboard" class="btn btn-secondary">
                        <i class="bi bi-pie-chart-fill"></i> Dashboard
                    </a>
                </div>
            </div>

            <!-- Toolbar Card (Search & Page Size) -->
            <div class="toolbar-card">
                <div class="toolbar-row">
                    <!-- Search Form -->
                    <form action="${pageContext.request.contextPath}/student" method="get" class="search-box">
                        <input type="hidden" name="action" value="list">
                        <input type="hidden" name="sort" value="${sort}">
                        <input type="hidden" name="order" value="${order}">
                        <input type="hidden" name="pageSize" value="${pageSize}">
                        <i class="bi bi-search" style="color:var(--text-muted); margin-left:8px; font-size:1rem;"></i>
                        <input type="text" name="search" placeholder="Search by student code, name, email or major..." value="<c:out value='${search}'/>" autocomplete="off">
                        <button type="submit" class="btn btn-sm btn-primary" style="margin-right:2px;">Search</button>
                        <c:if test="${not empty search}">
                            <a href="${pageContext.request.contextPath}/student?action=list&pageSize=${pageSize}&sort=${sort}&order=${order}" class="btn btn-sm btn-secondary" title="Clear Search">
                                <i class="bi bi-x-lg"></i>
                            </a>
                        </c:if>
                    </form>

                    <!-- Page Size Selector -->
                    <form action="${pageContext.request.contextPath}/student" method="get" class="pagesize-control">
                        <input type="hidden" name="action" value="list">
                        <input type="hidden" name="search" value="<c:out value='${search}'/>">
                        <input type="hidden" name="sort" value="${sort}">
                        <input type="hidden" name="order" value="${order}">
                        <input type="hidden" name="page" value="1">
                        <label for="pageSizeSelect">Show:</label>
                        <select id="pageSizeSelect" name="pageSize" class="pagesize-select" onchange="this.form.submit()">
                            <option value="5" ${pageSize == 5 ? 'selected' : ''}>5 per page</option>
                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10 per page</option>
                            <option value="20" ${pageSize == 20 ? 'selected' : ''}>20 per page</option>
                            <option value="50" ${pageSize == 50 ? 'selected' : ''}>50 per page</option>
                        </select>
                    </form>
                </div>

                <!-- Bulk Selection Action Row -->
                <div class="action-bar-row">
                    <div style="font-size:0.9rem; color:var(--text-secondary); font-weight:500;">
                        <c:choose>
                            <c:when test="${not empty search}">
                                Showing results matching "<strong><c:out value='${search}'/></strong>" &bull; <strong>${totalStudents}</strong> student(s) found
                            </c:when>
                            <c:otherwise>
                                Enrolled students database &bull; Total records: <strong>${totalStudents}</strong>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <c:if test="${sessionScope.role eq 'admin'}">
                        <div>
                            <button type="submit" form="bulkForm" id="bulkDeleteBtn" class="btn btn-sm btn-danger" disabled>
                                <i class="bi bi-trash3-fill"></i> Delete Selected (<span id="selectedCount">0</span>)
                            </button>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Table Card -->
            <div class="table-card">
                <form id="bulkForm" action="${pageContext.request.contextPath}/student" method="post">
                    <input type="hidden" name="action" value="confirmBulkDelete">

                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th class="checkbox-col">
                                        <input type="checkbox" id="selectAll" title="Select All Students">
                                    </th>
                                    <th>
                                        <a href="${pageContext.request.contextPath}/student?action=list&sort=id&order=${sort == 'id' ? reverseOrder : 'asc'}&pageSize=${pageSize}&search=<c:out value='${search}'/>" class="sort-header">
                                            ID
                                            <span class="sort-indicator ${sort == 'id' ? 'active' : 'inactive'}">
                                                <i class="bi ${sort == 'id' ? (order == 'desc' ? 'bi-sort-numeric-down-alt' : 'bi-sort-numeric-down') : 'bi-arrow-down-up'}"></i>
                                            </span>
                                        </a>
                                    </th>
                                    <th>
                                        <a href="${pageContext.request.contextPath}/student?action=list&sort=student_code&order=${sort == 'student_code' ? reverseOrder : 'asc'}&pageSize=${pageSize}&search=<c:out value='${search}'/>" class="sort-header">
                                            Student Code
                                            <span class="sort-indicator ${sort == 'student_code' ? 'active' : 'inactive'}">
                                                <i class="bi ${sort == 'student_code' ? (order == 'desc' ? 'bi-sort-alpha-down-alt' : 'bi-sort-alpha-down') : 'bi-arrow-down-up'}"></i>
                                            </span>
                                        </a>
                                    </th>
                                    <th>
                                        <a href="${pageContext.request.contextPath}/student?action=list&sort=full_name&order=${sort == 'full_name' ? reverseOrder : 'asc'}&pageSize=${pageSize}&search=<c:out value='${search}'/>" class="sort-header">
                                            Student Name
                                            <span class="sort-indicator ${sort == 'full_name' ? 'active' : 'inactive'}">
                                                <i class="bi ${sort == 'full_name' ? (order == 'desc' ? 'bi-sort-alpha-down-alt' : 'bi-sort-alpha-down') : 'bi-arrow-down-up'}"></i>
                                            </span>
                                        </a>
                                    </th>
                                    <th>
                                        <a href="${pageContext.request.contextPath}/student?action=list&sort=email&order=${sort == 'email' ? reverseOrder : 'asc'}&pageSize=${pageSize}&search=<c:out value='${search}'/>" class="sort-header">
                                            Email Address
                                            <span class="sort-indicator ${sort == 'email' ? 'active' : 'inactive'}">
                                                <i class="bi ${sort == 'email' ? (order == 'desc' ? 'bi-sort-alpha-down-alt' : 'bi-sort-alpha-down') : 'bi-arrow-down-up'}"></i>
                                            </span>
                                        </a>
                                    </th>
                                    <th>
                                        <a href="${pageContext.request.contextPath}/student?action=list&sort=major&order=${sort == 'major' ? reverseOrder : 'asc'}&pageSize=${pageSize}&search=<c:out value='${search}'/>" class="sort-header">
                                            Major
                                            <span class="sort-indicator ${sort == 'major' ? 'active' : 'inactive'}">
                                                <i class="bi ${sort == 'major' ? (order == 'desc' ? 'bi-sort-alpha-down-alt' : 'bi-sort-alpha-down') : 'bi-arrow-down-up'}"></i>
                                            </span>
                                        </a>
                                    </th>
                                    <th style="text-align: right; padding-right: 24px;">Actions</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach items="${students}" var="student">
                                    <tr id="row-${student.id}">
                                        <td class="checkbox-col">
                                            <input type="checkbox" name="selectedIds" value="${student.id}" class="student-checkbox">
                                        </td>
                                        <td><span style="color:var(--text-muted); font-size:0.85rem; font-weight:600;">#${student.id}</span></td>
                                        <td>
                                            <span class="code-pill">
                                                <i class="bi bi-hash" style="opacity:0.6;"></i>${student.studentCode}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="user-info-cell">
                                                <div class="user-avatar-sm">
                                                    <c:choose>
                                                        <c:when test="${not empty student.fullName}">
                                                            ${fn:toUpperCase(fn:substring(student.fullName, 0, 1))}
                                                        </c:when>
                                                        <c:otherwise>S</c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/student?action=view&id=${student.id}" class="user-name-title">
                                                    ${student.fullName}
                                                </a>
                                            </div>
                                        </td>
                                        <td>
                                            <a href="mailto:${student.email}" style="color:var(--text-secondary); text-decoration:none; font-size:0.9rem; display:inline-flex; align-items:center; gap:6px;">
                                                <i class="bi bi-envelope" style="opacity:0.7;"></i>${student.email}
                                            </a>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${student.major == 'Computer Science'}">
                                                    <span class="badge badge-cs"><i class="bi bi-laptop"></i> ${student.major}</span>
                                                </c:when>
                                                <c:when test="${student.major == 'Information Technology'}">
                                                    <span class="badge badge-it"><i class="bi bi-cpu"></i> ${student.major}</span>
                                                </c:when>
                                                <c:when test="${student.major == 'Software Engineering'}">
                                                    <span class="badge badge-se"><i class="bi bi-code-slash"></i> ${student.major}</span>
                                                </c:when>
                                                <c:when test="${student.major == 'Data Science'}">
                                                    <span class="badge badge-ds"><i class="bi bi-graph-up"></i> ${student.major}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-default"><i class="bi bi-bookmark"></i> ${student.major}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <c:if test="${sessionScope.role eq 'admin'}">
                                            <td style="text-align: right; padding-right: 24px;">
                                                <div class="action-group" style="justify-content: flex-end;">
                                                    <a href="${pageContext.request.contextPath}/student?action=view&id=${student.id}" class="btn btn-sm btn-secondary" title="View Profile">
                                                        <i class="bi bi-eye"></i> View
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/student?action=edit&id=${student.id}" class="btn btn-sm btn-secondary" title="Edit Student">
                                                        <i class="bi bi-pencil"></i> Edit
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/student?action=confirmDelete&id=${student.id}" class="btn btn-sm btn-danger" title="Delete Student">
                                                        <i class="bi bi-trash3"></i> Delete
                                                    </a>
                                                </div>
                                            </td>
                                        </c:if>

                                        <c:if test="${sessionScope.role eq 'user'}">
                                            <td>None</td>
                                        </c:if>
                                        
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </form>

                <!-- Empty State -->
                <c:if test="${empty students}">
                    <div class="empty-state">
                        <div class="empty-icon"><i class="bi bi-person-x"></i></div>
                        <h3 class="empty-title">No matching students found</h3>
                        <p class="empty-desc">
                            <c:choose>
                                <c:when test="${not empty search}">
                                    We couldn't find any student records matching "<strong><c:out value='${search}'/></strong>". Check your spelling or reset the search query.
                                </c:when>
                                <c:otherwise>
                                    Your student database is currently empty. Get started by enrolling your first student!
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <c:choose>
                            <c:when test="${not empty search}">
                                <a href="${pageContext.request.contextPath}/student?action=list" class="btn btn-secondary">
                                    <i class="bi bi-arrow-counterclockwise"></i> Reset Search
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/student?action=new" class="btn btn-primary">
                                    <i class="bi bi-person-plus-fill"></i> Enroll First Student
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <!-- Pagination Section -->
                <c:if test="${not empty students and totalPages > 1}">
                    <div class="pagination-wrapper">
                        <div class="page-info">
                            <c:set var="startIdx" value="${(currentPage - 1) * pageSize + 1}" />
                            <c:set var="endIdx" value="${currentPage * pageSize > totalStudents ? totalStudents : currentPage * pageSize}" />
                            Showing <strong>${startIdx}</strong> &ndash; <strong>${endIdx}</strong> of <strong>${totalStudents}</strong> students
                        </div>

                        <ul class="pagination">
                            <%-- First Page --%>
                            <li>
                                <c:choose>
                                    <c:when test="${currentPage > 1}">
                                        <a href="${pageContext.request.contextPath}/student?action=list&page=1&pageSize=${pageSize}&sort=${sort}&order=${order}&search=<c:out value='${search}'/>" class="page-link" title="First Page">
                                            <i class="bi bi-chevron-double-left"></i>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="page-link disabled"><i class="bi bi-chevron-double-left"></i></span>
                                    </c:otherwise>
                                </c:choose>
                            </li>

                            <%-- Previous Page --%>
                            <li>
                                <c:choose>
                                    <c:when test="${currentPage > 1}">
                                        <a href="${pageContext.request.contextPath}/student?action=list&page=${currentPage - 1}&pageSize=${pageSize}&sort=${sort}&order=${order}&search=<c:out value='${search}'/>" class="page-link" title="Previous Page">
                                            <i class="bi bi-chevron-left"></i>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="page-link disabled"><i class="bi bi-chevron-left"></i></span>
                                    </c:otherwise>
                                </c:choose>
                            </li>

                            <%-- Page Number Links --%>
                            <c:set var="beginPage" value="${currentPage - 2 > 1 ? currentPage - 2 : 1}" />
                            <c:set var="endPage" value="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}" />

                            <c:forEach begin="${beginPage}" end="${endPage}" var="p">
                                <li>
                                    <c:choose>
                                        <c:when test="${p == currentPage}">
                                            <span class="page-link active">${p}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/student?action=list&page=${p}&pageSize=${pageSize}&sort=${sort}&order=${order}&search=<c:out value='${search}'/>" class="page-link">
                                                ${p}
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </li>
                            </c:forEach>

                            <%-- Next Page --%>
                            <li>
                                <c:choose>
                                    <c:when test="${currentPage < totalPages}">
                                        <a href="${pageContext.request.contextPath}/student?action=list&page=${currentPage + 1}&pageSize=${pageSize}&sort=${sort}&order=${order}&search=<c:out value='${search}'/>" class="page-link" title="Next Page">
                                            <i class="bi bi-chevron-right"></i>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="page-link disabled"><i class="bi bi-chevron-right"></i></span>
                                    </c:otherwise>
                                </c:choose>
                            </li>

                            <%-- Last Page --%>
                            <li>
                                <c:choose>
                                    <c:when test="${currentPage < totalPages}">
                                        <a href="${pageContext.request.contextPath}/student?action=list&page=${totalPages}&pageSize=${pageSize}&sort=${sort}&order=${order}&search=<c:out value='${search}'/>" class="page-link" title="Last Page">
                                            <i class="bi bi-chevron-double-right"></i>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="page-link disabled"><i class="bi bi-chevron-double-right"></i></span>
                                    </c:otherwise>
                                </c:choose>
                            </li>
                        </ul>
                    </div>
                </c:if>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="app-footer">
        <div class="container">
            <p>&copy; 2026 EduManage System &bull; Total Enrolled Students: ${totalStudents}</p>
        </div>
    </footer>

    <!-- Interactive Selection Script -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const selectAll = document.getElementById('selectAll');
            const studentCheckboxes = document.querySelectorAll('.student-checkbox');
            const bulkDeleteBtn = document.getElementById('bulkDeleteBtn');
            const selectedCountSpan = document.getElementById('selectedCount');
            const bulkForm = document.getElementById('bulkForm');

            function updateSelectionState() {
                let checkedCount = 0;
                studentCheckboxes.forEach(function (cb) {
                    const row = cb.closest('tr');
                    if (cb.checked) {
                        checkedCount++;
                        if (row) row.classList.add('selected-row');
                    } else {
                        if (row) row.classList.remove('selected-row');
                    }
                });

                if (selectedCountSpan) {
                    selectedCountSpan.textContent = checkedCount;
                }

                if (bulkDeleteBtn) {
                    bulkDeleteBtn.disabled = (checkedCount === 0);
                }

                if (selectAll && studentCheckboxes.length > 0) {
                    if (checkedCount === studentCheckboxes.length) {
                        selectAll.checked = true;
                        selectAll.indeterminate = false;
                    } else if (checkedCount > 0) {
                        selectAll.checked = false;
                        selectAll.indeterminate = true;
                    } else {
                        selectAll.checked = false;
                        selectAll.indeterminate = false;
                    }
                }
            }

            if (selectAll) {
                selectAll.addEventListener('change', function () {
                    const isChecked = selectAll.checked;
                    studentCheckboxes.forEach(function (cb) {
                        cb.checked = isChecked;
                    });
                    updateSelectionState();
                });
            }

            studentCheckboxes.forEach(function (cb) {
                cb.addEventListener('change', updateSelectionState);
            });

            if (bulkForm) {
                bulkForm.addEventListener('submit', function (e) {
                    const checkedCount = document.querySelectorAll('.student-checkbox:checked').length;
                    if (checkedCount === 0) {
                        e.preventDefault();
                        alert('Please select at least one student to delete.');
                        return false;
                    }
                });
            }

            // Initial state check
            updateSelectionState();
        });
    </script>
</body>

</html>
