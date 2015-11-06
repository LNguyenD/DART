using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EM_Report.Common;
using EM_Report.Domain.Resources;
namespace EM_Report.Common.Utilities
{
    public class ResourcesHelper
    {
        public static string Action_Active
        {
            get { return Resource.Action_Active; }
        }

        public static string Action_InActive
        {
            get { return Resource.Action_InActive; }
        }
        
        public static short StatusActive
        {
            get { return short.Parse(Control.Status_Active); }
        }

        public static short StatusInactive
        {
            get { return short.Parse(Control.Status_InActive); }
        }

        public static int Report_GroupSize
        {
            get { return int.Parse(Control.Report_GroupSize); }
        }

        public static int Report_PageSize
        {
            get { return int.Parse(Control.Report_PageSize); }
        }

        public static int System_User
        {
            get { return int.Parse(Control.System_User); }
        }

        public static int System_Report
        {
            get { return int.Parse(Control.System_Report); }
        }

        public static int System_Permission
        {
            get { return int.Parse(Control.System_Permission); }
        }

        public static int System_Login
        {
            get { return int.Parse(Control.System_Login); }
        }

        public static int System_Group
        {
            get { return int.Parse(Control.System_Group); }
        }

        public static int System_Role
        {
            get { return int.Parse(Control.System_Role); }
        }

        public static int System_AuditTrail
        {
            get { return int.Parse(Control.System_AuditTrail); }
        }

        public static int Permission_Add
        {
            get { return int.Parse(Control.Permission_Add); }
        }

        public static int Permission_Delete
        {
            get { return int.Parse(Control.Permission_Delete); }
        }

        public static int Permission_None
        {
            get { return int.Parse(Control.Permission_None); }
        }

        public static int Permission_Update
        {
            get { return int.Parse(Control.Permission_Update); }
        }

        public static int Permission_View
        {
            get { return int.Parse(Control.Permission_View); }
        }

        public static int System_Dashboard
        {
            get { return int.Parse(Control.System_Dashboard); }
        }        
    }
}