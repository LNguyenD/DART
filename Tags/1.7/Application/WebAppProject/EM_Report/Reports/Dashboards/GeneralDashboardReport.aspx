<%@  Language="C#" AutoEventWireup="true" CodeBehind="GeneralDashboardReport.aspx.cs" Inherits="EM_Report.DashboardReports.GeneralDashboardReport" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head011" runat="server">
    <title></title>
    <script src="../../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery-ui-1.11.3.custom.min.js" type="text/javascript"></script>    
    <script src="<%=EM_Report.Helpers.FileVersioning.AppendVersion("../../Scripts/iDashboard.js") %>" type="text/javascript"></script>    
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
        });       
        
        // ======= CONCRETE METHODS =========
        function adjustReport_FixHeight(ifHeight) {
            $('#ifReport', window.parent.document).height(ifHeight + 'px');
        }

        function adjustReport_FixWidth() {
            $("div[title*='width_30']").css("width", "99.5%");
            $("div[title*='width_100']").css("width", "100%");
        }

        function adjustReport_HideMetricLight() {
            return;
        }

        function adjustReport_HandleReportLoadingCompleted() {
            if (!eventRegistered) {
                registerDescriptionButtonHover();
                registerPrintButtonClick();
            }

            if (window.location.href.toLowerCase().indexOf('level1') < 0) {
                hideLargeGraph();
            }

            if (window.location.href.toLowerCase().indexOf('level0') > -1) {
                $("img[alt*='print_graph_']").hide();
            }
        }

        function adjustLayout() {
            if (document.URL.toLowerCase().indexOf("level0") >= 0) {
                AdjustMetricLightLevel0();
            }
            else if (document.URL.toLowerCase().indexOf("_level1") >= 0) {
                AdjustMetricLightLevel1();
				UnderlineSubTotalAndTotal();
            }

            // Center all graphs
            $("map").closest("td").attr("align", "center");
            $("map").closest("td").children("div").attr("align", "center");

            if ($.browser.msie && $.browser.version < 9 && document.documentMode < 9) {
                fixLayoutIE8();
            }
        }

        function doAdditionalWorks() {
            initGraphTitleTooltip();
        }

        // ======= END CONCRETE METHODS =========

        function fixLayoutIE8() {           
            if (document.URL.toLowerCase().indexOf('_level1') >= 0) {
                $(".breadcrum_02", window.parent.document).css("min-width", "1270px");
                $(".container", window.parent.document).css("min-width", "1290px");
            }
            else {
                $(".breadcrum_01", window.parent.document).css("min-width", "1270px");
                $(".breadcrum_02", window.parent.document).css("min-width", "1250px");
                $(".container", window.parent.document).css("min-width", "1270px");
            }

            //fix AWC layout in IE8 compatibility view            
            if ($.browser.version < 8 && (window.location.href.toLowerCase().indexOf('awc') > 0 || window.location.href.toLowerCase().indexOf('level0') > 0)) {
                $("img[alt^='print_']").parent().parent().parent().parent().css("width", "80%");
                $("img[alt^='expand_']").parent().parent().parent().css("width", "80%");
                $("img[alt^='raw_data_']").parent().parent().parent().parent().css("width", "80%");
                $("img[alt^='raw_data_']:first").parent().parent().parent().parent().css("width", "1%");
                $("img[alt^='print_']").parent().parent().parent().css("width", "1%");
            }           
        }

        function initGraphTitleTooltip() {
            if (document.URL.toLowerCase().indexOf('level0') >= 0) {
                $("td[alt^='title_graph_']").attr('title', 'Click for more details');
            }
        }
    </script>
</body>
</html>