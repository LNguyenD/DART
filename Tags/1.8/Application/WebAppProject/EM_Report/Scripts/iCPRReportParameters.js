// Show/Hide parameter list handler
$(".portfolioParameterSection .show").click(function () {
    changeShowOrHideText();
    var isShow = $(".showOrg").is(':visible');
    if (isShow) {
        $(".showOrg").slideUp('slow');
    }
    else {
        $(".showOrg").slideDown('slow');
    }
});

function changeShowOrHideText() {
    var isShow = $(".showOrg").is(':visible');
    var $btnShow = $(".portfolioParameterSection .show");
    var btnShowText = $btnShow.text();

    if (isShow) {
        btnShowText = btnShowText.replace("Hide", "Show");
    }
    else {
        btnShowText = btnShowText.replace("Show", "Hide");
    }

    $btnShow.text(btnShowText);
}

// VIEW REPORT BUTTON
// In cases users come from level 3/4/5, There are Value parameter on query string and no tab on the page
// => if there is Value param on query string -> detect Type from query string instead of tab
var expandCollapseActionRegistered = false;
function reloadReport() {
    expandCollapseActionRegistered = false;
    var url = document.location.href;
    var currentType = getCurrentType();
    var typeValue = getCurrentTabType();
    if (typeValue == '')
        typeValue = getParameterByName('type');

    var reportContainerId;


    var system = $('input[type="hidden"][id="System"]').val();

    if (system == "WOW") {

        // Get type for WOW system
        if (typeValue == "account_manager") {
            typeValue = 'state';
        }
        else if (typeValue == "portfolio") {
            typeValue = 'division';
        }
    }

    var paramData = populateReportParamsData();

    var reportUrl = g_baseUrl + "/Reports/Dashboards/CPRTableReport.aspx?reportpath=/emreporting/reports/cpr_summary";
    reportUrl += "&System=" + system + "&Type=" + typeValue;

    if (document.URL.toLowerCase().indexOf("level3") >= 0) {
        var value = getParameterByName('value');
        reportUrl += "&Value=" + value;
    }

    if (document.URL.toLowerCase().indexOf("level4") >= 0) {
        var value = getParameterByName('value');
        reportUrl += "&Value=" + value;

        var subValue = getParameterByName('subvalue');
        reportUrl += "&SubValue=" + subValue;
    }

    reportUrl += paramData;

    var $report = $('#portfolioReportSection iframe[id*=ifTableReport_advance_' + currentType + ']');
    if ($report.length > 0) {
        $report.show();
        var reportId = $report.attr('id');
        var reportStyle = $report.attr('style');

        var reportContent = '<iframe id="' + reportId + '" src="' + reportUrl + '" width="100%" height="100%" frameborder="0" scrolling="no" style="' + reportStyle + '"></iframe>';
        $("#portfolioReportSection div[id*=ifSearchCover_" + currentType + "]").html(reportContent);

    }
    else {
        var reportWrapper = $('<div id="ifSearchCover_' + currentType + '"></div>');
        var reportContent = $('<iframe id="ifTableReport_advance_' + currentType + '" src="' + reportUrl + '" width="100%" height="100%" frameborder="0" scrolling="no" style="height: 1198px"></iframe>');
        reportWrapper.append(reportContent);
        $("#portfolioReportSection").append(reportWrapper);
    }

    // keep track start time, end time of each page/tab
    var currentTab = $('.tab .tab_current');
    submitTimeInfo(currentTab, '2');
    saveStartTime();
}

// populate parameters data from parameter section as query string to append to report url
function populateReportParamsData() {
    var paramData = "";

    $('#ReportParameterSection select, #ReportParameterSection input[type="text"]').each(function (index) {
        var id = $(this).attr("id");
        var paramName = id.substring(3, id.length);
        var paramValue;
        if ($(this).prop('type').indexOf('select') > -1) {
            paramValue = $(this).find(":selected").text();
            if (paramValue == 'Yes' || paramValue == 'yes')
                paramValue = '1';
            else if (paramValue == 'No' || paramValue == 'no')
                paramValue = '0';
        }
        else if ($(this).prop('type').indexOf('text') > -1) {
            paramValue = $(this).val();
            if (paramName == 'Start_Date') {
                paramValue += ' 00:00';
            }
            else if (paramName == 'End_Date') {
                paramValue += ' 23:59';
            }
        }

        paramData += "&" + paramName + "=" + paramValue;
    });

    return paramData;
}

// add or update report parameters data and reload report parameter (if needed)
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

    addOrUpdateReportParameter(prmName, prmValue);

    if ($(me).hasClass("prm-dependency")) {
        LoadReportParameter(null);
    }
}

var tabParameterData = [];

// save current tabs' parameters data and restore parameters data for new tab
function CPRTabChanged(me, newTabIndex) {
    if ($('#cprAdvanceSearch').length == 0)
        return;

    // save parameter data for current tab
    var currentTab = $(".tab .tab_current");
    var currentTabIndex = currentTab.index();
    saveParameterValues(currentTabIndex);

    // update parameter data with type of new tab
    var type = $(me).attr("data-ReportType");
    var containerId = $(me).attr("data-ReportContainerId");
    addOrUpdateReportParameter('Type', type);

    // restore parameter data for new tab
    updateReportParameterData(newTabIndex);
    LoadReportParameter(newTabIndex);
}

// restore parameter data for tab
function updateReportParameterData(newTabIndex) {
    if (tabParameterData[newTabIndex] == null) {
        tabParameterData[newTabIndex] = [];
        $('#ReportParameterSection select, #ReportParameterSection input[type="text"]').each(function (index) {
            var id = $(this).attr("id");
            var paramName = id.substring(3, id.length);
            if (paramName != 'Value' && paramName != 'SubValue') {
                var param = { paramName: paramName };
                if ($(this).prop('type').indexOf('select') > -1) {
                    param.paramValue = "All";
                }
                    // currrently, we just have 2 textboxes for Start_Date, End_Date so just assign empty value to have default date
                else if ($(this).prop('type').indexOf('text') > -1) {
                    param.paramValue = '';
                }

                tabParameterData[newTabIndex].push(param);
            }
        });
    }

    $.each(tabParameterData[newTabIndex], function (index, item) {
        addOrUpdateReportParameter(item.paramName, item.paramValue);
    });
}

// save parameters data for tab
function saveParameterValues(tabIndex) {
    tabParameterData[tabIndex] = getAllControlsValues();
}

// get all parameters data
function getAllControlsValues() {
    var paramData = [];

    $('#ReportParameterSection select, #ReportParameterSection input[type="text"]').each(function (index) {
        var id = $(this).attr("id");
        var paramName = id.substring(3, id.length);
        var paramValue;
        if ($(this).prop('type').indexOf('select') > -1) {
            paramValue = $(this).find(":selected").text();
        }
        else if ($(this).prop('type').indexOf('text') > -1) {
            paramValue = $(this).val();
        }

        paramData[index] = { paramName: paramName, paramValue: paramValue };
    });

    return paramData;
}

// get query string in report url
function getReportUrlValue(reportUrl, valueName) {
    var re = new RegExp(valueName + "=[a-zA-Z0-9]+", 'gi');
    var m = re.exec(reportUrl);
    if (m == null)
        return null;

    var s = '';
    for (i = 0; i < m.length; i++) {
        s = s + m[i];
    }

    return s.replace(valueName + '=', '');
}

// add or update report parameters data
function addOrUpdateReportParameter(prmName, prmValue) {
    var currentValue = $("#ReportParameterData").val();
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

    $("#ReportParameterData").val(currentValue);
}

// load report parameter section
function LoadReportParameter(newTabIndex) {
    //showLoading();
    var prmData = $("#ReportParameterData").val();
    var url = g_baseUrl + '/Dashboard/UpdateReportParameters';
    $.get(url, { reportParameterData: prmData }, function (response) {
        LoadReportParameterSuccess(response);
    });

    //check if ie7
    //    if ($.browser.msie && parseInt($.browser.version, 10) == 7) {
    //        setTimeout(function () { reloadParameter(); }, 500);
    //    }
}

function LoadReportParameterSuccess(data) {
    $('#ReportParameterSection').html(data);
    $('#ui-datepicker-div').remove();
    ProcessReportParameterUI();
    //hideLoading();
}

function ProcessReportParameterUI() {
    FixUI();
    //InitDatetime();
    //    $(".cbl-parameter").multiselect({
    //        selectedList: 4
    //    });
    $(".cbl-parameter").siblings().attr('style', '');
}

function FixUI() {
    $("select option").not("#searchType option").each(function (index, element) {
        var current_val = $(this).val();
        $(this).val(current_val);
    });

    $("select").selectbox();
    // fix IE 7 issue with SelectBox plugin
    var n = $(".sbHolder").length;
    $(".sbHolder").each(function () {
        $(this).css("z-index", n);
        n--;
    });

    $('#ReportParameterSection').find("input[type=text]").each(function () {
        //prettyForms();
        appendParentsTo(this);
    });
    FixCalendar();
}

function FixCalendar() {
    $('html').click(function (e) {
        var $target = $(e.target);
        if ($target[0].id != 'ui-datepicker-div' &&
				$target.parents('#ui-datepicker-div').length == 0 &&
				!$target.hasClass('hasDatepicker') &&
				!$target.hasClass('ui-datepicker-trigger') &&
                !$target.parents('a').hasClass('ui-datepicker-prev') &&
                !$target.parents('a').hasClass('ui-datepicker-next') &&
				e.target.id != 'prmStart_Date' && e.target.id != 'prmEnd_Date') {
            $('#ui-datepicker-div').hide();
        }
        else if (e.target.id == 'prmStart_Date' || e.target.id == 'prmEnd_Date') {
            $('#ui-datepicker-div').fadeIn('fast');
        }
    });

    //not allow user input to start date and end date picker
    $("#prmStart_Date").prop('readonly', true);
    $("#prmEnd_Date").prop('readonly', true);

    $(".date").datepicker({
        dateFormat: 'dd/mm/yy',
        changeMonth: true,
        changeYear: true,
        beforeShow: function (input, me) {
            // make calendar on top
            setTimeout(function () {
                $('.ui-datepicker').css('z-index', 1000000);
            }, 0);

            // Start_Date max date = End Date
            if (me.id == "prmStart_Date") {
                var endDate = $('#prmEnd_Date').datepicker('getDate');
                //me.settings.maxDate = endDate;

                var maxReportingDateParts = $("#maxReportingDate").val().split('/');
                var currentDate = parseInt(maxReportingDateParts[0], 10);
                var currentMonth = parseInt(maxReportingDateParts[1], 10);
                var currentYear = parseInt(maxReportingDateParts[2], 10);
                me.settings.maxDate = new Date(currentYear, currentMonth - 1, currentDate);

                var endDateParts = $('#prmEnd_Date').val().split('/');
                var startDateParts = $('#prmStart_Date').val().split('/');
                var endDate = new Date(parseInt(endDateParts[2]), parseInt(endDateParts[1], 10) - 1, parseInt(endDateParts[0], 10));
                var startDate = new Date(parseInt(startDateParts[2]), parseInt(startDateParts[1], 10) - 1, parseInt(startDateParts[0], 10));

                if (startDate > endDate) {
                    //$('#prmEnd_Date').val(new Date(startDate.getFullYear(), startDate.getMonth() + 1, 0).format("dd/MM/yyyy"));
                    var comMonth = startDate.getMonth() + 1;
                    var curMonth = new Date().getMonth() + 1;

                    if (comMonth == curMonth) {
                        $('#prmEnd_Date').val(new Date(currentYear, currentMonth, currentDate).format("dd/MM/yyyy"));
                    }
                    else {
                        $('#prmEnd_Date').val(new Date(startDate.getFullYear(), startDate.getMonth() + 1, 0).format("dd/MM/yyyy"));
                    }
                }
            }

            last3MonthsConstrains(me.id, 'beforeShow');
        },
        onSelect: function (date, me) {
            if (me.id == "prmStart_Date") {
                var maxReportingDateParts = $("#maxReportingDate").val().split('/');
                var currentDate = parseInt(maxReportingDateParts[0], 10);
                var currentMonth = parseInt(maxReportingDateParts[1], 10);
                var currentYear = parseInt(maxReportingDateParts[2], 10);
                me.settings.maxDate = new Date(currentYear, currentMonth - 1, currentDate);

                var endDateParts = $('#prmEnd_Date').val().split('/');
                var startDateParts = $('#prmStart_Date').val().split('/');
                var endDate = new Date(parseInt(endDateParts[2]), parseInt(endDateParts[1], 10) - 1, parseInt(endDateParts[0], 10));
                var startDate = new Date(parseInt(startDateParts[2]), parseInt(startDateParts[1], 10) - 1, parseInt(startDateParts[0], 10));

                var last3MonthsFirstDate = new Date(currentYear, currentMonth - 3, currentDate);
                if (last3MonthsFirstDate.getDate() != currentDate) {
                    last3MonthsFirstDate = new Date(currentYear, currentMonth - 2, 0);
                }

                if (startDate > endDate) {
                    var comMonth = startDate.getMonth() + 1;
                    var curMonth = parseInt(maxReportingDateParts[1], 10);

                    if (comMonth == curMonth) {
                        $('#prmEnd_Date').datepicker('setDate', new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate()).format("dd/MM/yyyy"));
                    }
                    else {
                        if (endDate < last3MonthsFirstDate) {

                            var endDateMonth = parseInt(endDateParts[1], 10);
                            var last3MonthFirstDateMonth = currentMonth - 3;

                            if (endDateMonth == last3MonthFirstDateMonth) {
                                $('#prmEnd_Date').datepicker('setDate', new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate()).format("dd/MM/yyyy"));
                            }
                            else {
                                $('#prmEnd_Date').val(new Date(startDate.getFullYear(), startDate.getMonth() + 1, 0).format("dd/MM/yyyy"));
                            }
                        }
                        else {
                            $('#prmEnd_Date').datepicker('setDate', new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate()).format("dd/MM/yyyy"));
                        }
                    }
                }
            }
            if (me.id == "prmEnd_Date") {
                var endDateParts = $('#prmEnd_Date').val().split('/');
                var startDateParts = $('#prmStart_Date').val().split('/');

                // auto set start date = end date when user choose end date < start date
                var endDate = new Date(parseInt(endDateParts[2]), parseInt(endDateParts[1], 10) - 1, parseInt(endDateParts[0], 10));
                var startDate = new Date(parseInt(startDateParts[2]), parseInt(startDateParts[1], 10) - 1, parseInt(startDateParts[0], 10));
                if (endDate < startDate) {
                    $('#prmStart_Date').datepicker('setDate', new Date(parseInt(endDateParts[2]), parseInt(endDateParts[1], 10) - 1, parseInt(endDateParts[0], 10)));
                    //$('#prmEnd_Date').val(new Date(endDate.getFullYear(), endDate.getMonth() + 1, 0).format("dd/MM/yyyy"));
                }
            }

            last3MonthsConstrains(me.id, 'onSelect');
        }
    });

    setupConstraintsForCalendar();
}

function last3MonthsConstrains(prmName, state) {
    var maxReportingDateParts = $("#maxReportingDate").val().split('/');
    var currentDate = parseInt(maxReportingDateParts[0], 10);
    var currentYear = parseInt(maxReportingDateParts[2], 10);
    var currentMonth = parseInt(maxReportingDateParts[1] - 1, 10);
    var last3MonthsFirstDate = new Date(currentYear, currentMonth - 3, currentDate);
    if (last3MonthsFirstDate.getDate() != currentDate) {
        last3MonthsFirstDate = new Date(currentYear, currentMonth - 2, 0);
    }

    var endDateParts = $('#prmEnd_Date').val().split('/');
    var startDateParts = $('#prmStart_Date').val().split('/');
    var endDate = new Date(parseInt(endDateParts[2]), parseInt(endDateParts[1], 10) - 1, parseInt(endDateParts[0], 10));
    var startDate = new Date(parseInt(startDateParts[2]), parseInt(startDateParts[1], 10) - 1, parseInt(startDateParts[0], 10));

    if (prmName == "prmEnd_Date") {
        if (endDate < last3MonthsFirstDate) {
            if (state == 'onSelect') {
                $('#prmEnd_Date').val(new Date(endDate.getFullYear(), endDate.getMonth() + 1, 0).format("dd/MM/yyyy"));
                $('#prmStart_Date').val(new Date(startDate.getFullYear(), startDate.getMonth(), 1).format("dd/MM/yyyy"));
            }
            else {
                var lastDateOfMonth = new Date(endDate.getFullYear(), endDate.getMonth() + 1, 0);
                $('#prmEnd_Date').datepicker('setDate', new Date(lastDateOfMonth.getFullYear(), lastDateOfMonth.getMonth(), lastDateOfMonth.getDate()));
            }
        }
    }

    if (prmName == "prmStart_Date") {
        if (startDate < last3MonthsFirstDate) {
            if (state == 'onSelect') {
                $('#prmStart_Date').val(new Date(startDate.getFullYear(), startDate.getMonth(), 1).format("dd/MM/yyyy"));
            }
            else {
                $('#prmStart_Date').datepicker('setDate', new Date(parseInt(startDateParts[2]), parseInt(startDateParts[1], 10) - 1, 1));
            }
        }
    }
}


function setupConstraintsForCalendar() {
    /* 
    constraints for Start Date, End Date
    End Date, Start Date must be within last 3 years
    End Date max date = yesterday
    */
    var maxReportingDateParts = $("#maxReportingDate").val().split('/');

    var startDate = $('#prmStart_Date').val();
    var endDate = $('#prmEnd_Date').val();
    var currentDate = parseInt(maxReportingDateParts[0], 10);
    var currentYear = parseInt(maxReportingDateParts[2], 10);
    var currentMonth = parseInt(maxReportingDateParts[1] - 1, 10);
    ////last 3 years
    var last3yearsfirstDate = new Date(currentYear - 3, currentMonth, 1);

    //if (last3yearsfirstDate.getDate() != currentDate) {
    //    last3yearsfirstDate = new Date(currentYear - 3, currentMonth, 0);
    //}

    //// set correct date on textbox
    $("#prmStart_Date").datepicker("setDate", startDate);
    $("#prmEnd_Date").datepicker("setDate", endDate);

    //// set constraints
    $("#prmEnd_Date").datepicker('option', 'maxDate', new Date(currentYear, currentMonth, currentDate));
    $("#prmStart_Date").datepicker('option', 'minDate', last3yearsfirstDate);
    $("#prmEnd_Date").datepicker('option', 'minDate', last3yearsfirstDate);
}