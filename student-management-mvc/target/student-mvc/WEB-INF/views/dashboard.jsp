<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib>
            <div class="stat-label">Total Students</div>
            <div class="stat-value">${totalStudents}</div>
            </div>
            <div class="stat-card stat-card-green">
                <div class="stat-label">Majors</div>
                <div class="stat-vuri=" http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
                    <!DOCTYPE html>
                    <html>

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Statistics Dashboard</title>
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
                    </head>

                    <body>
                        <div class="container">
                            <h1>Statistics Dashboard</h1>

                            <div class="toolbar">
                                <a href="student?action=list" class="btn btn-secondary">&larr; Back to Student List</a>
                            </div>

                            <!-- Summary cards -->
                            <div class="stat-cards">
                                <div class="stat-card" alue">${totalMajors}</div>
                            </div>
                            <div class="stat-card stat-card-orange">
                                <div class="stat-label">Added This Month</div>
                                <div class="stat-value">${addedThisMonth}</div>
                            </div>
                            <div class="stat-card stat-card-purple">
                                <div class="stat-label">Added (Last ${growthMonths} Months)</div>
                                <div class="stat-value">${addedInPeriod}</div>
                            </div>
                        </div>

                        <!-- Charts -->
                        <div class="chart-grid">
                            <div class="chart-box">
                                <h2>Students by Major</h2>
                                <c:choose>
                                    <c:when test="${empty majorStats}">
                                        <p class="empty-message">No data available.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="chart-canvas"><canvas id="majorChart"></canvas></div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="chart-box">
                                <h2>Growth Trend (Last ${growthMonths} Months)</h2>
                                <div class="chart-canvas"><canvas id="growthChart"></canvas></div>
                            </div>
                        </div>

                        <!-- Major breakdown table -->
                        <c:if test="${not empty majorStats}">
                            <h2 class="section-title">Major Breakdown</h2>
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Major</th>
                                        <th>Students</th>
                                        <th>Percentage</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${majorStats}" var="entry">
                                        <tr>
                                            <td>
                                                <c:out value="${entry.key}" />
                                            </td>
                                            <td>${entry.value}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${totalStudents > 0}">
                                                        <fmt:formatNumber value="${entry.value * 100.0 / totalStudents}"
                                                            maxFractionDigits="1" />%
                                                    </c:when>
                                                    <c:otherwise>0%</c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:if>
                </div>

                <!-- Server-side chart data (rendered by JSP, read by JS below) -->
                <div id="dashboardData" hidden data-major-labels="<c:out value='${majorLabelsJson}' />"
                    data-major-counts="<c:out value='${majorCountsJson}' />"
                    data-growth-labels="<c:out value='${growthLabelsJson}' />"
                    data-growth-counts="<c:out value='${growthCountsJson}' />"></div>

                <script>
                    const dataEl = document.getElementById('dashboardData').dataset;
                    const majorLabels = JSON.parse(dataEl.majorLabels || '[]');
                    const majorCounts = JSON.parse(dataEl.majorCounts || '[]');
                    const growthLabels = JSON.parse(dataEl.growthLabels || '[]');
                    const growthCounts = JSON.parse(dataEl.growthCounts || '[]');

                    const palette = ['#007bff', '#28a745', '#ffc107', '#dc3545', '#6f42c1',
                        '#17a2b8', '#fd7e14', '#20c997', '#e83e8c', '#6c757d'];

                    // Pie chart: count by major
                    const majorCanvas = document.getElementById('majorChart');
                    if (majorCanvas) {
                        new Chart(majorCanvas, {
                            type: 'pie',
                            data: {
                                labels: majorLabels,
                                datasets: [{
                                    data: majorCounts,
                                    backgroundColor: majorLabels.map((_, i) => palette[i % palette.length]),
                                    borderColor: '#fff',
                                    borderWidth: 2
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                plugins: {
                                    legend: { position: 'right' },
                                    tooltip: {
                                        callbacks: {
                                            label: (ctx) => {
                                                const total = ctx.dataset.data.reduce((a, b) => a + b, 0);
                                                const pct = total ? (ctx.parsed * 100 / total).toFixed(1) : 0;
                                                return ' ' + ctx.label + ': ' + ctx.parsed + ' (' + pct + '%)';
                                            }
                                        }
                                    }
                                }
                            }
                        });
                    }

                    // Bar + line chart: students added per month
                    new Chart(document.getElementById('growthChart'), {
                        data: {
                            labels: growthLabels,
                            datasets: [{
                                type: 'bar',
                                label: 'New Students',
                                data: growthCounts,
                                backgroundColor: 'rgba(0, 123, 255, 0.6)',
                                borderColor: '#007bff',
                                borderWidth: 1,
                                borderRadius: 4
                            }, {
                                type: 'line',
                                label: 'Trend',
                                data: growthCounts,
                                borderColor: '#28a745',
                                backgroundColor: '#28a745',
                                tension: 0.3,
                                fill: false
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            scales: {
                                y: { beginAtZero: true, ticks: { precision: 0 } }
                            }
                        }
                    });
                </script>
                </body>

                </html>