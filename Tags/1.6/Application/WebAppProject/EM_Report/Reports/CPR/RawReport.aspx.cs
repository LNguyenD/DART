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
using EM_Report.DashboardReports;
using EM_Report.Reports.Helpers;

namespace EM_Report.EMReports
{
    public partial class RawReport : BaseReportPage
    {
        protected override ReportViewer reportViewer
        {
            get { return rvwReportViewerRawData; }
        }

        protected override void GetQueryString(List<ReportParameter> lstReportParameter, string key, string value)
        {
            if (key.ToLower().IndexOf("reportpath") < 0 && key.ToLower().IndexOf("rdr") < 0)
            {
                if (key == "Start_Date" || key == "End_Date")
                {
                    // replace some special characters before pass to report file
                    lstReportParameter.Add(new ReportParameter(key, value
                        .Replace('_', '/').Replace('.', ':'), false));
                }
                else if (key == "Is_Last_Month" && value == "true")
                {
                    var today = DateTime.Today;
                    var firstCurrentDay = new DateTime(today.Year, today.Month, 1);
                    var startDate = firstCurrentDay.AddMonths(-1);
                    var endDate = firstCurrentDay.AddDays(-1);

                    // append Start_Date as input parameter in last month
                    lstReportParameter.Add(new ReportParameter("Start_Date", startDate.ToString("dd/MM/yyyy"), false));

                    // append End_Date as input parameter in last month
                    lstReportParameter.Add(new ReportParameter("End_Date", endDate.ToString("dd/MM/yyyy") + " 23:59 ", false));

                    //appden Is_Last_Month parameter itself
                    lstReportParameter.Add(new ReportParameter(key, value, false));
                }
                else
                    lstReportParameter.Add(new ReportParameter(key, value, false));
            }
        }
    }
 }