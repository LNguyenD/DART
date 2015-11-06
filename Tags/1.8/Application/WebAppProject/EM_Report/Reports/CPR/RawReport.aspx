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

                //$("table[name='tbRawData']").css("width", "99.99%");
                                                
                var realHeader = $("table[name='tbRawData']").first();
                var cloneHeader = $("table[name='tbRawData']").last();

                if ($.browser.msie & parseInt($.browser.version, 10) < 10) {
                    cloneHeader.css('table-layout', 'fixed');
                }

                //fix frozen header in IE11
                if (isIE11() || parseInt($.browser.version, 10) < 10) {
                    //header width
                    $('#ifRaw', window.parent.document).contents().find("table[name='tbRawData']").first().css('width', '99.9%');
                    if (window.location.href.toLowerCase().indexOf('awc') > -1) {
                        $('#ifRaw', window.parent.document).contents().find("table[name='tbRawData']").first().css('width', '132.4%');
                    }
                    //make header frozen
                    var parentDiv = cloneHeader.closest('div');
                    if (isIE11()) {
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
                    }
                    else
                    {
                        $('#rvwReportViewerRawData_ctl09').scroll(function () {
                            var scrollTop = $(this).scrollTop();
                            var scrollLeft = $(this).scrollLeft();
                            if (realHeader.length > 0) {
                                if (scrollTop >= 30 && scrollLeft == 0) {
                                    parentDiv.css('top', $(this).scrollTop() - 0 + 'px');
                                }
                                else if (scrollTop == 0 && scrollLeft == 0) {
                                    parentDiv.css('top', 0 + 'px');
                                }
                            }
                        });
                    }

                    //scroll
                    $("#rvwReportViewerRawData_ctl09").height($('#divViewer').height() - 30);
                    $(parent.window).resize(function () {
                        $("#rvwReportViewerRawData_ctl09").height($('#divViewer').height() - 30);
                    });
                }                

                // expand report to fit the container popup
                $("div[id*='VisibleReportContentrvwReportViewerRawData'] table div:gt(0)").css("width", "100%");
                
                //end adjust frozen header in IE

                // remove white space on top of table tbRawData
                //$("table[name='tbRawData']").parents("tr").prev("tr").children("td:first").css("height", "0");

                var numCols = $("table[name='tbRawData'] tr[height=0]").next().children("td:not(:first)").length;
                var colPixcel = Math.round((divViewerWidth - 50) / numCols) + "px";

                $("table[name='tbRawData'] tr[height=0]").next().children("td:not(:first)").css("width", colPixcel);
                $("table[name='tbRawData'] tr[height=0]").next().children("td:(:first)").css("width", "0.1");

                // change report loading panel
                $("div[id*='rvwReportViewerRawData_AsyncWait_Wait']").html("<img src='../../images/loading.gif' complete='complete' /><br /><a href='javascript:$get(&#39;rvwReportViewerRawData_AsyncWait&#39;).control._cancelCurrentPostback(); closedPopup();' style='font-family:Verdana;font-size:8pt;color:#3366CC;'>Cancel</a>");                
                $("div[id*='rvwReportViewerRawData_AsyncWait_Wait']").css({ "border": "0", "background-color": "" });               

                // automatically scroll 1 px to fix the bug that report header not align to cells (frozen header)
                $('#rvwReportViewerRawData_ctl09').scrollTop(1);

                removeTooltips();

                // Hide back to parent report
                $("table[title='Go back to the parent report']").closest('div').next().remove();

                // center the control bar for IE11
                if (isIE11()) {
                    $("div[id='rvwReportViewerRawData_ctl05']").closest('div').css('padding-left', '35%');
                    
                }

                //record viewer
                var recordIframe = $("#ifRecordViewer", window.parent.document);
                var tableHeight = $("table[name='tbRawData']").height() + 100;
                recordIframe.css("height", tableHeight + "px");
                recordIframe.contents().find('#rvwReportViewerRawData_ctl09').css('height', '');

                // Adjust Close icon
                var closeIcon = recordIframe.contents().find("img[alt*='portfolio_detail_close']");
                closeIcon.attr({ 'src': "../../images/ico_close.png" });
                closeIcon.closest('div').css('position', 'fixed');
                closeIcon.closest('div').css({ 'right': '20px', 'top': '28px', 'width': '' });
                closeIcon.css('cursor', 'pointer');

                closeIcon.click(function (event) {
                    event.preventDefault();
                    if (recordIframe.length > 0) {
                        var parentDiv = "";
                        parentDiv = recordIframe.parent('div');
                        var otherIFrame = parentDiv.find('iframe').first();
                        $("iframe#" + otherIFrame.attr('id'), window.parent.document).show();
                        recordIframe.remove();
                    }
                    
                });
                //end record viewer

                //add Total claim to report viewer toolbar
                var targetDiv = $("div[id^='rvwReportViewerRawData'] > div > div").first();
                var extendText = $("table[name='tbRawData']").attr('alt');
                if (extendText != 'CPRGraph') {
                    var extendDiv = "<div id='totalClaim'><label>" + extendText + "</label></div>"
                }
                if ($("#totalClaim").length <= 0 && typeof(extendText) == 'string') {
                    targetDiv.after(extendDiv);
                }
                $("#totalClaim").attr('style', targetDiv.attr('style'));
                $("#totalClaim").css({ 'margin-top': '8px', 'margin-left': '5px', 'font-weight': 'bold', 'display' : 'inline-block' });
                $("table[name='tbRawData']").removeAttr('title');

                if (document.URL.toLowerCase().indexOf('cpr') >= 0) {
                    //adjust table width after removing NCMM from CPR raw data
                    if ($.browser.msie) {
                        if (document.URL.toLowerCase().indexOf('wow') >= 0) {
                            $("table[ALT*='Claims:']").css('width', '135%');
                            $("table[ALT*='CPRGraph']").css('width', '99.9%');
                        }
                        else {
                            $("table[name='tbRawData']").css('width', '113%');
                        }
                    }
                    else {
                        if (document.URL.toLowerCase().indexOf('wow') >= 0) {
                            $("table[ALT*='Claims:']").css('width', '135%');
                            $("table[ALT*='CPRGraph']").css('width', '99.9%');
                        }
                        else {
                            $("table[name='tbRawData']").css('width', '106%');
                        }
                    }
                }
                else {
                    $("table[name='tbRawData']").css("width", "99.99%");
                }
            }
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
