using System;
using System.Linq;
using System.Web.Mvc;
using EM_Report.BLL.Commons;
using EM_Report.BLL.Resources;
using EM_Report.BLL.Services;
using EM_Report.Helpers;
using EM_Report.Models;

namespace EM_Report.Controllers
{
    public class ExternalController : BaseController
    {
        private I_External_GroupService _qExternal_GroupService = new External_GroupService(Base.LoginSession);
        private I_UserService _qUserService = new UserService(Base.LoginSession);

        [HttpGet]
        public ActionResult Index(string search_input, string hddSort)
        {
            var list = _qExternal_GroupService.GetAllQueryable(hddSort ?? "External_GroupId|desc", string.Empty);
            var pagedList = UpdateViewBag<External_GroupModel>(search_input, hddSort, 1, ResourcesHelper.Report_PageSize, list);
            return View(pagedList);  
        }

        [HttpPost]
        public ActionResult Index(FormCollection postForm, string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            if (hddAction != null && hddAction != string.Empty)
            {
                External_GroupModel model;
                string[] hddActionSplit = hddAction.Split('|');
                if (hddActionSplit.Length > 0)
                {
                    foreach (var item in hddActionSplit[1].Split(','))
                    {
                        model = _qExternal_GroupService.GetById(long.Parse(item));
                        _qExternal_GroupService.UpdateStatus(model, short.Parse(hddActionSplit[0]));
                    }
                }
            }

            var pagesize = int.Parse(Request.Form["cboDisplayEntry"]);
            hddSort = hddSort == null || hddSort == string.Empty ? "External_GroupId|desc" : hddSort;
            var list = _qExternal_GroupService.GetAllQueryable(hddSort, search_input);
            var pagedList = UpdateViewBag<External_GroupModel>(search_input, hddSort, hddPaging, pagesize, list);
            return View(pagedList);
        }

        [HttpGet]
        public ActionResult Details(long? id)
        {
            if (!id.HasValue)
            {
                FormViewBag(null);
                return View();
            }
            else
            {
                var model = _qExternal_GroupService.GetById(id);
                model.OwnerName = model.Owner != 0 ? _qUserService.GetById(model.Owner).UserName : string.Empty;
                FormViewBag(model);
                return View(model);
            }            
        }

        [HttpPost]
        public ActionResult Details(External_GroupModel model)
        {
            if (ModelState.IsValid)
            {
                if (model.External_GroupId > 0)
                {
                    _qExternal_GroupService.Update(model, model.External_GroupId);
                    model.OwnerName = model.Owner != 0 ? _qUserService.GetById(model.Owner).UserName : string.Empty;
                    ShowSuccess(Resource.msgSaveSuccess);
                }
                else
                {
                    model.Create_Date = DateTime.Now;
                    model.Owner = Base.LoginSession.intUserId;
                    model.Description = model.Description ?? string.Empty;
                    _qExternal_GroupService.Create(model);
                    return RedirectToAction("index", "external");
                }
            }
            else
            {
                ShowError(Resource.msgInvalidInput);
            }
            FormViewBag(model);
            return View(model);
        }       

        protected void FormViewBag(External_GroupModel model)
        {
            ViewBag.cboStatus = new SelectList(Base.StatusList(), "StatusId", "Name", model == null ? short.Parse(BLL.Resources.Control.Status_Active) : model.Status);
        }
    }
}
