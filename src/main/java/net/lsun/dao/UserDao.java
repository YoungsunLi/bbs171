package net.lsun.dao;

import net.lsun.bean.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDao {
    // 单例模式
    private static final UserDao instance = new UserDao();
    private Connection connection;

    private UserDao() {
        super();
        DBConnection dbConnection = new DBConnection();
        connection = dbConnection.getConnection();
    }

    public static UserDao getInstance() {
        return instance;
    }

    /**
     * 注册
     *
     * @param user User
     */
    public void reg(User user) {
        String sql = "INSERT INTO user(phone, username, password, gender, avatar) VALUES(?, ?, ?, ?, ?)";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, user.getPhone());
            preparedStatement.setString(2, user.getUsername());
            preparedStatement.setString(3, user.getPassword());
            preparedStatement.setString(4, user.getGender());
            preparedStatement.setString(5, user.getAvatar());
            preparedStatement.executeUpdate();
            System.out.println("用户:" + user.getUsername() + " 注册成功");
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * 检查该手机是否已注册
     *
     * @param phone 新注册的手机
     * @return false: 可注册; true: 该手机已注册
     */
    public boolean checkPhone(String phone) {
        String sql = "SELECT COUNT(*) FROM user WHERE phone = ?";
        boolean res = false;
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, phone);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                int count = resultSet.getInt(1);
                // 索引查询至多为=1
                if (count == 1) {
                    System.out.println("该手机:" + phone + " 已注册");
                    res = true;
                }
            }
            resultSet.close();
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return res;
    }

    /**
     * 登录
     *
     * @param phone    手机
     * @param password 密码
     * @return User: 可登录; null: 反之
     */
    public User login(String phone, String password) {
        User user = null;
        String url = "SELECT * FROM user WHERE phone = ? AND password = ?";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(url);
            preparedStatement.setString(1, phone);
            preparedStatement.setString(2, password);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                user = new User();
                user.setId(resultSet.getInt("id"));
                user.setType(resultSet.getInt("type"));
                user.setPhone(resultSet.getString("phone"));
                user.setUsername(resultSet.getString("username"));
                user.setPassword("我跟你说哦: ~!@#$%^&*()_+");
                user.setGender(resultSet.getString("gender"));
                user.setSign(resultSet.getString("sign"));
                user.setAvatar(resultSet.getString("avatar"));
                user.setDatetime(resultSet.getTimestamp("datetime"));
            }
            resultSet.close();
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    /**
     * 通过手机号获取用户信息
     *
     * @param phone 手机
     * @return user
     */
    public User getUserByPhone(String phone) {
        User user = null;
        String url = "SELECT * FROM user WHERE phone = ?";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(url);
            preparedStatement.setString(1, phone);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                user = new User();
                user.setId(resultSet.getInt("id"));
                user.setType(resultSet.getInt("type"));
                user.setPhone(resultSet.getString("phone"));
                user.setUsername(resultSet.getString("username"));
                user.setPassword("我跟你说哦: ~!@#$%^&*()_+");
                user.setGender(resultSet.getString("gender"));
                user.setSign(resultSet.getString("sign"));
                user.setAvatar(resultSet.getString("avatar"));
                user.setDatetime(resultSet.getTimestamp("datetime"));
            }
            resultSet.close();
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    /**
     * 更新用户信息(用户名, 性别, 签名)
     *
     * @param id       必须是通过session获取到的用户id
     * @param username 新的用户名
     * @param gender   新的性别
     * @param sign     新的签名
     */
    public void updateUserInfo(int id, String username, String gender, String sign) {
        String sql = "UPDATE user SET username = ?, gender = ?, sign = ? WHERE id = ?";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, gender);
            preparedStatement.setString(3, sign);
            preparedStatement.setInt(4, id);
            preparedStatement.executeUpdate();
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * 更新用户密码
     *
     * @param id       必须是通过session获取到的用户id
     * @param password 新密码
     */
    public void updatePassword(int id, String password) {
        String sql = "UPDATE user SET password = ? WHERE id = ?";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, password);
            preparedStatement.setInt(2, id);
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
