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
    public class ExternalController : BaseController
    {
        public ExternalController()
            : base()
        {
                            
        }  

        [HttpGet]
        public ActionResult Index()
        {
            var hddSort = Base.Page_Sort("External_GroupId|desc");
            var pageSize = Base.Page_Size();
            var list = External_GroupRepository.GetList(string.Empty, hddSort, 1, pageSize);
            var pagedList = UpdateViewBag<External_Group>(string.Empty, hddSort, 1, pageSize, list);            
            return View(pagedList);  
        }

        [HttpPost]
        public ActionResult Index(FormCollection postForm, string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            External_GroupRepository.UpdateStatus(StatusRepository.ReplaceNameById(hddAction));

            var pageSize = int.Parse(Request.Form["cboDisplayEntry"]);            
            hddSort = hddSort ?? Base.Page_Sort("External_GroupId|desc");
            
            var pagedList = UpdateViewBag<External_Group>(search_input, hddSort, hddPaging, pageSize, External_GroupRepository.GetList(search_input, hddSort, (int)(hddPaging), pageSize));
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
                var sModel = External_GroupRepository.GetById(id ?? 0);
                var model = sModel;                
                FormViewBag(model);
                return View(model);
            }            
        }

        [HttpPost]
        public ActionResult Details(Domain.External_Group model)
        {
            if (ModelState.IsValid)
            {
                var sModel = model;
                if (model.External_GroupId > 0)
                {
                    External_GroupRepository.Update(sModel);                    
                    ShowSuccess(Resource.msgSaveSuccess);
                }
                else
                {                
                    External_GroupRepository.Insert(sModel);
                    return RedirectToAction("index", "external");
                }
            }
            else
            {
                ShowError(Resource.msgInvalidInput);
            }
            FormViewBag(model);
            return View(model);
        }

        protected void FormViewBag(Domain.External_Group model)
        {
            ViewBag.cboStatus = new SelectList(StatusRepository.StatusList(), "StatusId", "Name", model == null ? 0 : model.Status);
        }
    }
}
