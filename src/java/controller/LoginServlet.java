package controller;

import dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();

        if (dao.loginUser(username, password)) {

            HttpSession session = request.getSession();
            session.setAttribute("username", username);

            response.sendRedirect("game.jsp");

        } else {

            response.getWriter().println("Invalid Login");

        }
    }
}