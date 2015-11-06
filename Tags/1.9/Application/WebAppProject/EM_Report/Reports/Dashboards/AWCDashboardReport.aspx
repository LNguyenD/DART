<%@  Language="C#" AutoEventWireup="true" CodeBehind="AWCDashboardReport.aspx.cs" Inherits="EM_Report.DashboardReports.AWCDashboardReport" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head011" runat="server">
    <title></title>    
    <!doctype html>
    <meta http-equiv="X-UA-Compatible" content="IE=edge; IE=EmulateIE9; IE=9"/>
    <script src="../../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery-ui-1.11.3.custom.min.js" type="text/javascript"></script>
    <script src="<%=EM_Report.Helpers.FileVersioning.AppendVersion("../../Scripts/iDashboard.js") %>" type="text/javascript"></script>
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
                $('#ifReport_Agency', window.parent.document).contents().find($("table[alt^='projection']")).each(function () {
                    $(this).find('tr:eq(1)').find('td:first').width(0.1);
                });

                $('#ifReport', window.parent.document).contents().find($("table[alt^='projection']")).each(function () {
                    $(this).find('tr:eq(1)').find('td:first').width(0.1);
                });
            }

        });

        // ======= CONCRETE METHODS =========
        function adjustReport_FixHeight(ifHeight) {
            if (document.URL.toLowerCase().indexOf('_level2') >= 0) {                
                $('#ifReport_Agency', window.parent.document).height((ifHeight - 20) + 'px');
            }
            else {
                $('#ifReport', window.parent.document).height(ifHeight + 'px');
            }
        }

        function adjustReport_FixWidth() {
            if ($.browser.msie || $.browser.version < 8 || document.documentMode < 8) {
                $("div[title$='width_30']").css("width", "99.5%");
                $("div[title$='width_100']").css("width", "99.5%");
            }
            else {                
                $("div[title$='width_30']").css("width", "100%");
                $("div[title$='width_100']").css("width", "100%");                
            }
        }

        function adjustReport_HideMetricLight(loading, ifHeight) {
            var strValueParam = getParameterByName("Value").toLowerCase();
            var url = document.URL.toLowerCase();

            if ((url.indexOf('type=employer_size') >= 0 && url.indexOf('_level3') >= 0)
                // condition for TMF Total
                || strValueParam == "tmf"

                //codition for TMF group
                || (url.indexOf('tmf_') >= 0 && url.indexOf('type=group') >= 0 && url.indexOf('_level3') >= 0)

                //codition for EML Total
                || strValueParam == "wcnsw"

                //codition for TMF Police & Fire and Health & Other                
                || (url.indexOf('_level3') >= 0 && strValueParam == "police@@@emergency services" || strValueParam == "health@@@other" || strValueParam == "hotel")
                || (url.indexOf('_level3') >= 0 && url.indexOf('hem_') >= 0 && url.indexOf('type=group') >= 0)) {

                // AWC: hide title
                $("#tbMetric_TrafficLight").parents("tr[vAlign='top']").parents("tr[vAlign='top']").prev().hide();

                if (loading == false) {

                    var metricTableHeight = $("#tbMetric_TrafficLight").parent("td").height();
                    parent.metricTableHeightBeforeHide = metricTableHeight;

                    // hide metric table
                    if ($.browser.msie || isIE11()) {
                        // IE 7 and smaller version
                        $("#tbMetric_TrafficLight").parents("div[alt$='width_100']").parents("tr[vAlign='top']").hide();
                    }
                    else {
                        $("#tbMetric_TrafficLight").parents("table[alt$='width_100']").parents("tr[vAlign='top']").hide();
                    }

                    // AWC: adjust the iframe height
                    $('#ifReport', window.parent.document).height(ifHeight - (metricTableHeight + 30) + 'px');
                }
            }
        }

        function adjustReport_HandleReportLoadingCompleted() {
            if (!eventRegistered) {
                registerDescriptionButtonHover();
                registerPrintButtonClick();
            }

            hideLargeGraph();

            setupGraphView();
            hidePrintingIconOfSmallGraphs();

            // register button events
            registerLargeGraphButtonClick();
        }

        function adjustLayout() {
            if (document.URL.toLowerCase().indexOf("_level2") >= 0) {
                AdjustMetricLightLevel2AWC_Up();
                UnderlineSubTotalAndTotal();
            }
            else if (document.URL.toLowerCase().indexOf("_level3") >= 0) {
                AdjustMetricLightLevel2_Up();                
            }

            // Center all graphs
            $("map").closest("td").attr("align", "center");
            $("map").closest("td").children("div").attr("align", "center");



            if (document.URL.indexOf("#viewlarge") >= 0) {
                var obj = $("img[alt='Raw data']").not(":first").first();
                if (obj.length > 0) {
                    var off = obj.position();
                    parent.window.scrollTo(0, off.top + 110)
                }
            }

            //get href of the metric light raw data icon
            parent.metricLightHref = $("img[alt='Raw data']").first().parent('a').attr('href');

            if ($.browser.msie && (document.documentMode == 7 || document.documentMode == 8)) {
                fixLayoutIE8();
            }
        }

        function doAdditionalWorks() {
            return;
        }

        function getRawDataSource() {
            return "/dashboard/RawData";
        }
        // ======= END CONCRETE METHODS =========

        function AdjustMetricLightLevel2AWC_Up() {
            if (window.location.href.toLowerCase().indexOf('awc') >= 0) {
                $("table[alt*='metric_table']").attr("id", "tbMetric_TrafficLight");
                $("table#tbMetric_TrafficLight :first").parents('table').css("width", "100%");
                $("table#tbMetric_TrafficLight :first").parents('table').parents("div").css("width", "100%");
                $("table[alt*='metric_table']").parent('td').css('height', '0px');
                $("table[alt='width_100']").parent('td').prev('td').prev('td').height(0);
                $("div[alt='width_100']").parent('td').prev('td').prev('td').attr('style', '');
                $("table[alt='width_100']").parent('td').parent('tr').parent('tbody').find('tr > td').first().height(0);
                $("table[alt='width_100']:eq(1)").height(0);
                $("div[alt='width_100']:eq(1)").css('min-height', '0px');
                if ($.browser.msie || isIE11()){
                    $("div[alt='width_100']:eq(0)").hide();
                } else {
                    $("table[alt='width_100']:eq(0)").hide();
                }

                if ($.browser.msie && $.browser.version < 8 && document.documentMode < 8) {
                    $("table[alt*='metric_table']").css("width", "99.5%");
                }
                else {
                    $("table[alt*='metric_table']").css("width", "100%");
                }
                $("table[alt*='metric_table'] td").css('width', 'auto');
                $("table[alt*='metric_table'] td").css('min-width', '0');
                $("table[alt*='metric_table'] td").attr('align', 'center');

                var url = document.URL.toLowerCase();
                var type = getParameterByName("Type");
                var hiddenTableMetricHeight = 0;

                $("table[alt*='metric_table']").each(function () {
                    var tableName = $(this).attr('alt').replace('metric_table_', '').replace('agencies_', '');
                    if (tableName == type) {
                        $(this).show();
                    }
                    else {
                        $(this).hide();
                        hiddenTableMetricHeight += $(this).height();
                    }
                });
                var heightAdjust = url.indexOf("tmf") >= 0 ? 10 : -50;
                var loading = $("#rvwReportViewer_AsyncWait_Wait").is(':visible');
                parent.iframeHeight = $("#ifReport_Agency", parent.window.document).height();

                if (!loading) {
                    $("#ifReport_Agency", parent.window.document).height(parent.iframeHeight - hiddenTableMetricHeight + heightAdjust);
                }

                $("table[alt*='metric_table']").attr("title", '');

                //$("#rvwReportViewer_ctl09").find('table:first').find('table:first').find('tbody > tr:first').hide();
            }
        }

        function fixLayoutIE8() {
            $("img[alt^='print_']").parent().parent().parent().parent().css("width", "80%");
            $("img[alt^='expand_']").parent().parent().parent().css("width", "80%");
            $("img[alt^='raw_data_']").parent().parent().parent().parent().css("width", "80%");
            $("img[alt^='raw_data_']:first").parent().parent().parent().parent().css("width", "1%");
            $("img[alt^='print_']").parent().parent().parent().css("width", "1%");

            if (document.URL.toLowerCase().indexOf('_level3') >= 0
                || document.URL.toLowerCase().indexOf('_level5') >= 0
                || document.URL.toLowerCase().indexOf('_level7') >= 0) {
                $(".breadcrum_01", window.parent.document).css("min-width", "1310px");
                $(".breadcrum_02", window.parent.document).css("min-width", "1290px");
                $(".container", window.parent.document).css("min-width", "1310px");
            }
        }

    </script>
</body>
</html>
