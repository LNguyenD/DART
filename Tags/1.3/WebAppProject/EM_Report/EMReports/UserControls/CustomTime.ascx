<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomTime.ascx.cs" Inherits="EM_Report.EMReports.UserControls.CustomTime" %>

Start time of day: 
<input class="time-input-1" runat="server" id="txtHour" value="1" /> :
<input class="time-input-1" runat="server" id="txtMinute" value="00" /> 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
<asp:RadioButton GroupName="DayPart" Checked="true" runat="server" ID="radAM" Text="A.M."/>
<asp:RadioButton GroupName="DayPart" runat="server" ID="radPM" Text="P.M."/>