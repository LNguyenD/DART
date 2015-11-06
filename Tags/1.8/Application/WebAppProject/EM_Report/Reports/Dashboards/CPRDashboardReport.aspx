<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CPRDashboardReport.aspx.cs" Inherits="EM_Report.DashboardReports.CPRDashboardReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head011" runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title></title>
    <script src="../../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery-ui-1.11.3.custom.min.js" type="text/javascript"></script>
    <script src="<%=EM_Report.Helpers.FileVersioning.AppendVersion("../../Scripts/iDashboard.js") %>" type="text/javascript"></script>
    <script src="<%=EM_Report.Helpers.FileVersioning.AppendVersion("../../Scripts/iCPRTableRowColumnManager.js") %>" type="text/javascript"></script>
    <script src="<%=EM_Report.Helpers.FileVersioning.AppendVersion("../../Scripts/html2canvas.js") %>" type="text/javascript"></script>
    <link href="<%=EM_Report.Helpers.FileVersioning.AppendVersion("../../Css/dashboard.css") %>" rel="stylesheet" type="text/css" />
</head>
<body style="margin: 0;">
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server" ID="ScriptManager1">
        </asp:ScriptManager>
        <div align="center" id="divViewer" style="height: 100%; width: 100%;">
            <rsweb:ReportViewer CssClass="reportViewer" ID="rvwReportViewer" runat="server" Width="100%"
                Height="100%" ShowCredentialPrompts="false" AsyncRendering="true" ShowParameterPrompts="false"
                ShowRefreshButton="true" ShowToolBar="false">
            </rsweb:ReportViewer>
        </div>
    </form>
    <script type="text/javascript" language="javascript">
        var eventRegistered = false;

        Sys.Application.add_load(function () {
            $find("rvwReportViewer").add_propertyChanged(viewerPropertyChanged);
            
            if (!$.browser.msie) {
                $('#ifReport_Agency', window.parent.document).contents().find($("table[alt^='portfolio']")).each(function () {
                    $(this).find('tr:eq(1)').find('td:first').width(0.1);
                });
            }

        });

        // ======= CONCRETE METHODS =========
        function adjustReport_FixHeight(ifHeight) {                        

        }

        function adjustReport_FixWidth() {
            $("div[title$='width_30']").css("width", "99%");
            $("div[title$='width_100']").css("width", "100%");
        }

        function adjustReport_HideMetricLight(loading, ifHeight) {
            var strValueParam = getParameterByName("Value").toLowerCase();
            var url = document.URL.toLowerCase();

            if (loading) {
                $("#CPRViewType .sbSelector", window.parent.document).click(function (event) {
                    $("#CPRViewType .sbOptions", window.parent.document).hide();
                });

                PreventLoadingTabs("none");
                
            }
            else {
                $("#CPRViewType .sbSelector", window.parent.document).click(function (event) {
                    $("#CPRViewType .sbOptions", window.parent.document).show();
                });

                PreventLoadingTabs("auto");

            }            

            if ((url.indexOf('type=employer_size') >= 0 && url.indexOf('_level3') >= 0)

                // condition for grouping value Level 3
                || (url.indexOf('_level3') >= 0 && strValueParam == "police@@@fire@@@rfs" || strValueParam == "health@@@other" || strValueParam == "hotel")

                // condition for Level 5 no group
                || (url.indexOf('_level5') >= 0 && url.indexOf('type=group') < 0)

                // condition for total value
                || strValueParam == "tmf" || strValueParam == "wcnsw" || strValueParam == "hospitality"
                ) {

                // hide metric light title
                //$("#tbMetric_TrafficLight").parents("tr[vAlign='top']").prev().prev().hide();

                if (loading == false) {

                    var metricTableHeight = $("#tbMetric_TrafficLight").parent("td").height();
                    parent.metricTableHeightBeforeHide = metricTableHeight;

                    // hide metric table
                    if ($.browser.msie) {
                        // IE 7 and smaller version
                        $("#tbMetric_TrafficLight").parents("div[alt$='width_100']").parents("tr[vAlign='top']").hide();
                    }
                    else {
                        //$("#tbMetric_TrafficLight").parents("table[alt$='width_100']").parents("tr[vAlign='top']").hide();
                        $("#tbMetric_TrafficLight").parents("table:eq(0)").hide();
                    }

                    // adjust the iframe height
                    var iframe = getIframe();
                    iframe.height(ifHeight - (metricTableHeight + 30) + 'px');
                }
            }
        }

        function PreventLoadingTabs(status) {
            // Not allow user switch another tab while loading
            if (document.URL.toLowerCase().indexOf('tmf') >= 1) {
                if (document.URL.toLowerCase().indexOf('type=group') >= 1)
                    $("#tab_agency", window.parent.document).css('pointer-events', status);
                else {

                    $("#tab_group", window.parent.document).css('pointer-events', status);
                }
            }
            else if (document.URL.toLowerCase().indexOf('hem') >= 1) {
                if (document.URL.toLowerCase().indexOf('type=group') >= 1)
                    $("#tab_portfolio", window.parent.document).css('pointer-events', status);
                else
                    $("#tab_group", window.parent.document).css('pointer-events', status);
            }
            else if (document.URL.toLowerCase().indexOf('eml') >= 1) {
                if (document.URL.toLowerCase().indexOf('type=group') >= 1) {
                    $("#tab_employer_size", window.parent.document).css('pointer-events', status);
                    $("#tab_account_manager", window.parent.document).css('pointer-events', status);
                }
                else if (document.URL.toLowerCase().indexOf('type=employer_size') >= 1) {
                    $("#tab_group", window.parent.document).css('pointer-events', status);
                    $("#tab_account_manager", window.parent.document).css('pointer-events', status);
                }
                else {
                    $("#tab_group", window.parent.document).css('pointer-events', status);
                    $("#tab_employer_size", window.parent.document).css('pointer-events', status);
                }
            }
            else {
                if (document.URL.toLowerCase().indexOf('type=group') >= 1) {
                    $("#tab_portfolio", window.parent.document).css('pointer-events', status);
                    $("#tab_account_manager", window.parent.document).css('pointer-events', status);
                }
                else if (document.URL.toLowerCase().indexOf('type=division') >= 1) {
                    $("#tab_group", window.parent.document).css('pointer-events', status);
                    $("#tab_account_manager", window.parent.document).css('pointer-events', status);
                }
                else {
                    $("#tab_group", window.parent.document).css('pointer-events', status);
                    $("#tab_portfolio", window.parent.document).css('pointer-events', status);
                }
            }
        }

        function adjustReport_HandleReportLoadingCompleted() {
            hideLargeGraph();
            hidePrintingIconOfSmallGraphs();

            // fix for IE8
            if ($.browser.msie && $.browser.version < 9 && document.documentMode < 9) {
                fixLayoutIE8();
            }           
        }

        function adjustLayout() {
            $("img[alt*='description']").closest('td').css('width', '');
            $("img[alt*='description']").parents('div:eq(1)').css({ 'min-width': '', 'width': '5px' });;

            if (document.URL.toLowerCase().indexOf("_level2") >= 0) {
                AdjustMetricLightLevel2_Up();
            }
            else if (document.URL.toLowerCase().indexOf("_level3") >= 0) {
                AdjustMetricLightLevel2_Up();
            }
            else if (document.URL.toLowerCase().indexOf("_level4") >= 0) {
                AdjustMetricLightLevel2_Up();
            }
            else if (document.URL.toLowerCase().indexOf("_level5") >= 0) {
                AdjustMetricLightLevel2_Up();
                AdjustTitlteHeight();
            }
            else if (document.URL.toLowerCase().indexOf("_level6") >= 0) {
                AdjustMetricLightLevel2_Up();
                AdjustTitlteHeight();
            }

            // Center all graphs
            $("map").closest("td").attr("align", "center");
            $("map").closest("td").children("div").attr("align", "center");

            if (document.URL.toLowerCase().indexOf("#viewlarge") >= 0) {
                var obj = $("img[alt='Raw data']").not(":first").first();
                if (obj.length > 0) {
                    var off = obj.position();
                    parent.window.scrollTo(0, off.top + 110)
                }
            }

            //get href of the metric light raw data icon
            parent.metricLightHref = $("img[alt='Raw data']").first().parent('a').attr('href');

            adjustPortfolioTable();

            // fix for IE8
            if ($.browser.msie && $.browser.version < 9 && document.documentMode < 9) {
                fixLayoutIE8();
            }

            var portfolioTable = $("table[alt*='portfolio']");
            fixImages(portfolioTable);

        }

        function doAdditionalWorks() {
            //hideShowCPRTablesAndMetricLight();
            showHideClaimsValidation();
            initCPRTableArray();
            loadMonthReport();
            HideWowExtGrp();            
        }

        // Hide metric light for wow external group
        function HideWowExtGrp() {
            var grpName = $('#grpName', window.parent.document).val();            
            if (document.URL.toLowerCase().indexOf('wow') >= 1 && grpName == 'WOWExternal') {
                //$("table[alt*='portfolio_week_group']").find('tr:eq(2)').hide();
                //$("table[alt*='portfolio_month_group']").find('tr:eq(2)').hide();
                $("table[alt*='portfolio_week_group']").hide();
                $("table[alt*='portfolio_month_group']").hide();
            }
        }

        function getRawDataSource() {
            return "/Report/ReportRawData";
        }
        // ======= END CONCRETE METHODS =========



        // ========== ADJUST LAYOUT ===========
        function loadMonthReport() {
            var weekReportIframe = $('iframe#ifReport_week', window.parent.document);
            var weekReport = weekReportIframe.contents().find("table[alt*='portfolio']");
            var monthReportIframe = $('iframe#ifReport_month', window.parent.document);

            if (weekReport.length > 0 && monthReportIframe.length < 1) {
                var url = weekReportIframe.attr('src').split('?')[0];
                var dateCutOff = $("#dateCutOff", window.parent.document).val().split('/');
                var lastMonthDate = new Date(dateCutOff[2], dateCutOff[1] - 1, 1);
                lastMonthDate.setMonth(lastMonthDate.getMonth() - 1);
                startDate = new Date(lastMonthDate.getFullYear(), lastMonthDate.getMonth(), 1);
                endDate = new Date(lastMonthDate.getFullYear(), lastMonthDate.getMonth() + 1, 0);
                var startDateParam = '&Start_Date=' + startDate.getDate() + '/' + (startDate.getMonth() + 1) + '/' + startDate.getFullYear();
                var endDateParam = '&End_Date=' + endDate.getDate() + '/' + (endDate.getMonth() + 1) + '/' + endDate.getFullYear();

                var queryString = document.referrer.split('?')[1];
                url += '?' + queryString + startDateParam + endDateParam + "&View_Type=last_month";

                var monthReportContent = '<iframe id="ifReport_month" src="' + url + '" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>';
                $('div#ifReportCover_month', window.parent.document).html(monthReportContent);
            }            
        }

        function fixLayoutIE8() {
            if (document.URL.toLowerCase().indexOf('_level3') >= 0
                || document.URL.toLowerCase().indexOf('_level5') >= 0
                || document.URL.toLowerCase().indexOf('_level7') >= 0) {
                $(".breadcrum_01", window.parent.document).css("min-width", "1310px");
                $(".breadcrum_02", window.parent.document).css("min-width", "1290px");
                $(".container", window.parent.document).css("min-width", "1310px");
            }
        }

        function adjustPortfolioTable() {
            var portfolioTable = $("table[alt^='portfolio']");            
            
            if (portfolioTable.length > 0) {
                var tbOwner = $("div[id*='VisibleReportContentrvwReportViewer'] table:first");

                // get height of report viewer content
                var ifHeight = tbOwner.height();

                var loading = $("#rvwReportViewer_AsyncWait_Wait").is(':visible');
                if (loading) {
                    // supply a additional number for loading icon area
                    ifHeight = ifHeight + 78;
                }

                // fix layout for ie brower
                if ($.browser.msie || isIE11()) {

                    fixPortfolioLayout();
                    ShowActionButtons();
                    if (!eventRegistered) {
                        var iframe = getIframe();

                        registerDescriptionButtonHover();
                        registerPrintButtonClick();
                        registerPortfolioRowsAction(iframe);

                        fixPortfolioHeader();
                        fixMetricLight();

                        eventRegistered = true;
                    }
                }
                else {
                    if (ifHeight > IFRAME_LOADING_DIV_HEIGHT) {
                        // fix layout                       
                        fixPortfolioLayout();

                        // hide action buttons
                        ShowActionButtons();

                        if (!eventRegistered) {
                            var iframe = getIframe();

                            registerDescriptionButtonHover();
                            registerPrintButtonClick();
                            registerPortfolioRowsAction(iframe);
                            fixPortfolioHeader();
                            fixMetricLight();

                            eventRegistered = true;
                        }
                    }
                }

                // remove developer tooltips
                removePortfolioTooltips();
            }

            RemoveMetricLightUnnecessary();

        }

        function RemoveMetricLightUnnecessary() {
            $("table[alt^='portfolio']").each(function () {

                $(this).find('img').parent('div').css('display', 'none');

            });
        }

        function fixPortfolioLayout() {
            var iframe = getIframe();

            // hide show CPR table
            var currentTabType = parent.getCurrentTabType();
            var defaultPortfolioTableName;
            if (parent.document.URL.toLowerCase().indexOf('level3') > 0
                || parent.document.URL.toLowerCase().indexOf('level4') > 0) {
                defaultPortfolioTableName = 'portfolio_';
            }
            else {
                defaultPortfolioTableName = 'portfolio_week_' + currentTabType;
            }

            var portfolioTable = $("table[alt*='" + defaultPortfolioTableName + "']");
            var iframeHeight = portfolioTable.height();

            if (isLevel('level2')) {
                $("table[alt^='portfolio']").first().parents('table:eq(0)').find('tr:eq(0)').children('td').css({ 'width': '', 'min-width': '' });
                $("table[alt^='portfolio']").parent('td').css('height', '');
                $("table[alt^='portfolio'] td:eq(0)").css({ 'width': '0px' });
                $("table[alt^='portfolio']").each(function () {
                    $(this).closest('tr').children('td').css('height', '');
                });

                $("table[alt^='portfolio']").parent('td').removeAttr('colspan');

                if ($.browser.msie || isIE11()) {
                    $("table[alt^='portfolio']").css("margin-left", "1px");
                }

                var iframeWidth = $('div#content', window.parent.document).width() - 50;



                $("table[alt^='portfolio']").each(function () {
                    var tableContainer = $(this).closest('td');

                    var div = $('<div></div>');
                    div.wrapInner($(this));
                    tableContainer.html(div);

                    $(this).closest('div').css({ 'width': iframeWidth + 'px', 'overflow': 'auto' });
                    $(this).width(iframeWidth - 2);

                    if (document.documentMode == 7 || document.documentMode == 8) {
                        $(this).closest('div').height($(this).height() + 20);
                    }

                    // remove all unnecessary tr under dashboard                                        
                    $(this).parents("table:first").find('> tbody > tr').not("tr[vAlign='top']").remove('tr');

                    if (document.URL.toLowerCase().indexOf('hem') >= 0) {
                        var graph = $("td[alt^='title_graph_view']");
                        graph.parents('tr').prev('tr').height('40px');
                        graph.closest("td").css('vertical-align', 'bottom');
                    }
                    else {
                        var graph = $("td[alt^='title_graph_view']");
                        graph.closest("tr").css('height', '60px');
                        graph.closest("td").css('vertical-align', 'bottom');
                    }

                });

                iframe.width(iframeWidth);
                iframe.parent().attr('align', 'center');
            }
            else if (isLevel('level3') || isLevel('level4')) {
                //$("table[alt^='portfolio']").css('table-layout', 'fixed');
                $("table[alt^='portfolio']").find('tr:eq(1)').find('td:eq(1)').css('min-width', '200px');
                var iframeWidth = $('div#content', window.parent.document).width() - 50;
                $("table[alt^='portfolio']").parent('td').removeAttr('style');

                $("table[alt^='portfolio']").each(function () {
                    var tableContainer = $(this).closest('td');

                    var div = $('<div></div>');
                    div.wrapInner($(this));
                    tableContainer.html(div);

                    if (document.documentMode == 7 || document.documentMode == 8 || document.documentMode == 9) {
                        $(this).closest('div').css({ 'width': iframeWidth + 'px', 'overflow': 'auto', 'height': '100%' });
                    }
                    else {
                        $(this).closest('div').css({ 'width': iframeWidth + 'px', 'overflow': 'auto' });
                    }
                    $(this).width(iframeWidth - 2);

                    // remove all unnecessary tr under dashboard                                        
                    $(this).parents("table:first").find('> tbody > tr').not("tr[vAlign='top']").remove('tr');

                    if (document.URL.toLowerCase().indexOf('hem') >= 0) {
                        var graph = $("td[alt^='title_graph_view']");
                        graph.closest("tr").css('height', '40px');
                        graph.closest("td").css('vertical-align', 'bottom');
                    }
                    else {
                        var graph = $("td[alt^='title_graph_view']");
                        graph.closest("tr").css('height', '60px');
                        graph.closest("td").css('vertical-align', 'bottom');
                    }

                });

                iframe.width(iframeWidth);

                if (document.documentMode == 7 || document.documentMode == 8 || document.documentMode == 9) {
                    iframe.height(iframeHeight);
                }

                iframe.parent().attr('align', 'center');
            }

            // fix IE not refresh height issue
            if ($.browser.msie) {
                $('#content', window.parent.document).css('height', '');
            }

            // graph
            var graphImage = $("img[alt^='graph_view']");
            if (graphImage.length > 0) {
                var graphContainer;
                if ($.browser.msie || parent.isIE11()) {
                    graphContainer = graphImage.parents('table:eq(0)').parents('td:eq(0)');
                    $("div[alt*='cpr_graph_view']").each(function () {
                        $(this).css({ 'width': (iframeWidth - 1) + 'px' });
                    });
                }
                else {
                    graphContainer = graphImage.parents('table:eq(1)').parent('td');
                    $("table[alt*='cpr_graph_view']").each(function () {
                        $(this).css({ 'width': (iframeWidth - 1) + 'px' });
                    });
                }

                graphContainer.siblings('td:gt(0)').css('display', 'none');
                graphContainer[0].colSpan = 10;
                graphImage.parent().attr('align', 'center');
                //graphImage.parent().width(graphImage.width());
                //graphImage.parent().height(graphImage.height());
            }

            var defaultMetricTableName = 'metric_table_' + currentTabType;
            hideShowCPRTablesAndMetricLight(defaultPortfolioTableName, defaultMetricTableName);

            portfolioTable_Init(defaultPortfolioTableName);
            fixHeight(iframe, defaultPortfolioTableName);
            forceIE8RefreshHeight();
        }

        function fixPortfolioHeader() {
            $('table[alt^="portfolio"]').each(function () {
                var table = $(this);
                $(this).find('tr:first').children('td').css({ 'min-width': '' });

                // header width
                for (var i = 3; i < $(this).find('tr:eq(0) > td').length; i++) {
                    var cell = $(this).find('tr:eq(0) > td:eq(' + i + ')');
                    cell.width(90);
                }

                var numberOfColumns = $(this).find('tr:eq(1) > td').length;

                // header height              
                var headerHeight = $(this).find('tr:eq(1) > td:eq(0)').height();
                for (var i = 0; i < numberOfColumns; i++) {
                    var cell = $(this).find('tr:eq(1) > td:eq(' + i + ')');
                    if (document.documentMode != 7 && document.documentMode != 8) {
                        if (getIframe().parent('div').css('display').indexOf('none') < 0) {
                            cell.height(headerHeight);
                        }
                    }
                }

                UnderlineSubTotalAndTotal();

                // header hover
                for (var i = 2; i < numberOfColumns; i++) {
                    var cell = $(this).find('tr:eq(1) > td:eq(' + i + ')');
                    var cellValue = cell.children('div').children('a');

                    //remove special character
                    var cellText = cellValue.text().replace("@@@", " & ");

                    //remove '_total' part from the total column in CPR main table
                    cellText = cellText.replace('_total', '').toUpperCase();
                    cellValue.text(cellText);

                    if (i < numberOfColumns) {
                        // click
                        // populate querystring
                        var href = cellValue.attr('href');
                        var queryStringStartPos = href.indexOf("'");
                        var queryStringEndPos = href.lastIndexOf("'");
                        var queryString = href.substring(queryStringStartPos + 1, queryStringEndPos);

                        // register click event
                        cellValue.attr('href', 'javascript:void(0)');
                        cellValue.attr('onclick', 'openCPRDetail("' + queryString + '")');

                        // hover
                        cell.hover(function () {
                            $(this).addClass('hoverCell');
                        }, function () {
                            $(this).removeClass('hoverCell');
                        });

                        // made whole cell clickable
                        var div = $('<div></div>');
                        if (document.documentMode != 7 && document.documentMode != 8) {

                            div.addClass('vertical-align');
                        }

                        //set double underline for total column
                        if (i == numberOfColumns - 1) {
                            div.css({ 'border-bottom': 'double 3pt', 'display': 'inline', 'position': 'relative', 'line-height': '20px' });
                        }

                        cell.children('div').css({ 'height': '100%' });
                        cellValue.css({ 'display': 'block', 'height': '100%' });
                        cellValue.wrapInner(div);
                    }
                }
            });
        }

        function fixPortfolioHeaderHeight() {
            $('table[alt^="portfolio"]').each(function () {
                var numberOfColumns = $(this).find('tr:eq(1) > td').length;
                var headerHeight = $(this).find('tr:eq(1) > td:eq(0)').height() + 2;

                for (var i = 0; i < numberOfColumns; i++) {
                    var cell = $(this).find('tr:eq(1) > td:eq(' + i + ')');
                    if (document.documentMode != 7 && document.documentMode != 8) {
                        if (getIframe().parent('div').css('display').indexOf('none') < 0) {
                            cell.height(headerHeight);
                        }
                    }
                }
            });
        }

        function fixMetricLight() {
            $('table[alt^="portfolio"]').each(function () {
                var numberOfColumns = $(this).find('tr:eq(1) > td').length;

                for (var i = 2; i < numberOfColumns; i++) {
                    var cell = $(this).find('tr:eq(2) > td:eq(' + i + ')');

                    cell.find('table > tbody > tr:first > td').css({ 'width': '', 'min-width': '' });
                }
            });
        }

        function ShowActionButtons() {

            $("img[alt*='print_graph_view']").attr({ 'src': "../../images/ico_print.png" });
            $("img[alt*='print_graph_view']").closest('div').css('position', 'absolute');
            $("img[alt*='print_graph_view']").closest('div').css({ 'right': '4px' });
            $("img[alt*='print_graph_view']").css('cursor', 'pointer');
            $("img[alt*='print_graph_view']").closest("tr").css('height', '60px');
            $("img[alt*='print_graph_view']").closest("td").css('vertical-align', 'bottom');
            $("img[alt*='print_graph_view']").closest('td').find('> div').css('height', '8mm');

            $("img[alt*='raw_data_graph_view']").attr({ 'src': "../../images/bullet_raw_data.png" });
            $("img[alt*='raw_data_graph_view']").closest('div').css('position', 'absolute');
            $("img[alt*='raw_data_graph_view']").closest('div').css({ 'right': '36px' });
            $("img[alt*='raw_data_graph_view']").css('cursor', 'pointer');
            $("img[alt*='raw_data_graph_view']").closest("tr").css('height', '60px');
            $("img[alt*='raw_data_graph_view']").closest("td").css('vertical-align', 'bottom');
            $("img[alt*='raw_data_graph_view']").closest('td').find('> div').css('height', '8mm');

            $("img[alt*='description_graph_view']").attr({ 'src': "../../images/ico_description_final.png" });
            $("img[alt*='description_graph_view']").closest('div').css('position', 'absolute');
            $("img[alt*='description_graph_view']").closest('div').css({ 'right': '68px' });
            $("img[alt*='description_graph_view']").css('cursor', 'pointer');
            $("img[alt*='description_graph_view']").closest("tr").css('height', '60px');
            $("img[alt*='description_graph_view']").closest("td").css('vertical-align', 'bottom');
            $("img[alt*='description_graph_view']").closest('td').find('> div').css('height', '8mm');

            // adjust height and width for icon consistent with rtw, awc            
            $("img[alt*='print_graph_view']").css({ 'width': '23px' });
            $("img[alt*='print_graph_view']").css({ 'height': '19px' });
            $("img[alt*='print_graph_view']").closest('div').css({ 'width': '30px' });

            $("img[alt*='raw_data_graph_view']").css({ 'width': '19px' });
            $("img[alt*='raw_data_graph_view']").css({ 'height': '17px' });
            $("img[alt*='raw_data_graph_view']").closest('div').css({ 'width': '25px' });

            $("img[alt*='description_graph_view']").css({ 'width': '22px' });
            $("img[alt*='description_graph_view']").css({ 'height': '20px' });
            $("img[alt*='description_graph_view']").closest('div').css({ 'width': '25px' });
        }

        function portfolioTable_Init(tableName) {

            var portfolioTable = $("table[alt*='" + tableName + "']");
            var isInitCompleted = portfolioTable.attr('data-init-completed');

            if ((!isInitCompleted || isInitCompleted == 0)) {
                var iframe = getIframe();

                hideDetailedRowsByDefault(portfolioTable, iframe);

                // fix empty values
                portfolioTable.children('tbody').children('tr:gt(2)').find('a').each(function () {
                    var linkContent = $(this).html();
                    if (linkContent == "-") {
                        if (document.URL.toLowerCase().indexOf('tmf_cpr_level4') >= 0
                            && $.browser.msie && $.browser.version < 8) {
                            return;
                        }
                        else {
                            $(this).mouseover(function () {
                                $(this).css('cursor', 'default');
                            });
                            $(this).click(function (event) {
                                event.preventDefault();
                            });
                        }
                    }
                    else {
                        // populate querystring
                        var href = $(this).attr('href');
                        var queryStringStartPos = href.indexOf("'");
                        var queryStringEndPos = href.lastIndexOf("'");
                        var queryString = href.substring(queryStringStartPos + 1, queryStringEndPos);

                        // register click event
                        $(this).attr('href', 'javascript:void(0)');
                        $(this).click(function () {
                            openRawDataPopup(queryString);
                        });
                    }
                });

                portfolioTable.attr('data-init-completed', '1');
            }
        }
        // ========== END ADJUST LAYOUT ==============



        // =========== HELPER =============
        function openCPRDetail(param) {
            var currentType = parent.getCurrentType();
            var $report;

            var reportUrl = parent.g_baseUrl + '/Reports/Dashboards/CPRTableReport.aspx?' + param;

            if (isLevel('level2')) {
                // hide summary section
                $('iframe#ifReport_Agency', window.parent.document).hide();

                // view detail
                $report = $('#ifReportCover_Agency iframe[id*=ifTableReport_detail_' + currentType + ']', window.parent.document);
                if ($report.length > 0) {
                    
                    $report.attr('src', reportUrl);
                    $report.show();
                }
                else {
                    var reportContent = $('<iframe id="ifTableReport_detail_' + currentType + '" src="' + reportUrl + '" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>');
                    $('#ifReportCover_Agency', window.parent.document).append(reportContent);
                }
            }
            else {
                var viewType = getCurrentViewType();
                if (viewType != 'advance_option') {
                    // hide summary section
                    $('iframe#ifReport_' + viewType, window.parent.document).hide();

                    // view detail
                    $report = $('iframe[id*=ifTableReport_detail_' + viewType + ']', window.parent.document);
                    if ($report.length > 0) {
                        $report.attr('src', reportUrl);
                        $report.show();
                    }
                    else {
                        var reportContent = $('<iframe id="ifTableReport_detail_' + viewType + '" src="' + reportUrl + '" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>');
                        $('#ifReportCover_' + getCurrentViewType(), window.parent.document).append(reportContent);
                    }
                }
                else
                {
                    // hide summary section
                    $('iframe#ifReport_week', window.parent.document).hide();

                    // view detail
                    $report = $('iframe[id*=ifTableReport_detail_week]', window.parent.document);
                    if ($report.length > 0) {
                        $report.attr('src', reportUrl);
                        $report.show();
                    }
                    else {
                        var ifwidth = $('#ifReportCover_week', window.parent.document).width() - 65;
                        var ifheight = $('#ifReportCover_week', window.parent.document).height() + 700;                       

                        var reportContent = $('<iframe id="ifTableReport_detail_week' + '" src="' + reportUrl + '" width="100%" height="100%" frameborder="0" scrolling="no" style="width: '+ ifwidth +'px; height: '+ ifheight +'px "></iframe>');
                        $('#ifReportCover_week', window.parent.document).append(reportContent);
                    }                    
                }                
            }
            // hide CPR dropdown options
            $("#CPRViewType", window.parent.document).hide();
        }

        function getPortfolioTableType(portfolioTable) {
            var type = '';
            if (isLevel('level2') && portfolioTable.attr('alt') != null) {
                type = portfolioTable.attr('alt').replace('portfolio_week_', '').replace('portfolio_month_', '');
            }

            return type;
        }

        function rotateDetailedHeaderText(me) {
            me.css('margin-left', '-5px');
            me.css('width', '100px');
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
        }

        function fixHeight(iframe, portfolioTableName) {
            var portfolioTable = $("table[alt*='" + portfolioTableName + "']");

            var selectedType = "";
            $("table[alt*='" + portfolioTableName + "']").each(function () {
                var tableType = $(this).attr("alt").replace('portfolio_', '');
                var tableVisibility = $(this).closest('div').attr('style');
                if (!tableVisibility || tableVisibility.indexOf("display: none") < 0) {
                    selectedType = tableType;
                }
            });

            var iframeHeight = portfolioTable.height() + 150;
            if (document.documentMode == 7 || document.documentMode == 8) {
                portfolioTable.closest('div').height(portfolioTable.height() + 50);
            }

            var portfolioTable = $("table[alt*='portfolio_" + selectedType + "']");
            var graph = $("img[alt^='graph_view']").closest('table');
            if (graph.length > 0) {
                iframeHeight = portfolioTable.height() + graph.height() + 150;
            }

            if (document.documentMode == 7 || document.documentMode == 8) {
                portfolioTable.closest('div').height(portfolioTable.height() + 50);
            }

            iframe.height(iframeHeight);
            $('#divViewer').height(iframeHeight);
            $('#rvwReportViewer').height(iframeHeight);
            $('#rvwReportViewer_ct109').closest('td').height(iframeHeight);
        }

        function getIframe() {
            var iframe;
            if (isLevel('level2')) {
                iframe = $('iframe#ifReport_Agency', window.parent.document);
            }
            else {
                var portfolioTable = $("table[alt^='portfolio']");
                var alt = portfolioTable.attr('alt');

                if (typeof (alt) == 'undefined') {
                    iframe = $('iframe#ifReport_Agency', window.parent.document);
                }
                else {
                    var viewType = alt.split('_')[1];

                    var iframe = $('iframe', window.parent.document).filter(function () {
                        return $(this).attr('id').toLowerCase().indexOf(viewType.toLowerCase()) > -1;
                    });
                }
            }

            return iframe;
        }

        function removePortfolioTooltips() {
            // remove heading tooltips
            $("div[title='[image_header_tablix]']").attr("title", '');
            $("div[alt='[image_header_tablix]']").removeAttr("alt");
            $("[title^='DetailedPortfolio_']").attr("title", '');
            $("td[title='[image_header_tablix]']").attr("title", '');
            $("td[alt='[image_header_tablix]']").removeAttr("alt");
            $('table[alt^="portfolio"]').attr("title", '');
            $('table[alt*="metric_table"]').attr("title", '');
            $('table[alt^="portfolio"] td[alt*="therapy"]').attr("title", '');
            $('table[alt^="portfolio"] td[alt*="lump"]').attr("title", '');
            $("div[title*='therapy_treat']").attr("title", '');
            $("div[title*='lump_sum_int']").attr("title", '');
            $("div[title*='TotalDetailedPortfolio']").attr("title", '');
            $("[alt*=graph_view]").attr("title", '');

        }

        function hideShowCPRTablesAndMetricLight(portfolioTableName, metricTableName) {
            // hide all
            $("table[alt*='portfolio_week']").closest('div').css('display', 'none');
            $("table[alt*='portfolio_month']").closest('div').css('display', 'none');
            $("table[alt*='metric_table']").each(function () {
                if ($.browser.msie || isIE11()) {
                    $(this).parent('div').css('display', 'none');
                }
                else {
                    $(this).parents('table:eq(0)').css('display', 'none');
                }
            });

            // show default tables            
            $("table[alt*='" + portfolioTableName + "']").closest('div').css('display', '');
            if ($.browser.msie || isIE11()) {
                $("table[alt*='" + metricTableName + "']").parent('div').css('display', '');
            }
            else {
                $("table[alt*='" + metricTableName + "']").parents('table:eq(0)').css('display', '');
            }
        }

        function initCPRTableArray() {
            var array = parent.CPRTables;
            $('#ifReport_Agency', window.parent.document).contents().find($("table[alt^='portfolio']")).each(function () {
                array.push({
                    tableName: $(this).attr('alt').replace('portfolio_week_', '').replace('portfolio_month_', '')
                    , visibleTable: 'week'
                });
            });
        }

        function showHideClaimsValidation() {
            if (document.URL.toLowerCase().indexOf("_level3") >= 0) {
                var doValidate = parent.getParameterByName("doValidate");
                if (doValidate == 'true') {
                    $('td[alt="claimsValidationMessage"]').css('display', '');
                }
                else {
                    $('td[alt="claimsValidationMessage"]').css('display', 'none');
                }
            }
        }

        function fixImages(portfolioTable) {
            portfolioTable.find('img').each(function () {
                var imgCurent = $(this);
                var refixTooltip = "";

                if (imgCurent.attr('alt') != null) {
                    imgCurent.closest('div').attr('align', 'center');

                    var arrTraffic = $(this).attr('alt').replace("[", "").replace("]", "");
                    arrTraffic = arrTraffic.split('_');
                    var arrCompare = [];

                    imgCurent.attr({ "src": "../../images/light_violet.png" });

                    // clear tooltip
                    imgCurent.attr('title', '');

                    $.each(arrCompare, function (index) {
                        // For RTW: Measure/ For AWC: Number of claims
                        var value1 = parseFloat(arrTraffic[1]);

                        // For RTW: Target/ For AWC: Projection
                        var value2 = parseFloat(arrTraffic[2]);

                        if (value1 == NaN || value2 == NaN || (value1 == 0 && value2 == 0)) {
                            imgCurent.attr("src", '../' + unknowImageUrl);
                        }
                        else if (value2 >= parseFloat(arrCompare[index].fromVal)
                            && value2 <= parseFloat(arrCompare[index].toVal)) {
                            imgCurent.attr("src", '../' + arrCompare[index].url);
                        }
                    });
                }
            });
        }

        function getCurrentViewType() {
            var viewType = $('#cboCPRViewType', window.parent.document).find(":selected").val();
            return viewType;
        }

        function isLevel(level) {
            if (document.referrer.toLowerCase().indexOf(level) > -1)
                return true;

            return false;
        }

        function isIE11() {
            if (!!navigator.userAgent.match(/Trident\/7\./))
                return true;

            return false;
        }
        // =========== END HELPER ==============
    </script>
</body>
</html>
