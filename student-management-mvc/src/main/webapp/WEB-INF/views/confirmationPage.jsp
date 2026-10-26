<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Confirmation</title>
            <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
        </head>

        <body>
            <div class="container">
                <!-- Student information -->
                <div class="card">
                    <h2>Student Information</h2>
                    <p><strong>ID:</strong> ${student.id}</p>
                    <p><strong>Student Code:</strong> ${student.studentCode}</p>
                    <p><strong>Full Name:</strong> ${student.fullName}</p>
                    <p><strong>Email:</strong> ${student.email}</p>
                    <p><strong>Major:</strong> ${student.major}</p>
                </div>

                <!-- Confirmation message -->
                <div class="confirmation">
                    <p>Are you sure you want to delete this student?</p>
                </div>

                <!-- Buttons -->
                <div class="form-actions">
                    <a href="student?action=delete&id=${student.id}" class="btn btn-danger">Delete</a>
                    <a href="student?action=list" class="btn btn-secondary">Cancel</a>
                </div>
            </div>
        </body>

        </html>