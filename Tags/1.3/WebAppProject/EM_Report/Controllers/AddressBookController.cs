using System;
using System.Web.Mvc;
using EM_Report.BLL.Commons;
using EM_Report.BLL.Resources;
using EM_Report.BLL.Services;
using EM_Report.Helpers;
using EM_Report.Models;
using System.Linq;

namespace EM_Report.Controllers
{
    public class AddressBookController : BaseController
    {
        #region private member variables
        private I_AddressBookService _addressService;
        #endregion

        #region public properties
        public I_AddressBookService AddressService
        {
            get { return _addressService; }
            set { _addressService = value; }
        }
        #endregion

        #region constructor
        //
        // GET: /Permission/
        public AddressBookController()
            : base()
        {
            _addressService = new AddressBookService(Base.LoginSession);
        }
        #endregion

        #region private method
        private ActionResult Save(AddressBookModel model)
        {
            if (ModelState.IsValid)
            {
                var isNew = model.Id <= 0;
                model.UserId = Base.LoginSession.intUserId;
               
                try
                {
                    model = AddressService.CreateOrUpdate(model);
                    if (isNew)
                        return RedirectToAction("Index");
                    ShowSuccess(Resource.msgSaveSuccess);
                }
                catch
                {
                    ShowError(Resource.msgUpdateError);
                }

            }
            return View(model);

        }

        private ActionResult Delete(AddressBookModel model)
        {
            try
            {
                AddressService.Delete(model.Id);
                return RedirectToAction("Index");
            }
            catch
            {
                ShowError(Resource.msgDeleteError);
            }
            return View(model);
        }
        #endregion

        #region public methods
        [HttpGet]
        public ActionResult Index(string search_input, string hddSort)
        {
            var list = AddressService.GetAllQueryable(hddSort ?? "FirstName|asc", string.Empty).Where(c => c.UserId == Base.LoginSession.intUserId);
            var pagedList = UpdateViewBag<AddressBookModel>(search_input, hddSort, 1, ResourcesHelper.Report_PageSize, list);
            return View(pagedList);  
        }

        [HttpPost]
        public ActionResult Index(FormCollection postForm, string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            if (hddAction != null && hddAction != string.Empty)
            {
                string[] hddActionSplit = hddAction.Split('|');
                if (hddActionSplit.Length > 0)
                {
                    foreach (var item in hddActionSplit[1].Split(','))
                    {
                        //model = AddressService.GetById(long.Parse(item));
                        AddressService.Delete(long.Parse(item));
                    }
                }
            }

            var pagesize = int.Parse(Request.Form["cboDisplayEntry"]);
            hddSort = string.IsNullOrEmpty(hddSort) ? "FirstName|asc" : hddSort;
            var list = AddressService.GetAllQueryable(hddSort, search_input).Where(c => c.UserId == Base.LoginSession.intUserId);
            var pagedList = UpdateViewBag<AddressBookModel>(search_input, hddSort, hddPaging, pagesize, list);
            return View(pagedList);
        }

        [HttpGet]
        public ActionResult Details(int? id, string hddSort)
        {
            var model = new AddressBookModel();
            if (!id.HasValue)
                return View(model);

            try
            {
                model = AddressService.GetById(id.Value);
            }
            catch (Exception)
            {
                ShowError(Resource.msgLoadError);
            }
            return View(model);
        }

        [HttpPost]
        public ActionResult Details(AddressBookModel model, string hddAction, string hddSort, int? hddPaging = 1)
        {
            switch (Request.Form["action"].ToLower())
            {
                case "save":
                    return Save(model);
                case "delete":
                    return Delete(model);
                default:
                    break;

            }
            return View();
        }

        [HttpPost]
        public ActionResult AllContacts(FormCollection postForm, string search_input)
        {
            var list = AddressService.GetAllQueryable("FirstName|asc", search_input).Where(c => c.UserId == Base.LoginSession.intUserId);
            return View(list.ToList());  
        }
        #endregion
    }
}
