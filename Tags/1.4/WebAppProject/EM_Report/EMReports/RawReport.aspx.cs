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

namespace EM_Report.EMReports
{
    public partial class RawReport : System.Web.UI.Page
    {
        private void SetReportParameters(string reportPath)
        {
            List<ReportParameter> lstreportParameter = new List<ReportParameter>();

            foreach (String key in Request.QueryString.AllKeys)
            {
                if (key.ToLower().IndexOf("reportpath") < 0 && key.ToLower().IndexOf("rdr") < 0)
                {
                    if (key == "Start_Date" || key == "End_Date")
                    {
                        // replace some special characters before pass to report file
                        lstreportParameter.Add(new ReportParameter(key, Request.QueryString[key]
                            .Replace('_', '/').Replace('.', ':'), false));
                    }
                    else
                        lstreportParameter.Add(new ReportParameter(key, Request.QueryString[key], false));
                }
            }

            rvwReportViewerRawData.ServerReport.SetParameters(lstreportParameter);            
        }

        private void SetCustomParameters(ref List<ReportParameter> reportParameter) 
        {
            if (reportParameter == null)
            {
                return;
            }
            var visibleParaList = new SSRS.ReportParameterService().GetDashboard_VisibleParametersInfo(rvwReportViewerRawData.ServerReport.ReportPath, null).ToList();

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
                            rvwReportViewerRawData.ServerReport.GetParameters().FirstOrDefault(r => r.Name.Equals(name, StringComparison.InvariantCultureIgnoreCase));
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
                    rvwReportViewerRawData.ProcessingMode = ProcessingMode.Remote;
                    rvwReportViewerRawData.ServerReport.ReportServerUrl = new Uri(Base.LoginSession.objConfig.ReportServerUrl);
                    rvwReportViewerRawData.ServerReport.ReportPath = reportPath;
                    rvwReportViewerRawData.ServerReport.Timeout = 3600000;                    

                    HttpCookie cookie = Request.Cookies["sqlAuthCookie"];
                    if (cookie != null)
                    {
                        Cookie authCookie = new Cookie(cookie.Name, cookie.Value);
                        authCookie.Domain = Base.LoginSession.objConfig.ReportServerDomain;
                        rvwReportViewerRawData.ServerReport.ReportServerCredentials = new MyReportServerCredentials(authCookie);
                        SetReportParameters(reportPath);
                    }
                }
                catch (Exception ex) { }
            }            
        }       
    }
 }