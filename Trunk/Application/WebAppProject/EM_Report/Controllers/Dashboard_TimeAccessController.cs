using System;
using System.Configuration;
using System.Linq;
using System.Web.Mvc;
using System.Collections.Generic;
using EM_Report.Common.Utilities;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Domain;
using System.Web.Script.Serialization;
using EM_Report.Repositories;

namespace EM_Report.Controllers
{
    public class Dashboard_TimeAccessController : BaseController
    {
        [HttpGet]
        public ActionResult Index(string search_input, string hddSort)
        {
            hddSort = Base.Page_Sort("Id|desc");
            var pageSize = Base.Page_Size();
            var systemId = Request.QueryString["systemid"] != null ? int.Parse(Request.QueryString["systemid"]) : Base.LoginSession.intSystemId;
            var list = Dashboard_TimeAccessRepository.GetList(string.Empty, hddSort, 1, pageSize, systemId);

            var pagedList = UpdateViewBag<Dashboard_TimeAccess>(string.Empty, hddSort, 1, pageSize, list);
            return View(pagedList);
        }

        [HttpPost]
        public ActionResult Index(FormCollection postForm, string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            var pagesize = int.Parse(Request.Form["cboDisplayEntry"]);
            hddSort = hddSort ?? Base.Page_Sort("Id|desc");

            var list = Dashboard_TimeAccessRepository.GetList(search_input, hddSort, (int)(hddPaging), pagesize, int.Parse(Request["cboSystem"]));
            var pagedList = UpdateViewBag<Dashboard_TimeAccess>(search_input, hddSort, (int)(hddPaging), pagesize, list);

            return View(pagedList);
        }

        [HttpGet]
        public ActionResult Details(int? id)
        {
            if (!id.HasValue)
            {
                FormViewBag(null);

                return View();
            }
            else
            {
                var sModel = Dashboard_TimeAccessRepository.GetById(id ?? 0);
                var model = sModel;
                FormViewBag(model);
                return View(model);
            }
        }

        [HttpPost]
        public ActionResult Details(string url, string starttime, string endtime)
        {
            var model = new Dashboard_TimeAccess();

            if (url != null && starttime != null && endtime != null)
            {
                model.Url = url;
                model.UserId = Base.LoginSession.intUserId;
                model.StartTime = DateTime.Parse(starttime);
                model.EndTime = DateTime.Parse(endtime);
                model.Create_Date = DateTime.Now;
                model.Owner = Base.LoginSession.intUserId;
                model.UpdatedBy = Base.LoginSession.intUserId;
                model.Status = StatusRepository.GetStatusIdByName("Active"); //Temporarily set Status of Time Access to Active
                Dashboard_TimeAccessRepository.Insert(model);
            }
            return PartialView("Details", null);
        }

        protected void FormViewBag(Dashboard_TimeAccess model)
        {
            if (model != null)
            {
                //ViewBag.cboSystemSite = new SelectList(UserRepository.GetSystemList().ToList(), "SystemId", "Name", model.SystemId);
            }
            else
            {
                ViewBag.cboSystemSite = UserRepository.GetSystemList().ToList();
            }
        }
    }
}
