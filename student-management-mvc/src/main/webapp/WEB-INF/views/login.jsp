<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta name="color-scheme" content="light dark">
            <title>Login - Student Management System</title>
            <style>
                :root {
                    color-scheme: light dark;
                }

                :root:has(body:not(.dark-theme)) {
                    color-scheme: light;
                }

                :root:has(body.dark-theme) {
                    color-scheme: dark;
                }

                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
                    min-height: 100vh;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                }

                .card {
                    background: white;
                    padding: 40px;
                    border-radius: 10px;
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
                    width: 100%;
                    max-width: 400px;
                }

                h1 {
                    color: #2c3e50;
                    font-size: 24px;
                    margin-bottom: 8px;
                    text-align: center;
                }

                .subtitle {
                    color: #7f8c8d;
                    font-size: 14px;
                    text-align: center;
                    margin-bottom:
                        30px;
                }

                .form-group {
                    margin-bottom: 18px;
                }

                label {
                    display: block;
                    margin-bottom: 5px;
                    font-weight: 500;
                    color: #2c3e50;
                    font-size: 14px;
                }

                input[type="text"],
                input[type="password"] {
                    width: 100%;
                    padding: 10px 12px;
                    border: 1px solid #ddd;
                    border-radius: 5px;
                    font-size: 14px;
                    transition: border-color 0.2s;
                }

                input:focus {
                    outline: none;
                    border-color: #3498db;
                }

                .remember-row {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    margin-bottom: 20px;
                    font-size: 14px;
                    color: #555;
                }

                .btn-submit {
                    width: 100%;
                    padding: 11px;
                    background: #3498db;
                    color: white;
                    border: none;
                    border-radius: 5px;
                    font-size: 15px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: background 0.2s;
                }

                .btn-submit:hover {
                    background: #2980b9;
                }

                .alert {
                    padding: 10px 14px;
                    border-radius: 5px;
                    font-size: 13px;
                    margin-bottom: 18px;
                }

                .alert-error {
                    background: #fdecea;
                    color: #c0392b;
                    border: 1px solid #f5c6cb;
                }

                .alert-success {
                    background: #eafaf1;
                    color: #1e8449;
                    border: 1px solid #c3e6cb;
                }

                .demo-box {
                    margin-top: 24px;
                    padding: 12px;
                    background: #f8f9fa;
                    border-radius: 5px;
                    font-size: 12px;
                    color: #555;
                }

                .demo-box strong {
                    display: block;
                    margin-bottom: 6px;
                    color: #333;
                }

                .theme-toggle-row {
                    display: flex;
                    justify-content: flex-end;
                    margin-bottom: 8px;
                }

                .theme-toggle-link {
                    text-decoration: none;
                    font-size: 13px;
                    font-weight: 600;
                    padding: 5px 10px;
                    border-radius: 6px;
                    color: #2c3e50;
                    background: #f1f5f9;
                    border: 1px solid #cbd5e1;
                    transition: background 0.2s;
                }

                .theme-toggle-link:hover {
                    background: #e2e8f0;
                }

                body.dark-theme {
                    background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
                    color: #f8fafc;
                }

                body.dark-theme .card {
                    background: #1e293b;
                    color: #f8fafc;
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
                    border: 1px solid #334155;
                }

                body.dark-theme h1,
                body.dark-theme label {
                    color: #f8fafc;
                }

                body.dark-theme .subtitle,
                body.dark-theme .remember-row {
                    color: #94a3b8;
                }

                body.dark-theme input[type="text"],
                body.dark-theme input[type="password"] {
                    background: #0f172a;
                    color: #f8fafc;
                    border-color: #334155;
                }

                body.dark-theme input:focus {
                    border-color: #3498db;
                }

                body.dark-theme .demo-box {
                    background: #0f172a;
                    color: #94a3b8;
                    border: 1px solid #334155;
                }

                body.dark-theme .demo-box strong {
                    color: #f8fafc;
                }

                body.dark-theme .theme-toggle-link {
                    color: #f8fafc;
                    background: #0f172a;
                    border-color: #334155;
                }

                body.dark-theme .theme-toggle-link:hover {
                    background: #334155;
                }
            </style>
        </head>

        <body class="${cookie.user_theme.value eq 'dark' ? 'dark-theme' : ''}">
            <div class="card">
                <div class="theme-toggle-row">
                    <a href="theme?mode=${cookie.user_theme.value eq 'dark' ? 'light' : 'dark'}" class="theme-toggle-link">
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
                        <form action="login" method="post">
                            <div class="form-group">
                                <label for="username">Username</label>
                                <%-- Retain username value if login failed --%>
                                    <input type="text" id="username" name="username" value="${username}"
                                        placeholder="Enter username" required autofocus>
                            </div>
                            <div class="form-group">
                                <label for="password">Password</label>
                                <input type="password" id="password" name="password" placeholder="Enter password"
                                    required>
                            </div>
                            <div class="remember-row">
                                <input type="checkbox" id="remember" name="remember">
                                <label for="remember" style="margin:0;">Remember me</label>
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