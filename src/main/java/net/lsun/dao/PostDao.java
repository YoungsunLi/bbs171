package net.lsun.dao;

import net.lsun.bean.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PostDao {
    // 单例模式
    private static final PostDao instance = new PostDao();
    private Connection connection;

    private PostDao() {
        super();
        DBConnection dbConnection = new DBConnection();
        connection = dbConnection.getConnection();
    }

    public static PostDao getInstance() {
        return instance;
    }

    /**
     * 发帖
     *
     * @param post post
     */
    public void submitPost(Post post) {
        String sql = "INSERT INTO posts(phone, title, content, category) VALUES(?, ?, ?, ?)";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, post.getPhone());
            preparedStatement.setString(2, post.getTitle());
            preparedStatement.setString(3, post.getContent());
            preparedStatement.setInt(4, post.getCategory());
            preparedStatement.executeUpdate();
            System.out.println("帖子:" + post.getTitle() + " 发表成功");
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * 查询帖子列表以及对应的作者信息(管理帖子页)
     *
     * @param category 板块: 0=综合, 1=默认, 2=学习, 3=生活, 4=表白墙.
     * @param sort     排序方式: 0=按最新, 1=按热度, 2=按评论, 3=按举报
     * @param status   帖子状态: 3=全部, 0=未审核, 1=已审核, 2=已删除.
     * @param keywords 搜索标题关键字
     * @return postManageList
     */
    public List<PostAndUserForManage> queryPostsAnUserForManage(int category, int sort, int status, String keywords) {
        // 非法参数过滤 防止sql注入
        // category = category == 1 || category == 2 || category == 3 || category == 4 ? category : 0;
        // status = status == 0 || status == 3 || status == 2 ? status : 1;
        String order = "datetime";
        switch (sort) {
            case 1:
                order = "views";
                break;
            case 2:
                order = "comment";
                break;
            case 3:
                order = "report";
                break;
            case 0:
            default:
                break;
        }

        // 这样写虽然狗屎 但是查询性能好 啊哈哈哈哈哈哈哈
        String sql = "SELECT posts.id, posts.title, posts.datetime, posts.category, posts.views, posts.status, posts.report, posts.comment, user.id user_id, user.username FROM posts INNER JOIN user ON user.phone = posts.phone";
        if (category != 0 || status != 3 || !"".equals(keywords)) {
            sql += " AND";
            if (category != 0) {
                sql += " category = " + category;
                if (status != 3 || !"".equals(keywords)) sql += " AND";
            }
            if (status != 3) {
                sql += " status = " + status;
                if (!"".equals(keywords)) sql += " AND";
            }
            if (!"".equals(keywords)) {
                sql += " title REGEXP ?";
            }
        }
        sql += " ORDER BY " + order + " DESC";

        List<PostAndUserForManage> postAndUserForManageList = new ArrayList<PostAndUserForManage>();

        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            if (!"".equals(keywords)) {
                preparedStatement.setString(1, keywords);
            }
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                PostAndUserForManage postAndUserForManage = new PostAndUserForManage();
                postAndUserForManage.setId(resultSet.getInt("id"));
                postAndUserForManage.setTitle(resultSet.getString("title"));
                postAndUserForManage.setDatetime(resultSet.getTimestamp("datetime"));
                postAndUserForManage.setCategory(resultSet.getInt("category"));
                postAndUserForManage.setViews(resultSet.getInt("views"));
                postAndUserForManage.setStatus(resultSet.getInt("status"));
                postAndUserForManage.setReport(resultSet.getInt("report"));
                postAndUserForManage.setComment(resultSet.getInt("comment"));
                postAndUserForManage.setUser_id(resultSet.getInt("user_id"));
                postAndUserForManage.setUsername(resultSet.getString("username"));
                postAndUserForManageList.add(postAndUserForManage);
            }
            resultSet.close();
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return postAndUserForManageList;
    }

    /**
     * 查询帖子列表以及对应的作者信息(首页)
     *
     * @param category 板块: 0=综合, 1=默认, 2=学习, 3=生活, 4=表白墙.
     * @param sort     排序方式: 0=按最新, 1=按热度, 2=按评论.
     * @param keywords 搜索标题关键字
     * @return postManageList
     */
    public List<PostAndUserForIndex> queryPostsAnUserForIndex(int category, int sort, String keywords) {
        // 非法参数过滤 防止sql注入
        // category = category == 1 || category == 2 || category == 3 || category == 4 ? category : 0;
        String order = "datetime";
        switch (sort) {
            case 1:
                order = "views";
                break;
            case 2:
                order = "comment";
                break;
            case 0:
            default:
                break;
        }

        // 这样写虽然狗屎 但是查询性能好 啊哈哈哈哈哈哈哈
        String sql = "SELECT posts.id, posts.title, posts.datetime, posts.category, posts.views, posts.comment, user.id user_id, user.username, user.avatar FROM posts INNER JOIN user ON user.phone = posts.phone AND posts.status = 1";
        if (category != 0 || !"".equals(keywords)) {
            sql += " AND";
            if (category != 0) {
                sql += " category = " + category;
                if (!"".equals(keywords)) sql += " AND";
            }
            if (!"".equals(keywords)) {
                sql += " title REGEXP ?";
            }
        }
        sql += " ORDER BY " + order + " DESC";

        List<PostAndUserForIndex> postAndUserForIndexList = new ArrayList<PostAndUserForIndex>();

        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            if (!"".equals(keywords)) {
                preparedStatement.setString(1, keywords);
            }
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                PostAndUserForIndex postAndUserForIndex = new PostAndUserForIndex();
                postAndUserForIndex.setId(resultSet.getInt("id"));
                postAndUserForIndex.setTitle(resultSet.getString("title"));
                postAndUserForIndex.setDatetime(resultSet.getTimestamp("datetime"));
                postAndUserForIndex.setCategory(resultSet.getInt("category"));
                postAndUserForIndex.setViews(resultSet.getInt("views"));
                postAndUserForIndex.setComment(resultSet.getInt("comment"));
                postAndUserForIndex.setUser_id(resultSet.getInt("user_id"));
                postAndUserForIndex.setUsername(resultSet.getString("username"));
                postAndUserForIndex.setAvatar(resultSet.getString("avatar"));
                postAndUserForIndexList.add(postAndUserForIndex);
            }
            resultSet.close();
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return postAndUserForIndexList;
    }

    /**
     * 通过帖子id获取单个帖子信息和作者信息
     *
     * @param id 帖子id
     * @return postAndUserForDetail
     */
    public PostAndUserForDetail getPostAndUserById(int id) {
        String sql = "SELECT posts.*, user.id user_id, user.type, user.username, user.gender, user.sign, user.avatar FROM posts INNER JOIN user ON  posts.id = ? AND user.phone = posts.phone";
        PostAndUserForDetail postAndUserForDetail = new PostAndUserForDetail();
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                postAndUserForDetail.setId(resultSet.getInt("id"));
                postAndUserForDetail.setPhone(resultSet.getString("phone"));
                postAndUserForDetail.setTitle(resultSet.getString("title"));
                postAndUserForDetail.setContent(resultSet.getString("content"));
                postAndUserForDetail.setDatetime(resultSet.getTimestamp("datetime"));
                postAndUserForDetail.setCategory(resultSet.getInt("category"));
                postAndUserForDetail.setViews(resultSet.getInt("views"));
                postAndUserForDetail.setStatus(resultSet.getInt("status"));
                postAndUserForDetail.setReport(resultSet.getInt("report"));
                postAndUserForDetail.setComment(resultSet.getInt("comment"));
                postAndUserForDetail.setUser_id(resultSet.getInt("user_id"));
                postAndUserForDetail.setType(resultSet.getInt("type"));
                postAndUserForDetail.setUsername(resultSet.getString("username"));
                postAndUserForDetail.setGender(resultSet.getString("gender"));
                postAndUserForDetail.setSign(resultSet.getString("sign"));
                postAndUserForDetail.setAvatar(resultSet.getString("avatar"));
            }
            resultSet.close();
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return postAndUserForDetail;
    }

    /**
     * 通过帖子id获取帖子作者手机
     *
     * @param id 帖子id
     * @return phone
     */
    public String getPostPhoneById(int id) {
        String sql = "SELECT phone FROM posts WHERE id = ?";
        String phone = "";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                phone = resultSet.getString("phone");
            }
            resultSet.close();
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return phone;
    }

    /**
     * 记录一次浏览量
     *
     * @param id 帖子id
     */
    public void updateViewsById(int id) {
        String sql = "UPDATE posts SET views = views + 1 WHERE id = ?";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, id);
            preparedStatement.executeUpdate();
            System.out.println("帖子id:" + id + " 的浏览量+1");
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * 记录一次举报数
     *
     * @param id   帖子id
     * @param type 1=加一次, 其他=减一次
     */
    public void updateReportById(int id, int type) {
        String sql = "UPDATE posts SET report = report + " + (type == 1 ? 1 : -1) + " WHERE id = ?";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, id);
            preparedStatement.executeUpdate();
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * 记录一次评论数
     *
     * @param id   帖子id
     * @param type 1=加一次, 其他=减一次
     */
    public void updateCommentCountById(int id, int type) {
        String sql = "UPDATE posts SET comment = comment + " + (type == 1 ? 1 : -1) + " WHERE id = ?";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, id);
            preparedStatement.executeUpdate();
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * 管理帖子(审核 删除)
     *
     * @param id     帖子id
     * @param status 帖子状态
     */
    public void managePost(int id, int status) {
        String sql = "UPDATE posts SET status = ? WHERE id = ?";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, status);
            preparedStatement.setInt(2, id);
            preparedStatement.executeUpdate();
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * 通过session用户的手机获取该用户帖子
     *
     * @param phone 手机号
     * @return 该用户的帖子 包括未审核
     */
    public List<PostForUserIndex> getPostsByPhone(String phone) {
        String sql = "SELECT id, title, datetime, category, views, status, comment FROM posts WHERE phone = ? AND status < 2";
        List<PostForUserIndex> postForUserIndexList = new ArrayList<PostForUserIndex>();
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, phone);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                PostForUserIndex postForUserIndex = new PostForUserIndex();
                postForUserIndex.setId(resultSet.getInt("id"));
                postForUserIndex.setTitle(resultSet.getString("title"));
                postForUserIndex.setDatetime(resultSet.getTimestamp("datetime"));
                postForUserIndex.setCategory(resultSet.getInt("category"));
                postForUserIndex.setViews(resultSet.getInt("views"));
                postForUserIndex.setStatus(resultSet.getInt("status"));
                postForUserIndex.setComment(resultSet.getInt("comment"));
                postForUserIndexList.add(postForUserIndex);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return postForUserIndexList;
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize();
        connection.close();
    }
}
