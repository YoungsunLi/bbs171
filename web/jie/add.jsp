<%@ page import="net.lsun.bean.PostForUpdate" %>
<%@ page import="net.lsun.bean.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    boolean edit = request.getAttribute("edit") != null;
    PostForUpdate postForUpdate = new PostForUpdate();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <%
        if (edit) {
            postForUpdate = (PostForUpdate) request.getAttribute("postForUpdate");
    %>
    <title>编辑帖子</title>
    <%
    } else {
    %>
    <title>发表新帖</title>
    <%
        }
    %>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1" name="viewport">
    <link href="../res/layui/css/layui.css" rel="stylesheet">
    <link href="../res/css/global.css" rel="stylesheet">
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

<div class="layui-container fly-marginTop">
    <div class="fly-panel" pad20 style="padding-top: 5px;">
        <!--<div class="fly-none">没有权限</div>-->
        <div class="layui-form layui-form-pane">
            <div class="layui-tab layui-tab-brief" lay-filter="user">
                <ul class="layui-tab-title">
                    <%
                        if (edit) {
                    %>
                    <li class="layui-this">编辑帖子</li>
                    <%
                    } else {
                    %>
                    <li class="layui-this">发表新帖</li>
                    <%
                        }
                    %>
                </ul>
                <div class="layui-form layui-tab-content" id="LAY_ucm" style="padding: 20px 0;">
                    <div class="layui-tab-item layui-show">
                        <form class="layui-form">
                            <div class="layui-row layui-col-space15 layui-form-item">
                                <div class="layui-col-md3">
                                    <label class="layui-form-label">所在板块</label>
                                    <div class="layui-input-block">
                                        <select lay-filter="column" lay-verify="required" name="category" id="category">
                                            <option value="1">默认</option>
                                            <option value="2">学习</option>
                                            <option value="3">生活</option>
                                            <option value="4">表白墙</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="layui-col-md9">
                                    <label class="layui-form-label" for="L_title">标题</label>
                                    <div class="layui-input-block">
                                        <input autocomplete="off" class="layui-input" id="L_title" lay-verify="required"
                                               name="title"
                                               placeholder="请输入标题"
                                               required type="text"
                                               value="<%= edit ? postForUpdate.getTitle() : ""%>">
                                    </div>
                                </div>
                            </div>
                            <div class="layui-form-item layui-form-text">
                                <div class="layui-input-block">
                                    <textarea class="layui-textarea fly-editor" id="L_content" lay-verify="required"
                                              name="content"
                                              placeholder="详细描述" required
                                              style="height: 260px;"
                                              maxlength="10000"><%= edit ? postForUpdate.getContent() : ""%></textarea>
                                </div>
                            </div>
                            <div class="layui-form-item">
                                <input type="hidden" name="id" value="<%= postForUpdate.getId()%>">
                                <button id="add" class="layui-btn" lay-filter="add"
                                        lay-submit><%= edit ? "提交编辑" : "立即发布"%>
                                </button>
                            </div>
                        </form>
                    </div>
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
    document.getElementById('category')[<%= edit ? postForUpdate.getCategory() - 1 : 0%>].selected = true;

    layui.cache.page = 'jie';
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
    }).use(['fly', 'form'], function () {
        let forms = layui.form;
        let $ = layui.$;

        let user = '<%= session.getAttribute("user")%>';
        if (user === 'null') {
            layer.msg('登录后才可以发表新帖哦~', {icon: 7, anim: 6});
            setTimeout(function () {
                location.href = '../user/login.jsp';
            }, 2000)
        }

        forms.on('submit(add)', function (data) {
            $.ajax({
                type: 'post',
                url: '/submit_post',
                data: data.field,
                dataType: "json",
                success: function (res) {
                    $("#add").addClass("layui-btn-disabled");
                    $('#add').attr('disabled', "true");
                    if (res.success) {
                        layer.msg(res.msg, {icon: 6});
                        setTimeout(function () {
                            location.href = '<%= edit ? "/detail?id="+postForUpdate.getId() : "/"%>';
                        }, 1500)
                    } else {
                        $("#add").addClass("layui-btn-enabled");
                        $('#add').attr('disabled', "false");
                        layer.msg(res.msg, {icon: 5, anim: 6});
                    }
                },
                error: function (msg) {
                    console.log(msg);
                    layer.msg('请求失败!', {icon: 2, anim: 6});
                }
            });
            return false;
        });
    });
</script>

</body>
</html>