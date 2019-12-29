package net.lsun.servlet;

import net.lsun.bean.PostAndUserForManage;
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
import java.util.List;

@WebServlet(name = "ManagePosts", value = "/manage-posts")
public class ManagePosts extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession httpSession = request.getSession();
        User user = (User) httpSession.getAttribute("user");

        if (user == null || user.getType() != 0) {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter printWriter = response.getWriter();
            printWriter.println("请以管理员身份登录!");
            return;
        }

        int category = request.getParameter("category") == null ? 0 : Integer.parseInt(request.getParameter("category"));
        int sort = request.getParameter("sort") == null ? 0 : Integer.parseInt(request.getParameter("sort"));
        int status = request.getParameter("status") == null ? 3 : Integer.parseInt(request.getParameter("status"));
        String keywords = request.getParameter("keywords") == null ? "" : request.getParameter("keywords");

        PostDao postDao = PostDao.getInstance();
        List<PostAndUserForManage> postAndUserForManageList = postDao.queryPostsAnUserForManage(category, sort, status, keywords);

        request.setAttribute("postAndUserForManageList", postAndUserForManageList);
        request.setAttribute("category", category);
        request.setAttribute("sort", sort);
        request.setAttribute("status", status);
        request.setAttribute("keywords", keywords);
        request.getRequestDispatcher("/user/manage-posts.jsp").forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
