﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using System.Web.Script.Serialization;
using EM_Report.Common.Utilities;
using EM_Report.Domain;
using EM_Report.Helpers;
using EM_Report.Repositories;
using EM_Report.Domain.Resources;
using EM_Report.ActionServiceReference;
using System.Web;


namespace EM_Report.Controllers
{
    public class DashboardController : BaseController
    {

        public ActionResult Index()
        {
            var hddSort = Base.Page_Sort("DashboardId|asc");
            var pageSize = Base.Page_Size();
            var systemId = Request.QueryString["systemid"] != null ? int.Parse(Request.QueryString["systemid"]) : Base.LoginSession.intSystemId;
            var list = DashboardRepository.GetList(string.Empty, "", 1, pageSize, systemId);
            var pagedList = UpdateViewBag(string.Empty, hddSort, 1, pageSize, list);
            return View(pagedList);
        }

        [HttpPost]
        public ActionResult Index(FormCollection postForm, string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            var pagesize = int.Parse(Request.Form["cboDisplayEntry"]);
            hddSort = hddSort ?? Base.Page_Sort("DashboardId|asc");
            DashboardRepository.UpdateStatus(StatusRepository.ReplaceNameById(hddAction));
            var list = DashboardRepository.GetList(search_input, hddSort, (int)(hddPaging), pagesize, int.Parse(Request["cboSystem"]));
            var pagedList = UpdateViewBag<Dashboard>(search_input, hddSort, (int)(hddPaging), pagesize, list);
            return View(pagedList);
        }

        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Details(int? id, string hddSort)
        {

            if (!id.HasValue)
            {
                FormViewBag(null);
                return View();
            }
            else
            {
                var sModel = DashboardRepository.GetById(id ?? 0);
                var model = sModel;
                FormViewBag(model);
                return View(model);
            }
        }

        protected void FormViewBag(Dashboard model)
        {           
            ViewBag.cboStatus = new SelectList(StatusRepository.StatusList(), "StatusId", "Name", model == null ? 0 : model.Status);
        }

        [HttpPost]
        public ActionResult Details(Dashboard model)
        {
            var DashOrgRoleLevel = new Dashboard_OrganisationRole_Levels();
            var IsNew = false;
            if (ModelState.IsValid)
            {

                var sModel = model;

                var urlStr = new StringBuilder();
                var lstDashboardLevel = DashboardLevelRepository.GetList();
                foreach (var dashboardLevel in lstDashboardLevel)
                {
                    if (!string.IsNullOrEmpty(Request.Form["txtUrl_" + dashboardLevel.Sort.ToString()]))
                    {
                        urlStr.Append(Request.Form["txtUrl_" + dashboardLevel.Sort.ToString()] + ",");
                    }
                }

                sModel.Url = urlStr.Length > 0 ? urlStr.ToString().Substring(0, urlStr.ToString().Length - 1) : "";

                if (model.DashboardId > 0)
                {
                    DashboardRepository.Update(sModel);
                    DashOrgRoleLevel.DashboardId = model.DashboardId;
                    var OrgRoleLevelbyDashIdList = Dashboard_OrganisationRole_LevelsRepository.GetList(model.DashboardId);
                    if (OrgRoleLevelbyDashIdList != null)
                    {
                        foreach (var dashboardOrganisationRoleLevelse in OrgRoleLevelbyDashIdList)
                        {
                            Dashboard_OrganisationRole_LevelsRepository.Delete(dashboardOrganisationRoleLevelse.DashboardOrganisationlevelId);
                        }
                    }
                    ShowSuccess(Resource.msgSaveSuccess);
                }
                else
                {
                    IsNew = true;
                    DashboardRepository.Insert(sModel);
                    var dashboard = DashboardRepository.GetList("", "").LastOrDefault();
                    DashOrgRoleLevel.DashboardId = dashboard.DashboardId;
                }

                if (!model.Dashboard_OrganisationRole_Levels.IsNullOrEmpty())
                {
                    var orgitemlist = model.Dashboard_OrganisationRole_Levels.Split('>');
                    foreach (var orgitem in orgitemlist)
                    {
                        var orglevelid = int.Parse(orgitem.Substring(0, orgitem.IndexOf("=")));
                        var dashboardlevelidlist = orgitem.Substring(orgitem.IndexOf("=") + 1).Split('|');
                        foreach (var dashitem in dashboardlevelidlist)
                        {
                            DashOrgRoleLevel.LevelId = orglevelid;
                            DashOrgRoleLevel.DashboardLevelId = int.Parse(dashitem);
                            Dashboard_OrganisationRole_LevelsRepository.Insert(DashOrgRoleLevel);
                        }
                    }
                }
                FormViewBag(model);
                if (IsNew == true)
                {
                    return RedirectToAction("index", "Dashboard", new { systemid = model.SystemId });
                }
            }
            else
            {
                ShowError(Resource.msgInvalidInput);
            }
            return View(model);
        }        

        public ActionResult Level0()
        {
            try
            {                
                string reportpath = !string.IsNullOrEmpty(Request["reportpath"]) ? Request["reportpath"] : Base.LoginSession.objConfig.ReportPathPrefix + "Level0";
                var havePermission = Dashboard_OrganisationRole_LevelsRepository.HaveDashboardPermission(Base.LoginSession.isSystemUser, reportpath.ToLower().Replace(Base.LoginSession.objConfig.ReportPathPrefix.ToLower(), ""), Base.LoginSession.intLevelId ?? 0, int.Parse(Control.Dashboard_Levels0_Value));

                if (!havePermission)
                {
                    return Redirect(Base.AbsoluteUrl("~/dashboard/level1?reportpath="
                        + "/emreporting/reports/" + Base.LoginSession.defaultSystemName
                        + "_level1"));
                }

                string systems = !string.IsNullOrEmpty(Request["systems"]) ? Request["systems"] : string.Empty;
                ViewBag.Systems = systems;

                LevelViewBag(reportpath);
            }
            catch (Exception ex)
            {
                if (ex.Message.ToLower().Contains("logonuser") && ex.Message.ToLower().Contains("authorization ticket"))
                {
                    Login.DoLogout();
                    return RedirectToAction("/login");
                }

                ViewBag.ErrorAccess = ex.Message;
            }

            return View();
        }

        public ActionResult Level1()
        {
            try
            {                
                string reportpath = !string.IsNullOrEmpty(Request["reportpath"]) ? Request["reportpath"] : Base.LoginSession.objConfig.ReportPathPrefix + "TMF_Level1";
                var havePermission = Dashboard_OrganisationRole_LevelsRepository.HaveDashboardPermission(Base.LoginSession.isSystemUser, reportpath.ToLower().Replace(Base.LoginSession.objConfig.ReportPathPrefix.ToLower(), ""), Base.LoginSession.intLevelId ?? 0, int.Parse(Control.Dashboard_Levels1_Value));

                if (!havePermission)
                    return RedirectToAction("index", "welcome");

                LevelViewBag(reportpath);
            }
            catch (Exception ex)
            {
                if (ex.Message.ToLower().Contains("logonuser") && ex.Message.ToLower().Contains("authorization ticket"))
                {
                    Login.DoLogout();
                    return RedirectToAction("/login");
                }

                ViewBag.ErrorAccess = ex.Message;
            }

            return View();
        }

        public ActionResult Level2(string reportpath)
        {
            try
            {
                var havePermission = Dashboard_OrganisationRole_LevelsRepository.HaveDashboardPermission(Base.LoginSession.isSystemUser, Request["reportpath"].ToLower().Replace(Base.LoginSession.objConfig.ReportPathPrefix.ToLower(), ""), Base.LoginSession.intLevelId ?? 0, int.Parse(Control.Dashboard_Levels2_Value));
                if (!havePermission)
                    return RedirectToAction("index", "welcome");

                LevelViewBag(reportpath);
            }
            catch (Exception ex)
            {
                if (ex.Message.ToLower().Contains("logonuser") && ex.Message.ToLower().Contains("authorization ticket"))
                {
                    Login.DoLogout();
                    return RedirectToAction("/login");
                }

                ViewBag.ErrorAccess = ex.Message;
            }

            return View();
        }

        public ActionResult Level3(string reportpath)
        {
            try
            {
                var havePermission = Dashboard_OrganisationRole_LevelsRepository.HaveDashboardPermission(Base.LoginSession.isSystemUser, Request["reportpath"].ToLower().Replace(Base.LoginSession.objConfig.ReportPathPrefix.ToLower(), ""), Base.LoginSession.intLevelId ?? 0, int.Parse(Control.Dashboard_Levels3_Value));
                if (!havePermission)
                    return RedirectToAction("index", "welcome");

                LevelViewBag(reportpath);
            }
            catch (Exception ex)
            {
                if (ex.Message.ToLower().Contains("logonuser") && ex.Message.ToLower().Contains("authorization ticket"))
                {
                    Login.DoLogout();
                    return RedirectToAction("/login");
                }

                ViewBag.ErrorAccess = ex.Message;
            }

            return View();
        }

        public ActionResult Level4(string reportpath)
        {
            try
            {
                var havePermission = Dashboard_OrganisationRole_LevelsRepository.HaveDashboardPermission(Base.LoginSession.isSystemUser, Request["reportpath"].ToLower().Replace(Base.LoginSession.objConfig.ReportPathPrefix.ToLower(), ""), Base.LoginSession.intLevelId ?? 0, int.Parse(Control.Dashboard_Levels4_Value));
                if (!havePermission)
                    return RedirectToAction("index", "welcome");

                LevelViewBag(reportpath);
            }
            catch (Exception ex)
            {
                if (ex.Message.ToLower().Contains("logonuser") && ex.Message.ToLower().Contains("authorization ticket"))
                {
                    Login.DoLogout();
                    return RedirectToAction("/login");
                }

                ViewBag.ErrorAccess = ex.Message;
            }

            return View();
        }

        public ActionResult Level5(string reportpath)
        {
            try
            {
                var havePermission = Dashboard_OrganisationRole_LevelsRepository.HaveDashboardPermission(Base.LoginSession.isSystemUser, Request["reportpath"].ToLower().Replace(Base.LoginSession.objConfig.ReportPathPrefix.ToLower(), ""), Base.LoginSession.intLevelId ?? 0, int.Parse(Control.Dashboard_Levels5_Value));
                if (!havePermission)
                    return RedirectToAction("index", "welcome");

                LevelViewBag(reportpath); LevelViewBag(reportpath);
            }
            catch (Exception ex)
            {
                if (ex.Message.ToLower().Contains("logonuser") && ex.Message.ToLower().Contains("authorization ticket"))
                {
                    Login.DoLogout();
                    return RedirectToAction("/login");
                }

                ViewBag.ErrorAccess = ex.Message;
            }

            return View();
        }

        public ActionResult RawData(string reportname)
        {
            try
            {
                ViewBag.ReportPath = Base.LoginSession.objConfig.ReportPathPrefix + reportname;
                ViewBag.ReportParams = new SSRS.ItemParameter() { lstRSParameters = new SSRS.ReportParameterService().GetDashboard_VisibleParametersInfo(Base.LoginSession.objConfig.ReportPathPrefix + reportname, null) };
            }
            catch (Exception ex)
            {
                if (ex.Message.ToLower().Contains("logonuser") && ex.Message.ToLower().Contains("authorization ticket"))
                {
                    Login.DoLogout();
                    return RedirectToAction("/login");
                }

                ViewBag.ErrorAccess = ex.Message;
            }

            return View();
        }

        public ActionResult Cache()
        {
            try
            {
                if (Base.LoginSession == null || !Base.LoginSession.isSystemUser)
                    return RedirectToAction("/welcome");
                else
                    SSRS.Cache.Cache_Refresh_Snapshot(Request["doCache"] != null && Request["doCache"].ToLower() == "true" ? true : false
                                                        , Request["doRefresh"] != null && Request["doRefresh"].ToLower() == "true" ? true : false
                                                        , Request["doSnapshot"] != null && Request["doSnapshot"].ToLower() == "true" ? true : false);
            }
            catch (Exception ex)
            {
                return RedirectToAction("/login");
            }
            return View();
        }

        protected void LevelViewBag(string reportpath)
        {
            var systemName = Base.GetSystemNameByUrl(reportpath);
            var systemid = UserRepository.GetSystemIdByName(!string.IsNullOrEmpty(systemName) ? systemName : "tmf");

            if (!(reportpath.ToLower().Contains("_rtw") && reportpath.ToLower().Contains("level5"))
                && !(reportpath.ToLower().Contains("_awc") && reportpath.ToLower().Contains("level4")))
            {
                ViewBag.List_TrafficLight = DashboardRepository.GetList_TrafficLight(systemid);
            }

            ViewBag.ReportPath = reportpath;
            ViewBag.SystemId = systemid;
            ViewBag.SystemName = systemName;

            // check whether user can see level 0 or not
            ViewBag.HasLevel0 = Dashboard_OrganisationRole_LevelsRepository.HaveDashboardPermission(
                Base.LoginSession.isSystemUser, "level0",
                Base.LoginSession.intLevelId ?? 0, int.Parse(Control.Dashboard_Levels0_Value));
        }
    }
}