using System.Configuration;
using System.Web.Mvc;
using System;
using EM_Report.Helpers;
public static class UrlHelperExtension
{
    public static string Site()
    {
        return (Base.GetConfig("Site") != null) ? Base.GetConfig("Site") : "EML";
    }

    public static string Image(this UrlHelper helper, string fileName)
    {
        return helper.Content(string.Format("~/images/{0}", fileName));
    }

    public static string Stylesheet(this UrlHelper helper, string fileName)
    {
        return helper.Content(string.Format("~/css/{0}", fileName));
    }

    public static string ContentV(this UrlHelper helper, string url)
    {
        url = helper.Content(url).ToLower();
        url = url.Replace(".png", ".png" + "?v=" + DateTime.Now.Ticks.ToString());
        url = url.Replace(".jpg", ".jpg" + "?v=" + DateTime.Now.Ticks.ToString());
        url = url.Replace(".gif", ".gif" + "?v=" + DateTime.Now.Ticks.ToString());
        url = url.Replace(".ico", ".ico" + "?v=" + DateTime.Now.Ticks.ToString());
        url = url.Replace(".css", ".css" + "?v=" + DateTime.Now.Ticks.ToString());
        url = url.Replace(".js", ".js" + "?v=" + DateTime.Now.Ticks.ToString());
        return url;
    }
}