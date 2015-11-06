<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Schedule.aspx.cs" Inherits="EM_Report.EMReports.Popup.Schedule" %>
<%@ Register src="../UserControls/CustomTime.ascx" tagname="CustomTime" tagprefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    
</head>
<body>
<script src="../../Scripts/jquery-1.5.1.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery-1.5.1.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery-ui-1.8.16.custom.min.js" type="text/javascript"></script>
    <link href="../../Css/jquery/jquery.ui.dialog.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/JScript1.js" type="text/javascript"></script>
    <style type="text/css">
        .ScheduleForm
        {
            font:12px "Tahoma",sans-serif;
        }
         .time-input-1
         {
             width:28px;
         }
         .time-view
         {
             margin:10px 0 0 30px;
         }
         .time-view-details
         {
             border:1px solid #AAA;
             padding:10px;
         }
         .time-type-title
         {
             font-weight:bold;
         }
         .cblDayDays
         {
             margin:0 0 0 20px;
         }
    </style>
    <script type="text/javascript">
        $(function () {
        })
        function CloseDialog() {
            alert($("body").html());
        }
    </script>

    <form id="ScheduleForm" class="ScheduleForm" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div>
        <asp:HiddenField runat="server" ID="hddScheduleXML"/>
        Choose whether to run the report on an hourly, daily, weekly, monthly, or one time basis.
        <br />
        All times are expressed in (GMT +07:00) SE Asia Standard Time. 
        <%--<asp:Label runat="server" ID="lblGMTTime">text</asp:Label>--%>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table style="height:290px">
            <tr>
            <td valign="top">
            <asp:Panel CssClass="time-selection" ID="Panel1" runat="server">
                <asp:RadioButtonList ID="rblTimes" runat="server" AutoPostBack="True" 
                    onselectedindexchanged="RadioButtonList1_SelectedIndexChanged">
                <asp:ListItem Selected="True">Hour</asp:ListItem>
                <asp:ListItem>Day</asp:ListItem>
                <asp:ListItem>Week</asp:ListItem>
                <asp:ListItem>Month</asp:ListItem>
                <asp:ListItem>Once</asp:ListItem>
                </asp:RadioButtonList>
            </asp:Panel>
            </td>
            <td valign="top">
            <asp:MultiView ID="mvwSchedule" runat="server" ActiveViewIndex="0">
                <asp:View runat="server" ID="vwHour">
                    <div class="time-view">
                        <span class="time-type-title">Hourly Schedule</span>
                        <div class="time-view-details">
                            Run the schedule every:<br />
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <input class="time-input-1" runat="server" id="txtHH" value="1" /> hours&nbsp;&nbsp;
                            <input class="time-input-1" runat="server" id="txtHM" value="00" /> minutes
                        </div>
                    </div>
                </asp:View>
                <asp:View runat="server" ID="vwDay">
                <div class="time-view">
                    <span class="time-type-title">Daily Schedule</span>
                    <div class="time-view-details">
                        <asp:RadioButton Checked="true" GroupName="DaySchedule" runat="server" ID="radDayDays" Text="On the following days" />
                            <asp:CheckBoxList ID="cblDayDays" CssClass="cblDayDays" runat="server"  RepeatDirection="Horizontal">
                                <asp:ListItem>Sun</asp:ListItem>
                                <asp:ListItem>Mon</asp:ListItem>
                                <asp:ListItem>Tue</asp:ListItem>
                                <asp:ListItem>Wed</asp:ListItem>
                                <asp:ListItem>Thu</asp:ListItem>
                                <asp:ListItem>Fri</asp:ListItem>
                                <asp:ListItem>Sat</asp:ListItem>
                            </asp:CheckBoxList>
                        <%--<asp:RadioButton GroupName="DaySchedule" runat="server" ID="radEveryWeekDay" Text="Every weekday" />--%>
                        <br />
                        <asp:RadioButton GroupName="DaySchedule" runat="server" ID="radDayRepeat" Text="Repeat after this number of days:"/>
                            <asp:TextBox runat="server" CssClass="time-input-1" ID="txtDayRepeat">1</asp:TextBox>
                    </div>
                </div>
                </asp:View>
                <asp:View runat="server" ID="vwWeek">
                <div class="time-view">
                    <span class="time-type-title">Weekly Schedule</span>
                    <div class="time-view-details">
                        Repeat after this number of weeks:
                        <asp:TextBox runat="server" ID="txtReapeatWeek" CssClass="time-input-1">1</asp:TextBox>
                        <br />
                        On day(s): 
                        <asp:CheckBoxList ID="cblWeekDays" CssClass="cblDayDays" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem>Sun</asp:ListItem>
                            <asp:ListItem Selected="True">Mon</asp:ListItem>
                            <asp:ListItem>Tue</asp:ListItem>
                            <asp:ListItem>Wed</asp:ListItem>
                            <asp:ListItem>Thu</asp:ListItem>
                            <asp:ListItem>Fri</asp:ListItem>
                            <asp:ListItem>Sat</asp:ListItem>
                        </asp:CheckBoxList>
                    </div>
                </div>
                </asp:View>
                <asp:View runat="server" ID="vwMonth">
                <div class="time-view">
                    <span class="time-type-title">Monthly Schedule</span>
                    <div class="time-view-details">
                        Months: 
                        <asp:CheckBoxList ID="cblMonthsOfYear" CssClass="cblDayDays" runat="server" 
                            RepeatDirection="Horizontal" RepeatColumns="3">
                            <asp:ListItem Selected="True">Jan</asp:ListItem>
                            <asp:ListItem Selected="True">Apr</asp:ListItem>
                            <asp:ListItem Selected="True">Jul</asp:ListItem>
                            <asp:ListItem Selected="True">Oct</asp:ListItem>
                            <asp:ListItem Selected="True">Feb</asp:ListItem>
                            <asp:ListItem Selected="True">May</asp:ListItem>
                            <asp:ListItem Selected="True">Aug</asp:ListItem>
                            <asp:ListItem Selected="True">Nov</asp:ListItem>
                            <asp:ListItem Selected="True">Mar</asp:ListItem>
                            <asp:ListItem Selected="True">Jun</asp:ListItem>
                            <asp:ListItem Selected="True">Sep</asp:ListItem>
                            <asp:ListItem Selected="True">Dec</asp:ListItem>
                        </asp:CheckBoxList>
                        <br />
                        <asp:RadioButton Checked="true" runat="server" ID="radWOM" GroupName="Month" Text="On week of month: "/>
                        <asp:DropDownList runat="server" ID="drlWOM">
                            <asp:ListItem>1st</asp:ListItem>
                            <asp:ListItem>2nd</asp:ListItem>
                            <asp:ListItem>3rd</asp:ListItem>
                            <asp:ListItem>4th</asp:ListItem>
                            <asp:ListItem>Last</asp:ListItem>
                        </asp:DropDownList>
                        <br />
                        &nbsp;&nbsp;&nbsp;&nbsp; On day of week:
                        <asp:CheckBoxList ID="cblMonthDays" CssClass="cblDayDays" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem>Sun</asp:ListItem>
                            <asp:ListItem Selected="True">Mon</asp:ListItem>
                            <asp:ListItem>Tue</asp:ListItem>
                            <asp:ListItem>Wed</asp:ListItem>
                            <asp:ListItem>Thu</asp:ListItem>
                            <asp:ListItem>Fri</asp:ListItem>
                            <asp:ListItem>Sat</asp:ListItem>
                        </asp:CheckBoxList>
                        <br />
                        <asp:RadioButton runat="server" ID="radOnCalDays" GroupName="Month" Text="On calendar day(s): "/>
                        <asp:TextBox runat="server" ID="txtOnCalDays">1, 3-5</asp:TextBox>
                    </div>
                </div>
                </asp:View>
                <asp:View runat="server" ID="vwOnce">
                <div class="time-view">
                    <span class="time-type-title">One-time Schedule</span>
                    <div class="time-view-details">
                        Runs only once on below start time. <br />
                        <span style="color:Blue">This subscripton will be automatically deleted when it expired</span>
                    </div>
                </div>
                </asp:View>
            </asp:MultiView>
            </td>
            </tr>
            </table>
            <uc2:CustomTime ID="ctStartTime" runat="server" />
        </ContentTemplate>
        </asp:UpdatePanel>
        <div>
            <h3>Start and end dates</h3>
            Specify the date to start and optionally end this schedule.
            <br />
            Begin running his schedule on: 
            <asp:TextBox runat="server" ID="txtStartDate"></asp:TextBox> &nbsp;&nbsp; DD/MM/YYYY
            <br />
            <asp:CheckBox runat="server" ID="chbEndDate" Text="Stop this schedule on: "/>
            <asp:TextBox runat="server" ID="txtEndDate"></asp:TextBox> &nbsp;&nbsp; DD/MM/YYYY
        </div>
        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
            <ContentTemplate>
                <div>
                    <asp:Button runat="server" CssClass="ui-dialog-titlebar-close ui" ID="btnOK" Text="OK" onclick="btnOK_Click" OnClientClick="CloseDialog();"/>
                    <asp:Button runat="server" CssClass="ui-dialog-titlebar-close ui" ID="btnCancel" Text="Cancel" OnClientClick="CloseDialog();"
                        onclick="btnCancel_Click"/>
                        <input type="button" value="Save" onclick="Save();"/>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    </form>
</body>
</html>

