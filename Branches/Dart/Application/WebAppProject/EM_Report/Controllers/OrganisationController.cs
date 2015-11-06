using EM_Report.Domain;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using System.Web.Script.Serialization;

namespace EM_Report.Controllers
{
    public class OrganisationController : BaseController
    {
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
                var model = OrganisationRoleRepository.Get((int)id);
                FormViewBag(model);
                return View(model);
            }
        }

        [HttpPost]
        public ActionResult Details(Organisation_Roles model)
        {
            var tModel = model;
            if (ModelState.IsValid)
            {
                if (model.Organisation_RoleId > 0)
                {
                    if (!string.IsNullOrEmpty(Request.Form["cbolevel"]))
                    {
                        tModel.LevelId = Int16.Parse(Request.Form["cbolevel"]);
                        OrganisationRoleRepository.Update(tModel);
                        ShowSuccess(Resource.msgSaveSuccess);
                    }
                }
                else
                {
                    var lstSystem = UserRepository.GetSystemList();
                    foreach (var s in lstSystem)
                    {
                        if (!string.IsNullOrEmpty(Request.Form["cbolevel" + s.Name]))
                        {
                            tModel.LevelId = Int16.Parse(Request.Form["cbolevel" + s.Name]);
                            OrganisationRoleRepository.Create(tModel);
                        }
                    }

                    return RedirectToAction("index", "organisation_level", new { systemid = model.SystemId });
                }
            }
            else
            {
                ShowError(Resource.msgInvalidInput);
            }
            FormViewBag(model);
            return View(model);
        }

        public string LevelList(int systemId)
        {
            var lstLevel = OrganisationLevelRepository.GetList().Where(e => e.SystemId == systemId).ToList();
            var systemLevel = new List<SelectListItem>();
            foreach (var organisationLevelse in lstLevel)
            {
                systemLevel.Add(new SelectListItem() { Text = organisationLevelse.Name, Value = organisationLevelse.LevelId.ToString() });
            }

            return new JavaScriptSerializer().Serialize(systemLevel);
        }

        protected void FormViewBag(Organisation_Roles model)
        {
            ViewBag.cboStatus = new SelectList(StatusRepository.StatusList(), "StatusId", "Name", model == null ? 0 : model.Status);
            ViewBag.LevelListTMF = new SelectList(OrganisationLevelRepository.GetList().Where(e => e.SystemId == 2), "LevelId", "Name");
            ViewBag.LevelListHEM = new SelectList(OrganisationLevelRepository.GetList().Where(e => e.SystemId == 1), "LevelId", "Name");
            ViewBag.LevelListEML = new SelectList(OrganisationLevelRepository.GetList().Where(e => e.SystemId == 3), "LevelId", "Name");
            ViewBag.LevelList = new SelectList(OrganisationLevelRepository.GetList().Where(e => e.SystemId == (model != null ? model.SystemId : Base.LoginSession.intSystemId)), "LevelId", "Name", model != null ? model.LevelId : 0);
            ViewBag.cboSystemType = new SelectList(UserRepository.GetSystemList(), "SystemId", "Name", model != null ? model.SystemId : Base.LoginSession.intSystemId);
        }
    }
}