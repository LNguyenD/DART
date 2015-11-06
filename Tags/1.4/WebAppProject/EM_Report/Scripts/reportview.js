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
    $('#ifReport').contents().find("#cmdUpdateParam").click();
    return false;
}

function viewreport() {
    $('#prmFilter_Hidden').val($('#temp_prmFilter_Hidden').val());
    if (iValidParameter() && isValidDateTime() && isValidQuaterYear() && IsvalidRequired()) {
        $(".BtnBack_Top").show();
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

function ShowSendMailForm(url, functionShow) {
    $.ajax({
        type: 'GET',
        url: url,
        data: { reportParameters: rptParameters, reportId: rptId, reportName: rptName, multipleValueNames: multipleValueNames },
        success: functionShow,
        statusCode: {
            403: function () {
                // forbidden (when users lost session) -> redirect to login page
                window.location.href = window.g_baseUrl + "/account/login";
            }
        }
    });
}
function ShowSearchForm(url, functionShow) {    
    $.ajax({
        type: 'GET',
        url: url,
        data: { claimNumber: claimNo, showClaimNumber: showClaimNo },
        success: functionShow,
        statusCode: {
            403: function () {
                // forbidden (when users lost session) -> redirect to login page
                window.location.href = window.g_baseUrl + "/account/login";
            }
        }
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
function ShowPolicies(systemid) {    
    var url = window.g_baseUrl + "/Report/UCPolicy?systemid="+systemid;
    ShowSearchForm(url, ShowPoliciesCallback);    
}
function ShowPoliciesCallback(data) {
    ShowForm("#searchPolicy", data);
}

function ShowPaymentTypes(systemid) {
    var url = window.g_baseUrl + "/Report/UCPaymentType?systemid=" + systemid;
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

function ShowCreditors(systemid) {
    var url = window.g_baseUrl + "/Report/UCCreditor?systemid=" + systemid;
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

function ShowBrokers(systemid) {
    var url = window.g_baseUrl + "/Report/UCBroker?systemid=" + systemid;
    ShowSearchForm(url, ShowBrokerCallback);
}
function ShowBrokerCallback(data) {
    ShowForm("#searchBroker", data);
}

function ShowProviders(systemid) {
    var url = window.g_baseUrl + "/Report/UCProvider?systemid=" + systemid;
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
function SplitStringToArr(str, criteria){
    var result = [];
    var indexCount = 0;
    for(i = 0; i <= str.length; i++){
        if(str.charAt(i) != criteria && str.charAt(i)!= ""){
            indexCount ++;
        }
        else{
            result.push(str.substr(i - indexCount, indexCount));
            indexCount = 0;
        }
    }
    return result;
}

function getFilterOptionFromHiddenField(str){
    var result = [];
    resultFromFilter = [];
    if(str != null && str.length > 0){
        result = SplitStringToArr(str, "@");
        for(j = 0; j < result.length; j++){
            resultFromFilter.push(SplitStringToArr(result[j],"#"));
        }
    }       
}
var resultFromFilter = [];
function LoadFilterData() {
    getFilterOptionFromHiddenField($('#temp_prmFilter_Hidden').val());
    for (j = 0; j < resultFromFilter.length; j++) {
        g_indexOfRadio++;
        var html = $('#divFilter').clone();
        html.css('display', 'block');
        html.find('input[name=txtValue]').css('display', 'inline');
        html.find('input[name=txtDatetime]').css('display', 'none');
        html.find('input[type=radio]').css('display', 'none');
        html.find('input[type=radio]').attr('name', 'bit' + g_indexOfRadio); // set distinct name for radio
        html.find('label[name=True]').css('display', 'none');
        html.find('label[name=False]').css('display', 'none');
        html.find('input[name=txtValue]').removeClass("input-validation-error");
        html.find('input[name=txtValue]').val('');
        html.find('span[id=selectcboDynamicFilterColumn]').attr('name', 'spf' + g_indexOfRadio);
        html.find('span[id=selectoperator]').attr('name', 'spo' + g_indexOfRadio);
        html.find('select[name=cboDynamicFilterColumn]').change(function () { $(this).parent().find('span').text($(this).parent().find('select[name=cboDynamicFilterColumn] option:selected').text()); });
        html.find('select[name=operator]').change(function () { $(this).parent().find('span').text($(this).parent().find('select[name=operator] option:selected').text()); });
        changeOperator(html, "like,=");

        html.find('input[name=txtValue]').val(resultFromFilter[j][2]);
        html.find('select[name=cboDynamicFilterColumn]').val('varchar#' + resultFromFilter[j][0]);
        html.find('select[name=operator]').val(resultFromFilter[j][1]);
        $('#filter').contents().find('.BoxContent').append(html);
        html.parent().find('span[name=spf' + g_indexOfRadio + ']').text(html.find('select[name=cboDynamicFilterColumn] option:selected').text());
        html.parent().find('span[name=spo' + g_indexOfRadio + ']').text(html.find('select[name=operator] option:selected').text());
        $('#msgFilterError').html('');
        $('#msgNoFilter').html('');
        AdjustContentHeight(true);
        
    }
}

function ShowAddFilter() {
    $('#msgFilterError').html('');
    $('#msgNoFilter').html('');
    RemoveFilterAll(1);
    LoadFilterData();
    $("#filter").overlay().load();
    
}

function ShowAddFilterCallback(data) {
    ShowForm("#filter", data);
    $('#filter').contents().find('.BoxContent').find('#divFilter').each(function (index) {
        $(this).find('select[name=cboDynamicFilterColumn]').css('border', ' 1px solid #AAA');
        $(this).find('input[name=txtValue]').css('border', ' 1px solid #AAA');
    });
    $("#msgFilterError").text('');
}
var contentHeight;
$(document).ready(function () {
    $('#hdClientUTC').val(getTimezoneName());
    if ($("#btnViewReport").length > 0) {
        // setup ul.tabs to work as tabs for each div directly under div.panes
        $("ul.tabs").tabs("div.panes > div", function (event, index) {
            if (index == 1) { //report viewer tab
                $("#rpViewerTab").toggleClass("Hide Show");
                $("#sendMailTab").removeClass("Hide Show");
                $("#sendMailTab").addClass("Hide");
                $("#wrapper").addClass("ViewReport");

                if ($.browser.msie && parseInt($.browser.version, 10) == 7) {
                    $("#ifReport").show();
                }
            } else if (index == 2) {
                $("#rpViewerTab").removeClass("Hide Show");
                $("#rpViewerTab").addClass("Hide");
                $("#sendMailTab").toggleClass("Hide Show");
                $("#wrapper").removeClass("ViewReport");

                if ($.browser.msie && parseInt($.browser.version, 10) == 7) {
                    $("#ifReport").hide();
                }
            } else {
                $("#rpViewerTab").removeClass("Hide Show");
                $("#rpViewerTab").addClass("Hide");
                $("#sendMailTab").removeClass("Hide Show");
                $("#sendMailTab").addClass("Hide");
                $("#wrapper").removeClass("ViewReport");

                if ($.browser.msie && parseInt($.browser.version, 10) == 7) {
                    $("#ifReport").hide();
                }
            }
        });
        //create dialog - overlay
        CreateOverlay("#searchPolicy");
        CreateOverlay("#searchPaymentType");
        CreateOverlay("#searchCreditor");
        CreateOverlay("#searchBroker");
        CreateOverlay("#searchProvider");
        CreateOverlay("#sendMailLoadingReport");
        CreateOverlay("#filter");

        changeInputType($("#cboDynamicFilterColumn"));
        $("#fieldSize").val($("#cboDynamicFilterColumn option").size());
    }
});
 
var g_indexOfRadio = 0;
var filterItemFlag = 0;
function ExpandAddFilter() {
    if ($('#filter').contents().find('.BoxContent').find('#divFilter').size() < parseInt($("#fieldSize").val())+filterItemFlag) {
        g_indexOfRadio++;
        var html = $('#divFilter').clone();
        html.css('display', 'block');
        html.find('input[name=txtValue]').css('display', 'inline');
        html.find('input[name=txtDatetime]').css('display', 'none');
        html.find('input[type=radio]').css('display', 'none');
        html.find('input[type=radio]').attr('name', 'bit' + g_indexOfRadio); // set distinct name for radio
        html.find('label[name=True]').css('display', 'none');
        html.find('label[name=False]').css('display', 'none');
        html.find('input[name=txtValue]').removeClass("input-validation-error");
        html.find('input[name=txtValue]').val('');
        html.find('span[id=selectcboDynamicFilterColumn]').attr('name', 'spf' + g_indexOfRadio);
        html.find('span[id=selectoperator]').attr('name', 'spo' + g_indexOfRadio);
        html.find('select[name=cboDynamicFilterColumn]').change(function () { $(this).parent().find('span').text($(this).parent().find('select[name=cboDynamicFilterColumn] option:selected').text()); });
        html.find('select[name=operator]').change(function () { $(this).parent().find('span').text($(this).parent().find('select[name=name=operator] option:selected').text()); });
        changeOperator(html, "like,=");
        $('#filter').contents().find('.BoxContent').append(html);
        $('#msgFilterError').html('');
        $('#msgNoFilter').html('');
        AdjustContentHeight(true);
    }
}
function AdjustContentHeight(isIncrease) { //true = increase, false = decrease
    var value = 40;
    if (isIncrease) {
        contentHeight += value;
    } else {
        contentHeight -= value;
    }
    $('#filter').contents().find('.BoxContent').height(contentHeight);
}
function RemoveFilter(obj) {
    if ($('#filter').contents().find('.BoxContent').find('#divFilter').size() > 1) {
        $(obj).parent().parent().remove();
        g_indexOfRadio--;
    }
    else {
        filterItemFlag = 1;
        $('#filter').contents().find('.BoxContent').find('#divFilter').css('display', 'none');
    }
    if (g_indexOfRadio == 0) {
        $("#msgNoFilter").text('No filter found!');
    }
    AdjustContentHeight(false);
}
function RemoveFilterAll(obj) {
    if ($('#filter').contents().find('.BoxContent').find('#divFilter').size() > 1) {
        $('#filter').contents().find('.BoxContent').find('#divFilter').each(function (index) {
            if ($(this).css('display') == "block" && index != 0) {
                $(this).remove();
            }
        });
        g_indexOfRadio = 0;
    }
    $('#filter').contents().find('.BoxContent').find('#divFilter').css('display', 'none');
    $('#msgNoFilter').text('No filter found!');
    filterItemFlag = 1;
    contentHeight = 88;
    $('#filter').contents().find('.BoxContent').height(contentHeight);//100 = default value
}
function changeInputType(obj) {
    var type = $(obj).find('option:selected').attr('value');
    if (typeof type != 'undefined') {
        var partType = type.split('#');
        var valueObj = $(obj).parent().parent().parent().children();
        changeFormType(partType[0], valueObj);
    }
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

function verifyDuplicatedFilter() {
    var result = true;
    var errorMessage = 'Duplicated Field(s) : ';
    var selectItem = [];
    var visitedArr = [];
    $('#filter').contents().find('.BoxContent').find('#divFilter').each(function (index) {  
        if ($(this).css('display') != "none") {
            var fieldName = $(this).find('select[name=cboDynamicFilterColumn] option:selected').text();
            $(this).find('select[name=cboDynamicFilterColumn]').css('border', ' 1px solid #AAA');
            selectItem.push(fieldName);
            visitedArr.push(false);
        }
    });
    var count = 0;
    $('#filter').contents().find('.BoxContent').find('#divFilter').each(function (index) {
        count = 0;
        if (visitedArr[index] == false) {
            for (j = index + 1; j < selectItem.length; j++) {
                if (selectItem[index] == selectItem[j] && visitedArr[j] == false) {
                    count++;
                    visitedArr[j] = true;
                    $('#filter').contents().find('.BoxContent').find('#divFilter').find('select[name=cboDynamicFilterColumn]')[j + 1].style.border = "1px solid #FF0000";
                    result = false;
                }
            }
        }
        if (count > 0) {
            errorMessage += selectItem[index] + ' , ';
            $('#filter').contents().find('.BoxContent').find('#divFilter').find('select[name=cboDynamicFilterColumn]')[index + 1].style.border = "1px solid #FF0000";
        }

    });
    errorMessage = errorMessage.slice(0, errorMessage.length - 2) + '!';
    $("#msgFilterError").text(errorMessage);
    return result;
}
function verifySpecialCharacter() {
    var result = true;
    $('#filter').contents().find('.BoxContent').find('#divFilter').each(function(index) {
       var fieldName = $(this).find('select[name=cboDynamicFilterColumn] option:selected').text();
        var txtvalue = $(this).find('input[name=txtValue]').val();
        if (!checkAlphaNumeric(txtvalue)) {
            $("#msgFilterError").text('Input value is invalid of the "'+fieldName+'"!');
            $(this).find('input[name=txtValue]').css('border', '1px solid #FF0000');
            result = false;
        }
        else {
             $(this).find('input[name=txtValue]').css('border', ' 1px solid #AAA');
        }
    });
    return result ;
}

function isInArray(str, destinationArr) {
    for (j = 0; j < destinationArr.length; j++) {
        if(str.toLowerCase() == 'claim_no' && destinationArr[j].toLowerCase() == 'claim_number')
            return true;
        if (str.toLowerCase() == 'claim_officer' && destinationArr[j].toLowerCase() == 'claims_officer')
            return true;
        if (destinationArr[j].toLowerCase() == str.toLowerCase())
            return true;
    }
    return false;
}

function verifyNotExistedFilter() {
    var errorMessage = ' Field(s) do not exist in the Report: ';
    var result = true;
    var count = 0;
    var selectItem = new Array();
    $('#filter').contents().find('.BoxContent').find('#divFilter').each(function (index) {
        if ($(this).css('display') != "none") {
            var fieldName = $(this).find('select[name=cboDynamicFilterColumn] option:selected').attr('value').split('#')[1];
            var destinationArr = SplitStringToArr($('#fieldList_Hidden').val(), ',');
            if (!isInArray(fieldName, destinationArr)) {
                count++;
                errorMessage += $(this).find('select[name=cboDynamicFilterColumn] option:selected').text() + ' , ';
                $(this).find('select[name=cboDynamicFilterColumn]').css('border', '1px solid #FF0000');
                result = false;
            }

        }
    });
    errorMessage = errorMessage.slice(1, errorMessage.length - 2) + '!';
    $("#msgFilterError").text(errorMessage);
    if (count == 0)
        $("#msgFilterError").html('');
    return result;
}

function AddFilter(form) {
    $('#msgFilterError').html('');
    $('#msgNoFilter').html('');
    var sql = '';
    var hasError = false;
    var lenght = $('#filter').contents().find('.BoxContent').find('#divFilter').size();

    if (verifyDuplicatedFilter() && verifySpecialCharacter() && verifyNotExistedFilter())
     {
        $('#filter').contents().find('.BoxContent').find('#divFilter').each(function (index) {
            if ($(this).css('display') != "none") {
                var type = $(this).find('select[name=cboDynamicFilterColumn] option:selected').attr('value').split('#');
                if( $(this).find('input[name=txtValue]').val() != "")
                {
                sql += type[1];
                sql += "#";
                sql += $(this).find('select[name=operator]').val();
                sql += "#";
                switch (type[0]) {
                    case 'datetime':
                        if ($(this).find('input[name=txtDatetime]').val() != "")
                            sql += "CONVERT(DATE, '" + $(this).find('input[name=txtDatetime]').val() + "',103) "+ "@";
                        break;
                    case 'varchar':
                        sql += $(this).find('select[name=operator]').val() == "like" ?  $(this).find('input[name=txtValue]').val() + "@" :  $(this).find('input[name=txtValue]').val() +"@";
                        break;
                    case 'bit':
                        if ($(this).find('input[type=radio]:checked').val() != "")
                            sql += parseInt($(this).find('input[type=radio]:checked').val()) + "@";
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
                            sql += $(this).find('input[name=txtValue]').val() + "@";
                        }
                        break;

                    default:
                    }
                        
                }

            }
        });
        sql = sql.slice(0, sql.length - 1);
        if (!hasError) {        
            if (lenght == 1 && $('#filter').contents().find('.BoxContent').find('#divFilter').css('display') == "none")
                sql = "";
            $('#prmFilter_Hidden').val(sql);            
            $('#temp_prmFilter_Hidden').val(sql);
            closePopup(form);                             
            return false;
        }
     }
}
//*****Send mail******//
function SendMailSuccess() {
    $('#msgSendMailSuccess').html('Sent mail successfully.');
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
//*****End Send mail******//

