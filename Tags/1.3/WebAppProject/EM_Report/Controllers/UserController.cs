using System;
using System.Configuration;
using System.Linq;
using System.Web.Mvc;
using System.Collections.Generic;
using EM_Report.BLL.Commons;
using EM_Report.BLL.Resources;
using EM_Report.BLL.Services;
using EM_Report.Helpers;
using EM_Report.Models;
using System.Web.Script.Serialization;

namespace EM_Report.Controllers
{
    public class UserController : BaseController
    {
        private I_UserService _qUserService = new UserService(Base.LoginSession);
        private I_TeamService _qTeamServiceService = new TeamService(Base.LoginSession);
        private I_External_GroupService _qExternal_GroupService = new External_GroupService(Base.LoginSession);
        private I_System_RolesService _qSystem_RolesService = new System_RolesService(Base.LoginSession);
        private I_Organisation_RolesService _qOrganisation_RolesService = new Organisation_RolesService(Base.LoginSession);
        private I_Organisation_Levels_Service _qOrganisation_Roles_LevelService = new Organisation_Levels_Service(Base.LoginSession);

        [HttpGet]
        public ActionResult Index()
        {
            var list = _qUserService.GetAllQueryable("UserName|asc", string.Empty);
            var pagedList = UpdateViewBag<UserModel>(string.Empty, string.Empty, 1, ResourcesHelper.Report_PageSize, list);
            return View(pagedList);
        }

        [HttpPost]
        public ActionResult Index(string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            if (hddAction != null && hddAction != string.Empty)
            {
                UserModel model;
                string[] hddActionSplit = hddAction.Split('|');
                if (hddActionSplit.Length > 0)
                {
                    foreach (var item in hddActionSplit[1].Split(','))
                    {
                        model = _qUserService.GetById(int.Parse(item));
                        _qUserService.UpdateStatus(model, short.Parse(hddActionSplit[0]));
                    }
                }
            }

            var pagesize = int.Parse(Request.Form["cboDisplayEntry"]);
            hddSort = string.IsNullOrEmpty(hddSort) ? "UserName|asc" : hddSort;
            var list = _qUserService.GetAllQueryable(hddSort, search_input);
            var pagedList = UpdateViewBag<UserModel>(search_input, hddSort, hddPaging, pagesize, list);
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
                var model = _qUserService.GetUserById(id??0);                
                FormViewBag(model);
                return View(model);
            }            
        }

        [HttpPost]
        public ActionResult Details(UserModel model)
        {
            if (ModelState.IsValid)
            {
                if (model.UserId > 0)
                {
                    if (_qUserService.IsValidUser(model, model.UserId))
                    {
                        var user = _qUserService.GetById(model.UserId);
                        if (user != null && user.Password == model.Password)
                        {
                            model.Password = model.Password;
                        }
                        else
                        {
                            model.Password = CryptMD5.EncryptMD5WithSalt(model.Password, ConfigurationManager.AppSettings["PassWordSalt"]);
                        }
                        _qUserService.UpdateUser(model);                        
                        ShowSuccess(Resource.msgSaveSuccess);                    
                    }
                    else
                    {                        
                        ShowError(Resource.msgUserDuplicate);                         
                    }                   
                }
                else
                {
                    if (_qUserService.IsValidUser(model))
                    {
                        string password = model.Password;
                        model.Password = CryptMD5.EncryptMD5WithSalt(password, ConfigurationManager.AppSettings["PassWordSalt"]);
                        model.Create_Date = DateTime.Now;
                        model.Owner = Base.LoginSession.intUserId;
                        if (Request.Form["Is_System_User"] == "False")
                        {
                            if (!string.IsNullOrEmpty(Request.Form["Organisation_RoleId"]))
                            {
                                model.Organisation_RoleId = int.Parse(Request.Form["Organisation_RoleId"]);
                            }
                            if (!string.IsNullOrEmpty(Request.Form["External_GroupId"]))
                            {
                                model.Is_External_User = true;
                                model.External_GroupId = int.Parse(Request.Form["External_GroupId"]);
                            }
                        }

                        _qUserService.CreateUser(model);
                        if (model.Email != string.Empty)
                        {
                            string mailbody = ConfigurationManager.AppSettings["MailNewAccountBody"];
                            mailbody = mailbody.Replace("[FullName]", model.FirstName + " " + model.LastName);
                            mailbody = mailbody.Replace("[UserName]", model.UserName);
                            mailbody = mailbody.Replace("[Password]", password);
                            Base.SendMail(model.Email, ConfigurationManager.AppSettings["MailNewAccountSubject"], mailbody);
                        }
                        return RedirectToAction("Index", "User");
                    }
                    else
                    {                        
                        ShowError(Resource.msgUserDuplicate);  
                    }                    
                }
            }
            else
            {
                ShowError(Resource.msgInvalidInput);                
            }
            FormViewBag(model);
            return View(model);
        }      

        protected void FormViewBag(UserModel model)
        {
            ViewBag.External_Groups = new SelectList(_qExternal_GroupService.GetAll().OrderBy(l => l.Name).AsEnumerable(), "External_GroupId", "Name", model != null ? model.External_GroupId : 0);
            ViewBag.Teams = new SelectList(_qTeamServiceService.GetAll().OrderBy(l => l.Name).AsEnumerable(), "TeamId", "Name", model != null ? model.TeamId : 0);
            ViewBag.System_Roles = new SelectList(_qSystem_RolesService.GetAll().OrderBy(l => l.Name).AsEnumerable(), "System_RoleId", "Name", model != null ? model.System_RoleId : 0);
            ViewBag.cboOrganisation_Roles = new SelectList(_qOrganisation_RolesService.GetAll().OrderBy(l => l.Name).AsEnumerable(), "Organisation_RoleId", "Name", model != null ? model.Organisation_RoleId : 0);
            ViewBag.cboStatus = new SelectList(Base.StatusList(), "StatusId", "Name", model == null ? short.Parse(BLL.Resources.Control.Status_Active) : model.Status);
            if (model == null)
            {
                ViewBag.Password = string.Empty;
            }
            else
            {
                ViewBag.Password = model.Password;
            }
        }        
    }
}
