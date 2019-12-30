<%@ page import="net.lsun.bean.CommentAndUser" %>
<%@ page import="net.lsun.bean.PostAndUserForDetail" %>
<%@ page import="net.lsun.bean.User" %>
<%@ page import="net.lsun.utils.Util" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    PostAndUserForDetail postAndUserForDetail = (PostAndUserForDetail) request.getAttribute("postAndUserForDetail");
    List<CommentAndUser> commentAndUserList = (List) request.getAttribute("commentAndUserList");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <title><%= postAndUserForDetail.getTitle()%>
    </title>
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
                    <dd><a href="../user/set.html"><i class="layui-icon">&#xe620;</i>基本设置</a>
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
            <li><a href="/index?category=0">综合</a></li>
            <li><a href="/index?category=1">默认</a></li>
            <li><a href="/index?category=2">学习</a></li>
            <li><a href="/index?category=3">生活</a></li>
            <li><a href="/index?category=4">表白墙</a></li>

            <%
                if (user != null) {
            %>
            <!-- 用户登入后显示 -->
            <li class="layui-hide-xs layui-hide-sm layui-show-md-inline-block"><span class="fly-mid"></span></li>
            <li class="layui-hide-sm layui-show-md-inline-block"><a href="/to?href=/user/index.jsp">我发表的贴</a></li>
            <%
                }
            %>
        </ul>

        <div class="fly-column-right layui-hide-xs">
            <a class="layui-btn" href="/to?href=/jie/add.jsp" style="margin-left: 10px">发表新帖</a>
        </div>
        <div class="layui-hide-sm layui-show-xs-block"
             style="margin-top: -10px; padding-bottom: 10px; text-align: center;">
            <a class="layui-btn" href="/to?href=/jie/add.jsp" style="margin-left: 6px;">发表新帖</a>
        </div>
    </div>
</div>

<div class="layui-container">
    <div class="layui-row layui-col-space15">
        <div class="content detail layui-col-md8">
            <div class="fly-panel detail-box">
                <h1><%= postAndUserForDetail.getTitle()%>
                </h1>
                <div class="fly-detail-info">
                    <span class="layui-badge layui-bg-gray"><%= Util.parseCategory(postAndUserForDetail.getCategory())%></span>
                    <%
                        if (postAndUserForDetail.getStatus() == 0) {
                    %>
                    <span class="layui-badge layui-bg-orange">审核中</span>
                    <%
                        }
                        if (user != null && (user.getType() == 0 || user.getPhone().equals(postAndUserForDetail.getPhone()))) {
                    %>
                    <div class="fly-admin-box">
                        <span class="layui-btn layui-btn-xs " onclick="editPost();">编辑此贴</span>
                        <%
                            if (postAndUserForDetail.getStatus() == 2) {
                        %>
                        <span class="layui-btn layui-btn-xs layui-bg-red">已删除</span>
                        <%
                        } else {
                        %>
                        <span class="layui-btn layui-btn-xs layui-bg-red"
                              onclick="managePost(<%= postAndUserForDetail.getId()%>, 2);">删除</span>
                        <%
                            }
                        %>
                    </div>
                    <%
                    } else {
                    %>
                    <div class="fly-admin-box">
                        <span class="layui-btn layui-btn-xs layui-bg-red"
                              onclick="reportPost(<%= postAndUserForDetail.getId()%>);">举报</span>
                    </div>
                    <%
                        }
                    %>
                    <span class="fly-list-nums">
            <i class="iconfont" title="人气">&#xe60b;</i> <%= postAndUserForDetail.getViews()%>
            <a href="#comment"><i class="iconfont" title="回答">&#xe60c;</i><%= postAndUserForDetail.getComment()%></a>
          </span>
                </div>
                <div class="detail-about">
                    <a class="fly-avatar" href="">
                        <img alt="<%= postAndUserForDetail.getUsername()%>"
                             src="<%= request.getContextPath()+ postAndUserForDetail.getAvatar()%>">
                    </a>
                    <div class="fly-detail-user">
                        <a class="fly-link" href="">
                            <cite><%= postAndUserForDetail.getUsername()%>
                            </cite>
                        </a>
                        <span><%= Util.parseTimestampToXxxBefore(postAndUserForDetail.getDatetime())%></span>
                    </div>
                    <div class="detail-hits">
                        <span class="layui-badge layui-bg-gray"><%= postAndUserForDetail.getGender()%></span>
                        <%= postAndUserForDetail.getSign()%>
                    </div>
                </div>
                <div class="detail-body photos">
                    <%= postAndUserForDetail.getContent()%>
                </div>
            </div>

            <div class="fly-panel detail-box" id="flyReply">
                <fieldset class="layui-elem-field layui-field-title" style="text-align: center;">
                    <legend>回帖</legend>
                </fieldset>

                <ul class="jieda" id="jieda">
                    <%
                        for (CommentAndUser commentAndUser : commentAndUserList) {
                    %>

                    <li class="jieda-daan" data-id="111">
                        <div class="detail-about detail-about-reply">
                            <a class="fly-avatar" href=""><img alt="<%= commentAndUser.getUsername()%>"
                                                               src="<%= request.getContextPath()+ commentAndUser.getAvatar()%>"></a>
                            <div class="fly-detail-user">
                                <a class="fly-link" href="">
                                    <cite><%= commentAndUser.getUsername()%>
                                    </cite>
                                    <%
                                        if (commentAndUser.getFrom_phone().equals(postAndUserForDetail.getPhone())) {
                                    %>
                                    <span>(楼主)</span>
                                    <%
                                        }
                                        if (commentAndUser.getType() == 0) {
                                    %>
                                    <span style="color:#5FB878">(管理员)</span>
                                    <%
                                        }
                                    %>
                                </a>
                            </div>

                            <div class="detail-hits">
                                <span><%= Util.parseTimestampToXxxBefore(commentAndUser.getDatetime())%></span>
                            </div>
                        </div>
                        <div class="detail-body jieda-body photos"><%= commentAndUser.getContent()%>
                        </div>
                        <div class="jieda-reply">
                            <span type="reply"><i class="iconfont icon-svgmoban53"></i>回复 </span>
                            <%
                                if (user != null && (user.getType() == 0 || user.getPhone().equals(commentAndUser.getFrom_phone()))) {
                            %>
                            <div class="jieda-admin">
                                <span onclick="editPost()">编辑</span>
                                <span onclick="delComment(<%= commentAndUser.getId()%>);">删除</span>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </li>
                    <%
                        }

                        if (commentAndUserList.size() == 0) {
                    %>
                    <li class="fly-none">还没有回复哦</li>
                    <%
                        }
                    %>
                </ul>

                <div class="layui-form layui-form-pane">
                    <form class="layui-form">
                        <div class="layui-form-item layui-form-text">
                            <a name="comment"></a>
                            <div class="layui-input-block">
                                <textarea class="layui-textarea fly-editor" id="L_content" lay-verify="required"
                                          name="content"
                                          placeholder="请输入内容"
                                          required
                                          style="height: 150px;"
                                          maxlength="2000"></textarea>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <input type="hidden" name="post_id" value="<%= postAndUserForDetail.getId()%>">
                            <button id="comment" class="layui-btn" lay-filter="comment" lay-submit>提交回复</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div class="layui-col-md4">
            <dl class="fly-panel fly-list-one">
                <dt class="fly-panel-title">项目说明</dt>
                <dd style="white-space: normal; color: #333">
                    <h3>计本171<b>李宏旭</b>JSP程序设计实训作业作品</h3>
                    该项目仅针对:<br>
                    [2019秋JSP程序设计]题目类型二：论坛类网站要求开发.
                </dd>
                <dd style="white-space: normal; color: #333">
                    仅按照题目要求开发完成所有需求功能, 少部分实现其他一些功能. 所以站点其他很多不在题目要求内功能多为不可用状态或者入口已被删除.时间有限! 时间有限! 时间有限!
                </dd>
            </dl>
            <dl class="fly-panel fly-list-one">
                <dt class="fly-panel-title">👌广告时间</dt>
                <dd style="white-space: normal; color: #333">
                    <li> 个人站点: <a href="https://lsun.net" target="_blank"> lsun.net</a></li>
                    <li> GitHub: <a href="https://github.com/YoungsunLi" target="_blank"> YoungsunLi</a></li>
                </dd>
            </dl>
            <dl class="fly-panel fly-list-one">
                <dt class="fly-panel-title">👌广告时间</dt>
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

<script src="../res/layui/layui.js"></script>
<script>
    let managePost;
    let editPost;
    let delComment;
    let reportPost;
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
    }).use(['fly', 'face', 'form'], function () {
        let $ = layui.$, fly = layui.fly;
        $('.detail-body').each(function () {
            let othis = $(this), html = othis.html();
            othis.html(fly.content(html));
        });

        let forms = layui.form;
        let user = '<%= session.getAttribute("user")%>';
        forms.on('submit(new_post)', function () {
            if (user === 'null') {
                layer.msg('登录后才可以发表新帖哦~', {icon: 7, anim: 6});
                setTimeout(function () {
                    location.href = '../user/login.jsp';
                }, 2000)
            } else {
                location.href = '/to?href=/jie/add.jsp';
            }
            return false;
        });

        forms.on('submit(comment)', function (data) {
            if (user === 'null') {
                layer.msg('登录后才可以回复哦~', {icon: 7, anim: 6});
            } else {
                $.ajax({
                    type: 'post',
                    url: '/comment',
                    data: data.field,
                    dataType: "json",
                    success: function (res) {
                        $("#comment").addClass(" layui-btn-disabled");
                        $('#comment').attr('disabled', "true");
                        if (res.success) {
                            layer.msg(res.msg, {icon: 6});
                            setTimeout(function () {
                                location.reload();
                            }, 2000)
                        } else {
                            $("#comment").addClass(" layui-btn-enabled");
                            $('#comment').attr('disabled', "false");
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

        managePost = function (id, status) {
            layer.confirm("确定要该帖子删除吗?", function (index) {
                layer.close(index);
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
                                location.href = '/';
                            }, 800)
                        } else {
                            layer.msg(res.msg, {icon: 5, anim: 6});
                        }
                    },
                    error: function (msg) {
                        console.log(msg);
                        layer.msg('请求失败!', {icon: 2, anim: 6});
                    }
                });
            });
        };

        delComment = function (id) {
            layer.confirm("确定要删除该评论吗?", function (index) {
                layer.close(index);
                $.ajax({
                    type: 'post',
                    url: '/del-comment',
                    data: {
                        id: id
                    },
                    dataType: "json",
                    success: function (res) {
                        if (res.success) {
                            layer.msg(res.msg, {icon: 6});
                            setTimeout(function () {
                                location.reload();
                            }, 800)
                        } else {
                            layer.msg(res.msg, {icon: 5, anim: 6});
                        }
                    },
                    error: function (msg) {
                        console.log(msg);
                        layer.msg('请求失败!', {icon: 2, anim: 6});
                    }
                });
            });
        };

        reportPost = function (id) {
            if (user === 'null') {
                layer.msg('登录后才可以举报!', {icon: 7, anim: 6});
            } else {
                layer.prompt({title: '为什么举报人家呀?', formType: 2}, function (text, index) {
                    layer.close(index);
                    // layer.msg(text, {icon: 1});
                    $.ajax({
                        type: 'post',
                        url: '/report-post',
                        data: {
                            post_id: id,
                            content: text
                        },
                        dataType: "json",
                        success: function (res) {
                            if (res.success) {
                                layer.msg(res.msg, {icon: 6});
                                setTimeout(function () {
                                    location.reload();
                                }, 800)
                            } else {
                                layer.msg(res.msg, {icon: 5, anim: 6});
                            }
                        },
                        error: function (msg) {
                            console.log(msg);
                            layer.msg('请求失败!', {icon: 2, anim: 6});
                        }
                    });
                });
            }
        };

        editPost = function () {
            layer.msg('还不得编辑!', {icon: 2, anim: 6})
        };
    });
</script>
</body>
</html>