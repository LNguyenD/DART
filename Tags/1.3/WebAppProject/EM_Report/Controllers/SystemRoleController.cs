using System.Linq;
using System.Text;
using System.Web.Mvc;
using EM_Report.BLL.Commons;
using EM_Report.BLL.Resources;
using EM_Report.BLL.Services;
using EM_Report.Helpers;
using EM_Report.Models;

namespace EM_Report.Controllers
{
    public class SystemRoleController : BaseController
    {
        private I_System_RolesService _qSystem_RolesService = new System_RolesService(Base.LoginSession);
        private I_PermissionService _qPermissionService = new PermissionService(Base.LoginSession);
        private I_System_PermissionService _qSystem_PermissionService = new System_PermissionService(Base.LoginSession);
        private I_System_Role_PermissionsService _qSystem_Role_PermissionService = new System_Role_PermissionsService(Base.LoginSession);

        [HttpGet]
        public ActionResult Index(string search_input, string hddSort)
        {                    
            var list = _qSystem_RolesService.GetAllQueryable(hddSort ?? "System_RoleId|desc", string.Empty);
            var pagedList = UpdateViewBag<System_RolesModel>(search_input, hddSort, 1, ResourcesHelper.Report_PageSize, list);
            return View(pagedList);
        }

        [HttpPost]
        public ActionResult Index(FormCollection postForm, string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            if (hddAction != null && hddAction != string.Empty)
            {
                string[] hddActionSplit = hddAction.Split('|');
                if (hddActionSplit.Length > 0)
                {
                    foreach (var item in hddActionSplit[1].Split(','))
                    {
                        _qSystem_RolesService.Delete(item);
                    }
                }
            }

            var pagesize = int.Parse(Request.Form["cboDisplayEntry"]);
            hddSort = string.IsNullOrEmpty(hddSort) ? "System_RoleId|desc" : hddSort;
            var list = _qSystem_RolesService.GetAllQueryable(hddSort, search_input);
            var pagedList = UpdateViewBag<System_RolesModel>(search_input, hddSort, hddPaging, pagesize, list);
            return View(pagedList);
        }

        [HttpGet]
        public ActionResult Details(long? id)
        {
            if (!id.HasValue)
            {
                FormViewBag(null, string.Empty);
                return View();
            }
            else
            {
                var model = _qSystem_RolesService.GetById(id);
                StringBuilder permission = new StringBuilder();
                var system_permission = _qSystem_Role_PermissionService.GetAll().Where(l => l.System_RoleId == id);
                foreach (var item in system_permission)
                {
                    permission.Append(permission.ToString() != string.Empty ? "," + item.System_PermissionId + "_" + item.PermissionId : item.System_PermissionId + "_" + item.PermissionId);
                }
                FormViewBag(model, permission.ToString());                
                return View(model);
            }
        }

        [HttpPost]
        public ActionResult Details(System_RolesModel model, string hddSystemPermission)
        {
            if (ModelState.IsValid)
            {
                if (model.System_RoleId > 0)
                {
                    if (_qSystem_RolesService.Save(model.System_RoleId, model.Name, model.Description ?? string.Empty, hddSystemPermission))
                    {
                        ModelState.AddModelError("Success", Resource.msgSaveSuccess);
                        FormViewBag(model, hddSystemPermission);
                    }
                    else
                    {
                        ModelState.AddModelError("Error", Resource.msgUpdateError);
                        FormViewBag(model, hddSystemPermission);
                    }
                }
                else
                {
                    if (_qSystem_RolesService.Save(0, model.Name, model.Description ?? string.Empty, hddSystemPermission))
                    {
                        return RedirectToAction("index", "systemrole");
                    }
                    else
                    {
                        ModelState.AddModelError("Error", Resource.msgSaveFail);
                        FormViewBag(model, hddSystemPermission);
                    }
                }
            }
            else
            {
                ShowError(Resource.msgInvalidInput);
                FormViewBag(model, hddSystemPermission);
            }
            return View(model);
        }  

        [HttpGet]
        public ActionResult Edit(long id)
        {
            var model = _qSystem_RolesService.GetById(id);                        

            StringBuilder permission = new StringBuilder();
            var system_permission = _qSystem_Role_PermissionService.GetAll().Where(l => l.System_RoleId == id);
            foreach (var item in system_permission)
            {
                permission.Append(permission.ToString() != string.Empty ? "," + item.System_PermissionId + "_" + item.PermissionId : item.System_PermissionId + "_" + item.PermissionId);
            }
            FormViewBag(model, permission.ToString());
            return View(model);
        }

        [HttpPost]
        public ActionResult Edit(System_RolesModel model, string hddSystemPermission)
        {
            if (_qSystem_RolesService.Save(model.System_RoleId, model.Name, model.Description??string.Empty, hddSystemPermission))
            {
                ModelState.AddModelError("Success", Resource.msgSaveSuccess);
                FormViewBag(model, hddSystemPermission);
            }
            else
            {
                ModelState.AddModelError("Error", Resource.msgUpdateError);
                FormViewBag(model, hddSystemPermission);
            }
            return View(model);
        }

        [HttpGet]
        public ActionResult Create()
        {
            FormViewBag(null, string.Empty);
            return View();
        }

        [HttpPost]
        public ActionResult Create(System_RolesModel model,string hddSystemPermission)
        {
            if (_qSystem_RolesService.Save(0, model.Name, model.Description ?? string.Empty, hddSystemPermission))
            {
                return RedirectToAction("Index", "SystemRole");
            }
            else
            {
                ModelState.AddModelError("Error",Resource.msgSaveFail);
                FormViewBag(model, hddSystemPermission);
            }
            return View(model);
        }

        protected void FormViewBag(System_RolesModel model, string hddSystemPermission)
        {
            ViewBag.System_Permissions = new SelectList(_qSystem_PermissionService.GetAll().AsEnumerable(), "System_PermissionId", "Name");
            ViewBag.Permissions = new SelectList(_qPermissionService.GetAll().AsEnumerable().Where(l => l.PermissionId != long.Parse(Control.Permission_None)), "PermissionId", "Name");
            if (hddSystemPermission != string.Empty)
            {
                ViewBag.I_Permissions = hddSystemPermission;
            }
        }
    }
}
