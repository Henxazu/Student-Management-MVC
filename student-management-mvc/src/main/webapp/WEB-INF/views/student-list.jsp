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
                    <form action="student?action=search" method="get" style="display:inline-block;">
                        <input type="text" name="query" placeholder="Search student..." value="${param.query}" required>
                        <button type="submit" class="btn btn-sm">Search</button>
                        <a href="student?action=list" class="btn btn-sm btn-secondary">Clear</a>
                    </form>
                </div>

                <div class="toolbar">
                    <a href="student?action=new" class="btn btn-primary">Add New Student</a>
                    <a href="student?action=export&format=csv" class="btn btn-success">Export to CSV</a>
                </div>

                <table class="table">
                    <thead>
                        <tr>

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
                            <tr>

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



                <c:if test="${empty students}">
                    <p class="empty-message">No students found.</p>
                </c:if>
            </div>
        </body>

        <script src="${pageContext.request.contextPath}/js/pageSizeControl.js"></script>

        </html>