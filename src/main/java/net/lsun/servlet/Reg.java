package net.lsun.servlet;

import net.lsun.bean.User;
import net.lsun.dao.UserDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "Reg", value = "/reg")
public class Reg extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        UserDao userDao = UserDao.getInstance();

        String phone = request.getParameter("phone");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        boolean checkPhone = userDao.checkPhone(phone);

        PrintWriter printWriter = response.getWriter();

        // 如果手机已注册
        if (checkPhone) {
            printWriter.write("{\"success\":false,\"msg\":\"该手机已注册!\",\"data\":{}}");
        } else {
            User user = new User();
            user.setPhone(phone);
            user.setUsername(username);
            user.setPassword(password);
            user.setAvatar("https://gravatar.com/avatar/" + phone + "?s=200&d=identicon");
            userDao.reg(user);

            printWriter.write("{\"success\":true,\"msg\":\"注册成功!\",\"data\":{}}");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}