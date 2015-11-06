using System;
using System.Collections.Specialized;
using System.Diagnostics.CodeAnalysis;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace EM_Report
{
    public class FilterConfig
    {
        [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, AllowMultiple = false, Inherited = true)]
        public class GlobalValidateAntiForgeryToken : AuthorizeAttribute
        {
            public override void OnAuthorization(AuthorizationContext filterContext)
            {
                //Check post request only
                if (filterContext.HttpContext.Request.HttpMethod == WebRequestMethods.Http.Post)
                {
                    new ValidateAntiForgeryTokenAttribute().OnAuthorization(filterContext); 
                }
            }
        }

        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {            
            filters.Add(new RequireHttpsAttribute());
            filters.Add(new HandleErrorAttribute());
            filters.Add(new RequireHttpsAttribute());
            filters.Add(new GlobalValidateAntiForgeryToken());
        }
    }
}
