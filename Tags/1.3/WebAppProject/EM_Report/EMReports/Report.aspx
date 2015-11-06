<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Report.aspx.cs" Inherits="EM_Report.SSRS.Report" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>    
    <style type="text/css">
        .ac-list
        {
            font-family: Verdana;
            font-size: 8pt;
            width:800px !important;
            height:300px;
            overflow:auto;
        }
        .ac-list > li > a 
        {
            display:block;
            padding:3px !important;
        }
        .ac-list > li > a > span.right
        {
            left: 150px;
            position: absolute;
            font-size: 7pt;
        }
        .hidden {
            visibility:hidden;
        }
    </style>
    <%--<script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>--%>
    <script type="text/javascript" language="javascript">
//        function loadreport() {            
//            $("#ReportParamValues").val('');
//            parent.$("[id^='prm']").each(function () {
//                var value = '';                          
//                if ($(this).attr("type") == "checkbox") {
//                    value = $(this).attr("checked") == "true" || $(this).attr("checked")=="checked" ? true : false;
//                } else {
//                    value = $(this).val();
//                }
//                $("#ReportParamValues").val($("#ReportParamValues").val() + $(this).attr("id") + "|" + value + ";");
//            });

//            var runNormal = true;

//            // Employer Notification Report
//            if (document.URL.indexOf("EmployerNotificationReport") > 0) {
//                var prmArr = $("#ReportParamValues").val().split(';');
//                for (var i in prmArr) {
//                    var nv = prmArr[i].split('|');
//                    if (nv[0] == 'prmAll_Agencies_in_one') {
//                        if (nv[1] == 'false') {
//                            $("#ExLoading").show();
//                            runNormal = false;
//                            $.post(window.url.substr(0, url.indexOf("/EMReports/")) + "/Report/ExportFile",
//                            { strParams: $("#ReportParamValues").val(),
//                                reportPath: '/EMReporting/Reports/EmployerNotificationReport',
//                                exportFormat: 'pdf'
//                            },
//                            function (data) {
//                                $("#ExLoading").hide();
//                                $("body").append("<div id='exportmessage'/>");
//                                confirmOK("Message", data.html);
//                                if (data.issuccess) {
//                                    document.location = window.url.substr(0, url.indexOf("/EMReports/")) + "/Report/RenderExport";
//                                }
//                            }).error(function (data) {
//                                $("#ExLoading").hide();
//                                confirmOK("Message", data.html);
//                            });
//                        }
//                    }
//                }
//            }

//            if (runNormal == true)
//                $("#cmdUpdateParam").click();
//            return false;
//        }            
</script>
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager runat="server" ID="scriptManager" AsyncPostBackTimeout="1800" EnablePageMethods="true">
    </asp:ScriptManager>
    <div>
        <rsweb:ReportViewer  CssClass="report-viewer" ID="rvwReportViewer" runat="server"  Width="100%" Height="590px" OnPreRender="rvwReportViewer_PreRender" ShowCredentialPrompts="false" AsyncRendering="true" ShowParameterPrompts="false" ShowRefreshButton="true" >
        </rsweb:ReportViewer>
        <input type="hidden" id="ReportParamValues" runat="server" value="" />
        <asp:Button runat="server" ID="cmdUpdateParam" Text="UpdateParam" onclick="cmdUpdateParam_Click" CssClass="hidden"/>
    </div>     
    </form>
</body>
</html>
