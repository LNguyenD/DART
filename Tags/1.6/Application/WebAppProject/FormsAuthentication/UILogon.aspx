<%@ Page language="c#" Codebehind="UILogon.aspx.cs" AutoEventWireup="false" Inherits="Microsoft.Samples.ReportingServices.CustomSecurity.UILogon" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
   <HEAD>
      <title>Sql Server 2008 Reporting Services Samples</title>
      <meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
      <meta name="CODE_LANGUAGE" Content="C#">
      <meta name="vs_defaultClientScript" content="JavaScript">
      <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
   </HEAD>
   <body MS_POSITIONING="GridLayout">
      <form id="Form1" method="post" runat="server">
         <asp:Label id="Label1" style="Z-INDEX: 108; LEFT: 120px; POSITION: absolute; TOP: 96px" runat="server"
            Width="416px" Height="32px" Font-Size="Medium" Font-Names="Verdana" meta:resourcekey="Label1Resource1" Text="SQL Server Reporting Services Management"></asp:Label>
         <asp:Label id="LblUser" 
             style="Z-INDEX: 109; LEFT: 156px; POSITION: absolute; TOP: 150px; right: 517px;" runat="server"
             Font-Size="X-Small" Font-Names="Verdana" Font-Bold="True" 
             meta:resourcekey="LblUserResource1">User Name/Email:</asp:Label>
         <asp:Label id="LblPwd" 
             style="Z-INDEX: 102; LEFT: 156px; POSITION: absolute; TOP: 190px" runat="server"
            Width="104px" Font-Size="X-Small" Font-Names="Verdana" Font-Bold="True" 
             meta:resourcekey="LblPwdResource1">Password:</asp:Label>
         <asp:Button id="BtnLogon" style="Z-INDEX: 106; LEFT: 352px; POSITION: absolute; TOP: 240px"
            runat="server" Width="104px" Text="Logon" tabIndex="3" 
             meta:resourcekey="BtnLogonResource1"></asp:Button>
         <asp:TextBox id="TxtPwd" 
             style="Z-INDEX: 103; LEFT: 296px; POSITION: absolute; TOP: 190px" runat="server"
            tabIndex="2" Width="160px" TextMode="Password" 
             meta:resourcekey="TxtPwdResource1"></asp:TextBox>&nbsp;
         <asp:TextBox id="TxtUser" 
             style="Z-INDEX: 104; LEFT: 296px; POSITION: absolute; TOP: 150px" runat="server"
            tabIndex="1" Width="160px" meta:resourcekey="TxtUserResource1"></asp:TextBox>
         <asp:Button id="BtnRegister" style="Z-INDEX: 105; LEFT: 232px; POSITION: absolute; TOP: 240px"
            runat="server" Width="104px" Text="Register User" tabIndex="4" 
             meta:resourcekey="BtnRegisterResource1"></asp:Button>
         <asp:Label id="lblMessage" style="Z-INDEX: 107; LEFT: 168px; POSITION: absolute; TOP: 300px"
            runat="server" Width="321px" meta:resourcekey="lblMessageResource1"></asp:Label>
      </form>
   </body>
</HTML>