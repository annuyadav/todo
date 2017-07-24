function display_notice(key, msg) {
    new PNotify({
        type: key,
        text: msg,
        delay: 3000,
        mouse_reset: false,
        nonblock: {
            nonblock: true
        },
        buttons: {
            sticker: false
        }
    });
}


$(document).ajaxComplete(function (event, request) {
    var msg = request.getResponseHeader('X-Message');
    var type = request.getResponseHeader('X-Message-Type');
    if (type != null)display_notice(type, msg); //use whatever popup, notification or whatever plugin you want
});

//--- Showing the loading indicator for ajax requests ---//
$(function () {
    $('.loading_animation').hide();  // hide it initially.
    $(document)
        .ajaxStart(function () {
            $('.loading_animation').show(); // show on any Ajax event.
        })
        .ajaxStop(function () {
            $('.loading_animation').hide(); // hide it when it is done.
        });
});