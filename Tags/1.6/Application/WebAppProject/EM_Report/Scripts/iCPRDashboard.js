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
            changeGoToCPRReportURL($(this));
            
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
            var lookaheadLevel4CrumbtrailsCPR = $("#lookaheadLevel4CrumbtrailsCPR").html();
            var lookaheadLevel5CrumbtrailsCPR = $("#lookaheadLevel5CrumbtrailsCPR").html();

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
                        $("#lookaheadLevel3CrumbtrailsCPR").html($("#lookaheadLevel3CrumbtrailsCPR").html().replace("group", "agency"));

                        //hide levels 6, 7 lookahead crumtrails for agency
                        $("#lookaheadLevel6CrumbtrailsCPR").hide();
                        $("#lookaheadLevel7CrumbtrailsCPR").hide();

                        if (lookaheadLevel4CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsCPR").html(lookaheadLevel4CrumbtrailsCPR.replace("team", "subcategory"));
                        }

                        if (lookaheadLevel5CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel5CrumbtrailsCPR").html(lookaheadLevel5CrumbtrailsCPR.replace("team", "subcategory"));
                        }

                    }
                    else if (systemName == "WCNSW") {

                        if (level2CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('group', "employer size"));

                        }
                        else if (level2CrumbtrailsCPR.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('account manager', "employer size"));

                        }

                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('group', "employer size"));
                        }
                        else if (lookaheadLevel3CrumbtrailsCPR.indexOf('account manager') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('account manager', "employer size"));
                        }

                        //hide levels 4, 5, 6, 7 lookahead crumtrails for employer size
                        $("#lookaheadLevel4CrumbtrailsCPR").hide();
                        $("#lookaheadLevel5CrumbtrailsCPR").hide();
                        $("#lookaheadLevel6CrumbtrailsCPR").hide();
                        $("#lookaheadLevel7CrumbtrailsCPR").hide();
                    }
                    else if (systemName == "Hospitality") {

                        if (level2CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('group', "portfolio"));

                        }
                        else if (level2CrumbtrailsCPR.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('account manager', "portfolio"));

                        }

                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('group', "portfolio"));
                        }
                        else if (lookaheadLevel3CrumbtrailsCPR.indexOf('account manager') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('account manager', "portfolio"));
                        }

                        //show level 4 5 lookahead crumtrails for porfolio
                        $("#lookaheadLevel4CrumbtrailsCPR").show();
                        $("#lookaheadLevel5CrumbtrailsCPR").show();

                        if (lookaheadLevel4CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsCPR").html(lookaheadLevel4CrumbtrailsCPR.replace("team", "employer size"));
                        }

                        if (lookaheadLevel5CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel5CrumbtrailsCPR").html(lookaheadLevel5CrumbtrailsCPR.replace("team", "employer size"));
                        }

                        //hide levels 6, 7 lookahead crumtrails for portfolio
                        $("#lookaheadLevel6CrumbtrailsCPR").hide();
                        $("#lookaheadLevel7CrumbtrailsCPR").hide();
                    }
                }
            }

            else if (id_name == "tab_group") {
                //change crumbtrail text when change tab Group
                // CPR
                if (level2CrumbtrailsCPR != null) {
                    if (systemName == "TMF") {

                        $("#level2CrumbtrailsCPR").html($("#level2CrumbtrailsCPR").html().replace("agency", "group"));
                        $("#lookaheadLevel3CrumbtrailsCPR").html($("#lookaheadLevel3CrumbtrailsCPR").html().replace("agency", "group"));

                        //show levels 6 ,7 lookahead crumtrails for group
                        $("#lookaheadLevel6CrumbtrailsCPR").show();
                        $("#lookaheadLevel7CrumbtrailsCPR").show();

                    }
                    else if (systemName == "WCNSW") {

                        if (level2CrumbtrailsCPR.indexOf('employer size') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('employer size', "group"));


                            //show levels 4, 5 lookahead crumtrails for Group
                            $("#lookaheadLevel4CrumbtrailsCPR").show();
                            $("#lookaheadLevel5CrumbtrailsCPR").show();
                        }
                        else if (level2CrumbtrailsCPR.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('account manager', "group"));

                        }

                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('employer size', "group"));
                        }
                        else if (lookaheadLevel3CrumbtrailsCPR.indexOf('account manager') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('account manager', "group"));
                        }

                        //show levels 6, 7 lookahead crumtrails for Group
                        $("#lookaheadLevel6CrumbtrailsCPR").show();
                        $("#lookaheadLevel7CrumbtrailsCPR").show();

                        if (lookaheadLevel4CrumbtrailsCPR.indexOf('subcategory') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsCPR").html($("#lookaheadLevel4CrumbtrailsCPR").html().replace("subcategory", "team"));
                        }
                        else if (lookaheadLevel4CrumbtrailsCPR.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsCPR").html($("#lookaheadLevel4CrumbtrailsCPR").html().replace("employer size", "team"));
                        }

                        if (lookaheadLevel5CrumbtrailsCPR.indexOf('subcategory') >= 0) {
                            $("#lookaheadLevel5CrumbtrailsCPR").html($("#lookaheadLevel5CrumbtrailsCPR").html().replace("subcategory", "team"));
                        }
                        else if (lookaheadLevel5CrumbtrailsCPR.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel5CrumbtrailsCPR").html($("#lookaheadLevel5CrumbtrailsCPR").html().replace("employer size", "team"));
                        }
                    }
                    else if (systemName == "Hospitality") {

                        if (level2CrumbtrailsCPR.indexOf('portfolio') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('portfolio view', "group view"));

                        }
                        else if (level2CrumbtrailsCPR.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('account manager', "group"));

                        }

                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('portfolio') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('for portfolio', "for group"));
                        }
                        else if (lookaheadLevel3CrumbtrailsCPR.indexOf('account manager') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('account manager', "group"));
                        }

                        //show levels 6, 7 lookahead crumtrails for Group
                        $("#lookaheadLevel6CrumbtrailsCPR").show();
                        $("#lookaheadLevel7CrumbtrailsCPR").show();

                        if (lookaheadLevel4CrumbtrailsCPR.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsCPR").html($("#lookaheadLevel4CrumbtrailsCPR").html().replace("employer size", "team"));
                        }

                        if (lookaheadLevel5CrumbtrailsCPR.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel5CrumbtrailsCPR").html($("#lookaheadLevel5CrumbtrailsCPR").html().replace("employer size", "team"));
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

                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('employer size', "account manager"));
                        }
                        else if (lookaheadLevel3CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('group', "account manager"));
                        }

                        //show level 4, 5 lookahead crumtrails for Account Manager
                        $("#lookaheadLevel4CrumbtrailsCPR").show();
                        $("#lookaheadLevel5CrumbtrailsCPR").show();

                        if (lookaheadLevel4CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsCPR").html(lookaheadLevel4CrumbtrailsCPR.replace('team', 'employer size'));
                        }

                        if (lookaheadLevel5CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel5CrumbtrailsCPR").html(lookaheadLevel5CrumbtrailsCPR.replace('team', 'employer size'));
                        }

                        //hide levels 6, 7 lookahead crumtrails for account manager
                        $("#lookaheadLevel6CrumbtrailsCPR").hide();
                        $("#lookaheadLevel7CrumbtrailsCPR").hide();
                    }
                    if (systemName == "Hospitality") {

                        if (level2CrumbtrailsCPR.indexOf('portfolio') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('portfolio view', "account manager view"));

                        }
                        else if (level2CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('group', "account manager"));

                        }

                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('portfolio') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('for portfolio', "for account manager"));
                        }
                        else if (lookaheadLevel3CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('group', "account manager"));
                        }

                        //show level 4, 5 lookahead crumtrails for Account Manager
                        $("#lookaheadLevel4CrumbtrailsCPR").show();
                        $("#lookaheadLevel5CrumbtrailsCPR").show();

                        if (lookaheadLevel4CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel4CrumbtrailsCPR").html(lookaheadLevel4CrumbtrailsCPR.replace('team', 'employer size'));
                        }

                        if (lookaheadLevel5CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel5CrumbtrailsCPR").html(lookaheadLevel5CrumbtrailsCPR.replace('team', 'employer size'));
                        }

                        //hide levels 6, 7 lookahead crumtrails for account manager
                        $("#lookaheadLevel6CrumbtrailsCPR").hide();
                        $("#lookaheadLevel7CrumbtrailsCPR").hide();
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

    var iframe;
    if (window.location.href.toLowerCase().indexOf('level2') >= 0) {
        iframe = $("#ifReport_Agency");
    }
    else {
        iframe = $("#ifReport");
    }

    //hide or show corresponding cpr table
    $.each(selectOptions, function (index) {
        var currentTabType = getCurrentTabType();
        var portfolioTableName = 'portfolio_' + selectOptions[index].value + '_' + currentTabType;
        if ($.browser.msie || isIE11()) {
            if (document.URL.toLowerCase().indexOf('level2') >= 0) {
                window.frames['ifReport_Agency'].portfolioTable_Init(portfolioTableName);
            }
            else {
                window.frames['ifReport'].portfolioTable_Init(portfolioTableName);
            }
        }
        else {
            if (document.URL.toLowerCase().indexOf('level2') >= 0) {
                window.frames['ifReport_Agency'].contentWindow.portfolioTable_Init(portfolioTableName);
            }
            else {
                window.frames['ifReport'].contentWindow.portfolioTable_Init(portfolioTableName);
            }
        }
      
        var visibility = selectOptions[index].visibility;
        var portfolioTable = iframe.contents().find("table[alt*='" + portfolioTableName + "']");
        portfolioTable.closest('div').css('display', selectOptions[index].visibility);

        if (visibility != 'none') {
            var metricTable = iframe.contents().find("table[alt*='metric_table_" + currentTabType + "']");
            var graph = iframe.contents().find("img[alt^='graph_view']").closest('table');
            var iframeHeight;
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

            if (document.documentMode == 7 || document.documentMode == 8) {
                portfolioTable.closest('div').height(portfolioTable.height() + 50);
            }

            iframe.height(iframeHeight);
            iframe.contents().find('#divViewer').height(iframeHeight);
            iframe.contents().find('#rvwReportViewer').height(iframeHeight);
            iframe.contents().find('#rvwReportViewer_ct109').closest('td').height(iframeHeight);
        }

        forceIE8RefreshHeight(iframe);
    });

    //update CPR table array
    $.each(CPRTables, function (index) {
        var tabName = $(".tab_current").attr('id').replace('tab_', '');
        if (CPRTables[index].tableName == tabName) {
            CPRTables[index].visibleTable = selectedValue;
        }
    });
});

function changeCPRViewTypeOption(tab) {
    var tabName = tab.attr('id').replace('tab_', '');
    var iframe = $("iframe#ifReport_Agency");
    var selectedType = "";
    iframe.contents().find("table[alt*='portfolio_']").each(function () {
        var CPRTable = $(this).attr("alt").split('_');
        var tableViewType = CPRTable[1];
        var tableType = $(this).attr("alt").replace("portfolio_" + tableViewType + "_",'');
        var tableVisibility = $(this).closest('div').attr('style');
        if (tableVisibility.indexOf("display: none") < 0 && tableType == tabName) {
            selectedType = tableViewType;
        }
    });

    $("#cboCPRViewType option").each(function () {
        if ($(this).val() == selectedType) {
            selectedType = $(this).text();
        }
    });

    $("#cboCPRViewType").next('div').find("a[id*='sbSelector']").text(selectedType);
}

function changeGoToCPRReportURL(tab) {
    var tabName = tab.attr('id').replace('tab_', '').replace('agencies', 'agency');
    var currentURL = $("#goToCPRReportIcon").attr('href');
    var splittedCurrentURL = currentURL.split('&');
    var sType = splittedCurrentURL[1];

    //assign new type
    $("#goToCPRReportIcon").attr('href', currentURL.replace(sType, 'Type=' + tabName));
}

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

    portfolioTableName = 'portfolio_' + selectedViewType + '_' + newTabType;

    if ($.browser.msie || isIE11()) {
        window.frames['ifReport_Agency'].hideShowCPRTablesAndMetricLight(portfolioTableName, metricTableName);
        window.frames['ifReport_Agency'].portfolioTable_Init(portfolioTableName);
        window.frames['ifReport_Agency'].fixHeight($("#ifReport_Agency"), newTabType);
    }
    else {
        window.frames['ifReport_Agency'].contentWindow.hideShowCPRTablesAndMetricLight(portfolioTableName, metricTableName);
        window.frames['ifReport_Agency'].contentWindow.portfolioTable_Init(portfolioTableName);
        window.frames['ifReport_Agency'].contentWindow.fixHeight($("#ifReport_Agency"), newTabType);
    }
}
