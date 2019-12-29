package net.lsun.servlet;

import net.lsun.bean.Report;
import net.lsun.bean.User;
import net.lsun.dao.PostDao;
import net.lsun.dao.ReportDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "ReportPost", value = "/report-post")
public class ReportPost extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter printWriter = response.getWriter();

        HttpSession httpSession = request.getSession();
        User user = (User) httpSession.getAttribute("user");

        if (user == null) {
            printWriter.write("{\"success\":false,\"msg\":\"登录后才可以举报!\",\"data\":{}}");
            return;
        }

        int post_id = Integer.parseInt(request.getParameter("post_id"));
        String content = request.getParameter("content");

        Report report = new Report();
        report.setPost_id(post_id);
        report.setUser_id(user.getId());
        System.out.println(user.getUsername() + ":" + user.getId());
        report.setContent(content);

        ReportDao reportDao = ReportDao.getInstance();
        reportDao.submitReport(report);

        // 向post记录一次
        PostDao postDao = PostDao.getInstance();
        postDao.updateReportById(post_id, 1);

        printWriter.write("{\"success\":true,\"msg\":\"举报成功!\",\"data\":{}}");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
