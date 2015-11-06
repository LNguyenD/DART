<%@  Language="C#" AutoEventWireup="true" CodeBehind="DashboardReport.aspx.cs" Inherits="EM_Report.DashboardReports.DashboardReport" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head011" runat="server">
    <title></title>
    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.11.0.custom.min.js" type="text/javascript"></script>
    <style type="text/css">
        .viewDescContent {
            position: absolute;
            background: url(../images/pixel_000_70.png) repeat;
            width: 350px;
            padding: 5px 15px 5px;
            -webkit-border-radius: 5px;
            -moz-border-radius: 5px;
            border-radius: 5px;
            display: none;
            background-color: White;
        }

            .viewDescContent p {
                color: #EEE;
                font-weight: normal;
                outline: 0;
                border: 0;
                padding: 0;
                margin: 0 0 15px;
                font-family: 'lato_regular', Arial, Helvetica, sans-serif;
                font-size: 12px;
            }

            .viewDescContent h1 {
                color: #4fb8e7;
                font-family: 'lato_regular', Arial, Helvetica, sans-serif;
                font-size: 18px;
                font-weight: normal;
            }
    </style>
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
        $(document).ready(function () {
            // detect report lost session problem
            var htmlContent = $("div[id='divViewer']").html();
            var uSess = '<%=EM_Report.Helpers.Base.LoginSession %>';
            if (htmlContent.indexOf('attempt to connect to the report server failed') >= 0 || uSess == "") {
                parent.window.location = parent.window.g_baseUrl + '/account/login?logout=true&ssrs=lost';
            }
        });

        Sys.Application.add_load(function () {
            $find("rvwReportViewer").add_propertyChanged(viewerPropertyChanged);
        });

        function openRawDataPopup(strHref) {
            if (strHref != null) {
                parent.openRawDataPopup(strHref);
            }
        }

        function ViewLargeGraph(Url) {
            parent.ViewLargeGraph(Url);
        }

        var eventRegistered = false;
        function AdjustReport() {
            // Adjust Icon traffice light
            $("img[title*='images/']").each(function (index, value) {
                var fullTitle = $(this).attr("title");
                var url = fullTitle.substring(0, fullTitle.indexOf("]") + 1);
                $(this).attr("src", "../" + url.replace("[", "").replace("]", ""));
                $(this).attr("title", fullTitle.replace(url, ""));
                $(this).attr("alt", fullTitle.replace(url, ""));
            });

            // Adjust Expand icon
            $("img[alt='Expand']").attr({ 'src': "../images/ico_large.png" });
            $("img[alt='Expand']").width(23);
            $("img[alt='Expand']").height(19);
            $("img[alt='Expand']").closest('div').css('width', '30px');

            // Adjust Print icon
            $("img[alt*='print']").attr({ 'src': "../images/ico_print.png" });
            $("img[alt*='print']").width(23);
            $("img[alt*='print']").height(19);
            $("img[alt*='print']").closest('div').css('width', '30px');
            $("img[alt*='print']").css('cursor', 'pointer');

            //Adjust Description
            $("img[alt='Description']").attr({ 'src': "../images/ico_description_final.png" });
            $("img[alt='Description']").width(22);
            $("img[alt='Description']").height(20);
            $("img[alt='Description']").closest('div').css('width', '25px');
            $("img[alt='Description']").closest('td').css('width', '19px');

            //Adjust Graph numbers
            $("img[alt='Graph numbers']").attr({ 'src': "../images/ico_graph_numbers.png" });
            $("img[alt='Graph numbers']").width(14);
            $("img[alt='Graph numbers']").height(14);

            // Adjust heading background
            $("div[alt='[image_header_tablix]']").parent("td").css(
                'background', 'url("../images/thead_bg.png") repeat-x scroll 0 0 #EDECEC');
            $("td[alt='[image_header_tablix]']").css('background', 'url("../images/thead_bg.png") repeat-x scroll 0 0 #EDECEC');

            // attach event handlers for 'Raw data' buttons
            $("img[alt='Raw data']").attr({ 'src': "../images/bullet_raw_data.png" });
            $("img[alt='Raw data']").width(19);
            $("img[alt='Raw data']").height(17);
            $("img[alt='Raw data']").closest('div').css('width', '20px');

            // hide metric light raw data icon
            $("img[alt='Raw data']").parent("a[href*='=Metric']").parent("div").hide();

            parent.metricLightHref = $("img[alt='Raw data']:first").parent("a").attr("href");

            var viewer = document.getElementById("<%=rvwReportViewer.ClientID %>");
            var tbOwner = $("div[id*='VisibleReportContentrvwReportViewer'] table:first");

            // get height of report viewer content
            var ifHeight = tbOwner.height();

            // hide horizontal scroll
            $("div[id*='rvwReportViewer']").css("overflow", "hidden");
            $("div[id='rvwReportViewer']").css("width", "100%");

            // change report loading panel                
            $("div[id*='rvwReportViewer_AsyncWait_Wait']").html("<img src='../images/loading.gif' complete='complete' />");
            $("div[id*='rvwReportViewer_AsyncWait_Wait']").css({ "border": "0", "background-color": "" });

            var loading = $("#rvwReportViewer_AsyncWait_Wait").is(':visible');
            if (loading) {
                // supply a additional number for loading icon area
                ifHeight = ifHeight + 78;
            }

            // adjust height of report viewer
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

            $('#divViewer').height(ifHeight + 'px');
            $("td[id*='oReportCell'] > div").css("width", "100%");
            $("td[id*='oReportCell'] > div > div").css("width", "100%");
            $("td[id*='oReportCell'] > div > div > div").css("width", "100%");
            $("td[id*='oReportCell']").closest("table").css("width", "100%");
            $("td[id*='oReportCell']").find("table").css("width", "100%");
            $("td[id*='oReportCell']").find("td").attr("align", "left");

            $("div[title$='width_30']").css("width", "99%");
            $("div[title$='width_100']").css("width", "100%");
            $("div[imgConImage='AutoSize']").parent("td").attr("align", "left");
            $("img[title$='width_100']").parent("div").css("width", "100%");

            // value parameter from URL
            var strValueParam = getParameterByName("Value").toLowerCase();
            var url = document.URL.toLowerCase();

            //hide metric light table in level 3
            // condition for employer size
            if ((url.indexOf('type=employer_size') >= 0 && url.indexOf('_level3') >= 0)
                // condition for TMF Total
                || strValueParam == "tmf"
                //codition for TMF group
                || (url.indexOf('tmf_') >= 0 && url.indexOf('type=group') >= 0 && url.indexOf('_level3') >= 0)
                //codition for EML Total
                || strValueParam == "wcnsw"
                //codition for TMF Police & Fire and Health & Other
                || (url.indexOf('_level3') >= 0 && strValueParam == "police@@@fire" || strValueParam == "health@@@other" || strValueParam == "hotel")
                || (url.indexOf('_level3') >= 0 && url.indexOf('hem_') >= 0 && url.indexOf('type=group') >= 0)) {
                if (url.indexOf("_rtw_") >= 0) {
                    // RTW: hide title
                    $("#tbMetric_TrafficLight").parents("tr[vAlign='top']").prev().prev().hide();
                }
                else {
                    // AWC: hide title
                    $("#tbMetric_TrafficLight").parents("tr[vAlign='top']").parents("tr[vAlign='top']").prev().hide();
                }

                if (loading == false) {

                    var metricTableHeight = $("#tbMetric_TrafficLight").parent("td").height();
                    parent.metricTableHeightBeforeHide = metricTableHeight;

                    // hide metric table
                    if ($.browser.msie) {
                        // IE 7 and smaller version
                        $("#tbMetric_TrafficLight").parents("div[alt$='width_100']").parents("tr[vAlign='top']").hide();
                    }
                    else {
                        $("#tbMetric_TrafficLight").parents("table[alt$='width_100']").parents("tr[vAlign='top']").hide();
                    }

                    if (document.URL.toLowerCase().indexOf("_rtw_") >= 0) {
                        // RTW: adjust the iframe height
                        $('#ifReport', window.parent.document).height(ifHeight - (metricTableHeight + 45) + 'px');
                    }
                    else {
                        // AWC: adjust the iframe height
                        $('#ifReport', window.parent.document).height(ifHeight - (metricTableHeight + 30) + 'px');
                    }
                }
            }

            // Show default metric light as unknow src then adjust later
            var tbMetricLight = $("table[id*='TrafficLight']");
            if (tbMetricLight.length > 0) {
                var srcUnknow = parent.$("img[src*='unknown']").first().attr("src");
                tbMetricLight.find('img').attr("src", srcUnknow);
                GetImageUrl();
            }

            if (ifHeight > 78) {
                if (!eventRegistered) {
                    registerDescriptionButtonHover();
                }

                if (window.location.href.toLowerCase().indexOf('level1') < 0
                    && window.location.href.toLowerCase().indexOf('level0') < 0) {
                    setupGraphView();

                    if (!eventRegistered) {
                        registerPrintButtonClick();
                        registerDescriptionButtonHover();

                        eventRegistered = true;
                    }
                }               
            }

            //remove printing icon from small graph
            $("img[alt*='print_graph_']").each(function () {
                if (document.URL.toLowerCase().indexOf("level0") > 0) {
                    $(this).hide();
                }
                if ((document.URL.toLowerCase().indexOf("_level3") > 0 ||
                    document.URL.toLowerCase().indexOf("_level5") > 0) &&
                    document.URL.toLowerCase().indexOf("_rtw_") > 0) {
                    if ($(this).attr('alt') != 'print_graph_0' && $(this).attr('alt') != 'print_graph_1' &&
                        $(this).attr('alt') != 'print_graph_2' && $(this).attr('alt') != 'print_graph_3' &&
                        $(this).attr('alt') != 'print_graph_4') {
                        $(this).hide();
                    }
                }
                else {
                    if ($(this).attr('alt').toLowerCase().indexOf('print_graph_0') <= -1) {
                        $(this).hide();
                    }
                }
            });
        }

        function AdjustMetricLightLevel0() {
            $("div[id*='VisibleReportContentrvwReportViewer'] table").css("width", "100%");

            // Adjust odd & event background
            $("table[alt='level0_tmf']").attr("id", "tbTrafficLight_TMF");
            $("table[alt='level0_eml']").attr("id", "tbTrafficLight_EML");
            $("table[alt='level0_hem']").attr("id", "tbTrafficLight_HEM");

            $("table#tbTrafficLight_TMF").css("width", "99.95%");
            $("table#tbTrafficLight_EML").css("width", "99.95%");
            $("table#tbTrafficLight_HEM").css("width", "99.95%");

            $("table#tbTrafficLight_TMF").parents('table').css("width", "100%");
            $("table#tbTrafficLight_TMF").parents('table').parents("div").css("width", "100%");

            $("table#tbTrafficLight_TMF td").css('width', 'auto');
            $("table#tbTrafficLight_TMF td").css('min-width', '0');
            $("table#tbTrafficLight_TMF td").attr('align', 'center');

            $("table#tbTrafficLight_EML").parents('table').css("width", "100%");
            $("table#tbTrafficLight_EML").parents('table').parents("div").css("width", "100%");

            $("table#tbTrafficLight_EML td").css('width', 'auto');
            $("table#tbTrafficLight_EML td").css('min-width', '0');
            $("table#tbTrafficLight_EML td").attr('align', 'center');

            $("table#tbTrafficLight_HEM").parents('table').css("width", "100%");
            $("table#tbTrafficLight_HEM").parents('table').parents("div").css("width", "100%");

            $("table#tbTrafficLight_HEM td").css('width', 'auto');
            $("table#tbTrafficLight_HEM td").css('min-width', '0');
            $("table#tbTrafficLight_HEM td").attr('align', 'center');

            // Adjust header background
            $("table#tbTrafficLight_TMF tr[height=0]").next().children("td:not(:first)").css("width", "16.67%");
            $("table#tbTrafficLight_EML tr[height=0]").next().children("td:not(:first)").css("width", "16.67%");
            $("table#tbTrafficLight_HEM tr[height=0]").next().children("td:not(:first)").css("width", "16.67%");
        }

        function AdjustMetricLightLevel1() {
            $("div[id*='VisibleReportContentrvwReportViewer'] table").css("width", "100%");
            $('#divViewer').css("background", "url(../images/pattern.png) repeat 0 0");

            // Adjust odd & event background                    
            $("table[alt='level1_table1']").attr("id", "tbTrafficLight_Table1");
            $("table[alt='level1_table2']").attr("id", "tbTrafficLight_Table2");
            $("table[alt='level1_table3']").attr("id", "tbTrafficLight_Table3");

            $("table#tbTrafficLight_Table1").css("width", "99.95%");
            $("table#tbTrafficLight_Table2").css("width", "99.95%");
            $("table#tbTrafficLight_Table3").css("width", "99.95%");

            $("table#tbTrafficLight_Table1").parents('table').css("width", "100%");
            $("table#tbTrafficLight_Table1").parents('table').parents("div").css("width", "100%");

            $("table#tbTrafficLight_Table1 td").css('width', 'auto');
            $("table#tbTrafficLight_Table1 td").css('min-width', '0');
            $("table#tbTrafficLight_Table1 td").attr('align', 'center');

            $("table#tbTrafficLight_Table2").parents('table').css("width", "100%");
            $("table#tbTrafficLight_Table2").parents('table').parents("div").css("width", "100%");

            $("table#tbTrafficLight_Table2 td").css('width', 'auto');
            $("table#tbTrafficLight_Table2 td").css('min-width', '0');
            $("table#tbTrafficLight_Table2 td").attr('align', 'center');

            $("table#tbTrafficLight_Table3").parents('table').css("width", "100%");
            $("table#tbTrafficLight_Table3").parents('table').parents("div").css("width", "100%");

            $("table#tbTrafficLight_Table3 td").css('width', 'auto');
            $("table#tbTrafficLight_Table3 td").css('min-width', '0');
            $("table#tbTrafficLight_Table3 td").attr('align', 'center');

            // Adjust header background   
            var backgroundWidth;
            if (document.URL.toLowerCase().indexOf("tmf_level1") > 0) {
                backgroundWidth = 14.28;
            }
            else {
                backgroundWidth = 16.67;
            }
            $("table#tbTrafficLight_Table1 tr[height=0]").next().children("td:not(:first)").css("width", backgroundWidth + "%");
            $("table#tbTrafficLight_Table2 tr[height=0]").next().children("td:not(:first)").css("width", backgroundWidth + "%");
            $("table#tbTrafficLight_Table3 tr[height=0]").next().children("td:not(:first)").css("width", backgroundWidth + "%");
        }

        function ShowHideVisibleTooltip() {
            $('input[type=checkbox]').click(function () {
                if ($(this).attr("id") == "chkAll_Unit") {
                    if ($(this).attr("checked")) {
                        $("input[type=checkbox]").attr("checked", true);
                    }
                    else {
                        $("input[type=checkbox]").attr("checked", false);
                    }
                }
                else {

                }
                if ($('input:checked[id!=chkAll_Unit]').length > 0) {
                    parent.$(".serverContent").fadeIn("slow");
                }
                else {
                    parent.$(".serverContent").fadeOut("slow");
                }
            });
        }

        function RemoveTitle() {
            // remove heading tooltips
            $("div[title='[image_header_tablix]']").removeAttr("title");
            $("div[alt='[image_header_tablix]']").removeAttr("alt");
            $("td[title='[image_header_tablix]']").removeAttr("title");
            $("td[alt='[image_header_tablix]']").removeAttr("alt");

            // remove the tooltip on metric light tables
            $("table[title='level1_table1']").removeAttr("title");
            $("table[title='level1_table2']").removeAttr("title");
            $("table[title='level1_table3']").removeAttr("title");
            $("table[title='level0_tmf']").removeAttr("title");
            $("table[title='level0_eml']").removeAttr("title");
            $("table[title='level0_hem']").removeAttr("title");

            // remove other tooltips
            $("div[title$='width_100']").removeAttr("title");
            $("img[title$='width_100']").removeAttr("title");
            $("table[title$='width_100']").removeAttr("title");
            $("div[title$='width_30']").removeAttr("title");
            $("table[title$='width_30']").removeAttr("title");

            // remove desciption icon title
            $("img[title='Description']").removeAttr("title");

            // remove portfolio report icon title
            $("img[title='PortIcon']").removeAttr("title");

            // remove tooltips relating printing function
            $("img[title^='graph_']").removeAttr("title");
            $("td[title*='title_graph_']").removeAttr("title");
            $("table[title='projection_table']").removeAttr("title");

            // adjust tooltips for print button
            $("img[title^='print_graph_']").attr("title", "Print graph");
        }

        function Init_Visible_CheckBox() {
            $("td:[title*='chkUnit_']").each(function (index, value) {
                $(this).append("<input type='checkbox' id='" + $(this).attr("title").replace(" & ", "@@@") + "' />");
                $(this).removeAttr("title");
                $(this).removeAttr("alt");
                if ($(this).css("background-color") != "rgb(249, 248, 240)" && $(this).css("background-color") != "#f9f8f0") {
                    $(this).children("input[type=checkbox]").attr("checked", true);
                }
            });
            $("td[title='[image_header_tablix]']").first().append("<input type='checkbox' id='chkAll_Unit' />");
            if ($('input:checked[id!=chkAll_Unit]').length == $("input[type=checkbox]").length - 1) {
                $("input[id=chkAll_Unit]").attr("checked", true);
                $('input[id=chkAll_Unit]').closest("td").width(50);
            }
            ShowHideVisibleTooltip();
        }

        function AdjustMetricLightLevel2_Up() {
            var tableMetric = $("table > tbody > tr[height=0]").first().closest("table");
            tableMetric.attr("id", "tbMetric_TrafficLight");
            tableMetric.parents('table').css("width", "100%");
            tableMetric.parents('table').parents("div").css("width", "100%");

            $("table#tbMetric_TrafficLight").css("width", "100%");

            $("table#tbMetric_TrafficLight td").css('width', 'auto');
            $("table#tbMetric_TrafficLight td").css('min-width', '0');
            $("table#tbMetric_TrafficLight td").attr('align', 'center');
        }

        function viewerPropertyChanged(sender, e) {
            if (e.get_propertyName() == "isLoading") {
                AdjustReport();
                if (document.URL.toLowerCase().indexOf("level0") >= 0) {
                    AdjustMetricLightLevel0();
                }
                else if (document.URL.toLowerCase().indexOf("_level1") >= 0) {
                    AdjustMetricLightLevel1();
                }
                else if (document.URL.toLowerCase().indexOf("_level2") >= 0) {
                    AdjustMetricLightLevel2_Up();
                    if (document.URL.toLowerCase().indexOf("_rtw_") >= 0) {
                        Init_Visible_CheckBox();
                    }
                }
                else if (document.URL.toLowerCase().indexOf("_level3") >= 0) {
                    AdjustMetricLightLevel2_Up();
                }
                else if (document.URL.toLowerCase().indexOf("_level4") >= 0) {
                    if (document.URL.toLowerCase().indexOf("_rtw_") >= 0) {
                        AdjustMetricLightLevel2_Up();
                        Init_Visible_CheckBox();
                    }
                }

                // Center all graphs
                $("map").closest("td").attr("align", "center");
                $("map").closest("td").children("div").attr("align", "center");

                //Remove all title attribute
                RemoveTitle();

                if (document.URL.indexOf("#viewlarge") >= 0) {
                    var obj = $("img[alt='Raw data']").not(":first").first();
                    if (obj.length > 0) {
                        var off = obj.position();
                        parent.window.scrollTo(0, off.top + 110)
                    }
                }

                hideShowIndicator();

                //adjustTooltip();

                //ShowDescription();
                //hideShowDescriptionIcon();                               

                //get href of the metric light raw data icon
                parent.metricLightHref = $("img[alt='Raw data']").first().parent('a').attr('href');

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
                            if (parent.loadedL2EndTab == 2) {
                                parent.canTabClick = true;
                                if (document.URL.indexOf('Type=group') >= 0
                                    && $('#ifReportCover_Group', window.parent.document).css("height") == "0px") {
                                    $('#ifReportCover_Group', window.parent.document).css("display", "none");
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
                            if (parent.loadedL2EndTab == 2) {
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
                            if (parent.loadedL2SecondTab == 2) {

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
        }

        function AdjustShowDescription(position) {
            var content = parent.$(".viewDescContent");
            var pos = position;
            var topAdjust;
            var strValueParam = getParameterByName("Value");

            if (document.URL.toLowerCase().indexOf("_level2") >= 0) {
                var screenWidth = parent.$(window).width();
                if (screenWidth < 1317) {
                    topAdjust = 278;
                }
                else {
                    topAdjust = 275;
                }
            }
            else if ((document.URL.toLowerCase().indexOf("_level3") >= 0
                && document.URL.toLowerCase().indexOf("type=employer_size") >= 0)
                || strValueParam.toLowerCase() == "wcnsw"
                //condition for hotel, Police&Fire, Health&Other
                || (document.URL.toLowerCase().indexOf("_level3") >= 0
                    && (strValueParam.toLowerCase() == "hotel"
                        || (strValueParam.toLowerCase().indexOf("police") >= 0 && strValueParam.toLowerCase().indexOf("fire") >= 0)
                        || (strValueParam.toLowerCase().indexOf("health") >= 0 && strValueParam.toLowerCase().indexOf("other") >= 0)))) {

                var metricTableHeight = parent.metricTableHeightBeforeHide;
                //adjust description tooltip in level 3  employer size
                if (document.URL.toLowerCase().indexOf("_rtw_") >= 0) {
                    if (strValueParam.toLowerCase() == "wcnsw") {
                        metricTableHeight = $("#tbMetric_TrafficLight").parent("td").height();
                        topAdjust = 155 - metricTableHeight;
                    }
                    else
                        topAdjust = 185 - metricTableHeight;
                }
                else {
                    topAdjust = 180 - metricTableHeight;
                }
            }
            else {
                topAdjust = 235;
            }

            content.css("top", pos.top + topAdjust);
            var posLeft = pos.left + content.width();
            var limit = parent.$(".w_100p").position().left + parent.$(".w_100p").width();

            if (posLeft > limit) {
                content.css("left", pos.left - content.width());
            }
            else {
                content.css("left", pos.left);
            }
        }

        //display tooltip
        var flag = false;
        function ShowDescription() {
            var content = parent.$(".viewDescContent");
            if (flag == false) {
                $("img[alt='Description']").each(function (index) {
                    var intTiming = 0;
                    var href = $(this).parent("a").attr('href');
                    var pos = $(this).position();
                    $(this).mouseover(function () {
                        tooltipTimeout = setTimeout(function () { openDescription(content, href, pos) }, 300);
                    });
                    $(this).mouseleave(function () {
                        closeDescription(content);
                    });

                    flag = true;
                });
            }
        }

        function openDescription(content, href, pos) {
            filterDescriptionContent(href);
            AdjustShowDescription(pos);
            if (content.css('background-image') == 'none') {
                var contentStyle = content.attr('style');
                content.attr('style', contentStyle + ';background-color: #4C4C4C !important');
            }
            content.slideDown();
        }

        function closeDescription(content) {
            clearTimeout(tooltipTimeout);
            content.slideUp();
        }
        //end display tooltip

        //change text description tooltip
        function filterDescriptionContent(href) {
            href = href.replace("javascript:ShowDescription('", "");
            href = href.replace("')", "");
            href = href.replace("','", " ");
            var content = parent.$(".viewDescContent");
            var h1 = content.find('h1');
            var p = content.find('p');
            var flag = false;

            content.find("input").each(function () {
                var desc = $(this).val();
                var dbHref = $(this).attr('id');
                var systemName = $(this).attr('title');
                if (href.indexOf(dbHref) >= 0) {
                    flag = true;
                }
                else if (href.indexOf(dbHref) >= 0 && href.indexOf(systemName) >= 0) {
                    flag = true;
                }

                if (flag == true) {
                    p.html(desc);
                    if (href == "1-2" || href == "3-5") {
                        h1.html("Weekly open " + href + " years post-injury");
                    }
                    else if (href == "5-plus") {
                        h1.html("Weekly open 5 + years post-injury");
                    }
                    else if (href == "Whole_HEM") {
                        h1.html("No. of active weekly claims by accident year Hospitality");
                    }
                    else if (href == "Whole_TMF") {
                        h1.html("No. of active weekly claims by accident year TMF");
                    }
                    else if (href == "Whole_EML") {
                        h1.html("No. of active weekly claims by accident year WCNSW");
                    }
                    else {
                        href = href.replace(/-/g, " ");
                        href = href.replace(/_/g, " ");
                        href = href.replace("HEM", "Hospitality");
                        href = href.replace("EML", "WCNSW");
                        h1.html(href);
                    }
                }
                flag = false;
            });

        }

        var flag2 = false;
        function hideShowDescriptionIcon() {
            if (flag2 == false) {
                $("img[alt='Description']").each(function (index) {
                    var i = 0;
                    var icon = $(this);
                    var href = $(this).parent("a").attr('href');
                    href = href.replace("javascript:ShowDescription('", "");
                    href = href.replace("')", "");
                    href = href.replace("','", "");

                    $(".viewDescContent", window.parent.document).find("input").each(function () {
                        var desc = $(this).val();
                        var dbHref = $(this).attr('id');
                        var systemName = $(this).attr('title');

                        //check if there is no description
                        if (desc == "") {
                            if (href == dbHref) {
                                icon.parent().remove();
                            }
                        }

                        //check if there is no record
                        if (document.URL.toLowerCase().indexOf("level0") < 0) {
                            if (href.indexOf(dbHref) >= 0) i++;
                        }
                        else {
                            if (href.indexOf(dbHref) >= 0 && href.indexOf(systemName) >= 0) i++;
                        }
                    });

                    if (i <= 0) icon.parent().remove();
                    flag2 = true;
                });
            }
        }

        //get keys and values from all icons in the table
        function GetImageUrl() {
            var arrRTW = [];
            var arrAWC = [];
            parent.$("div[class=trafficContents]").find('img').each(function () {
                if ($(this).attr("name").toLowerCase().indexOf("rtw") >= 0) {
                    arrRTW.push({
                        name: $(this).attr("name")
                        , url: $(this).attr("src")
                        , fromVal: $(this).attr("fromVal")
                        , toVal: $(this).attr("toVal")
                    });
                }
                else {
                    arrAWC.push({
                        name: $(this).attr("name")
                        , url: $(this).attr("src")
                        , fromVal: $(this).attr("fromVal")
                        , toVal: $(this).attr("toVal")
                    });
                }
            });

            // find traffic light unknow image
            var unknowImageUrl = "";
            var unknowImage = parent.$("div[class=trafficContents]").find("img[name$='_Unknown']");
            if (unknowImage.length > 0) {
                unknowImageUrl = unknowImage.attr("src");
            }

            $("table[id*=TrafficLight]").find('img').each(function () {
                var imgCurent = $(this);
                var refixTooltip = "";

                if (imgCurent.attr('alt') != null && imgCurent.attr('alt') != "PortIcon") {
                    var arrTraffic = $(this).attr('alt').replace("[", "").replace("]", "");
                    arrTraffic = arrTraffic.split('_');
                    var arrCompare = [];
                    if (arrTraffic[0].toLowerCase().indexOf("rtw") >= 0) {
                        arrCompare = arrRTW;
                        refixTooltip = "Current RTW measure: " + arrTraffic[1];
                    }
                    else {
                        arrCompare = arrAWC;
                        refixTooltip = "Number of claims: " + arrTraffic[1];
                    }
                    imgCurent.attr('alt', refixTooltip);
                    imgCurent.attr('title', refixTooltip);

                    $.each(arrCompare, function (index) {
                        // For RTW: Measure/ For AWC: Number of claims
                        var value1 = parseFloat(arrTraffic[1]);

                        // For RTW: Target/ For AWC: Projection
                        var value2 = parseFloat(arrTraffic[2]);

                        if (value1 == NaN || value2 == NaN || (value1 == 0 && value2 == 0)) {
                            imgCurent.attr("src", unknowImageUrl);
                        }
                        else if (value2 >= parseFloat(arrCompare[index].fromVal)
                            && value2 <= parseFloat(arrCompare[index].toVal)) {
                            imgCurent.attr("src", arrCompare[index].url);
                        }
                    });
                }
                else {
                    //Adjust Portfolio icon in level 1
                    imgCurent.attr({ "src": "../images/light_yellow.png" });
                }
            });
        }

        function getParameterByName(key) {
            if (key != null) {
                key = key.replace(/[*+?^$.\[\]{}()|\\\/]/g, "\\$&"); // escape RegEx meta chars
                var match = location.search.match(new RegExp("[?&]" + key + "=([^&]+)(&|$)"));

                if (match != null)
                    return match && decodeURIComponent(match[1].replace(/\+/g, " "));
            }

            return "";
        }

        // ======== PRINTING ===============

        function registerPrintButtonClick() {
            $("img[alt*='print']").click(function () {
                var graphViewName = $(this).attr('alt').replace('print_', '');
                previewGraphBeforePrint(graphViewName);
            });
        }

        function formatProjectionTable(projectionTable) {
            projectionTable.css('font-size', '11px');
            projectionTable.css('font-family', '"lato_regular", Arial, Helvetica, sans-serif');
            projectionTable.find('tr:gt(0):lt(3)').each(function (index) {
                var rowIndex = index;
                $(this).children('td:gt(1)').each(function (index) {
                    $(this).css('text-align', 'center');
                    $(this).css('vertical-align', 'middle');
                    $(this).css('padding', '2px');
                    $(this).css('border-style', 'solid');
                    $(this).css('border-width', '1px');
                    $(this).css('border-color', '#e1e1e1');

                    if (index == 0) {
                        $(this).css('color', '#037baf');
                    }
                });

                // set color for table header
                if (index == 0) {
                    $(this).css('color', '#037baf');
                }

                // set color for table row 1
                $(this).children('td:gt(1)').each(function (index) {
                    if (rowIndex == 1) {
                        $(this).css('background-color', '#edf2f6');
                    }
                });
            });
        }

        function previewGraphBeforePrint(graphViewName) {
            var graphContainer = graphViewName == "graph_1" ? ($.browser.msie ? $("div[alt^='" + graphViewName + "']") : $("table[alt^='" + graphViewName + "']")) : $('#' + graphViewName);

            var graphContainerClone = graphContainer.clone()/*.css({'width': ''})*/;

            validateGraphSession(graphContainerClone);

            clipGraphs(graphContainer, graphContainerClone);

            var graphTitle = $('td[alt="title_' + graphViewName.replace('_width_100', '') + '"]').text();

            $("#overlay", window.parent.document).fadeIn('fast', function () {
                // FIXED: losting CSS in projection table (AWC) when user open print preview popup (Chrome only)
                graphContainerClone.find("table[alt='projection_table'] > tbody div").each(function () {
                    $(this).removeAttr("class");
                });
                graphContainerClone.find("table[alt='projection_table']").attr("alt", "projection_table_clone");

                var printContentIframe = $("#printContent", window.parent.document);
                printContentIframe.contents().find('body').empty();
                printContentIframe.contents().find('body').append('<div id="content" align="center" style="position: relative"><div id="graphTitle"</div></div>');
                printContentIframe.contents().find('body div#graphTitle').html(graphTitle);
                printContentIframe.contents().find('body div#graphTitle').css({ 'font-family': 'arial', 'font-size': '12pt', 'color': '#037baf', 'font-weight': '700' });
                printContentIframe.contents().find('body div#content').append(graphContainerClone);
                printContentIframe.contents().find("body").css("width", "99%");
                printContentIframe.contents().find("html").css("overflow", "auto");
                //$("#printContent", window.parent.document).height(graphContainer.height() + 30); // use graphContainer instead of graphContainerClone to get correct height for IE

                var selfPopup = $(".viewPrintContent", window.parent.document);
                selfPopup.css("top", ($(window).height() - selfPopup.height()) / 2 + $(window).scrollTop() + "px");
                var popupWidth = $(window).width() - 200;
                //selfPopup.css("cssText", "width: " + (graphViewName.indexOf('width_100') >= 0 ? graph.width() + 20 : graphContainer.width() + 20) + "px !important; height: " + (graphContainer.height() + 40) + "px !important");
                selfPopup.css("cssText", "width: " + popupWidth + "px !important");

                selfPopup.css("left", "15px");
                selfPopup.fadeIn('slow');
                selfPopup.css("margin", "auto");

                graphContainerClone.css("margin-left", "-10px");

                printContentIframe.contents().find('body div#content').css("top", (printContentIframe.height() - graphContainer.height()) / 2 + "px");

                var projectionTable = graphContainerClone.find('table[alt="projection_table_clone"]');
                if (projectionTable.length > 0) {
                    formatProjectionTable(projectionTable);
                }
            });


        }

        function clipGraphs(graphContainer, graphContainerClone) {
            graphContainer.find('img[alt*="graph"]').each(function () {
                var graphImg = $(this);
                var graphInfo = {};
                graphInfo.graphSrc = graphImg.attr('src');
                graphInfo.graphName = graphImg.attr('alt');
                graphInfo.graphWidth = graphImg.width() < graphImg.parent().width() || graphImg.parent().width() == 0 ? graphImg.width() : graphImg.parent().width();
                graphInfo.graphHeight = graphImg.parent().height();

                if (graphInfo.graphWidth != 0 && graphInfo.graphHeight != 0) {
                    var graphLeft = parseInt(graphImg.css('left').replace('-', '').replace('px', ''));
                    if (isNaN(graphLeft))
                        graphLeft = 0;
                    graphInfo.graphLeft = graphLeft;

                    var graphTop = parseInt(graphImg.css('top').replace('-', '').replace('px', ''));
                    if (isNaN(graphTop))
                        graphTop = 0;
                    graphInfo.graphTop = graphTop;
                    graphInfo.graphBottom = graphInfo.graphTop + graphInfo.graphHeight;

                    var graph = graphContainerClone.find('img[alt="' + graphInfo.graphName + '"]');
                    graph.css('clip', 'rect(' + graphInfo.graphTop + 'px,' + graphInfo.graphWidth + 'px,' + graphInfo.graphBottom + 'px,' + graphInfo.graphLeft + 'px' + ')');
                    graph.css('position', 'absolute');
                    graph.css('left', '0px');
                    graphContainerClone.width(graphInfo.graphWidth);
                    //graphContainerClone.css('height', graphContainer.find('img').parent().height() + 'px');
                    graphContainerClone.css('position', 'relative');
                }
            });
        }

        function hidePrintingIconOfSmallGraphs() {
            $("img[alt*='print_graph_']").each(function () {
                if ($(this).attr('alt').toLowerCase().indexOf('print_graph_view') < 0) {
                    $(this).hide();
                }
            });
        }

        function setupGraphView() {
            $('img[alt^="graph"]').each(function () {
                if (document.URL.toLowerCase().indexOf('awc') > -1) {
                    if ($(this).attr('alt').indexOf('width_100') < 0) {
                        $(this).closest('table').attr('id', $(this).attr('alt'));
                    }
                    else {
                        $(this).parent().attr('id', $(this).attr('alt'));
                        $(this).parent().parent().attr('align', 'center');
                    }                  
                }
                else {
                    $(this).parent().attr('id', $(this).attr('alt'));
                    $(this).parent().parent().attr('align', 'center');
                }
            });
        }
        // ========= END PRINTING ==========

        // ========= DETECT LOST SESSION ========
        function validateGraphSession(graphView) {
            var graph = graphView.find('img');
            graph.error(function () {
                parent.window.location = parent.window.g_baseUrl + '/account/login?logout=true&ssrs=lost';
            });
        }
        // ========= END DETECT LOST SESSION ========

        // ======== DESCRIPTION TOOLTIP ========

        function registerDescriptionButtonHover() {
            removeNoDataDescriptionButtons();

            $(document).tooltip({
                items: "img[alt*='Description']",
                content: function () {
                    var content = parent.$(".viewDescContent");
                    var href = $(this).parent("a").attr('href');
                    filterDescriptionContent(href);
                    return content.html();
                },
                tooltipClass: "viewDescContent",
                show: { effect: "blind", duration: 300 }
            });
        }

        function removeNoDataDescriptionButtons() {
            $("img[alt*='Description']").each(function (index) {
                var i = 0;
                var icon = $(this);
                var href = $(this).parent("a").attr('href');
                href = href.replace("javascript:ShowDescription('", "");
                href = href.replace("')", "");
                href = href.replace("','", "");

                $(".viewDescContent", window.parent.document).find("input").each(function () {
                    var desc = $(this).val();
                    var dbHref = $(this).attr('id');
                    var systemName = $(this).attr('title');

                    //check if there is no description
                    if (desc == "") {
                        if (href == dbHref) {
                            icon.parent().remove();
                        }
                    }

                    //check if there is no record
                    if (document.URL.toLowerCase().indexOf("level0") < 0) {
                        if (href.indexOf(dbHref) >= 0) i++;
                    }
                    else {
                        if (href.indexOf(dbHref) >= 0 && href.indexOf(systemName) >= 0) i++;
                    }
                });

                if (i <= 0) icon.parent().remove();
            });
        }

        function filterDescriptionContent(href) {
            href = href.replace("javascript:ShowDescription('", "");
            href = href.replace("')", "");
            href = href.replace("','", " ");
            var content = parent.$(".viewDescContent");
            var h1 = content.find('h1');
            var p = content.find('p');
            var flag = false;

            content.find("input").each(function () {
                var desc = $(this).val();
                var dbHref = $(this).attr('id');
                var systemName = $(this).attr('title');
                if (href.indexOf(dbHref) >= 0) {
                    flag = true;
                }
                else if (href.indexOf(dbHref) >= 0 && href.indexOf(systemName) >= 0) {
                    flag = true;
                }

                if (flag == true) {
                    p.html(desc);
                    if (href == "1-2" || href == "3-5") {
                        h1.html("Weekly open " + href + " years post-injury");
                    }
                    else if (href == "5-plus") {
                        h1.html("Weekly open 5 + years post-injury");
                    }
                    else if (href == "Whole_HEM") {
                        h1.html("No. of active weekly claims by accident year Hospitality");
                    }
                    else if (href == "Whole_TMF") {
                        h1.html("No. of active weekly claims by accident year TMF");
                    }
                    else if (href == "Whole_EML") {
                        h1.html("No. of active weekly claims by accident year WCNSW");
                    }
                    else {
                        href = href.replace(/-/g, " ");
                        href = href.replace(/_/g, " ");
                        href = href.replace("HEM", "Hospitality");
                        href = href.replace("EML", "WCNSW");
                        h1.html(href);
                    }
                }
                flag = false;
            });

        }
        // ======== END DESCRIPTION TOOLTIP =========

        function hideShowIndicator() {
            //add indicator images
            var indicatorUp = $("td[alt='Indicator_Up']");
            var indicatorDown = $("td[alt='Indicator_Down']");

            if (indicatorUp.children('div').length > 0) {
                indicatorUp.children('div').replaceWith('<img id="imgIndicatorUp" src="../images/indicator_up.png"></img>');
                indicatorDown.children('div').replaceWith('<img id="imgIndicatorDown" src="../images/indicator_down.png"></img>');
            }
            else {
                if ($("#imgIndicatorUp").length <= 0) {
                    indicatorUp.append('<img id="imgIndicatorUp" src="../images/indicator_up.png"></img>');
                    indicatorDown.append('<img id="imgIndicatorDown" src="../images/indicator_down.png"></img>');
                }
            }

            var AVRDURNList = [];
            $("img[alt='graph_1']").next('map').children('area').each(function () {
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
            $("td[alt*='Indicator']").removeAttr('title');
        }
    </script>
</body>
</html>