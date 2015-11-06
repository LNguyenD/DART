using EM_Report.Domain;
using EM_Report.Helpers;
using System;
using System.Linq;
using System.Web.Mvc;

namespace EM_Report.Controllers
{
    public class Dashboard_FavourController : BaseController
    {
        [HttpGet]
        public ActionResult Index(int userId)
        {
            var search = userId.ToString();
            var sort = "FavourId|asc";
            var list = Dashboard_FavourRepository.GetList(search, sort);
            return PartialView("Index", list);
        }

        [HttpPost]
        public ActionResult Index(FormCollection postForm, string favourId, string flag)
        {
            if (postForm["userId"] == Base.LoginSession.intUserId.ToString())
            {
                if (!string.IsNullOrEmpty(favourId) && !string.IsNullOrEmpty(flag))
                {
                    Dashboard_FavourRepository.Delete(int.Parse(favourId));
                }
                var search = postForm["userId"];
                var sort = "FavourId|asc";
                var list = Dashboard_FavourRepository.GetList(search, sort);
                return PartialView("Index", list);
            }
            else
                return RedirectToAction("Error_404");
        }

        [HttpGet]
        public ActionResult Details(string userId)
        {
            if (string.IsNullOrEmpty(userId))
            {
                return PartialView("Details", null);
            }
            else
            {
                var sModel = Dashboard_FavourRepository.GetByUserId(int.Parse(userId));
                var model = sModel;
                return PartialView("Details", model);
            }
        }

        [HttpPost]
        public ActionResult Details(string userId, string favourUrl, string name, string favourId, bool isLoadingPage)
        {
            if (userId == Base.LoginSession.intUserId.ToString())
            {
                var sModelList = Dashboard_FavourRepository.GetList(userId.ToString(), "");

                if (int.Parse(favourId) <= 0)
                {
                    var duplicatedFavour = sModelList.Where(f => f.Url == favourUrl && f.UserId == int.Parse(userId)).FirstOrDefault();

                    //insert if there is no duplicated favour
                    if (duplicatedFavour == null)
                    {
                        var sModel = new Dashboard_Favours();
                        sModel.FavourId = 0;
                        sModel.Name = name;
                        sModel.Url = favourUrl;
                        sModel.UserId = int.Parse(userId);
                        sModel.Create_Date = DateTime.Today;
                        Dashboard_FavourRepository.Insert(sModel);
                    }
                    //update if there is duplicated favour
                    else
                    {
                        duplicatedFavour.Name = name;
                        duplicatedFavour.UpdateBy = int.Parse(userId);
                        Dashboard_FavourRepository.Update(duplicatedFavour, name, int.Parse(userId));
                    }
                }
                else
                {
                    //update selected favour
                    var sModel = Dashboard_FavourRepository.GetById(int.Parse(favourId));
                    sModel.Name = name;
                    sModel.Is_Landing_Page = isLoadingPage;
                    Dashboard_FavourRepository.Update(sModel, name, Base.LoginSession.intUserId);

                    //update isLoadingPage property of other favours
                    if (isLoadingPage != false)
                    {
                        foreach (Dashboard_Favours model in sModelList)
                        {
                            if (model.Name != sModel.Name)
                            {
                                model.Is_Landing_Page = false;
                                Dashboard_FavourRepository.Update(model, model.Name, Base.LoginSession.intUserId);
                            }
                            else if (model.Name == sModel.Name && model.Url != sModel.Url)
                            {
                                model.Is_Landing_Page = false;
                                Dashboard_FavourRepository.Update(model, model.Name, Base.LoginSession.intUserId);
                            }

                        }
                    }
                }

                return PartialView("Details", null);
            }
            else
                return RedirectToAction("Error_404");
        }
    }
}