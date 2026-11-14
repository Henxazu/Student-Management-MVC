<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="color-scheme" content="light dark">
    <title>Login - Student Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>

<body class="${cookie.user_theme.value eq 'dark' ? 'dark-theme' : ''}">
    <div class="card">
        <div class="theme-toggle-row">
            <a href="${pageContext.request.contextPath}/theme?mode=${cookie.user_theme.value eq 'dark' ? 'light' : 'dark'}" class="theme-toggle-link">
                ${cookie.user_theme.value eq 'dark' ? '☀️ Light' : '🌙 Dark'}
            </a>
        </div>
        <h1>Login</h1>
        <p class="subtitle">Student Management System</p>
        <%-- Error from failed login attempt --%>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        <%-- Success message from logout (passed as URL parameter) --%>
        <c:if test="${not empty param.message}">
            <div class="alert alert-success">${param.message}</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <%-- Retain username value if login failed --%>
                <input type="text" id="username" name="username" value="<c:out value='${username}'/>"
                    placeholder="Enter username" required autofocus>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter password"
                    required>
            </div>
            <div class="remember-row">
                <input type="checkbox" id="remember" name="remember">
                <label for="remember">Remember me</label>
            </div>
            <button type="submit" class="btn-submit">Sign In</button>
        </form>
        <div class="demo-box">
            <strong>Test credentials</strong>
            Admin: admin / password123<br>
            User: john / password123
        </div>
    </div>
</body>

</html>
