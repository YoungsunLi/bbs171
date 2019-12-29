package net.lsun.dao;

import net.lsun.bean.Comment;
import net.lsun.bean.CommentAndUser;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CommentDao {
    // 单例模式
    private static final CommentDao instance = new CommentDao();
    Connection connection;

    private CommentDao() {
        super();
        DBConnection dbConnection = new DBConnection();
        connection = dbConnection.getConnection();
    }

    public static CommentDao getInstance() {
        return instance;
    }

    /**
     * 回复
     *
     * @param comment comment
     */
    public void submitComment(Comment comment) {
        String sql = "INSERT INTO comment(post_id, from_phone, content) VALUES(?, ?, ?)";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, comment.getPost_id());
            preparedStatement.setString(2, comment.getFrom_phone());
            preparedStatement.setString(3, comment.getContent());
            preparedStatement.executeUpdate();
            System.out.println("回复:" + comment.getContent() + " 发表成功");
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        PostDao postDao = PostDao.getInstance();
        postDao.updateCommentCountById(comment.getPost_id(), 1);
    }

    /**
     * 通过帖子id获取其评论数量
     *
     * @param post_id 帖子id
     * @return 评论数量
     */
    public int getCommentCountByPostID(int post_id) {
        String sql = "SELECT COUNT(*) FROM comment WHERE post_id = ?";
        int res = 0;
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, post_id);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                res = resultSet.getInt(1);
            }
            resultSet.close();
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return res;
    }

    /**
     * 通过帖子id获取其所有评论以及作者信息
     *
     * @param post_id 帖子id
     * @return 包含所有评论的ArrayList
     */
    public List<CommentAndUser> getAllCommentAndUserByPostId(int post_id) {
        List<CommentAndUser> commentAndUserList = new ArrayList<CommentAndUser>();
        String sql = "SELECT comment.id, comment.post_id, comment.from_phone, comment.content, comment.datetime, user.id user_id, user.type, user.username, user.gender, user.sign, user.avatar FROM comment INNER JOIN user ON comment.post_id = ? AND comment.status = 1 AND user.phone = comment.from_phone";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, post_id);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                CommentAndUser commentAndUser = new CommentAndUser();
                commentAndUser.setId(resultSet.getInt("id"));
                commentAndUser.setPost_id(resultSet.getInt("post_id"));
                commentAndUser.setFrom_phone(resultSet.getString("from_phone"));
                commentAndUser.setContent(resultSet.getString("content"));
                commentAndUser.setDatetime(resultSet.getTimestamp("datetime"));
                commentAndUser.setUser_id(resultSet.getInt("user_id"));
                commentAndUser.setType(resultSet.getInt("type"));
                commentAndUser.setUsername(resultSet.getString("username"));
                commentAndUser.setGender(resultSet.getString("gender"));
                commentAndUser.setSign(resultSet.getString("sign"));
                commentAndUser.setAvatar(resultSet.getString("avatar"));
                commentAndUserList.add(commentAndUser);
            }
            resultSet.close();
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return commentAndUserList;
    }

    /**
     * 根据评论id删除该评论
     *
     * @param id 该评论id
     */
    public void delCommentByCommentId(int id) {
        String sql = "UPDATE comment SET status = 2 WHERE id = ?";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, id);
            preparedStatement.executeUpdate();
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        Comment comment = getCommentById(id);
        PostDao postDao = PostDao.getInstance();
        postDao.updateCommentCountById(comment.getPost_id(), 0);
    }

    /**
     * 根据评论id获取该评论
     *
     * @param id 该评论id
     * @return comment
     */
    public Comment getCommentById(int id) {
        String sql = "SELECT * FROM comment WHERE id = ?";
        Comment comment = new Comment();
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                setComment(comment, resultSet);
            }
            resultSet.close();
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comment;
    }

    private void setComment(Comment comment, ResultSet resultSet) throws SQLException {
        comment.setId(resultSet.getInt("id"));
        comment.setPost_id(resultSet.getInt("post_id"));
        comment.setFrom_phone(resultSet.getString("from_phone"));
        comment.setTo_phone(resultSet.getString("to_phone"));
        comment.setContent(resultSet.getString("content"));
        comment.setDatetime(resultSet.getTimestamp("datetime"));
        comment.setStatus(resultSet.getInt("status"));
    }
}
