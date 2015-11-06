using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Reflection;
using System.Web;
using EM_Report.BLL.Commons;
using EM_Report.BLL.Services;
using EM_Report.Helpers;
using Microsoft.Reporting.WebForms;

namespace EM_Report.SSRS
{
    public partial class Report : System.Web.UI.Page
    {
        private void SetReportParameters()
        {
            List<ReportParameter> reportParameter = ReportParameterService.GetInvisibleParameter(Base.LoginSession.strUserName, new List<string>());

            if (Base.SiteName() == Constants.STR_SITE_HEM)
            {
                var reportInfo = rvwReportViewer.ServerReport.GetParameters().FirstOrDefault(r => r.Name.Equals(Constants.STR_IS_ALL, StringComparison.InvariantCultureIgnoreCase));
                if (reportInfo != null)
                {
                    reportParameter.Add(new ReportParameter(Constants.STR_IS_ALL, "true", false));
                }
            }

            if (rvwReportViewer.ServerReport.GetParameters().FirstOrDefault(r => r.Name.Equals(Constants.STR_IS_RIG, StringComparison.InvariantCultureIgnoreCase)) != null)
            {
                var teamService = new TeamService(Base.LoginSession);
                var value = teamService.IsRIG(Base.LoginSession.strUserName, Base.SiteName()).ToString().ToLowerInvariant();
                reportParameter.Add(new ReportParameter(Constants.STR_IS_RIG, value, false));
            }

            if (rvwReportViewer.ServerReport.GetParameters().FirstOrDefault(r => r.Name.Equals(Constants.STR_IS_TEAMLEADER, StringComparison.InvariantCultureIgnoreCase)) != null)
            {
                I_Organisation_RolesService roleService = new Organisation_RolesService(Base.LoginSession);
                var isTeamLeadOrAbove = roleService.IsTeamLeaderOrAbove(Base.LoginSession.intOrganisation_RoleId.Value) ? "true" : "false";
                reportParameter.Add(new ReportParameter(Constants.STR_IS_TEAMLEADER, isTeamLeadOrAbove, false));
            }
            // clear default value of one param to prevent auto loading
            var firstParam = rvwReportViewer.ServerReport.GetParameters().FirstOrDefault(r => !reportParameter.Any(t => t.Name == r.Name) && r.Visible);
            if (firstParam != null)
            {
                reportParameter.Add(new ReportParameter(firstParam.Name, new string[] { null }, true));
            }

            rvwReportViewer.ServerReport.SetParameters(reportParameter);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            string reportServerUrl = ConfigurationManager.AppSettings[Constants.STR_REPORT_SERVER_URL];
            string rsConnectionString = ConfigurationManager.ConnectionStrings[Constants.STR_RS_CONNECTIONSTRING].ToString();
            string reportPath = HttpUtility.UrlDecode(Request.QueryString["ReportPath"].ToString()).Trim(',').Trim();            

            if (!IsPostBack)
            {
                rvwReportViewer.ProcessingMode = ProcessingMode.Remote;
                rvwReportViewer.ServerReport.ReportServerCredentials = new ReportViewerCredentials();
                rvwReportViewer.ServerReport.ReportServerUrl = new Uri(reportServerUrl);
                rvwReportViewer.ServerReport.ReportPath = reportPath;
                rvwReportViewer.ServerReport.Timeout = 1800000;
                SetReportParameters();
            }
        }
        
        protected void cmdUpdateParam_Click(object sender, EventArgs e)
        {
            PrepareParameter();
        }
        
        protected void rvwReportViewer_PreRender(object sender, EventArgs e)
        {
            DisableUnwantedExportFormats("IMAGE,RPL,XML,MHTML");
        }

        public void PrepareParameter()
        {
            var parameters = ReportParamValues.Value.Split(';');
            if (parameters.Length > 0)
            {
                List<ReportParameter> reportParameter = new List<ReportParameter>();
                foreach (string param in parameters)
                {
                    var items = param.Split('|');
                    if (items.Length > 0 && items[0].StartsWith("prm") && !items[0].EndsWith(Constants.STR_HIDDEN))
                    {
                        var name = items[0].Substring(3);
                        var reportInfo = rvwReportViewer.ServerReport.GetParameters().FirstOrDefault(r => r.Name.Equals(name, StringComparison.InvariantCultureIgnoreCase));
                        if (reportInfo != null)
                        {
                            if (reportInfo.MultiValue)
                                reportParameter.Add(new ReportParameter(name, items[1].Split(','), true));
                            else
                                reportParameter.Add(new ReportParameter(name, items[1], true));
                        }
                    }

                }

                if (reportParameter.Any())
                {
                    rvwReportViewer.ServerReport.SetParameters(reportParameter);
                }
            }
          
        }
        
        public void DisableUnwantedExportFormats(string configRemoveOpt)
        {
            FieldInfo info;
            foreach (RenderingExtension extension in rvwReportViewer.ServerReport.ListRenderingExtensions())
            {               
                if (configRemoveOpt.Split(',').Contains(extension.Name))
                {
                    info = extension.GetType().GetField("m_isVisible", BindingFlags.Instance | BindingFlags.NonPublic);
                    info.SetValue(extension, false);
                }
            } 
        }       
    }
}