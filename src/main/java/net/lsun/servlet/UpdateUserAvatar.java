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

@WebServlet(name = "UpdateUserAvatar", value = "/update_user_avatar")
public class UpdateUserAvatar extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter printWriter = response.getWriter();

        HttpSession httpSession = request.getSession();
        User user = (User) httpSession.getAttribute("user");

        if (user == null) {
            printWriter.write("{\"success\":false,\"msg\":\"非法操作! \",\"data\":{}}");
            return;
        }

        String avatar = request.getParameter("avatar");

        UserDao userDao = UserDao.getInstance();
        userDao.updateAvatar(user.getId(), avatar);

        user.setAvatar(avatar);
        httpSession.setAttribute("user", user);

        printWriter.write("{\"success\":true,\"msg\":\"上传成功\",\"data\":{}}");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
