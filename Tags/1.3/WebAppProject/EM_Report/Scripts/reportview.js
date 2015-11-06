function loadreport() {
    $('#ifReport').contents().find("#ReportParamValues").val('');
    $("[id^='prm']").each(function () {
        var value = '';
        if ($(this).attr("type") == "checkbox") {
            value = $(this).attr("checked") == "true" || $(this).attr("checked") == "checked" ? true : false;
        } else {
            value = $(this).val();
        }
        $('#ifReport').contents().find("#ReportParamValues").val($('#ifReport').contents().find("#ReportParamValues").val() + $(this).attr("id") + "|" + value + ";");
    });

    var runNormal = true;
    
    // Employer Notification Report
    if (document.URL.indexOf("EmployerNotificationReport") > 0) {
        var prmArr = $('#ifReport').contents().find("#ReportParamValues").val().split(';');
        for (var i in prmArr) {
            var nv = prmArr[i].split('|');
            if (nv[0] == 'prmAll_Agencies_in_one') {
                if (nv[1] == 'false') {
                    //alert(url.indexOf("/EMReports/"));             
                    $('#ifReport').contents().find("#ExLoading").show();
                    runNormal = false;
                    //remove window.url.substr(0, url.indexOf("/EMReports/")) with window.g_baseUrl
                    $.post(window.g_baseUrl + "/Report/ExportFile",
                            { strParams: $('#ifReport').contents().find("#ReportParamValues").val(),
                                reportPath: '/EMReporting/Reports/EmployerNotificationReport',
                                exportFormat: 'pdf'
                            },
                            function (data) {
                                $('#ifReport').contents().find("#ExLoading").hide();
                                $('#ifReport').contents().find("body").append("<div id='exportmessage'/>");
                                confirmOK("Message", data.html);
                                if (data.issuccess) {
                                    document.location = window.url.substr(0, url.indexOf("/EMReports/")) + "/Report/RenderExport";
                                }
                            }).error(function (data) {
                                $('#ifReport').contents().find("#ExLoading").hide();
                                confirmOK("Message", data.html);
                            });
                }
            }
        }
    }

    if (runNormal == true)
        $('#ifReport').contents().find("#cmdUpdateParam").click();
    return false;
} 

function viewreport() {    
    if (iValidParameter()) {
        ResetParameterClass();
        loadreport();
        ShowReportTab();

        var timeout = window.g_TimeOut;
        timer = setTimeout(function () { ShowSendMail(); }, parseInt(timeout));
        $('html, body').animate({ scrollTop: 150 }, 'slow');
        // show filter button
        $('a#btnShowAddFilter.SmallButton').css('pointer-events', 'auto');
        $('a#btnShowAddFilter.SmallButton').css('opacity', '1.0');
    }
}
function ShowReportTab() {
    $("#lnkViewerTab").click();
}

function split(val) {
    return val.split(/,\s*/);
}
function extractLast(term) {
    return split(term).pop();
}

var claimNo = '';
var showClaimNo = '';
var rptId = '';
var rptName = '';
var rptParameters = '';
var timer;
var multipleValueNames = '';

//var urlReport = document.location.href.toString();

function ShowSendMailForm(url, functionShow) {
    $.ajax({
        type: 'GET',
        url: url,
        data: { reportParameters: rptParameters, reportId: rptId, reportName: rptName, multipleValueNames: multipleValueNames },
        success: functionShow
    });
}
function ShowSearchForm(url, functionShow) {
    $.ajax({
        type: 'GET',
        url: url,
        data: { claimNumber: claimNo, showClaimNumber: showClaimNo },
        success: functionShow
    });
}
function ShowForm(form, data) {
    var api = $(form).data("overlay");
    $(form).html(data);
    api.load();    
}
function closePopup(form) {
    $(form).data("overlay").close();
}
function handleOK_SearchForm(form, txtInput) {
    var items = ' ';
    $(form).find('input[name=chkItem]:checked').each(function (index) {
        items += $(this).val().trim() + ', ';
    });
    items = items.trim().substring(0, items.length - 3);
    var inputObj = "[id*='" + txtInput + "']";
    $(inputObj).each(function (index) {
        var text = $(this).val().trim();
        if (text.length > 0 && text.lastIndexOf(',') != text.length - 1)
            text += ' ,';
        $(this).val(text + items).change();
    });
    closePopup(form);
}
function ShowPolicies() {
    var url = window.g_baseUrl + "/Report/UCPolicy";
    ShowSearchForm(url, ShowPoliciesCallback);    
}
function ShowPoliciesCallback(data) {
    ShowForm("#searchPolicy", data);
}

function ShowPaymentTypes() {
    var url = window.g_baseUrl + "/Report/UCPaymentType";
    claimNo = "";
    showClaimNo = "";
    var report = $('#rptName').html();
    var subcription = $('.ui-autocomplete-input').val();
    
    if ((report != null && report.indexOf("4.19.") >= 0) || (subcription != null && subcription.indexOf("4.19.") >= 0)) {
        claimNo = $('#prmClaimNumber').val();
        showClaimNo = "true";
    }
    if ((report != null && report.indexOf("4.25.") >= 0) || (subcription != null && subcription.indexOf("4.25.") >= 0)) {
        showClaimNo = "false";
    }

    ShowSearchForm(url, ShowPaymentTypeCallback);
}
function ShowPaymentTypeCallback(data) {
    ShowForm("#searchPaymentType", data);
}

function ShowCreditors() {
    var url = window.g_baseUrl + "/Report/UCCreditor";
    claimNo = "";
    showClaimNo = "";
    var report = $('#rptName').html();
    var subcription = $('.ui-autocomplete-input').val();

    if ((report != null && report.indexOf("4.19.") >= 0) || (subcription != null && subcription.indexOf("4.19.") >= 0)) {
        claimNo = $('#prmClaimNumber').val();
        showClaimNo = "true";
    }
    if ((report != null && report.indexOf("4.25.") >= 0) || (subcription != null && subcription.indexOf("4.25.") >= 0)) {
        showClaimNo = "false";
    }
    
    ShowSearchForm(url, ShowCreditorCallback);
}
function ShowCreditorCallback(data) {
    ShowForm("#searchCreditor", data);
}

function ShowBrokers() {
    var url = window.g_baseUrl + "/Report/UCBroker";
    ShowSearchForm(url, ShowBrokerCallback);
}
function ShowBrokerCallback(data) {
    ShowForm("#searchBroker", data);
}

function ShowProviders() {
    var url = window.g_baseUrl + "/Report/UCProvider";
    claimNo = "";
    showClaimNo = "";
    var report = $('#rptName').html();
    var subcription = $('.ui-autocomplete-input').val();

    if ((report != null && report.indexOf("4.19.") >= 0) || (subcription != null && subcription.indexOf("4.19.") >= 0)) {
        claimNo = $('#prmClaimNumber').val();
        showClaimNo = "true";
    }
    if ((report != null && report.indexOf("4.25.") >= 0) || (subcription != null && subcription.indexOf("4.25.") >= 0)) {
        showClaimNo = "false";
    }
    
    ShowSearchForm(url, ShowProviderCallback);
}
function ShowProviderCallback(data) {
    ShowForm("#searchProvider", data);
}

function ShowSendMail() {
    //var clientViewer = $('#ifReport').contents().find("rvwReportViewer");
    var isLoading = $('#ifReport').contents().find("#rvwReportViewer_AsyncWait_Wait").is(':visible');
    if (isLoading) {
        var url = window.g_baseUrl + "/Report/SendMailLoadingReport";
        rptId = $('#rptId').val();
        rptName = $('#rptName').html();
        rptParameters = '';
        multipleValueNames = '';
        $("[id^='prm']").each(function () {
            var value = '';
            if ($(this).attr("type") == "checkbox") {
                value = $(this).attr("checked") == "true" || $(this).attr("checked") == "checked" ? true : false;
            } else {
                if ($(this).attr("multiple") == "multiple") {
                    multipleValueNames += $(this).attr("id") + ",";
                }
                value = $(this).val();
            }
            rptParameters += $(this).attr("id") + "|" + value + ">";
        });
        ShowSendMailForm(url, ShowSendMailCallback);
    }
    else {
        clearTimeout(timer);
    }
}
function ShowSendMailCallback(data) {
    ShowForm("#sendMailLoadingReport", data);
    clearTimeout(timer);
}
function ShowAddFilter() {
    //var url = window.g_baseUrl + "/Report/UCAddFilter";
    //ShowSearchForm(url, ShowAddFilterCallback);
    $("#filter").overlay().load();
}
function ShowAddFilterCallback(data) {
    ShowForm("#filter", data);
}
