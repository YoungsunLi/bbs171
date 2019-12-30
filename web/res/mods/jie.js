layui.define('fly', function (exports) {

    var $ = layui.jquery;

    var gather = {}, dom = {
        jieda: $('#jieda')
        , content: $('#L_content')
        , jiedaCount: $('#jiedaCount')
    };

    //解答操作
    gather.jiedaActive = {
        reply: function (li) { //回复
            var val = dom.content.val();
            var aite = '@' + li.find('.fly-detail-user cite').text().replace(/\s/g, '');
            dom.content.focus();
            if (val.indexOf(aite) !== -1) return;
            dom.content.val(aite + ' ' + val);
        }
    };

    //定位分页
    if (/\/page\//.test(location.href) && !location.hash) {
        var replyTop = $('#flyReply').offset().top - 80;
        $('html,body').scrollTop(replyTop);
    }

    exports('jie', null);
});