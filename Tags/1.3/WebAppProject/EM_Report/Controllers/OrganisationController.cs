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
    public class OrganisationController : BaseController
    {
        private I_Organisation_RolesService _qOrganisation_RolesService;
        private I_UserService _qUserService;
        private I_Organisation_Levels_Service _levelService;

        public I_UserService QUserService
        {
            get { return _qUserService; }
            set { _qUserService = value; }
        }

        public I_Organisation_RolesService QOrganisation_RolesService
        {
            get { return _qOrganisation_RolesService; }
            set { _qOrganisation_RolesService = value; }
        }
        public I_Organisation_Levels_Service LevelService
        {
            get { return _levelService; }
            set { _levelService = value; }
        }

        public OrganisationController()
            : base()
        {
            _qOrganisation_RolesService = new Organisation_RolesService(Base.LoginSession);
            _qUserService = new UserService(Base.LoginSession);
            _levelService = new Organisation_Levels_Service(Base.LoginSession);
        }

        [HttpGet]
        public ActionResult Index(string search_input, string hddSort)
        {
            var list = _qOrganisation_RolesService.GetAllQueryable(hddSort ?? "Organisation_RoleId|desc", string.Empty);
            var pagedList = UpdateViewBag<Organisation_RolesModel>(search_input, hddSort, 1, ResourcesHelper.Report_PageSize, list);
            return View(pagedList);    
        }

        [HttpPost]
        public ActionResult Index(FormCollection postForm, string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            if (hddAction != null && hddAction != string.Empty)
            {
                Organisation_RolesModel model;
                string[] hddActionSplit = hddAction.Split('|');
                if (hddActionSplit.Length > 0)
                {
                    foreach (var item in hddActionSplit[1].Split(','))
                    {
                        model = _qOrganisation_RolesService.GetById(long.Parse(item));
                        _qOrganisation_RolesService.UpdateStatus(model, short.Parse(hddActionSplit[0]));
                    }
                }
            }

            var pagesize = int.Parse(Request.Form["cboDisplayEntry"]);
            hddSort = string.IsNullOrEmpty(hddSort) ? "Organisation_RoleId|desc" : hddSort;

            var list = _qOrganisation_RolesService.GetAllQueryable(hddSort, search_input);
            var pagedList = UpdateViewBag<Organisation_RolesModel>(search_input, hddSort, hddPaging, pagesize, list);
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
                var model = _qOrganisation_RolesService.GetById(id);
                model.OwnerName = model.Owner != 0 ? _qUserService.GetById(model.Owner).UserName : string.Empty;
                FormViewBag(model);
                return View(model);
            }
        }

        [HttpPost]
        public ActionResult Details(Organisation_RolesModel model)
        {
            if (ModelState.IsValid)
            {
                if (model.Organisation_RoleId > 0)
                {
                    _qOrganisation_RolesService.Update(model, model.Organisation_RoleId);
                    model.OwnerName = model.Owner != 0 ? _qUserService.GetById(model.Owner).UserName : string.Empty;                                   
                    ShowSuccess(Resource.msgSaveSuccess);
                }
                else
                {
                    model.Create_Date = DateTime.Now;
                    model.Owner = Base.LoginSession.intUserId;
                    model.Description = model.Description ?? string.Empty;
                    _qOrganisation_RolesService.Create(model);
                    return RedirectToAction("index", "organisation_level");
                }
            }
            else
            {
                ShowError(Resource.msgInvalidInput);
            }
            FormViewBag(model);
            return View(model);
        }        
       
        protected void FormViewBag(Organisation_RolesModel model)
        {
            ViewBag.cboStatus = new SelectList(Base.StatusList(), "StatusId", "Name", model == null ? short.Parse(BLL.Resources.Control.Status_Active) : model.Status);
            ViewBag.LevelList = new SelectList(LevelService.GetAll(), "LevelId", "Name");
        }
    }
}
