using System.Linq;
using System.Text;
using System.Web.Mvc;
using EM_Report.Common.Utilities;
using EM_Report.Domain;
using EM_Report.Helpers;
using EM_Report.Repositories;
using EM_Report.Domain.Resources;
using EM_Report.ActionServiceReference;

namespace EM_Report.Controllers
{
    public class DashboardLevelController :  BaseController
    {
        //
        // GET: /DashboardLevel/

        public ActionResult Index()
        {
            var hddSort = Base.Page_Sort("Name|desc");
            var pageSize = Base.Page_Size();

            var pagesize = ResourcesHelper.Report_PageSize;

            var list = DashboardLevelRepository.GetList(string.Empty, hddSort);
            var pagedList = UpdateViewBag(string.Empty, hddSort, 1, pageSize, list);

            return View(pagedList);
        }

        [HttpPost]
        public ActionResult Index(FormCollection postForm, string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            var pagesize = int.Parse(Request.Form["cboDisplayEntry"]);
            hddSort = hddSort ?? Base.Page_Sort("DashboardLevelId|desc");

            DashboardLevelRepository.UpdateStatus(StatusRepository.ReplaceNameById(hddAction));

            var list = DashboardLevelRepository.GetList(search_input, hddSort, (int)(hddPaging), pagesize);
            var pagedList = UpdateViewBag<Dashboard_Levels>(search_input, hddSort, (int)(hddPaging), pagesize, list);

            return View(pagedList);
        }

        [HttpPost]
        public ActionResult Details(Dashboard_Levels model)
        {
            if (ModelState.IsValid)
            {
                var sModel = model;

                if (model.DashboardLevelId > 0)
                {
                    DashboardLevelRepository.Update(sModel);
                    ShowSuccess(Resource.msgSaveSuccess);
                }
                else
                {
                    //check sort value existing?
                    var dashboardLevel = DashboardLevelRepository.GetList("","").Where(l=>l.Sort == sModel.Sort);
                    if (dashboardLevel.Count() == 0) //sModel.Sort = (short)(dashboardLevel.Sort + 1);
                    {
                        DashboardLevelRepository.Insert(sModel);
                        return RedirectToAction("index", "DashboardLevel");
                    }
                    else
                    {
                        ShowError("Level" + sModel.Sort + ":" + Resource.msgLevelDuplicate);
                    }

                   
                }
            }
            else
            {
                ShowError(Resource.msgInvalidInput);
            }

            FormViewBag(model);

            return View(model);
        }

        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Details(int? id, string hddSort)
        {
            if (!id.HasValue)
            {
                FormViewBag(null);

                return View();
            }
            else
            {
                var sModel = DashboardLevelRepository.GetById(id ?? 0);
                var model = sModel;
                FormViewBag(model);

                return View(model);
            }           
        }

        protected void FormViewBag(Dashboard_Levels model)
        {                     
            ViewBag.cboStatus = new SelectList(StatusRepository.StatusList(), "StatusId", "Name", model == null ? 0 : model.Status);
        }
    }
}