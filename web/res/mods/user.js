/**

 @Name: 用户模块

 */

layui.define(['laypage', 'fly', 'element', 'flow'], function(exports){

  var $ = layui.jquery;
  var layer = layui.layer;
  var util = layui.util;
  var laytpl = layui.laytpl;
  var form = layui.form;
  var laypage = layui.laypage;
  var fly = layui.fly;
  var flow = layui.flow;
  var element = layui.element;
  var upload = layui.upload;

  var gather = {}, dom = {
    mine: $('#LAY_mine')
    ,mineview: $('.mine-view')
    ,minemsg: $('#LAY_minemsg')
    ,infobtn: $('#LAY_btninfo')
  };


  //显示当前tab
  if(location.hash){
    element.tabChange('user', location.hash.replace(/^#/, ''));
  }

  element.on('tab(user)', function(){
    var othis = $(this), layid = othis.attr('lay-id');
    if(layid){
      location.hash = layid;
    }
  });

  //根据ip获取城市
  if($('#L_city').val() === ''){
    $.getScript('http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js', function(){
      $('#L_city').val(remote_ip_info.city||'');
    });
  }

  //上传图片
  if($('.upload-img')[0]){
    layui.use('upload', function(upload){
      var avatarAdd = $('.avatar-add');

      upload.render({
        elem: '.upload-img'
        ,url: '/upload'
        ,size: 2048
        ,before: function(){
          avatarAdd.find('.loading').show();
        }
        ,done: function(res){
          if(res.success){
            console.log(res);
            $.post('/update_user_avatar', {
              avatar: res.data.url
            }, function(res){
                location.reload();
            });
          } else {
            layer.msg(res.msg, {icon: 5});
          }
          avatarAdd.find('.loading').hide();
        }
        ,error: function(){
          avatarAdd.find('.loading').hide();
        }
      });
    });
  }

  //合作平台
  if($('#LAY_coop')[0]){

    //资源上传
    $('#LAY_coop .uploadRes').each(function(index, item){
      var othis = $(this);
      upload.render({
        elem: item
        ,url: '/api/upload/cooperation/?filename='+ othis.data('filename')
        ,accept: 'file'
        ,exts: 'zip'
        ,size: 30*1024
        ,before: function(){
          layer.msg('正在上传', {
            icon: 16
            ,time: -1
            ,shade: 0.7
          });
        }
        ,done: function(res){
          if(res.code == 0){
            layer.msg(res.msg, {icon: 6})
          } else {
            layer.msg(res.msg)
          }
        }
      });
    });

  }

  //提交成功后刷新
  fly.form['set-mine'] = function(data, required){
    layer.msg('修改成功', {
      icon: 1
      ,time: 1000
      ,shade: 0.1
    }, function(){
      location.reload();
    });
  };

  dom.minemsg[0] && gather.minemsg();

  exports('user', null);

});