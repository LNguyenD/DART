using System.Linq;
using System.Text;
using System.Web.Mvc;
using EM_Report.Helpers;
using EM_Report.Domain;
using EM_Report.Domain.Resources;
using EM_Report.Common.Utilities;
using System;

namespace EM_Report.Controllers
{
    public class SystemRoleController : BaseController
    {
        [HttpGet]
        public ActionResult Index(string search_input, string hddSort)
        {    
            hddSort = Base.Page_Sort("System_RoleId|desc");
            var pageSize = Base.Page_Size();            
            var pagedList = UpdateViewBag<System_Roles>(search_input, hddSort, 1, pageSize, SystemRoleRepository.GetList(string.Empty, hddSort, 1, pageSize));
            return View(pagedList);
        }

        [HttpPost]
        public ActionResult Index(FormCollection postForm, string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            SystemRoleRepository.Delete(hddAction);
            var pagesize = int.Parse(Request.Form["cboDisplayEntry"]);            
            hddSort = hddSort ?? Base.Page_Sort("System_RoleId|desc");            
            var pagedList = UpdateViewBag<System_Roles>(search_input, hddSort, hddPaging, pagesize, SystemRoleRepository.GetList(search_input, hddSort, 1, ResourcesHelper.Report_PageSize));
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
                var model = SystemRoleRepository.GetById(System.Convert.ToInt32(id));
            
                StringBuilder permission = new StringBuilder();
                var system_permission = SysRolePermissionRepository.GetList().Where(l => l.System_RoleId == id);             
                foreach (var item in system_permission)
                {
                    permission.Append(permission.ToString() != string.Empty ? "," + item.System_PermissionId + "_" + item.PermissionId : item.System_PermissionId + "_" + item.PermissionId);
                }
                FormViewBag(model, permission.ToString());
                return View(model);
            }
        }

        [HttpPost]
        public ActionResult Details(System_Roles model, string hddSystemPermission)
        {
            if (ModelState.IsValid)
            {
                if (model.System_RoleId > 0)
                {
                    if (SystemRoleRepository.Save(model, hddSystemPermission, Base.LoginSession.intUserId))
                    {
                        ModelState.AddModelError("Success", Resource.msgSaveSuccess);
                        FormViewBag(model, hddSystemPermission);
                        if (model.System_RoleId == Base.LoginSession.intSystem_RoleId)
                        {
                            Base.LoginSession.objUserPermission = SysRolePermissionRepository.GetSystemRolePermissions(model.System_RoleId);
                        }
                    }
                    else
                    {
                        ModelState.AddModelError("Error", Resource.msgUpdateError);
                        FormViewBag(model, hddSystemPermission);
                    }
                }
                else
                {                    
                    model.System_RoleId = 0;
                    if (SystemRoleRepository.Save(model, hddSystemPermission, Base.LoginSession.intUserId))
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

        protected void FormViewBag(System_Roles model, string hddSystemPermission)
        {
            ViewBag.System_Permissions = new SelectList(SystemPermissionRepository.GetList().AsEnumerable(), "System_PermissionId", "Name");
            ViewBag.Permissions = new SelectList(PermissionRepository.GetList().AsEnumerable().Where(l => l.PermissionId != long.Parse(Control.Permission_None)), "PermissionId", "Name");
            if (hddSystemPermission != string.Empty)
            {
                ViewBag.I_Permissions = hddSystemPermission;
            }
        }
    }
}
