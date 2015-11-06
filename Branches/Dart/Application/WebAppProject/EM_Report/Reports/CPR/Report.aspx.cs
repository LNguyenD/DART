using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Security.Principal;
using System.Web;
using EM_Report.Common.Utilities;
using EM_Report.Helpers;
using Microsoft.Reporting.WebForms;
using EM_Report.SSRS;
using EM_Report.DashboardReports;
using EM_Report.Reports.Helpers;

namespace EM_Report.EMReports
{
    public partial class Report : BaseReportPage
    {
        protected override ReportViewer reportViewer
        {
            get { return rvwReportViewer; }
        }

        protected override void GetQueryString(List<ReportParameter> lstReportParameter, string key, string value)
        {
            if (key.ToLower().IndexOf("reportpath") < 0)
            {
                lstReportParameter.Add(new ReportParameter(key, value, false));
            }
        }
    }
}