<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Academic Analytics Dashboard - EduManage</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
</head>

<body>
    <!-- Top Navigation -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/index.jsp" class="nav-brand">
                <span class="nav-brand-icon"><i class="bi bi-mortarboard-fill"></i></span>
                <span>EduManage</span>
            </a>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/student?action=list" class="nav-link"><i class="bi bi-people"></i> Students</a></li>
                <li><a href="${pageContext.request.contextPath}/student?action=new" class="nav-link"><i class="bi bi-person-plus"></i> Add Student</a></li>
                <li><a href="${pageContext.request.contextPath}/student?action=dashboard" class="nav-link active"><i class="bi bi-pie-chart"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/student?action=export&format=csv" class="nav-link"><i class="bi bi-file-earmark-spreadsheet"></i> Export</a></li>
            </ul>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container">
            <!-- Header Section -->
            <div class="page-header">
                <div class="page-title-group">
                    <h1><i class="bi bi-pie-chart-fill" style="color:var(--primary);"></i> Academic Analytics Dashboard</h1>
                    <p class="page-subtitle">Real-time statistics on university enrollment and departmental distribution</p>
                </div>
                <div class="page-actions">
                    <a href="${pageContext.request.contextPath}/student?action=list" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Student Directory
                    </a>
                    <a href="${pageContext.request.contextPath}/student?action=export&format=csv" class="btn btn-success">
                        <i class="bi bi-file-earmark-spreadsheet"></i> Export CSV
                    </a>
                </div>
            </div>

            <!-- Summary Stat Cards -->
            <div class="stat-cards">
                <!-- Total Students -->
                <div class="stat-card">
                    <div style="display:flex; justify-content:space-between; align-items:flex-start;">
                        <div>
                            <div class="stat-label">Total Enrolled</div>
                            <div class="stat-value">${totalStudents}</div>
                        </div>
                        <i class="bi bi-people-fill" style="font-size:2.5rem; opacity:0.25;"></i>
                    </div>
                </div>

                <!-- Academic Majors -->
                <div class="stat-card stat-card-green">
                    <div style="display:flex; justify-content:space-between; align-items:flex-start;">
                        <div>
                            <div class="stat-label">Active Programs</div>
                            <div class="stat-value">${totalMajors}</div>
                        </div>
                        <i class="bi bi-mortarboard-fill" style="font-size:2.5rem; opacity:0.25;"></i>
                    </div>
                </div>

                <!-- Added This Month -->
                <div class="stat-card stat-card-orange">
                    <div style="display:flex; justify-content:space-between; align-items:flex-start;">
                        <div>
                            <div class="stat-label">New This Month</div>
                            <div class="stat-value">${addedThisMonth}</div>
                        </div>
                        <i class="bi bi-calendar-check-fill" style="font-size:2.5rem; opacity:0.25;"></i>
                    </div>
                </div>

                <!-- Period Growth -->
                <div class="stat-card stat-card-purple">
                    <div style="display:flex; justify-content:space-between; align-items:flex-start;">
                        <div>
                            <div class="stat-label">Past ${growthMonths} Months</div>
                            <div class="stat-value">${addedInPeriod}</div>
                        </div>
                        <i class="bi bi-graph-up-arrow" style="font-size:2.5rem; opacity:0.25;"></i>
                    </div>
                </div>
            </div>

            <!-- Chart Visualizations -->
            <div class="chart-grid">
                <!-- Major Distribution Chart -->
                <div class="chart-box">
                    <h2><i class="bi bi-pie-chart" style="color:var(--primary);"></i> Students by Academic Major</h2>
                    <c:choose>
                        <c:when test="${empty majorStats}">
                            <div class="empty-state" style="padding: 40px 20px;">
                                <div class="empty-icon"><i class="bi bi-bar-chart"></i></div>
                                <p class="empty-title">No enrollment data available</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="chart-canvas">
                                <canvas id="majorChart"></canvas>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Enrollment Trend Chart -->
                <div class="chart-box">
                    <h2><i class="bi bi-graph-up" style="color:var(--success);"></i> Monthly Enrollment Velocity (Past ${growthMonths} Months)</h2>
                    <div class="chart-canvas">
                        <canvas id="growthChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Major Breakdown Table -->
            <c:if test="${not empty majorStats}">
                <div class="table-card">
                    <div class="card-header" style="padding: 22px 28px; border-bottom: 1px solid var(--border);">
                        <h2 class="section-title" style="margin-bottom:0;">
                            <i class="bi bi-table" style="color:var(--primary);"></i> Detailed Departmental Breakdown
                        </h2>
                    </div>
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Academic Major</th>
                                    <th>Total Students</th>
                                    <th>Relative Share</th>
                                    <th style="width: 140px; text-align: right; padding-right: 28px;">Percentage</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${majorStats}" var="entry">
                                    <c:set var="pct" value="${totalStudents > 0 ? (entry.value * 100.0 / totalStudents) : 0}" />
                                    <tr>
                                        <td>
                                            <strong style="color:var(--text-primary); font-size:0.95rem;">
                                                <c:out value="${entry.key}" />
                                            </strong>
                                        </td>
                                        <td>
                                            <strong>${entry.value}</strong> student(s)
                                        </td>
                                        <td>
                                            <div class="progress-track">
                                                <div class="progress-fill" data-progress="<fmt:formatNumber value='${pct}' maxFractionDigits='1' />"></div>
                                            </div>
                                        </td>
                                        <td style="text-align: right; padding-right: 28px;">
                                            <span class="badge badge-default" style="font-weight:700;">
                                                <fmt:formatNumber value="${pct}" maxFractionDigits="1" />%
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>
        </div>
    </main>

    <!-- Server-side chart data -->
    <div id="dashboardData" hidden
        data-major-labels="<c:out value='${majorLabelsJson}' />"
        data-major-counts="<c:out value='${majorCountsJson}' />"
        data-growth-labels="<c:out value='${growthLabelsJson}' />"
        data-growth-counts="<c:out value='${growthCountsJson}' />">
    </div>

    <!-- Footer -->
    <footer class="app-footer">
        <div class="container">
            <p>&copy; 2026 EduManage System &bull; Analytics powered by Chart.js &bull; Clean MVC Architecture</p>
        </div>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const dataEl = document.getElementById('dashboardData').dataset;
            const majorLabels = JSON.parse(dataEl.majorLabels || '[]');
            const majorCounts = JSON.parse(dataEl.majorCounts || '[]');
            const growthLabels = JSON.parse(dataEl.growthLabels || '[]');
            const growthCounts = JSON.parse(dataEl.growthCounts || '[]');

            // Set progress bar widths dynamically
            document.querySelectorAll('.progress-fill').forEach(function (bar) {
                const prog = bar.getAttribute('data-progress') || 0;
                bar.style.width = prog + '%';
            });

            const palette = [
                '#4f46e5', // indigo
                '#10b981', // emerald
                '#f59e0b', // amber
                '#8b5cf6', // purple
                '#06b6d4', // cyan
                '#ec4899', // pink
                '#f97316', // orange
                '#64748b'  // slate
            ];

            // 1. Doughnut chart: Students by Major
            const majorCanvas = document.getElementById('majorChart');
            if (majorCanvas && majorLabels.length > 0) {
                new Chart(majorCanvas, {
                    type: 'doughnut',
                    data: {
                        labels: majorLabels,
                        datasets: [{
                            data: majorCounts,
                            backgroundColor: majorLabels.map((_, i) => palette[i % palette.length]),
                            borderColor: '#ffffff',
                            borderWidth: 3,
                            hoverOffset: 6
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'right',
                                labels: {
                                    boxWidth: 14,
                                    padding: 14,
                                    font: { family: "'Plus Jakarta Sans', sans-serif", size: 12, weight: '600' }
                                }
                            },
                            tooltip: {
                                padding: 12,
                                cornerRadius: 10,
                                bodyFont: { family: "'Plus Jakarta Sans', sans-serif" },
                                callbacks: {
                                    label: function (ctx) {
                                        const total = ctx.dataset.data.reduce((a, b) => a + b, 0);
                                        const pct = total ? (ctx.parsed * 100 / total).toFixed(1) : 0;
                                        return ' ' + ctx.label + ': ' + ctx.parsed + ' (' + pct + '%)';
                                    }
                                }
                            }
                        },
                        cutout: '68%'
                    }
                });
            }

            // 2. Bar + Line chart: Monthly Growth Trend
            const growthCanvas = document.getElementById('growthChart');
            if (growthCanvas) {
                new Chart(growthCanvas, {
                    data: {
                        labels: growthLabels,
                        datasets: [
                            {
                                type: 'bar',
                                label: 'New Enrollments',
                                data: growthCounts,
                                backgroundColor: 'rgba(79, 70, 229, 0.75)',
                                borderColor: '#4f46e5',
                                borderWidth: 1,
                                borderRadius: 8,
                                maxBarThickness: 45
                            },
                            {
                                type: 'line',
                                label: 'Growth Trend',
                                data: growthCounts,
                                borderColor: '#10b981',
                                backgroundColor: 'rgba(16, 185, 129, 0.12)',
                                fill: true,
                                tension: 0.35,
                                pointBackgroundColor: '#10b981',
                                pointRadius: 5,
                                pointHoverRadius: 7
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'top',
                                labels: {
                                    boxWidth: 14,
                                    font: { family: "'Plus Jakarta Sans', sans-serif", size: 12, weight: '600' }
                                }
                            },
                            tooltip: {
                                padding: 12,
                                cornerRadius: 10
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    precision: 0,
                                    font: { family: "'Plus Jakarta Sans', sans-serif", weight: '500' }
                                },
                                grid: {
                                    color: '#f1f5f9'
                                }
                            },
                            x: {
                                ticks: {
                                    font: { family: "'Plus Jakarta Sans', sans-serif", weight: '500' }
                                },
                                grid: {
                                    display: false
                                }
                            }
                        }
                    }
                });
            }
        });
    </script>
</body>

</html>
