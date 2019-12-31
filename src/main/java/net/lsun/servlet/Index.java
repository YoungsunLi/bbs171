package net.lsun.servlet;

import net.lsun.bean.PostAndUserForIndex;
import net.lsun.dao.PostDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "Index", value = "/index")
public class Index extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int category = request.getParameter("category") == null ? 0 : Integer.parseInt(request.getParameter("category"));
        int sort = request.getParameter("sort") == null ? 0 : Integer.parseInt(request.getParameter("sort"));
        String keywords = request.getParameter("keywords") == null ? "" : request.getParameter("keywords");

        keywords = new String(keywords.getBytes("ISO-8859-1"), "UTF-8");

        PostDao postDao = PostDao.getInstance();
        List<PostAndUserForIndex> postAndUserForIndexList = postDao.queryPostsAnUserForIndex(category, sort, keywords);

        request.setAttribute("postAndUserForIndexList", postAndUserForIndexList);
        request.setAttribute("category", category);
        request.setAttribute("sort", sort);
        request.setAttribute("keywords", keywords);
        request.getRequestDispatcher("/index277013309.jsp").forward(request, response);
    }
}
