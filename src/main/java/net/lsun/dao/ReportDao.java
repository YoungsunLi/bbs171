package net.lsun.dao;

import net.lsun.bean.Report;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ReportDao {
    // 单例模式
    private static final ReportDao instance = new ReportDao();
    private Connection connection;

    private ReportDao() {
        super();
        DBConnection dbConnection = new DBConnection();
        connection = dbConnection.getConnection();
    }

    public static ReportDao getInstance() {
        return instance;
    }

    public void submitReport(Report report) {
        String sql = "INSERT INTO report(post_id, user_id, content) VALUES(?, ?, ?)";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, report.getPost_id());
            preparedStatement.setInt(2, report.getUser_id());
            preparedStatement.setString(3, report.getContent());
            preparedStatement.executeUpdate();
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize();
        connection.close();
    }
}
