using EM_Report.Reports.Helpers;
using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EM_Report.Reports.Dashboards
{
    public partial class CPRTableReport : BaseReportPage
    {
        protected override ReportViewer reportViewer
        {
            get { return rvwReportViewer; }
        }

        protected override void GetQueryString(List<ReportParameter> lstReportParameter, string key, string value)
        {
            if (key.ToLower().IndexOf("reportpath") < 0 && key.ToLower().IndexOf("dovalidate") < 0)
            {
                lstReportParameter.Add(new ReportParameter(key, value, false));
            }
        }
    }
}