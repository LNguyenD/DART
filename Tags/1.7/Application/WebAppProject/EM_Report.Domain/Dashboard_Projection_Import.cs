using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;
using EM_Report.Domain.Attributes;

namespace EM_Report.Domain
{
    public class Dashboard_Projection_Import
    {
        [FileSize(4194304)]
        [FileTypes("csv")]
        public HttpPostedFileBase File { get; set; }

        public IList<Dashboard_Projection> ProjectionList { get; set; }
    }
}