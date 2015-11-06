using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Linq.Expressions;
using System.Web.Mvc;
using System.Data;
using System.Data.SqlClient;
using EM_Report.BLL.Commons;
using EM_Report.BLL.Resources;
using EM_Report.BLL.Services;
using EM_Report.Helpers;
using EM_Report.Models;
using System.Web.Script.Serialization;
using EM_Report.Models.Report_Data_Object;
using System.IO;
using System.Text;

namespace EM_Report.Controllers
{
    using System.Collections.Specialized;

    using EM_Report.Models.RS2005;

    using Microsoft.ReportingServices.RdlObjectModel;

    public class ReportController : BaseController
    {
        private const string STR_SAVE = "save";
        private const string STR_DELETE = "delete";
        private const string STR_ASSIGN = "assign";
        private const string STR_UNASSIGN = "unassign";
        private const string STR_CBO_DISPLAY_ENTRY = "cboDisplayEntry";
        private const string STR_ACTION = "action";

        #region private member variables
        private I_ReportService _reportService;
        private I_ReportCategoriesService _categoryService;
        private I_External_GroupService _externalGroupService;
        private I_Organisation_Levels_Service _levelService;
        private I_RS_SubscriptionService _rs_subService;
        I_ReportParameterService _reportParamService;
        private I_UserService _qUserService;
        private string urlFullPath;

        #endregion

        #region public properties
        public I_ReportCategoriesService CategoryService
        {
            get { return _categoryService; }
            set { _categoryService = value; }
        }

        public I_ReportService ReportService
        {
            get { return _reportService; }
            set { _reportService = value; }
        }

        public I_External_GroupService ExternalGroupService
        {
            get { return _externalGroupService; }
            set { _externalGroupService = value; }
        }

        public I_Organisation_Levels_Service LevelService
        {
            get { return _levelService; }
            set { _levelService = value; }
        }

        #endregion

        #region constructor
        //
        // GET: /Permission/
        public ReportController()
            : base()
        {
            _reportService = new ReportService(Base.LoginSession);
            _categoryService = new ReportCategoriesService(Base.LoginSession);
            _externalGroupService = new External_GroupService(Base.LoginSession);
            _levelService = new Organisation_Levels_Service(Base.LoginSession);
            _rs_subService = new RS_SubscriptionService(Base.LoginSession);
            _reportParamService = new ReportParameterService();
            _qUserService = new UserService(Base.LoginSession);
            urlFullPath = "";
        }
        #endregion

        #region private method
        private ActionResult Save(ReportModel model, FormCollection postForm)
        {
            if (ModelState.IsValid)
            {
                var isNew = model.ReportId <= 0;
                model.Owner = (model.Owner <= 0 && isNew) ? Base.LoginSession.intUserId : model.Owner;
                model.OwnerName = Base.LoginSession.strUserName;
                try
                {
                    model = _reportService.CreateOrUpdate(model);
                    ShowSuccess(Resource.msgSaveSuccess);
                    if (!HandleReportPermission(postForm, _reportService.GetReportViewById(model.ReportId)))
                    {
                        ShowError(Resource.msgUpdateError);
                    }
                    else
                    {
                        ShowSuccess(Resource.msgSaveSuccess);
                    }
                    if (isNew)
                        return RedirectToAction("Index");
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
            return View(model);
        }

        private ActionResult Delete(ReportModel model)
        {
            try
            {
                _reportService.Delete(model.ReportId);
                return RedirectToAction("Index");
            }
            catch
            {
                ShowError(Resource.msgDeleteError);
            }
            return View(model);
        }

        private ActionResult SaveCategory(Report_CategoriesModel model)
        {
            if (ModelState.IsValid)
            {
                var isNew = model.CategoryId <= 0;
                model.Owner = (model.Owner <= 0 && isNew) ? Base.LoginSession.intUserId : model.Owner;
                model.OwnerName = Base.LoginSession.strUserName;

                try
                {
                    model = _categoryService.CreateOrUpdate(model);
                    ShowSuccess(Resource.msgSaveSuccess);
                    if (isNew)
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
            return View(model);
        }

        private ActionResult DeleteCategory(Report_CategoriesModel model)
        {
            try
            {
                _categoryService.Delete(model.CategoryId);
                return RedirectToAction("Category");
            }
            catch
            {
                ShowError(Resource.msgDeleteError);
            }
            return View(model);
        }

        private bool HandleReportPermission(FormCollection postForm, ReportPermissionModel model)
        {
            var isSuccess = AssignLevel(postForm, model);            

            ViewBag.Levels = LevelService.GetAll();
            ViewBag.ExternalsGroups = ExternalGroupService.GetAll();
            UpdateViewBagForReportPermission(model);

            return isSuccess;
        }

        private bool AssignLevel(FormCollection postForm, ReportPermissionModel model)
        {
            var selectedLevelId = int.Parse(postForm["cboLevel"]);

            // don't add again if existed
            if (model.ReportOrganisationLevelList.Where(e => e.LevelId == selectedLevelId).FirstOrDefault() != null)
            {
                return true;
            }

            try
            {
                //remove existing assignment
                foreach (var item in model.ReportOrganisationLevelList)
                {
                    ReportService.RemoveOrganisationRole(model, item);
                }
                model.ReportOrganisationLevelList.Clear();
                //add new one
                var organisationRole = new Report_Organisation_LevelsModel()
                {
                    LevelId = selectedLevelId,
                    Create_Date = DateTime.Now,
                    ReportId = model.ReportId,
                    Owner = Base.LoginSession.intUserId,
                    OwnerName = Base.LoginSession.strUserName
                };
                ReportService.AddOrganisationRole(model, organisationRole);
                model.ReportOrganisationLevelList.Add(organisationRole);
                return true;
            }
            catch
            {
                return false;
            }
        }

        private void HandleUnassignCommand(string hddAction, ReportPermissionModel modelResult)
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
                    var externalAccess = modelResult.ReportExternalAccessList.Where(e => e.External_GroupId == int.Parse(item) && e.ReportId == modelResult.ReportId).FirstOrDefault();
                    ReportService.RemoveReportExternalAccess(modelResult, externalAccess);
                    modelResult.ReportExternalAccessList.Remove(externalAccess);
                    ShowSuccess(Resource.msgSaveSuccess);
                }
                catch
                {
                    ShowError(Resource.msgUpdateError);
                }
            }
        }

        private void HandleUnassignCommandLevel(string hddAction, ReportPermissionModel modelResult)
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
                    var levelRole = modelResult.ReportOrganisationLevelList.Where(e => e.LevelId == int.Parse(item) && e.ReportId == modelResult.ReportId).FirstOrDefault();
                    ReportService.RemoveOrganisationRole(modelResult, levelRole);
                    modelResult.ReportOrganisationLevelList.Remove(levelRole);
                    ShowSuccess(Resource.msgSaveSuccess);
                }
                catch
                {
                    ShowError(Resource.msgUpdateError);
                }
            }
        }

        private void HandleAssignCommand(FormCollection postForm, string hddAction, ReportPermissionModel modelResult)
        {
            if (string.IsNullOrEmpty(hddAction))
                return;

            var selectedItems = hddAction.Split('|');
            if (selectedItems.Length <= 0)
                return;

            foreach (var item in selectedItems[1].Split(','))
            {
                var group = this.ExternalGroupService.GetById(item);
                if (!modelResult.ReportExternalAccessList.Where(e => e.ReportId == modelResult.ReportId && e.External_GroupId == group.External_GroupId).IsNullOrEmpty())
                    continue;

                var externalAccess = new Report_External_AccessModel()
                {
                    External_GroupId = group.External_GroupId,
                    Create_Date = DateTime.Now,
                    ReportId = modelResult.ReportId,
                    Owner = Base.LoginSession.intUserId,
                    OwnerName = Base.LoginSession.strUserName
                };
                try
                {
                    ReportService.AddReportExternalAccess(modelResult, externalAccess);
                    modelResult.ReportExternalAccessList.Add(externalAccess);
                    ShowSuccess(Resource.msgSaveSuccess);
                }
                catch
                {
                    ShowError(Resource.msgUpdateError);
                }

            }
        }

        private void HandleAssignCommandLevel(FormCollection postForm, string hddAction, ReportPermissionModel modelResult)
        {
            if (string.IsNullOrEmpty(hddAction))
                return;

            var selectedItems = hddAction.Split('|');
            if (selectedItems.Length <= 0)
                return;

            foreach (var item in selectedItems[1].Split(','))
            {
                var level = this.LevelService.GetById(item);
                if (!modelResult.ReportOrganisationLevelList.Where(e => e.ReportId == modelResult.ReportId && e.LevelId == level.LevelId).IsNullOrEmpty())
                    continue;

                var organisationRole = new Report_Organisation_LevelsModel()
                {
                    LevelId = level.LevelId,
                    Create_Date = DateTime.Now,
                    ReportId = modelResult.ReportId,
                    Owner = Base.LoginSession.intUserId,
                    OwnerName = Base.LoginSession.strUserName
                };
                try
                {
                    ReportService.AddOrganisationRole(modelResult, organisationRole);
                    modelResult.ReportOrganisationLevelList.Add(organisationRole);
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
            IList<Report_CategoriesModel> categoryList = CategoryService.GetAll().OrderBy(l=>l.Name).ToList();
            if (haveEmptyDefaultRow)
            {
                categoryList.Insert(0, new Report_CategoriesModel() { CategoryId = 0, Name = "-- All --" });
            }
            ViewBag.CategoryList = new SelectList(categoryList, "CategoryId", "Name", selectedValue);
        }

        private void PrepareForEmailReportResult(ReportModel rptModel)
        {
            //create new subscription
            RS_SubscriptionModel subModel = new RS_SubscriptionModel();
            ScheduleDefinition defaultSchDef = (ScheduleDefinition)HttpContext.Application["DefaultSchedule"];
            defaultSchDef.StartDateTime = DateTime.Now.Date;

            subModel = new RS_SubscriptionModel()
            {
                rptParamterModel = new ReportParameterModel()
                {
                    lstRSParameters = _reportParamService.GetVisibleParametersInfo(rptModel.UrlFullPath)
                },
                ReportPath = rptModel.UrlFullPath,
                ReportId = rptModel.ReportId,
                DeliveryMethod = Constants.DeliveryMethodNames[DeliveryMethod.EMAIL],
                ScheduleDefJson = HttpUtility.UrlEncode(ScheduleService.SerializeSchedule(defaultSchDef).InnerXml),
                Status = ResourcesHelper.StatusActive
            };

            ViewBag.DeliveryMethod = subModel.DeliveryMethod;
            Session["RS_SubscriptionModel"] = subModel;
        }
        #endregion

        #region public methods
        //Category
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult CategoryDetails(long? id)
        {
            var model = new Report_CategoriesModel();
            if (!id.HasValue)
                return View(model);

            try
            {
                model = _categoryService.GetById(id.Value);
            }
            catch (Exception)
            {
                //get error
                ShowError(Resource.msgLoadError);
            }
            return View(model);
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult CategoryDetails(FormCollection postForm, Report_CategoriesModel model)
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

        public ActionResult Category(string search_input, string hddSort)
        {
            var hddPaging = 1;
            hddSort = hddSort ?? "Create_Date|desc";
            var pagesize = ResourcesHelper.Report_PageSize;

            var list = CategoryService.GetAllQueryable(hddSort, string.Empty);
            var pagedList = UpdateViewBag<Report_CategoriesModel>(search_input, hddSort, hddPaging, pagesize, list);
            return View(pagedList);
        }

        [HttpPost]
        public ActionResult Category(FormCollection postForm, string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            if (!string.IsNullOrEmpty(hddAction))
            {
                var selectedItems = hddAction.Split('|');
                Report_CategoriesModel model;
                if (selectedItems.Length > 0)
                {
                    foreach (var item in selectedItems[1].Split(','))
                    {
                        model = _categoryService.GetById(item);
                        _categoryService.UpdateStatus(model, short.Parse(selectedItems[0]));
                    }
                }
            }

            var pagesize = int.Parse(Request.Form[STR_CBO_DISPLAY_ENTRY]);
            hddSort = hddSort ?? string.Empty;
            var list = CategoryService.GetAllQueryable(hddSort, search_input.Trim());
            var pagedList = UpdateViewBag<Report_CategoriesModel>(search_input.Trim(), hddSort, hddPaging, pagesize, list);
            return View(pagedList);
        }

        //Report
        public ActionResult Index(string search_input, string hddSort)
        {
            var hddPaging = 1;
            hddSort = hddSort ?? "Create_Date|desc";
            var pagesize = ResourcesHelper.Report_PageSize;

            PrepareCategoryDropdownlist(string.IsNullOrEmpty(Request["cId"]) ? 0 :int.Parse(Request["cId"]), true);
            var list = ReportService.GetAllQueryable(hddSort, string.Empty);
            if (!Base.LoginSession.isSystemUser)
            {
                list = list.Where(l => l.Status == ResourcesHelper.StatusActive);
            }
            if (!string.IsNullOrEmpty(Request["cId"]))
            {
                list = list.Where(l => l.CategoryId == int.Parse(Request["cId"]));
            }
            var pagedList = UpdateViewBag<ReportModel>(search_input, hddSort, hddPaging, pagesize, list);            
            
            ViewBag.Categories = CategoryService.GetAllQueryable("Name|asc", string.Empty);
            return View(pagedList);
        }

        [HttpPost]
        public ActionResult Index(FormCollection postForm, string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            //action
            if (!string.IsNullOrEmpty(hddAction))
            {
                var selectedItems = hddAction.Split('|');
                ReportModel model;
                if (selectedItems.Length > 0)
                {
                    if (selectedItems[0] == "favorite" && selectedItems[1]!=null)
                    {
                        ReportService.AddOrRemoveFavoriteReport(Base.LoginSession.intUserId, int.Parse(selectedItems[1]));
                        
                        Login.LoginAction(Base.LoginSession.intUserId, Base.LoginSession.isRememberme);
                    }
                    else
                    {
                        foreach (var item in selectedItems[1].Split(','))
                        {
                            model = ReportService.GetById(item);
                            ReportService.UpdateStatus(model, short.Parse(selectedItems[0]));
                        }
                    }
                }
            }
            
            //page size
            var pagesize = int.Parse(Request.Form[STR_CBO_DISPLAY_ENTRY]);
            hddSort = hddSort ?? string.Empty;
           
            //category
            Expression<Func<ReportModel, bool>> criteria = null;
            var category = int.Parse(Request.Form["cboCategory"]);
            ViewBag.Category = category;
            if (category > 0)
            {
                criteria = (p => p.CategoryId == category);
            }            

            //binding list
            PrepareCategoryDropdownlist(category, true);
            var list = ReportService.GetAllQueryable(hddSort, search_input.Trim(), criteria);
            if (!Base.LoginSession.isSystemUser)
            {
                list = list.Where(l => l.Status == ResourcesHelper.StatusActive);
            }            
            var pagedList = UpdateViewBag<ReportModel>(search_input.Trim(), hddSort, hddPaging, pagesize, list);

            return View(pagedList);
        }

        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Details(long? id, string hddSort)
        {
            PrepareCategoryDropdownlist(1, false);
            var reportModel = new ReportModel();
            ViewBag.Levels = LevelService.GetAll().OrderBy(l=>l.Name);
            ViewBag.ExternalsGroups = ExternalGroupService.GetAll();

            if (!id.HasValue)
                return View(reportModel);
            try
            {
                reportModel = _reportService.GetById(id.Value);
                var reportPermissionModel = _reportService.GetReportViewById(id.Value);
                UpdateViewBagForReportPermission(reportPermissionModel);
            }
            catch (Exception)
            {
                ShowError(Resource.msgLoadError);
            }
            return View(reportModel);
        }

        private void UpdateViewBagForReportPermission(ReportPermissionModel model)
        {
            if (model.ReportOrganisationLevelList.FirstOrDefault() != null)
            {
                ViewBag.AssignLevel = model.ReportOrganisationLevelList.FirstOrDefault().LevelId;
            }
            if (model.ReportExternalAccessList.FirstOrDefault() != null)
            {
                ViewBag.AssignGroup = model.ReportExternalAccessList.FirstOrDefault().External_GroupId;
            }
        }

        [HttpPost]
        public ActionResult Details(FormCollection postForm, ReportModel model, string hddAction, string hddSort, int? hddPaging = 1)
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
                ViewBag.Levels = LevelService.GetAll().OrderBy(l => l.Name);
                ViewBag.ExternalsGroups = ExternalGroupService.GetAll();
                PrepareCategoryDropdownlist(model.CategoryId, false);
                ShowError(Resource.msgInvalidInput);
            }
            return View();
        }

        [HttpGet]
        public ActionResult ExternalGroup(long? id, string hddSort)
        {
            var hddPaging = 1;
            hddSort = hddSort ?? "External_GroupId|desc";
            var pagesize = ResourcesHelper.Report_PageSize;
            var externalGroups = ExternalGroupService.GetAllQueryable(hddSort, string.Empty);
            var pagedList = UpdateViewBag<External_GroupModel>(string.Empty, hddSort, hddPaging, pagesize, externalGroups);
            ViewBag.ExternalGroups = pagedList;

            var model = new ReportPermissionModel();
            if (!id.HasValue)
                return View(model);

            try
            {
                model = _reportService.GetReportViewById(id.Value);
            }
            catch (Exception)
            {
                ShowError(Resource.msgLoadError);
            }
            return View(model);
        }

        [HttpPost]
        public ActionResult ExternalGroup(FormCollection postForm, ReportPermissionModel model, string hddAction,string search_input, string hddSort, int? hddPaging = 1)
        {
            ReportPermissionModel modelResult = _reportService.GetReportViewById(model.ReportId);
            switch (Request.Form[STR_ACTION].ToLower())
            {
                case STR_ASSIGN:
                    HandleAssignCommand(postForm, hddAction, modelResult);
                    break;
                case STR_UNASSIGN:
                    HandleUnassignCommand(hddAction, modelResult);
                    break;
                default:
                    break;

            }
            var pagesize = int.Parse(Request.Form[STR_CBO_DISPLAY_ENTRY]);
            hddSort = hddSort ?? string.Empty;
            var externalGroups = ExternalGroupService.GetAllQueryable(hddSort,search_input);
            var pagedList = UpdateViewBag<External_GroupModel>(search_input, hddSort, hddPaging, pagesize, externalGroups);
            ViewBag.ExternalGroups = pagedList;
            return View(modelResult);
        }

        [HttpGet]
        public ActionResult OrganisationRole(long? id, string hddSort)
        {
            var hddPaging = 1;
            hddSort = hddSort ?? "LevelId|desc";
            var pagesize = ResourcesHelper.Report_PageSize;
            var levelGroups = LevelService.GetAllQueryable(hddSort, string.Empty);
            var pagedList = UpdateViewBag<Organisation_Levels_Model>(string.Empty, hddSort, hddPaging, pagesize, levelGroups);
            ViewBag.OrganisationRoles = pagedList;

            var model = new ReportPermissionModel();
            if (!id.HasValue)
                return View(model);

            try
            {
                model = _reportService.GetReportViewById(id.Value);
            }
            catch (Exception)
            {
                ShowError(Resource.msgLoadError);
            }
            return View(model);
        }

        [HttpPost]
        public ActionResult OrganisationRole(FormCollection postForm, ReportPermissionModel model, string hddAction, string hddSort, int? hddPaging = 1)
        {
            ReportPermissionModel modelResult = _reportService.GetReportViewById(model.ReportId);
            switch (Request.Form[STR_ACTION].ToLower())
            {
                case STR_ASSIGN:
                    HandleAssignCommandLevel(postForm, hddAction, modelResult);
                    break;
                case STR_UNASSIGN:
                    HandleUnassignCommandLevel(hddAction, modelResult);
                    break;
                default:
                    break;

            }
            var pagesize = int.Parse(Request.Form[STR_CBO_DISPLAY_ENTRY]);
            hddSort = hddSort ?? string.Empty;
            var levelGroups = LevelService.GetAllQueryable(hddSort, string.Empty);
            var pagedList = UpdateViewBag<Organisation_Levels_Model>(string.Empty, hddSort, hddPaging, pagesize, levelGroups);
            ViewBag.OrganisationRoles = pagedList;
            return View(modelResult);
        }

        public ActionResult ViewInfo(string reportpath)
        {
            var model = new ReportModel();
             //Insert Recently report
            try
            {
                if (!string.IsNullOrEmpty(Request["rId"]))
                {
                    Login.LoginAction(Base.LoginSession.intUserId, Base.LoginSession.isRememberme);
                    ReportService.AddRecentlyReport(Base.LoginSession.intUserId, int.Parse(Request["rId"]));
                    model = ReportService.GetById(Request["rId"]);
                    if (model != null)
                    {
                        ViewBag.ReportName = model.Name;
                    }
                    ViewBag.ReportId = Request["rId"];
                }
                else
                {
                    ViewBag.ReportId = 0;
                    ViewBag.ReportName = string.Empty;
                }
                ViewBag.ReportPath = model.UrlFullPath;
                ViewBag.ReportParams = new ReportParameterModel() { lstRSParameters = new ReportParameterService().GetVisibleParametersInfo(model.UrlFullPath, null) };
                ViewBag.RenderFormats = ViewHelpers.LocalRenderFormats();
                PrepareForEmailReportResult(model);
                // Linh comment out get field for filter feature
                //ViewBag.Fields = _reportParamService.GetFields(model.UrlFullPath);
            }
            catch (Exception ex)
            {
                ViewBag.ErrorAccess = ex.Message;
            }
            return View(model);
        }        

        [HttpPost]
        public ActionResult ExportFile(string strParams, string reportpath, string exportFormat)
        {
            ExportService exService = new ExportService();
            MemoryStream ms = new MemoryStream();
            string fileLocation = null;
            try
            {
                fileLocation = exService.ExportFile(strParams, reportpath, exportFormat, Base.LoginSession.strUserName,
                    bool.Parse((new TeamService(Base.LoginSession)).IsRIG(Base.LoginSession.strUserName, Base.SiteName()).ToString().ToLowerInvariant()));
            }
            catch (Exception ex)
            {
                ViewBag.Result = false;
                ViewBag.Message = ex.Message + ". Export fail!";
                return Json(new { issuccess = false, html = this.RenderPartialViewToString("ExportFile")}, JsonRequestBehavior.AllowGet);
            }
            ViewBag.Result = true;
            ViewBag.Message = "Export successfull! Wait seconds for downloading...";
            Session["ExportFileLocation"] = fileLocation;
            return Json(new { issuccess = true, html = this.RenderPartialViewToString("ExportFile") }, JsonRequestBehavior.AllowGet);
        }

        public FileContentResult RenderExport()
        {
            ExportService exService = new ExportService();
            string fileLocation = (string)Session["ExportFileLocation"];
            MemoryStream stream = exService.Zip(fileLocation);
            return File(stream.ToArray(), "application/zip", fileLocation.Substring(fileLocation.LastIndexOf("\\")) + ".zip");
        }       

        [HttpGet]
        public ActionResult UCPolicy()
        {
            return View();
        }

        [HttpPost]
        public ActionResult UCPolicy(PolicyModel policyModel, string employer, int? hddPaging = 1)
        {
            if (ModelState.IsValid)
            {
                ViewBag.Employer = employer;

                string sort = "PolicyNo|Asc";
                I_PolicyService policyService = new PolicyService(Base.LoginSession);
                var list = policyService.Search(employer, string.IsNullOrEmpty(policyModel.PolicyNo) ? "" : policyModel.PolicyNo, policyModel.ABN.ToString(), policyModel.ACN.ToString(), sort);
                var pagedList = UpdateViewBag<PolicyModel>(string.Empty, sort, hddPaging, ResourcesHelper.Report_PageSize, list);
                ViewBag.policymodel = pagedList;
            }
            else
            {
                ModelState.AddModelError("Error", Resource.msgInvalidInput);
            }
            return View();
        }

        [HttpGet]
        public ActionResult UCPaymentType(string claimNumber, string showClaimNumber)
        {
            if (!string.IsNullOrEmpty(claimNumber))
                ViewBag.ClaimNumber = claimNumber.TrimStart();
            if (!string.IsNullOrEmpty(showClaimNumber))
                ViewBag.ShowClaimNumber = showClaimNumber;  

            return View();
        }

        [HttpPost]
        public ActionResult UCPaymentType(string paymentType, string paymentDescription, string claimNumber, string showClaimNumber, int? hddPaging = 1)
        {
            ViewBag.PaymentType = paymentType;
            ViewBag.PaymentDescription = paymentDescription;
            if (!string.IsNullOrEmpty(claimNumber))
                claimNumber = claimNumber.TrimStart();
            ViewBag.ClaimNumber = claimNumber;
            ViewBag.ShowClaimNumber = showClaimNumber;

            string sort = "Type|Asc";
            I_PaymentService paymentService = new PaymentService(Base.LoginSession);
            var list = paymentService.Search(paymentType, paymentDescription, claimNumber, sort);
            var pagedList = UpdateViewBag<PaymentTypeModel>(string.Empty, sort, hddPaging, ResourcesHelper.Report_PageSize, list);

            return View(pagedList);

        }

        [HttpGet]
        public ActionResult UCCreditor(string claimNumber, string showClaimNumber)
        {
            if (!string.IsNullOrEmpty(claimNumber))
                ViewBag.ClaimNumber = claimNumber.TrimStart();
            if (!string.IsNullOrEmpty(showClaimNumber))
                ViewBag.ShowClaimNumber = showClaimNumber;  
            return View();
        }

        [HttpPost]
        public ActionResult UCCreditor(CreditorModel creditormodel, string name, string wcprovidercode, string hcno, string claimNumber, string showClaimNumber, int? hddPaging = 1)
        {
            if (ModelState.IsValid)
            {
                ViewBag.Name = name;
                ViewBag.WCProviderCode = wcprovidercode;
                ViewBag.HCNo = hcno;
                if (!string.IsNullOrEmpty(claimNumber))
                    claimNumber = claimNumber.TrimStart();
                ViewBag.ClaimNumber = claimNumber;
                ViewBag.ShowClaimNumber = showClaimNumber;

                string sort = "Name|Asc";
                I_CreditorService creditorService = new CreditorService(Base.LoginSession);
                var list = creditorService.Search(name, string.IsNullOrEmpty(creditormodel.ABN.ToString()) ? "" : creditormodel.ABN.ToString(), wcprovidercode, hcno, claimNumber, sort);
                var pagedList = UpdateViewBag<CreditorModel>(string.Empty, sort, hddPaging, ResourcesHelper.Report_PageSize, list);
                ViewBag.creditorModel = pagedList;
            }
            else
            {
                ViewBag.ShowClaimNumber = showClaimNumber;
                ShowError(Resource.msgInvalidInput);
            }
            return View();
        }

        [HttpGet]
        public ActionResult UCBroker()
        {
            return View();
        }

        [HttpPost]
        public ActionResult UCBroker(string brokerName, string contactSurname, int? hddPaging = 1)
        {
            ViewBag.BrokerName = brokerName;
            ViewBag.ContactSurname = contactSurname;
            
            string sort = "Name|BrokerNo|Asc";
            I_BrokerService brokerService = new BrokerService(Base.LoginSession);
            var list = brokerService.Search(brokerName, contactSurname, sort);
            var pagedList = UpdateViewBag<BrokerModel>(string.Empty, sort, hddPaging, ResourcesHelper.Report_PageSize, list);

            return View(pagedList);

        }

        [HttpGet]
        public ActionResult UCProvider(string claimNumber, string showClaimNumber)
        {
            if (!string.IsNullOrEmpty(claimNumber))
                ViewBag.ClaimNumber = claimNumber.TrimStart();
            if (!string.IsNullOrEmpty(showClaimNumber))
                ViewBag.ShowClaimNumber = showClaimNumber;  

            return View();
        }

        [HttpPost]
        public ActionResult UCProvider(string name, string claimNumber, string showClaimNumber, int? hddPaging = 1)
        {
            ViewBag.ProviderName = name;
            if (!string.IsNullOrEmpty(claimNumber))
                claimNumber = claimNumber.TrimStart();
            ViewBag.ClaimNumber = claimNumber;
            ViewBag.ShowClaimNumber = showClaimNumber;

            string sort = "FirstName|Asc";
            I_ProviderService providerService = new ProviderService(Base.LoginSession);
            var list = providerService.Search(name, claimNumber, sort);
            var pagedList = UpdateViewBag<ProviderModel>(string.Empty, sort, hddPaging, ResourcesHelper.Report_PageSize, list);

            return View(pagedList);

        }

        [HttpPost]
        public ActionResult ViewInfo(FormCollection collection, string ReportId, string schedule, string hdClientUTC)
        {
            RS_SubscriptionModel sub = new RS_SubscriptionModel();
            sub.Format = collection.Get("format");
            sub.ToEmail = collection.Get("toEmail");
            sub.Subject = collection.Get("subject");
            sub.Comment = collection.Get("comment");
            sub.ReportId = int.Parse(ReportId);            
            sub.StartHour = sub.StartDate.Hour;
            sub.StartMinute = sub.StartDate.Minute + 1;
            sub.DeliveryMethod = Constants.DeliveryMethodNames[DeliveryMethod.EMAIL];
            
            if(CreateSubscription(sub, collection, schedule, hdClientUTC))
                ShowSuccess(Resource.msgSendMailSuccess);
            else ShowError(Resource.msgSendMailError);

            return JavaScript("SendMailSuccess();");
        }

        private bool CreateSubscription(RS_SubscriptionModel sub, FormCollection collection, string schedule, string hdClientUTC)
        {
            // schedule
            sub.ScheduleName = sub.ReportPath + " - " + DateTime.Now.ToString();
            schedule = GetScheduleSendMail(sub, hdClientUTC);
            sub.EventType = "TimedSubscription";
            sub.Owner = Base.LoginSession.intUserId;
            sub.rptParamterModel = ((RS_SubscriptionModel)Session["RS_SubscriptionModel"]).rptParamterModel;
            sub.rptParamterModel.lstRSValues = SubscriptionController.GetReportParameterValues(collection, collection.Get("reportParameterNames"));
            return (!string.IsNullOrEmpty(_rs_subService.Create(sub)));
        }

        protected string GetScheduleSendMail(RS_SubscriptionModel sub, string hdClientUTC)
        {
            sub.ScheduleDefType = "Once";

            ScheduleDefinition scdDef = new ScheduleDefinition();
            int hour = sub.IsAM ? sub.StartHour : sub.StartHour + 12;

            scdDef.StartDateTime = Base.ConvertToServerDatetime(new System.DateTime(sub.StartDate.Year, sub.StartDate.Month, sub.StartDate.Day, sub.StartDate.Hour, sub.StartDate.Minute + 1, 0), hdClientUTC);
            scdDef.EndDate = sub.EndDate;
            scdDef.EndDateSpecified = sub.HasEndDate;

            scdDef.Item = null;

            Schedule scd = new Models.RS2005.Schedule() { Definition = scdDef };
            sub.ScheduleDefJson = HttpUtility.UrlEncode(ScheduleService.SerializeSchedule(scd.Definition).InnerXml);
            sub.ScheduleChanged = true;
            return sub.ScheduleDefJson;
        }

        [HttpGet]
        public ActionResult SendMailLoadingReport(string reportParameters, string reportId, string reportName, string multipleValueNames)
        {
            var userModel = _qUserService.GetUserById(Base.LoginSession.intUserId);
            ViewBag.ToEmail = userModel.Email;
            ViewBag.RenderFormats = ViewHelpers.LocalRenderFormats();
            
            var model = new ReportModel();
            model = ReportService.GetById(reportId);
            ViewBag.ReportParams = reportParameters;
            ViewBag.MultipleParamNames = multipleValueNames;

            ViewBag.ReportName = reportName;
            ViewBag.ReportId = reportId;

            return View();
        }

        [HttpPost]
        public ActionResult SendMailLoadingReport(FormCollection collection, string schedule,string hdClientUTC)
        {
            RS_SubscriptionModel sub = new RS_SubscriptionModel();
            sub.Format = collection.Get("format");
            sub.ToEmail = collection.Get("toEmail");
            sub.Subject = collection.Get("reportName").Replace("Name:", "Report:");
            sub.Comment = collection.Get("reportName").Replace("Name:", "Report:");
            sub.ReportId = int.Parse(collection.Get("reportId"));
            sub.StartHour = sub.StartDate.Hour;
            sub.StartMinute = sub.StartDate.Minute + 1;
            sub.DeliveryMethod = Constants.DeliveryMethodNames[DeliveryMethod.EMAIL];

            CreateSubscription(sub, collection, schedule, hdClientUTC);

            return null;
        }

        //public ActionResult TestResult()
        //{
        //    ViewBag.ReportParams = new ReportParameterModel() { lstRSParameters = new ReportParameterService().GetVisibleParametersInfo("/EMReportingDEMO/Reports/TOOCSCoding", null) };
        //    if (ViewBag.ReportParams != null)
        //        ViewBag.Test = "Success";
        //    return View(ViewBag);
        //}
        #endregion
    }
}
