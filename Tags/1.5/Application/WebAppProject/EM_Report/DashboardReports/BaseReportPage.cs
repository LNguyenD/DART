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
using EM_Report.SSRS;

namespace EM_Report.DashboardReports
{
    public abstract class BaseReportPage : System.Web.UI.Page
    {
        protected abstract ReportViewer reportViewer { get; }

        private void SetReportParameters(string reportPath)
        {
            List<ReportParameter> lstReportParameter = new List<ReportParameter>();

            foreach (String key in Request.QueryString.AllKeys)
            {
                GetQueryString(lstReportParameter, key, Request.QueryString[key]);
            }

            reportViewer.ServerReport.SetParameters(lstReportParameter);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            string reportPath = HttpUtility.UrlDecode(Request.QueryString["reportpath"].ToString()).Trim(',').Trim();

            if (!IsPostBack)
            {
                try
                {
                    reportViewer.ProcessingMode = ProcessingMode.Remote;
                    reportViewer.ServerReport.ReportServerUrl = new Uri(Base.GetConfig("ReportServerUrl"));
                    reportViewer.ServerReport.ReportPath = reportPath;
                    reportViewer.ServerReport.Timeout = 3600000;

                    Cookie authCookie = new Cookie("sqlAuthCookie", Base.LoginSession.RS2010.AuthCookie.Value);
                    authCookie.Domain = Base.GetConfig("ReportServerDomain");

                    reportViewer.ServerReport.ReportServerCredentials = new MyReportServerCredentials(authCookie);
                    SetReportParameters(reportPath);
                }
                catch (Exception ex) { }
            }
        }

        protected abstract void GetQueryString(List<ReportParameter> lstReportParameter, string key, string value);
    }
}