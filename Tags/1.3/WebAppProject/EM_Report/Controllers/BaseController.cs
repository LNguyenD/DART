using System.Linq;
using System.Web.Mvc;
using System.Web.Routing;
using EM_Report.BLL.Pager;
using EM_Report.Helpers;

namespace EM_Report.Controllers
{
    public class BaseController : Controller
    {
        protected override void Initialize(RequestContext context)
        {
            ClearMessage();
            base.Initialize(context);            
            Login.AuthorizeLogin();           
        }
        //
        // GET: /Base/
        public BaseController()
            : base()
        {
            
        }

        protected PagedList<T> UpdateViewBag<T>(string search_input, string hddSort, int? hddPaging, int pagesize, IQueryable<T> list)
        {
            //ViewBag.HasPrevious = list.HasPrevious;
            //ViewBag.HasMore = list.HasNext;
            //ViewBag.ItemCount = list.ItemCount;
            ViewBag.CurrentPage = hddPaging;
            var pagedList = list.ToPagedList<T>(hddPaging.Value, pagesize);
            ViewBag.Pager = pagedList;
            ViewBag.DisplayEntry = new SelectList(Base.PageSizeOptions(), pagesize.ToString());
            ViewBag.SearchValue = search_input;
            ViewBag.SortValue = hddSort;
            ViewBag.PagingValue = hddPaging;
            return pagedList; 
        }

        protected void ShowMessage(string message)
        {
            ClearMessage();
            TempData.Add("message", message);
        }

        protected void ShowSuccess(string message)
        {
            //ShowMessage(message);
            //TempData.Add("isValid", true);
            ModelState.AddModelError("Success", message);
        }

        protected void ShowError(string message)
        {
            //ShowMessage(message);
            //TempData.Add("isValid", false);
            ModelState.AddModelError("Error", message);
        }

        private void ClearMessage()
        {
            TempData.Remove("message");
            TempData.Remove("isValid");
        }
    }
}
