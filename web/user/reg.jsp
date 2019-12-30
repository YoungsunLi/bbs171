<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <title>注册</title>
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
                <li><a href="../user/login.jsp">登入</a></li>
                <li class="layui-this">注册</li>
            </ul>
            <div class="layui-form layui-tab-content" id="LAY_ucm" style="padding: 20px 0;">
                <div class="layui-form">
                    <form class="layui-form layui-form-pane">
                        <div class="layui-form-item">
                            <label class="layui-form-label" for="L_phone">手机</label>
                            <div class="layui-input-inline">
                                <input autocomplete="off" class="layui-input" id="L_phone" lay-verify="phone"
                                       name="phone" required type="text" value="">
                            </div>
                            <div class="layui-form-mid layui-word-aux">将会成为您唯一的登入名</div>
                        </div>
                        <div style="margin-bottom: 40px">
                            <label class="layui-form-label">验证码</label>
                            <label class="layui-input-inline" style="width: 121px; ">
                                <input autocomplete="off" class="layui-input" lay-verify="required"
                                       name="code" required type="text" value="">
                            </label>
                            <button class="layui-btn" id="get_code">获取</button>
                        </div>

                        <div class="layui-form-item">
                            <label class="layui-form-label" for="L_username">昵称</label>
                            <div class="layui-input-inline">
                                <input autocomplete="off" class="layui-input" id="L_username" lay-verify="required"
                                       name="username" required type="text" value="">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label" for="L_pass">密码</label>
                            <div class="layui-input-inline">
                                <input autocomplete="off" class="layui-input" id="L_pass" lay-verify="required"
                                       name="password" required type="password" value="">
                            </div>
                            <div class="layui-form-mid layui-word-aux">6到16个字符</div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label" for="L_repass">确认密码</label>
                            <div class="layui-input-inline">
                                <input autocomplete="off" class="layui-input" id="L_repass" lay-verify="required"
                                       name="repassword" required type="password" value="">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <input type="radio" name="gender" value="男" title="男" checked="">
                            <input type="radio" name="gender" value="女" title="女">
                        </div>
                        <div class="layui-form-item">
                            <button class="layui-btn" lay-filter="reg" lay-submit>立即注册</button>
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
        version: "3.0.0",
        base: '../res/mods/',
        uid: '277013309'
    }).extend({
        fly: 'index'
    }).use(['fly', 'form'], function () {
        let forms = layui.form;
        let $ = layui.$;

        $("#get_code").click(function () {
            if (!/^1[3456789]\d{9}$/.test($("#L_phone").val())) {
                layer.msg('请输入正确的手机号', {icon: 5, anim: 6});
                return false;
            }

            let ele = this;
            $.ajax({
                type: "post",
                url: "/send_sms",
                data: {
                    phone: $("#L_phone").val(),
                },
                dataType: 'json',
                success: function (res) {
                    if (res.success) {
                        $("#get_code").addClass(" layui-btn-disabled");
                        $('#get_code').attr('disabled', "true");
                        setTime(ele);
                        console.log(res);
                        if (res.data.Code === 'OK') {
                            layer.msg(res.msg, {icon: 6});
                        } else {
                            console.log(res.data.Message);
                            layer.msg("发送异常", {icon: 5, anim: 6});
                        }
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

        forms.on('submit(reg)', function (data) {
            if (data.field.password.length < 6 || data.field.password.length > 16) {
                layer.msg('密码长度必须为6到16个字符!', {icon: 5, anim: 6});
            } else if (data.field.password !== data.field.repassword) {
                layer.msg('两次密码不一致!', {icon: 5, anim: 6});
            } else {
                $.ajax({
                    type: 'post',
                    url: '/reg',
                    data: data.field,
                    dataType: "json",
                    success: function (res) {
                        if (res.success) {
                            layer.msg(res.msg, {icon: 6});
                            setTimeout(function () {
                                location.href = '/user/login.jsp?phone=' + data.field.phone;
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
            }
            return false;
        });
    });

    let time = 60;

    function setTime(obj) {
        if (time === 0) {
            obj.removeAttribute("disabled");
            obj.classList.remove("layui-btn-disabled");
            obj.innerText = "获取";
            time = 120;
            return;
        } else {
            obj.innerText = "获取(" + time + ")";
            time--;
        }
        setTimeout(function () {
            setTime(obj)
        }, 1000)
    }

</script>
</body>
</html>