package dao;

import database.DBConnection;
import model.Score;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ScoreDAO {

    public boolean saveScore(Score score) {
        try {
            Connection con = DBConnection.getConnection();

            // Check if user already has a score
            String checkSql = "SELECT score FROM scores WHERE username = ?";
            PreparedStatement checkPs = con.prepareStatement(checkSql);
            checkPs.setString(1, score.getUsername());
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                // User exists — update only if new score is HIGHER
                int existingScore = rs.getInt("score");
                if (score.getScore() > existingScore) {
                    String updateSql = "UPDATE scores SET score = ? WHERE username = ?";
                    PreparedStatement updatePs = con.prepareStatement(updateSql);
                    updatePs.setInt(1, score.getScore());
                    updatePs.setString(2, score.getUsername());
                    int i = updatePs.executeUpdate();
                    return i > 0;
                } else {
                    // Score not better — still return true (no error)
                    return true;
                }
            } else {
                // New user — insert fresh score
                String insertSql = "INSERT INTO scores(username, score) VALUES(?, ?)";
                PreparedStatement insertPs = con.prepareStatement(insertSql);
                insertPs.setString(1, score.getUsername());
                insertPs.setInt(2, score.getScore());
                int i = insertPs.executeUpdate();
                return i > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
