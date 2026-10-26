<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${student != null ? 'Edit' : 'Add'} Student</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>
            <div class="container">
                <h1>${student != null ? 'Edit' : 'Add New'} Student</h1>

                <form method="post" action="student">
                    <input type="hidden" name="action" value="${student != null ? 'update' : 'insert'}">

                    <c:if test="${student != null}">
                        <input type="hidden" name="id" value="${student.id}">
                    </c:if>

                    <div class="form-group">
                        <label for="student_code">Student Code:</label>
                        <input type="text" id="student_code" name="student_code" value="${student.student_code}"
                            required>
                        <span style="color: red;" id="errorStudentCode"></span>
                    </div>

                    <div class="form-group">
                        <label for="full_name">Full Name:</label>
                        <input type="text" id="full_name" name="full_name" value="${student.full_name}" required>
                        <span style="color: red;" id="errorFullName"></span>
                    </div>

                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" value="${student.email}" required>
                        <span style="color: red;" id="errorEmail"></span>
                    </div>

                    <div class="form-group">
                        <label for="major">Major:</label>
                        <select id="major" name="major" required>
                            <option value="">-- Select Major --</option>
                            <span style="color: red;" id="errorMajor"></span>

                            <option value="Computer Science" ${student.major=='Computer Science' ? 'selected' : '' }>
                                Computer Science
                            </option>

                            <option value="Information Technology" ${student.major=='Information Technology'
                                ? 'selected' : '' }>
                                Information Technology
                            </option>

                            <option value="Software Engineering" ${student.major=='Software Engineering' ? 'selected'
                                : '' }>
                                Software Engineering
                            </option>

                            <option value="Data Science" ${student.major=='Data Science' ? 'selected' : '' }>
                                Data Science
                            </option>

                        </select>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">Save</button>
                        <a href="student?action=list" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
            </div>
            <script src="<c:url value='/js/validation.js'/>"></script>
        </body>

        </html>