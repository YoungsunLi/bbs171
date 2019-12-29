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

@WebServlet(name = "DelComment", value = "/del-comment")
public class DelComment extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter printWriter = response.getWriter();

        HttpSession httpSession = request.getSession();
        User user = (User) httpSession.getAttribute("user");

        int id;
        CommentDao commentDao = CommentDao.getInstance();

        if (user == null) {
            printWriter.write("{\"success\":false,\"msg\":\"非法操作!\",\"data\":{}}");
            return;
        } else {
            id = Integer.parseInt(request.getParameter("id"));
            Comment comment = commentDao.getCommentById(id);
            if (user.getType() == 1 && !(user.getPhone().equals(comment.getFrom_phone()))) {
                printWriter.write("{\"success\":false,\"msg\":\"非法操作!\",\"data\":{}}");
                return;
            }
        }

        commentDao.delCommentByCommentId(id);
        printWriter.write("{\"success\":true,\"msg\":\"删除成功!\",\"data\":{}}");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
