package net.lsun.servlet;

import net.lsun.bean.CommentAndUser;
import net.lsun.bean.PostAndUserForDetail;
import net.lsun.bean.User;
import net.lsun.dao.CommentDao;
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

@WebServlet(name = "Detail", value = "/detail")
public class Detail extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        PostDao postDao = PostDao.getInstance();
        CommentDao commentDao = CommentDao.getInstance();

        PostAndUserForDetail postAndUserForDetail = postDao.getPostAndUserById(id);

        // 已删除的帖子不给普通用户查看
        if (postAndUserForDetail.getStatus() == 2) {
            HttpSession httpSession = request.getSession();
            User user = (User) httpSession.getAttribute("user");
            if (user == null || user.getType() == 1) {
                response.setContentType("text/html;charset=UTF-8");
                PrintWriter printWriter = response.getWriter();
                printWriter.println("该帖子已被删除!");
                return;
            }
        }

        List<CommentAndUser> commentAndUserList = commentDao.getAllCommentAndUserByPostId(postAndUserForDetail.getId());

        postDao.updateViewsById(id);

        request.setAttribute("postAndUserForDetail", postAndUserForDetail);
        request.setAttribute("commentAndUserList", commentAndUserList);
        request.getRequestDispatcher("/jie/detail.jsp").forward(request, response);
    }
}
