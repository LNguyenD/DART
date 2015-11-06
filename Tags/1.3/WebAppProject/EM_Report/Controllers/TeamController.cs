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
    public class TeamController : BaseController
    {
        private I_TeamService _qTeamService = new TeamService(Base.LoginSession);
        private I_UserService _qUserService = new UserService(Base.LoginSession);
        [HttpGet]
        public ActionResult Index(string search_input, string hddSort)
        {            
            var list = _qTeamService.GetAllQueryable(hddSort ?? "TeamId|desc", string.Empty);            
            var pagedList = UpdateViewBag<TeamModel>(search_input, hddSort, 1, ResourcesHelper.Report_PageSize, list);
            return View(pagedList);  
        }

        [HttpPost]
        public ActionResult Index(FormCollection postForm, string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            if (hddAction != null && hddAction != string.Empty)
            {
                TeamModel model;
                string[] hddActionSplit = hddAction.Split('|');
                if (hddActionSplit.Length > 0)
                {
                    foreach (var item in hddActionSplit[1].Split(','))
                    {
                        model = _qTeamService.GetById(long.Parse(item));
                        _qTeamService.UpdateStatus(model, short.Parse(hddActionSplit[0]));
                    }
                }
            }

            var pagesize = int.Parse(Request.Form["cboDisplayEntry"]);
            hddSort = string.IsNullOrEmpty(hddSort) ? "TeamId|desc" : hddSort;
            var list = _qTeamService.GetAllQueryable(hddSort, search_input);
            var pagedList = UpdateViewBag<TeamModel>(search_input, hddSort, hddPaging, pagesize, list);
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
                var model = _qTeamService.GetById(id);
                model.OwnerName = model.Owner != 0 ? _qUserService.GetById(model.Owner).UserName : string.Empty;
                FormViewBag(model);
                return View(model);
            }
        }

        [HttpPost]
        public ActionResult Details(TeamModel model)
        {
            if (ModelState.IsValid)
            {
                if (model.TeamId > 0)
                {
                    _qTeamService.Update(model, model.TeamId);
                    model.OwnerName = model.Owner != 0 ? _qUserService.GetById(model.Owner).UserName : string.Empty;
                    ShowSuccess(Resource.msgSaveSuccess);
                }
                else
                {
                    model.Create_Date = DateTime.Now;
                    model.Owner = Base.LoginSession.intUserId;
                    model.Description = model.Description ?? string.Empty;
                    _qTeamService.Create(model);
                    return RedirectToAction("index", "team");
                }
            }
            else
            {
                ShowError(Resource.msgInvalidInput);
            }
            FormViewBag(model);
            return View(model);
        }       

        protected void FormViewBag(TeamModel model)
        {
            ViewBag.cboStatus = new SelectList(Base.StatusList(), "StatusId", "Name", model == null ? short.Parse(BLL.Resources.Control.Status_Active) : model.Status);
        }
    }
}
