package com.university.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.university.dao.StudentDAO;
import com.university.model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/student")
public class StudentController extends HttpServlet{
    private StudentDAO studentDAO;
    
    //initialization
    @Override 
    public void init(){
        studentDAO = new StudentDAO();
    }

    // DoGet config
    @Override
    public void doGet(HttpServletRequest rq, HttpServletResponse resp)
        throws ServletException, IOException{

        // get action para
        String action = rq.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try{
            switch (action) {
                case "list":
                    listStudents(rq,resp);
                    break;
                case "view":
                    viewStudent(rq,resp);
                    break;
                case "new":
                    showNewForm(rq,resp);
                    break;
                case "delete":
                    deleteStudent(rq,resp);
                    break;
                case "edit":
                    showEditForm(rq,resp);
                    break;
                default:
                    listStudents(rq,resp);
            }
        } catch (SQLException e){
            throw new ServletException("DB Error", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest rq, HttpServletResponse rp)
        throws ServletException, IOException{
            String action = rq.getParameter("action");

            try {
                if("insert".equals(action)){
                    insertStudent(rq, rp);
                }else if("update".equals(action)){
                    updateStudent(rq, rp);
                }
            } catch (SQLException e) {
                throw new ServletException("DB Error", e);
            }
    }


    // List all student
    private void listStudents(HttpServletRequest rq, HttpServletResponse rp)
        throws SQLException, ServletException, IOException{
        
            List<Student> students = studentDAO.getAllStudent();
            rq.setAttribute("students", students);
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
        throws SQLException, ServletException, IOException{
            rq.getRequestDispatcher("/WEB-INF/views/student-new-form.jsp")
            .forward(rq, rp);
    }

    // Show Edit Form
    private void showEditForm(HttpServletRequest rq, HttpServletResponse rp)
        throws SQLException, ServletException, IOException{
            rq.getRequestDispatcher("/WEB-INF/views/student-edit-form.jsp")
            .forward(rq, rp);
    }
    
    //Insert student
    private void insertStudent(HttpServletRequest rq, HttpServletResponse rp)
        throws SQLException, ServletException, IOException{
            Student s = new Student();
            s.setFullName(rq.getParameter("name"));
            s.setEmail(rq.getParameter("email"));
            s.setStudentCode(rq.getParameter("student_code"));
            s.setMajor(rq.getParameter("major"));

            studentDAO.insertStudent(s);
            rp.sendRedirect("student?action=list");
    }

    //Update
    private void updateStudent(HttpServletRequest rq, HttpServletResponse rp)
        throws SQLException, ServletException, IOException{
            String student_code = rq.getParameter("student_code");
            String student_fullName = rq.getParameter("name");
            String student_email = rq.getParameter("email");
            String student_major = rq.getParameter("major");
            int student_id = Integer.parseInt(rq.getParameter("id"));
            
            Student s = new Student(student_code,student_fullName,student_email,student_major);
            s.setId(student_id);

            studentDAO.updateStudent(s);

            rp.sendRedirect("student?action=list");
    }

    //Delete
    private void deleteStudent(HttpServletRequest rq, HttpServletResponse rp)
        throws SQLException, ServletException, IOException{
            int id = Integer.parseInt(rq.getParameter("id"));
            studentDAO.deleteStudent(id);

            rp.sendRedirect("student?action=list");
        }
}
