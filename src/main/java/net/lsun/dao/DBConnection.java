package net.lsun.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    public Connection connection = null;

    public DBConnection() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        final String URL = "jdbc:mysql://bbs171.lsun.net:3306/bbs171?serverTimezone=Asia/Shanghai";
        final String USERNAME = "bbs171";
        final String PASSWORD = "LbGb2EfKzxXjZNdS";

        final String USERNAME = "root";
        final String PASSWORD = "123456";

        try {
            connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        System.out.println("connection created");
    }

    public Connection getConnection() {
        return connection;
    }
}
