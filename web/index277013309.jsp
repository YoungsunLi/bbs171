<%@ page import="net.lsun.bean.PostAndUserForIndex" %>
<%@ page import="net.lsun.bean.User" %>
<%@ page import="net.lsun.utils.Util" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    List<PostAndUserForIndex> postAndUserForIndexList = (List) request.getAttribute("postAndUserForIndexList");
    int category = request.getParameter("category") != null ? Integer.parseInt(request.getParameter("category")) : 0;
    int sort = request.getParameter("sort") != null ? Integer.parseInt(request.getParameter("sort")) : 0;
    String keywords = request.getParameter("keywords") != null ? request.getParameter("keywords") : "";
    keywords = new String(keywords.getBytes("ISO-8859-1"), "UTF-8");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <title>171快乐源泉</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="./res/layui/css/layui.css">
    <link rel="stylesheet" href="./res/css/global.css">
</head>
<body>

<div class="fly-header layui-bg-black">
    <div class="layui-container">
        <a class="fly-logo" href="/">
            <img src="../res/images/logo.png" alt="bbs171" style=" height: 37px; width: 135px;">
        </a>
        <ul class="layui-nav fly-nav">
            <%
                User user = (User) session.getAttribute("user");
                if (user != null && user.getType() == 0) {
            %>
            <li class="layui-nav-item layui-this">
                <a href="/manage-posts"><i class="layui-icon">&#xe632;</i>管理帖子</a>
            </li>

            <%
                }
            %>
        </ul>
        <ul class="layui-nav fly-nav-user">

            <%
                if (user == null) {
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

<div class="fly-panel fly-column">
    <div class="layui-container">
        <ul class="layui-clear category">
            <li>
                <a href="/index?category=0&sort=<%=sort%>&keywords=<%=keywords%>">综合</a>
            </li>
            <li>
                <a href="/index?category=1&sort=<%=sort%>&keywords=<%=keywords%>">默认</a>
            </li>
            <li>
                <a href="/index?category=2&sort=<%=sort%>&keywords=<%=keywords%>">学习</a>
            </li>
            <li>
                <a href="/index?category=3&sort=<%=sort%>&keywords=<%=keywords%>">生活</a>
            </li>
            <li>
                <a href="/index?category=4&sort=<%=sort%>&keywords=<%=keywords%>">表白墙</a>
            </li>

            <%
                if (user != null) {
            %>
            <!-- 用户登入后显示 -->
            <li class="layui-hide-xs layui-hide-sm layui-show-md-inline-block"><span class="fly-mid"></span></li>
            <li class="layui-hide-sm layui-show-md-inline-block"><a href="/user_index">我发表的贴</a></li>
            <%
                }
            %>
        </ul>

        <div class="fly-column-right layui-hide-xs">
            <form class="layui-form layui-inline" style="margin-bottom: 3px" method="get"
                  action="/index?category=<%=category%>&sort=<%=sort%>">
                <div class="layui-input-inline">
                    <input id="keywords" autocomplete="off" class="layui-input"
                           name="keywords"
                           placeholder="搜索帖子标题"
                           type="text"
                           style="margin-bottom: 2px">
                </div>
                <button type="submit" class="layui-btn">搜索</button>
            </form>
            <a class="layui-btn" href="/to?href=/jie/add.jsp"
               style="margin-left: 10px">发表新帖</a>
        </div>
        <div class="layui-hide-sm layui-show-xs-block"
             style="margin-top: -10px; padding-bottom: 10px; text-align: center;">
            <form class="layui-form layui-inline" method="get"
                  action="/index?category=<%=category%>&sort=<%=sort%>">
                <div class="layui-input-inline">
                    <input id="keywords2" autocomplete="off" class="layui-input"
                           name="keywords"
                           placeholder="搜索帖子标题"
                           type="text" style="width: 162px">
                </div>
                <button type="submit" class="layui-btn">搜索</button>
            </form>
            <a class="layui-btn" href="/to?href=/jie/add.jsp"
               style="margin-left: 6px;">发表新帖</a>
        </div>
    </div>
</div>

<div class="layui-container">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md8">
            <div class="fly-panel" style="margin-bottom: 0;">
                <div id="sort" class="fly-panel-title fly-filter">
                    <a href="/index?category=<%=category%>&sort=0&keywords=<%=keywords%>">按最新</a>
                    <span class="fly-mid"></span>
                    <a href="/index?category=<%=category%>&sort=1&keywords=<%=keywords%>">按热度</a>
                    <span class="fly-mid"></span>
                    <a href="/index?category=<%=category%>&sort=2&keywords=<%=keywords%>">按评论</a>
                </div>
                <ul class="fly-list">
                    <%
                        for (PostAndUserForIndex postAndUserForIndex : postAndUserForIndexList) {
                    %>
                    <li>
                        <a href="" class="fly-avatar">
                            <img src="<%= request.getContextPath() + postAndUserForIndex.getAvatar()%>"
                                 alt="<%= postAndUserForIndex.getUsername()%>">
                        </a>
                        <h2>
                            <a class="layui-badge"><%= Util.parseCategory(postAndUserForIndex.getCategory())%>
                            </a>
                            <a href="/detail?id=<%= postAndUserForIndex.getId()%>"><%= postAndUserForIndex.getTitle()%>
                            </a>
                        </h2>
                        <div class="fly-list-info">
                            <a href=""><cite
                                    style="color: #999999"><%=postAndUserForIndex.getUsername()%>
                            </cite></a>
                            <span><%= Util.parseTimestampToXxxBefore(postAndUserForIndex.getDatetime())%></span>
                            <span class="fly-list-nums">
                                <i class="iconfont icon-yulan1" title="人气"></i><%= postAndUserForIndex.getViews()%>
                                <i class="iconfont icon-pinglun1" title="回答"></i><%= postAndUserForIndex.getComment()%>
                            </span>
                        </div>
                    </li>
                    <%
                        }
                    %>

                </ul>
                <%
                    if (postAndUserForIndexList.size() == 0) {
                %>
                <div class="fly-none">没有相关数据</div>
                <%
                    }
                %>
                <%--                <div style="text-align: center">--%>
                <%--                    <div class="laypage-main">--%>
                <%--                        <span class="laypage-curr">1</span>--%>
                <%--                        <a href="/jie/page/2/">2</a>--%>
                <%--                        <a href="/jie/page/3/">3</a>--%>
                <%--                        <a href="/jie/page/4/">4</a>--%>
                <%--                        <a href="/jie/page/5/">5</a>--%>
                <%--                        <span>…</span>--%>
                <%--                        <a href="/jie/page/148/" class="laypage-last" title="尾页">尾页</a>--%>
                <%--                        <a href="/jie/page/2/" class="laypage-next">下一页</a>--%>
                <%--                    </div>--%>
                <%--                </div>--%>

            </div>
        </div>
        <div class="layui-col-md4">
            <dl class="fly-panel fly-list-one">
                <dt class="fly-panel-title">项目说明</dt>
                <dd style="white-space: normal; color: #333">
                    <h3>计本171<b>李宏旭</b>JSP程序设计实训作业作品</h3>
                    该项目仅针对:<br>
                    [2019秋JSP程序设计]题目类型二：论坛类网站, 要求设计开发.
                </dd>
                <dd style="white-space: normal; color: #333">
                    按照题目要求开发完成了<b>所有</b>需求功能, 当然为了论坛能够基本正常运作, 能够快乐, 也接了一些其他核心功能.
                </dd>
            </dl>
            <dl class="fly-panel fly-list-one">
                <dt class="fly-panel-title">🙈广告时间</dt>
                <dd style="white-space: normal; color: #333">
                    <li> 个人站点: <a href="https://lsun.net" target="_blank"> lsun.net</a></li>
                    <li> GitHub: <a href="https://github.com/YoungsunLi" target="_blank"> YoungsunLi</a></li>
                </dd>
            </dl>
            <dl class="fly-panel fly-list-one">
                <dt class="fly-panel-title">🙈广告时间</dt>
                <dd style="white-space: normal; color: #333">
                    <div class="fly-none">广告位招租</div>
                </dd>
            </dl>
        </div>
    </div>
</div>

<div class="fly-footer">
    <p>&copy; 2019<a href="https://lsun.net/">Youngsun Li.</a>Powered by Layui</p>
</div>

<script src="./res/layui/layui.js"></script>
<script>
    document.getElementsByClassName('category')[0].children[<%=category%>].classList.add('layui-this');
    document.getElementById('sort').children[<%=sort > 0 ? sort * 2 : 0%>].classList.add('layui-this');
    document.getElementById('keywords').value = '<%=keywords%>';
    document.getElementById('keywords2').value = '<%=keywords%>';

    layui.cache.page = '';
    layui.cache.user = {
        username: '游客'
        , uid: -1
        , avatar: './res/images/avatar/00.jpg'
        , experience: 83
        , sex: '男'
    };
    layui.config({
        version: "3.0.0"
        , base: './res/mods/' //这里实际使用时，建议改成绝对路径
    }).extend({
        fly: 'index'
    }).use(['fly', 'form'], function () {
    });
</script>
</body>
</html>