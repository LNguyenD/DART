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
using System.Web;

namespace EM_Report.Controllers
{
    public class TeamController : BaseController
    {
        public TeamController()
            : base()
        {                          
        }
        [HttpGet]
        public ActionResult Index(string search_input, string hddSort)
        {
            hddSort = Base.Page_Sort("TeamId|desc");
            var pageSize = Base.Page_Size();
            var systemId = Request.QueryString["systemid"] != null ? int.Parse(Request.QueryString["systemid"]) : Base.LoginSession.intSystemId;
            var list = TeamRepository.GetList(string.Empty, hddSort, 1, pageSize, systemId);
            var pagedList = UpdateViewBag<Team>(string.Empty, hddSort, 1, pageSize, list);
            
            return View(pagedList); 
        }
        [HttpPost]
        public ActionResult Index(FormCollection postForm, string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            var pagesize = int.Parse(Request.Form["cboDisplayEntry"]);
            hddSort = hddSort ?? Base.Page_Sort("TeamId|desc");

            TeamRepository.UpdateStatus(StatusRepository.ReplaceNameById(hddAction));

            var list = TeamRepository.GetList(search_input, hddSort, (int)(hddPaging), pagesize, int.Parse(Request["cboSystem"]));
            var pagedList = UpdateViewBag<Team>(search_input, hddSort, (int)(hddPaging), pagesize, list);

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
                var sModel = TeamRepository.GetById(id ?? 0);
                var model = sModel;
                FormViewBag(model);
                return View(model);
            }
        }

        [HttpPost]
        public ActionResult Details(Team model)
        {
            if (ModelState.IsValid)
            {
                var lstSystemSite = UserRepository.GetSystemList();
                var sModel = model;
                if (model.TeamId > 0)
                {

                    TeamRepository.Update(sModel);                    
                    ShowSuccess(Resource.msgSaveSuccess);
                }
                else
                {
                    int _FirstSystemId = 0;
                    foreach (var systemse in lstSystemSite)
                    {
                        if (!string.IsNullOrEmpty(Request.Form["chkSystem_" + systemse.Name]))
                        {
                            if (_FirstSystemId == 0)
                            {
                                _FirstSystemId = int.Parse(Request.Form["chkSystem_" + systemse.Name]);
                            }
                            sModel.SystemId = int.Parse(Request.Form["chkSystem_" + systemse.Name]);
                            TeamRepository.Insert(sModel);
                        }
                    }                   
                    return Redirect(Base.AbsoluteUrl("~/team/?systemid=" + _FirstSystemId));
                }
            }
            else
            {
                ShowError(Resource.msgInvalidInput);
            }
            FormViewBag(model);
            return View(model);
        }

        protected void FormViewBag(Team model)
        {            
            ViewBag.cboStatus = new SelectList(StatusRepository.StatusList(), "StatusId", "Name", model == null ? 0 : model.Status);
            if (model != null)
            {
                ViewBag.cboSystemSite = new SelectList(UserRepository.GetSystemList().ToList(), "SystemId", "Name",model.SystemId);
            }
            else
            {
                ViewBag.cboSystemSite = UserRepository.GetSystemList().ToList();
            }
        }
    }
}
