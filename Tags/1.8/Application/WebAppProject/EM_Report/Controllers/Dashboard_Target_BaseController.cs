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
    public class Dashboard_Target_BaseController : BaseController
    {
        
        [HttpGet]
        public ActionResult Index(string search_input, string hddSort)
        {
            hddSort = Base.Page_Sort("Id|desc");
            var pageSize = Base.Page_Size();
            var systemId = Request.QueryString["systemid"] != null ? int.Parse(Request.QueryString["systemid"]) : Base.LoginSession.intSystemId;
            var list = Dashboard_Target_BaseRepository.GetList(UserRepository.GetSystemNameById(systemId), string.Empty, hddSort, 1, pageSize);

            var pagedList = UpdateViewBag<Dashboard_Target_Base>(string.Empty, hddSort, 1, pageSize, list);

            return View(pagedList);
        }

        [HttpPost]
        public ActionResult Index(FormCollection postForm, string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            var pagesize = int.Parse(Request.Form["cboDisplayEntry"]);
            hddSort = hddSort ?? Base.Page_Sort("Id|desc");
            var Url = Request.UrlReferrer.ToString().ToLower();
            var SystemIdUrl = Url.Substring(Url.IndexOf("systemid"));
            var systemId = int.Parse(SystemIdUrl.Substring(SystemIdUrl.IndexOf("=") + 1));
            var list = Dashboard_Target_BaseRepository.GetList(UserRepository.GetSystemNameById(systemId), search_input, hddSort, (int)(hddPaging), pagesize);
            var pagedList = UpdateViewBag<Dashboard_Target_Base>(search_input, hddSort, (int)(hddPaging), pagesize, list);

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
                var systemId = Request.QueryString["systemid"] != null ? int.Parse(Request.QueryString["systemid"]) : Base.LoginSession.intSystemId;
                var sModel = Dashboard_Target_BaseRepository.GetById(UserRepository.GetSystemNameById(systemId), id ?? 0);
                var model = sModel;

                FormViewBag(model);
                return View(model);
            }
        }

        [HttpPost]
        public ActionResult Details(Dashboard_Target_Base model)
        {
            if (ModelState.IsValid)
            {
                var lstSystemSite = UserRepository.GetSystemList();
                var systemId = Request.QueryString["systemid"] != null ? int.Parse(Request.QueryString["systemid"]) : Base.LoginSession.intSystemId;
                var sModel = model;
                if (model.Id > 0)
                {
                    Dashboard_Target_BaseRepository.Update(UserRepository.GetSystemNameById(systemId), sModel);
                    ShowSuccess(Resource.msgSaveSuccess);
                }
                else
                {
                    Dashboard_Target_BaseRepository.Insert(UserRepository.GetSystemNameById(systemId), sModel);
                    return RedirectToAction("index", "Dashboard_Target_Base", new { systemid = systemId });
                }
            }
            else
            {
                ShowError(Resource.msgInvalidInput);
            }

            FormViewBag(model);
            return View(model);
        }        

        [HttpPost]
        public ActionResult DeleteAll(int systemId)
        {
            try
            {
                var systemName = UserRepository.GetSystemNameById(systemId);
                Dashboard_Target_BaseRepository.DeleteAll(systemName);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500);
            }

            return new HttpStatusCodeResult(200);
        }       

        protected void FormViewBag(Dashboard_Target_Base model)
        {
            if (model != null)
            {
                ViewBag.cboSystemSite = new SelectList(UserRepository.GetSystemList().ToList(), "SystemId", "Name", model.Id);
            }
            else
            {
                ViewBag.cboSystemSite = UserRepository.GetSystemList().ToList();
            }
        }
    }
}