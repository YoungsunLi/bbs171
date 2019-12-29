package net.lsun.servlet;

import net.lsun.bean.Post;
import net.lsun.bean.User;
import net.lsun.dao.PostDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "SubmitPost", value = "/submit_post")
public class SubmitPost extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter printWriter = response.getWriter();

        HttpSession httpSession = request.getSession();
        User user = (User) httpSession.getAttribute("user");

        if (user == null) {
            printWriter.write("{\"success\":false,\"msg\":\"非法操作! \",\"data\":{}}");
            return;
        }

        String phone = user.getPhone();
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        int  category = Integer.parseInt(request.getParameter("category"));

        Post post = new Post();
        post.setPhone(phone);
        post.setTitle(title);
        post.setContent(content);
        post.setCategory(category);

        PostDao postDao = PostDao.getInstance();
        postDao.submitPost(post);

        printWriter.write("{\"success\":true,\"msg\":\"发表成功! 待管理员审核后显示.\",\"data\":{}}");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
