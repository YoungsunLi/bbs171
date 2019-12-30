<%@ page import="net.lsun.bean.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>帐号设置</title>
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
    <li class="layui-nav-item layui-this">
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
        <li class="layui-this" lay-id="info">我的资料</li>
        <li lay-id="avatar">头像</li>
        <li lay-id="pass">密码</li>
      </ul>
      <div class="layui-tab-content" style="padding: 20px 0;">
        <div class="layui-form layui-form-pane layui-tab-item layui-show">
          <form method="post">
            <div class="layui-form-item">
              <label for="L_email" class="layui-form-label">手机</label>
              <div class="layui-input-inline">
                <input type="text" id="L_email" name="email" required lay-verify="email" autocomplete="off" value="" class="layui-input">
              </div>
              <div class="layui-form-mid layui-word-aux">--</div>
            </div>
            <div class="layui-form-item">
              <label for="L_username" class="layui-form-label">昵称</label>
              <div class="layui-input-inline">
                <input type="text" id="L_username" name="username" required lay-verify="required" autocomplete="off" value="" class="layui-input">
              </div>
              <div class="layui-inline">
                <div class="layui-input-inline">
                  <input type="radio" name="sex" value="0" checked title="男">
                  <input type="radio" name="sex" value="1" title="女">
                </div>
              </div>
            </div>
            <div class="layui-form-item layui-form-text">
              <label for="L_sign" class="layui-form-label">签名</label>
              <div class="layui-input-block">
                <textarea placeholder="随便写些什么刷下存在感" id="L_sign"  name="sign" autocomplete="off" class="layui-textarea" style="height: 80px;"></textarea>
              </div>
            </div>
            <div class="layui-form-item">
              <button class="layui-btn" key="set-mine" lay-filter="*" lay-submit>确认修改</button>
            </div>
          </div>
          
          <div class="layui-form layui-form-pane layui-tab-item">
            <div class="layui-form-item">
              <div class="avatar-add">
                <p>建议尺寸168*168，支持jpg、png、gif，最大不能超过50KB</p>
                <button type="button" class="layui-btn upload-img">
                  <i class="layui-icon">&#xe67c;</i>上传头像
                </button>
                <img src="https://tva1.sinaimg.cn/crop.0.0.118.118.180/5db11ff4gw1e77d3nqrv8j203b03cweg.jpg">
                <span class="loading"></span>
              </div>
            </div>
          </div>
          
          <div class="layui-form layui-form-pane layui-tab-item">
            <form action="/user/repass" method="post">
              <div class="layui-form-item">
                <label for="L_nowpass" class="layui-form-label">当前密码</label>
                <div class="layui-input-inline">
                  <input type="password" id="L_nowpass" name="nowpass" required lay-verify="required" autocomplete="off" class="layui-input">
                </div>
              </div>
              <div class="layui-form-item">
                <label for="L_pass" class="layui-form-label">新密码</label>
                <div class="layui-input-inline">
                  <input type="password" id="L_pass" name="pass" required lay-verify="required" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux">6到16个字符</div>
              </div>
              <div class="layui-form-item">
                <label for="L_repass" class="layui-form-label">确认密码</label>
                <div class="layui-input-inline">
                  <input type="password" id="L_repass" name="repass" required lay-verify="required" autocomplete="off" class="layui-input">
                </div>
              </div>
              <div class="layui-form-item">
                <button class="layui-btn" key="set-mine" lay-filter="*" lay-submit>确认修改</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="fly-footer">
  <p>&copy; 2019<a href="https://lsun.net/" >Youngsun Li.</a>Powered by Layui</p>
</div>

<script src="../res/layui/layui.js"></script>
<script>
layui.cache.page = 'user';
layui.cache.user = {
  username: '游客'
  ,uid: -1
  ,avatar: '../res/images/avatar/00.jpg'
  ,experience: 83
  ,sex: '男'
};
layui.config({
  version: "2.0.0"
  ,base: '../res/mods/'
}).extend({
  fly: 'index'
}).use('fly');
</script>

</body>
</html>