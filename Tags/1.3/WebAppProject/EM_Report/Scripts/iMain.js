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
    return true;
}

function showLoading() {
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

function InitDatetime() {
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
//    $('a#btnShowAddFilter.SmallButton').css('pointer-events', 'none');
//    $('a#btnShowAddFilter.SmallButton').css('opacity', '0.3');
});

function confirmOKCancel(title, text) {
    $(".modal > h2").html(title);
    $(".modal > p").first().html(text);   
    $("#yesno").overlay().load();
}

// Overload Dialog function 
function confirmSubmit(title, text) {   
    $(".modal > h2").html(title);
    $(".modal > p").first().html(text);
    $("#btnCancelModal").show();
    $("#yesno").overlay().load();     
}

function confirmOK(title, text) {   
    $(".modal > h2").html(title);
    $(".modal > p").first().html(text);
    $("#btnCancelModal").hide();
    $("#yesno").overlay().load();
}

function SendMailSuccess() {
    $('#msgSendMailSuccess').html('Sent mail successfully.');
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

function SubmitMailForm() {
    if (iValidParameter()) {
        $('form').submit();
    }
}

function SendMail() {
    if ($('#toEmail').val() == "") {
        $('#toEmail').toggleClass("input-validation-error");
    }
    else {
        $('form').submit();
    }
}

var g_indexOfRadio = 0;

function ExpandAddFilter() {
    g_indexOfRadio++;
    var html = $('#divFilter').clone();
    html.css('display', 'block');
    html.find('input[name=txtValue]').css('display', 'block');
    html.find('input[name=txtDatetime]').css('display', 'none');
    html.find('input[type=radio]').css('display', 'none');
    html.find('input[type=radio]').attr('name', 'bit' + g_indexOfRadio); // set distinct name for radio
    html.find('label[name=True]').css('display', 'none');
    html.find('label[name=False]').css('display', 'none');
    html.find('input[name=txtValue]').removeClass("input-validation-error");
    html.find('input[name=txtValue]').val('');

    changeOperator(html, "like,=");
    $('#filter').contents().find('.BoxContent').append(html);
    $('#msgFilterError').html('');
}

function RemoveFilter(obj) {
    if ($('#filter').contents().find('.BoxContent').find('#divFilter').size() > 1) {
        $(obj).parent().remove();
        g_indexOfRadio--;
    }
    else {
        $('#filter').contents().find('.BoxContent').find('#divFilter').css('display', 'none');
    }
}

function changeInputType(obj) {
    var type = $(obj).find('option:selected').attr('type');
    var valueObj = $(obj).parent().parent().parent().children();
    changeFormType(type, valueObj);
}
function changeFormType(type, valueObj) {
    switch (type) {
        case 'varchar':
            valueObj.find('input[name=txtValue]').css('display', 'block');
            valueObj.find('input[name=txtDatetime]').css('display', 'none');
            valueObj.find('input[type=radio]').css('display', 'none');
            valueObj.find('label[name=True]').css('display', 'none');
            valueObj.find('label[name=False]').css('display', 'none');

            changeOperator(valueObj, "like,=");
            valueObj.find('select[name=operator] option[value=like]').attr('selected', 'selected');
            break;
        case 'money':
        case 'int':
            valueObj.find('input[name=txtValue]').css('display', 'block');
            valueObj.find('input[name=txtDatetime]').css('display', 'none');
            valueObj.find('input[type=radio]').css('display', 'none');
            valueObj.find('label[name=True]').css('display', 'none');
            valueObj.find('label[name=False]').css('display', 'none');

            changeOperator(valueObj, ">,>=,=,<,<=,<>");
            valueObj.find('select[name=operator] option[value="="]').attr('selected', 'selected');
            break;
        case 'datetime':

            valueObj.find('input[name=txtValue]').css('display', 'none');
            valueObj.find('input[name=txtDatetime]').css('display', 'block');
            valueObj.find('input[type=radio]').css('display', 'none');
            valueObj.find('label[name=True]').css('display', 'none');
            valueObj.find('label[name=False]').css('display', 'none');

            valueObj.find('input[name=txtDatetime]').dateinput({ format: 'dd/mm/yyyy', // the format displayed for the user
                selectors: true,             	// whether month/year dropdowns are shown
                offset: [100, 0],            	// tweak the position of the calendar
                speed: 'fast',               	// calendar reveal speed
                firstDay: 1,                  	// which day starts a week. 0 = sunday, 1 = monday etc..
                value: 'dd/mm/yyyy'
            });

//            valueObj.find('input[name=txtDatetime]').data('dateinput').setMin(new Date(1950, 1, 1), true);
//            valueObj.find('input[name=txtDatetime]').data('dateinput').setMi(new Date(2012, 1, 1), true);
            valueObj.find('input[name=txtDatetime]').val(initDate());

            changeOperator(valueObj, ">,>=,=,<,<=,<>");
            valueObj.find('select[name=operator] option[value=like]').attr('disabled', true);
            valueObj.find('select[name=operator] option[value="="]').attr('selected', 'selected');
            break;
        case 'bit':
            valueObj.find('input[name=txtValue]').css('display', 'none');
            valueObj.find('input[name=txtDatetime]').css('display', 'none');
            valueObj.find('input[type=radio]').css('display', '');
            valueObj.find('label[name=True]').css('display', '');
            valueObj.find('label[name=False]').css('display', '');
            valueObj.find('input[type=radio]')[0].checked = true;

            changeOperator(valueObj, '=');
            valueObj.find('select[name=operator] option[value="="]').attr('selected', 'selected');
            break;

        default:
//            valueObj.find('input[name=txtValue]').css('display', 'block');
//            valueObj.find('input[name=txtDatetime]').css('display', 'none');
//            valueObj.find('input[name=bit]').css('display', 'none');
//            valueObj.find('label[name=True]').css('display', 'none');
//            valueObj.find('label[name=False]').css('display', 'none');
//            
//            //changeOperator(valueObj, '');
//            valueObj.find('select[name=operator] option[value=like]').attr('disabled', true);
//            valueObj.find('select[name=operator] option[value="="]').attr('selected', 'selected');
            break;
    }
}

function changeOperator(obj, ops) {
    obj.find('select[name=operator]').children().each(function () {
        if (ops.indexOf($(this).val()) >= 0) {
            $(this).removeAttr('disabled');
        }
        else {
            $(this).attr('disabled', true);
        }
    });
}

function AddFilter(form) {
    $('#msgFilterError').html('');
    var sql = '';
    var hasError = false;
    var lenght = $('#filter').contents().find('.BoxContent').find('#divFilter').size();

    $('#filter').contents().find('.BoxContent').find('#divFilter').each(function (index) {
        if ($(this).css('display') != "none") {
            var type = $(this).find('select[name=field] option:selected').attr('type');
            if (type != "datetime")
                sql += $(this).find('select[name=field]').val() + ' ';
            else sql += "CONVERT(DATE, " + $(this).find('select[name=field]').val() + ') ';
            sql += $(this).find('select[name=operator]').val() + ' ';
            switch (type) {
            case 'datetime':
                if ($(this).find('input[name=txtDatetime]').val() != "")
                    sql += "CONVERT(DATE, '" + $(this).find('input[name=txtDatetime]').val() + "', 103) ";
                break;
            case 'varchar':
                sql += $(this).find('select[name=operator]').val() == "like" ? "'%" + $(this).find('input[name=txtValue]').val() + "%' " : "'" + $(this).find('input[name=txtValue]').val() + "' ";
                break;
            case 'bit':
                if ($(this).find('input[type=radio]:checked').val() != "")
                    sql += parseInt($(this).find('input[type=radio]:checked').val()) + ' ';
                break;
            case 'int':
            case 'money':
                if (!IsNumeric($(this).find('input[name=txtValue]').val())) {
                    $('#msgFilterError').html($(this).find('select[name=field]').val() + ' must be a number!');
                    $(this).find('input[name=txtValue]').addClass("input-validation-error");
                    hasError = true;
                }
                else {
                    $(this).find('input[name=txtValue]').removeClass("input-validation-error");
                    sql += $(this).find('input[name=txtValue]').val() + ' ';
                }
                break;

            default:
            }
            if (index < lenght - 1)
                sql += $(this).find('select[name=condition]').val() + ' ';
        }
    });
    if (!hasError) {
        //sql = sql.replace(/'/g, "''");
        if (lenght == 1 && $('#filter').contents().find('.BoxContent').find('#divFilter').css('display') == "none")
            sql = "";
        $('#prmFilterParameter_Hidden').val(sql).change();
        closePopup(form);
        viewreport();
        return false;
    }
}

function IsNumeric(input) {
    return (input - 0) == input && input.length > 0;
}
