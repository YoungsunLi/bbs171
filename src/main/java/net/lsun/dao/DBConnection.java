package net.lsun.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private Connection connection = null;

    public Connection getConnection() {
        if (connection == null) {
            try {
                Class.forName("com.mysql.jdbc.Driver");
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }

            final String URL = "jdbc:mysql://127.0.0.1:3306/bbs171?serverTimezone=Asia/Shanghai&autoReconnect=true";
            final String USERNAME = "root";
            final String PASSWORD = "123456";

//            final String USERNAME = "bbs171";
//            final String PASSWORD = "LbGb2EfKzxXjZNdS";

            try {
                connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return connection;
    }
}
