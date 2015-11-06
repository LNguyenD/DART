<%@  Language="C#" AutoEventWireup="true" CodeBehind="RawDashboardReport.aspx.cs"
    Inherits="EM_Report.DashboardReports.RawDashboardReport" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head011" runat="server">
	<meta http-equiv="X-UA-Compatible" content="IE=11; IE=10; IE=9; IE=8; IE=7; IE=EDGE; IE=EmulateIE7; IE=EmulateIE8" />
    <title></title>
    <script src="../../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
</head>
<body style="margin: 0;">
    <form id="form1" runat="server">
    <asp:ScriptManager runat="server" ID="ScriptManager1">
    </asp:ScriptManager>
    <div align="center" id="divViewer" style="height: 100%; width: 100%; overflow: auto">
        <rsweb:ReportViewer CssClass="reportViewer" ID="rvwReportViewerRawData" runat="server"
            Width="100%" Height="100%" ShowCredentialPrompts="false" AsyncRendering="true"
            ShowParameterPrompts="false" ShowRefreshButton="true" ShowToolBar="true" ShowZoomControl="false" ShowPrintButton="false">
        </rsweb:ReportViewer>
    </div>
    </form>
    <script type="text/javascript" language="javascript">
        $(document).ready(function () {
            // detect report lost session problem
            var htmlContent = $("div[id='divViewer']").html();
            var uSess = '<%=EM_Report.Helpers.Base.LoginSession %>';
            if (htmlContent.indexOf('attempt to connect to the report server failed') >= 0 || uSess == "") {
                //parent.window.location = parent.window.g_baseUrl + '/account/login?logout=true&ssrs=lost';

                var returnUrl = document.referrer;
                parent.window.location = parent.window.g_baseUrl + '/account/login?returnUrl=' + encodeURIComponent(returnUrl);
            }
        });

        Sys.Application.add_load(function () {
            $find("rvwReportViewerRawData").add_propertyChanged(viewerPropertyChanged);
        });

        function viewerPropertyChanged(sender, e) {
            if (e.get_propertyName() == "isLoading") {
                var viewer = document.getElementById("<%=rvwReportViewerRawData.ClientID %>");
                var tbOwner = $("div[id*='VisibleReportContentrvwReportViewerRawData'] table:first");

                var ifHeight = tbOwner.height();

                var loading = $("#rvwReportViewerRawData_AsyncWait_Wait").is(':visible');
                if (loading) {
                    // supply a additional number for loading icon area
                    ifHeight = ifHeight + 78;
                }
                else {
                    //adjust the pop up height base on the window
                    ifHeight = parent.windowHeight - 100;
                }

                if (ifHeight > 500) {
                    ifHeight = 500;
                }

                if (document.URL.indexOf("=raw-") >= 0 || document.URL.indexOf("Graph=Raw") >= 0) {                    
                    $('#ifRaw2', window.parent.document).height(ifHeight + 'px');
                    $('#ifRaw3', window.parent.document).height(ifHeight + 'px');
                }
                else if (document.URL.indexOf("=Metric") >= 0) {
                    
                    $('#ifRaw3', window.parent.document).height(ifHeight + 'px');
                }
                else {
                    
                    $('#ifRaw', window.parent.document).height(ifHeight + 'px');
                }

                $('#divViewer').height(ifHeight + 'px');
                $('#divViewer').css("background-color", "#fff");

                //fix scroll bar issue in IE
                if ($.browser.msie || isIE11()) {
                    $('#divViewer').css('overflow', 'hidden');
                }

                var divViewerWidth = $('#divViewer').width();

                $("div[id*='VisibleReportContentrvwReportViewerRawData'] table").css("width", "100%");

                $("table > tbody > tr[height=0]").first().closest("table").attr("name", "tbRawData");
                //assign a name to frozen panes
                $("table > tbody > tr[height=0]").last().closest("table").attr("name", "tbRawData");

                $("table[name='tbRawData']").css("width", "99.99%");

                var realHeader = $("table[name='tbRawData']").first();
                var cloneHeader = $("table[name='tbRawData']").last();

                if ($.browser.msie & parseInt($.browser.version, 10) < 10) {
                    cloneHeader.css('table-layout', 'fixed');
                }
                
                //fix frozen header in IE11
                if (isIE11() || parseInt($.browser.version, 10) < 10) {
                    if (isIE11()) {
                        //header width of 1st tab
                        $('#ifRaw', window.parent.document).contents().find("table[name='tbRawData']").first().css('width', '119.4%');
                        if (window.location.href.toLowerCase().indexOf('awc') > -1) {
                            $('#ifRaw', window.parent.document).contents().find("table[name='tbRawData']").first().css('width', '132.4%');
                        }
                    }
                    else
                    {
                        //header width of 1st tab
                        $('#ifRaw', window.parent.document).contents().find("table[name='tbRawData']").first().css('width', '99.99%');
                        if (window.location.href.toLowerCase().indexOf('awc') > -1) {
                            $('#ifRaw', window.parent.document).contents().find("table[name='tbRawData']").first().css('width', '99.99%');
                        }
                    }
                    //make header frozen
                    var parentDiv = cloneHeader.closest('div');
                    $('#divViewer').scroll(function () {
                        var scrollTop = $(this).scrollTop();
                        var scrollLeft = $(this).scrollLeft();
                        if (realHeader.length > 0) {
                            if (scrollTop >= 30 && scrollLeft == 0) {
                                parentDiv.css('top', $(this).scrollTop() - 30 + 'px');
                            }
                            else if (scrollTop == 0 && scrollLeft == 0) {
                                parentDiv.css('top', 0 + 'px');
                            }
                        }
                    });

                    //scroll
                    $("#rvwReportViewerRawData_ctl09").height($('#divViewer').height() - 30);
                    $(parent.window).resize(function () {
                        $("#rvwReportViewerRawData_ctl09").height($('#divViewer').height() - 30);
                    });
                }

                ////adjust frozen header in IE9
                //var w = realHeader.width();
                //var originalStyle = realHeader.attr('style');
                //if (originalStyle != null && !isIE11) {
                //    originalStyle = originalStyle.replace("width: 99.99%", "width:" + w + "px !important");
                //}
                //cloneHeader.attr('style', originalStyle);
                ////end adjust frozen header in IE

                // remove white space on top of table tbRawData
                $("table[name='tbRawData']").parents("tr").prev("tr").children("td:first").css("height", "0");

                var numCols = $("table[name='tbRawData'] tr[height=0]").next().children("td:not(:first)").length;
                var colPixcel = Math.round((divViewerWidth - 50) / numCols) + "px";

                $("table[name='tbRawData'] tr[height=0]").next().children("td:not(:first)").css("width", colPixcel);
                $("table[name='tbRawData'] tr[height=0]").next().children("td:(:first)").css("width", "0.1");

                // change report loading panel
                $("div[id*='rvwReportViewerRawData_AsyncWait_Wait']").html("<img src='../../images/loading.gif' complete='complete' /><br /><a href='javascript:$get(&#39;rvwReportViewerRawData_AsyncWait&#39;).control._cancelCurrentPostback(); closedPopup();' style='font-family:Verdana;font-size:8pt;color:#3366CC;'>Cancel</a>");                
                $("div[id*='rvwReportViewerRawData_AsyncWait_Wait']").css({ "border": "0", "background-color": "" });

                // automatically scroll 1 px to fix the bug that report header not align to cells (frozen header)
                $('#rvwReportViewerRawData_ctl09').scrollTop(1);                

                parent.RawDataContentTab1 = $('#ifRaw', window.parent.document).contents().find("table[name='tbRawData']").html();
                parent.RawDataContentTab2 = $('#ifRaw2', window.parent.document).contents().find("table[name='tbRawData']").html();
                parent.RawDataContentTab3 = $('#ifRaw3', window.parent.document).contents().find("table[name='tbRawData']").html();

                if (!isIE11()) {
                    $("table[name='tbRawData']").parent().css("width", "");
                    $("table[name='tbRawData']").closest("div").parent().css("width", "");
                }

                // Hide back to parent report
                $("table[title='Go back to the parent report']").closest('div').next().remove();

                // center the control bar for chrome
                if (!$.browser.msie) {
                    $("div[id='rvwReportViewerRawData_ctl05']").closest('div').css('padding-left', '30%');
                }

                // center the control bar for IE11
                if (isIE11()) {
                    $("div[id='rvwReportViewerRawData_ctl05']").closest('div').css('padding-left', '35%');                    
                }                                                               

                $('#rvwReportViewerRawData_ctl09').scrollLeft(1);                

                openRecordViewer();

                //add Total claim to report viewer toolbar
                var targetDiv = $("div[id^='rvwReportViewerRawData'] > div > div").first();
                var extendText = $("table[name='tbRawData']").attr('alt');
                var extendDiv = "<div id='totalClaim'><label>" + extendText + "</label></div>"
                if ($("#totalClaim").length <= 0 && typeof (extendText) == 'string') {
                    targetDiv.after(extendDiv);
                }
                $("#totalClaim").attr('style', targetDiv.attr('style'));
                $("#totalClaim").css({ 'margin-top': '8px', 'margin-left': '5px', 'font-weight': 'bold', 'display' : 'inline-block' });
                $("table[name='tbRawData']").removeAttr('title');                
                
                if (parent.RawDataContentTab3 != null) {
                    // case: tab 3 is complete

                    parent.canTabClick_RawData = true;

                    parent.HideContentTab3++
                    if (parent.HideContentTab3 == 2) {
                        if ($('#ifRaw3Cover', window.parent.document).css("height") == "0px") {
                            //$('#ifRaw3Cover', window.parent.document).css("display", "none");
                        }
                    }

                    $("table[name='tbRawData']").parents("div").css("width", "100%");
                    $("table[name='tbRawData']").parents('table').css("width", "100%");
                    $("table[name='tbRawData']").parents('table').parents("div").css("width", "100%");
                    //$("table[name='tbRawData'] td").css({ 'width': 'auto', 'min-width': '0' });
                    $("table[name='tbRawData'] td").attr('align', 'center');
                }
                else if (parent.RawDataContentTab2 != null && parent.loadedTab2 == false) {
                    // case: tab 2 is complete

                    if (!parent.isLastLevel()) {
                        parent.Load_Thirth_Tab_RawData();
                    }


                    parent.canTabClick_RawData = true;
                    parent.loadedTab2 = true;

                    $("table[name='tbRawData']").parents("div").css("width", "100%");
                    $("table[name='tbRawData']").parents('table').css("width", "100%");
                    $("table[name='tbRawData']").parents('table').parents("div").css("width", "100%");
                    $("table[name='tbRawData'] td").attr('align', 'center');
                }
                else if (parent.RawDataContentTab1 != null && parent.loadedTab1 == false) {
                    // case: tab 1 is complete

                    parent.Load_Second_Tab_RawData();
                    parent.canTabClick_RawData = true;
                    parent.loadedTab1 = true;

                    //adjust raw data pop up
                    var popupHeight = $(".viewRawDataContent", window.parent.document).height();
                    var popupWidth = $(".viewRawDataContent", window.parent.document).width();
                    var top = (parent.windowHeight / 2) - (popupHeight / 2);

                    $(".viewRawDataContent", window.parent.document).css("top", top + "px");
                    $("table[name='tbRawData']").css("float", "left");

                    if ($.browser.msie == false || $.browser.version.substr(0, 1) > 7) {
                        $("table[name='tbRawData']").parents("div").css("width", "100%");
                        $("table[name='tbRawData']").parents('table').css("width", "100%");
                        $("table[name='tbRawData']").parents('table').parents("div").css("width", "100%");
                        $("table[name='tbRawData'] td").css({ 'width': 'auto', 'min-width': '0' });
                        $("table[name='tbRawData'] td").attr('align', 'center');
                    }                   
                }
                if (parent.RawDataContentTab2 != null) {

                    parent.HideContentTab2++;
                    if (parent.HideContentTab2 == 2) {
                        if ($('#ifRaw2Cover', window.parent.document).css("height") == "0px") {
                            //$('#ifRaw2Cover', window.parent.document).css("display", "none");
                        }
                    }
                }
            }
        }        

        function openRecordViewer() {
            $("iframe[id*='ifRaw']", window.parent.document).not(":first").each(function () {
                var parentIframe = $(this);
                parentIframe.contents().find("table[name='tbRawData']").find("div[alt='claim_no']").each(function () {
                    var table = $(this);
                    var a = table.find('a');
                    var href = a.attr("href");
                    href = href.replace("javascript:openPortfolioRawDataPopup('", "");
                    href = href.replace("')", "");
                    href = href.replace("reportname=", "");
                    href = parent.g_baseUrl + "/Reports/CPR/RawReport.aspx?reportpath=/emreporting/reports/" + href;
                    a.attr('href', 'javascript:void(0)');

                    var newIframe = '<iframe id="ifRecordViewer" src="' + href + '" width="100%" frameborder="0" scrolling="no" style="margin-top: 0px; display: inline;"></iframe></div>';

                    a.click(function (event) {
                        event.preventDefault();
                        if (href.indexOf('javascript:void(0)') < 0) {
                            parentIframe.after(newIframe);
                            parentIframe.hide();
                        }
                    });

                    //make it look clickable
                    a.css('color', 'blue');

                    //remove tooltip
                    table.removeAttr('title');
                });
            });
        }

        function saveAsExcel() {
            var reportViewerRawData = $find("rvwReportViewerRawData");
            var stillonLoadState = reportViewerRawData.get_isLoading();

            if (!stillonLoadState) {
                reportViewerRawData.exportReport('EXCEL');
            }
        }

        function adjustHeaderCells(cloneHeader, realHeader) {
            realHeader.find("tr[height='0']").next().children("td:not(:first)").each(function (index1) {
                var realWidth = $(this).children('div').width();
                if (index1 == 7) {
                    realWidth = realWidth + 20;
                }
                $(this).children('div').attr('name', realWidth);
                cloneHeader.find("tr[height='0']").next().children("td:not(:first)").each(function (index2) {
                    if (index2 == index1) {
                        $(this).children('div').width(realWidth);
                    }
                });
            });
        }

        function isIE11() {
            if (!!navigator.userAgent.match(/Trident\/7\./))
                return true;

            return false;
        }
    </script>
</body>
</html>