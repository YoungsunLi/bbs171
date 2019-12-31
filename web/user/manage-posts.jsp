<%@ page import="net.lsun.bean.PostAndUserForManage" %>
<%@ page import="net.lsun.bean.User" %>
<%@ page import="net.lsun.utils.Util" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    List<PostAndUserForManage> postAndUserForManageList = (List) request.getAttribute("postAndUserForManageList");
    int category = request.getParameter("category") != null ? Integer.parseInt(request.getParameter("category")) : 0;
    int sort = request.getParameter("sort") != null ? Integer.parseInt(request.getParameter("sort")) : 0;
    int status = request.getParameter("status") != null ? Integer.parseInt(request.getParameter("status")) : 3;
    String keywords = (String) request.getAttribute("keywords");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>管理帖子</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="../res/layui/css/layui.css">
    <link rel="stylesheet" href="../res/css/global.css">
</head>
<body style="white-space: nowrap; overflow-x: auto;">

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
        <li class="layui-nav-item">
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
        <li class="layui-nav-item  layui-this">
            <a href="/manage-posts">
                <i class="layui-icon">&#xe632;</i>
                管理帖子
            </a>
        </li>
    </ul>

    <div class="site-tree-mobile layui-hide">
        <i class="layui-icon">&#xe602;</i>
    </div>
    <div class="site-mobile-shade"></div>

    <div class="site-tree-mobile layui-hide">
        <i class="layui-icon">&#xe602;</i>
    </div>
    <div class="site-mobile-shade"></div>


    <div class="fly-panel fly-panel-user" pad20 style="min-width: 958px">
        <form class="layui-form layui-form-pane" method="post" action="/manage-posts"
              style="padding-top: 8px">
            <div class="layui-form-item">
                <label class="layui-form-label" style="width: 64px">板块</label>
                <label class="layui-form layui-input-inline" style="width: 90px;">
                    <select name="category" id="category">
                        <option value="0">综合</option>
                        <option value="1">默认</option>
                        <option value="2">学习</option>
                        <option value="3">生活</option>
                        <option value="4">表白墙</option>
                    </select>
                </label>
                <label class="layui-form-label" style="width: 64px">排序</label>
                <label class="layui-form layui-input-inline" style="width: 90px;">
                    <select name="sort" id="sort">
                        <option value="0">按最新</option>
                        <option value="1">按热度</option>
                        <option value="2">按评论</option>
                        <option value="3">按举报</option>
                    </select>
                </label>
                <label class="layui-form-label" style="width: 64px">状态</label>
                <label class="layui-form layui-input-inline" style="width: 90px;">
                    <select name="status" id="status">
                        <option value="0">未审核</option>
                        <option value="1">已审核</option>
                        <option value="2">已删除</option>
                        <option value="3">全部</option>
                    </select>
                </label>
                <label class="layui-form-label" style="width: 64px">搜索</label>
                <label class="layui-form layui-input-inline">
                    <input id="keywords" type="text" name="keywords" placeholder="标题关键字(选填)" autocomplete="off"
                           class="layui-input">
                </label>
                <button class="layui-btn" type="submit">查询</button>
            </div>
        </form>
        <div class="layui-tab-item layui-show">
            <table class="layui-table" lay-size="sm" lay-skin="line" style="text-align: center">
                <colgroup>
                    <col width="48">
                    <col width="72">
                    <col width="72">
                    <col>
                    <col width="110">
                    <col width="134">
                    <col width="58">
                    <col width="58">
                    <col width="58">
                    <col width="127">
                </colgroup>
                <thead>
                <tr>
                    <th style="text-align: center">序号</th>
                    <th style="text-align: center">状态</th>
                    <th style="text-align: center">板块</th>
                    <th>ID & 标题</th>
                    <th style="text-align: center">作者</th>
                    <th style="text-align: center">发帖时间</th>
                    <th style="text-align: center">访问量</th>
                    <th style="text-align: center">评论量</th>
                    <th style="text-align: center">举报量</th>
                    <th style="text-align: center">操作</th>
                </tr>
                </thead>
                <tbody>
                <%
                    for (int i = 0; i < postAndUserForManageList.size(); i++) {
                %>
                <tr>
                    <td><%= i + 1%>
                    </td>
                    <td>
                        <%
                            if (postAndUserForManageList.get(i).getStatus() == 1) {
                        %>
                        <span class="layui-badge-rim" style="color: #009688; border-color: #009688">已审核</span>
                        <%
                        } else if (postAndUserForManageList.get(i).getStatus() == 0) {
                        %>
                        <span class="layui-badge-rim" style="color: #FFB800; border-color: #FFB800">未审核</span>
                        <%
                        } else if (postAndUserForManageList.get(i).getStatus() == 2) {
                        %>
                        <span class="layui-badge-rim" style="color: #FF5722; border-color: #FF5722">已删除</span>
                        <%
                            }
                        %>
                    </td>
                    <td>
                        <span class="layui-badge-rim"><%= Util.parseCategory(postAndUserForManageList.get(i).getCategory())%></span>
                    </td>
                    <td style="text-align: left">
                        <a class="jie-title"
                           href="/detail?id=<%= postAndUserForManageList.get(i).getId()%>"
                           target="_blank" style="width: 320px"><span
                                class="layui-badge-rim"><%= postAndUserForManageList.get(i).getId()%></span> <%= postAndUserForManageList.get(i).getTitle()%>
                        </a>
                    </td>
                    <td>
                        <a class="jie-title"
                           href="" target="_blank"
                           style="width: 320px"><%= postAndUserForManageList.get(i).getUsername()%>
                        </a>
                    </td>
                    <td><%= Util.parseTimestampToString(postAndUserForManageList.get(i).getDatetime())%>
                    </td>
                    <td><%= postAndUserForManageList.get(i).getViews()%>
                    </td>
                    <td><%= postAndUserForManageList.get(i).getComment()%>
                    </td>
                    <td><%= postAndUserForManageList.get(i).getReport()%>
                    </td>
                    <td>
                        <%
                            if (postAndUserForManageList.get(i).getStatus() == 1) {
                        %>
                        <span class="layui-btn layui-btn-xs layui-bg-orange"
                              onclick="managePost(<%= postAndUserForManageList.get(i).getId()%>, 0);">重新审核</span>
                        <span class="layui-btn layui-btn-xs layui-bg-red"
                              onclick="managePost(<%= postAndUserForManageList.get(i).getId()%>, 2);">删除</span>
                        <%
                        } else if (postAndUserForManageList.get(i).getStatus() == 0) {
                        %>
                        <span class="layui-btn layui-btn-xs layui-bg-green"
                              onclick="managePost(<%= postAndUserForManageList.get(i).getId()%>, 1);">通过审核</span>
                        <span class="layui-btn layui-btn-xs layui-bg-red"
                              onclick="managePost(<%= postAndUserForManageList.get(i).getId()%>, 2);">删除</span>
                        <%
                        } else if (postAndUserForManageList.get(i).getStatus() == 2) {
                        %>
                        <%--                        <span class="layui-btn layui-btn-xs layui-bg-green" onclick="managePost(<%= post.getId()%>, 1);">恢复到已审核</span>--%>
                        <span class="layui-btn layui-btn-xs layui-bg-gray"
                              onclick="managePost(<%= postAndUserForManageList.get(i).getId()%>, 0);">恢复到未审核</span>
                        <%
                            }
                        %>
                    </td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
            <%
                if (postAndUserForManageList.size() == 0) {
            %>
            <li class="fly-none">暂无数据</li>
            <%
                }
            %>
            <div id="LAY_page"></div>
        </div>
    </div>
</div>

<div class="fly-footer">
    <p>&copy; 2019<a href="https://lsun.net/">Youngsun Li.</a>Powered by Layui</p>
</div>

<script src="../res/layui/layui.js"></script>
<script>
    // 恢复表单
    document.getElementById('category')[<%=category%>].selected = true;
    document.getElementById('sort')[<%=sort%>].selected = true;
    document.getElementById('status')[<%=status%>].selected = true;
    document.getElementById('keywords').value = '<%= keywords%>';

    let managePost;

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
    }).use('fly', function () {
        let $ = layui.$;
        managePost = function (id, status) {
            $.ajax({
                type: 'post',
                url: '/manage-post',
                data: {
                    id: id,
                    status: status
                },
                dataType: "json",
                success: function (res) {
                    if (res.success) {
                        layer.msg(res.msg, {icon: 6});
                        setTimeout(function () {
                            location.reload();
                        }, 1500)
                    } else {
                        layer.msg(res.msg, {icon: 5, anim: 6});
                    }
                },
                error: function (msg) {
                    console.log(msg);
                    layer.msg('请求失败!', {icon: 2, anim: 6});
                }
            });
        }
    });
</script>
</body>
</html>