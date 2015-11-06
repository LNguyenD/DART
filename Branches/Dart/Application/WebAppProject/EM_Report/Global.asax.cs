﻿
using EM_Report.Repositories;
using EM_Report.Helpers;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

namespace EM_Report
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            MvcHandler.DisableMvcResponseHeader = true;  
            try
            {
                var helper = new HelperRepository();
                Helpers.Base.ByPassCertificate();
                helper.EncryptConnectionStrings();
            }
            catch { };

            log4net.Config.XmlConfigurator.Configure();

            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }       

        protected void Application_EndRequest(Object sender, EventArgs e)
        {
            if (Response.Cookies.Count > 0)
            {
                foreach (string s in Response.Cookies.AllKeys)
                {
                    Response.Cookies[s].HttpOnly = false;
                    Response.Cookies[s].Secure = true;
                }
            }
            Response.Headers.Set("Server", "ASW");
        }
    }
}
