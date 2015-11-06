<%@  Language="C#" AutoEventWireup="true" CodeBehind="RTWDashboardReport.aspx.cs" Inherits="EM_Report.DashboardReports.RTWDashboardReport" %>
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
        });

        // ======= CONCRETE METHODS =========
        function adjustReport_FixHeight(ifHeight) {
            if (document.URL.toLowerCase().indexOf('_level2') >= 0) {
                if (document.URL.indexOf('Type=group') >= 0) {
                    $('#ifReport_Group', window.parent.document).height(ifHeight + 'px');
                }
                else if (document.URL.indexOf('Type=account_manager') >= 0) {
                    $('#ifReport_AccountManager', window.parent.document).height(ifHeight + 'px');
                }
                else {
                    $('#ifReport_Agency', window.parent.document).height(ifHeight + 'px');
                }
            }
            else {
                $('#ifReport', window.parent.document).height(ifHeight + 'px');
            }
        }

        function adjustReport_FixWidth() {
            if ($.browser.msie && $.browser.version < 8 && document.documentMode < 8) {
                $("div[title$='width_30']").css("width", "98.5%");
                $("div[title$='width_100']").css("width", "98.5%");
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
                || strValueParam == "hospitality"
                //codition for TMF Police & Fire and Health & Other                
                || (url.indexOf('_level3') >= 0 && strValueParam == "police@@@emergency services" || strValueParam == "health@@@other" || strValueParam == "hotel")
                || (url.indexOf('_level3') >= 0 && url.indexOf('hem_') >= 0 && url.indexOf('type=group') >= 0)) {

                // RTW: hide title
                $("#tbMetric_TrafficLight").parents("tr[vAlign='top']").prev().prev().hide();

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

                    // RTW: adjust the iframe height
                    $('#ifReport', window.parent.document).height(ifHeight - (metricTableHeight + 45) + 'px');
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
            if (document.URL.toLowerCase().indexOf("_level2") >= 0 || document.URL.toLowerCase().indexOf("_level4") >= 0) {
                AdjustMetricLightLevel2_Up();
                Init_Visible_CheckBox();

                UnderlineSubTotalAndTotal();                

            }
            else if (document.URL.toLowerCase().indexOf("_level3") >= 0) {
                AdjustMetricLightLevel2_Up();
                AdjustTitlteHeight();
            }
            else if (document.URL.toLowerCase().indexOf("_level5") >= 0) {
                AdjustTitlteHeight();
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
                $("table[id*='tbMetric']").closest('tr').children('td:eq(0)').css('height', '');

                fixLayoutIE8();
            }
        }

        function doAdditionalWorks() {
            loadTabs();
            hideShowIndicator();
        }

        function getRawDataSource() {
            return "/dashboard/RawData";
        }
        // ======= END CONCRETE METHODS =========

        function fixLayoutIE8() {
            if (document.URL.toLowerCase().indexOf('_level3') >= 0
                || document.URL.toLowerCase().indexOf('_level5') >= 0
                || document.URL.toLowerCase().indexOf('_level7') >= 0) {
                $(".breadcrum_01", window.parent.document).css("min-width", "1310px");
                $(".breadcrum_02", window.parent.document).css("min-width", "1290px");
                $(".container", window.parent.document).css("min-width", "1310px");
            }
        }

        function Init_Visible_CheckBox() {
            $("td:[title*='chkUnit_']").each(function (index, value) {
                $(this).append("<input type='checkbox' id='" + $(this).attr("title").replace(" & ", "@@@") + "' />");
                $(this).attr("title", '');
                $(this).removeAttr("alt");
                if ($(this).css("background-color") != "rgb(249, 248, 240)" && $(this).css("background-color") != "#f9f8f0") {
                    $(this).children("input[type=checkbox]").attr("checked", true);
                }
            });
            $("td[title='[image_header_tablix]']").first().append("<input type='checkbox' id='chkAll_Unit' />");
            if ($('input:checked[id!=chkAll_Unit]').length == $("input[type=checkbox]").length - 1) {
                $("input[id=chkAll_Unit]").attr("checked", true);
                $('input[id=chkAll_Unit]').closest("td").width("4%");
            }
            ShowHideVisibleTooltip();
        }        

        function hideShowIndicator() {
            //add indicator images
            var indicatorUp = $("td[alt='Indicator_Up']");
            var indicatorDown = $("td[alt='Indicator_Down']");

            if (indicatorUp.children('div').length > 0) {
                indicatorUp.children('div').replaceWith('<img id="imgIndicatorUp" src="../../images/indicator_up.png"></img>');
                indicatorDown.children('div').replaceWith('<img id="imgIndicatorDown" src="../../images/indicator_down.png"></img>');
            }
            else {
                if ($("#imgIndicatorUp").length <= 0) {
                    indicatorUp.append('<img id="imgIndicatorUp" src="../../images/indicator_up.png"></img>');
                    indicatorDown.append('<img id="imgIndicatorDown" src="../../images/indicator_down.png"></img>');
                }
            }

            var AVRDURNList = [];
            var graphView1 = $.browser.msie || isIE11() ? $("div[alt='graph_view_1']") : $("table[alt='graph_view_1']");

            graphView1.find('area').each(function () {
                var string = $(this).attr('alt').split(":");
                AVRDURNList.push(string[1].replace(" ", ""));
            });

            var positiveDisplay = 'none';
            var negativeDisplay = 'none';

            $.each(AVRDURNList, function (index) {
                if (parseInt(AVRDURNList[index]) > 0) {
                    positiveDisplay = 'inline';
                }
                else {
                    negativeDisplay = 'inline';
                }
            });

            //hide or show the indicators and labels base on the AVRDURN numbers
            $("td[alt='Indicator_Up']").css('display', positiveDisplay);
            $("td[alt='Indicator_Down']").css('display', negativeDisplay);

            //adjust indicator position
            if ($("td[alt='Indicator_Up']").is(':visible') && $("td[alt='Indicator_Down']").is(':hidden')) {
                $("td[alt='Indicator_Up']").parent("div").css('top', '90px');
            }
            else if ($("td[alt='Indicator_Down']").is(':visible') && $("td[alt='Indicator_Up']").is(':hidden')) {
                $("td[alt='Indicator_Down']").parent('div').css('top', '-50px');
            }

            //hide indicators title
            $("td[alt*='Indicator']").attr("title", '');
        }

        function loadTabs() {
            if (document.URL.toLowerCase().indexOf('_level2') >= 0) {

                parent.DataContentL2Tab1 = $('iframe:eq(0)', window.parent.document).contents()
                    .find('table#tbMetric_TrafficLight').html();
                parent.DataContentL2Tab2 = $('iframe:eq(1)', window.parent.document).contents()
                    .find('table#tbMetric_TrafficLight').html();
                parent.DataContentL2Tab3 = $('iframe:eq(2)', window.parent.document).contents()
                    .find('table#tbMetric_TrafficLight').html();

                if (parent.systemName == "TMF") {
                    //complete tab 1
                    if (parent.DataContentL2Tab1 != null && parent.loadedL2Tab1 == false) {
                        parent.Load_Second_Tab();
                        parent.loadedL2Tab1 = true;
                    }
                        //complete tab 2
                    else if (parent.DataContentL2Tab1 != null && parent.DataContentL2Tab2 != null) {
                        parent.loadedL2EndTab++;
                        if (parent.loadedL2EndTab == 1) {
                            parent.canTabClick = true;
                            if (document.URL.indexOf('Type=group') >= 0
                                && $('#ifReportCover_Group', window.parent.document).css("height") == "0px") {
                                $('#ifReportCover_Group', window.parent.document).css("display", "none");

                                if ($(parent.location).attr('href').indexOf('Type=agency') >= 0) {
                                    $('#ifReportCover_Agency', window.parent.document).css("height", $('#ifReport_Agency', window.parent.document).height());
                                }
                            }
                        }
                    }
                }
                else if (parent.systemName == "WCNSW" || parent.systemName == "Hospitality") {
                    //complete tab 1
                    if (parent.DataContentL2Tab1 != null && parent.loadedL2Tab1 == false) {
                        parent.Load_Second_Tab();
                        parent.loadedL2Tab1 = true;
                    }
                        //complete tab 3
                    else if (parent.DataContentL2Tab1 != null && parent.DataContentL2Tab2 != null
                               && parent.DataContentL2Tab3 != null) {
                        parent.loadedL2EndTab++;
                        if (parent.loadedL2EndTab == 1) {
                            parent.canTabClick = true;
                            if (document.URL.indexOf('Type=account_manager') >= 0
                                 && $('#ifReportCover_AccountManager', window.parent.document).css("height") == "0px") {
                                $('#ifReportCover_AccountManager', window.parent.document).css("display", "none");
                            }
                        }
                    }
                        //complete tab 2
                    else if (parent.DataContentL2Tab1 != null) {

                        parent.loadedL2SecondTab++;
                        if (parent.loadedL2SecondTab == 1) {
                            if (window.location.href.toLowerCase().indexOf('system=hem') < 0) {
                                parent.Load_Third_Tab();
                            }

                            parent.canTabClick = true;

                            if (document.URL.indexOf('Type=group') >= 0
                            && $('#ifReportCover_Group', window.parent.document).css("height") == "0px") {

                                $('#ifReportCover_Group', window.parent.document).css("display", "none");

                                if ($(parent.location).attr('href').indexOf('Type=employer_size') >= 0
                                    || $(parent.location).attr('href').indexOf('Type=portfolio') >= 0) {
                                    $('#ifReportCover_Agency', window.parent.document).css("height", $('#ifReport_Agency', window.parent.document).height());
                                }
                                else if ($(parent.location).attr('href').indexOf('Type=account_manager') >= 0) {
                                    $('#ifReportCover_AccountManager', window.parent.document).css("height", $('#ifReport_AccountManager', window.parent.document).height());
                                }
                            }
                        }
                    }
                }
            }
        }
    </script>
</body>
</html>
