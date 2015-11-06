using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;
using System.Globalization;
using EM_Report.Models.RS2005;
namespace EM_Report.Models.RS2005
{
    public partial class ReportingService2005 : System.Web.Services.Protocols.SoapHttpClientProtocol
    {
        protected override System.Net.WebRequest GetWebRequest(Uri uri)
        {
            WebRequest request = base.GetWebRequest(uri);

            //request.Headers.Add(HttpRequestHeader.AcceptLanguage, CultureInfo.CurrentCulture.Name);
            request.Headers.Add(HttpRequestHeader.AcceptLanguage, "en-AU");

            return request;
        }
    }
}