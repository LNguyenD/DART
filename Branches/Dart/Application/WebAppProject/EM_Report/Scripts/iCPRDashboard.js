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
                        else if (level2CrumbtrailsCPR.indexOf('broker') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('broker', "employer size"));
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
                        else if (level2CrumbtrailsCPR.indexOf('broker') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('broker view', "portfolio view"));
                        }
                        //show level 4 lookahead crumtrails for porfolio
                        $("#lookaheadLevel3CrumbtrailsCPR").show();

                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace("team", "employer size"));
                        }

                        // hide level 4 lookahead crumtrails for portfolio
                        $("#lookaheadLevel4CrumbtrailsCPR").hide();
                    }
                    else if (systemName == "WOW") {                        
                        $("#level2CrumbtrailsCPR").html($("#level2CrumbtrailsCPR").html().replace("group", "division"));
                        $("#level2CrumbtrailsCPR").html($("#level2CrumbtrailsCPR").html().replace("state", "division"));

                        // hide level 4 lookahead crumtrails for agency
                        $("#lookaheadLevel4CrumbtrailsCPR").hide();

                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace("team", "state"));
                        }
                        else if (lookaheadLevel3CrumbtrailsCPR.indexOf('division') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace("division", "state"));
                        }
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
                        else if (level2CrumbtrailsCPR.indexOf('broker') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('broker', "group"));                            
                            $("#lookaheadLevel3CrumbtrailsCPR").show();
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

                        if (level2CrumbtrailsCPR.indexOf('broker') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('broker', "group"));
                            $("#lookaheadLevel3CrumbtrailsCPR").show();
                        }

                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('employer size') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html($("#lookaheadLevel3CrumbtrailsCPR").html().replace("employer size", "team"));
                        }
                    }
                    else if (systemName == "WOW") {
                        var grpName = $('#grpName', window.parent.document).val();
                        if (grpName == "WOWExternal") {
                            if (level2CrumbtrailsCPR.indexOf('division') >= 0) {
                                $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('division', "group"));
                                
                                $("#lookaheadLevel3CrumbtrailsCPR").hide();
                                $("#lookaheadLevel4CrumbtrailsCPR").hide();
                            }
                            else if (level2CrumbtrailsCPR.indexOf('state') >= 0) {
                                $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('state', "group"));
                                
                                $("#lookaheadLevel3CrumbtrailsCPR").hide();
                                $("#lookaheadLevel4CrumbtrailsCPR").hide();
                            }
                        }
                        else {
                            if (level2CrumbtrailsCPR.indexOf('division') >= 0) {
                                $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('division', "group"));

                                //show level 4 lookahead crumtrails for Group
                                $("#lookaheadLevel3CrumbtrailsCPR").show();
                            }
                            else if (level2CrumbtrailsCPR.indexOf('state') >= 0) {
                                $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('state', "group"));

                            }

                            // show level 4 lookahead crumtrails for Group
                            $("#lookaheadLevel4CrumbtrailsCPR").show();

                            if (lookaheadLevel3CrumbtrailsCPR.indexOf('state') >= 0) {
                                $("#lookaheadLevel3CrumbtrailsCPR").html($("#lookaheadLevel3CrumbtrailsCPR").html().replace("state", "team"));
                            }
                            else if (lookaheadLevel3CrumbtrailsCPR.indexOf('division') >= 0) {
                                $("#lookaheadLevel3CrumbtrailsCPR").html($("#lookaheadLevel3CrumbtrailsCPR").html().replace("division", "team"));
                            }
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
                        else if (level2CrumbtrailsCPR.indexOf('broker') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('broker', "account manager"));
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
                    else if (systemName == "WOW") {
                        
                        if (level2CrumbtrailsCPR.indexOf('division') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('division', "state"));

                        }
                        else if (level2CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('group', "state"));

                        }

                        //show level 4 lookahead crumtrails for Account Manager
                        $("#lookaheadLevel3CrumbtrailsCPR").show();

                        if (lookaheadLevel3CrumbtrailsCPR.indexOf('state') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('state', 'division'));
                        }
                        else if (lookaheadLevel3CrumbtrailsCPR.indexOf('team') >= 0) {
                            $("#lookaheadLevel3CrumbtrailsCPR").html(lookaheadLevel3CrumbtrailsCPR.replace('team', 'division'));
                        }

                        // hide level 4 lookahead crumtrails for account manager
                        $("#lookaheadLevel4CrumbtrailsCPR").hide();
                        
                    }
                }
            }
            else if (id_name == "tab_broker") {
                if (level2CrumbtrailsCPR != null) {
                    if (systemName == "Hospitality") {
                        if (level2CrumbtrailsCPR.indexOf('portfolio') >= 0) {                            
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('portfolio view', "broker view"));
                            $("#lookaheadLevel3CrumbtrailsCPR").hide();                            
                        }
                        if (level2CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('group view', "broker view"));
                            $("#lookaheadLevel3CrumbtrailsCPR").hide();
                            $("#lookaheadLevel4CrumbtrailsCPR").hide();
                        }
                    }
                    else if (systemName == "WCNSW") {
                        if (level2CrumbtrailsCPR.indexOf('employer size') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('employer size', "broker"));
                        }
                        else if (level2CrumbtrailsCPR.indexOf('group') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('group', "broker"));
                            $("#lookaheadLevel3CrumbtrailsCPR").hide();
                            $("#lookaheadLevel4CrumbtrailsCPR").hide();
                        }
                        else if (level2CrumbtrailsCPR.indexOf('account manager') >= 0) {
                            $("#level2CrumbtrailsCPR").html(level2CrumbtrailsCPR.replace('account manager', "broker"));
                            $("#lookaheadLevel3CrumbtrailsCPR").hide();
                        }
                    }
                }
            }
            adjustGuideBar();

            // keep track start time, end time of each page/tab
            submitTimeInfo(currentTab);
            saveStartTime();

            // Hide graph when switch tab
            HideGraphViewTypeOption($(this));
        });
    });    
}

var CPRTables = [];

$("#cboCPRViewType").change(function () {
    var selectedValue = $(this).val();
    var selectOptions = [];
    $("#cboCPRViewType option").each(function () {
        $(this).removeAttr('selected');

        var visibility = $(this).val() == selectedValue ? '' : 'none';
        selectOptions.push({
            value: $(this).val()
            , visibility: visibility
        });
    });

    // fix a bug that the dropdownlist does not clear selected attr of old selected item
    $("#cboCPRViewType option").each(function () {
        if ($(this).val() != selectedValue) {
            $(this).removeAttr('selected');
        }
        else {
            $(this).attr('selected', 'selected');
        }
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

                    if (document.URL.toLowerCase().indexOf('eml') >= 1) {
                        var graph = iframe.contents().find("img[alt^='broker_graph_view']").closest('table');
                        var iframeHeight;
                        if (graph.length > 0) {
                            iframeHeight = portfolioTable.height() + graph.height() + 150;
                        }
                    }
                    else if (document.URL.toLowerCase().indexOf('hem') >= 1) {
                        var currentTabType = parent.getCurrentTabType();                        
                        if (currentTabType == "broker") {
                            
                            var graph = iframe.contents().find("img[alt^='broker_graph_view']").closest('table');
                            var iframeHeight;
                            if (graph.length > 0) {
                                iframeHeight = portfolioTable.height() + graph.height() + 150;
                            }
                        }
                    }

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

                iframe.closest('div').css('display', selectOptions[index].visibility);

                if ($.browser.msie || isIE11()) {
                    var iframeName = 'ifReport_' + selectedValue;
                    window.frames[iframeName].portfolioTable_Init(portfolioTableName);
                    window.frames[iframeName].fixHeight(iframe, portfolioTableName);
                    window.frames[iframeName].fixPortfolioHeaderHeight();
                }
                else {
                    var iframeName = 'ifReport_' + selectedValue;
                    window.frames[iframeName].contentWindow.portfolioTable_Init(portfolioTableName);
                    window.frames[iframeName].contentWindow.fixHeight(iframe, portfolioTableName);
                }                
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

    var url = window.g_baseUrl + "/Dashboard/GetReportParameters" + system;    
    $.ajax({
        type: 'GET',
        url: url,
        cache: false,
        async: false,
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

    $("#cboCPRViewType option").removeAttr('selected').closest("option[value='" + selectedType + "']").attr('selected', 'selected');

    $("#cboCPRViewType option").each(function () {
        if ($(this).val() == selectedType) {
            selectedType = $(this).text();
        }
    });
        
    $("#cboCPRViewType").next('div').find("a[id*='sbSelector']").text(selectedType);
}

function HideGraphViewTypeOption(tab) {
    var newTabType = tab.attr('id').replace('tab_', '');
    var systemName = $('#wrapper .breadcrum_01 a:eq(0)').html().trim();
    var ifheight = "";    

    if (systemName == "WCNSW" || systemName == "Hospitality") {
        if (newTabType == "broker") {
            
            // Hide crp element
            if (!$.browser.msie && !isIE11())
                $('#ifReport_Agency').contents().find("table[alt='cpr_graph_view']").closest('td').closest('tr').css('display', 'none');
            else
                $('#ifReport_Agency').contents().find("div[alt='cpr_graph_view']").closest('td').closest('tr').css('display', 'none');

            $('#ifReport_Agency').contents().find("img[alt='description_graph_view_0']").closest('td').css('display', 'none');
            $('#ifReport_Agency').contents().find("img[alt='raw_data_graph_view_0']").closest('td').css('display', 'none');
            $('#ifReport_Agency').contents().find("img[alt='print_graph_view_0']").closest('td').css('display', 'none');
            if (systemName == "WCNSW") {
                $('#ifReport_Agency').contents().find("td[alt='title_graph_view_0']").closest('td').closest('tr').css('display', 'none');
            }
            else {
                $('#ifReport_Agency').contents().find("td[alt='title_graph_view_0']").closest('table').closest('td').closest('tr').css('display', 'none');
                $('#ifReport_Agency', window.parent.document).contents().find("img[alt='broker_description_graph_view_0']").closest('tr').css('height', '');
            }

            // adjust broker element
            $('#ifReport_Agency').contents().find("td[alt='broker_title_graph_view_0']").closest('table').closest('td').removeAttr('rowspan');
            $('#ifReport_Agency').contents().find("td[alt='broker_title_graph_view_0']").closest('table').closest('tr').removeAttr('style');
            $('#ifReport_Agency').contents().find("img[alt='broker_description_graph_view_0']").closest('td').removeAttr('style');
            $('#ifReport_Agency').contents().find("img[alt='broker_raw_data_graph_view_0']").closest('td').removeAttr('style');
            $('#ifReport_Agency').contents().find("img[alt='broker_print_graph_view_0']").closest('td').removeAttr('style');

            $('#ifReport_Agency').contents().find("td[alt='broker_title_graph_view_0']").closest('table').closest('td').css('display', '');

            if (systemName == "Hospitality") {
                if (!$.browser.msie && !isIE11())
                    $('#ifReport_Agency').contents().find("table[alt='broker_cpr_graph_view']").closest('td').closest('tr').css('display', '');
                else
                    $('#ifReport_Agency').contents().find("div[alt='broker_cpr_graph_view']").closest('td').closest('tr').css('display', '');

                $('#ifReport_Agency').contents().find("img[alt='broker_description_graph_view_0']").closest('td').removeAttr('rowspan');
                $('#ifReport_Agency').contents().find("img[alt='broker_raw_data_graph_view_0']").closest('td').removeAttr('rowspan');
                $('#ifReport_Agency').contents().find("img[alt='broker_print_graph_view_0']").closest('td').removeAttr('rowspan');
            }
            if (systemName == "Hospitality") {
                $('#ifReport_Agency', window.parent.document).contents().find("td[alt='broker_title_graph_view_0']").closest('table').closest('td').closest('tr').css({ 'position': 'absolute', 'margin-top': '-25px' });
            }            
        }
        else {            
            var orgHeight = $('#ifReport_Agency').height();
            if (!$.browser.msie && !isIE11())
                var graphHeight = $('#ifReport_Agency').contents().find("table[alt='broker_cpr_graph_view']").height();                                   
            else
                var graphHeight = $('#ifReport_Agency').contents().find("div[alt='broker_cpr_graph_view']").height();

            if (orgHeight < 800)
            {                
                $('#ifReport_Agency').css('height', orgHeight + graphHeight + 'px');
                if (!$.browser.msie && !isIE11())
                    $('#ifReport_Agency').contents().find('#rvwReportViewer').removeAttr('style');
                else {
                    $('iframe#ifReport_Agency', window.parent.document).contents().find('#divViewer').removeAttr("style");
                    $('iframe#ifReport_Agency', window.parent.document).contents().find('#rvwReportViewer').removeAttr("style");
                }
            }

            if (systemName == "Hospitality") {
                if (!$.browser.msie && !isIE11())
                    $('#ifReport_Agency').contents().find("table[alt='broker_cpr_graph_view']").closest('td').closest('tr').css('display', 'none');
                else
                    $('#ifReport_Agency').contents().find("div[alt='broker_cpr_graph_view']").closest('td').closest('tr').css('display', 'none');

                $('#ifReport_Agency').contents().find("td[alt='title_graph_view_0']").closest('table').closest('td').closest('tr').css('display', '');
                $('#ifReport_Agency', window.parent.document).contents().find("td[alt='title_graph_view_0']").closest('table').closest('td').closest('tr').removeAttr('style');
            }

            // Hide crp element
            if (!$.browser.msie && !isIE11())
                $('#ifReport_Agency').contents().find("table[alt='cpr_graph_view']").closest('td').closest('tr').css('display', '');
            else
                $('#ifReport_Agency').contents().find("div[alt='cpr_graph_view']").closest('td').closest('tr').css('display', '');

            $('#ifReport_Agency').contents().find("img[alt='description_graph_view_0']").closest('td').css('display', '');
            $('#ifReport_Agency').contents().find("img[alt='raw_data_graph_view_0']").closest('td').css('display', '');
            $('#ifReport_Agency').contents().find("img[alt='print_graph_view_0']").closest('td').css('display', '');
            $('#ifReport_Agency').contents().find("td[alt='title_graph_view_0']").closest('td').closest('tr').css('display', '');

            // adjust broker element
            $('#ifReport_Agency').contents().find("td[alt='broker_title_graph_view_0']").closest('table').closest('td').css('display', 'none');
            $('#ifReport_Agency').contents().find("td[alt='broker_title_graph_view_0']").closest('table').closest('tr').css('display', 'none');
            $('#ifReport_Agency').contents().find("img[alt='broker_description_graph_view_0']").closest('td').css('display', 'none');
            $('#ifReport_Agency').contents().find("img[alt='broker_raw_data_graph_view_0']").closest('td').css('display', 'none');
            $('#ifReport_Agency').contents().find("img[alt='broker_print_graph_view_0']").closest('td').css('display', 'none');           
        }
    }   
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

function isIE11() {
    if (!!navigator.userAgent.match(/Trident\/7\./))
        return true;

    return false;
}
