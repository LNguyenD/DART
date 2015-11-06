using EM_Report.Common.Utilities;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using RS = Microsoft.SqlServer.ReportingServices2010;

namespace EM_Report.Controllers
{
    using EM_Report.Domain;
    using EM_Report.Domain.Enums;
    using EM_Report.SSRS;
    using System.IO;
    using Report = EM_Report.Domain.Report;

    public class ReportController : BaseController
    {
        private const string STR_SAVE = "save";
        private const string STR_DELETE = "delete";
        private const string STR_ASSIGN = "assign";
        private const string STR_UNASSIGN = "unassign";
        private const string STR_CBO_DISPLAY_ENTRY = "cboDisplayEntry";
        private const string STR_ACTION = "action";

        #region Private Methods

        private ActionResult Save(Report model, FormCollection postForm)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    if (model.ReportId <= 0)
                    {
                        // insert
                        var modelReturn = ReportRepository.Insert(model);
                        if (modelReturn != null)
                        {
                            var reportPermission = ReportPermissionRepository.Get(modelReturn.ReportId);

                            // remove existing assignment
                            foreach (var item in reportPermission.ReportOrganisationLevelList)
                                ReportPermissionRepository.RemoveOrganisationRole(reportPermission, item);

                            reportPermission.ReportOrganisationLevelList = new List<Report_Organisation_Levels>();

                            var lstSystem = UserRepository.GetSystemList();
                            foreach (var s in lstSystem)
                            {
                                if (Request.Form["cboLevels_" + s.Name] != "")
                                {
                                    if (!HandleReportPermission(postForm, reportPermission, int.Parse(Request.Form["cboLevels_" + s.Name])))
                                        ShowError(Resource.msgUpdateError);
                                    else
                                        ShowSuccess(Resource.msgSaveSuccess);
                                }

                                UpdateViewBagForReportPermission(ReportPermissionRepository.Get((modelReturn.ReportId)));
                            }
                        }
                        else
                            ShowError(Resource.msgUpdateError);
                    }
                    else
                    {
                        // update
                        var modelReturn = ReportRepository.Update(model);
                        if (modelReturn != null)
                        {
                            var reportPermission = ReportPermissionRepository.Get(modelReturn.ReportId);

                            // remove existing assignment
                            foreach (var item in reportPermission.ReportOrganisationLevelList)
                                ReportPermissionRepository.RemoveOrganisationRole(reportPermission, item);

                            reportPermission.ReportOrganisationLevelList = new List<Report_Organisation_Levels>();

                            var lstSystem = UserRepository.GetSystemList();
                            foreach (var s in lstSystem)
                            {
                                if (Request.Form["cboLevels_" + s.Name] != "")
                                {
                                    if (!HandleReportPermission(postForm, reportPermission, int.Parse(Request.Form["cboLevels_" + s.Name])))
                                        ShowError(Resource.msgUpdateError);
                                    else
                                        ShowSuccess(Resource.msgSaveSuccess);
                                }

                                UpdateViewBagForReportPermission(ReportPermissionRepository.Get((modelReturn.ReportId)));
                            }

                            model.Report_OrganisationRole_Levels = reportPermission.ReportOrganisationLevelList.ToList();
                        }
                        else
                            ShowError(Resource.msgUpdateError);
                    }

                    ShowSuccess(Resource.msgSaveSuccess);

                    if (model.ReportId <= 0)
                    {
                        ViewBag.Levels = OrganisationLevelRepository.GetList("", "Name|Asc");
                        ViewBag.ExternalsGroups = External_GroupRepository.GetList();

                        return RedirectToAction("Index", new { systemid = Request["systemid"] });
                    }

                    PrepareCategoryDropdownlist(model.CategoryId, false);
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
            FormViewBag(model);
            return View(model);
        }

        private ActionResult Delete(Report model)
        {
            try
            {
                ReportRepository.Delete(model.ReportId);

                return RedirectToAction("Index");
            }
            catch
            {
                ShowError(Resource.msgDeleteError);
            }

            FormViewBag(model);
            return View(model);
        }

        private ActionResult SaveCategory(Report_Categories model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    if (model.CategoryId > 0)
                        ReportCategoryRepository.Update(model);
                    else
                        ReportCategoryRepository.Insert(model);

                    ShowSuccess(Resource.msgSaveSuccess);

                    if (model.CategoryId <= 0)
                        return RedirectToAction("Category");
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
            FormCategoryViewBag(model);
            return View(model);
        }

        private ActionResult DeleteCategory(Report_Categories model)
        {
            try
            {
                ReportCategoryRepository.Delete(model.CategoryId);
                return RedirectToAction("Category");
            }
            catch
            {
                ShowError(Resource.msgDeleteError);
            }
            FormCategoryViewBag(model);
            return View(model);
        }

        private bool HandleReportPermission(FormCollection postForm, ReportPermission model, int levelid)
        {
            var isSuccess = AssignLevel(postForm, model, levelid);

            UpdateViewBagForReportPermission(model);

            return isSuccess;
        }

        private bool AssignLevel(FormCollection postForm, ReportPermission model, int levelid)
        {
            var selectedLevelId = levelid;

            // don't add again if existed
            if (model.ReportOrganisationLevelList.Where(e => e.LevelId == selectedLevelId).FirstOrDefault() != null)
                return true;

            try
            {
                //add new one
                var organisationRole = new Report_Organisation_Levels()
                {
                    LevelId = selectedLevelId,
                    Create_Date = DateTime.Now,
                    ReportId = model.ReportId,
                    Owner = Base.LoginSession.intUserId,
                    OwnerName = Base.LoginSession.strUserName
                };

                ReportPermissionRepository.AddOrganisationRole(model, organisationRole);

                var reportOrgLevelList = model.ReportOrganisationLevelList as List<Report_Organisation_Levels>;
                reportOrgLevelList.Add(organisationRole);

                return true;
            }
            catch
            {
                return false;
            }
        }

        private void HandleUnassignCommand(string hddAction, ReportPermission result)
        {
            if (string.IsNullOrEmpty(hddAction))
                return;

            var selectedItems = hddAction.Split('|');

            if (selectedItems.Length <= 0)
                return;

            foreach (var item in selectedItems[1].Split(','))
            {
                try
                {
                    var externalAccess = result.ReportExternalAccessList.Where(e => e.External_GroupId == int.Parse(item) && e.ReportId == result.ReportId).FirstOrDefault();
                    ReportPermissionRepository.RemoveReportExternalAccess(result, externalAccess);
                    result.ReportExternalAccessList.ToList().Remove(externalAccess);
                    ShowSuccess(Resource.msgSaveSuccess);
                }
                catch
                {
                    ShowError(Resource.msgUpdateError);
                }
            }
        }

        private void HandleUnassignCommandLevel(string hddAction, ReportPermission result)
        {
            if (string.IsNullOrEmpty(hddAction))
                return;

            var selectedItems = hddAction.Split('|');

            if (selectedItems.Length <= 0)
                return;

            foreach (var item in selectedItems[1].Split(','))
            {
                try
                {
                    var levelRole = result.ReportOrganisationLevelList.Where(e => e.LevelId == int.Parse(item) && e.ReportId == result.ReportId).FirstOrDefault();
                    ReportPermissionRepository.RemoveOrganisationRole(result, levelRole);
                    result.ReportOrganisationLevelList.ToList().Remove(levelRole);
                    ShowSuccess(Resource.msgSaveSuccess);
                }
                catch
                {
                    ShowError(Resource.msgUpdateError);
                }
            }
        }

        private void HandleAssignCommand(FormCollection postForm, string hddAction, ReportPermission result)
        {
            if (string.IsNullOrEmpty(hddAction))
                return;

            var selectedItems = hddAction.Split('|');
            if (selectedItems.Length <= 0)
                return;

            foreach (var item in selectedItems[1].Split(','))
            {
                var group = this.External_GroupRepository.GetById(int.Parse(item));
                if (!result.ReportExternalAccessList.Where(e => e.ReportId == result.ReportId && e.External_GroupId == group.External_GroupId).IsNullOrEmpty())
                    continue;

                var externalAccess = new Report_External_Access()
                {
                    External_GroupId = group.External_GroupId,
                    Create_Date = DateTime.Now,
                    ReportId = result.ReportId,
                    Owner = Base.LoginSession.intUserId,
                    OwnerName = Base.LoginSession.strUserName
                };
                try
                {
                    ReportPermissionRepository.AddReportExternalAccess(result, externalAccess);
                    result.ReportExternalAccessList.ToList().Add(externalAccess);
                    ShowSuccess(Resource.msgSaveSuccess);
                }
                catch
                {
                    ShowError(Resource.msgUpdateError);
                }
            }
        }

        private void HandleAssignCommandLevel(FormCollection postForm, string hddAction, ReportPermission result)
        {
            if (string.IsNullOrEmpty(hddAction))
                return;

            var selectedItems = hddAction.Split('|');
            if (selectedItems.Length <= 0)
                return;

            foreach (var item in selectedItems[1].Split(','))
            {
                var level = this.OrganisationLevelRepository.Get(int.Parse(item));
                if (!result.ReportOrganisationLevelList.Where(e => e.ReportId == result.ReportId && e.LevelId == level.LevelId).IsNullOrEmpty())
                    continue;

                var organisationRole = new Report_Organisation_Levels()
                {
                    LevelId = level.LevelId,
                    Create_Date = DateTime.Now,
                    ReportId = result.ReportId,
                    Owner = Base.LoginSession.intUserId,
                    OwnerName = Base.LoginSession.strUserName
                };
                try
                {
                    ReportPermissionRepository.AddOrganisationRole(result, organisationRole);
                    result.ReportOrganisationLevelList.ToList().Add(organisationRole);
                    ShowSuccess(Resource.msgSaveSuccess);
                }
                catch
                {
                    ShowError(Resource.msgUpdateError);
                }
            }
        }

        private void PrepareCategoryDropdownlist(int selectedValue, bool haveEmptyDefaultRow)
        {
            var categoryList = ReportCategoryRepository.GetList().ToList();
            if (haveEmptyDefaultRow)
            {
                categoryList.Insert(0, new Report_Categories() { CategoryId = 0, Name = "-- All --" });
            }
            ViewBag.CategoryList = new SelectList(categoryList, "CategoryId", "Name", selectedValue);
        }

        #region Populate data for report parameters

        private ItemParameter PopulateParametersData(PortfolioReportParameters paramData)
        {
            string reportParameterData;

            var itemParameter = ReportParametersHelper.PopulateParametersData(paramData, out reportParameterData);
            ViewBag.ReportParameterData = reportParameterData;

            return itemParameter;
        }

        private ItemParameter PopulateGeneralParametersData(PortfolioReportParameters paramData)
        {
            string reportParameterData;

            var itemParameter = ReportParametersHelper.PopulateGeneralParametersData(paramData, out reportParameterData);
            ViewBag.ReportParameterData = reportParameterData;

            return itemParameter;
        }

        #endregion Populate data for report parameters

        #endregion Private Methods

        #region Public Methods

        public ActionResult GetReportParameter(string reportParameterData)
        {
            var parameterDictionary = new Dictionary<string, string>();
            parameterDictionary = ReportParametersHelper.ParseReportParameterDataToDictionary(reportParameterData);

            var parameters = new List<RS.ItemParameter>();
            var systemName = parameterDictionary["System"];

            if (parameterDictionary.ContainsKey("Type"))
            {
                var type = parameterDictionary["Type"];
                if (!type.Equals("Employer_Size", StringComparison.OrdinalIgnoreCase))
                {
                    // VALUE
                    var values = ReportParametersHelper.GetValuesList(systemName, type);
                    var valueParameter = ReportParametersHelper.CreateValueParameter(type, values, null);
                    parameters.Add(valueParameter);

                    var value = values.ElementAt(0).Value;
                    if (parameterDictionary.ContainsKey("Value"))
                    {
                        value = parameterDictionary["Value"];
                        valueParameter.DefaultValues = new string[] { value };
                    }

                    // SUBVALUE
                    if (type.Equals("Group", StringComparison.OrdinalIgnoreCase))
                    {
                        var subValuesList = ReportParametersHelper.GetSubValuesList(systemName, value, type);
                        var subValueParameter = ReportParametersHelper.CreateSubValueParameter(type, subValuesList, null);
                        parameters.Add(subValueParameter);

                        if (parameterDictionary.ContainsKey("SubValue"))
                        {
                            var subValue = parameterDictionary["SubValue"];
                            subValueParameter.DefaultValues = new string[] { subValue };
                        }
                    }
                }
            }

            if (parameterDictionary.ContainsKey("End_Date") || !string.IsNullOrEmpty(parameterDictionary["End_Date"]))
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

        //Category
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult CategoryDetails(long? id)
        {
            var model = !id.HasValue ? null : ReportCategoryRepository.Get(Convert.ToInt32(id.Value));
            FormCategoryViewBag(model);

            if (!id.HasValue)
                return View();
            else
            {
                return View(model);
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult CategoryDetails(FormCollection postForm, Report_Categories model)
        {
            switch (Request.Form[STR_ACTION].ToLower())
            {
                case STR_SAVE:
                    return SaveCategory(model);

                case STR_DELETE:
                    return DeleteCategory(model);

                default:
                    break;
            }
            return View();
        }

        protected void FormCategoryViewBag(Report_Categories model)
        {
            ViewBag.cboStatus = new SelectList(StatusRepository.StatusList(), "StatusId", "Name", model == null ? 0 : model.Status);
        }

        public ActionResult Category()
        {
            var hddSort = Base.Page_Sort("Create_Date|desc");
            var pageSize = Base.Page_Size();

            var pagedList = UpdateViewBag<Report_Categories>(string.Empty, hddSort, 1, pageSize, ReportCategoryRepository.GetList(string.Empty, hddSort, 1, pageSize));
            return View(pagedList);
        }

        [HttpPost]
        public ActionResult Category(FormCollection postForm, string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            ReportCategoryRepository.UpdateStatus(StatusRepository.ReplaceNameById(hddAction));

            var pageSize = int.Parse(Request.Form[STR_CBO_DISPLAY_ENTRY]);
            hddSort = hddSort ?? string.Empty;

            var pagedList = UpdateViewBag<Report_Categories>(search_input.Trim(), hddSort, (int)(hddPaging), pageSize, ReportCategoryRepository.GetList(search_input, hddSort, (int)(hddPaging), pageSize));
            return View(pagedList);
        }

        //Report
        public ActionResult Index()
        {
            var hddSort = Base.Page_Sort("Create_Date|desc");
            var pageSize = Base.Page_Size();

            PrepareCategoryDropdownlist(string.IsNullOrEmpty(Request["cId"]) ? 0 : int.Parse(Request["cId"]), true);

            var systemId = Request.QueryString["systemid"] != null ? int.Parse(Request.QueryString["systemid"]) : Base.LoginSession.intSystemId;
            var list = string.IsNullOrEmpty(Request["cId"]) ? ReportRepository.GetList(string.Empty, hddSort, 1, pageSize, systemId)
                       : ReportRepository.GetListByCategory(string.Empty, hddSort, 1, pageSize, int.Parse(Request["cId"]), systemId);

            var pagedList = UpdateViewBag(string.Empty, hddSort, 1, pageSize, list);

            return View(pagedList);
        }

        [HttpPost]
        public ActionResult Index(FormCollection postForm, string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            ReportRepository.UpdateStatus(StatusRepository.ReplaceNameById(hddAction));

            //page size
            var pageSize = int.Parse(Request.Form[STR_CBO_DISPLAY_ENTRY]);
            hddSort = hddSort ?? Base.Page_Sort("Create_Date|desc");

            //category
            var category = int.Parse(Request.Form["cboCategory"]);
            ViewBag.Category = category;

            //binding list
            PrepareCategoryDropdownlist(category, true);
            var list = category <= 0 ? ReportRepository.GetList(search_input.Trim(), hddSort, (int)hddPaging, pageSize, int.Parse(Request["cboSystem"]))
                       : ReportRepository.GetListByCategory(search_input.Trim(), hddSort, (int)hddPaging, pageSize, category, int.Parse(Request["cboSystem"]));

            var pagedList = UpdateViewBag(search_input.Trim(), hddSort, hddPaging, pageSize, list);

            return View(pagedList);
        }

        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Details(long? id, string hddSort)
        {
            PrepareCategoryDropdownlist(1, false);
            var model = !id.HasValue ? null : ReportRepository.Get(id != 0 ? int.Parse(id.ToString()) : 0);
            FormViewBag(model);

            if (!id.HasValue)
                return View();
            else
            {
                var reportPermissionModel = ReportPermissionRepository.Get(id);
                UpdateViewBagForReportPermission(reportPermissionModel);
                return View(model);
            }
        }

        private void UpdateViewBagForReportPermission(ReportPermission model)
        {
            if (model.ReportOrganisationLevelList.FirstOrDefault() != null)
            {
                ViewBag.AssignLevel = model.ReportOrganisationLevelList.FirstOrDefault().LevelId;
            }
            else
            {
                ViewBag.AssignLevel = 0;
            }
            if (model.ReportExternalAccessList.FirstOrDefault() != null)
            {
                ViewBag.AssignGroup = model.ReportExternalAccessList.FirstOrDefault().External_GroupId;
            }
        }

        [HttpPost]
        public ActionResult Details(FormCollection postForm, Report model, string hddAction, string hddSort, int? hddPaging = 1)
        {
            if (ModelState.IsValid)
            {
                switch (Request.Form[STR_ACTION].ToLower())
                {
                    case STR_SAVE:
                        return Save(model, postForm);

                    case STR_DELETE:
                        return Delete(model);

                    default:
                        break;
                }
            }
            else
            {
                FormViewBag(model);
                PrepareCategoryDropdownlist(model.CategoryId, false);
                ShowError(Resource.msgInvalidInput);
            }
            return View();
        }

        protected void FormViewBag(Report model)
        {
            ViewBag.cboStatus = new SelectList(StatusRepository.StatusList(), "StatusId", "Name", model == null ? 0 : model.Status);
            ViewBag.Systems = UserRepository.GetSystemList();
            ViewBag.Levels = OrganisationLevelRepository.GetList("", "Name|Asc");
            ViewBag.ExternalsGroups = External_GroupRepository.GetList().ToList();
        }

        [HttpGet]
        public ActionResult ExternalGroup(long? id, string hddSort)
        {
            var hddPaging = 1;
            hddSort = hddSort ?? "External_GroupId|desc";
            var pagesize = ResourcesHelper.Report_PageSize;
            //var externalGroups = ExternalGroupService.GetAllQueryable(hddSort, string.Empty);
            var externalGroups = External_GroupRepository.GetList(string.Empty, hddSort);
            var pagedList = UpdateViewBag<External_Group>(string.Empty, hddSort, hddPaging, pagesize, externalGroups);
            ViewBag.ExternalGroups = pagedList;

            var model = new ReportPermission();
            if (!id.HasValue)
                return View(model);

            try
            {
                model = ReportPermissionRepository.Get(id);
            }
            catch (Exception)
            {
                ShowError(Resource.msgLoadError);
            }
            return View(model);
        }

        [HttpPost]
        public ActionResult ExternalGroup(FormCollection postForm, ReportPermission model, string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            ReportPermission result = ReportPermissionRepository.Get(model.ReportId);
            switch (Request.Form[STR_ACTION].ToLower())
            {
                case STR_ASSIGN:
                    HandleAssignCommand(postForm, hddAction, result);
                    break;

                case STR_UNASSIGN:
                    HandleUnassignCommand(hddAction, result);
                    break;

                default:
                    break;
            }
            var pagesize = int.Parse(Request.Form[STR_CBO_DISPLAY_ENTRY]);
            hddSort = hddSort ?? string.Empty;
            var externalGroups = External_GroupRepository.GetList(search_input, hddSort);
            var pagedList = UpdateViewBag<External_Group>(search_input, hddSort, hddPaging, pagesize, externalGroups);
            ViewBag.ExternalGroups = pagedList;
            return View(result);
        }

        public ActionResult ViewInfo(PortfolioReportParameters paramData, string reportpath)
        {
            var havePermission = ReportPermissionRepository.HaveReportPermission(Base.LoginSession.isSystemUser,
                reportpath.ToLower().Replace(Base.GetConfig("ReportPathPrefix").ToLower(), ""),
                Base.LoginSession.intLevelId ?? 0, paramData.System.ToUpper());

            if (!havePermission)
            {
                return RedirectToAction("index", "welcome");
            }

            ViewBag.ReportParams = PopulateParametersData(paramData);
            LevelViewBag(reportpath, paramData.System.ToUpper());

            return View();
        }

        protected void LevelViewBag(string reportpath, string system)
        {
            var systemName = system;
            var systemid = UserRepository.GetSystemIdByName(!string.IsNullOrEmpty(systemName) ? systemName : "tmf");

            if (!(reportpath.ToLower().Contains("_rtw") && reportpath.ToLower().Contains("level5"))
                && !(reportpath.ToLower().Contains("_awc") && reportpath.ToLower().Contains("level4")))
            {
                ViewBag.List_TrafficLight = DashboardRepository.GetList_TrafficLight(systemid);
            }

            ViewBag.ReportPath = reportpath;
            ViewBag.SystemId = systemid;
            ViewBag.SystemName = systemName;
        }

        public ActionResult ReportRawData(string reportname)
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

        public ActionResult GetCPRAdvanceSearch(PortfolioReportParameters paramData)
        {
            ViewBag.ReportParams = PopulateGeneralParametersData(paramData);

            return PartialView("CPRAdvanceSearch");
        }

        #endregion Public Methods

        #region File cabinet

        public ActionResult GetFileCabinetReports(string system, string dashboard, string level, string type, string value, string subValue, string subSubValue)
        {
            var systemId = UserRepository.GetSystemIdByName(system);
            var systemList = UserRepository.GetSystemList();
            var categories = ReportCategoryRepository.GetList();
            var normalReportCategory = categories.FirstOrDefault();

            var normalReports = new List<Report>();
            if (normalReportCategory != null)
            {
                normalReports = ReportRepository.GetListByCategory("", "", 0, 0, normalReportCategory.CategoryId, systemId);
                UpdateNormalReportsUrl(normalReports, system, dashboard, level, type, value, subValue, subSubValue);
            }

            var reportFolders = new List<ActuarialItem>();
            if (Base.LoginType == LoginType.Internal)
            {
                foreach (Systems s in systemList)
                {
                    if (s.SystemId == systemId || Base.LoginSession.isSystemUser)
                        reportFolders = FileCabinetHelper.GetActuarialFolders(Base.GetConfig("FileCabinetRoot"), system);
                }
            }

            var model = new FileCabinet
            {
                NormalReports = normalReports,
                ReportFolders = reportFolders
            };

            return PartialView("FileCabinet", model);
        }

        public FileResult DownloadActuarialReport(string reportPath)
        {
            byte[] fileBytes = System.IO.File.ReadAllBytes(reportPath);
            string fileName = new FileInfo(reportPath).Name;
            return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, fileName);
        }

        public ActionResult GetActuarialReports(string folderPath)
        {
            var result = FileCabinetHelper.GetActuarialReports(folderPath);

            ViewBag.HasItems = false;
            return PartialView("ActuarialItems", result);
        }

        public ActionResult GetActuarialFolders(string system)
        {
            var result = FileCabinetHelper.GetActuarialFolders(Base.GetConfig("FileCabinetRoot"), system);
            return PartialView("ActuarialItems", result);
        }

        #region Private Methods

        private void UpdateNormalReportsUrl(List<Report> reports, string system, string dashboard, string level, string type, string value, string subValue, string subSubValue)
        {
            if (reports != null && reports.Any())
            {
                foreach (var report in reports)
                {
                    var strBasicPortfolioURL = Base.AbsoluteUrl("~/Report/ViewInfo?System=" + system + "&Type={0}");
                    var strPortfolio12URL = strBasicPortfolioURL + "&Value=all&reportpath=/emreporting/reports/" + report.Url.Trim();
                    var strPortfolio34URL = strBasicPortfolioURL + "&Value={1}&reportpath=/emreporting/reports/" + report.Url.Trim();
                    var strPortfolio5URL = strBasicPortfolioURL + "&Value={1}&SubValue={2}&reportpath=/emreporting/reports/" + report.Url.Trim();

                    if (level == "1" || level == "2")
                        report.Url = string.Format(strPortfolio12URL, type);
                    else if (level == "3" || level == "4")
                    {
                        if (level == "3")
                        {
                            // detect system Total and Grouping logic in level 3
                            if (value.ToLower() == "health@@@other"
                                //|| value.ToLower() == "police@@@fire@@@rfs"
                                || value.ToLower() == "police@@@emergency services"
                                || value.ToLower() == "hotel"
                                || value.ToLower() == "tmf"
                                || value.ToLower() == "wcnsw"
                                || value.ToLower() == "hospitality")
                            {
                                // use same URL in level 2
                                report.Url = string.Format(strPortfolio12URL, type);
                            }
                            else
                                report.Url = string.Format(strPortfolio34URL, type, value);
                        }
                        else
                        {
                            if (dashboard == "rtw")
                                report.Url = string.Format(strPortfolio34URL, type, value);
                            else
                            {
                                if (type.ToLower() != "group")
                                {
                                    // use same URL in level 3, 4
                                    report.Url = string.Format(strPortfolio34URL, type, value);
                                }
                                else
                                    report.Url = string.Format(strPortfolio5URL, type, value, subValue);
                            }
                        }
                    }
                    else if (level == "5" || level == "6" || level == "7")
                    {
                        if (type.ToLower() != "group")
                        {
                            // use same URL in level 3, 4
                            report.Url = string.Format(strPortfolio34URL, type, value);
                        }
                        else
                            report.Url = string.Format(strPortfolio5URL, type, value, subValue);
                    }
                }
            }
        }

        #endregion Private Methods

        #endregion File cabinet
    }
}