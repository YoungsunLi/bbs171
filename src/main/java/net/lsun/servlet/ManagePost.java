package net.lsun.servlet;

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

@WebServlet(name = "ManagePost", value = "/manage-post")
public class ManagePost extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter printWriter = response.getWriter();

        HttpSession httpSession = request.getSession();
        User user = (User) httpSession.getAttribute("user");

        if (user == null) {
            printWriter.write("{\"success\":false,\"msg\":\"请登录后操作!\",\"data\":{}}");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));

        PostDao postDao = PostDao.getInstance();
        String  phone = postDao.getPostPhoneById(id);

        if (user.getType() != 0 && !(user.getPhone().equals(phone))) {
            printWriter.write("{\"success\":false,\"msg\":\"你只能删除自己的帖子!\",\"data\":{}}");
            return;
        }

        int status = Integer.parseInt(request.getParameter("status"));
        postDao.managePost(id, status);
        printWriter.write("{\"success\":true,\"msg\":\"操作成功!\",\"data\":{}}");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
