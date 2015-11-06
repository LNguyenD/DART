using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EM_Report.Helpers
{
    public class FileVersioning
    {
        public static string AppendVersion(string resourceUrl)
        {
            resourceUrl = resourceUrl.Replace(".png", ".png" + "?v=" + DateTime.Now.Ticks.ToString());
            resourceUrl = resourceUrl.Replace(".jpg", ".jpg" + "?v=" + DateTime.Now.Ticks.ToString());
            resourceUrl = resourceUrl.Replace(".gif", ".gif" + "?v=" + DateTime.Now.Ticks.ToString());
            resourceUrl = resourceUrl.Replace(".ico", ".ico" + "?v=" + DateTime.Now.Ticks.ToString());
            resourceUrl = resourceUrl.Replace(".css", ".css" + "?v=" + DateTime.Now.Ticks.ToString());
            resourceUrl = resourceUrl.Replace(".js", ".js" + "?v=" + DateTime.Now.Ticks.ToString());
            return resourceUrl;
        }
    }
}