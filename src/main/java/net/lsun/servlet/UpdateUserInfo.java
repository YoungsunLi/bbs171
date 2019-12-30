package net.lsun.servlet;

import net.lsun.bean.User;
import net.lsun.dao.UserDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "UpdateUserInfo", value = "/update_user_info")
public class UpdateUserInfo extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter printWriter = response.getWriter();

        HttpSession httpSession = request.getSession();
        User user = (User) httpSession.getAttribute("user");

        if (user == null) {
            printWriter.write("{\"success\":false,\"msg\":\"请重新登录后重试!\",\"data\":{}}");
        } else {
            int id = user.getId();
            String username = request.getParameter("username").equals("") ? user.getUsername() : request.getParameter("username");
            String gender = request.getParameter("gender").equals("") ? user.getGender() : request.getParameter("gender");
            String sign = request.getParameter("sign");

            UserDao userDao = UserDao.getInstance();
            userDao.updateUserInfo(id, username, gender, sign);
            printWriter.write("{\"success\":true,\"msg\":\"修改成功, 重新登录后生效.\",\"data\":{}}");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
