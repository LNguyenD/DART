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

namespace EM_Report.Controllers
{
    public class Dashboard_Graph_DescriptionController : BaseController
    {
        [HttpGet]
        public ActionResult GetAllDescription(string systemId, string type)
        {
            if (!string.IsNullOrEmpty(systemId))
            {
                var list = Dashboard_Graph_DescriptionRepository.GetList(type, int.Parse(systemId));
                return PartialView("GetAllDescription", list);
            }
            else
            {
                var list = Dashboard_Graph_DescriptionRepository.GetList();
                return PartialView("GetAllDescription", list);
            }
        }        

        [HttpGet]
        public ActionResult Index(string search_input, string hddSort)
        {
            hddSort = Base.Page_Sort("DescriptionId|desc");
            var pageSize = Base.Page_Size();
            var systemId = Request.QueryString["systemid"] != null ? int.Parse(Request.QueryString["systemid"]) : Base.LoginSession.intSystemId;
            var list = Dashboard_Graph_DescriptionRepository.GetList(string.Empty, hddSort, 1, pageSize, systemId);
            var pagedList = UpdateViewBag<Dashboard_Graph_Description>(string.Empty, hddSort, 1, pageSize, list);

            return View(pagedList);
        }

        [HttpPost]
        public ActionResult Index(FormCollection postForm, string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            var pagesize = int.Parse(Request.Form["cboDisplayEntry"]);
            hddSort = hddSort ?? Base.Page_Sort("DescriptionId|desc");
            var list = Dashboard_Graph_DescriptionRepository.GetList(search_input, hddSort, (int)(hddPaging), pagesize, 0);
            var pagedList = UpdateViewBag<Dashboard_Graph_Description>(search_input, hddSort, (int)(hddPaging), pagesize, list);

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
                var sModel = Dashboard_Graph_DescriptionRepository.GetById(id ?? 0);
                var model = sModel;
                FormViewBag(model);
                return View(model);
            }
        }

        [HttpPost]
        public ActionResult Details(Dashboard_Graph_Description model)
        {
            if (ModelState.IsValid)
            {
                var lstSystemSite = UserRepository.GetSystemList();
                var sModel = model;
                if (model.DescriptionId > 0)
                {
                    Dashboard_Graph_DescriptionRepository.Update(sModel);
                    ShowSuccess(Resource.msgSaveSuccess);
                }
                else
                {

                    foreach (var systemse in lstSystemSite)
                    {
                        if (!string.IsNullOrEmpty(Request.Form["chkSystem_" + systemse.Name]))
                        {
                            sModel.SystemId = int.Parse(Request.Form["chkSystem_" + systemse.Name]);
                            Dashboard_Graph_DescriptionRepository.Insert(sModel);
                        }
                    }

                    return RedirectToAction("Index", "Dashboard_Graph_Description");
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
        public ActionResult Import(Dashboard_Graph_Description_Import model)
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
                    if (!System.IO.Directory.Exists(AppDomain.CurrentDomain.BaseDirectory + "ImportData\\Description"))
                    {
                        System.IO.Directory.CreateDirectory(AppDomain.CurrentDomain.BaseDirectory + "ImportData\\Description");
                    }

                    string path = AppDomain.CurrentDomain.BaseDirectory + "ImportData\\Description\\" + fileName + "_"
                        + createdDate.ToString("yyyyMMddHHmmss") + fileExt;
                    model.File.SaveAs(path);

                    // save temp path
                    ViewBag.PathFileTmp = path;

                    model.GraphDescriptionList = ImportHelper.Get_Graph_Description_List(path);

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

                    model.GraphDescriptionList = ImportHelper.Get_Graph_Description_List(pathFileTmp);

                    // insert to db
                    foreach (var graphDescription in model.GraphDescriptionList)
                    {
                        if (!graphDescription.IsError)
                        {
                            graphDescription.Description = graphDescription.Description.Trim('\"');

                            var foundGraphDescriptionItem = Dashboard_Graph_DescriptionRepository.GetList(
                               graphDescription.Type.Trim().ToLower(),graphDescription.SystemId).ToList().SingleOrDefault();

                            if (foundGraphDescriptionItem == null)
                            {
                                Dashboard_Graph_DescriptionRepository.Insert(graphDescription);
                            }
                            else
                            {
                                graphDescription.DescriptionId = foundGraphDescriptionItem.DescriptionId;
                                Dashboard_Graph_DescriptionRepository.Update(graphDescription);
                            }
                        }
                    }
                   
                    // delete temp file
                    System.IO.File.Delete(pathFileTmp);

                    return RedirectToAction("Index", "Dashboard_Graph_Description", new { systemid = Request["systemid"] });
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
                Dashboard_Graph_DescriptionRepository.DeleteAll();
            }
            catch(Exception ex)
            {
                return new HttpStatusCodeResult(500);
            }
            
            return new HttpStatusCodeResult(200);
        }      

        protected void FormViewBag(Dashboard_Graph_Description model)
        {
            if (model != null)
            {
                ViewBag.cboSystemSite = new SelectList(UserRepository.GetSystemList().ToList(), "SystemId", "Name", model.DescriptionId);
            }
            else
            {
                ViewBag.cboSystemSite = UserRepository.GetSystemList().ToList();
            }
        }
    }
}