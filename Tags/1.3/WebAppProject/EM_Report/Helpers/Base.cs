using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Linq;
using System.Runtime.Caching;
using System.Web;
using EM_Report.BLL.Commons;
using EM_Report.BLL.Services;
using EM_Report.Models;
using Microsoft.Reporting.WebForms;
using System.Net;
using System.Xml;
using System.Data;
using System.Globalization;

namespace EM_Report.Helpers
{
    public class Base
    {
        
        public static string CreateRandomPassword(int passwordLength)
        {
            string allowedChars = ConfigurationManager.AppSettings["PasswordAllowedChars"];
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
            string sizes = (ConfigurationManager.AppSettings["pagesizes"] != null) ? ConfigurationManager.AppSettings["pagesizes"].ToString() : "5,10,15,20";
            return sizes.Split(',');
        }

        public static bool SendMail(string to,string subject,string body)
        {
            try
            {
                System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                message.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["MailFrom"]);
                message.To.Add(new System.Net.Mail.MailAddress(to));
                message.Subject = subject;
                message.Body = body;
                System.Net.Mail.SmtpClient mSmtpClient = new System.Net.Mail.SmtpClient(ConfigurationManager.AppSettings["MailHost"]);
                mSmtpClient.Send(message);
                return true;
            }
            catch { return false; }
        }

        public static EM_Report.BLL.Commons.I_LoginSession LoginSession
        {
            get
            {
                try
                {
                    return (I_LoginSession)HttpContext.Current.Session["LoginSession"];
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

        public static IEnumerable<StatusModel> StatusList()
        {
            ObjectCache cache = MemoryCache.Default;
            if (!cache.Contains("StatusList"))
            {
                I_Service<StatusModel> _statusService = new StatusService(Base.LoginSession);
                var list = _statusService.GetAll();
                cache.Add("StatusList", list, new CacheItemPolicy());
            }
            return cache.Get("StatusList") as IEnumerable<StatusModel>;
        }

        public static Dictionary<string, string> AuditList()
        {
            var source = (NameValueCollection)ConfigurationManager.GetSection("AuditDictionary");
            return source.Cast<string>()
                     .Select(s => new { Key = s, Value = source[s] })  
                     .ToDictionary(p => p.Key, p => p.Value);
        }                      

        public static string GetStatusName(short id)
        {
            return StatusList().Where(s => s.StatusId == id).Select(s => s.Name).FirstOrDefault();
        }    

        public static string GetDatetimeText(DateTime? date)
        {
            return date.HasValue ? date.Value.ToShortDateString() : string.Empty;
        }

        public static string GetDatetimeText(string date)
        {
            return date != null && date.ToString().IndexOf("/0001") < 0 ? DateTime.Parse(date).ToString("dd/MM/yyyy") : string.Empty;
        }

        public static string GetStringByMaxLength(int maxlength,string value)
        {
            return value==null || value.Length <=maxlength ? value : value.Substring(0,maxlength) + "...";
        }

        public static int GetIntByConfigKey(string key)
        { 
            return int.Parse(ConfigurationManager.AppSettings[key]);
        }

        public static string SiteName()
        {
            return UrlHelperExtension.Site();
        }

        public static DateTime ConvertToServerDatetime(DateTime dtLocal)
        {
            return TimeZoneInfo.ConvertTimeBySystemTimeZoneId(dtLocal,EM_Report.BLL.Resources.Resource.strDestinationTimeZoneIdServer);            
        }

        public static DateTime ConvertToServerDatetime(DateTime dtLocal, string strSourceTimeZoneIdClient)
        {
            try
            {
                if (string.IsNullOrEmpty(strSourceTimeZoneIdClient))
                    return ConvertToServerDatetime(dtLocal);
                else
                    return TimeZoneInfo.ConvertTimeBySystemTimeZoneId(dtLocal, strSourceTimeZoneIdClient, EM_Report.BLL.Resources.Resource.strDestinationTimeZoneIdServer);
            }
            catch (Exception)
            {
                return ConvertToServerDatetime(dtLocal);
            }
        }

        public static DateTime ConvertToClientDatetime(DateTime dtServer, string strSourceTimeZoneClientId)
        {
            try
            {
                if (strSourceTimeZoneClientId != EM_Report.BLL.Resources.Resource.strDestinationTimeZoneIdServer)
                {
                    return TimeZoneInfo.ConvertTimeBySystemTimeZoneId(dtServer, EM_Report.BLL.Resources.Resource.strDestinationTimeZoneIdServer, strSourceTimeZoneClientId);
                }
                else
                {
                    return dtServer;
                }
            }
            catch (Exception)
            {
                return ConvertToServerDatetime(dtServer);
            }
        }        
    }
}