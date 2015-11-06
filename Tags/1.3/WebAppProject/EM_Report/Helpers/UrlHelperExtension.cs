using System.Configuration;
using System.Web.Mvc;

public static class UrlHelperExtension
{
    public static string Site()
    {
        return (ConfigurationManager.AppSettings["Site"] != null) ? ConfigurationManager.AppSettings["Site"].ToString() : "EML";
    }

    public static string Image(this UrlHelper helper, string fileName)
    {
        return helper.Content(string. Format("~/images/{0}/{1}", Site(), fileName));
    }

    public static string Stylesheet(this UrlHelper helper, string fileName)
    {
        return helper.Content(string.Format("~/css/{0}/{1}", Site(), fileName));
    }

}