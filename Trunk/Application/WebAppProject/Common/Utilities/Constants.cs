using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EM_Report.Common.Utilities
{
    public class Constants
    {
        public const string STR_SITE_EML = "EML";
        public const string STR_SITE_HEM = "HEM";
        public const string STR_SITE_TMF = "TMF";

        public const string G_ORDER_ASC = "asc";
        public const string G_ORDER_DESC = "desc";

        public const string STR_EMIC_CONNECTIONSTRING = "HEMConnectionString";
        public const string STR_HEMCONNECTIONSTRING = "HEMConnectionString";
        public const string STR_TMFCONNECTIONSTRING = "TMFConnectionString";
        public const string STR_EMLCONNECTIONSTRING = "EMLConnectionString";
        public const string STR_REPORT_SERVER_URL = "ReportServerUrl";
        public const string STR_REPORTPATH_PREFIX = "ReportPathPrefix";
		public const string STR_EXPORT_DRIVER = "ExportDriver";

        public const string STR_HIDDEN = "_Hidden";
        public const string STR_DATABASE_PARAM = "DatabaseParam" + STR_HIDDEN;
        public const string STR_USERNAME_PARAM = "UserName" + STR_HIDDEN;
        public const string STR_IS_ALL = "IsAll";
        public const string STR_IS_TEAMLEADER = "IsTeamLeader" + STR_HIDDEN;
        public const string STR_IS_RIG = "IsRIG" + STR_HIDDEN;
        public const string STR_COOKIE_SYSTEM = "Cookie_Systems";
        public const string STR_UserInfoSecurity = "UserInfoSecurity";
        public const string STR_UserBlocked_ = "UserBlocked_";
        public const string STR_SystemId_ = "SystemId_";
        public const string STR_SystemName_ = "SystemName_";  
        public static IDictionary<DeliveryMethod, string> DeliveryMethodNames = new Dictionary<DeliveryMethod, string>()
        {
           { DeliveryMethod.FILE  , "Report Server FileShare" },  
           { DeliveryMethod.EMAIL , "Report Server Email" },  
        };
    }

    public enum DeliveryMethod
    {
        FILE = 0,
        EMAIL = 1
    }   
}