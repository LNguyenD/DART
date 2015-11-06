function showLoading() {
    var img_loading = $(".ui-dialog-titlebar").next().children("img[alt=loading]");
    if (img_loading.length > 0) {
        img_loading.parent().prev().hide(); 
    }
    $("#loading").overlay().load();
    return true;
}

function hideLoading() {
    $("#loading").overlay().close();    
    return true;
}

function actionClick(value, isConfirm) {
    $("#action").attr("value", value);
    isConfirm = (typeof isConfirm != 'undefined' && isConfirm == true) ? true : false;
    if (isConfirm) {
        confirmSubmit("Notification!", "Are your sure?");
    } else {
        $('form').submit();
    }
}

function CompleteFunction(ajaxContext) {   
    $('.message').removeClass('hide');
    hideLoading();    
    return false;
}

function showHideMessage() {
    $('.message').toggleClass('hide');
}

$(document).ready(function () {
    $('input:text:visible:first').focus();
    if (top.location != location) {
        top.location.href = document.location.href;
    }
    if ($('.message').text() == "") {
        $('.message').addClass('hide');
    }

    $("#loading").overlay({
        // some mask tweaks suitable for modal dialogs
        mask: {
            color: '#000',
            loadSpeed: 200,
            opacity: 0.6
        },
        top: '45%',
        closeOnClick: false
    });

    $('.close').click(function () {
        $(this).parent().next('.box-content').toggle();
    });

    //$('.datepicker').attr('readonly', false);

    // Init Dialog     
    $("#dialog-confirm").dialog({
        autoOpen: false,
        modal: true
    });
});

// Overload Dialog function 
function confirmSubmit(title, text) {
    var dialogOpts = {
        title: title,
        modal: true,
        autoOpen: false,
        buttons: {
            "Cancel": function () {
                if ($("#hddAction").length > 0) {
                    $("#hddAction").val("");
                }
                $(this).dialog("close");
            },
            "Ok": function () {
                $(this).dialog("close");
                $('form').submit();
            }
        }
    };
    $("#dialog-confirm").dialog(dialogOpts).html("<span class='ui-icon ui-icon-alert'style='float:left; margin:0 7px 20px 0;'></span>" + text).dialog('open');    
}

function confirmOK(title, text) {
    var dialogOpts = {
        title: title,
        modal: true,
        autoOpen: false,
        buttons: {
            Ok: function () {
                if ($("#hddAction").length > 0) {
                    $("#hddAction").val("");
                }
                $(this).dialog("close");
            }
        }
    };
    $("#dialog-confirm").dialog(dialogOpts).html("<span class='ui-icon ui-icon-alert'style='float:left; margin:0 7px 20px 0;'></span>" + text).dialog('open');
}
