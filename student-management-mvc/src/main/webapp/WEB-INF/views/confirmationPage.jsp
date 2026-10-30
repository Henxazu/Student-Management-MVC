<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Confirmation</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>
    <div class="container">
        <c:choose>
            <%-- Bulk delete confirmation view --%>
            <c:when test="${not empty students}">
                <h1>Confirm Bulk Deletion</h1>

                <div class="confirmation alert alert-warning">
                    <p style="font-size: 1.1rem; font-weight: 600; margin-bottom: 6px;">
                        Are you sure you want to delete the following <strong>${students.size()}</strong> student(s)?
                    </p>
                    <p style="font-size: 0.925rem; color: #856404;">
                        <strong>Note:</strong> This operation runs in a single database transaction. All selected students will be deleted together, or none if an error occurs.
                    </p>
                </div>

                <table class="table" style="margin-bottom: 25px;">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Student Code</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Major</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${students}" var="s">
                            <tr>
                                <td>${s.id}</td>
                                <td><strong>${s.studentCode}</strong></td>
                                <td>${s.fullName}</td>
                                <td>${s.email}</td>
                                <td>${s.major}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <form action="student" method="post">
                    <input type="hidden" name="action" value="bulkDelete">
                    <c:forEach items="${students}" var="s">
                        <input type="hidden" name="selectedIds" value="${s.id}">
                    </c:forEach>
                    <div class="form-actions">
                        <button type="submit" class="btn btn-danger">Yes, Delete Selected (${students.size()})</button>
                        <a href="student?action=list" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
            </c:when>

            <%-- Single student confirmation view --%>
            <c:when test="${not empty student}">
                <h1>Confirm Student Deletion</h1>

                <div class="card">
                    <h2>Student Information</h2>
                    <p><strong>ID:</strong> ${student.id}</p>
                    <p><strong>Student Code:</strong> ${student.studentCode}</p>
                    <p><strong>Full Name:</strong> ${student.fullName}</p>
                    <p><strong>Email:</strong> ${student.email}</p>
                    <p><strong>Major:</strong> ${student.major}</p>
                </div>

                <div class="confirmation alert alert-warning">
                    <p>Are you sure you want to delete this student?</p>
                </div>

                <div class="form-actions">
                    <a href="student?action=delete&id=${student.id}" class="btn btn-danger">Delete</a>
                    <a href="student?action=list" class="btn btn-secondary">Cancel</a>
                </div>
            </c:when>

            <%-- Fallback when no student found --%>
            <c:otherwise>
                <h1>Delete Confirmation</h1>
                <p class="empty-message">No students selected for deletion.</p>
                <div class="form-actions">
                    <a href="student?action=list" class="btn btn-secondary">Back to Student List</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>

</html>