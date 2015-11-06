using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Linq;
using System.Net;
using System.ServiceModel;
using System.Web;
using EM_Report.ActionServiceReference;
using EM_Report.Common.Utilities;
using EM_Report.Domain.Resources;
using EM_Report.Repositories;
using EM_Report.Domain.Enums;

namespace EM_Report.Helpers
{
    public class Base : RepositoryBase
    {
        public static LoginType LoginType
        {
            get
            {
                return (LoginType)Enum.Parse(typeof(LoginType), Base.GetConfig("LoginType"), true);                
            }
        }

        /// <summary>
        /// Get Total Count Of List before Paged
        /// </summary>
        /// <param name="request"></param>
        /// <param name="response"></param>
        /// 
        public static string GetController
        {
            get
            {                
                return HttpContext.Current.Request.RequestContext.RouteData.Values["controller"].ToString();
            }
        }
        
        public static string GetAction
        {
            get
            {
                return HttpContext.Current.Request.RequestContext.RouteData.Values["action"].ToString();
            }
        }

        public static string RawUrl
        {
            get
            {
                try
                {
                    return HttpContext.Current.Request.Url.AbsolutePath;
                }
                catch
                {
                    return string.Empty;
                }
            }
        }

        public static ActionServiceClient SvcClient
        {
            get
            {
                if (Base.LoginSession == null)
                {

                    Login.LoginAction(new LoginResponse(), false);
                }

                if (Base.LoginSession.svcClient.State == CommunicationState.Faulted)
                {
                    try { Base.LoginSession.svcClient.Abort(); }
                    catch { /* no action */ }

                    ByPassCertificate();
                    Base.LoginSession.svcClient = new ActionServiceClient();
                }
                return Base.LoginSession.svcClient;
            }
        }

        public static I_LoginSessionExtend LoginSession
        {
            get
            {
                try
                {
                    return (I_LoginSessionExtend)HttpContext.Current.Session["LoginSession"];
                }
                catch
                {
                    return null;
                }
            }
            set
            {
                HttpContext.Current.Session["LoginSession"] = value;
            }
        }        

        public static long TotalItemCount { get; set; }

        public static string CreateRandomPassword(int passwordLength)
        {
            string allowedChars = Base.GetConfig("PasswordAllowedChars");
            char[] chars = new char[passwordLength];
            Random rd = new Random();

            for (int i = 0; i < passwordLength; i++)
            {
                chars[i] = allowedChars[rd.Next(0, allowedChars.Length)];
            }

            return new string(chars);
        }

        public static IEnumerable<string> PageSizeOptions()
        {
            string sizes = (Base.GetConfig("pagesizes") != null) ? Base.GetConfig("pagesizes") : "5,10,15,20";
            return sizes.Split(',');
        }

        public static IEnumerable<string> UserTypeOptions()
        {
            string sizes = Base.GetConfig("usertypes");
            return sizes.Split(',');
        }        

        public static string GetDatetimeText(DateTime? date)
        {
            return date.HasValue && date.Value.ToString("dd/MM/yyyy").Trim() != "01/01/0001" ? date.Value.ToString("dd/MM/yyyy") : string.Empty;
        }

        public static string GetDatetimeText(string date)
        {
            return date;
            //return date != null && date.ToString().IndexOf("/0001") < 0 ? DateTime.Parse(date).ToString("dd/MM/yyyy") : string.Empty;
        }

        public static string GetStringByMaxLength(int maxlength, string value)
        {
            return value == null || value.Length <= maxlength ? value : value.Substring(0, maxlength) + "...";
        }

        public static string GetConfig(string key)
        {
            return ConfigurationManager.AppSettings[key];
        }

        public static int GetIntConfig(string key)
        {
            return int.Parse(ConfigurationManager.AppSettings[key]);
        }

        public static string SiteName(string systemname)
        {
            return systemname.ToLower().IndexOf("hem") >= 0 ? Constants.STR_SITE_HEM : systemname.ToLower().IndexOf("tmf") >= 0 ? Constants.STR_SITE_TMF : Constants.STR_SITE_EML;
        }

        public static DateTime ConvertDateTimeByTimeZone(DateTime dt, string strSourceTimeZoneId, string strDestinationTimeZoneIdServer)
        {
            try
            {
                return strSourceTimeZoneId != strDestinationTimeZoneIdServer && strSourceTimeZoneId != "" && strDestinationTimeZoneIdServer != "" ? TimeZoneInfo.ConvertTime(dt, TimeZoneInfo.FindSystemTimeZoneById(strSourceTimeZoneId), TimeZoneInfo.FindSystemTimeZoneById(strDestinationTimeZoneIdServer)) : dt;
            }
            catch (Exception) { return dt; }
        }

        public static int Page_Size()
        {
            var pagesize = ResourcesHelper.Report_PageSize;
            var cookiePaging = HttpContext.Current.Request.Url.ToString().ToLower() + "_" + Base.LoginSession.strUserName.ToLower() + "_pagesize";
            cookiePaging = cookiePaging.Replace("/", "_").Replace(":", "_").Replace("?", "_").Replace("&", "_").Replace("=", "_");
            if (HttpContext.Current.Request.Cookies[cookiePaging] != null && !string.IsNullOrEmpty(HttpContext.Current.Request.Cookies[cookiePaging].Value))
            {
                pagesize = int.Parse(HttpContext.Current.Request.Cookies[cookiePaging].Value);
            }
            return pagesize;
        }

        public static string Page_Sort(string default_sort)
        {
            var cookieSort = HttpUtility.UrlEncode(HttpContext.Current.Request.Url.ToString().ToLower() + "_" + Base.LoginSession.strUserName.ToLower() + "_sort");
            cookieSort = cookieSort.Replace("/", "_").Replace(":", "_").Replace("?", "_").Replace("&", "_").Replace("=", "_");

            if (HttpContext.Current.Request.Cookies[cookieSort] != null && !string.IsNullOrEmpty(HttpContext.Current.Request.Cookies[cookieSort].Value))
            {
                default_sort = HttpUtility.UrlDecode(HttpContext.Current.Request.Cookies[cookieSort].Value, System.Text.Encoding.Default);
            }

            return default_sort;
        }

        public static void ByPassCertificate()
        {
            if (Base.GetConfig("IsNeedByPassCertificate").ToLower() == "true")
            {
                ServicePointManager.ServerCertificateValidationCallback = (sender, cert, chain, sslPolicyErrors) => true;
            }
        }       

        public static Dictionary<string, string> GetListFromSectionConfig(string SectionName)
        {
            var source = (NameValueCollection)ConfigurationManager.GetSection(SectionName);
            return source.Cast<string>()
                     .Select(s => new { Key = s, Value = source[s] })
                     .ToDictionary(p => p.Key, p => p.Value);
        }       

        public static void AddUpdateCookie(string cookie_name, string cookie_value, int days)
        {
            if (HttpContext.Current.Request.Cookies[cookie_name] != null)
            {
                RemoveCookie(cookie_name);
            }

            //Response.Cookies.Add(mycookie);
            HttpCookie cookie = new HttpCookie(cookie_name);
            //Setting values inside it
            cookie.Value = cookie_value;

            //Adding Expire Time of cookies
            cookie.Expires = DateTime.Now.AddDays(days);

            //Adding cookies to current web response
            HttpContext.Current.Response.Cookies.Add(cookie);
        }

        public static string RetrieveCookie(string cookieName)
        {
            var cookieValue = "";
            var cookie = HttpContext.Current.Request.Cookies[cookieName];
            if (cookie != null)
            {
                cookieValue = cookie.Value;
            }

            return cookieValue;
        }

        public static void RemoveCookie(string cookie_name)
        {
            if (HttpContext.Current.Request.Cookies[cookie_name] != null)
            {
                HttpCookie aCookie = HttpContext.Current.Request.Cookies[cookie_name];
                aCookie.Expires = DateTime.Now.AddDays(-999);
                HttpContext.Current.Response.Cookies.Add(aCookie);
            }
        }

        public static string GetSystemNameByUrl(string url)
        {
            var urlUpper = url.ToUpper();
            var systemName = string.Empty;

            if (urlUpper.IndexOf("TMF") >= 0)
            {
                systemName = "TMF";
            }
            else if (urlUpper.IndexOf("EML") >= 0)
            {
                systemName = "EML";
            }
            else if (urlUpper.IndexOf("HEM") >= 0)
            {
                systemName = "HEM";
            }
            return systemName;
        }        

        public static bool IsAjaxRequest()
        {
            return HttpContext.Current.Request.Headers["X-Requested-With"] != null && HttpContext.Current.Request.Headers["X-Requested-With"] == "XMLHttpRequest";
        }

        public static void RedirectTo(string page)
        {
            HttpContext.Current.Response.Redirect(page);
        }

        public static string AbsoluteUrl(string RelativeUrl)
        {
            return VirtualPathUtility.ToAbsolute(RelativeUrl);
        }
    }
}