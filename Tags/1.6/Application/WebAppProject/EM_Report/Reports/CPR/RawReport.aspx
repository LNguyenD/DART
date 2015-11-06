<%@  Language="C#" AutoEventWireup="true" CodeBehind="RawReport.aspx.cs"
    Inherits="EM_Report.EMReports.RawReport" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head011" runat="server">
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
                parent.window.location = parent.window.g_baseUrl + '/account/login?logout=true&ssrs=lost';
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

                $('#divViewer').height(ifHeight + 'px');
                $('#ifRaw', window.parent.document).height(ifHeight + 'px');

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

                //fix frozen header in IE11
                if (isIE11()) {
                    //header width
                    $('#ifRaw', window.parent.document).contents().find("table[name='tbRawData']").first().css('width', '119.4%');
                    if (window.location.href.toLowerCase().indexOf('awc') > -1) {
                        $('#ifRaw', window.parent.document).contents().find("table[name='tbRawData']").first().css('width', '132.4%');
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

                //adjust frozen header in IE9
                var w = $("table[name='tbRawData']").first().width();
                var originalStyle = $("table[name='tbRawData']").attr('style');
                if (originalStyle != null) {
                    originalStyle = originalStyle.replace("width: 99.99%", "width:" + w + "px !important");
                }
                $("table[name='tbRawData']").last().attr('style', originalStyle);

                // expand report to fit the container popup
                $("div[id*='VisibleReportContentrvwReportViewerRawData'] table div:gt(0)").css("width", "100%");
                
                //end adjust frozen header in IE

                // remove white space on top of table tbRawData
                $("table[name='tbRawData']").parents("tr").prev("tr").children("td:first").css("height", "0");

                var numCols = $("table[name='tbRawData'] tr[height=0]").next().children("td:not(:first)").length;
                var colPixcel = Math.round((divViewerWidth - 50) / numCols) + "px";

                $("table[name='tbRawData'] tr[height=0]").next().children("td:not(:first)").css("width", colPixcel);
                $("table[name='tbRawData'] tr[height=0]").next().children("td:(:first)").css("width", "0");

                // change report loading panel
                $("div[id*='rvwReportViewerRawData_AsyncWait_Wait']").html("<img src='../../images/loading.gif' complete='complete' /><br /><a href='javascript:$get(&#39;rvwReportViewerRawData_AsyncWait&#39;).control._cancelCurrentPostback(); closedPopup();' style='font-family:Verdana;font-size:8pt;color:#3366CC;'>Cancel</a>");
                $("div[id*='rvwReportViewerRawData_AsyncWait_Wait']").css({ "border": "0", "background-color": "" });

                if (document.documentMode == 7) {
                    //$('#rvwReportViewerRawData_ctl09 table tr td div:eq(0)').width('100%');
                    //$('#rvwReportViewerRawData_ctl09 table tr td div:eq(0) div').width('100%');
                    //$('#rvwReportViewerRawData_ctl09 table tr td div:eq(1)').css('left', '0px');
                }

                // automatically scroll 1 px to fix the bug that report header not align to cells (frozen header)
                $('#rvwReportViewerRawData_ctl09').scrollTop(1);

                removeTooltips();
            }
        }

        function closedPopup() {
            $(".viewRawDataContent", window.parent.document).fadeOut('slow', function () {
                $("#overlay", window.parent.document).fadeOut('fast');
            });
        }

        function saveAsExcel() {
            var reportViewerRawData = $find("rvwReportViewerRawData");
            if (reportViewerRawData != null) {
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

        function removeTooltips() {
            $('table[alt="portfolio"]').attr("title", '');
        }

        function isIE11() {
            if (!!navigator.userAgent.match(/Trident\/7\./))
                return true;

            return false;
        }
    </script>
</body>
</html>
