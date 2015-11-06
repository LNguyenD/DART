//============== PORTFOLIO PARAMETERS ============

// VIEW REPORT BUTTON
// In cases users come from level 3/4/5, There are Value parameter on query string and no tab on the page
// => if there is Value param on query string -> detect Type from query string instead of tab
var expandCollapseActionRegistered = false;
function reloadReport() {
    expandCollapseActionRegistered = false;
    var url = document.location.href;
    var currentType;
    var reportContainerId;
    var $report;

    // Check if Start Date and End Date is invalid
    var StartDate = $('#prmStart_Date').val();
    if (StartDate == '') {
        alert('Start date is not valid');
        return false;
    }
    var EndDate = $('#prmEnd_Date').val();
    if (EndDate == '') {
        alert('End date is not valid');
        return false;
    }

    //var value = getReportUrlValue(url, "Value");
    //if (value != null) {
    //    currentType = getReportUrlValue(url, "Type");
    //    reportContainerId = 'ReportCover';
    //    $report = $('#portfolioReportSection iframe:eq(0)');
    //}
    //else {
    currentType = $('.tab .tab_current').attr('data-ReportType');
    reportContainerId = $('.tab .tab_current').attr('data-ReportContainerId');
    $report = $('#portfolioReportSection iframe[id*=' + reportContainerId + ']');
    //}

    var reportId = $report.attr('id');
    var reportStyle = $report.attr('style');
    var system = $('input[type="hidden"][id="System"]').val();
    var paramData = populateReportParamsData();

    var reportUrl = g_baseUrl + "/Reports/CPR/Report.aspx?reportpath=/emreporting/reports/port";
    reportUrl += "&System=" + system + "&Type=" + currentType;
    reportUrl += paramData;

    var reportContent = '<iframe id="' + reportId + '" src="' + reportUrl + '" width="100%" height="100%" frameborder="0" scrolling="no" style="' + reportStyle + '"></iframe>';
    $("#portfolioReportSection div[id*=" + reportContainerId + "]").html(reportContent);

    // keep track start time, end time of each page/tab
    var currentTab = $('.tab .tab_current');
    submitTimeInfo(currentTab);
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
                paramValue = 'true';
            else if (paramValue == 'No' || paramValue == 'no')
                paramValue = 'false';
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
function PortfolioTabChanged(me, newTabIndex) {
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

    // keep track start time, end time of each page/tab
    submitTimeInfo(currentTab);
    saveStartTime();
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
    var url = g_baseUrl + '/Report/GetReportParameter';
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

    prettyForms();
    FixCalendar();
}

function FixCalendar() {
    //$(".date").datepicker({
    //    dateFormat: 'dd/mm/yy',
    //    changeMonth: true,
    //    changeYear: true,
    //    beforeShow: function (input, me) {
    //        console.log(input);
    //        console.log(me);

    //        // make calendar on top
    //        setTimeout(function () {
    //            $('.ui-datepicker').css('z-index', 1000000);
    //        }, 0);

    //        // Start_Date max date = End Date
    //        if (me.id == "prmStart_Date") {
    //            var endDate = $('#prmEnd_Date').datepicker('getDate');
    //            me.settings.maxDate = endDate;
    //        }

    //        last3MonthsConstrains(me.id, 'beforeShow');
    //    },
    //    onSelect: function (date, me) {
    //        if (me.id == "prmEnd_Date") {
    //            var endDateParts = $('#prmEnd_Date').val().split('/');
    //            var startDateParts = $('#prmStart_Date').val().split('/');

    //            // auto set start date = end date when user choose end date < start date
    //            var endDate = new Date(parseInt(endDateParts[2]), parseInt(endDateParts[1], 10) - 1, parseInt(endDateParts[0], 10));
    //            var startDate = new Date(parseInt(startDateParts[2]), parseInt(startDateParts[1], 10) - 1, parseInt(startDateParts[0], 10));
    //            if (endDate < startDate) {
    //                $('#prmStart_Date').datepicker('setDate', new Date(parseInt(endDateParts[2]), parseInt(endDateParts[1], 10) - 1, parseInt(endDateParts[0], 10)));
    //                $('#prmEnd_Date').val(new Date(endDate.getFullYear(), endDate.getMonth() + 1, 0).format("dd/MM/yyyy"));
    //            }
    //        }

    //        last3MonthsConstrains(me.id, 'onSelect');
    //    }
    //});

    $(".date").dateinput({
        format: 'dd/mm/yyyy', // the format displayed for the user
        selectors: true,
        speed: 'fast',  // calendar reveal speed 
        onBeforeShow: function () {
            var $input = this.getInput();
            id = $input.attr("id");
            prmName = id.substring(3, id.length);

            // set correct date
            //var dateParts = $input.val().split('/'); // dd/MM/yyyy
            //this.setValue(parseInt(dateParts[2]), parseInt(dateParts[1]) - 1, parseInt(dateParts[0]));

            // Start_Date max date = End Date
            if (prmName == "Start_Date") {
                var endDate = $('#prmEnd_Date').data('dateinput');
                this.setMax(endDate.getValue(), true);
            }

            last3MonthsConstrains(prmName, 'beforeShow');
        },
        onShow: function () {
            $("#calroot").css('z-index', 1000000);
            $("#calmonth").show(); $("#calmonth").next("div").remove(); $("#calmonth").width(60);
            $("#calyear").show(); $("#calyear").next("div").remove(); $("#calyear").width(60);
        },
        // Start_Date = first date on End_Date month
        change: function () {
            var $input = this.getInput();
            id = $input.attr("id");
            prmName = id.substring(3, id.length);

            if (prmName == "End_Date") {
                var endDateParts = $('#prmEnd_Date').val().split('/');
                var startDateParts = $('#prmStart_Date').val().split('/');
                var startDateInput = $('#prmStart_Date').data('dateinput');

                //if (parseInt(endDateParts[1]) < parseInt(startDateParts[1])) {
                //    startDateInput.setValue(parseInt(endDateParts[2]), parseInt(endDateParts[1]) - 1, 1);
                //}

                // auto set start date = end date when user choose end date < start date
                var endDate = new Date(parseInt(endDateParts[2]), parseInt(endDateParts[1], 10) - 1, parseInt(endDateParts[0], 10));
                var startDate = new Date(parseInt(startDateParts[2]), parseInt(startDateParts[1], 10) - 1, parseInt(startDateParts[0], 10));
                if (endDate < startDate) {
                    startDateInput.setValue(parseInt(endDateParts[2]), parseInt(endDateParts[1], 10) - 1, parseInt(endDateParts[0], 10));
                    $('#prmEnd_Date').val(new Date(endDate.getFullYear(), endDate.getMonth() + 1, 0).format("dd/MM/yyyy"));
                }
            }

            last3MonthsConstrains(prmName,'onchange');
        }
    });

    setupConstraintsForCalendar();
}

function last3MonthsConstrains(prmName, state) {
    var currentYear = new Date().getFullYear();
    var currentMonth = new Date().getMonth() + 1;
    var last3MonthsFirstDate = new Date(currentYear, currentMonth - 4, 1);

    var endDateParts = $('#prmEnd_Date').val().split('/');
    var startDateParts = $('#prmStart_Date').val().split('/');
    var endDate = new Date(parseInt(endDateParts[2]), parseInt(endDateParts[1], 10) - 1, parseInt(endDateParts[0], 10));
    var startDate = new Date(parseInt(startDateParts[2]), parseInt(startDateParts[1], 10) - 1, parseInt(startDateParts[0], 10));

    if (prmName == "End_Date") {
        if (endDate < last3MonthsFirstDate) {
            if (state == 'onchange') {
                $('#prmEnd_Date').val(new Date(endDate.getFullYear(), endDate.getMonth() + 1, 0).format("dd/MM/yyyy"));
            }
            else {
                var lastDateOfMonth = new Date(endDate.getFullYear(), endDate.getMonth() + 1, 0);
                $('#prmEnd_Date').data('dateinput').setValue(lastDateOfMonth.getFullYear(), lastDateOfMonth.getMonth(), lastDateOfMonth.getDate());
            }
        }
    }

    if (prmName == "Start_Date") {
        if (startDate < last3MonthsFirstDate) {
            if (state == 'onchange') {
                $('#prmStart_Date').val(new Date(startDate.getFullYear(), startDate.getMonth(), 1).format("dd/MM/yyyy"));
            }
            else {
                $('#prmStart_Date').data('dateinput').setValue(parseInt(startDateParts[2]), parseInt(startDateParts[1], 10) - 1, 1);
            }
        }
    }
}

//function last3MonthsConstrains(prmName, state) {
//    var currentYear = new Date().getFullYear();
//    var currentMonth = new Date().getMonth() + 1;
//    var last3MonthsFirstDate = new Date(currentYear, currentMonth - 4, 1);

//    var endDateParts = $('#prmEnd_Date').val().split('/');
//    var startDateParts = $('#prmStart_Date').val().split('/');
//    var endDate = new Date(parseInt(endDateParts[2]), parseInt(endDateParts[1], 10) - 1, parseInt(endDateParts[0], 10));
//    var startDate = new Date(parseInt(startDateParts[2]), parseInt(startDateParts[1], 10) - 1, parseInt(startDateParts[0], 10));

//    if (prmName == "prmEnd_Date") {
//        if (endDate < last3MonthsFirstDate) {
//            if (state == 'onSelect') {
//                $('#prmEnd_Date').val(new Date(endDate.getFullYear(), endDate.getMonth() + 1, 0).format("dd/MM/yyyy"));
//            }
//            else {
//                var lastDateOfMonth = new Date(endDate.getFullYear(), endDate.getMonth() + 1, 0);
//                $('#prmEnd_Date').datepicker('setDate', new Date(lastDateOfMonth.getFullYear(), lastDateOfMonth.getMonth(), lastDateOfMonth.getDate()));
//            }
//        }
//    }

//    if (prmName == "prmStart_Date") {
//        if (startDate < last3MonthsFirstDate) {
//            if (state == 'onSelect') {
//                $('#prmStart_Date').val(new Date(startDate.getFullYear(), startDate.getMonth(), 1).format("dd/MM/yyyy"));
//            }
//            else {
//                $('#prmStart_Date').datepicker('setDate', new Date(parseInt(startDateParts[2]), parseInt(startDateParts[1], 10) - 1, 1));
//            }
//        }
//    }
//}

function setupConstraintsForCalendar() {
    /* 
    constraints for Start Date, End Date
    End Date, Start Date must be within last 3 years
    End Date max date = yesterday
    */

    var startDate = $('#prmStart_Date').data('dateinput');
    var endDate = $('#prmEnd_Date').data('dateinput');
    var currentYear = new Date().getFullYear();
    //last 3 years
    var firstDate = new Date(currentYear - 3, 0, 1);

    // set correct date on textbox
    var dateParts = startDate.getInput().val().split('/'); // dd/MM/yyyy
    startDate.setValue(parseInt(dateParts[2]), parseInt(dateParts[1], 10) - 1, parseInt(dateParts[0], 10));
    dateParts = endDate.getInput().val().split('/'); // dd/MM/yyyy
    endDate.setValue(parseInt(dateParts[2]), parseInt(dateParts[1], 10) - 1, parseInt(dateParts[0], 10));

    // set constraints
    endDate.setMax(-1, true); // yesterday
    startDate.setMin(firstDate);
    endDate.setMin(firstDate);
}

//function setupConstraintsForCalendar() {
//    /* 
//    constraints for Start Date, End Date
//    End Date, Start Date must be within last 3 years
//    End Date max date = yesterday
//    */

//    var startDate = $('#prmStart_Date').val()
//    var endDate = $('#prmEnd_Date').val();
//    var currentYear = new Date().getFullYear();
//    //last 3 years
//    var firstDate = new Date(currentYear - 3, 0, 1);

//    // set correct date on textbox
//    $("#prmStart_Date").datepicker("setDate", startDate);
//    $("#prmEnd_Date").datepicker("setDate", endDate);

//    // set constraints
//    $("#prmEnd_Date").datepicker('option', 'maxDate', -1);
//    $("#prmStart_Date").datepicker('option', 'minDate', firstDate);
//    $("#prmEnd_Date").datepicker('option', 'minDate', firstDate);
//}

//==================== END PORTFOLIO REPORT PARAMETERS ===================

//------------------------------------------------------------------------

//=============== PORTFOLIO REPORT EXPAND/COLLAPSE FEATURES ==============

// expand/collapse portfolio detail
function registerExpandCollapseAction(reportTable) {
    if (expandCollapseActionRegistered)
        return;

    if ($.browser.msie && ($.browser.version.substr(0, 1) == 7 || $.browser.version.substr(0, 1) == 8) && (document.documentMode == 8 || document.documentMode == 7)) {
        registerExpandCollapseActionForColumnsForIE8(reportTable);
    }
    else {
        registerExpandCollapseActionForColumns(reportTable);
    }

    registerExpandCollapseActionForRows(reportTable);

    expandCollapseActionRegistered = true;
}

// init repeat operation object
RepeatOperation = function (anonymousOperation, whenToYield) {
    var count = 0;
    return function () {
        if (++count >= whenToYield) {
            count = 0;
            setTimeout(function () { anonymousOperation(); }, 1);
        }
        else {
            anonymousOperation();
        }
    }
};

function registerExpandCollapseActionForColumnsForIE8(reportTable) {
    var totalCellIndex = 0;

    var yieldAfter = 2;
    var i = 0;
    var max = reportTable.children('tbody').children('tr:eq(4)').children('td').length;

    reportTable.css('visibility', 'hidden');
    //reportTable.hide();

    var ro = new RepeatOperation(function () {
        var totalCell = reportTable.children('tbody').children('tr:eq(4)').children('td:eq(' + i + ')');
        totalCell.children('div').each(function () {
            if ($(this).attr('alt') != null) {
                if ($(this).attr('alt').indexOf('TotalDetailedPortfolio') > -1) { // total cell header -> register events
                    var type = reportTable.attr('alt').replace('portfolio_', '');
                    var iframe = $('iframe', window.parent.document).filter(function () {
                        return $(this).attr('id').toLowerCase().indexOf(type.toLowerCase()) > -1;
                    });
                    var iframeSrc = iframe.attr('src').toLowerCase();
                    if (iframeSrc.indexOf('subvalue') > -1 && iframeSrc.indexOf('subvalue=all') < 0) { // is claim officer view
                        fixClaimOfficerName($(this));
                    }

                    //remove '_total' part from the total column in CPR main table
                    var cellText = $(this).text();
                    $(this).text(cellText.replace('_total', ''));

                    totalCell.attr('data-index', totalCellIndex++);
                    totalCell.attr('data-isExpanded', '0');
                    totalCell.css('cursor', 'pointer');
                    $(this).attr("title", '');

                    totalCell.hover(function () {
                        $(this).addClass('hoverCell');
                    }, function () {
                        var isExpanded = $(this).attr('data-isExpanded');
                        if (isExpanded == 0) {
                            $(this).removeClass('hoverCell');
                        }
                    });

                    totalCell.click(function () {
                        var isExpanded = $(this).attr('data-isExpanded');
                        if (isExpanded == 0) {
                            adjustToggledHeaderHeight(reportTable, true); // adjust before increment
                            expandedTabsCount++;

                            $(this).addClass('hoverCell');
                            totalCell.attr('data-isExpanded', 1);
                        }
                        else {
                            $(this).removeClass('hoverCell');
                            totalCell.attr('data-isExpanded', 0);

                            expandedTabsCount--;
                            adjustToggledHeaderHeight(reportTable, false); // adjust after decrement
                        }

                        toggleDetailedPortfolioColumns(reportTable, totalCell);
                    });
                }
                else if ($(this).attr('alt').indexOf('DetailedPortfolio') > -1) { // detailed header -> rotate text
                    rotateDetailedHeaderText($(this));
                }
            }
        });

        // collapse all by default
        toggleDetailedPortfolioColumns(reportTable, totalCell);

        i++;
        if (i <= max) {
            ro();
        }
        else {
            reportTable.css('visibility', 'visible');
            //reportTable.show();

        }
    }, yieldAfter);

    // start repeat operation
    ro();

    adjustToggledHeaderHeight(reportTable);
}

function registerExpandCollapseActionForColumns(reportTable) {
    
    var totalCellIndex = 0;
    reportTable.children('tbody').children('tr:eq(4)').children('td').each(function () {
        var totalCell = $(this);
        totalCell.children('div').each(function () {
            if ($(this).attr('alt') != null) {
                if ($(this).attr('alt').indexOf('TotalDetailedPortfolio') > -1) { // total cell header -> register events
                    var type = reportTable.attr('alt').replace('portfolio_', '');
                    var iframe = $('iframe', window.parent.document).filter(function () {
                        return $(this).attr('id').toLowerCase().indexOf(type.toLowerCase()) > -1;
                    });
                    var iframeSrc = iframe.attr('src').toLowerCase();
                    if (iframeSrc.indexOf('subvalue') > -1 && iframeSrc.indexOf('subvalue=all') < 0) { // is claim officer view
                        fixClaimOfficerName($(this));
                    }

                    //remove '_total' part from the total column in CPR main table
                    var cellText = $(this).text();
                    $(this).text(cellText.replace('_total', ''));

                    totalCell.attr('data-index', totalCellIndex++);
                    totalCell.attr('data-isExpanded', '0');
                    totalCell.css('cursor', 'pointer');
                    $(this).attr("title", '');

                    totalCell.hover(function () {
                        $(this).addClass('hoverCell');
                    }, function () {
                        var isExpanded = $(this).attr('data-isExpanded');
                        if (isExpanded == 0) {
                            $(this).removeClass('hoverCell');
                        }
                    });

                    totalCell.click(function () {
                        var isExpanded = $(this).attr('data-isExpanded');
                        if (isExpanded == 0) {
                            adjustToggledHeaderHeight(reportTable, true); // adjust before increment
                            expandedTabsCount++;

                            $(this).addClass('hoverCell');
                            totalCell.attr('data-isExpanded', 1);
                        }
                        else {
                            $(this).removeClass('hoverCell');
                            totalCell.attr('data-isExpanded', 0);

                            expandedTabsCount--;
                            adjustToggledHeaderHeight(reportTable, false); // adjust after decrement
                        }

                        toggleDetailedPortfolioColumns(reportTable, totalCell);
                    });
                }
                else if ($(this).attr('alt').indexOf('DetailedPortfolio') > -1) { // detailed header -> rotate text
                    rotateDetailedHeaderText($(this));
                }
            }
        });

        // collapse all by default
        toggleDetailedPortfolioColumns(reportTable, totalCell);
    });

    adjustToggledHeaderHeight(reportTable);
}

function fixClaimOfficerName(me) {
    if (me.text().indexOf(' ') > -1) {
        var firstCharacter = me.text().substring(0, 1);
        me.text(firstCharacter + '. ' + me.text().substring(me.text().indexOf(' ') + 1, me.text().length));
    }
}

var numberOfDetailColumns = 11;
function toggleDetailedPortfolioColumns(reportTable, me) {
    var totalCellIndex = me.attr('data-index');

    // 5 = skip some first columns
    var startColumnIndex = 4 + (numberOfDetailColumns + 1) * totalCellIndex;
    for (var i = startColumnIndex + 1; i <= startColumnIndex + numberOfDetailColumns; i++) {
        reportTable.toggleColumns(i);
    }
}

var expandedTabsCount = 0;
function adjustToggledHeaderHeight(reportTable, isExpanding) {
    if (expandedTabsCount == 0) {
        var adjustedHeight = 0;
        reportTable.children("tbody").children("tr:lt(5)").each(function (index) {
            var cell = $(this).children("td:eq(0)");
            var toggleHeight = cell.attr('data-toggle-height');

            // for adjusting report container height
            var rowHeight = $(this).attr('data-old-height');
            $(this).attr('data-old-height', $(this).height());
            adjustedHeight += rowHeight - $(this).height();
            //////

            if (typeof (toggleHeight) === 'undefined') {
                cell.attr('data-toggle-height', cell.height());

                if (index == 4) {
                    cell.css("height", "30px");
                }
                else {
                    cell.css("height", "0px");
                }
            }
            else {
                cell.attr('data-toggle-height', cell.height());
                cell.css("height", toggleHeight + 'px');
            }

        });

        if (isExpanding) {
            adjustedHeight += 10;
        }
        else {
            adjustedHeight -= 10;
        }

        var type = reportTable.attr('alt').replace('portfolio_', '');
        adjustPortfolioContainerHeight(adjustedHeight, type);
    }
}

function fixTotalColumnWidth(portfolioTable, isClaimOfficerView) {
    for (var i = 3; i < portfolioTable.children('tbody').children('tr:eq(0)').children('td').length; i = i + numberOfDetailColumns + 1) {
        var cell = portfolioTable.children('tbody').children('tr:eq(0)').children('td:eq(' + i + ')');
        if (isClaimOfficerView) {
            cell.width(110);
        }
        else {
            cell.width(90);
        }
    }
}

var numberOfTherapyRows = 6;
function registerExpandCollapseActionForRows(reportTable) {
    var type = reportTable.attr('alt').replace('portfolio_', '');

    // for therapy treatments   
    var therapyTreatmentCell = reportTable.children('tbody').children('tr:eq(21)').children('td:eq(1)')/*.children('div[alt="therapy_treat"]')*/;
    therapyTreatmentCell.attr('data-isExpanded', '0');
    therapyTreatmentCell.closest('tr').css('cursor', 'pointer');
    therapyTreatmentCell.closest('tr').click(function () {
        toggleDetailedRows(therapyTreatmentCell, type, 6);
    });

    // for lump sum intimations
    var lumpSumCell = reportTable.children('tbody').children('tr:eq(28)').children('td:eq(1)')/*.children('div[alt="therapy_treat"]')*/;
    lumpSumCell.attr('data-isExpanded', '0');
    lumpSumCell.closest('tr').css('cursor', 'pointer');
    lumpSumCell.closest('tr').click(function () {
        toggleDetailedRows(lumpSumCell, type, 12);
    });

    // collapse by default
    hideDetailedRows(therapyTreatmentCell, type, 6);
    hideDetailedRows(lumpSumCell, type, 12);
}

function toggleDetailedRows(cell, type, numberOfRows) {
    var isExpanded = cell.attr('data-isExpanded');
    if (isExpanded == 0) {
        showDetailedRows(cell, type, numberOfRows);
    }
    else {
        hideDetailedRows(cell, type, numberOfRows);
    }
}

function headerCellClick(cell, callback) {
    var detailedCellAlt = cell.children('div').attr('alt') + '_sub';
    cell.closest('tr').siblings().each(function () {
        if ($(this).children('td:eq(1)').children('div[alt="' + detailedCellAlt + '"]').length == 1) {
            callback($(this));
        }
    });
}

function showDetailedRows(cell, type, numberOfRows) {
    cell.attr('data-isExpanded', '1');
    headerCellClick(cell, showMe);
    var expandHeight = cell.closest('tr').height() * numberOfRows;
    adjustPortfolioContainerHeight(expandHeight + 2, type);
}

function hideDetailedRows(cell, type, numberOfRows) {
    cell.attr('data-isExpanded', '0');
    headerCellClick(cell, hideMe);
    var collapseHeight = cell.closest('tr').height() * numberOfRows * -1;
    adjustPortfolioContainerHeight(collapseHeight - 2, type);
}

function showMe(me) {
    me.show();
}

function hideMe(me) {
    me.hide();
}

// adjust portfolio container height when expand/collapse
function adjustPortfolioContainerHeight(ammount, type) {
    var iframe = $('iframe', window.parent.document).filter(function () {
        return $(this).attr('id').toLowerCase().indexOf(type.toLowerCase()) > -1;
    });

    var iframeHeight = iframe.height() + ammount;
    iframe.height(iframeHeight);
    $('#divViewer').height(iframeHeight);
    $('#rvwReportViewer').height(iframeHeight);
    $('#rvwReportViewer_ct109').closest('td').height(iframeHeight);
}

function rotateDetailedHeaderText(me) {
    if (me.children().length == 0) {
        me.css('margin-left', '-25px');
        me.css('width', '100px');
    }
    else {
        me.css('margin-left', '-5px');
        me.css('margin-bottom', '-40px');
        me.children('div').css('width', '100px');
        me.css('white-space', 'nowrap');
    }

    me.css('word-wrap', 'normal');
    me.css('-webkit-transform', 'rotate(-90deg)'); // Chrome
    me.css('-ms-transform', 'rotate(-90deg)'); // IE 9
    me.css('transform', 'rotate(-90deg)'); // IE 10    

    // IE 8
    if ($.browser.msie && ($.browser.version.substr(0, 1) == 7 || $.browser.version.substr(0, 1) == 8) && (document.documentMode == 8 || document.documentMode == 7)) {

        me.css('font-weight', '100');
        me.css('margin-left', '10px');
        me.css('margin-bottom', '70px');
        me.css('color', 'black');
        me.css('filter', 'progid:DXImageTransform.Microsoft.Matrix(sizingMethod="auto expand", M11=0, M12=1, M21=-1, M22=0)');
        me.css('-ms-filter', 'progid:DXImageTransform.Microsoft.Matrix(SizingMethod="auto expand", M11=0, M12=1, M21=-1, M22=0)');
    }

    //if (document.documentMode == 7 || $.browser.msie && $.browser.version.substr(0, 1) == 7) {
    //    me.css('margin-left', '0px');
    //    me.css('color', 'black');
    //    me.css('filter', 'progid:DXImageTransform.Microsoft.Matrix(sizingMethod="auto expand", M11=0, M12=1, M21=-1, M22=0)');
    //    me.css('-ms-filter', 'progid:DXImageTransform.Microsoft.Matrix(SizingMethod="auto expand", M11=0, M12=1, M21=-1, M22=0)');
    //}
}

//=============== END PORTFOLIO REPORT EXPAND/COLLAPSE FEATURES =================