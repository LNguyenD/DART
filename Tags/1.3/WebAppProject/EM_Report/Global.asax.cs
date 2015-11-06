using System;
using System.Web.Mvc;
using System.Web.Routing;
using EM_Report.Models.RS2005;
namespace EM_Report
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : System.Web.HttpApplication
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
        }

        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            //Custom route for reports
            routes.MapRoute(
             "ReportRoute",                         // Route name
             "Reports/{reportname}",                // URL
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
            log4net.Config.XmlConfigurator.Configure();

            AreaRegistration.RegisterAllAreas();

            RegisterGlobalFilters(GlobalFilters.Filters);
            RegisterRoutes(RouteTable.Routes);

            ScheduleDefinition defaultSchedule = new ScheduleDefinition();
            defaultSchedule.EndDateSpecified = false;
            defaultSchedule.EndDate = defaultSchedule.StartDateTime.AddDays(1);
            defaultSchedule.Item = null;

            Application["DefaultSchedule"] = defaultSchedule;
        }
    }
}