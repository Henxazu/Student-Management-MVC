package com.university.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Locale;
import java.util.Map;
import java.util.List;

import com.university.dao.StudentDAO;
import com.university.model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/student")
public class StudentController extends HttpServlet {
    private StudentDAO studentDAO;

    // Default page size
    private static final int DEFAULT_PAGE_SIZE = 5;

    // Number of months shown in the dashboard growth trend
    private static final int GROWTH_MONTHS = 6;

    // initialization
    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    // DoGet config
    @Override
    public void doGet(HttpServletRequest rq, HttpServletResponse rp)
            throws ServletException, IOException {

        // get action para
        String action = rq.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "dashboard":
                    showDashboard(rq, rp);
                    break;
                case "export":
                    exportCsv(rq, rp);
                    break;
                case "list":
                    listStudents(rq, rp);
                    break;
                case "search":
                    listStudents(rq, rp);
                    break;
                case "view":
                    viewStudent(rq, rp);
                    break;
                case "new":
                    showNewForm(rq, rp);
                    break;
                case "delete":
                    deleteStudent(rq, rp);
                    break;
                case "edit":
                    showEditForm(rq, rp);
                    break;
                case "confirmDelete":
                    showConfirmDelete(rq, rp);
                    break;
                case "confirmBulkDelete":
                    showConfirmBulkDelete(rq, rp);
                    break;
                case "bulkDelete":
                    bulkDeleteStudents(rq, rp);
                    break;
                default:
                    listStudents(rq, rp);
            }
        } catch (SQLException e) {
            throw new ServletException("DB Error", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest rq, HttpServletResponse rp)
            throws ServletException, IOException {
        String action = rq.getParameter("action");

        try {
            if ("insert".equals(action)) {
                insertStudent(rq, rp);
            } else if ("update".equals(action)) {
                updateStudent(rq, rp);
            } else if ("confirmBulkDelete".equals(action)) {
                showConfirmBulkDelete(rq, rp);
            } else if ("bulkDelete".equals(action)) {
                bulkDeleteStudents(rq, rp);
            }
        } catch (SQLException e) {
            throw new ServletException("DB Error", e);
        }
    }

    // STATISTICS DASHBOARD
    private void showDashboard(HttpServletRequest rq, HttpServletResponse rp)
            throws SQLException, ServletException, IOException {
        int totalStudents = studentDAO.getTotalStudents();
        Map<String, Integer> majorStats = studentDAO.getStudentCountByMajor();
        Map<String, Integer> growthStats = studentDAO.getMonthlyGrowth(GROWTH_MONTHS);
        int addedThisMonth = studentDAO.getStudentsAddedThisMonth();

        // Convert "yyyy-MM" keys into readable labels (e.g. "Oct 2026")
        DateTimeFormatter monthFmt = DateTimeFormatter.ofPattern("MMM yyyy", Locale.ENGLISH);
        List<String> growthLabels = new ArrayList<>();
        int addedInPeriod = 0;
        for (Map.Entry<String, Integer> e : growthStats.entrySet()) {
            growthLabels.add(YearMonth.parse(e.getKey()).format(monthFmt));
            addedInPeriod += e.getValue();
        }

        rq.setAttribute("totalStudents", totalStudents);
        rq.setAttribute("totalMajors", majorStats.size());
        rq.setAttribute("addedThisMonth", addedThisMonth);
        rq.setAttribute("addedInPeriod", addedInPeriod);
        rq.setAttribute("growthMonths", GROWTH_MONTHS);
        rq.setAttribute("majorStats", majorStats);

        // JSON arrays consumed by Chart.js
        rq.setAttribute("majorLabelsJson", toJsonStringArray(majorStats.keySet()));
        rq.setAttribute("majorCountsJson", majorStats.values().toString());
        rq.setAttribute("growthLabelsJson", toJsonStringArray(growthLabels));
        rq.setAttribute("growthCountsJson", growthStats.values().toString());

        rq.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(rq, rp);
    }

    // Build a JSON string array safe to embed inside a <script> tag
    private String toJsonStringArray(Collection<String> values) {
        StringBuilder sb = new StringBuilder("[");
        boolean first = true;
        for (String v : values) {
            if (!first) {
                sb.append(",");
            }
            first = false;
            sb.append("\"");
            for (char c : (v == null ? "" : v).toCharArray()) {
                switch (c) {
                    case '"': sb.append("\\\""); break;
                    case '\\': sb.append("\\\\"); break;
                    case '\n': sb.append("\\n"); break;
                    case '\r': sb.append("\\r"); break;
                    case '\t': sb.append("\\t"); break;
                    case '<': sb.append("\\u003c"); break;
                    case '>': sb.append("\\u003e"); break;
                    case '&': sb.append("\\u0026"); break;
                    default:
                        if (c < 0x20) {
                            sb.append(String.format("\\u%04x", (int) c));
                        } else {
                            sb.append(c);
                        }
                }
            }
            sb.append("\"");
        }
        return sb.append("]").toString();
    }

    // EXPORT TO CSV
    private void exportCsv(HttpServletRequest rq, HttpServletResponse rp)
            throws SQLException, IOException, ServletException {
        String format = rq.getParameter("format");
        if (format != null && !"csv".equalsIgnoreCase(format)) {
            listStudents(rq, rp);
            return;
        }

        List<Student> students = studentDAO.getAllStudent();

        rp.setContentType("text/csv; charset=UTF-8");
        rp.setCharacterEncoding("UTF-8");
        rp.setHeader("Content-Disposition", "attachment; filename=\"students.csv\"");
        rp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        rp.setHeader("Pragma", "no-cache");
        rp.setDateHeader("Expires", 0);

        PrintWriter writer = rp.getWriter();
        // UTF-8 BOM so spreadsheet editors like Excel render UTF-8 characters cleanly
        writer.write('\ufeff');

        // CSV Header: student_code,full_name,email,major
        writer.println("student_code,full_name,email,major");

        // CSV Data Rows
        for (Student s : students) {
            writer.print(escapeCsv(s.getStudentCode()));
            writer.print(",");
            writer.print(escapeCsv(s.getFullName()));
            writer.print(",");
            writer.print(escapeCsv(s.getEmail()));
            writer.print(",");
            writer.println(escapeCsv(s.getMajor()));
        }
        writer.flush();
    }

    private String escapeCsv(String value) {
        if (value == null) {
            return "";
        }
        if (value.contains(",") || value.contains("\"") || value.contains("\n") || value.contains("\r")) {
            return "\"" + value.replace("\"", "\"\"") + "\"";
        }
        return value;
    }

    // Show confirmation delete for single student
    private void showConfirmDelete(HttpServletRequest rq, HttpServletResponse rp)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(rq.getParameter("id"));
        Student student = studentDAO.getStudentById(id);
        rq.setAttribute("student", student);
        rq.getRequestDispatcher("/WEB-INF/views/confirmationPage.jsp")
                .forward(rq, rp);
    }

    // Show confirmation delete for multiple selected students
    private void showConfirmBulkDelete(HttpServletRequest rq, HttpServletResponse rp)
            throws SQLException, ServletException, IOException {
        String[] idParams = rq.getParameterValues("selectedIds");
        if (idParams == null || idParams.length == 0) {
            idParams = rq.getParameterValues("id");
        }

        if (idParams == null || idParams.length == 0) {
            rp.sendRedirect("student?action=list");
            return;
        }

        List<Integer> ids = new ArrayList<>();
        for (String idStr : idParams) {
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    ids.add(Integer.parseInt(idStr.trim()));
                } catch (NumberFormatException ignored) {
                }
            }
        }

        if (ids.isEmpty()) {
            rp.sendRedirect("student?action=list");
            return;
        }

        List<Student> students = studentDAO.getStudentsByIds(ids);
        if (students.isEmpty()) {
            rp.sendRedirect("student?action=list");
            return;
        }

        rq.setAttribute("students", students);
        rq.getRequestDispatcher("/WEB-INF/views/confirmationPage.jsp")
                .forward(rq, rp);
    }

    // Combined Search + Pagination + Sort
    private void listStudents(HttpServletRequest rq, HttpServletResponse rp)
            throws SQLException, ServletException, IOException {

        // 1. Search keyword (support both 'search' and 'query' parameters)
        String search = rq.getParameter("search");
        if (search == null) {
            search = rq.getParameter("query");
        }
        if (search != null) {
            search = search.trim();
        }
        if (search != null && search.isEmpty()) {
            search = null;
        }

        // 2. Sorting column and order
        String sortParam = rq.getParameter("sort");
        String sort = "student_code";
        if (sortParam != null) {
            switch (sortParam.toLowerCase().trim()) {
                case "name":
                case "full_name":
                case "fullname":
                    sort = "full_name";
                    break;
                case "email":
                    sort = "email";
                    break;
                case "major":
                    sort = "major";
                    break;
                case "id":
                    sort = "id";
                    break;
                case "student_code":
                case "studentcode":
                default:
                    sort = "student_code";
                    break;
            }
        }

        String order = rq.getParameter("order");
        if (order == null || (!"asc".equalsIgnoreCase(order) && !"desc".equalsIgnoreCase(order))) {
            order = "asc";
        } else {
            order = order.toLowerCase().trim();
        }

        // 3. Page size (default 5 students per page)
        int pageSize = DEFAULT_PAGE_SIZE;
        String pageSizeParam = rq.getParameter("pageSize");
        if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
            try {
                int ps = Integer.parseInt(pageSizeParam.trim());
                if (ps > 0) {
                    pageSize = ps;
                }
            } catch (NumberFormatException ignored) {
                pageSize = DEFAULT_PAGE_SIZE;
            }
        }

        // 4. Calculate total records and total pages
        int totalStudents = studentDAO.getTotalStudents(search);
        int totalPages = (int) Math.ceil((double) totalStudents / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }

        // 5. Page number & edge cases (page < 1, page > maxPage)
        int page = 1;
        String pageParam = rq.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam.trim());
            } catch (NumberFormatException ignored) {
                page = 1;
            }
        }

        // Edge case: page < 1
        if (page < 1) {
            page = 1;
        }
        // Edge case: page > maxPage
        if (page > totalPages) {
            page = totalPages;
        }

        // 6. Fetch paginated, sorted, and filtered students
        List<Student> students = studentDAO.getStudents(page, pageSize, sort, order, search);

        // 7. Set request attributes
        rq.setAttribute("students", students);
        rq.setAttribute("currentPage", page);
        rq.setAttribute("totalPages", totalPages);
        rq.setAttribute("totalStudents", totalStudents);
        rq.setAttribute("pageSize", pageSize);
        rq.setAttribute("sort", sort);
        rq.setAttribute("order", order);
        rq.setAttribute("reverseOrder", "asc".equalsIgnoreCase(order) ? "desc" : "asc");
        rq.setAttribute("search", search != null ? search : "");
        rq.setAttribute("query", search != null ? search : "");

        rq.getRequestDispatcher("/WEB-INF/views/student-list.jsp")
                .forward(rq, rp);
    }

    // List order student
    private void viewStudent(HttpServletRequest rq, HttpServletResponse rp)
            throws SQLException, ServletException, IOException {

        int id = Integer.parseInt(rq.getParameter("id"));
        Student student = studentDAO.getStudentById(id);
        rq.setAttribute("student", student);
        rq.getRequestDispatcher("/WEB-INF/views/student-detail.jsp")
                .forward(rq, rp);
    }

    // Show New Form
    private void showNewForm(HttpServletRequest rq, HttpServletResponse rp)
            throws ServletException, IOException {
        rq.getRequestDispatcher("/WEB-INF/views/student-form.jsp")
                .forward(rq, rp);
    }

    // Show Edit Form
    private void showEditForm(HttpServletRequest rq, HttpServletResponse rp)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(rq.getParameter("id"));
        Student student = studentDAO.getStudentById(id);
        rq.setAttribute("student", student);
        rq.getRequestDispatcher("/WEB-INF/views/student-form.jsp")
                .forward(rq, rp);
    }

    // Insert student
    private void insertStudent(HttpServletRequest rq, HttpServletResponse rp)
            throws SQLException, IOException {
        Student s = new Student();
        s.setFullName(rq.getParameter("full_name"));
        s.setEmail(rq.getParameter("email"));
        s.setStudentCode(rq.getParameter("student_code"));
        s.setMajor(rq.getParameter("major"));

        studentDAO.insertStudent(s);
        rp.sendRedirect("student?action=list");
    }

    // Update
    private void updateStudent(HttpServletRequest rq, HttpServletResponse rp)
            throws SQLException, IOException {
        String studentCode = rq.getParameter("student_code");
        String fullName = rq.getParameter("full_name") != null ? rq.getParameter("full_name") : rq.getParameter("name");
        String email = rq.getParameter("email");
        String major = rq.getParameter("major");
        int id = Integer.parseInt(rq.getParameter("id"));

        Student s = new Student(studentCode, fullName, email, major);
        s.setId(id);

        studentDAO.updateStudent(s);

        rp.sendRedirect("student?action=list");
    }

    // Delete single student
    private void deleteStudent(HttpServletRequest rq, HttpServletResponse rp)
            throws SQLException, IOException {
        int id = Integer.parseInt(rq.getParameter("id"));
        studentDAO.deleteStudent(id);

        rp.sendRedirect("student?action=list");
    }

    // Bulk delete selected students
    private void bulkDeleteStudents(HttpServletRequest rq, HttpServletResponse rp)
            throws SQLException, IOException {
        String[] idParams = rq.getParameterValues("selectedIds");
        if (idParams == null || idParams.length == 0) {
            idParams = rq.getParameterValues("id");
        }

        if (idParams != null && idParams.length > 0) {
            List<Integer> ids = new ArrayList<>();
            for (String idStr : idParams) {
                if (idStr != null && !idStr.trim().isEmpty()) {
                    try {
                        ids.add(Integer.parseInt(idStr.trim()));
                    } catch (NumberFormatException ignored) {
                    }
                }
            }
            if (!ids.isEmpty()) {
                studentDAO.deleteStudents(ids);
            }
        }

        rp.sendRedirect("student?action=list");
    }
}
