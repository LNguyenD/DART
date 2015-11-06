<%@ Page Language="c#" CodeBehind="Logon.aspx.cs" AutoEventWireup="false" Inherits="Microsoft.Samples.ReportingServices.CustomSecurity.Logon, Microsoft.Samples.ReportingServices.CustomSecurity"
    Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <title>Sql Server 2008 Reporting Services Samples</title>
    <meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
    <meta name="CODE_LANGUAGE" content="C#">
    <meta name="vs_defaultClientScript" content="JavaScript">
    <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
</head>
<body ms_positioning="GridLayout">
    <form id="Form1" method="post" runat="server">
    <asp:Label ID="LblUser" Style="z-index: 101; left: 176px; position: absolute; top: 196px"
        runat="server" Width="96px" Font-Size="X-Small" Font-Names="Verdana" Font-Bold="True"
        meta:resourcekey="LblUserResource1">User Name:</asp:Label>
    <asp:Button ID="BtnLogon" Style="z-index: 106; left: 352px; position: absolute; top: 272px"
        runat="server" Width="104px" Text="Logon" TabIndex="3" meta:resourcekey="BtnLogonResource1">
    </asp:Button>
    <asp:TextBox ID="TxtPwd" Style="z-index: 103; left: 296px; position: absolute; top: 231px"
        runat="server" TabIndex="2" Width="160px" TextMode="Password" meta:resourcekey="TxtPwdResource1"></asp:TextBox>
    <asp:Label ID="LblPwd" Style="z-index: 102; left: 176px; position: absolute; top: 232px"
        runat="server" Width="96px" Font-Size="X-Small" Font-Names="Verdana" Font-Bold="True"
        meta:resourcekey="LblPwdResource1">Password:</asp:Label>
    &nbsp;
    <asp:TextBox ID="TxtUser" Style="z-index: 104; left: 296px; position: absolute; top: 195px"
        runat="server" TabIndex="1" Width="160px" meta:resourcekey="TxtUserResource1"></asp:TextBox>
    <asp:Button id="BtnRegister" style="Z-INDEX: 105; LEFT: 232px; POSITION: absolute; TOP: 272px"
            runat="server" Width="104px" Text="Register User" tabIndex="4" 
             meta:resourcekey="BtnRegisterResource1"></asp:Button>
    <asp:Label ID="LblDb" Style="z-index: 102; left: 176px; position: absolute; top: 157px"
        runat="server" Width="96px" Font-Size="X-Small" Font-Names="Verdana" Font-Bold="True"
        meta:resourcekey="LblDbResource1">Database:</asp:Label>
    <asp:DropDownList ID="ddl" Style="z-index: 107; left: 297px; position: absolute;
        top: 154px; height: -2px;" runat="server">
        <asp:ListItem Value="EML">EML</asp:ListItem>
        <asp:ListItem Value="HEM">HEM</asp:ListItem>
        <asp:ListItem Value="TMF">TMF</asp:ListItem>
    </asp:DropDownList>
    <asp:Label ID="lblMessage" Style="z-index: 107; left: 168px; position: absolute;
        top: 316px" runat="server" Width="321px" meta:resourcekey="lblMessageResource1"></asp:Label>
    <asp:Label ID="Label1" Style="z-index: 108; left: 167px; position: absolute; top: 96px;
        width: 302px;" runat="server" Height="32px" Font-Size="Medium" Font-Names="Verdana"
        meta:resourcekey="Label1Resource1" Text="SQL Server  Reporting Services"></asp:Label>
    </form>
</body>
</html>
