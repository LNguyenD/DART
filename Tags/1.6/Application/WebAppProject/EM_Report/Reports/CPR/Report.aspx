<%@  Language="C#" AutoEventWireup="true" CodeBehind="Report.aspx.cs" Inherits="EM_Report.EMReports.Report" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head011" runat="server">
    <title></title>
    <script src="../../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery-ui-1.8.11.min.js" type="text/javascript"></script>
    <script src="<%=EM_Report.Helpers.FileVersioning.AppendVersion("../../Scripts/jquery.columnmanager.js") %>" type="text/javascript"></script>
    <script src="<%=EM_Report.Helpers.FileVersioning.AppendVersion("../../Scripts/iPortfolio.js") %>" type="text/javascript"></script>
    <style type="text/css">
        .hoverCell div {
            color: #037baf !important;
            font-weight: bold !important;
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

        // CONSOLE.LOG() cause some errors on IE when not open IE DEVELOPER TOOL

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

        function AdjustReport() {
            var viewer = document.getElementById("<%=rvwReportViewer.ClientID %>");
            var tbOwner = $("div[id*='VisibleReportContentrvwReportViewer'] table:first");
            var portfolioTable = $("table[alt*='portfolio']");

            // get height of report viewer content
            var ifHeight = tbOwner.height();

            // change report loading panel                
            $("div[id*='rvwReportViewer_AsyncWait_Wait']").html("<img src='../../images/loading.gif' complete='complete' />");
            $("div[id*='rvwReportViewer_AsyncWait_Wait']").css({ "border": "0", "background-color": "" });

            var loading = $("#rvwReportViewer_AsyncWait_Wait").is(':visible');
            if (loading) {
                // supply a additional number for loading icon area
                ifHeight = ifHeight + 78;
            }

            $('#divViewer').height(ifHeight + 'px');
            $("td[id*='oReportCell'] > div").css("width", "100%");
            $("td[id*='oReportCell'] > div > div").css("width", "100%");
            //$("td[id*='oReportCell'] > div > div > div").css("width", "100%");
            $("td[id*='oReportCell']").closest("table").css("width", "100%");
            $("td[id*='oReportCell']").find("table").css("width", "100%");
            //$("td[id*='oReportCell']").find("td").attr("align", "left");

            //$("div[title='width_30']").css("width", "99%");
            //$("div[title='width_100']").css("width", "100%");
            //$("div[imgConImage='AutoSize']").parent("td").attr("align", "left");
            //$("img[title='width_100']").parent("div").css("width", "100%");

            //$("td[id*='oReportCell']").children().attr("align", "left");
            portfolioTable.parent().parent().parent().attr("align", "left");
            portfolioTable.css("width", "99.99%");

            if (ifHeight > 78) {
                adjustPortfolioReportSize();
                registerExpandCollapseAction($('table[alt*="portfolio"]'));

                // update PORT Numbers
                updatePORTNumbers(portfolioTable);
            }

            // fix empty values
            portfolioTable.find('a').each(function () {
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
                        parent.openRawDataPopup('/Report/ReportRawData', queryString);
                    });
                }
            });
        }

        function viewerPropertyChanged(sender, e) {
            if (e.get_propertyName() == "isLoading") {
                AdjustReport();

                //Remove all title attribute
                RemoveTitle();

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
                        //console.log('complete tab 1');
                    }
                        //complete tab 2
                    else if (parent.DataContentL2Tab1 != null && parent.DataContentL2Tab2 != null) {
                        //console.log('complete tab 2');
                        parent.loadedL2EndTab++;
                        if (parent.loadedL2EndTab == 2) {
                            //console.log('complete');
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
                        //console.log('complete tab 1');
                    }
                        //complete tab 3
                    else if (parent.DataContentL2Tab1 != null && parent.DataContentL2Tab2 != null
                                && parent.DataContentL2Tab3 != null) {
                        //console.log('complete tab 3');
                        parent.loadedL2EndTab++;
                        if (parent.loadedL2EndTab == 2) {
                            //console.log('complete in 3');
                            parent.canTabClick = true;
                            if (document.URL.indexOf('Type=account_manager') >= 0
                                    && $('#ifReportCover_AccountManager', window.parent.document).css("height") == "0px") {
                                //$('#ifReportCover_AccountManager', window.parent.document).css("display", "none");
                            }
                        }
                    }
                        //complete tab 2
                    else if (parent.DataContentL2Tab1 != null) {
                        //console.log('complete tab 2');
                        parent.loadedL2SecondTab++;
                        if (parent.loadedL2SecondTab == 2) {
                            //console.log('complete in 2');
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
        }

        function adjustPortfolioReportSize() {
            // increase height to remove vertical scrollbar
            var portfolioTable = $("table[alt*='portfolio']");
            var portfolioAlt = portfolioTable.attr('alt');
            if (typeof (portfolioAlt) === 'undefined')
                return;

            var type = portfolioAlt.replace('portfolio_', '');
            var iframe = $('iframe', window.parent.document).filter(function () {
                return $(this).attr('id').toLowerCase().indexOf(type.toLowerCase()) > -1;
            });

            // hide PORT Numbers table
            var portLookupTable = $('table[alt="tbPORTLookup"]');
            portLookupTable.hide();
            portLookupTable.parent().css('height', '');
            portfolioTable.closest('tbody').children('tr:eq(0)').children('td').css({ 'width': '', 'min-width': '' });
            portfolioTable.parents('table:eq(2)').css({'min-width': '', 'height': ''});
            portfolioTable.parent().css('height', '');
            portfolioTable.closest('tr').next('tr').children('td').css({ 'height': '' });

            parent.adjustPortfolioReportSize(iframe, portfolioTable);
        }

        function updatePORTNumbers(portTable) {
            var portLookupTable = $('table[alt="tbPORTLookup"]');

            
            
            //// update PORT Numbers
            //portLookupTable.find('div[alt^="PORTNumbers_"]').each(function () {
            //    var jsonPORTRow = JSON.parse($(this).text());
                
            //    var lookupKey = $(this).attr("alt").replace("PORTNumbers_", "").replace(/\s/g, "");

            //    var portTableRowCells = portTable.find('td[alt^="' + lookupKey + '"]');
            //    portTableRowCells.each(function () {
            //        var portTableRowCell = $(this);

            //        jsonKey = $(this).attr("alt").replace(lookupKey + ";", "");
            //        $.grep(jsonPORTRow, function (e, i) {
            //            if (e["key"] == jsonKey)
            //            {
            //                // update PORT number
            //                portTableRowCell.find("a").text(e["value"]);
            //            }
            //        });
            //    });
            //});
        }

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
        }
    </script>
</body>
</html>
