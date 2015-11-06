<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CPRDashboardReport.aspx.cs" Inherits="EM_Report.DashboardReports.CPRDashboardReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head011" runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title></title>
    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.11.0.custom.min.js" type="text/javascript"></script>
    <script src="<%=EM_Report.Helpers.FileVersioning.AppendVersion("../Scripts/iDashboard.js") %>" type="text/javascript"></script>
    <link href="<%=EM_Report.Helpers.FileVersioning.AppendVersion("../Css/dashboard.css") %>" rel="stylesheet" type="text/css" />
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
        });

        // ======= CONCRETE METHODS =========
        function adjustReport_FixHeight(ifHeight) {
            if (document.URL.toLowerCase().indexOf('_level2') >= 0) {
                $('#ifReport_Agency', window.parent.document).height(ifHeight + 'px');
            }
            else {
                $('#ifReport', window.parent.document).height(ifHeight + 'px');
            }
        }

        function adjustReport_FixWidth() {
            $("div[title$='width_30']").css("width", "99%");
            $("div[title$='width_100']").css("width", "100%");
        }

        function adjustReport_HideMetricLight(loading, ifHeight) {
            var strValueParam = getParameterByName("Value").toLowerCase();
            var url = document.URL.toLowerCase();

            if ((url.indexOf('type=employer_size') >= 0 && url.indexOf('_level3') >= 0)

                // condition for grouping value Level 3
                || (url.indexOf('_level3') >= 0 && strValueParam == "police@@@fire" || strValueParam == "health@@@other" || strValueParam == "hotel")

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
                    $('#ifReport', window.parent.document).height(ifHeight - (metricTableHeight + 30) + 'px');
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
        }

        function doAdditionalWorks() {
            //hideShowCPRTablesAndMetricLight();
            initCPRTableArray();
        }

        function getRawDataSource() {
            return "/Report/ReportRawData";
        }
        // ======= END CONCRETE METHODS =========



        // ========== ADJUST LAYOUT ===========
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
            portfolioTable.css('table-layout', 'fixed');
            if (portfolioTable.length > 0) {
                var tbOwner = $("div[id*='VisibleReportContentrvwReportViewer'] table:first");

                // get height of report viewer content
                var ifHeight = tbOwner.height();

                var loading = $("#rvwReportViewer_AsyncWait_Wait").is(':visible');
                if (loading) {
                    // supply a additional number for loading icon area
                    ifHeight = ifHeight + 78;
                }

                if (ifHeight > IFRAME_LOADING_DIV_HEIGHT) {
                    // fix layout
                    //hideDetailedRowsByDefault();
                    fixPortfolioLayout();

                    // hide action buttons
                    hideActionButtons();

                    if (!eventRegistered) {
                        registerDescriptionButtonHover();
                        registerPrintButtonClick();
                        registerPortfolioRowsAction();
                        fixPortfolioHeader();

                        eventRegistered = true;
                    }

                    // remove developer tooltips
                    removePortfolioTooltips();

                    // fix empty values
                    //portfolioTable.find('a').each(function () {
                    //    var linkContent = $(this).html();

                    //    if (linkContent == "-") {
                    //        if (document.URL.toLowerCase().indexOf('tmf_cpr_level4') >= 0
                    //            && $.browser.msie && $.browser.version < 8) {
                    //            return;
                    //        }
                    //        else {
                    //            $(this).mouseover(function () {
                    //                $(this).css('cursor', 'default');
                    //            });
                    //            $(this).click(function (event) {
                    //                event.preventDefault();
                    //            });
                    //        }
                    //    }
                    //});
                }
            }
        }

        function fixPortfolioLayout() {
            var iframe;
            if (document.URL.toLowerCase().indexOf('level2') > 0) {
                //var portfolioTable = $("table[alt^='portfolio']").first();
                //var type = getPortfolioTableType(portfolioTable);
                //iframe = $('iframe', window.parent.document).filter(function () {
                //    return $(this).attr('id').toLowerCase().indexOf(type.toLowerCase()) > -1;
                //});
                iframe = $('iframe#ifReport_Agency', window.parent.document);
            }
            else {
                iframe = $('iframe#ifReport', window.parent.document);
            }

            if (document.URL.toLowerCase().indexOf('level2') > 0) {
                $("table[alt^='portfolio']").first().parents('table:eq(0)').find('tr:eq(0)').children('td').css({ 'width': '', 'min-width': '' });
                $("table[alt^='portfolio']").parent('td').css('height', '');
                $("table[alt^='portfolio'] td:eq(0)").css({ 'width': '0px' });
                $("table[alt^='portfolio']").each(function () {
                    $(this).closest('tr').children('td').css('height', '');
                });
                $("table[id*='tbMetric']").css({ 'width': '100%' });
                $("table[alt*='metric_table']").each(function () {
                    if ($.browser.msie) {
                        $(this).parents('tr:eq(0)').children('td').css('height', '');
                    }
                    else {
                        $(this).parents('tr:eq(1)').children('td').css('height', '');
                    }
                });

                if ($.browser.msie || isIE11()) {
                    if(document.documentMode == 7 || document.documentMode == 8){
                        $("table[id*='tbMetric']").find('tr:eq(0)').children('td').css({ 'width': '0px', 'min-width': '0px' });
                        $("table[id*='tbMetric']").closest('tr').prev('tr').children('td').css({ 'height': '0px' });
                    }
                    
                    $("table[alt^='portfolio']").css("margin-left", "1px");
                }

                var iframeWidth = iframe.width();
                $("table[alt^='portfolio']").each(function () {
                    var tableContainer = $(this).closest('td');

                    var div = $('<div></div>');
                    div.wrapInner($(this));
                    tableContainer.html(div);

                    $(this).closest('div').css({ 'width': (iframeWidth - 48) + 'px', 'overflow': 'auto' });
                    $(this).width(iframeWidth - 50);

                    if (document.documentMode == 7 || document.documentMode == 8) {
                        $(this).closest('div').height($(this).height() + 20);
                    }
                });
                $("table[id*='tbMetric']").width(iframeWidth - 50);

                iframe.width(iframeWidth - 29);
                iframe.parent().attr('align', 'center');
            }
            else if (document.URL.toLowerCase().indexOf('level3') > 0) {
                $("table[alt^='portfolio']").each(function () {
                    $(this).closest('tr').children('td:eq(0)').css('height', '');

                    var tableContainer = $(this).closest('td');
                    var div = $('<div></div>');
                    div.wrapInner($(this));
                    tableContainer.html(div);
                });

                if ($.browser.msie) {
                    $("table[id*='tbMetric']").parent('div').css({ 'width': '', 'min-width': '' });
                    $("table[id*='tbMetric']").find('tr:eq(0)').children('td').css({ 'width': '0px', 'min-width': '0px' });
                    $("img[alt*='graph_view']").closest('table').parent('div').css({ 'width': '', 'min-width': '' });
                }


                iframe.parent(".content").attr('align', 'center');
            }
            else if (document.URL.toLowerCase().indexOf('level4') > 0) {
                $("table[id*='tbMetric']").parents('table:eq(0)').find('tr:eq(0)').children('td').css({ 'width': '', 'min-width': '' });
                $("table[alt^='portfolio']").each(function () {
                    $(this).closest('tr').children('td:eq(0)').css('height', '');
                });

                if ($.browser.msie) {
                    $("table[id*='tbMetric']").find('tr:eq(0)').children('td').css({ 'width': '0px', 'min-width': '0px' });
                }

                var iframeWidth = iframe.width();
                $("table[alt^='portfolio']").each(function () {
                    var tableContainer = $(this).closest('td');

                    var div = $('<div></div>');
                    div.wrapInner($(this));
                    tableContainer.html(div);

                    $(this).closest('div').css({ 'width': (iframeWidth - 48) + 'px', 'overflow': 'auto' });
                    $(this).width(iframeWidth - 50);
                    if (document.documentMode == 7 || document.documentMode == 8) {
                        $(this).closest('div').height($(this).height() + 20);
                    }
                });
                $("table[id*='tbMetric']").width(iframeWidth - 50);

                iframe.width(iframeWidth - 29);
                iframe.parent().attr('align', 'center');
            }
            else if (document.URL.toLowerCase().indexOf('level5') > 0) {
                $("table[alt^='portfolio']").each(function () {
                    $(this).closest('tr').children('td:eq(0)').css('height', '');

                    var tableContainer = $(this).closest('td');
                    var div = $('<div></div>');
                    div.wrapInner($(this));
                    tableContainer.html(div);
                });

                if ($.browser.msie) {
                    $("table[id*='tbMetric']").parent('div').css({ 'width': '', 'min-width': '' });
                    $("table[id*='tbMetric']").find('tr:eq(0)').children('td').css({ 'width': '0px', 'min-width': '0px' });
                    $("img[alt*='graph_view']").closest('table').parent('div').css({ 'width': '', 'min-width': '' });
                }

                iframe.parent(".content").attr('align', 'center');
            }
            else if (document.URL.toLowerCase().indexOf('level6') > 0) {
                $("table[alt^='portfolio']").first().parents('table:eq(0)').find('tr:eq(0)').children('td').css({ 'width': '', 'min-width': '' });
                $("table[alt^='portfolio']").parent('td').css('height', '');
                $("table[alt^='portfolio'] td:eq(0)").css({ 'width': '0px' });
                $("table[id*='tbMetric']").css({ 'width': '100%' });
                $("table[id*='tbMetric']").parents('table:eq(0)').find('tr:eq(0)').children('td').css({ 'width': '', 'min-width': '' });
                if ($.browser.msie) {
                    $("table[id*='tbMetric']").find('tr:eq(0)').children('td').css({ 'width': '0px', 'min-width': '0px' });
                    $("table[alt^='portfolio']").css("margin-left", "1px");
                }

                var iframeWidth = iframe.width();
                $("table[alt^='portfolio']").each(function () {
                    var tableContainer = $(this).closest('td');

                    var div = $('<div></div>');
                    div.wrapInner($(this));
                    tableContainer.html(div);

                    $(this).closest('div').css({ 'width': (iframeWidth - 48) + 'px', 'overflow': 'auto' });
                    $(this).width(iframeWidth - 50);
                    if (document.documentMode == 7 || document.documentMode == 8) {
                        $(this).closest('div').height($(this).height() + 20);
                    }
                });
                $("table[id*='tbMetric']").width(iframeWidth - 50);
                iframe.width(iframeWidth - 29);

                iframe.parent().attr('align', 'center');
            }
            else if (document.URL.toLowerCase().indexOf('level7') > 0) {
                if ($.browser.msie) {
                    $("table[alt^='portfolio']").first().closest('div').css({ 'width': '', 'min-width': '' });
                }

                if (document.documentMode == 7 || document.documentMode == 8) {
                    $('div#VisibleReportContentrvwReportViewer_ctl09').css('width', '99%');
                }
                else {
                    iframe.css('width', '97%');
                }

                $("table[alt^='portfolio']").each(function () {
                    $(this).parent('td').css('height', '');

                    var tableContainer = $(this).closest('td');
                    var div = $('<div></div>');
                    div.wrapInner($(this));
                    tableContainer.html(div);
                });

                iframe.parent(".content").attr('align', 'center');
            }

            // fix graph title
            $('td[alt^="title_graph_view"]').children('div').css({ 'width': '', 'min-width': '' });

            //fix graph in case hide metric light
            if ($("table[id*='tbMetric']").length == 0) {
                var graphContainer;
                if ($.browser.msie) {
                    $("img[alt^='graph_view']").parents('table:eq(1)').find('tr:eq(0)').children('td').css({ 'width': '', 'min-width': '' });
                    graphContainer = $("img[alt^='graph_view']").parents('table:eq(0)').parents('td:eq(0)');
                }
                else {
                    $("img[alt^='graph_view']").parents('table:eq(2)').find('tr:eq(0)').children('td').css({ 'width': '', 'min-width': '' });
                    graphContainer = $("img[alt^='graph_view']").parents('table:eq(1)').parent('td');
                }

                graphContainer.siblings('td:gt(0)').css('display', 'none');
                graphContainer[0].colSpan = 10;
            }

            // fix IE not refresh height issue
            if ($.browser.msie) {
                $('#content', window.parent.document).css('height', '');
            }

            // hide show CPR table
            var currentTabType = parent.getCurrentTabType();
            var defaultPortfolioTableName = 'portfolio_week_' + currentTabType;
            var defaultMetricTableName = 'metric_table_' + currentTabType;
            hideShowCPRTablesAndMetricLight(defaultPortfolioTableName, defaultMetricTableName);

            portfolioTable_Init(defaultPortfolioTableName);
            fixHeight(iframe, currentTabType);
            forceIE8RefreshHeight();
        }

        function fixPortfolioHeader() {
            if (document.URL.toLowerCase().indexOf('level2') > -1 || document.URL.toLowerCase().indexOf('level4') > -1 || document.URL.toLowerCase().indexOf('level6') > -1) {
                $('table[alt^="portfolio"]').each(function () {
                    // header width
                    for (var i = 3; i < $(this).find('tr:eq(0) td').length; i++) {
                        var cell = $(this).find('tr:eq(0) td:eq(' + i + ')');
                        cell.width(100);
                    }

                    // header hover
                    var numberOfColumns = $(this).find('tr:eq(1) td').length
                    for (var i = 2; i < numberOfColumns; i++) {
                        var cell = $(this).find('tr:eq(1) td:eq(' + i + ')');

                        //remove special character
                        var cellText = cell.children('div').children('a').text().replace("@@@", " & ");

                        //remove '_total' part from the total column in CPR main table
                        cellText = cellText.replace('_total', '');

                        cell.children('div').children('a').text(cellText);                        

                        if (i < numberOfColumns - 1)
                        {
                            // hover
                            cell.hover(function () {
                                $(this).addClass('hoverCell');
                            }, function () {
                                $(this).removeClass('hoverCell');
                            });

                            // made whole cell clickable
                            var div = $('<div></div>');
                            if (document.documentMode != 7 && document.documentMode != 8) {
                                var headerHeight = $(this).find('tr:eq(1) td:eq(0)').height();
                                cell.height(headerHeight);
                                div.addClass('vertical-align');
                            }
                            cell.children('div').css({ 'height': '100%' });
                            cell.children('div').children('a').css({ 'display': 'block', 'height': '100%' });
                            cell.children('div').children('a').wrapInner(div);
                        }
                        else {
                            // prevent click on total column
                            if (document.URL.toLowerCase().indexOf('level2') < 0) {
                                cell.children('div').html(cellText);
                            }
                            else {
                                // hover
                                cell.hover(function () {
                                    $(this).addClass('hoverCell');
                                }, function () {
                                    $(this).removeClass('hoverCell');
                                });

                                // made whole cell clickable
                                var div = $('<div></div>');
                                if (document.documentMode != 7 && document.documentMode != 8) {
                                    var headerHeight = $(this).find('tr:eq(1) td:eq(0)').height();
                                    cell.height(headerHeight);
                                    div.addClass('vertical-align');
                                }
                                cell.children('div').css({ 'height': '100%' });
                                cell.children('div').children('a').css({ 'display': 'block', 'height': '100%' });
                                cell.children('div').children('a').wrapInner(div);
                            }
                        }
                    }
                });
            }
            else if (document.URL.toLowerCase().indexOf('level3') > -1 || document.URL.toLowerCase().indexOf('level5') > -1 || document.URL.toLowerCase().indexOf('level7') > -1) {
                $('table[alt^="portfolio"]').each(function () {
                    // header width
                    for (var i = 3; i < $(this).find('tr:eq(0) td').length; i++) {
                        var cell = $(this).find('tr:eq(0) td:eq(' + i + ')');
                        cell.css({ 'width': '', 'min-width': '' });
                    }

                    for (var i = 2; i < $(this).find('tr:eq(4) td').length; i++) {
                        var cell = $(this).find('tr:eq(4) td:eq(' + i + ')');

                        // remove special character
                        var cellText = cell.children('div').text().replace("@@@", " & ");
                        cell.children('div').text(cellText);

                        //rotateDetailedHeaderText(cell.children('div'));
                    }
                });
            }
        }

        function hideActionButtons() {
            if (document.URL.toLowerCase().indexOf("_level2") >= 0
                || document.URL.toLowerCase().indexOf("_level4") >= 0
                || document.URL.toLowerCase().indexOf("_level6") >= 0) {
                $(".print_icon", window.parent.document).hide();
            }
            else if (document.URL.toLowerCase().indexOf("_level3") >= 0
                || document.URL.toLowerCase().indexOf("_level5") >= 0
                || document.URL.toLowerCase().indexOf("_level7") >= 0) {
                $("img[alt*='raw_data']").hide();
                $("img[alt*='raw_data']").parents('div:eq(1)').css({'min-width': '', 'width': '5px'});
            }
        }

        function portfolioTable_Init(tableName) {
            var portfolioTable = $("table[alt*='" + tableName + "']");
            var isInitCompleted = portfolioTable.attr('data-init-completed');

            if (!isInitCompleted || isInitCompleted == 0) {
                hideDetailedRowsByDefault(portfolioTable);

                // fix empty values
                portfolioTable.find('tr:gt(1)').find('a').each(function () {
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

                        if (document.URL.toLowerCase().indexOf("_level2") >= 0) {
                            // append Type variable to query string for Level 2 only
                            var type = getPortfolioTableType(portfolioTable);
                            queryString += '&Type=' + type;
                        }
                        
                        var param = '';
                        if (tableName.toLowerCase().indexOf('week') > -1) {
                            param = '&Is_Last_Month=false';
                        }
                        else if (tableName.toLowerCase().indexOf('month') > -1) {
                            param = '&Is_Last_Month=true';
                        }

                        queryString += param;

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



        // ======== EXPAND / COLLAPSE PORTFOLIO ROWS ============
        var numberOfTherapyRows = 6;
        var numberOfLumpSumRows = 11;
        function registerPortfolioRowsAction() {
            $('table[alt^="portfolio"]').each(function () {
                var type = getPortfolioTableType($(this));

                // for therapy treatments   
                var therapyTreatmentRow = $(this).find('div[alt="therapy_treat"]').closest('tr');
                //therapyTreatmentRow.attr('data-isExpanded', '0');
                therapyTreatmentRow.css('cursor', 'pointer');
                therapyTreatmentRow.click(function () {
                    toggleDetailedRows($(this), type, numberOfTherapyRows);
                });

                // for lump sum intimations
                var lumpSumRow = $(this).find('div[alt="lump_sum_int"]').closest('tr');
                //lumpSumRow.attr('data-isExpanded', '0');
                lumpSumRow.css('cursor', 'pointer');
                lumpSumRow.click(function () {
                    toggleDetailedRows($(this), type, numberOfLumpSumRows);
                });
            });
        }

        function toggleDetailedRows(row, type, numberOfRows) {
            var isExpanded = row.attr('data-isExpanded');
            if (isExpanded == 0) {
                showDetailedRows(row, type, numberOfRows);
            }
            else {
                hideDetailedRows(row, type, numberOfRows);
            }
        }

        function showDetailedRows(row, type, numberOfRows) {
            row.attr('data-isExpanded', '1');
            row.nextAll('tr:lt(' + numberOfRows + ')').show();
            var expandHeight = (row.siblings("tr:eq(3)").height()) * numberOfRows;
            adjustPortfolioContainerHeight(expandHeight, type);


            if (document.documentMode == 7 || document.documentMode == 8) {
                var divHeight = row.closest('div').height();

                var rowType = row.find('td:eq(1) div').attr('alt');
                if (rowType == 'therapy_treat') {
                    row.closest('div').height(divHeight + expandHeight);
                }
                else if (rowType == 'lump_sum_int') {
                    row.closest('div').height(divHeight + expandHeight + 25);
                }
            }

            forceIE8RefreshHeight();
        }

        function hideDetailedRows(row, type, numberOfRows) {
            row.attr('data-isExpanded', '0');
            row.nextAll('tr:lt(' + numberOfRows + ')').hide();
            var collapseHeight = (row.siblings("tr:eq(3)").height()) * numberOfRows * -1;
            adjustPortfolioContainerHeight(collapseHeight, type);

            if (document.documentMode == 7 || document.documentMode == 8) {
                var divHeight = row.closest('div').height();

                var rowType = row.find('td:eq(1) div').attr('alt');
                if (rowType == 'therapy_treat') {
                    row.closest('div').height(divHeight + collapseHeight);
                }
                else if (rowType == 'lump_sum_int') {
                    row.closest('div').height(divHeight + collapseHeight - 25);
                }
            }

            forceIE8RefreshHeight();
        }

        // adjust portfolio container height when expand/collapse
        function adjustPortfolioContainerHeight(ammount, type) {
            var iframe;
            if (document.URL.toLowerCase().indexOf('level2') > 0) {
                iframe = $('iframe#ifReport_Agency', window.parent.document);
            }
            else {
                iframe = $('iframe#ifReport', window.parent.document);
            }

            var iframeHeight = iframe.height() + ammount;
            iframe.height(iframeHeight);
            $('#divViewer').height(iframeHeight);
            $('#rvwReportViewer').height(iframeHeight);
            $('#rvwReportViewer_ct109').closest('td').height(iframeHeight);
        }

        //function hideDetailedRowsByDefault() {
        //    $('table[alt^="portfolio"]').each(function () {
        //        var type = getPortfolioTableType($(this));

        //        var therapyTreatmentRow = $(this).find('div[alt="therapy_treat"]').closest('tr');
        //        var lumpSumRow = $(this).find('div[alt="lump_sum_int"]').closest('tr');
        //        hideDetailedRows(therapyTreatmentRow, type, numberOfTherapyRows);
        //        hideDetailedRows(lumpSumRow, type, numberOfLumpSumRows);
        //    });
        //}

        function hideDetailedRowsByDefault(portfolioTable) {
            var type = getPortfolioTableType(portfolioTable);

            var therapyTreatmentRow = portfolioTable.find('div[alt="therapy_treat"]').closest('tr');
            var lumpSumRow = portfolioTable.find('div[alt="lump_sum_int"]').closest('tr');
            hideDetailedRows(therapyTreatmentRow, type, numberOfTherapyRows);
            hideDetailedRows(lumpSumRow, type, numberOfLumpSumRows);
        }
        // ======== END EXPAND / COLLAPSE PORTFOLIO ROWS ============



        // =========== HELPER =============
        function getPortfolioTableType(portfolioTable) {
            var type = '';
            if (document.URL.toLowerCase().indexOf('level2') > -1 && portfolioTable.attr('alt') != null) {
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

        // fix height issue in IE 8
        function forceIE8RefreshHeight() {
            if (document.documentMode == 7 || document.documentMode == 8) {
                $("table[alt^='portfolio']").each(function () {
                    $(this).closest('td').attr('style', '');
                });
            }
        }

        function fixHeight(iframe, tabType) {
            //var currentTabType = parent.getCurrentTabType();
            var selectedType = "";
            $("table[alt*='portfolio_']").each(function () {
                //var CPRTable = $(this).attr("alt").split('_');
                //var tableType = CPRTable[1];
                var tableType = $(this).attr("alt").replace('portfolio_', '');
                var tableVisibility = $(this).closest('div').attr('style');
                if (!tableVisibility || tableVisibility.indexOf("display: none") < 0) {
                    selectedType = tableType;
                }
            });

            var portfolioTable = $("table[alt*='portfolio_" + selectedType + "']");
            var metricTable = $("table[alt*='metric_table_" + tabType + "']");
            var graph = $("img[alt^='graph_view']").closest('table');
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
            $('#divViewer').height(iframeHeight);
            $('#rvwReportViewer').height(iframeHeight);
            $('#rvwReportViewer_ct109').closest('td').height(iframeHeight);
        }

        function getIframe(type) {
            var iframe;
            if (type !== '') {
                iframe = $('iframe', window.parent.document).filter(function () {
                    return $(this).attr('id').toLowerCase().indexOf(type.toLowerCase()) > -1;
                });
            }
            else {
                iframe = $('iframe#ifReport', window.parent.document);
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
        }

        function hideShowCPRTablesAndMetricLight(portfolioTableName, metricTableName) {
            // hide all
            $("table[alt*='portfolio_week']").closest('div').css('display', 'none');
            $("table[alt*='portfolio_month']").closest('div').css('display', 'none');
            $("table[alt*='metric_table']").each(function () {
                if ($.browser.msie) {
                    $(this).parent('div').css('display', 'none');
                }
                else {
                    $(this).parents('table:eq(0)').css('display', 'none');
                }
            });

            // show default tables
            //var defaultPortfolioTableName = 'portfolio_week_' + type;
            //var defaultMetricTableName = 'metric_table_' + type;
            $("table[alt*='" + portfolioTableName + "']").closest('div').css('display', '');
            if ($.browser.msie) {
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
        // =========== END HELPER ==============

    </script>
</body>
</html>
