package net.lsun.servlet;

import net.lsun.bean.Comment;
import net.lsun.bean.User;
import net.lsun.dao.CommentDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "UpdateComment", value = "/update_comment")
public class UpdateComment extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter printWriter = response.getWriter();

        HttpSession httpSession = request.getSession();
        User user = (User) httpSession.getAttribute("user");

        if (user == null) {
            printWriter.write("{\"success\":false,\"msg\":\"请重新登录后重试!\",\"data\":{}}");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String content = request.getParameter("content");

        CommentDao commentDao = CommentDao.getInstance();
        Comment comment = commentDao.getCommentById(id);

        // 验证该评论所有者
        if (comment.getFrom_phone().equals(user.getPhone()) || user.getType() == 0) {
            commentDao.updateCommentById(id, content);
            System.out.println(id+"---"+content);
            printWriter.write("{\"success\":true,\"msg\":\"编辑成功\",\"data\":{}}");
        } else {
            printWriter.write("{\"success\":false,\"msg\":\"你无权编辑该评论!\",\"data\":{}}");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
