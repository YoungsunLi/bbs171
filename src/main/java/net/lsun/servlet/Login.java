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

@WebServlet(name = "Login", value = "/login")
public class Login extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        UserDao userDao = UserDao.getInstance();
        User user = userDao.login(phone, password);

        PrintWriter printWriter = response.getWriter();

        // 登陆失败
        if (user == null) {
            printWriter.write("{\"success\":false,\"msg\":\"用户名或密码错误!\",\"data\":{}}");
        } else {
            HttpSession httpSession = request.getSession();
            httpSession.setAttribute("user", user);

            printWriter.write("{\"success\":true,\"msg\":\"欢迎回来~\",\"data\":{}}");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}
