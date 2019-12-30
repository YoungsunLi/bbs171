<%@ page import="net.lsun.bean.PostForUserIndex" %>
<%@ page import="net.lsun.bean.User" %>
<%@ page import="java.util.List" %>
<%@ page import="net.lsun.utils.Util" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    List<PostForUserIndex> postForUserIndexList = (List) request.getAttribute("postForUserIndexList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>用户中心</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="../res/layui/css/layui.css">
    <link rel="stylesheet" href="../res/css/global.css">
</head>
<body>

<div class="fly-header layui-bg-black">
    <div class="layui-container">
        <a class="fly-logo" href="/">
            <img src="../res/images/logo.png" alt="bbs171" style=" height: 37px; width: 135px;">
        </a>
        <ul class="layui-nav fly-nav-user">

            <%
                User user = (User) session.getAttribute("user");
                if (user == null) {
                    request.getRequestDispatcher("/to?href=/user/login.jsp").forward(request, response);
            %>

            <!-- 未登入的状态 -->
            <li class="layui-nav-item">
                <a class="iconfont icon-touxiang layui-hide-xs"
                   href="../user/login.jsp"></a>
            </li>
            <li class="layui-nav-item">
                <a href="../user/login.jsp">登入</a>
            </li>
            <li class="layui-nav-item">
                <a href="../user/reg.jsp">注册</a>
            </li>

            <%
            } else {
            %>

            <!-- 登入后的状态 -->
            <li class="layui-nav-item">
                <a class="fly-nav-avatar" href="javascript:">
                    <cite class="layui-hide-xs"><%= user.getUsername()%>
                    </cite>
                    <img src="<%= request.getContextPath() + user.getAvatar()%>" alt="avatar">
                </a>
                <dl class="layui-nav-child">
                    <dd><a href="/to?href=/user/set.jsp"><i class="layui-icon">&#xe620;</i>基本设置</a>
                    </dd>
                    <hr style="margin: 5px 0;">
                    <dd><a href="/logout" style="text-align: center;">退出</a></dd>
                </dl>
            </li>

            <%
                }
            %>
        </ul>
    </div>
</div>

<div class="layui-container fly-marginTop fly-user-main">
    <ul class="layui-nav layui-nav-tree layui-inline" lay-filter="user">
        <li class="layui-nav-item layui-this">
            <a href="/user_index">
                <i class="layui-icon">&#xe612;</i>
                用户中心
            </a>
        </li>
        <li class="layui-nav-item">
            <a href="/to?href=/user/set.jsp">
                <i class="layui-icon">&#xe620;</i>
                基本设置
            </a>
        </li>

        <%
            if (user != null && user.getType() == 0) {
        %>
        <li class="layui-nav-item">
            <a href="/manage-posts">
                <i class="layui-icon">&#xe632;</i>
                管理帖子
            </a>
        </li>
        <%
            }
        %>
    </ul>

    <div class="site-tree-mobile layui-hide">
        <i class="layui-icon">&#xe602;</i>
    </div>
    <div class="site-mobile-shade"></div>

    <div class="site-tree-mobile layui-hide">
        <i class="layui-icon">&#xe602;</i>
    </div>
    <div class="site-mobile-shade"></div>


    <div class="fly-panel fly-panel-user" pad20>
        <div class="layui-tab layui-tab-brief" lay-filter="user">
            <ul class="layui-tab-title" id="LAY_mine">
                <li data-type="mine-jie" lay-id="index" class="layui-this">我发的帖</li>
            </ul>
            <div class="layui-tab-content" style="padding: 20px 0;">
                <div class="layui-tab-item layui-show">
                    <ul class="mine-view jie-row">
                        <%
                            for (PostForUserIndex post: postForUserIndexList) {
                        %>
                        <li>
                            <span class="layui-badge-rim layui-bg-gray"><%= Util.parseCategory(post.getCategory())%></span>
                            <%
                                if (post.getStatus() == 0) {
                            %>
                            <span class="layui-badge layui-bg-orange">审核中</span>
                            <%
                                }
                            %>
                            <a class="jie-title" href="/detail?id=<%= post.getId()%>" target="_blank"><%= post.getTitle()%></a>
                            <em>
                                <i><%= post.getViews()%>阅/<%= post.getComment()%>回</i>
                                <i><%= Util.parseTimestampToXxxBefore(post.getDatetime())%></i>
                                <a class="mine-edit" href="">编辑</a>
                            </em>
                        </li>
                        <%
                            }
                        %>
                    </ul>
                    <div id="LAY_page"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="fly-footer">
    <p>&copy; 2019<a href="https://lsun.net/">Youngsun Li.</a>Powered by Layui</p>
</div>

<script src="../res/layui/layui.js"></script>
<script>
    layui.cache.page = 'user';
    layui.cache.user = {
        username: '游客'
        , uid: -1
        , avatar: '../res/images/avatar/00.jpg'
        , experience: 83
        , sex: '男'
    };
    layui.config({
        version: "3.0.0"
        , base: '../res/mods/'
    }).extend({
        fly: 'index'
    }).use('fly');
</script>

</body>
</html>