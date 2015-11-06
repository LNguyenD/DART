using System;
using System.Collections.Specialized;
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
                //Do not check token for sigle sign on
                if (filterContext.HttpContext.Request.HttpMethod == WebRequestMethods.Http.Post && filterContext.ActionDescriptor.ActionName != "loginsso")
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
    }
}
