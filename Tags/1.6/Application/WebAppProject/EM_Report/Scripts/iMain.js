var metricLightHref="";
$.extend({
        getParamValue: function (paramName,url) {
            ///	<summary>
            ///		Get the value of input parameter from the querystring
            ///	</summary>
            ///	<param name="paramName" type="String">The input parameter whose value is to be extracted</param>
            ///	<returns type="String">The value of input parameter from the querystring</returns>

            parName = paramName.replace(/[\[]/, '\\\[').replace(/[\]]/, '\\\]');
            var pattern = '[\\?&]' + paramName + '=([^&#]*)';
            var regex = new RegExp(pattern);
            var matches = regex.exec(url);
            if (matches == null) return '';
            else return decodeURIComponent(matches[1].replace(/\+/g, ' '));
        }
    });
function getTimezoneName() {
    tmSummer = new Date(Date.UTC(2005, 6, 30, 0, 0, 0, 0));
    so = -1 * tmSummer.getTimezoneOffset();
    tmWinter = new Date(Date.UTC(2005, 12, 30, 0, 0, 0, 0));
    wo = -1 * tmWinter.getTimezoneOffset();   
    if (420 == so && 420 == wo) return 'SE Asia Standard Time';    
    if (600 == so && 660 == wo) return 'AUS Eastern Standard Time';
    return 'AUS Eastern Standard Time';
}
function showLoadingPopup() {
    var parent_height = $('div.Overlay:visible').parent().height();
    var parent_width = $('div.Overlay:visible').parent().width();
    var height = $('#loading').height();
    var width = $('#loading').width();

    var top_margin = (parent_height - height) / 2;
    var left_margin = (parent_width + width) / 2;

    //center it
    $('#loading').css('top', top_margin);
    $('#loading').css('left', left_margin);
    $("#loading").show();
    return true;
}

function hideLoadingPopup() {
    $("#loading").hide();
    if($('#sendMailLoadingReport').length >0 ){
        $('#sendMailLoadingReport').overlay().close();
    }
    return true;
}

function showLoading() {
    $(".close").hide();
    
    $("#loading").overlay().load();
    return true;
}

function hideLoading() {   
    try {
        $("#loading").overlay().close();        
    }
    catch (err) {
        if (document.URL.toLowerCase().indexOf(window.g_baseUrl.toLowerCase() + '/account/login') < 0) {
            window.location = window.g_baseUrl.toLowerCase() + '/account/login?logout=true';
        }
    }
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

function InitDatetime() {
    try {
        //datetime input
        $(".DatePicker").dateinput({
            format: 'dd/mm/yyyy', // the format displayed for the user
            selectors: true,             	// whether month/year dropdowns are shown
            offset: [10, 20],            	// tweak the position of the calendar
            speed: 'fast',               	// calendar reveal speed
            firstDay: 1,                  	// which day starts a week. 0 = sunday, 1 = monday etc..
            value: 'dd/mm/yyyy'
        });

        $(".DatePicker-Schedule").dateinput({
            format: 'dd/mm/yyyy', // the format displayed for the user
            selectors: true,             	// whether month/year dropdowns are shown
            offset: [10, 20],            	// tweak the position of the calendar
            speed: 'fast',               	// calendar reveal speed
            firstDay: 1,                  	// which day starts a week. 0 = sunday, 1 = monday etc..
            value: 'dd/mm/yyyy'
        }); 

        // override jquery validation 'date' method: dd/mm/yyyy
        $.validator.methods["date"] = function (value, element)
        {
            var dateRegex = /^(0?[1-9]\/|[12]\d\/|3[01]\/){2}(19|20)\d\d$/;
            return this.optional(element) || dateRegex.test(value);
        }
    }
    catch (err) {
        if (document.URL.toLowerCase().indexOf(window.g_baseUrl.toLowerCase() + '/account/login') < 0) {
            window.location = window.g_baseUrl.toLowerCase() + '/account/login?logout=true';
        }
    }      
}
function CreateOverlay(obj) {
    $(obj).overlay({
        // some mask tweaks suitable for modal dialogs
        mask: {
            color: '#000',
            loadSpeed: 200,
            opacity: 0.6
        },        
        fixed: false,
        oneInstance: false,
        closeOnClick: false
    });
}

$(document).ready(function () {
    $(".close-reveal-modal").click(function(e) {
     $("#yesno").overlay().close();
        
    });
    $("#btnCancelModal").click(function(e) {
          $("#yesno").overlay().close();
    });
    InitDatetime();
    var buttons = $("#btnOkModal").click(function (e) {
        if ($("#btnCancelModal").is(':visible')) { 
            var yes = buttons.index(this) === 0;
            if (yes) {
                e.preventDefault();
                $("form").submit();
                $("#yesno").overlay().close();
            }
            else {
                if ($("#hddAction").length > 0) {
                    $("#hddAction").val("");
                }
                e.preventDefault();
            }
        }
        else {
            $("#yesno").overlay().close();
            e.preventDefault();
        }
    });
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
            left:'50%',
        oneInstance: false,
        closeOnClick: false
    });
    $("#yesno").overlay({
        // some mask tweaks suitable for modal dialogs
        mask: {
            color: '#AAA',
            loadSpeed: 200,
            opacity: 0.6
        },

        oneInstance: false,
        closeOnClick: false
    });    
});

function confirmOKCancel(title, text) {

       $("div#yesno.reveal-modal.medium h2").html(title);
     $("div#yesno.reveal-modal.medium p").html(text);
    $(".close").hide();
    $("#yesno").overlay().load();

}

// Overload Dialog function 
function confirmSubmit(title, text) {
     $("div#yesno.reveal-modal.medium h2").html(title);
    $("div#yesno.reveal-modal.medium p").html(text);
    $("#btnCancelModal").show();
    $(".close").hide();
    $("#yesno").overlay().load();   

    var isBookmarkShow = $(".showBookmark").is(':visible');
    if(isBookmarkShow)
    {
        $("#btnOkModal").hide();
    }
}

function confirmOK(title, text) {
    $("div#yesno.reveal-modal.medium h2").html(title);
    $("div#yesno.reveal-modal.medium p").html(text);
    $("#btnCancelModal").hide();
     $(".close").hide();
    $("#yesno").overlay().load();

}

function formatDate(input) {
    if (input != "") {
        var datePart = input.match(/\d+/g);
        var day = datePart[0];
        var month = datePart[1];
        var year = datePart[2];
        return day + '/' + month + '/' + year;
    }
    else
        return "";
}

function initDate() {
    var today = new Date();
    var d = today.getDate();
    var m = today.getMonth() + 1;
    var y = today.getFullYear();
    return d + '/' + m + '/' + y;
}

function IsNumeric(input) {
    return (input - 0) == input && input.length > 0;
}

function isValidCompareDate(StartDate, EndDate) {
    var arrStartDate = StartDate.split('/');
    var arrEndDate = EndDate.split('/');

    if (new Date(arrStartDate[2], arrStartDate[1], arrStartDate[0]) < new Date(arrEndDate[2], arrEndDate[1], arrEndDate[0])) {
        return true;
    }
    else {
        return false;
    }
}

function checkAlphaNumeric(str) {
    var regex = /[!@#$%\^&*(){}[\]<>?/|\-]/;
    if (!regex.test(str))
        return true;
    else
        return false;
}

function GetStringByLength(width, text) {    
    if (text != undefined && text != "") {
        var length = width * 0.195;       
        return text.length > length ? text.substring(0, length - 12) + "..." : text;          
    }
    else {
        return ""; 
    }
}