package net.lsun.servlet;

import net.lsun.bean.PostForUserIndex;
import net.lsun.bean.User;
import net.lsun.dao.PostDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "UserIndex", value = "/user_index")
public class UserIndex extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession httpSession = request.getSession();
        User user = (User) httpSession.getAttribute("user");

        if (user == null) {
            request.getRequestDispatcher("/user/login.jsp").forward(request, response);
            return;
        }

        String phone = user.getPhone();
        PostDao postDao = PostDao.getInstance();
        List<PostForUserIndex> postForUserIndexList = postDao.getPostsByPhone(phone);

        request.setAttribute("postForUserIndexList", postForUserIndexList);
        request.getRequestDispatcher("/user/index.jsp").forward(request, response);
    }
}
