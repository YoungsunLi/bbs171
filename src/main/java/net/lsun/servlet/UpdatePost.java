package net.lsun.servlet;

import net.lsun.bean.PostForUpdate;
import net.lsun.dao.PostDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "UpdatePost", value = "/update_post")
public class UpdatePost extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        PostDao postDao = PostDao.getInstance();
        PostForUpdate postForUpdate = postDao.getPostForUpdateById(id);
        request.setAttribute("postForUpdate", postForUpdate);
        request.setAttribute("edit", 1);
        request.getRequestDispatcher("/jie/add.jsp").forward(request, response);
    }
}
