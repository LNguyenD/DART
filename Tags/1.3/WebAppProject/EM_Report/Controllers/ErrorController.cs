using System.Web.Mvc;

namespace EM_Report.Controllers
{
    public class ErrorController : Controller
    {
        public ActionResult Error_404(string url)
        {
            return View();
        }
       
        public ActionResult Error_500()
        {            
            return View();
        }

        public class NotFoundViewModel
        {
            public string RequestedUrl { get; set; }
            public string ReferrerUrl { get; set; }
        }
    }
}

