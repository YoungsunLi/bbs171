package net.lsun.servlet;

import net.lsun.bean.Comment;
import net.lsun.bean.User;
import net.lsun.dao.CommentDao;
import net.lsun.dao.PostDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.sql.Timestamp;

@WebServlet(name = "Comment", value = "/comment")
public class SubmitComment extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter printWriter = response.getWriter();

        HttpSession httpSession = request.getSession();
        User user = (User) httpSession.getAttribute("user");

        if (user == null) {
            printWriter.write("{\"success\":false,\"msg\":\"非法操作!\",\"data\":{}}");
            return;
        }

        int post_id = Integer.parseInt(request.getParameter("post_id"));
        String from_phone = user.getPhone();
        String content = request.getParameter("content");

        Comment comment = new Comment();
        comment.setPost_id(post_id);
        comment.setFrom_phone(from_phone);
        comment.setContent(content);

        CommentDao commentDao = CommentDao.getInstance();
        commentDao.submitComment(comment);

        printWriter.write("{\"success\":true,\"msg\":\"回复成功!\",\"data\":{}}");

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
