using System;
using System.Linq;
using System.Web.Mvc;
using EM_Report.BLL.Commons;
using EM_Report.BLL.Resources;
using EM_Report.BLL.Services;
using EM_Report.Helpers;
using EM_Report.Models;
using System.Collections;

namespace EM_Report.Controllers
{
    public class Organisation_LevelController : BaseController
    {
        #region private member variables
        private I_Organisation_Levels_Service _levelService;
        private I_Organisation_RolesService _roleService;

        #endregion

        #region public properties
        public I_Organisation_RolesService RoleService
        {
            get { return _roleService; }
            set { _roleService = value; }
        }
        public I_Organisation_Levels_Service LevelService
        {
          get { return _levelService; }
          set { _levelService = value; }
        }
        #endregion

        #region constructor
        //
        // GET: /Permission/
        public Organisation_LevelController()
            : base()
        {
            _levelService = new Organisation_Levels_Service(Base.LoginSession);
            _roleService = new Organisation_RolesService(Base.LoginSession);
        }
        #endregion

        #region private method
        private ActionResult Save(Organisation_Levels_Model model)
        {
            if (ModelState.IsValid)
            {
                var isNew = model.LevelId <= 0;
                model.Owner = (model.Owner <= 0 && isNew) ? Base.LoginSession.intUserId : model.Owner;
                model.OwnerName = Base.LoginSession.strUserName;
                try
                {
                    model = _levelService.CreateOrUpdate(model);
                    if (isNew)
                        return RedirectToAction("Index");
                    ShowSuccess(Resource.msgSaveSuccess);
                }
                catch
                {
                    ShowError(Resource.msgUpdateError);
                }

            }
            GetFormDropdownlist(model.LevelId);
            return View(model);

        }

        private ActionResult Delete(Organisation_Levels_Model model)
        {
            try
            {
                _levelService.Delete(model.LevelId);
                return RedirectToAction("Index");
            }
            catch
            {
                ShowError(Resource.msgDeleteError);
            }
            return View(model);
        }

        private void GetFormDropdownlist(int? id)
        {
            ViewBag.ParentList = LevelService.GetAll().Where(l => l.LevelId != id);
            ViewBag.RoleList = RoleService.GetRoleOfLevel(id ?? 0);
            ViewBag.AllRoleList = RoleService.GetAllQueryable("Name|asc", string.Empty);
        }

        private ActionResult AssignRolesToLevel(Organisation_Levels_Model level)
        {
            var selectedId = Request.Form["firstList"];
            if (!string.IsNullOrEmpty(selectedId))
            {
                var roleList = RoleService.GetAllQueryable("Name|asc", string.Empty).ToList();
                foreach (var id in selectedId.Split(','))
                {
                    var role = roleList.Where(r => r.Organisation_RoleId == int.Parse(id)).FirstOrDefault();
                    if (role != null)
                    {
                        role.LevelId = level.LevelId;
                        RoleService.Update(role, role.Organisation_RoleId);
                    }
                }
            }
            GetFormDropdownlist(level.LevelId);
            return View(level);
        }
        #endregion

        #region public methods
        public ActionResult Index(string search_input, string hddSort)
        {
            ViewBag.LevelList = LevelService.GetAllQueryable("", "").OrderBy(l=>l.Sort);            
            return View();
        }

        [HttpPost]
        public ActionResult Index()
        {
            if (!string.IsNullOrEmpty(Request["itype"]) && Request["itype"] =="level" && !string.IsNullOrEmpty(Request["data"]))
            {
                LevelService.ReArrangeLevel(Request["data"]);
            }
            else if (!string.IsNullOrEmpty(Request["itype"]) && Request["itype"] == "role" && !string.IsNullOrEmpty(Request["lid"]) && !string.IsNullOrEmpty(Request["rid"]))
            {
                RoleService.UpdateLevel(int.Parse(Request["rid"]), int.Parse(Request["lid"]));
            }
            ViewBag.LevelList = LevelService.GetAllQueryable("", "").OrderBy(l => l.Sort);
            return View();
        }

        [HttpGet]
        public ActionResult Details(int? id, string hddSort)
        {
            GetFormDropdownlist(id);
            var model = new Organisation_Levels_Model();
            if (!id.HasValue)
                return View(model);

            try
            {
                model = LevelService.GetById(id.Value);
            }
            catch (Exception)
            {
                ShowError(Resource.msgLoadError);
            }
            return View(model);
        }

        [HttpPost]
        public ActionResult Details(Organisation_Levels_Model model, string hddAction, string hddSort, int? hddPaging = 1)
        {
            switch (Request.Form["action"].ToLower())
            {
                case "save":
                    model.Sort = int.Parse(Request.Form["cboParentLevel"]);
                    return Save(model);
                case "delete":
                    return Delete(model);
                case "assign":
                    return AssignRolesToLevel(model);
                case "unassign":
                default:
                    break;

            }
            GetFormDropdownlist(model.LevelId);
            return View();
        }

        #endregion
    }
}
