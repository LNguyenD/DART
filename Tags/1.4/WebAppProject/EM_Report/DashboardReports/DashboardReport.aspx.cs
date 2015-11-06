using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using EM_Report.Common.Utilities;
using EM_Report.Repositories;
using EM_Report.Helpers;
using Microsoft.Reporting.WebForms;
using System.Security.Principal;   

namespace EM_Report.DashboardReports
{
    public partial class DashboardReport : System.Web.UI.Page
    {
        private void SetReportParameters(string reportPath)
        {
            List<ReportParameter> lstreportParameter = new List<ReportParameter>();

            foreach (String key in Request.QueryString.AllKeys)
            {
                if (key.ToLower().IndexOf("reportpath") < 0)
                {
                    lstreportParameter.Add(new ReportParameter(key, Request.QueryString[key], false));
                }
            }
            if (reportPath.ToLower().IndexOf("rtw_raw_data") >= 0)
            {
                rvwReportViewer.ShowToolBar = true;
            }

            rvwReportViewer.ServerReport.SetParameters(lstreportParameter);
        }

        private void SetCustomParameters(ref List<ReportParameter> reportParameter) 
        {
            if (reportParameter == null)
            {
                return;
            }
            var visibleParaList = new SSRS.ReportParameterService().GetDashboard_VisibleParametersInfo(rvwReportViewer.ServerReport.ReportPath,null).ToList();

            string paraserise = string.Empty;
            if (Request.QueryString["paraseries"] != null && Request.QueryString["paraseries"] !="")
            {
                paraserise = Request.QueryString["paraseries"];

                foreach (var item in paraserise.Split(';'))
                {
                    string[] paraChild = item.Split('|');
                    if (paraChild[0].Length > 0 && paraChild[0].StartsWith("prm") && !paraChild[0].EndsWith(Constants.STR_HIDDEN) || paraChild[0].Contains("Filter_") || paraChild[0].Contains("Subscription_"))
                    {
                        var name = paraChild[0].Substring(3);
                        var reportPara =
                            rvwReportViewer.ServerReport.GetParameters().FirstOrDefault(r => r.Name.Equals(name, StringComparison.InvariantCultureIgnoreCase));
                        if (reportPara != null)
                        {
                            if (reportPara.MultiValue)
                                reportParameter.Add(new ReportParameter(name, paraChild[1].Split(','), true));
                            else
                                reportParameter.Add(new ReportParameter(name, paraChild[1], true));
                        }
                    }
                }
            }                   
        }

        private bool HasReportParameter(List<Microsoft.SqlServer.ReportingServices2010.ItemParameter> reportParaList, string paraName) 
        {
            bool result = false;
            if (reportParaList != null)             
            {
                foreach (var item in reportParaList)
                {
                    if (item.Name.Equals(paraName))
                    {
                        result = true;
                        break;
                    }
                }
            }            

            return result;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            string reportPath = HttpUtility.UrlDecode(Request.QueryString["reportpath"].ToString()).Trim(',').Trim();

            if (!IsPostBack)
            {
                try
                {
                    rvwReportViewer.ProcessingMode = ProcessingMode.Remote;
                    rvwReportViewer.ServerReport.ReportServerUrl = new Uri(Base.LoginSession.objConfig.ReportServerUrl);
                    rvwReportViewer.ServerReport.ReportPath = reportPath;
                    rvwReportViewer.ServerReport.Timeout = 3600000;
                    
                    HttpCookie cookie = Request.Cookies["sqlAuthCookie"];
                    if (cookie != null)
                    {
                        Cookie authCookie = new Cookie(cookie.Name, cookie.Value);
                        authCookie.Domain = Base.LoginSession.objConfig.ReportServerDomain;
                        rvwReportViewer.ServerReport.ReportServerCredentials = new MyReportServerCredentials(authCookie);
                        SetReportParameters(reportPath);
                    }
                }
                catch (Exception ex) { }
            }            
        }        
    }
    public class MyReportServerCredentials : IReportServerCredentials
    {
        private Cookie m_authCookie;

        public MyReportServerCredentials(Cookie authCookie)
        {
            m_authCookie = authCookie;
        }

        public WindowsIdentity ImpersonationUser
        {
            get
            {
                return null;  // Use default identity.
            }
        }

        public ICredentials NetworkCredentials
        {
            get
            {
                return null;  // Not using NetworkCredentials to authenticate.
            }
        }

        public bool GetFormsCredentials(out Cookie authCookie, out string user,
                                        out string password, out string authority)
        {
            authCookie = m_authCookie;
            user = password = authority = null;
            return true;  // Use forms credentials to authenticate.
        }
    }   
}