<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Subscription.aspx.cs" Inherits="EM_Report.EMReports.Popup.Popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <%--<h3>Report Delivery Options</h3>
        Delivered by: <asp:DropDownList runat="server" ID="drlDelivered">
            <asp:ListItem Selected="True" Value="0">Windows File Share</asp:ListItem> 
        </asp:DropDownList>
        <br />
        File Name: <asp:TextBox runat="server" ID="txtFileName"></asp:TextBox>
        <br />
        Path: <asp:TextBox runat="server" ID="txtPath"></asp:TextBox>
        <br />
        Render Format: <asp:DropDownList runat="server" ID="drlFormat">
            <asp:ListItem Selected="True" Value="0">XML file with report data</asp:ListItem> 
            <asp:ListItem Value="1">PDF</asp:ListItem> 
        </asp:DropDownList>
        <br /><br />
        Credentials used to access the file share:
        <br />
        <table>
            <tr>
                <td>User Name: 
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtUserName"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td> Password:
                </td>
                <td>
                    <input runat="server" id="txtPassword" type="password" />
                </td>
            </tr>
        </table>
        
        <br />
        
        Overwrite options:
        <table>
            <tr> 
            <td> <asp:RadioButton Checked="true" GroupName="OverwriteOption" runat="server" ID="radOverwrite" Text="Overwrite an existing file with a newer version" />
            </td>
            </tr>
            <tr> 
            <td> <asp:RadioButton GroupName="OverwriteOption" runat="server" ID="radNone" Text="Do not overwrite the file if a previous version exists" />
            </td>
            </tr>
            <tr> 
            <td> <asp:RadioButton GroupName="OverwriteOption" runat="server" ID="radNewVersion" Text="Increment file names as newer versions are added" />
            </td>
            </tr>
        </table>--%>

        <h2>Config Report Subsciption</h2>

        Saved file name: <asp:TextBox runat="server" ID="txtSavedReportName"></asp:TextBox>
        <br />
        Format: 
        <asp:DropDownList runat="server" ID="drlFormats">
            <asp:ListItem></asp:ListItem>
            <asp:ListItem></asp:ListItem>
            <asp:ListItem></asp:ListItem>
            <asp:ListItem></asp:ListItem>
            <asp:ListItem></asp:ListItem>
            <asp:ListItem></asp:ListItem>
            <asp:ListItem></asp:ListItem>
        </asp:DropDownList>
        <br />
        Email:<asp:TextBox runat="server" ID="txtEmail"></asp:TextBox>
        <h4>Schedule Configuration</h4>
        <asp:Button runat="server" ID="btnRecSchedule" Text="Select Schedule" 
            onclick="btnSchedule_Click"/>
        <asp:Button runat="server" ID="btnOTSchedule" Text="One Time Schedule"/>
        <br />
        <asp:Label runat="server" ID="lblSchedule"></asp:Label>
        <h4>Report Parameter Values</h4>
        Specify the report parameter values to use with this subscription
        <asp:Panel ID="pnlParameters" runat="server">
            <asp:Repeater ID="rptParameters" runat="server">
                <HeaderTemplate>
                    <table>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td><asp:Label runat="server" ID="lblParamName"><%#Eval("Name") %></asp:Label></td>
                        <td><asp:TextBox runat="server" ID="txtParameter"></asp:TextBox></td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </asp:Panel>
        <br />
        <asp:Button runat="server" ID="btnOk" Text="OK" onclick="btnOk_Click"/>
        <asp:Button runat="server" ID="btnCancel" Text="Cancel"/>
    </div>
    </form>
</body>
</html>
