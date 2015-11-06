using System;
using System.Linq;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.ActionServiceReference;
using EM_Report.Common.Utilities;
using EM_Report.Domain;

namespace EM_Report.Controllers
{
    public class LevelController : BaseController
    {
        #region private method
        private ActionResult Save(Organisation_Levels model)
        {
            if (ModelState.IsValid)
            {
                var isNew = model.LevelId <= 0;
                model.Owner = (model.Owner <= 0 && isNew) ? Base.LoginSession.intUserId : model.Owner;
                model.OwnerName = Base.LoginSession.strUserName;
                try
                {
                    if (isNew)
                    {
                        model.Sort = OrganisationLevelRepository.GetList("", "").AsEnumerable().Select(al => al.Sort).Distinct().ToList().Max() + 1;
                    }

                    if (model.LevelId > 0)
                        OrganisationLevelRepository.Update(model);
                    else
                    {
                        var lstSystem = UserRepository.GetSystemList();
                        foreach (var s in lstSystem)
                        {
                            if(!string.IsNullOrEmpty(Request.Form["chkSystem_"+s.Name]))
                            {
                                model.SystemId = s.SystemId;
                                OrganisationLevelRepository.Create(model);
                            }
                        }
                    
                       }
                    if (isNew)
                        return RedirectToAction("index", "organisation_level", new { systemid = model.SystemId });

                    ShowSuccess(Resource.msgSaveSuccess);
                }
                catch
                {
                    ShowError(Resource.msgUpdateError);
                }
            }
            else
            {
                ShowError(Resource.msgInvalidInput);
            }

            GetFormDropdownlist(model.LevelId);

            return View(model);
        }

        private ActionResult Delete(Organisation_Levels model)
        {
            try
            {
                OrganisationLevelRepository.Delete(model.LevelId);

                return RedirectToAction("Index", new { systemid = model.SystemId });
            }
            catch
            {
                ShowError(Resource.msgDeleteError);
            }

            return View(model);
        }

        private void GetFormDropdownlist(int? id)
        {            
            ViewBag.RoleList = OrganisationRoleRepository.GetRolesOfLevel(id ?? 0);
            ViewBag.chkSystemSite = UserRepository.GetSystemList().ToList();
            ViewBag.cboSystemSite = new SelectList(UserRepository.GetSystemList(), "SystemId", "Name");
            ViewBag.cboStatus = new SelectList(StatusRepository.StatusList(), "StatusId", "Name",id);
        }

        private ActionResult AssignRolesToLevel(Organisation_Levels level)
        {
            var selectedId = Request.Form["firstList"];
            if (!string.IsNullOrEmpty(selectedId))
            {
                var roleList = OrganisationRoleRepository.GetList(string.Empty, "Name|asc").ToList();
                foreach (var id in selectedId.Split(','))
                {
                    var role = roleList.Where(r => r.Organisation_RoleId == int.Parse(id)).FirstOrDefault();
                    if (role != null)
                    {
                        role.LevelId = level.LevelId;
                        OrganisationRoleRepository.Update(role);
                    }
                }
            }
            GetFormDropdownlist(level.LevelId);
            return View(level);
        }

        #endregion

        #region public methods       

        [HttpGet]
        public ActionResult Details(int? id, string hddSort)
        {
            GetFormDropdownlist(id);
            if (!id.HasValue)
                return View();

            try
            {
                var model = OrganisationLevelRepository.Get(id.Value);                
                return View(model);
            }
            catch (Exception)
            {
                ShowError(Resource.msgLoadError);
            }
            return null;
        }

        [HttpPost]
        public ActionResult Details(Organisation_Levels model, string hddAction, string hddSort, int? hddPaging = 1)
        {
            var tModel = model;  
            
            switch (Request.Form["action"].ToLower())
            {
                case "save":                    
                    return Save(tModel);
                case "delete":
                    return Delete(tModel);
                case "assign":
                    return AssignRolesToLevel(tModel);
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
