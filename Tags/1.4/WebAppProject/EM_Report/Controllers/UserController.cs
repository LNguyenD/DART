using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using EM_Report.Common.Utilities;
using EM_Report.Domain;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Repositories;

namespace EM_Report.Controllers
{
    public class UserController : BaseController
    {
        /// <summary>
        /// Default Constructor for UserController.
        /// </summary>
        public UserController()
            : base()
        {
        }

        [HttpGet]
        public ActionResult Index()
        {
            var systemId = Request.QueryString["systemid"] != null ? int.Parse(Request.QueryString["systemid"]) : Base.LoginSession.intSystemId;

            var lstUserType = Base.UserTypeOptions();
            ViewBag.UserType = new SelectList(lstUserType);
            var hddSort = Base.Page_Sort("Create_Date|desc");
            var pageSize = Base.Page_Size();
            var pagedList = UpdateViewBag<User>(string.Empty, hddSort, 1, pageSize, UserRepository.GetList(string.Empty, hddSort, 1, pageSize, systemId, lstUserType.ElementAt(0)));

            return View(pagedList);
        }

        [HttpPost]
        public ActionResult Index(string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            ViewBag.UserType = new SelectList(Base.UserTypeOptions(), Request.Form["cboUserType"]);

            UserRepository.UpdateStatus(StatusRepository.ReplaceNameById(hddAction));
            var pagesize = int.Parse(Request.Form["cboDisplayEntry"]);
            hddSort = hddSort ?? Base.Page_Sort("UserName|desc");

            var pagedList = UpdateViewBag<User>(search_input, hddSort, (int)(hddPaging), pagesize, UserRepository.GetList(search_input, hddSort, (int)(hddPaging), pagesize, int.Parse(Request["cboSystem"]), Request.Form["cboUserType"]));

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
                var model = UserRepository.Get(id ?? 0);
                foreach (var s in UserRepository.GetSystemList())
                {
                    if (!model.Organisation_RoleIdList.IsNullOrEmpty())
                    {
                        ViewData["cboOrganisation_Roles_" + s.Name] = model.Organisation_RoleIdList[s.Name];
                    }
                    if (!model.TeamIdList.IsNullOrEmpty())
                    {
                        ViewData["cboTeams_" + s.Name] = model.TeamIdList[s.Name];
                    }
                }
                FormViewBag(model);
                return View(model);
            }
        }

        [HttpPost]
        public ActionResult Details(User model)
        {
            var url = Request.UrlReferrer.ToString().ToLower();
            var currentSystemId = int.Parse(url.Substring(url.LastIndexOf("=") + 1));

            if (ModelState.IsValid)
            {
                if (UserRepository.IsValidUser(model))
                {
                    if (model.UserId > 0)
                    {
                        if (Request["Is_External_User"] == "True")
                        {
                            if (model.External_GroupId != null)
                            {
                                UserRepository.Update(model);
                                ShowSuccess(Resource.msgSaveSuccess);
                            }
                            else
                            {
                                ShowError(Resource.msgExternalGroup_Require);
                                FormViewBag(model);
                                return View(model);
                            }
                        }
                        else if (Request["Is_System_User"] != "True" && Request["Is_External_User"] != "True")
                        {
                            Dictionary<string, int> lstRole_Id = new Dictionary<string, int>();
                            Dictionary<string, int> lstTeam_Id = new Dictionary<string, int>();
                            var Is_Selected_One_Organisation = false;
                            foreach (var s in UserRepository.GetSystemList())
                            {
                                if (Request.Form["cboOrganisation_Roles_" + s.Name] != "0") Is_Selected_One_Organisation = true;
                            }
                            if (Is_Selected_One_Organisation)
                            {
                                foreach (var s in UserRepository.GetSystemList())
                                {
                                    lstRole_Id.Add(s.Name, (int.Parse(Request.Form["cboOrganisation_Roles_" + s.Name])));
                                    lstTeam_Id.Add(s.Name, (int.Parse(Request.Form["cboTeams_" + s.Name])));
                                }
                            }
                            else
                            {
                                ShowError(Resource.msgOrganisationRole_Require);
                                FormViewBag(model);
                                return View(model);
                            }
                            model.Organisation_RoleIdList = lstRole_Id;
                            model.TeamIdList = lstTeam_Id;
                            UserRepository.Update(model);
                            foreach (var s in UserRepository.GetSystemList())
                            {
                                if (!model.Organisation_RoleIdList.IsNullOrEmpty())
                                {
                                    ViewData["cboOrganisation_Roles_" + s.Name] = model.Organisation_RoleIdList[s.Name];
                                }
                                if (!model.TeamIdList.IsNullOrEmpty())
                                {
                                    ViewData["cboTeams_" + s.Name] = model.TeamIdList[s.Name];
                                }
                            }
                            ShowSuccess(Resource.msgSaveSuccess);
                        }
                        else
                        {
                            UserRepository.Update(model);
                            ShowSuccess(Resource.msgSaveSuccess);
                        }
                    }
                    //Add new user
                    else
                    {
                        var Is_Selected_One_Organisation = false;
                        var lstSystem = UserRepository.GetSystemList();
                        foreach (var s in lstSystem)
                        {
                            if (Request.Form["cboTeams_" + s.Name] != "0")
                            {
                                ViewData["cboTeams_" + s.Name] = int.Parse(Request.Form["cboTeams_" + s.Name]);
                            }
                            if (Request.Form["cboOrganisation_Roles_" + s.Name] != "0")
                            {
                                ViewData["cboOrganisation_Roles_" + s.Name] = int.Parse(Request.Form["cboOrganisation_Roles_" + s.Name]);
                                Is_Selected_One_Organisation = true;
                            }
                        }
                        if (Request["Is_System_User"] != "True" && Request["Is_External_User"] != "True")
                        {
                            if (Is_Selected_One_Organisation)
                            {
                                Dictionary<string, int> lstRole_Id = new Dictionary<string, int>();
                                Dictionary<string, int> lstTeam_Id = new Dictionary<string, int>();
                                foreach (var s in lstSystem)
                                {
                                    lstTeam_Id.Add(s.Name, (int.Parse(Request.Form["cboTeams_" + s.Name])));
                                    lstRole_Id.Add(s.Name, (int.Parse(Request.Form["cboOrganisation_Roles_" + s.Name])));
                                }
                                model.Organisation_RoleIdList = lstRole_Id;
                                model.TeamIdList = lstTeam_Id;
                                UserRepository.Insert(model);
                            }
                            else
                            {
                                ShowError(Resource.msgOrganisationRole_Require);
                                FormViewBag(model);
                                return View(model);
                            }
                        }
                        else if (Request["Is_External_User"] == "True")
                        {
                            if (model.External_GroupId == null)
                            {
                                ShowError(Resource.msgExternalGroup_Require);
                                FormViewBag(model);
                                return View(model);
                            }
                            else { UserRepository.Insert(model); }
                        }
                        else
                        {
                            UserRepository.Insert(model);
                        }
                        return RedirectToAction("Index", "User", new { systemid = currentSystemId });
                    }
                }
                else
                {
                    ShowError(Resource.msgUserDuplicate);
                    FormViewBag(model);
                    return View(model);
                }
            }
            else
            {
                ShowError(Resource.msgInvalidInput);
            }

            FormViewBag(model);
            return View(model);
        }

        #region Importing

        [HttpGet]
        public ActionResult Import(int? id)
        {
            return View();
        }

        [HttpPost]
        public ActionResult Import(User_Import model)
        {
            if (ModelState.IsValid)
            {
                if (Request["action"] == "process")
                {
                    // process importing data

                    var createdDate = DateTime.Now;

                    var iDash = model.File.FileName.LastIndexOf('\\') + 1;

                    var fileName = model.File.FileName.Substring(iDash, model.File.FileName.LastIndexOf('.') - iDash);
                    var fileExt = model.File.FileName.Substring(model.File.FileName.LastIndexOf('.'));

                    // create temp folder if not exist
                    if (!System.IO.Directory.Exists(AppDomain.CurrentDomain.BaseDirectory + "ImportData\\User"))
                    {
                        System.IO.Directory.CreateDirectory(AppDomain.CurrentDomain.BaseDirectory + "ImportData\\User");
                    }

                    string path = AppDomain.CurrentDomain.BaseDirectory + "ImportData\\User\\" + fileName + "_"
                        + createdDate.ToString("yyyyMMddHHmmss") + fileExt;
                    model.File.SaveAs(path);

                    // save temp path
                    ViewBag.PathFileTmp = path;

                    model.UserList = ImportHelper.Get_User_List(path);

                    return View(model);
                }
                else
                {
                    // submit importing data

                    var pathFileTmp = Request["pathFileTmp"];

                    if (string.IsNullOrEmpty(pathFileTmp))
                    {
                        ShowError(Resource.msgProcessImportingData_Require);

                        return View(model);
                    }

                    model.UserList = ImportHelper.Get_User_List(pathFileTmp);

                    var lstSystem = UserRepository.GetSystemList();
                    var organisationList = OrganisationRoleRepository.GetList("", "");
                    var organisationLevelList = OrganisationLevelRepository.GetList();

                    // insert to db
                    foreach (var user in model.UserList)
                    {
                        if (!user.IsError)
                        {
                            Dictionary<string, int> lstRole_Id = new Dictionary<string, int>();
                            Dictionary<string, int> lstTeam_Id = new Dictionary<string, int>();

                            // get the organisation role "Pilot Users" id
                            var pilotOrganisationRoleId = (from p in organisationList
                                                           join q in organisationLevelList on p.LevelId equals q.LevelId into temp1
                                                           from q in temp1.DefaultIfEmpty()
                                                           where q.SystemId == user.SystemId && p.Name == "Pilot Users"
                                                           select p.Organisation_RoleId).FirstOrDefault();

                            foreach (var s in lstSystem)
                            {
                                lstRole_Id.Add(s.Name, (s.SystemId == user.SystemId ? pilotOrganisationRoleId : 0));
                                lstTeam_Id.Add(s.Name, 0);
                            }

                            user.Organisation_RoleIdList = lstRole_Id;
                            user.TeamIdList = lstTeam_Id;

                            var foundUserItem = UserRepository.Get(user.UserName.Trim().ToLower(), user.Email.Trim().ToLower());
                            if (foundUserItem == null)
                            {
                                // update model
                                user.Is_System_User = false;
                                user.Status = 1;

                                UserRepository.Insert(user);
                            }
                            else
                            {
                                // fields don't change
                                user.UserId = foundUserItem.UserId;
                                user.Address = foundUserItem.Address;
                                user.Status = foundUserItem.Status;
                                user.Phone = foundUserItem.Phone;
                                user.Online_Locked_Until_Datetime = foundUserItem.Online_Locked_Until_Datetime;
                                user.Online_No_Of_Login_Attempts = foundUserItem.Online_No_Of_Login_Attempts;
                                user.Last_Online_Login_Date = foundUserItem.Last_Online_Login_Date;
                                user.Create_Date = foundUserItem.Create_Date;
                                user.Owner = foundUserItem.Owner;
                                user.Is_System_User = foundUserItem.Is_System_User;

                                UserRepository.Update(user);
                            }
                        }
                    }

                    // delete temp file
                    System.IO.File.Delete(pathFileTmp);

                    ShowSuccess(Resource.msgImportSuccess);

                    return View();
                }
            }
            else
            {
                ShowError(Resource.msgInvalidInput);

                return View(model);
            }
        }       

        #endregion Importing

        protected void FormViewBag(User model)
        {
            ViewBag.External_Groups = External_GroupRepository.GetList("", "");
            ViewBag.Teams = TeamRepository.GetList("", "");
            ViewBag.System_Roles = new SelectList(SystemRoleRepository.GetList("", "").OrderBy(l => l.Name), "System_RoleId", "Name", model != null ? model.System_RoleId : 0);
            ViewBag.cboStatus = new SelectList(StatusRepository.StatusList(), "StatusId", "Name", model == null ? 0 : model.Status);
            ViewBag.Password = model == null ? string.Empty : model.Password;
            ViewBag.Organisations = OrganisationRoleRepository.GetList("", "");
            ViewBag.Levels = OrganisationLevelRepository.GetList();
            ViewBag.Systems = UserRepository.GetSystemList();
            var SystemList = UserRepository.GetSystemList();
            ViewBag.DefaultSystemId = new SelectList(UserRepository.GetSystemList(), "SystemId", "Name", Request.QueryString["systemid"]);            
        }
    }
}