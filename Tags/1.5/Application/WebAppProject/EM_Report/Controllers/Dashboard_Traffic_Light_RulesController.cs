using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using EM_Report.Domain;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Repositories;

namespace EM_Report.Controllers
{
    public class Dashboard_Traffic_Light_RulesController : BaseController
    {
        [HttpGet]
        public ActionResult Index(string searchInput, string hddSort)
        { 
            hddSort = Base.Page_Sort("Id|desc");
            var pageSize = Base.Page_Size();
            var systemId = Request.QueryString["systemid"] != null ? int.Parse(Request.QueryString["systemid"]) : Base.LoginSession.intSystemId;            
            var list = Dashboard_Traffic_Light_RulesRepository.GetList(string.Empty, hddSort, 1, pageSize, systemId);

            var pagedList = UpdateViewBag<Dashboard_Traffic_Light_Rule>(string.Empty, hddSort, 1, pageSize, list);
            return View(pagedList);
        }

        [HttpPost]
        public ActionResult Index(FormCollection postForm, string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            var pagesize = int.Parse(Request.Form["cboDisplayEntry"]);
            hddSort = hddSort ?? Base.Page_Sort("Id|desc");

            var list = Dashboard_Traffic_Light_RulesRepository.GetList(search_input, hddSort, (int)(hddPaging), pagesize, int.Parse(Request["cboSystem"]));
            var pagedList = UpdateViewBag<Dashboard_Traffic_Light_Rule>(search_input, hddSort, (int)(hddPaging), pagesize, list);

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
                var sModel = Dashboard_Traffic_Light_RulesRepository.GetById(id ?? 0);
                var model = sModel;
                FormViewBag(model);
                return View(model);
            }
        }

        [HttpPost]
        public ActionResult Details(Dashboard_Traffic_Light_Rule model)
        {
            if (ModelState.IsValid)
            {
                var lstSystemSite = UserRepository.GetSystemList();
                var sModel = model;
                if (model.Id > 0)
                {
                    Dashboard_Traffic_Light_RulesRepository.Update(sModel);
                    ShowSuccess(Resource.msgSaveSuccess);
                }
                else
                {
                    foreach (var systemse in lstSystemSite)
                    {
                        if (!string.IsNullOrEmpty(Request.Form["chkSystem_" + systemse.Name]))
                        {
                            sModel.SystemId = int.Parse(Request.Form["chkSystem_" + systemse.Name]);
                            Dashboard_Traffic_Light_RulesRepository.Insert(sModel);
                        }
                    }

                    return RedirectToAction("index", "Dashboard_Traffic_Light_Rules");
                }
            }
            else
            {
                ShowError(Resource.msgInvalidInput);
            }

            FormViewBag(model);
            return View(model);
        }

        [HttpGet]
        public ActionResult Import(int? id)
        {
            return View();
        }

        [HttpPost]
        public ActionResult Import(Dashboard_Traffic_Light_Rules_Import model)
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
                    if (!System.IO.Directory.Exists(AppDomain.CurrentDomain.BaseDirectory + "ImportData\\Target"))
                    {
                        System.IO.Directory.CreateDirectory(AppDomain.CurrentDomain.BaseDirectory + "ImportData\\Target");
                    }

                    string path = AppDomain.CurrentDomain.BaseDirectory + "ImportData\\Target\\" + fileName + "_"
                        + createdDate.ToString("yyyyMMddHHmmss") + fileExt;
                    model.File.SaveAs(path);

                    // save temp path
                    ViewBag.PathFileTmp = path;

                    model.TrafficLightRulesList = ImportHelper.Get_Dashboard_Traffic_Light_Rules_List(path);

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

                    model.TrafficLightRulesList = ImportHelper.Get_Dashboard_Traffic_Light_Rules_List(pathFileTmp);

                    // insert to db
                    foreach (var trafficLightRules in model.TrafficLightRulesList)
                    {
                        if (!trafficLightRules.IsError)
                        {
                            var foundTrafficLightRulesItem = Dashboard_Traffic_Light_RulesRepository.Get(
                                    trafficLightRules.DashboardType.Trim().ToLower(),
                                    trafficLightRules.Name.Trim().ToLower(),
                                    trafficLightRules.SystemId);

                            if (foundTrafficLightRulesItem == null)
                            {
                                Dashboard_Traffic_Light_RulesRepository.Insert(trafficLightRules);
                            }
                            else
                            {
                                trafficLightRules.Id = foundTrafficLightRulesItem.Id;
                                Dashboard_Traffic_Light_RulesRepository.Update(trafficLightRules);
                            }
                        }
                    }

                    // delete temp file
                    System.IO.File.Delete(pathFileTmp);

                    return RedirectToAction("Index", "Dashboard_Traffic_Light_Rules", new { systemid = Request["systemid"] });
                }
            }
            else
            {
                ShowError(Resource.msgInvalidInput);

                return View(model);
            }
        }

        [HttpPost]
        public ActionResult DeleteAll()
        {
            try
            {
                Dashboard_Traffic_Light_RulesRepository.DeleteAll();
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500);
            }

            return new HttpStatusCodeResult(200);
        }        

        [HttpPost]
        protected void FormViewBag(Dashboard_Traffic_Light_Rule model)
        {
            if (model != null)
            {
                ViewBag.cboSystemSite = new SelectList(UserRepository.GetSystemList().ToList(), "SystemId", "Name", model.SystemId);
            }
            else
            {
                ViewBag.cboSystemSite = UserRepository.GetSystemList().ToList();
            }
        }
    }
}