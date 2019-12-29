<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String phone = request.getParameter("phone");

    if (phone == null) {
        phone = "";
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <title>登入</title>
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
    </div>
</div>

<div class="layui-container fly-marginTop">
    <div class="fly-panel fly-panel-user" pad20>
        <div class="layui-tab layui-tab-brief" lay-filter="user">
            <ul class="layui-tab-title">
                <li class="layui-this">登入</li>
                <li><a href="../user/reg.jsp">注册</a></li>
            </ul>
            <div class="layui-form layui-tab-content" id="LAY_ucm" style="padding: 20px 0;">
                <div class="layui-form layui-form-pane">
                    <form class="layui-form">
                        <div class="layui-form-item">
                            <label class="layui-form-label" for="L_phone">手机</label>
                            <div class="layui-input-inline">
                                <input autocomplete="off" class="layui-input" id="L_phone" lay-verify="required"
                                       name="phone" required type="text" value="<%= phone%>">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label" for="L_pass">密码</label>
                            <div class="layui-input-inline">
                                <input autocomplete="off" class="layui-input" id="L_pass" lay-verify="required"
                                       name="password" required type="password" value="">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <button class="layui-btn" lay-filter="login" lay-submit>立即登录</button>
                            <%--                            <span style="padding-left:20px;"><a href="forget.html">忘记密码？</a></span>--%>
                        </div>
                    </form>
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
    }).use(['fly', 'form'], function () {
        let forms = layui.form;
        let $ = layui.$;

        forms.on('submit(login)', function (data) {
            $.ajax({
                type: 'post',
                url: '/login',
                data: data.field,
                dataType:"json",
                success: function (res) {
                    if (res.success) {
                        layer.msg(res.msg, {icon: 6});
                        setTimeout(function () {
                            location.href = '/';
                        }, 2000)
                    } else {
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