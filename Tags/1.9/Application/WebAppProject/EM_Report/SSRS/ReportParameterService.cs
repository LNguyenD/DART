using System;
using System.Net;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using EM_Report.Common.Logger;
using EM_Report.Domain;
using System.IO;
using EM_Report.Common.Utilities;
using System.Xml.Linq;
using EM_Report.Helpers;
using System.Reflection;
using System.Web.Mvc;

namespace EM_Report.SSRS
{
    using System.ComponentModel.DataAnnotations;

    public class ItemParameter
    {
        public IEnumerable<Microsoft.SqlServer.ReportingServices2010.ItemParameter> lstRSParameters { get; set; }
        public IEnumerable<Microsoft.SqlServer.ReportingServices2010.ParameterValue> lstRSValues { get; set; }
    }    
}