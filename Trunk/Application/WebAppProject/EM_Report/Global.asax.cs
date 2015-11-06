using System;
using System.Web.Mvc;
using System.Web.Routing;
using System.Net;
using System.Web.Helpers;
using System.Web;
using EM_Report.ActionServiceReference;
using EM_Report.Helpers;
using System.Collections.Specialized;

namespace EM_Report
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801   

    public class MvcApplication : System.Web.HttpApplication
    {
        [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, AllowMultiple = false, Inherited = true)]
        public class GlobalValidateAntiForgeryToken : AuthorizeAttribute
        {
            public override void OnAuthorization(AuthorizationContext filterContext)
            {
                if (filterContext.HttpContext.Request.HttpMethod == WebRequestMethods.Http.Post)
                {
                    if (filterContext.HttpContext.Request.IsAjaxRequest())
                    {
                        var form = new NameValueCollection(filterContext.HttpContext.Request.Form);
                        if (filterContext.HttpContext.Request.Headers["__RequestVerificationToken"] != null)
                        {
                            form["__RequestVerificationToken"] = filterContext.HttpContext.Request.Headers["__RequestVerificationToken"];
                        }
                    }
                    else
                    {
                        new ValidateAntiForgeryTokenAttribute().OnAuthorization(filterContext);
                    }

                }
            }
        }
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
            filters.Add(new GlobalValidateAntiForgeryToken());
        }

        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            //Custom route for reports
            routes.MapRoute(
             "ReportRoute",                  // Route name
             "Reports/{reportname}",         // URL
             "~/Reports/{reportname}.aspx"   // File
             );

            routes.MapRoute(
                "Default",
                "{controller}/{action}/{id}",
                new { controller = "account", action = "Index", id = UrlParameter.Optional }
            );
        }

        protected void Application_Start()
        {
            try
            {
                var svc = new ActionServiceClient();

                Helpers.Base.ByPassCertificate();

                svc.EncryptConnectionStrings();

                svc.Close();
            }
            catch { };

            log4net.Config.XmlConfigurator.Configure();

            AreaRegistration.RegisterAllAreas();

            RegisterGlobalFilters(GlobalFilters.Filters);
            RegisterRoutes(RouteTable.Routes);
        }
    }
}