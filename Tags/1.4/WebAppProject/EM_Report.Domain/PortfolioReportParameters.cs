using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EM_Report.Domain
{
    public class PortfolioReportParameters
    {
        public string System { get; set; }
        public string Type { get; set; }
        public string Value { get; set; }
        public string SubValue { get; set; }
    }
}