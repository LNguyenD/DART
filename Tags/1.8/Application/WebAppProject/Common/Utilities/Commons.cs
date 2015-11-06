using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Text;
using EM_Report.Domain.Resources;
using log4net;
using System.IO;
using System.Xml.Linq;


using System.Xml;
using System.Data;
using System.Data.SqlClient;
using System.Reflection;
using System.Security.Principal;

using System.Globalization;
using System.Collections;

namespace EM_Report.Common.Utilities
{
    public class Commons
    {
        public static string GetLoginSequenceTime(DateTime? datLastLogin)
        {
            if (datLastLogin == null)
            {
                return string.Empty;
            }
            var format = string.Format("ddd MMM dd '{0}', yyyy 'at' hh:mm tt", Commons.AppendOrdinalSuffix(datLastLogin.Value.Day));
            return datLastLogin.Value.ToString(format, System.Globalization.DateTimeFormatInfo.InvariantInfo);
        }

        public static string GetLoginSequence(DateTime? datLastLogin)
        {
            if (datLastLogin == null)
            {
                return string.Empty;
            }
            var format = string.Format("'<strong>Last Login</strong>' ddd MMM dd '{0}', yyyy 'at' hh:mm tt", Commons.AppendOrdinalSuffix(datLastLogin.Value.Day));
            return datLastLogin.Value.ToString(format, System.Globalization.DateTimeFormatInfo.InvariantInfo);
        }

        public static string AppendOrdinalSuffix(int number)
        {
            string[] SuffixLookup = { "th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th" };
            if (number % 100 >= 11 && number % 100 <= 13)
            {
                return "th";
            }
            return SuffixLookup[number % 10];
        }        

        public static string MergeStringArray(string[] array)
        {
            var strBuilder = new StringBuilder();
            foreach (var str in array)
            {
                strBuilder.Append(str);
                strBuilder.Append(',');
            }
            return strBuilder.ToString().TrimEnd(',');
        }
        
        public static string ConvertDataTypeToString(string dataType)
        {
            string result = string.Empty;
            switch (dataType)
            {
                case "System.Int32":
                case "System.Int16":
                case "System.Byte":
                    result = "int";
                    break;
                case "System.Decimal":
                case "System.Double":
                    result = "money";
                    break;

                case "System.String":
                    result = "varchar";
                    break;

                case "System.DateTime":
                    result = "datetime";
                    break;
                case "System.Boolean":
                    result = "bit";
                    break;
                case "true":
                    result = "varchar";
                    break;
            }
            return result;
        }

        public static string GetConnectionStringBySystemName(string systemName)
        {
            return ConfigurationManager.ConnectionStrings[systemName.ToLower().IndexOf("hem") >= 0 ? Constants.STR_HEMCONNECTIONSTRING : systemName.ToLower().IndexOf("tmf") >= 0 ? Constants.STR_TMFCONNECTIONSTRING : Constants.STR_EMLCONNECTIONSTRING].ToString();
        }

        public static void EncryptConnectionStrings()
        {
            
                var hasChange = false;
                string cnnStrFile;
                // This will get called on startup
                var stream = new FileStream(AppDomain.CurrentDomain.SetupInformation.ConfigurationFile, FileMode.Open, FileAccess.Read);

                // encrypt SharePassword  
                XDocument xDoc = XDocument.Load(stream);
                stream.Close();

                // encrypt the connection string
                // find connection string file
                cnnStrFile = xDoc.Root.Element("connectionStrings").Attribute("configSource").Value;
                string currentDir = Path.GetDirectoryName(AppDomain.CurrentDomain.SetupInformation.ConfigurationFile);
                cnnStrFile = Path.Combine(currentDir, cnnStrFile);


                stream = new FileStream(cnnStrFile, FileMode.Open, FileAccess.Read);

                xDoc = XDocument.Load(stream);
                stream.Close();
                xDoc.Root.Elements("add").ForEach(e =>
                {
                    if (!EnCryption.IsEncrypt(e.Attribute("connectionString").Value))
                    {
                        e.SetAttributeValue("connectionString", EnCryption.Encrypt(e.Attribute("connectionString").Value));
                        hasChange = true;
                    }
                });
                if (hasChange)
                {
                    xDoc.Save(cnnStrFile);
                    //ConfigurationManager.RefreshSection("connectionStrings");
                }
            
        }
        public static bool SendMail(string to, string subject, string body, string mailfrom, string mailhost)
        {
            try
            {
                System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                message.From = new System.Net.Mail.MailAddress(mailfrom);
                message.To.Add(new System.Net.Mail.MailAddress(to));
                message.Subject = subject;
                message.Body = body;
                message.IsBodyHtml = true;
                System.Net.Mail.SmtpClient mSmtpClient = new System.Net.Mail.SmtpClient(mailhost);
                mSmtpClient.Send(message);
                return true;
            }
            catch { return false; }
        }
    }
}