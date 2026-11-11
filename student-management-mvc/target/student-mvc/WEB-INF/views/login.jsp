<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Login - Student Management System</title>
            <style>
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
            </style>
        </head>

        <body>
            <div class="card">
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