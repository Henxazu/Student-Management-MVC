<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student List</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>
    <div class="container">
        <h1>Student Management System</h1>

        <div class="toolbar">
            <form action="student" method="get" style="display:inline-block;">
                <input type="hidden" name="action" value="search">
                <input type="text" name="query" placeholder="Search student..." value="${param.query}">
                <button type="submit" class="btn btn-sm">Search</button>
                <a href="student?action=list" class="btn btn-sm btn-secondary">Clear</a>
            </form>
        </div>

        <form id="bulkForm" action="student" method="post">
            <input type="hidden" name="action" value="confirmBulkDelete">

            <div class="toolbar-actions">
                <div>
                    <a href="student?action=new" class="btn btn-primary">Add New Student</a>
                    <a href="student?action=export&format=csv" class="btn btn-success">Export to CSV</a>
                    <a href="student?action=dashboard" class="btn btn-secondary">Statistics Dashboard</a>
                </div>
                <div>
                    <button type="submit" id="bulkDeleteBtn" class="btn btn-danger" disabled>
                        Delete Selected (<span id="selectedCount">0</span>)
                    </button>
                </div>
            </div>

            <table class="table">
                <thead>
                    <tr>
                        <th class="checkbox-col">
                            <input type="checkbox" id="selectAll" title="Select All">
                        </th>
                        <th>ID</th>
                        <th>Student Code</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Major</th>
                        <th>Actions</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach items="${students}" var="student">
                        <tr id="row-${student.id}">
                            <td class="checkbox-col">
                                <input type="checkbox" name="selectedIds" value="${student.id}" class="student-checkbox">
                            </td>
                            <td>${student.id}</td>
                            <td>${student.studentCode}</td>
                            <td>${student.fullName}</td>
                            <td>${student.email}</td>
                            <td>${student.major}</td>
                            <td>
                                <a href="student?action=view&id=${student.id}" class="btn btn-sm">View</a>
                                <a href="student?action=edit&id=${student.id}" class="btn btn-sm">Edit</a>
                                <a href="student?action=confirmDelete&id=${student.id}"
                                    class="btn btn-sm btn-danger">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </form>

        <c:if test="${empty students}">
            <p class="empty-message">No students found.</p>
        </c:if>
    </div>

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

            // Initial state
            updateSelectionState();
        });
    </script>
</body>

</html>