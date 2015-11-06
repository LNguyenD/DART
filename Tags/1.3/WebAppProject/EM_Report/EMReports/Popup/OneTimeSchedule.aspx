<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OneTimeSchedule.aspx.cs" Inherits="EM_Report.EMReports.Popup.OneTimeSchedule" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <h3>One Time Schedule</h3>
        <uc1:CustomTime ID="CustomTime1" runat="server" />
        <br />
        StartDate: <asp:TextBox runat="server" ID="txtStartDate"></asp:TextBox> &nbsp;&nbsp; DD/MM/YYY
    </div>
    </form>
</body>
</html>
