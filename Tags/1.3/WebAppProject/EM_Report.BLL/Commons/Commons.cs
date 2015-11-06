using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Text;

namespace EM_Report.BLL.Commons
{
    public class Commons
    {
        public static string ReportPathPrefix = ConfigurationManager.AppSettings[EM_Report.BLL.Commons.Constants.STR_REPORTPATH_PREFIX];

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

        public static string GetReportPathFromDB(string rptPath)
        {
            rptPath = rptPath.TrimStart('/');
            return ReportPathPrefix + rptPath;
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
    }
}