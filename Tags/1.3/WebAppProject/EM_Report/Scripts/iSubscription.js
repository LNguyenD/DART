function iValidParameter() {
    var iValid = true;
    $('.require').each(function () {
        if ($(this).attr("id").toLowerCase().indexOf("_hidden") < 0 && $(this).attr("id") != "undefined" && ($(this).val() == "null" || $.trim($(this).val()) == "")) {
            if ($(this).attr("class").indexOf("multiselect") >= 0) {
                $(this).next().toggleClass("input-validation-error");
            }
            else {
                $(this).attr("class", $(this).attr("class") + " input-validation-error");
            }
            iValid = false;
        }
    });

    // validate datetime for submit button
    var dateTimeParaRange = $('#dateTimeValidate').val();
    if (dateTimeParaRange !== undefined && dateTimeParaRange != '') {
        var dataTimeParaId = dateTimeParaRange.split(';');
        if (dataTimeParaId.length > 2) {
            var startDate = $('#' + dataTimeParaId[0]).val();
            var endDate = $('#' + dataTimeParaId[1]).val();
            if (startDate !== undefined && endDate !== undefined) {
                var arrStartDate = startDate.split('/');
                var arrEndDate = endDate.split('/');
                if (new Date(arrStartDate[2], arrStartDate[1], arrStartDate[0]) <= new Date(arrEndDate[2], arrEndDate[1], arrEndDate[0])) {
                    iValid = true;
                    $('#' + dataTimeParaId[0]).css('border-color', '#AAAAAA');
                    $('#' + dataTimeParaId[1]).css('border-color', '#AAAAAA');
                }
                else {
                    $('#' + dataTimeParaId[0]).css('border-color', 'red');
                    $('#' + dataTimeParaId[1]).css('border-color', 'red');
                    iValid = false;
                }
            }

        }

    }
    return iValid;
}

function ResetParameterClass() {
    $('.input-validation-error').each(function () {
        $(this).attr("class", $(this).attr("class").replace("input-validation-error", ""));
    });
}

function ParameterValueChange(me) {
    var id, prmName, prmValue = "";
    id = $(me).attr("id");
    prmName = id.substring(3, id.length);
    if ($(me).hasClass("cbl-parameter")) {
        $("input[type='checkbox'][id~=$(me).attr('id')][aria-selected='true']").each(function () {
            prmValue += $(this).val() + ",";
        });
        if (prmValue != "") {
            prmValue = prmValue.substring(0, prmValue.length - 1);
        }
    } else {
        if ($(me).attr("type") == "checkbox") {
            prmValue = $(me).attr("checked") == "true" || $(me).attr("checked") == "checked" ? true : false;
        } else {
            prmValue = $(me).val();
        }
    }

    var currentValue = $("#ReportParameterValue").val();
    if (currentValue.indexOf(prmName) >= 0) {
        var textParam = '';
        var array = currentValue.split(';');
        for (var i = 0; i < array.length; i++) {
            if (array[i].length > 0) {
                var param = array[i].split('|');
                textParam += param[0] + '|';
                if (param[0] == prmName) {
                    textParam += prmValue + ";"
                } else {
                    textParam += param[1] + ";"
                }
            }
        }
        currentValue = textParam;
    } else {
        currentValue += prmName + "|" + prmValue + ";"
    }
    $("#ReportParameterValue").val(currentValue);
    if ($(me).hasClass("prm-dependency")) {
        LoadReportParameter();
    }

}

function LoadReportParameter() {
    showLoading();
    var id = $("#ReportId").val();
    var prmValues = $("#ReportParameterValue").val();
    var url = g_baseUrl + '/Subscription/ReportParameter';
    //    $("#ReportParameterValue").val('');
    $.post(url, { "reportid": id, ReportParameterValue: prmValues }, function (response) { LoadReportParameterSuccess(response); });

    //check if ie7
    if ($.browser.msie && parseInt($.browser.version, 10) === 7) {
        setTimeout(function () { reloadParameter(); }, 500);
    }
//    if(document.all && !window.opera && window.XMLHttpRequest)
//        setTimeout(function () { reloadParameter(); }, 500);
}

function LoadReportParameterSuccess(data) {
    $('#ReportParameterFrame').html(data);
    ProcessReportParameterUI();
    hideLoading();
}

function ProcessReportParameterUI() {
    InitDatetime();
    $(".cbl-parameter").multiselect({
        selectedList: 4
    });
    $(".cbl-parameter").siblings().attr('style', '');
}


function DeliveryMethodChange(value) {
    var panIndex;
    if (value.indexOf("Email") >= 0) {
        panIndex = 1;
        // update Render Format dropdownlist
        $.post(g_baseUrl + "/Subscription/UpdateFormatList", { deliveryMethod: "Email" }, function (data) {
            $("#Format").html(data);
        });
    } else {
        panIndex = 0;
        $.post(g_baseUrl + "/Subscription/UpdateFormatList", { deliveryMethod: "FileShare" }, function (data) {
            $("#Format").html(data);
        });
    }
    $(".dlr-option-pan:eq(" + panIndex + ")").removeClass("display-none");
    $(".dlr-option-pan:not(:eq(" + panIndex + "))").addClass("display-none");
    $(".dlr-option-pan").each(function () {
        if ($(this).hasClass("display-none")) {
            $(this).find(".require").removeClass("require").addClass("req");
        } else {
            $(this).find(".req").addClass("require");
        }
    });
}

function SubmitForm() {
    var iValid = iValidParameter();
    if ($(".left-pan input[name=ScheduleDefType]:checked").attr("value") == "Week") {
        if ($(".right-pan input[name*='wDaysOfWeek']:checked").length <= 0) {
            $(".right-pan input[name*='wDaysOfWeek']").css('outline-color', 'red');
            $(".right-pan input[name*='wDaysOfWeek']").css('outline-style', 'solid');
            $(".right-pan input[name*='wDaysOfWeek']").css('outline-width', 'thin');
            iValid = false;
        }
    }
    else if ($(".left-pan input[name=ScheduleDefType]:checked").attr("value") == "Month") {
        if ($(".right-pan input[name*='MonthsOfYear']:checked").length <= 0) {
            $(".right-pan input[name*='MonthsOfYear']").css('outline-color', 'red');
            $(".right-pan input[name*='MonthsOfYear']").css('outline-style', 'solid');
            $(".right-pan input[name*='MonthsOfYear']").css('outline-width', 'thin');
            iValid = false;
        }
    }
    if (iValid) {
        ResetParameterClass();
        $('form').submit();
    }
}


function doMyJoin(arr, s) {
    var str = arr.join(s);
    str = str.substring(s.length, str.length);
    return str;
}

function OpenPopup(scheduleId) {

    var url = g_baseUrl + "/Subscription/Schedule";
    $.ajax({
        type: 'POST',
        url: url,
        data: ((scheduleId == undefined) ? "" : ("scheduleId=" + scheduleId)),
        success: LoadScheduleDialogSuccess
    });
}


function LoadScheduleDialogSuccess(data) {
    $("#schedule-pan").html(data.html);
    $("#schedule-pan").dialog({
        autoOpen: true,
        resizable: false,
        width: 560,
        height: 400,
        modal: true,
        draggable: true,
        title: 'Schedule Detail',
        open: function (event, ui) {
        },
        focus: function (event, ui) {
        }
    });
    handleEndDate = function () {
        if ($('#HasEndDate:checked').length > 0) {
            $('input[name=_EndDate]').removeAttr('disabled');
        }
        else {
            $('input[name=_EndDate]').attr('disabled', 'disabled');
        }
    }
    handleEndDate();
    $('#HasEndDate').click(function () {
        handleEndDate();
    });
}

function ScheduleTypeChange() {
    var scheduleId = $("#ScheduleId").val();
    var evn = $(".left-pan input[name=ScheduleDefType]:checked").attr("value");
    //var url = g_baseUrl + "/Subscription/Schedule";
    $("#evn").val(evn);
    $("div.time-view").hide();
    $("#" + evn + "-Schedule").show();
//    if (evn == "Once") {
//        $("#wrapper-start-end-date").hide();
//    }
//    else {
//        $("#wrapper-start-end-date").show();
//    }
    //$.post(url, { "scheduleId": (scheduleId == undefined ? "" : scheduleId), evn: evn }, function (response) { ScheduleTypeChangeSuccess(response); });
}

function ScheduleTypeChangeSuccess(data) {
    $("div.right-pan").html(data.html);
    RefixCheckBoxListLayOut();
}

function RefixCheckBoxListLayOut() {
    $("div.editor-label").each(function () {
        var text = $(this).text();
        $(this).text(text.substring(0, 3));

        $(this).before($(this).next().clone());
        $(this).next().remove();
    });

    $("#MonthDays").before($("#MonthDays").siblings(".RadioButton").last());
    $("#MonthDays").siblings(".RadioButton").eq(0).children(":eq(0)").unwrap();
    $("#MonthDays").siblings(".RadioButton").children(":eq(0)").unwrap();
    $("#MonthDays").siblings("table").eq(1).css({ "margin": "10px 0 0 20px" });
    //$('.datepicker').attr('readonly', 'true');
}

function CloseDialog(me) {
    if ($(".field-validation-error span").length == 0) {
        $("#evn").val($(me).attr("value"));
        $("#schedule-pan").dialog('close');
    }
}

function ShowAddressBook() {
    var url = g_baseUrl + "/AddressBook/AllContacts";
    $.ajax({
        type: 'POST',
        url: url,
        data: "",
        success: ShowAddressBookCallback
    });
}
function ShowAddressBookCallback(data) {
    $("#divContact").html(data);
    $("#txtToPopup").val($("#txtMailTo").val());
    $("#divContact").dialog({
        autoOpen: true,
        resizable: false,
        width: 660,
        height: 570,
        modal: true,
        draggable: true,
        title: 'Address Book',
        buttons: {
            "Cancel": function () {
                $(this).dialog("close");
            },
            "Ok": function () {
                $("#txtMailTo").val($("#txtToPopup").val());
                $(this).dialog("close");
            }
        }
    });
}

function AddContacts(value) {
    var currentText = $("#txtToPopup").val();
    if (currentText != "")
        currentText += ";";
    $("#txtToPopup").val(currentText + " " + value);
}

$(document).ready(function () {
    $("#DeliveryMethod").change(function () {
        DeliveryMethodChange($(this).val());
    });
    if ($("#DeliveryMethod").length > 0) {
        DeliveryMethodChange($("#DeliveryMethod").val());
    }
    $(".cbl-parameter").multiselect({
        selectedList: 100
    });
    $("select#ReportId").combobox();
    $(".ui-autocomplete-input").addClass('form-field');


    $(".right-pan input[name*='MonthsOfYear']").click(function () {
        $(".right-pan input[name*='MonthsOfYear']").css('outline-color', '');
        $(".right-pan input[name*='MonthsOfYear']").css('outline-style', '');
        $(".right-pan input[name*='MonthsOfYear']").css('outline-width', '');
    });
    $(".right-pan input[name*='wDaysOfWeek']").click(function () {
        $(".right-pan input[name*='wDaysOfWeek']").css('outline-color', '');
        $(".right-pan input[name*='wDaysOfWeek']").css('outline-style', '');
        $(".right-pan input[name*='wDaysOfWeek']").css('outline-width', '');
    });
});
