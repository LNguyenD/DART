using System;
using System.Linq;
using System.Web.Mvc;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.ActionServiceReference;

namespace EM_Report.Controllers
{
    public class Organisation_LevelController : BaseController
    {
        #region public methods

        public ActionResult Index(string search_input, string hddSort)
        {
            var systemId = Request.QueryString["systemid"] != null ? int.Parse(Request.QueryString["systemid"]) : Base.LoginSession.intSystemId;
            ViewBag.LevelList = OrganisationLevelRepository.GetList(string.Empty, string.Empty).AsQueryable().Where(p => p.SystemId == systemId).OrderBy(l => l.Sort);
            ViewBag.cboSystemType = new SelectList(UserRepository.GetSystemList(), "SystemId", "Name", systemId);

            return View();
        }

        [HttpPost]
        public ActionResult Index()
        {
            if (!string.IsNullOrEmpty(Request["itype"]) && Request["itype"] == "level" && !string.IsNullOrEmpty(Request["data"]))
            {
                OrganisationLevelRepository.ReArrangeLevel(Request["data"], Base.LoginSession.intUserId);
            }
            else if (!string.IsNullOrEmpty(Request["itype"]) && Request["itype"] == "role" && !string.IsNullOrEmpty(Request["lid"]) && !string.IsNullOrEmpty(Request["rid"]))
            {
                OrganisationRoleRepository.UpdateLevel(int.Parse(Request["rid"]), int.Parse(Request["lid"]));
            }
            ViewBag.LevelList = OrganisationLevelRepository.GetList(string.Empty, string.Empty).AsQueryable().OrderBy(l => l.Sort);           

            return View();
        }

        #endregion
    }
}