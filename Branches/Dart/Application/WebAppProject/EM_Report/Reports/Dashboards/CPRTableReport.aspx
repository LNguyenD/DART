<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CPRTableReport.aspx.cs" Inherits="EM_Report.Reports.Dashboards.CPRTableReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head011" runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title></title>
    <script src="../../Scripts/jquery-2.1.4.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery-migrate-1.2.1.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery-ui-1.11.3.custom.min.js" type="text/javascript"></script>
    <script src="<%=EM_Report.Helpers.FileVersioning.AppendVersion("../../Scripts/iDashboard.js") %>" type="text/javascript"></script>
    <script src="<%=EM_Report.Helpers.FileVersioning.AppendVersion("../../Scripts/iCPRTableRowColumnManager.js") %>" type="text/javascript"></script>    
    <script src="<%=EM_Report.Helpers.FileVersioning.AppendVersion("../../Scripts/html2canvas.js") %>" type="text/javascript"></script>
    <link href="<%=EM_Report.Helpers.FileVersioning.AppendVersion("../../Css/dashboard.css") %>" rel="stylesheet" type="text/css" />
    <script src="<%=EM_Report.Helpers.FileVersioning.AppendVersion("../../Scripts/html2canvas.js") %>" type="text/javascript"></script>
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

        // CONSOLE.LOG() cause some errors on IE when not open IE DEVELOPER TOOL

        var eventRegistered = false;

        $(document).ready(function () {
            // detect report lost session problem
            var htmlContent = $("div[id='divViewer']").html().toLowerCase();
            if (htmlContent.indexOf('attempt to connect to the report server failed') >= 0 || htmlContent.indexOf('object moved to') >= 0) {
                var returnUrl = document.referrer;
                parent.window.location = parent.window.g_baseUrl + '/account/login?returnUrl=' + encodeURIComponent(returnUrl);
            }            

        });
        
        Sys.Application.add_load(function () {
            var uSess = '<%=EM_Report.Helpers.Base.LoginSession.External_GroupName %>';

            var currentType = parent.getCurrentType();
            $('#ifTableReport_advance_' + currentType, window.parent.document).contents().find('img').closest('a').each(function () {
                if ($(this).attr('href') != "javascript:void(0)")
                    $(this).attr('href', $(this).attr('href').replace('javascript:void(', ''));
            });

            if (uSess.toLowerCase() == 'wow external' && document.URL.toLowerCase().indexOf('type=group') >= 1) {
                $("#divViewer").html('');
            }
            else {
                $find("rvwReportViewer").add_propertyChanged(viewerPropertyChanged);
            }            
        });

        function viewerPropertyChanged(sender, e) {
            if (e.get_propertyName() == "isLoading") {

                adjustReport();                                

                //Remove all title attribute
                RemoveTitle();

                RemoveMetricLightUnnecessary();

                if (document.URL.toLowerCase().indexOf("viewinfo") >= 0)
                    loadTabs();

                if ($.browser.msie || isIE11()) {
                    var getfrm = $("table[alt*='portfolio_detail']").attr('style');

                    if (getfrm != null && getfrm != undefined) {
                        var ifwidth = $('#ifReportCover_week', window.parent.document).width() - 69;
                        $("table[alt*='portfolio_detail']").removeAttr('style');
                        $("table[alt*='portfolio_detail']").css('margin-left', '1px');
                        $("table[alt*='portfolio_detail']").css('width', '99.5%');
                        $("table[alt*='portfolio_detail']").closest('div').css('width', ifwidth + 'px');
                    }
                }
            }            

            var grpName = $('#grpName', window.parent.document).val();
            if (document.URL.toLowerCase().indexOf('wow') >= 1 && grpName == 'WOWExternal') {
                $("table[alt*='portfolio_week_group']").find('tr:eq(2)').hide();
                $("table[alt*='portfolio_advance_group']").find('tr:eq(2)').hide();
            }            
        }        

        function RemoveStyleOfTab() {
            var currentTabType = parent.getCurrentTabType().replace('_', '');

            // Not allow user switch another tab while loading
            if (document.URL.toLowerCase().indexOf('tmf') >= 1) {
                if (currentTabType == "group")
                    $("#tab_agency", window.parent.document).removeAttr('style');
                else {

                    $("#tab_group", window.parent.document).removeAttr('style');
                }
            }
            else if (document.URL.toLowerCase().indexOf('hem') >= 1) {
                if (currentTabType == "group") {
                    $("#tab_portfolio", window.parent.document).removeAttr('style');
                    $("#tab_broker", window.parent.document).removeAttr('style');
                }
                else if (currentTabType == "portfolio") {
                    $("#tab_group", window.parent.document).removeAttr('style');
                    $("#tab_broker", window.parent.document).removeAttr('style');
                }
                else {
                    $("#tab_group", window.parent.document).removeAttr('style');
                    $("#tab_portfolio", window.parent.document).removeAttr('style');
                }
            }
            else if (document.URL.toLowerCase().indexOf('eml') >= 1) {
                if (currentTabType == "group") {
                    $("#tab_employer_size", window.parent.document).removeAttr('style');
                    $("#tab_account_manager", window.parent.document).removeAttr('style');
                    $("#tab_broker", window.parent.document).removeAttr('style');
                }
                if (currentTabType == "employersize") {
                    $("#tab_group", window.parent.document).removeAttr('style');
                    $("#tab_account_manager", window.parent.document).removeAttr('style');
                    $("#tab_broker", window.parent.document).removeAttr('style');
                }
                else if (currentTabType == "accountmanager") {
                    $("#tab_group", window.parent.document).removeAttr('style');
                    $("#tab_employer_size", window.parent.document).removeAttr('style');
                    $("#tab_broker", window.parent.document).removeAttr('style');
                }
                else {
                    $("#tab_group", window.parent.document).removeAttr('style');
                    $("#tab_employer_size", window.parent.document).removeAttr('style');
                    $("#tab_account_manager", window.parent.document).removeAttr('style');
                }
            }
            else {
                if (currentTabType == "group") {                    
                    $("#tab_portfolio", window.parent.document).removeAttr('style');
                    $("#tab_account_manager", window.parent.document).removeAttr('style');
                }
                if (currentTabType == "portfolio") {
                    $("#tab_group", window.parent.document).removeAttr('style');
                    $("#tab_account_manager", window.parent.document).removeAttr('style');
                }
                else {
                    $("#tab_group", window.parent.document).removeAttr('style');
                    $("#tab_portfolio", window.parent.document).removeAttr('style');
                }
            }
        }

        function PreventLoadingTabs(status) {

            var currentTabType = parent.getCurrentTabType().replace('_', '');                       

            // Not allow user switch another tab while loading
            if (document.URL.toLowerCase().indexOf('tmf') >= 1) {
                if (currentTabType == "group")
                    $("#tab_agency", window.parent.document).css('pointer-events', status);
                else 
                    $("#tab_group", window.parent.document).css('pointer-events', status);                
            }
            else if (document.URL.toLowerCase().indexOf('hem') >= 1) {
                if (currentTabType == "group") {
                    $("#tab_portfolio", window.parent.document).css('pointer-events', status);
                    $("#tab_broker", window.parent.document).css('pointer-events', status);
                }
                else if (currentTabType == "portfolio") {
                    $("#tab_group", window.parent.document).css('pointer-events', status);
                    $("#tab_broker", window.parent.document).css('pointer-events', status);
                }
                else {
                    $("#tab_group", window.parent.document).css('pointer-events', status);
                    $("#tab_portfolio", window.parent.document).css('pointer-events', status);
                }
            }
            else if (document.URL.toLowerCase().indexOf('eml') >= 1) {
                if (currentTabType == "group") {
                    $("#tab_employer_size", window.parent.document).css('pointer-events', status);
                    $("#tab_account_manager", window.parent.document).css('pointer-events', status);
                    $("#tab_broker", window.parent.document).css('pointer-events', status);
                }
                if (currentTabType == "employersize") {
                    $("#tab_group", window.parent.document).css('pointer-events', status);
                    $("#tab_account_manager", window.parent.document).css('pointer-events', status);
                    $("#tab_broker", window.parent.document).css('pointer-events', status);
                }
                else if (currentTabType == "accountmanager") {
                    $("#tab_group", window.parent.document).css('pointer-events', status);
                    $("#tab_employer_size", window.parent.document).css('pointer-events', status);
                    $("#tab_broker", window.parent.document).css('pointer-events', status);
                }
                else {
                    $("#tab_group", window.parent.document).css('pointer-events', status);
                    $("#tab_employer_size", window.parent.document).css('pointer-events', status);
                    $("#tab_account_manager", window.parent.document).css('pointer-events', status);
                }
            }
            else {
                if (currentTabType == "group") {
                    $("#tab_portfolio", window.parent.document).css('pointer-events', status);
                    $("#tab_account_manager", window.parent.document).css('pointer-events', status);                    
                }
                if (currentTabType == "portfolio") {
                    $("#tab_group", window.parent.document).css('pointer-events', status);
                    $("#tab_account_manager", window.parent.document).css('pointer-events', status);
                }
                else {
                    $("#tab_group", window.parent.document).css('pointer-events', status);
                    $("#tab_portfolio", window.parent.document).css('pointer-events', status);
                }
            }
        }

        function RemoveMetricLightUnnecessary() {
            $("table[alt^='portfolio']").each(function () {
                
                $(this).find('img').parent('div').css('display', 'none');

            });
        }

        function getRawDataSource() {
            return "/Report/ReportRawData";
        }

        // ========== ADJUST REPORT =============

        function adjustReport() {
            var viewer = document.getElementById("<%=rvwReportViewer.ClientID %>");
            var tbOwner = $("div[id*='VisibleReportContentrvwReportViewer'] table:first");
            var portfolioTable = $("table[alt*='portfolio']");

            if (!$.browser.msie) {              
                $("table[alt^='portfolio'] > tbody >tr:eq(1)").find('td:first').width(0.1);
            }

            // get height of report viewer content
            var ifHeight = tbOwner.height();

            // change report loading panel                
            $("div[id*='rvwReportViewer_AsyncWait_Wait']").html("<img src='../../images/loading.gif' complete='complete' />");
            $("div[id*='rvwReportViewer_AsyncWait_Wait']").css({ "border": "0", "background-color": "" });

            var loading = $("#rvwReportViewer_AsyncWait_Wait").is(':visible');
            if (loading) {
                // supply a additional number for loading icon area
                ifHeight = ifHeight + 78;
                RemoveStyleOfTab();
                PreventLoadingTabs("none");

                // Prevent chosing drop down list when loading advance option report
                $("#CPRViewType .sbSelector", window.parent.document).click(function (event) {
                    $("#CPRViewType .sbOptions", window.parent.document).hide();
                });
            }            

            $('#divViewer').height(ifHeight + 'px');
            $("td[id*='oReportCell'] > div").css("width", "100%");
            $("td[id*='oReportCell'] > div > div").css("width", "100%");            
            $("td[id*='oReportCell']").closest("table").css("width", "100%");
            $("td[id*='oReportCell']").find("table").css("width", "100%");
           
            portfolioTable.parent().parent().parent().attr("align", "left");
            portfolioTable.css("width", "99.99%");


            if (ifHeight > 78) {
                var iframe = getIframe();
                adjustPortfolioReportSize(iframe, portfolioTable);
                adjustReportLayout(iframe, portfolioTable);
                ShowActionButtons();                

                if (!eventRegistered) {
                    registerDescriptionButtonHover();
                    registerPrintButtonClick();
                    registerRawDataButtons();
                    registerPortfolioRowsAction(iframe);
                    hideDetailedRowsByDefault(portfolioTable, iframe);
                    fixPortfolioHeader();
                    fixMetricLight();
                    fixCells(portfolioTable);
                    eventRegistered = true;                   
                }

                fixImages(portfolioTable);

                if (portfolioTable.attr('alt').indexOf('detail') > -1) {
                    adjustDetailView();
                    RemoveTotalHeaderDetail();
                }

                // hide show CPR table
                var currentTabType = parent.getCurrentTabType();
                var defaultPortfolioTableName;
                defaultPortfolioTableName = 'portfolio_week_' + currentTabType;

                fixHeight(iframe, defaultPortfolioTableName);
                
                RemoveStyleOfTab();
                PreventLoadingTabs("auto");

                // Enable function chosing drop down list when the advance option loading completely
                $("#CPRViewType .sbSelector", window.parent.document).click(function (event) {
                    $("#CPRViewType .sbOptions", window.parent.document).show();
                });
            }
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

        function RemoveTotalHeaderDetail() {
            $('table[alt^="portfolio_detail_"]').each(function () {

                numberOfColumns = $(this).find('tr:eq(4) > td').length

                for (var i = 2; i < numberOfColumns; i++) {
                    var cell = $(this).find('tr:eq(4) > td:eq(' + i + ')');
                    var cellValue = cell.children('div');

                    var cellText = cellValue.text().replace("@@@", " & ");
                    cellText = cellText.replace('_TOTAL', '');

                    cellValue.text(cellText);
                }

            });
        }

        function loadTabs() {
            parent.DataContentL2Tab1 = $('iframe:eq(0)', window.parent.document).contents()
                    .find("table[alt*='portfolio']").html();
            parent.DataContentL2Tab2 = $('iframe:eq(1)', window.parent.document).contents()
                .find("table[alt*='portfolio']").html();
            parent.DataContentL2Tab3 = $('iframe:eq(2)', window.parent.document).contents()
                .find("table[alt*='portfolio']").html();

            if (parent.systemName == "TMF") {
                //complete tab 1
                if (parent.DataContentL2Tab1 != null && parent.loadedL2Tab1 == false) {
                    parent.Load_Second_Tab();
                    parent.loadedL2Tab1 = true;
                   
                }
                    //complete tab 2
                else if (parent.DataContentL2Tab1 != null && parent.DataContentL2Tab2 != null) {
                   
                    parent.loadedL2EndTab++;
                    if (parent.loadedL2EndTab == 2) {
                   
                        parent.canTabClick = true;
                        if (document.URL.indexOf('Type=group') >= 0
                            && $('#ifReportCover_Group', window.parent.document).css("height") == "0px") {
                            //$('#ifReportCover_Group', window.parent.document).css("display", "none");
                        }
                    }
                }
            }
            else if (parent.systemName == "EML" || parent.systemName == "HEM") {
                //complete tab 1
                if (parent.DataContentL2Tab1 != null && parent.loadedL2Tab1 == false) {
                    parent.Load_Second_Tab();
                    parent.loadedL2Tab1 = true;
                    
                }
                    //complete tab 3
                else if (parent.DataContentL2Tab1 != null && parent.DataContentL2Tab2 != null
                            && parent.DataContentL2Tab3 != null) {
                    
                    parent.loadedL2EndTab++;
                    if (parent.loadedL2EndTab == 2) {
                    
                        parent.canTabClick = true;
                        if (document.URL.indexOf('Type=account_manager') >= 0
                                && $('#ifReportCover_AccountManager', window.parent.document).css("height") == "0px") {
                            //$('#ifReportCover_AccountManager', window.parent.document).css("display", "none");
                        }
                    }
                }
                    //complete tab 2
                else if (parent.DataContentL2Tab1 != null) {
                    
                    parent.loadedL2SecondTab++;
                    if (parent.loadedL2SecondTab == 2) {
                    
                        if (window.location.href.toLowerCase().indexOf('system=hem') < 0) {
                            parent.Load_Third_Tab();
                        }

                        parent.canTabClick = true;

                        if (document.URL.indexOf('Type=group') >= 0
                        && $('#ifReportCover_Group', window.parent.document).css("height") == "0px") {

                            //$('#ifReportCover_Group', window.parent.document).css("display", "none");

                            //if ($(parent.location).attr('href').indexOf('Type=employer_size') >= 0
                            //    || $(parent.location).attr('href').indexOf('Type=portfolio') >= 0) {
                            //    //$('#ifReportCover_Agency', window.parent.document).css("height", $('#ifReport_Agency', window.parent.document).height());
                            //}
                            //else if ($(parent.location).attr('href').indexOf('Type=account_manager') >= 0) {
                            //    //$('#ifReportCover_AccountManager', window.parent.document).css("height", $('#ifReport_AccountManager', window.parent.document).height());
                            //}
                        }
                    }
                }
            }
        }

        function fixCells(portfolioTable) {
            portfolioTable.children('tbody').children('tr:gt(2)').find('a').each(function () {
                var linkContent = $(this).html();

                if (linkContent == "-") {
                    $(this).mouseover(function () {
                        $(this).css('cursor', 'default');
                    });
                    $(this).click(function (event) {
                        event.preventDefault();
                    });
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

        function fixPortfolioHeader() {
            if (document.URL.toLowerCase().indexOf('summary') > -1) {
                $('table[alt^="portfolio"]').each(function () {

                    $(this).find('tr:first').children('td').css({ 'min-width': '' });

                    // header width
                    for (var i = 3; i < $(this).find('tr:eq(0) > td').length; i++) {
                        var cell = $(this).find('tr:eq(0) > td:eq(' + i + ')');
                        cell.width(100);
                    }

                    // header hover
                    var numberOfColumns = $(this).find('tr:eq(1) > td').length;
                    var headerHeight = $(this).find('tr:eq(1) > td:eq(0)').height();

                    for (var i = 2; i < numberOfColumns; i++) {
                        var cell = $(this).find('tr:eq(1) > td:eq(' + i + ')');
                        var cellValue = cell.children('div').children('a');

                        //remove special character
                        var cellText = cellValue.text().replace("@@@", " & ");

                        UnderlineSubTotalAndTotal();

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
                                cell.height(headerHeight + 10);

                                div.addClass('vertical-align');
                            }

                            //set double underline for total column
                            if (i == numberOfColumns - 1) {
                                if (!$.browser.msie && !isIE11()) {
                                    div.css({ 'border-bottom': 'double 3pt', 'display': 'table', 'line-height': '20px', 'margin': 'auto', 'transform': 'translateY(-50%)', 'top': '50%' });
                                }
                                else {
                                    if (cellValue.height() >= 20) {
                                        div.css({ 'border-bottom': 'double 3pt', 'display': 'inline', 'position': 'relative', 'line-height': '20px', 'top': '50%' });
                                    } else {
                                        div.css({ 'border-bottom': 'double 3pt', 'display': 'table', 'line-height': '20px', 'margin': 'auto', 'transform': 'translateY(-50%)', 'top': '50%' });
                                    }
                                }
                                //div.css({ 'border-bottom': 'double 3pt', 'display': 'table', 'line-height': '20px', 'margin': 'auto', 'transform': 'translateY(-50%)', 'top': '50%' });
                            }

                            cell.children('div').css({ 'height': '100%' });
                            cellValue.css({ 'display': 'block', 'height': '100%' });
                            cellValue.wrapInner(div);
                        }
                    }
                });
            }
        }

        function fixPortfolioHeaderHeight() {
            $('table[alt^="portfolio"]').each(function () {
                var numberOfColumns = $(this).find('tr:eq(1) > td').length;
                var headerHeight = $(this).find('tr:eq(1) > td:eq(0)').height();

                for (var i = 0; i < numberOfColumns; i++) {
                    var cell = $(this).find('tr:eq(1) > td:eq(' + i + ')');
                    if (document.documentMode != 7 && document.documentMode != 8) {
                        cell.height(headerHeight + 10);
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

        function fixHeight(iframe, tabType) {
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
            var iframeHeight = portfolioTable.height() + 150;
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

        function adjustReportLayout(iframe, portfolioTable) {
            portfolioTable.parents('table:lt(3)').css('min-width', '');          
            // graph
            var graphImage = $("img[alt^='graph_view']");
            if (graphImage.length > 0) {
                var graphContainer;
                if ($.browser.msie || parent.isIE11()) {
                    graphImage.parents('table:eq(1)').find('tr:eq(0)').children('td').css({ 'width': '', 'min-width': '' });
                    graphContainer = $("img[alt^='graph_view']").parents('table:eq(0)').parents('td:eq(0)');
                    graphImage.parents('div:lt(2)').css('width', '');
                }
                else {
                    graphImage.parents('table:eq(2)').find('tr:eq(0)').children('td').css({ 'width': '', 'min-width': '' });
                    graphContainer = $("img[alt^='graph_view']").parents('table:eq(1)').parent('td');
                    graphImage.parent().css('width', '');
                }

                graphContainer.siblings('td:gt(0)').css('display', 'none');
                graphContainer[0].colSpan = 10;
                graphImage.parent().attr('align', 'center');
                graphImage.parent().parent().attr('align', 'center');
                //graphImage.parent().width(graphImage.width());
                //graphImage.parent().height(graphImage.height());
            }

            var iframeWidth = $('.portfolioParameterSection', window.parent.document).width();
            // adjust iframe for graph.

            if ($.browser.msie || parent.isIE11()) {
                //$("div[alt^='cpr_graph_view']").css({ 'width': '' });
                //$("div[alt^='cpr_graph_view']").css({ 'width': '96%' });
                $("div[alt^='cpr_graph_view']").width(iframeWidth - 5);
            }
            else {
                //$("table[alt^='cpr_graph_view']").css({ 'width': '' });
                //$("table[alt^='cpr_graph_view']").css({ 'width': '97.2%' });
                $("table[alt^='cpr_graph_view']").width(iframeWidth);
            }            

        }

        function adjustPortfolioReportSize(iframe, portfolioTable) {
            adjustPortfolioReportHeight(iframe, portfolioTable);
            adjustPortfolioReportWidth(iframe, portfolioTable);
        }

        function adjustPortfolioReportHeight(iframe, portfolioTable) {
            portfolioTable.closest('tr').children('td:eq(0)').css('height', '');

            var graphHeight = $('img[alt^="graph_view"]').closest('table').height();
            var graphTitleHeight = $('[alt^="title_graph_view"]').closest('table').height();
            var buttonHeight = $('[alt^="portfolio_detail_close"]').closest('div').height();
            var contentHeight = portfolioTable.height() + graphTitleHeight + graphHeight + buttonHeight;

            if ($.browser.msie && $.browser.version.substr(0, 1) == 9 && document.documentMode != 7) {
                iframe.height(contentHeight + 75);
            }
            else {
                iframe.height(contentHeight + 85);
            }

            // remove redundant vertical scrollbar
            if ($.browser.msie) {
                portfolioTable.parents('div:lt(3)').css('min-height', '');
            }
            else {
                portfolioTable.parents('table:lt(3)').height(portfolioTable.height());
            }

            var iframeHeight = iframe.height();
            if ($.browser.version.substr(0, 1) == 7 && document.documentMode == 8) { // browser mode IE 9 Compat, Doc 8
                iframe.contents().find('#divViewer').height(iframeHeight);
                iframe.contents().find('#rvwReportViewer').height(iframeHeight);
                iframe.contents().find('#rvwReportViewer_ct109').closest('td').height(iframeHeight);
            }
            else {
                iframe.contents().find('#divViewer').height(iframeHeight);
                iframe.contents().find('#rvwReportViewer').height(iframeHeight);
                iframe.contents().find('#rvwReportViewer_ct109').closest('td').height(iframeHeight);
            }
        }

        function adjustPortfolioReportWidth(iframe, portfolioTable) {
            var iframeWidth;            

            if (getCurrentViewType() == 'advance_option' && $('#cprAdvanceSearch', window.parent.document).is(':visible')) {
                iframeWidth = $('.portfolioParameterSection', window.parent.document).width();
            }
            else {
                iframeWidth = iframe.parent().parent().width() - 50;
            }

            portfolioTable.find('tr:eq(1)').find('td:eq(1)').css('min-width', '200px');

            var portfolioTableWidth = iframeWidth - 2;

            // make long table horizontally scrollable
            portfolioTable.parent('td').removeAttr('style');

            portfolioTable.each(function () {
                var tableContainer = $(this).closest('td');

                var div = $('<div></div>');
                div.wrapInner($(this));
                tableContainer.html(div);

                //$(this).closest('div').css({ 'width': iframeWidth + 'px', 'overflow': 'auto' });
                if (document.documentMode == 7 || document.documentMode == 8 || document.documentMode == 9) {
                    $(this).closest('div').css({ 'width': iframeWidth + 'px', 'overflow': 'auto', 'height': '100%' });
                }
                else {
                    $(this).closest('div').css({ 'width': iframeWidth + 'px', 'overflow': 'auto' });
                }
                $(this).width(portfolioTableWidth);                

                // remove all unnecessary tr under dashboard                                        
                $(this).parents("table:first").find('> tbody > tr').not("tr[vAlign='top']").remove('tr');

                var graph = $("td[alt^='title_graph_view']");
                graph.closest("tr").css('height', '60px');
                graph.closest("td").css('vertical-align', 'bottom');

            });
            iframe.width(iframeWidth);
            iframe.parent().attr('align', 'center');

            // remove unnecessary long horizontal scrollbar 
            if ($.browser.msie || isIE11()) {
                iframe.contents().find('#VisibleReportContentrvwReportViewer_ctl09').width(portfolioTableWidth);
                iframe.contents().find('#VisibleReportContentrvwReportViewer_ctl10').width(portfolioTableWidth);

                portfolioTable.width(portfolioTableWidth); // tricky workaround that reassign table width to correct table width
                // not happens in IE9 document mode
                portfolioTable.parents('div:lt(3)').css('min-width', iframeWidth).width(iframeWidth);

                //fix the table left border
                portfolioTable.css('margin-left', '1px');                
                portfolioTable.closest('tr').children("td:not(:first)").remove('td');

                //console.log(portfolioTable.closest('table:eq(1)').attr('class'));
                
            }
            else {
                //portfolioTable.parents('table:lt(2)').css('min-width', portfolioTableWidth).width(portfolioTableWidth);                
            }


            iframe.contents().find('#rvwReportViewer_ctl09').css('overflow', '');            

            // fixed column width
            //portfolioTable.css('table-layout', 'fixed');
            fixTotalColumnWidth(portfolioTable, 90);
        }

        function adjustDetailView() {
            // Adjust Close icon in CPR detail view
            $("img[alt*='portfolio_detail_close']").attr({ 'src': "../../images/ico_close.png" });
            $("img[alt*='portfolio_detail_close']").css({ 'width': '83%', 'height': '83%' });
            $("img[alt*='portfolio_detail_close']").closest('div').css('position', 'absolute');
            $("img[alt*='portfolio_detail_close']").closest('div').css({ 'right': '4px', 'top': '0' });
            $("img[alt*='portfolio_detail_close']").css('cursor', 'pointer');

            
            // register click event on Close icon in CPR detail view
            $("img[alt*='portfolio_detail_close']").click(function (event) {
                if (document.URL.toLowerCase().indexOf('level2') > -1) {
                    var portfolioTable = $("table[alt*='portfolio']");
                    var type = getPortfolioTableType(portfolioTable).replace('detail_', '');
                    var viewType = getCurrentViewType();
                    var currentTabType = parent.getCurrentTabType().replace('_', '');
                    var currentType = parent.getCurrentType();

                    if (viewType == 'advance_option') {

                        if (document.URL.toLowerCase().indexOf('wow') >= 1) {

                            // show CPR summary view
                            $('#ifTableReport_advance_' + currentType, window.parent.document).show();

                            // hide CPR detail view
                            $('#ifTableReport_detail_' + currentType, window.parent.document).hide();
                        }
                        else {

                            // show CPR summary view
                            $('#ifTableReport_advance_' + type, window.parent.document).show();

                            // hide CPR detail view
                            $('#cprAdvanceSearch #ifTableReport_detail_' + type, window.parent.document).hide();
                        }
                        // show CPR ViewType dropdown
                        $("#CPRViewType", window.parent.document).show();
                        // show CPR summary view
                        $('iframe#ifReport_Agency', window.parent.document).show();
                    }
                    else {

                        // show CPR summary view
                        $('iframe#ifReport_Agency', window.parent.document).show();
                        
                        try {
                            // show CPR ViewType dropdown
                            $("#CPRViewType", window.parent.document).show();

                            $('#ifTableReport_detail_' + currentType, window.parent.document).remove();
                            $('#ifTableReport_detail_' + currentTabType, window.parent.document).remove();
                        } catch (e) {

                        }                       
                    }
                }
                else {

                    var viewType = getCurrentViewType();
                    var currentType = parent.getCurrentType();
                    if (viewType == 'advance_option') {
                        if (document.URL.toLowerCase().indexOf('wow') >= 1) {                           

                            // show CPR summary view
                            $('#ifTableReport_advance_' + currentType, window.parent.document).show();

                            // hide CPR detail view
                            $('#ifTableReport_detail_' + currentType, window.parent.document).hide();

                            $('#ifTableReport_detail_week', window.parent.document).hide();
                            $('#ifReport_week', window.parent.document).show();
                        }
                        else {
                            var portfolioTable = $("table[alt*='portfolio']");
                            var type = getPortfolioTableType(portfolioTable).replace('detail_', '');

                            // show CPR summary view
                            $('#ifTableReport_advance_' + type, window.parent.document).show();
                            // hide CPR detail view
                            $('#ifTableReport_detail_' + type, window.parent.document).hide();                            
                        }
                        
                    }
                    else {
                        // show CPR summary view
                        $('iframe#ifReport_' + viewType, window.parent.document).show();
                        // hide CPR detail view
                        $('#ifTableReport_detail_' + viewType, window.parent.document).hide();                        
                    }

                    // show CPR ViewType dropdown
                    $("#CPRViewType", window.parent.document).show();
                }
            });
                        
        }

        function fixTotalColumnWidth(portfolioTable, width) {
            for (var i = 3; i < portfolioTable.children('tbody').children('tr:eq(0)').children('td').length; i++) {
                var cell = portfolioTable.children('tbody').children('tr:eq(0)').children('td:eq(' + i + ')');
                cell.width(width);
            }
        }

        // ================= END ADJUST REPORT ====================

        // =============== HELPERS ==============

        function openCPRDetail(param) {
            var currentType = parent.getCurrentType();            

            // hide CPR summary view
            $('#ifTableReport_advance_' + currentType, window.parent.document).hide();

            // find CPR detail view
            var $cprDetailView = $('#portfolioReportSection iframe[id*=ifTableReport_detail_' + currentType + ']', window.parent.document);
            var reportUrl = parent.g_baseUrl + '/Reports/Dashboards/CPRTableReport.aspx?' + param;

            if ($cprDetailView.length > 0) {
                // change CPR detail frame Url
                $cprDetailView.attr("src", reportUrl);

                // show CPR detail view
                $cprDetailView.show();
            }
            else {
                // build CPR detail frame Html content
                var reportContent = $('<iframe id="ifTableReport_detail_' + currentType + '" src="' + reportUrl + '" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>');

                // append the new CPR detail frame to cover
                $('#ifSearchCover_' + currentType, window.parent.document).append(reportContent);
            }

            // hide CPR dropdown options
            $("#CPRViewType", window.parent.document).hide();


        }

        function getPortfolioTableType(portfolioTable) {
            var type = '';
            if (portfolioTable.attr('alt') != null) {
                type = portfolioTable.attr('alt').replace('portfolio_week_', '').replace('portfolio_month_', '').replace('portfolio_advance_', '').replace('portfolio_detail_', '');
            }

            return type;
        }

        function getCurrentViewType() {
            var viewType = $('#cboCPRViewType', window.parent.document).find(":selected").val();
            return viewType;
        }

        function getIframe() {
            var type;

            var portfolioTable = $("table[alt*='portfolio']");
            var portfolioAlt = portfolioTable.attr('alt');
            if (portfolioAlt.toLowerCase().indexOf('detail') > -1) {

                if (document.URL.toLowerCase().indexOf('level2') > -1) {
                    type = 'detail_' + getPortfolioTableType(portfolioTable);
                }
                else {
                    var viewType = getCurrentViewType();
                    if (viewType == 'advance_option') {
                        type = 'detail_' + getPortfolioTableType(portfolioTable);
                    }
                    else {
                        type = 'detail_' + viewType;
                    }
                }
            }
            else {
                if (document.URL.toLowerCase().indexOf('level2') > -1) {
                    type = getCurrentViewType();
                    if (type == 'advance_option')
                        type = 'advance';

                    type += '_' + getPortfolioTableType(portfolioTable);
                }
                else {
                    type = getCurrentViewType();
                    if (type == 'advance_option') {
                        type = 'advance';
                        type += '_' + getPortfolioTableType(portfolioTable);
                    }
                }
            }

            var iframe = $('iframe', window.parent.document).filter(function () {
                return $(this).attr('id').toLowerCase().indexOf(type.toLowerCase()) > -1;
            });

            return iframe;
        }

        function isIE11() {
            if (!!navigator.userAgent.match(/Trident\/7\./))
                return true;

            return false;
        }

        // =============== END HELPERS ============

        function RemoveTitle() {
            // remove heading tooltips
            $("div[title='[image_header_tablix]']").attr("title", '');
            $("div[alt='[image_header_tablix]']").removeAttr("alt");
            $("div[title^='DetailedPortfolio_']").attr("title", '');
            $("td[title='[image_header_tablix]']").attr("title", '');
            $("td[alt='[image_header_tablix]']").removeAttr("alt");
            $('table[alt*="portfolio"]').attr("title", '');
            $('table[alt*="portfolio"] td[alt*="therapy"]').attr("title", '');
            $('table[alt*="portfolio"] td[alt*="lump"]').attr("title", '');
            $("div[title*='therapy_treat']").attr("title", '');
            $("div[title*='lump_sum_int']").attr("title", '');
            $("div[title*='TotalDetailedPortfolio']").attr("title", '');
            $("img[alt*='portfolio_detail_close']").attr("title", 'Close');
            $("[alt*=graph_view]").attr("title", '');

            $("img[alt*='print_graph_']").attr("title", "Print graph");
            $("img[alt*='raw_data']").attr("title", "Raw data");
        }


        

    </script>
</body>
</html>
