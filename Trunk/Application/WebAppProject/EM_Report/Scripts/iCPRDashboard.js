/*
    THIS FILE CONTAINS CPR METHODS USED OUTSIDE IFRAME ONLY
*/

if ($(".tab").length) {
    $(".formBox").not(".formBox:first").hide();
    $('ul [id^="tab_"]').each(function (index) {
        $(this).click(function () {
            var currentTab = $('.tab_current');

            switchTabCPRLevel2($(this));
            changeCPRViewTypeOption($(this));
            //changeGoToCPRReportURL($(this));
            CPRTabChanged(this, index);

            // IE 8 Compat
            if ($.browser.msie && ($.browser.version.substr(0, 1) == 7) && document.documentMode == 8) {
                $("iframe#ifReport_Agency").contents().find('#rvwReportViewer').css('width', '100%');
            }

            var id_name = $(this).attr('id');
            var systemName = $('#wrapper .breadcrum_01 a:eq(0)').html().trim();
            var AgencyTabContent = $('#ifReport_Agency').contents().find('table#tbMetric_TrafficLight').html() || $('#ifReport_Agency').contents().find("table[alt*='portfolio']").html();
            var GroupTabContent = $('#ifReport_Group').contents().find('table#tbMetric_TrafficLight').html() || $('#ifReport_Group').contents().find("table[alt*='portfolio']").html();
            var AccountManagerTabContent = $('#ifReport_AccountManager').contents().find('table#tbMetric_TrafficLight').html() || $('#ifReport_AccountManager').contents().find("table[alt*='portfolio']").html();

            // CPR
            var level2CrumbtrailsCPR = $("#level2CrumbtrailsCPR").html();
            var lookaheadLevel3CrumbtrailsCPR = $("#lookaheadLevel3CrumbtrailsCPR").html();

            $(".tab li").removeClass("tab_current");
            $(this).addClass("tab_current");

            $(".formBox").hide();
            $('div.' + id_name).fadeIn("slow");

            if (id_name == "tab_agency" || id_name == "tab_employer_size" || id_name == "tab_portfolio") {
                // change crumbtrail text when change tab to agency/employer size
                // CPR
                if (level2CrumbtrailsCPR != null) {

                    if (systemName == "TMF") {

                        $("#level2CrumbtrailsCPR").html($("#level2CrumbtrailsCPR").html().replace("group", "agency"));

                        // hide level 4 lookahead crumtrails for agency
                        $("#lookaheadLevel4CrumbtrailsCPR").hide();

                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace("team", "subcategory"));
                        }
                    }
                    else if (systemName == "WCNSW") {

                        if (level2CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('group', "employer size"));

                        }
                        else if (level2CrumbtrailsCPR.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('account manager', "employer size"));

                        }

                        // hide levels 3, 4 lookahead crumtrails for employer size
                        $("#lookaheadLevel3CrumbtrailsCPR").hide();
                        $("#lookaheadLevel4CrumbtrailsCPR").hide();
                    }
                    else if (systemName == "Hospitality") {

                        if (level2CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('group', "portfolio"));

                        }
                        else if (level2CrumbtrailsCPR.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('account manager', "portfolio"));

                        }

                        //show level 4 lookahead crumtrails for porfolio
                        $("#lookaheadLevel3CrumbtrailsCPR").show();

                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace("team", "employer size"));
                        }

                        // hide level 4 lookahead crumtrails for portfolio
                        $("#lookaheadLevel4CrumbtrailsCPR").hide();
                    }
                }
            }

            else if (id_name == "tab_group") {
                //change crumbtrail text when change tab Group
                // CPR
                if (level2CrumbtrailsCPR != null) {
                    if (systemName == "TMF") {

                        $("#level2CrumbtrailsCPR").html($("#level2CrumbtrailsCPR").html().replace("agency", "group"));

                        // show level 4 lookahead crumtrails for group
                        $("#lookaheadLevel4CrumbtrailsCPR").show();

                        $("#lookaheadLevel3CrumbtrailsCPR").html($("#lookaheadLevel3CrumbtrailsCPR").html().replace("subcategory", "team"));
                    }
                    else if (systemName == "WCNSW") {

                        if (level2CrumbtrailsCPR.indexOf('employer size') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('employer size', "group"));

                            //show level 4 lookahead crumtrails for Group
                            $("#lookaheadLevel3CrumbtrailsCPR").show();
                        }
                        else if (level2CrumbtrailsCPR.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('account manager', "group"));

                        }

                        // show level 4 lookahead crumtrails for Group
                        $("#lookaheadLevel4CrumbtrailsCPR").show();

                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('subcategory') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html($("#lookaheadLevel3CrumbtrailsCPR").html().replace("subcategory", "team"));
                        }
                        else if (lookaheadLevel3CrumbtrailsCPR.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html($("#lookaheadLevel3CrumbtrailsCPR").html().replace("employer size", "team"));
                        }
                    }
                    else if (systemName == "Hospitality") {

                        if (level2CrumbtrailsCPR.indexOf('portfolio') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('portfolio view', "group view"));

                        }
                        else if (level2CrumbtrailsCPR.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('account manager', "group"));

                        }

                        // show level 4 lookahead crumtrails for Group
                        $("#lookaheadLevel4CrumbtrailsCPR").show();

                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html($("#lookaheadLevel3CrumbtrailsCPR").html().replace("employer size", "team"));
                        }
                    }
                }
            }
            else if (id_name == "tab_account_manager") {
                //Change Crumbtrail text when change tab Account Manager
                // CPR
                if (level2CrumbtrailsCPR != null) {
                    if (systemName == "WCNSW") {

                        if (level2CrumbtrailsCPR.indexOf('employer size') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('employer size', "account manager"));

                        }
                        else if (level2CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('group', "account manager"));

                        }

                        //show level 4 lookahead crumtrails for Account Manager
                        $("#lookaheadLevel3CrumbtrailsCPR").show();

                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('team', 'employer size'));
                        }

                        // hide level 4 lookahead crumtrails for account manager
                        $("#lookaheadLevel4CrumbtrailsCPR").hide();
                    }
                    if (systemName == "Hospitality") {

                        if (level2CrumbtrailsCPR.indexOf('portfolio') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('portfolio view', "account manager view"));

                        }
                        else if (level2CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('group', "account manager"));

                        }

                        //show level 4 lookahead crumtrails for Account Manager
                        $("#lookaheadLevel3CrumbtrailsCPR").show();

                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('team', 'employer size'));
                        }

                        // hide level 4 lookahead crumtrails for account manager
                        $("#lookaheadLevel4CrumbtrailsCPR").hide();
                    }
                }
            }
            adjustGuideBar();

            // keep track start time, end time of each page/tab
            submitTimeInfo(currentTab);
            saveStartTime();
        });
    });
}

var CPRTables = [];

$("#cboCPRViewType").change(function () {
    var selectedValue = $(this).val();
    var selectOptions = [];
    $("#cboCPRViewType option").each(function () {
        var visibility = $(this).val() == selectedValue ? '' : 'none';
        selectOptions.push({
            value: $(this).val()
            , visibility: visibility
        });
    });

    // SHOW/HIDE ADVANCE OPTION
    if (selectedValue == "advance_option") {
        if ($("#cprAdvanceSearch").length <= 0) {
            // render "Advance search" partial
            renderAdvanceSearchArea();
        }
        else {
            // show "Advance search" area
            $("#cprAdvanceSearch").show();

            $("#portfolioReportSection div[id*=ifSearchCover]").hide();
            var currentType = getCurrentType();
            $("#portfolioReportSection div[id*=ifSearchCover_" + currentType + "]").show();
        }

        // hide metric light table
        //var metricTable = iframe.contents().find("table[id='tbMetric_TrafficLight']");
        //metricTable.hide();

        // hide reports iframe
        $("div[id*=ifReportCover]").css('display', 'none');
    }
    else {
        if ($("#cprAdvanceSearch").length > 0) {
            // hide "Advance search" area
            $("#cprAdvanceSearch").hide();
        }

        // show reports iframe
        $("div[id*=ifReportCover]").css('display', '');
    }

    hideDetailSection();

    // SHOW/HIDE WEEK, MONTH
    if (window.location.href.toLowerCase().indexOf('level2') >= 0) {
        var iframe = $("#ifReport_Agency");

        $.each(selectOptions, function (index) {
            var selectedValue = selectOptions[index].value;
            if (selectedValue != 'advance_option') {
                var currentTabType = getCurrentTabType();
                var portfolioTableName = 'portfolio_' + selectedValue + '_' + currentTabType;

                if ($.browser.msie || isIE11()) {
                    window.frames['ifReport_Agency'].portfolioTable_Init(portfolioTableName);
                }
                else {
                    window.frames['ifReport_Agency'].contentWindow.portfolioTable_Init(portfolioTableName);
                }

                var portfolioTable = iframe.contents().find("table[alt*='" + portfolioTableName + "']");
                portfolioTable.closest('div').css('display', selectOptions[index].visibility);

                if (selectOptions[index].visibility != 'none') {
                    var graph = iframe.contents().find("img[alt^='graph_view']").closest('table');
                    var iframeHeight;
                    if (graph.length > 0) {
                        iframeHeight = portfolioTable.height() + graph.height() + 150;
                    }
                    else {
                        iframeHeight = portfolioTable.height() + metricTable.height() + 150;
                    }

                    //if (document.documentMode == 7 || document.documentMode == 8 || document.documentMode == 9) {
                    //    portfolioTable.closest('div').css({ 'height': '100%' });
                    //}

                    iframe.height(iframeHeight);
                    iframe.contents().find('#divViewer').height(iframeHeight);
                    iframe.contents().find('#rvwReportViewer').height(iframeHeight);
                    iframe.contents().find('#rvwReportViewer_ct109').closest('td').height(iframeHeight);
                }

                forceIE8RefreshHeight(iframe);
            }
        });
    }
    else {
        $.each(selectOptions, function (index) {
            var selectedValue = selectOptions[index].value;
            if (selectedValue != 'advance_option') {
                var iframe = $("#ifReport_" + selectedValue);
                var currentTabType = getCurrentTabType();
                var portfolioTableName = 'portfolio_' + currentTabType;

                if ($.browser.msie || isIE11()) {
                    var iframeName = 'ifReport_' + selectedValue;
                    window.frames[iframeName].portfolioTable_Init(portfolioTableName);
                    window.frames[iframeName].fixHeight(iframe, portfolioTableName);
                }
                else {
                    var iframeName = 'ifReport_' + selectedValue;
                    window.frames[iframeName].contentWindow.portfolioTable_Init(portfolioTableName);
                    window.frames[iframeName].contentWindow.fixHeight(iframe, portfolioTableName);
                }

                iframe.closest('div').css('display', selectOptions[index].visibility);
            }
        });
    }

    //update CPR table array
    $.each(CPRTables, function (index) {
        var tabName = $(".tab_current").attr('id').replace('tab_', '');
        if (CPRTables[index].tableName == tabName) {
            CPRTables[index].visibleTable = selectedValue;
        }
    });
});

function renderAdvanceSearchArea() {
    var system;
    var dashBoardType;
    var dashboardValue;
    var dashboardSubValue;
    var dashboardSubSubValue;

    system = "?System=" + $('input#System').val();
    //system = $('#hddSystem').val() != "" ? "?System=" + $('#hddSystem').val() : "";
    //dashBoardType = $('#hddDashboardType').val() != "" ? "&Type=" + $('#hddDashboardType').val() : "";
    //dashboardValue = $('#hddDashboardValue').val() != "" ? "&Value=" + $('#hddDashboardValue').val() : "";
    //dashboardSubValue = $('#hddDashboardSubValue').val() != "" ? "&SubValue=" + $('#hddDashboardSubValue').val() : "";
    //dashboardSubSubValue = $('#hddDashboardSubSubValue').val() != "" ? "&SubSubValue=" + $('#hddDashboardSubSubValue').val() : "";

    //var queryData = system + dashBoardType + dashboardValue.replace(" & ", "@@@") + dashboardSubValue + dashboardSubSubValue;

    var url = window.g_baseUrl + "/Dashboard/GetReportParameters" + system;
    $.ajax({
        type: 'GET',
        url: url,
        cache: false,
        success: function (data) {
            // append "Advance search" area
            if (window.location.href.toLowerCase().indexOf('level2') >= 0) {
                var reportCover = $("#ifReportCover_Agency");

                // append to report cover
                reportCover.before(data);
            }
            else {
                var reportCover = $("#ifReportCover_week");

                // append before report iframe
                reportCover.before(data);
            }

            // adjust report parameter UI
            ProcessReportParameterUI();
        },
        statusCode: {
            403: function () {
                // forbidden (when users lost session) -> redirect to login page
                window.location.href = window.g_baseUrl + "/account/login";
            }
        }
    });
}

function changeCPRViewTypeOption(tab) {
    var selectedType = "";

    var isInAdvanceSearch = $('#cprAdvanceSearch').length > 0 && $('#cprAdvanceSearch').attr('style').indexOf("display: none") < 0;
    if (isInAdvanceSearch) {
        selectedType = 'advance_option'
    }
    else {
        var tabName = tab.attr('id').replace('tab_', '');
        var iframe = $("iframe#ifReport_Agency");

        iframe.contents().find("table[alt*='portfolio_']").each(function () {
            var CPRTable = $(this).attr("alt").split('_');
            var tableViewType = CPRTable[1];
            var tableType = $(this).attr("alt").replace("portfolio_" + tableViewType + "_", '');
            var tableVisibility = $(this).closest('div').attr('style');
            if (tableVisibility.indexOf("display: none") < 0 && tableType == tabName) {
                selectedType = tableViewType;
            }
        });
    }

    $("#cboCPRViewType option").each(function () {
        if ($(this).val() == selectedType) {
            selectedType = $(this).text();
        }
    });

    $("#cboCPRViewType").next('div').find("a[id*='sbSelector']").text(selectedType);
}

//function changeGoToCPRReportURL(tab) {
//    var tabName = tab.attr('id').replace('tab_', '').replace('agencies', 'agency');
//    var currentURL = $("#goToCPRReportIcon").attr('href');
//    var splittedCurrentURL = currentURL.split('&');
//    var sType = splittedCurrentURL[1];

//    //assign new type
//    $("#goToCPRReportIcon").attr('href', currentURL.replace(sType, 'Type=' + tabName));
//}

function fixIE8Height(tab) {
    var tabName = tab.attr('id').replace('tab_', '');
    var iframe = tabName == 'agency' ? $("#ifReport_Agency") : (tabName == 'group' ? $("#ifReport_Group") : $("#ifReport_AccountManager"));
    var selectedType = "";
    iframe.contents().find("table[alt*='portfolio_']").each(function () {
        var CPRTable = $(this).attr("alt").split('_');
        var tableType = CPRTable[1];
        var tableVisibility = $(this).closest('div').attr('style');
        if (tableVisibility.indexOf("display: none") < 0) {
            selectedType = tableType;
        }
    });

    var portfolioTable = iframe.contents().find("table[alt*='portfolio_" + selectedType + "']");
    var metricTable = iframe.contents().find("table[id*='tbMetric']");
    var graph = iframe.contents().find("img[alt^='graph_view']").closest('table');
    if (graph.length > 0) {
        if (metricTable.height() > graph.height()) {
            iframeHeight = portfolioTable.height() + metricTable.height() + 150;
        }
        else {
            iframeHeight = portfolioTable.height() + graph.height() + 150;
        }
    }
    else {
        iframeHeight = portfolioTable.height() + metricTable.height() + 150;
    }

    iframe.height(iframeHeight);
    iframe.contents().find('#divViewer').height(iframeHeight);
    iframe.contents().find('#rvwReportViewer').height(iframeHeight);
    iframe.contents().find('#rvwReportViewer_ct109').closest('td').height(iframeHeight);
}

// fix height issue in IE 8
function forceIE8RefreshHeight(iframe) {
    if (document.documentMode == 7 || document.documentMode == 8) {
        iframe.contents().find("table[alt^='portfolio']").each(function () {
            $(this).parent('td').attr('style', '');
        });
    }
}

$(function () {
    var system;
    var dashBoardType;
    var dashboardValue;
    var dashboardSubValue;
    var dashboardSubSubValue;

    system = $('#hddSystem').val() != "" ? "?System=" + $('#hddSystem').val() : "";
    dashBoardType = $('#hddDashboardType').val() != "" ? "&Type=" + $('#hddDashboardType').val() : "";
    dashboardValue = $('#hddDashboardValue').val() != "" ? "&Value=" + $('#hddDashboardValue').val() : "";
    dashboardSubValue = $('#hddDashboardSubValue').val() != "" ? "&SubValue=" + $('#hddDashboardSubValue').val() : "";
    dashboardSubSubValue = $('#hddDashboardSubSubValue').val() != "" ? "&SubSubValue=" + $('#hddDashboardSubSubValue').val() : "";

    if (window.location.href.toLowerCase().indexOf("level3") >= 0) {
        dashboardValue = "";
    }
    else if (window.location.href.toLowerCase().indexOf("level5") >= 0) {
        dashboardSubValue = "";
    }
    else if (window.location.href.toLowerCase().indexOf("level7") >= 0) {
        dashboardSubSubValue = "";
    }

    var queryData = system + dashBoardType + dashboardValue.replace(" & ", "@@@") + dashboardSubValue + dashboardSubSubValue;

    var randomNum = Math.ceil(Math.random() * 999999);
    var url = window.g_baseUrl + "/Report/ViewInfo" + queryData + "&reportpath=/emreporting/reports/PORT";
    $("#goToCPRReportIcon").attr('href', url);
});

function switchTabCPRLevel2(tab) {
    var newTabType = tab.attr('id').replace('tab_', '');
    var portfolioTableName;
    var metricTableName = 'metric_table_' + newTabType;
    var selectedViewType;

    $.each(CPRTables, function (index) {
        if (newTabType == CPRTables[index].tableName) {
            selectedViewType = CPRTables[index].visibleTable;
        }
    });

    // translate tab type
    var translatedType = newTabType;
    if (newTabType.toLowerCase() == 'portfolio' || newTabType.toLowerCase() == 'employer_size')
        translatedType = 'agency';
    else if (newTabType.toLowerCase() == 'account_manager')
        translatedType = 'accountmanager';

    if (selectedViewType == 'advance_option') {
        $('#cprAdvanceSearch').show();
        $("div[id*=ifReportCover]").hide();

        $("#portfolioReportSection div[id*=ifSearchCover]").hide();
        $("#portfolioReportSection div[id*=ifSearchCover_" + translatedType + "]").show();
    }
    else {
        // hide advance search
        $('#cprAdvanceSearch').hide();

        // hide CPR detail view
        $('div[id*="ifReportCover"] iframe[id*="ifTableReport_detail"]').hide();

        // show summary view
        if (document.URL.toLowerCase().indexOf('level2') > -1) {
            $('#ifReportCover_Agency').show();
            $('iframe#ifReport_Agency').show();
        }
        else {
            $('#ifReportCover_' + selectedViewType).show();
            $('iframe#ifReport_' + selectedViewType).show();
        }
    }

    hideDetailSection();

    portfolioTableName = 'portfolio_' + selectedViewType + '_' + newTabType;

    if ($.browser.msie || isIE11()) {
        window.frames['ifReport_Agency'].hideShowCPRTablesAndMetricLight(portfolioTableName, metricTableName);
        window.frames['ifReport_Agency'].portfolioTable_Init(portfolioTableName);
        window.frames['ifReport_Agency'].fixHeight($("#ifReport_Agency"), portfolioTableName);
    }
    else {
        window.frames['ifReport_Agency'].contentWindow.hideShowCPRTablesAndMetricLight(portfolioTableName, metricTableName);
        window.frames['ifReport_Agency'].contentWindow.portfolioTable_Init(portfolioTableName);
        window.frames['ifReport_Agency'].contentWindow.fixHeight($("#ifReport_Agency"), portfolioTableName);
    }
}

function hideDetailSection() {
    $('#ifReportCover_detail').hide();
    $('#CPRViewType').show();
}
