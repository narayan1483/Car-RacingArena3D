package controller;

import dao.ScoreDAO;
import model.Score;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/saveScore")
public class ScoreServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.getWriter().println("Login Required");
            return;
        }

        String username = (String) session.getAttribute("username");

        try {
            int scoreVal = Integer.parseInt(request.getParameter("score"));

            Score s = new Score();
            s.setUsername(username);
            s.setScore(scoreVal);

            ScoreDAO dao = new ScoreDAO();
            boolean saved = dao.saveScore(s);

            if (saved) {
                response.getWriter().println("Score Saved");
            } else {
                response.getWriter().println("Error Saving Score");
            }

        } catch (NumberFormatException e) {
            response.getWriter().println("Invalid Score");
        }
    }
}
