using EM_Report.Common.Utilities;
using EM_Report.Domain;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Repositories;
using EM_Report.SSRS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using RS = Microsoft.SqlServer.ReportingServices2010;

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
            var DashExtGroup = new DashboardExternal_Groups();
            var IsNew = false;
            var sDashboard_OrganisationRole_Levels = model.Dashboard_OrganisationRole_Levels;
            if (ModelState.IsValid)
            {
                var sModel = model;
                sModel.Dashboard_OrganisationRole_Levels = null;

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
                    // organize levels
                    var OrgRoleLevelbyDashIdList = Dashboard_OrganisationRole_LevelsRepository.GetList(model.DashboardId);
                    if (OrgRoleLevelbyDashIdList != null)
                    {
                        foreach (var dashboardOrganisationRoleLevelse in OrgRoleLevelbyDashIdList)
                        {
                            Dashboard_OrganisationRole_LevelsRepository.Delete(dashboardOrganisationRoleLevelse.DashboardOrganisationlevelId);
                        }
                    }
                    // dashboard external groups
                    DashExtGroup.DashboardId = model.DashboardId;
                    var DashExtGroupsbyDashIdList = DashboardExternal_GroupsRepository.GetList(model.DashboardId);
                    if (DashExtGroupsbyDashIdList != null)
                    {
                        foreach (var dashExtGrp in DashExtGroupsbyDashIdList)
                        {
                            DashboardExternal_GroupsRepository.Delete(dashExtGrp.DashboardExternal_GroupId);
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
                    DashExtGroup.DashboardId = dashboard.DashboardId;
                }

                model.Dashboard_OrganisationRole_Levels = sDashboard_OrganisationRole_Levels;

                // Organize Level
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
                // Dashboard External group
                if (!model.DashboardExternal_Groups.IsNullOrEmpty())
                {
                    var DashItemlist = model.DashboardExternal_Groups.Split('>');
                    foreach (var DashItem in DashItemlist)
                    {
                        if (DashItem != "")
                        {
                            var DashGrpId = int.Parse(DashItem.Substring(0, DashItem.IndexOf("=")));
                            var DashGrpIdlist = DashItem.Substring(DashItem.IndexOf("=") + 1).Split('|');
                            foreach (var dashitem in DashGrpIdlist)
                            {
                                DashExtGroup.External_GroupId = DashGrpId;
                                DashExtGroup.DashboardLevelId = int.Parse(dashitem);
                                DashboardExternal_GroupsRepository.Insert(DashExtGroup);
                            }
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
                string reportpath = !string.IsNullOrEmpty(Request["reportpath"]) ? Request["reportpath"] : Base.GetConfig("ReportPathPrefix") + "Level0";

                if (Base.LoginSession.isExternal)
                {
                    var havePermissionEx = DashboardExternal_GroupsRepository.HaveDashboardPermissionEx(Base.LoginSession.isSystemUser, "dashboardUrl=" + reportpath.ToLower().Replace(Base.GetConfig("ReportPathPrefix").ToLower(), ""), Base.LoginSession.intExternal_GroupId ?? 0, short.Parse(Control.Dashboard_Levels0_Sort_Value));
                    if (!havePermissionEx)
                    {
                        return Redirect(Base.AbsoluteUrl("~/dashboard/level1?reportpath="
                            + "/emreporting/reports/" + Base.LoginSession.defaultSystemName
                            + "_level1"));
                    }
                }
                else
                {
                    var havePermission = Dashboard_OrganisationRole_LevelsRepository.HaveDashboardPermission(Base.LoginSession.isSystemUser, reportpath.ToLower().Replace(Base.GetConfig("ReportPathPrefix").ToLower(), ""), Base.LoginSession.intLevelId ?? 0, short.Parse(Control.Dashboard_Levels0_Sort_Value));
                    if (!havePermission)
                    {
                        return Redirect(Base.AbsoluteUrl("~/dashboard/level1?reportpath="
                            + "/emreporting/reports/" + Base.LoginSession.defaultSystemName
                            + "_level1"));
                    }
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
                string reportpath = !string.IsNullOrEmpty(Request["reportpath"]) ? Request["reportpath"] : Base.GetConfig("ReportPathPrefix") + "TMF_Level1";

                if (Base.LoginSession.isExternal)
                {
                    var havePermission = DashboardExternal_GroupsRepository.HaveDashboardPermissionEx(Base.LoginSession.isSystemUser, "dashboardUrl=" + reportpath.ToLower().Replace(Base.GetConfig("ReportPathPrefix").ToLower(), ""), Base.LoginSession.intExternal_GroupId ?? 0, short.Parse(Control.Dashboard_Levels1_Sort_Value));

                    if (!havePermission)
                        return RedirectToAction("index", "welcome");
                }
                else
                {
                    var havePermission = Dashboard_OrganisationRole_LevelsRepository.HaveDashboardPermission(Base.LoginSession.isSystemUser, reportpath.ToLower().Replace(Base.GetConfig("ReportPathPrefix").ToLower(), ""), Base.LoginSession.intLevelId ?? 0, short.Parse(Control.Dashboard_Levels1_Sort_Value));

                    if (!havePermission)
                        return RedirectToAction("index", "welcome");
                }
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
                if (Base.LoginSession.isExternal)
                {                    
                    var systemName = "";
                    if (Request["reportpath"].ToLower().Contains("wow"))
                    {
                        systemName = "wow";
                        var havePermission = DashboardExternal_GroupsRepository.HaveDashboardPermissionEx(Base.LoginSession.isSystemUser,
                        "system=" + systemName
                        + "&type=" + Request["type"]
                        + "&level=2&dashboardUrl=" + Request["reportpath"].ToLower().Replace(Base.GetConfig("ReportPathPrefix").ToLower(), ""),
                        Base.LoginSession.intExternal_GroupId ?? 0, short.Parse(Control.Dashboard_Levels2_Sort_Value));
                        if (!havePermission)
                            return RedirectToAction("index", "welcome");
                    }
                    else
                    {
                        var havePermission = DashboardExternal_GroupsRepository.HaveDashboardPermissionEx(Base.LoginSession.isSystemUser, "dashboardUrl=" + Request["reportpath"].ToLower().Replace(Base.GetConfig("ReportPathPrefix").ToLower(), "").Replace("_" + Request["type"].ToLower(), ""), Base.LoginSession.intExternal_GroupId ?? 0, short.Parse(Control.Dashboard_Levels2_Sort_Value));
                        if (!havePermission)
                            return RedirectToAction("index", "welcome");
                    }
                    
                    
                }
                else
                {
                    var havePermission = Dashboard_OrganisationRole_LevelsRepository.HaveDashboardPermission(Base.LoginSession.isSystemUser, Request["reportpath"].ToLower().Replace(Base.GetConfig("ReportPathPrefix").ToLower(), "").Replace("_" + Request["type"].ToLower(), ""), Base.LoginSession.intLevelId ?? 0, short.Parse(Control.Dashboard_Levels2_Sort_Value));
                    if (!havePermission)
                        return RedirectToAction("index", "welcome");
                }
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
                if (Base.LoginSession.isExternal)
                {
                    var havePermission = DashboardExternal_GroupsRepository.HaveDashboardPermissionEx(Base.LoginSession.isSystemUser,
                        "system=" + Request["system"]
                        + "&type=" + Request["type"]
                        + "&level=3&dashboardUrl=" + Request["reportpath"].ToLower().Replace(Base.GetConfig("ReportPathPrefix").ToLower(), ""),
                        Base.LoginSession.intExternal_GroupId ?? 0, short.Parse(Control.Dashboard_Levels3_Sort_Value));
                    if (!havePermission)
                        return RedirectToAction("index", "welcome");
                }
                else
                {
                    var havePermission = Dashboard_OrganisationRole_LevelsRepository.HaveDashboardPermission(Base.LoginSession.isSystemUser, Request["reportpath"].ToLower().Replace(Base.GetConfig("ReportPathPrefix").ToLower(), ""), Base.LoginSession.intLevelId ?? 0, short.Parse(Control.Dashboard_Levels3_Sort_Value));
                    if (!havePermission)
                        return RedirectToAction("index", "welcome");
                }
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
                if (Base.LoginSession.isExternal)
                {
                    var havePermission = DashboardExternal_GroupsRepository.HaveDashboardPermissionEx(Base.LoginSession.isSystemUser,
                        "system=" + Request["system"]
                        + "&type=" + Request["type"]
                        + "&level=4&dashboardUrl=" + Request["reportpath"].ToLower().Replace(Base.GetConfig("ReportPathPrefix").ToLower(), ""),
                        Base.LoginSession.intExternal_GroupId ?? 0, short.Parse(Control.Dashboard_Levels4_Sort_Value));
                    if (!havePermission)
                        return RedirectToAction("index", "welcome");
                }
                else
                {
                    var havePermission = Dashboard_OrganisationRole_LevelsRepository.HaveDashboardPermission(Base.LoginSession.isSystemUser, Request["reportpath"].ToLower().Replace(Base.GetConfig("ReportPathPrefix").ToLower(), ""), Base.LoginSession.intLevelId ?? 0, short.Parse(Control.Dashboard_Levels4_Sort_Value));
                    if (!havePermission)
                        return RedirectToAction("index", "welcome");
                }
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
                if (Base.LoginSession.isExternal)
                {
                    var havePermission = DashboardExternal_GroupsRepository.HaveDashboardPermissionEx(Base.LoginSession.isSystemUser, "dashboardUrl=" + Request["reportpath"].ToLower().Replace(Base.GetConfig("ReportPathPrefix").ToLower(), ""), Base.LoginSession.intExternal_GroupId ?? 0, short.Parse(Control.Dashboard_Levels5_Sort_Value));
                    if (!havePermission)
                        return RedirectToAction("index", "welcome");
                }
                else
                {
                    var havePermission = Dashboard_OrganisationRole_LevelsRepository.HaveDashboardPermission(Base.LoginSession.isSystemUser, Request["reportpath"].ToLower().Replace(Base.GetConfig("ReportPathPrefix").ToLower(), ""), Base.LoginSession.intLevelId ?? 0, short.Parse(Control.Dashboard_Levels5_Sort_Value));
                    if (!havePermission)
                        return RedirectToAction("index", "welcome");
                }
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

        public ActionResult Level6(string reportpath)
        {
            try
            {
                if (Base.LoginSession.isExternal)
                {
                    var havePermission = DashboardExternal_GroupsRepository.HaveDashboardPermissionEx(Base.LoginSession.isSystemUser, "dashboardUrl=" + Request["reportpath"].ToLower().Replace(Base.GetConfig("ReportPathPrefix").ToLower(), ""), Base.LoginSession.intExternal_GroupId ?? 0, short.Parse(Control.Dashboard_Levels6_Sort_Value));
                    if (!havePermission)
                        return RedirectToAction("index", "welcome");
                }
                else
                {
                    var havePermission = Dashboard_OrganisationRole_LevelsRepository.HaveDashboardPermission(Base.LoginSession.isSystemUser, Request["reportpath"].ToLower().Replace(Base.GetConfig("ReportPathPrefix").ToLower(), ""), Base.LoginSession.intLevelId ?? 0, short.Parse(Control.Dashboard_Levels6_Sort_Value));
                    if (!havePermission)
                        return RedirectToAction("index", "welcome");
                }
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

        public ActionResult Level7(string reportpath)
        {
            try
            {
                if (Base.LoginSession.isExternal)
                {
                    var havePermission = DashboardExternal_GroupsRepository.HaveDashboardPermissionEx(Base.LoginSession.isSystemUser, "dashboardUrl=" + Request["reportpath"].ToLower().Replace(Base.GetConfig("ReportPathPrefix").ToLower(), ""), Base.LoginSession.intExternal_GroupId ?? 0, short.Parse(Control.Dashboard_Levels7_Sort_Value));
                    if (!havePermission)
                        return RedirectToAction("index", "welcome");
                }
                else
                {
                    var havePermission = Dashboard_OrganisationRole_LevelsRepository.HaveDashboardPermission(Base.LoginSession.isSystemUser, Request["reportpath"].ToLower().Replace(Base.GetConfig("ReportPathPrefix").ToLower(), ""), Base.LoginSession.intLevelId ?? 0, short.Parse(Control.Dashboard_Levels7_Sort_Value));
                    if (!havePermission)
                        return RedirectToAction("index", "welcome");
                }
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
                ViewBag.ReportPath = Base.GetConfig("ReportPathPrefix") + reportname;
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

        protected void LevelViewBag(string reportpath)
        {
            //var systemName = Base.GetSystemNameByUrl(reportpath);
            var systemName = Base.GetSystemNameByUrl(Request.RawUrl);
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
                Base.LoginSession.intLevelId ?? 0, short.Parse(Control.Dashboard_Levels0_Sort_Value));
        }

        #region CPR Advance Search

        public ActionResult GetReportParameters(PortfolioReportParameters paramData)
        {
            ViewBag.ReportParams = PopulateParametersData(paramData);

            return PartialView("CPRAdvanceSearch");
        }

        public ActionResult UpdateReportParameters(string reportParameterData)
        {
            var parameterDictionary = new Dictionary<string, string>();
            parameterDictionary = ReportParametersHelper.ParseReportParameterDataToDictionary(reportParameterData);

            var parameters = new List<RS.ItemParameter>();
            var systemName = parameterDictionary["System"];

            if (parameterDictionary.ContainsKey("End_Date") || parameterDictionary.ContainsKey("Start_Date"))
            {
                ReportParametersHelper.AddStartDateEndDateParameters(parameters, parameterDictionary["Start_Date"], parameterDictionary["End_Date"], systemName);
            }
            else
            {
                ReportParametersHelper.AddStartDateEndDateParameters(parameters, null, null, systemName);
            }

            var claimLiabilityIndicators = ReportParametersHelper.GetClaimLiabilityIndicators(systemName);
            var claimLiabilityIndicatorParameter = ReportParametersHelper.CreateClaimLiabilityIndicatorParameter(claimLiabilityIndicators, parameterDictionary["Claim_Liability_Indicator"]);
            parameters.Add(claimLiabilityIndicatorParameter);

            ReportParametersHelper.AddYesNoParameter("Psychological claims", "Psychological_Claims", parameters, parameterDictionary["Psychological_Claims"]);
            ReportParametersHelper.AddYesNoParameter("Inactive claims", "Inactive_Claims", parameters, parameterDictionary["Inactive_Claims"]);
            ReportParametersHelper.AddYesNoParameter("Medically discharged", "Medically_Discharged", parameters, parameterDictionary["Medically_Discharged"]);
            ReportParametersHelper.AddYesNoParameter("Exempt from reform", "Exempt_From_Reform", parameters, parameterDictionary["Exempt_From_Reform"]);
            //AddYesNoParameter("Premium Impacting", "Premium_Impacting", parameters, parameterDictionary["Premium_Impacting"]);
            ReportParametersHelper.AddYesNoParameter("Reactivation", "Reactivation", parameters, parameterDictionary["Reactivation"]);

            var itemParameters = new SSRS.ItemParameter();
            itemParameters.lstRSParameters = parameters;
            return View("ReportParameter", itemParameters);
        }

        private ItemParameter PopulateParametersData(PortfolioReportParameters paramData)
        {
            string reportParameterData;

            var itemParameter = ReportParametersHelper.PopulateGeneralParametersData(paramData, out reportParameterData);
            ViewBag.ReportParameterData = reportParameterData;

            return itemParameter;
        }

        #endregion CPR Advance Search

        public ActionResult OrgLevelAndExtGroupList(int? id, int systemId)
        {
            if (id == null)
            {
                FormViewBag(null);
                ViewBag.selectedSystemId = systemId;
                return PartialView("OrgLevelAndExtGroupList");
            }
            else
            {
                var sModel = DashboardRepository.GetById(id ?? 0);
                var model = sModel;
                FormViewBag(model);
                ViewBag.selectedSystemId = systemId;
                return PartialView("OrgLevelAndExtGroupList", model);
            }
        }
    }
}