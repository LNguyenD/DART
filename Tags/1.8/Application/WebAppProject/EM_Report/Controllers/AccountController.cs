
using EM_Report.Common.Utilities;
using EM_Report.Domain;
using EM_Report.Domain.Enums;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Repositories;
using EM_Report.Service.MessageBase;
using System.Collections.Generic;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace EM_Report.Controllers
{
    public class AccountController : BaseController
    {
        /// <summary>
        /// Default Constructor for AccountController.
        /// </summary>
        public AccountController()
            : base()
        {
        }

        public ActionResult Index()
        {
            return RedirectToAction("/login");
        }

        public ActionResult LogIn(string returnUrl)
        {
            if (Request.IsAjaxRequest())
            {
                return new HttpStatusCodeResult(403);
            }
            if (Request["ssrs"] != null && Request["ssrs"].ToLower() == "lost")
            {
                HttpContext.Application["RS2010"] = null;
            }
            if (Request["logout"] != null && Request["logout"].ToLower() == "true")
            {
                Login.DoLogout();
            }
            else
            {
                bool returnValue = false;

                if (Base.LoginSession != null)
                {
                    returnValue = Login.AutoLoginSession();
                }
                else
                {
                    returnValue = Login.AutoLoginCookie();
                }

                if (returnValue)
                {
                    var redirectToUrl = (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl)) ? returnUrl : Login.GetLandingPageUrl();
                    return Redirect(redirectToUrl);
                }
            }

            FormViewBag();

            return View();
        }

        [HttpPost]
        public ActionResult LogIn(LogIn model, string returnUrl)
        {
            var domain = Request["cboDomain"];
            var response = Login.Authenticate(0, model, domain);
            if (response != null && response.UserExt.UserId > 0 && response.UserExt.Status ==1)
            {
                Login.LoginAction(response, model.Password, model.Is_RememberMe, domain);
                return Redirect(Login.GetLandingPageUrl());
            }
            else if (response != null && response.UserExt.UserId > 0 && response.UserExt.Status ==2)
            {
                ModelState.AddModelError("Error", Resource.msgBlockedLogin);
            }
            else
            {
                var errorMessage = Login.GetInvalidLoginErrorMessage(Base.LoginType);
                ModelState.AddModelError("Error", errorMessage);
            }

            FormViewBag();
            return View(model);
        }
        public ActionResult LoginSSO(string returnUrl)
        {
            if (Request.IsAjaxRequest())
            {
                return new HttpStatusCodeResult(403);
            }
            if (Request["ssrs"] != null && Request["ssrs"].ToLower() == "lost")
            {
                HttpContext.Application["RS2010"] = null;
            }
            if (Request["logout"] != null && Request["logout"].ToLower() == "true")
            {
                Login.DoLogout();
            }
            else
            {
                bool returnValue = false;
                if (Base.LoginSession != null)
                {
                    returnValue = Login.AutoLoginSession();
                }
                else
                {
                    returnValue = Login.AutoLoginCookie();
                }
                if (returnValue)
                {
                    var redirectToUrl = (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl)) ? returnUrl : Login.GetLandingPageUrl();
                    return Redirect(redirectToUrl);
                }
            }

            return View();
        }

        [HttpPost]
        public ActionResult LoginSSO(LoginSSO model, string returnUrl)
        {
            var domain = Request["cboDomain"];
            EM_Report.Domain.LogIn loginmodel = new EM_Report.Domain.LogIn();
            loginmodel.Email = model.Email;
            loginmodel.Password = model.Password;
            loginmodel.Is_RememberMe = false;
            loginmodel.Username = null;

            var response = Login.Authenticate(0, loginmodel, domain);
            if (response != null && response.UserExt.UserId > 0 && response.UserExt.Status == 1)
            {
                Login.LoginAction(response, loginmodel.Password, loginmodel.Is_RememberMe, domain);
                return Redirect(Login.GetLandingPageUrl());
            }
            else if (response != null && response.UserExt.UserId > 0 && response.UserExt.Status == 2)
            {
                ModelState.AddModelError("Error", Resource.msgBlockedLogin);
            }
            else
            {
                var errorMessage = Login.GetInvalidLoginErrorMessage(Base.LoginType);
                ModelState.AddModelError("Error", errorMessage);
            }

            FormViewBag();
            return View(model);
        }

        //
        // GET: /Account/LogOff

        public ActionResult LogOff()
        {
            FormsAuthentication.SignOut();

            return RedirectToAction("Index", "report");
        }

        //
        // GET: /Account/ChangePassword

        public ActionResult ChangePassword()
        {
            Login.AuthorizeLogin();
            return View();
        }

        //
        // POST: /Account/ChangePassword

        [HttpPost]
        public ActionResult ChangePassword(ChangePassword model)
        {
            if (!ModelState.IsValid)
                return View(model);

            // ChangePassword will throw an exception rather
            // than return false in certain failure scenarios.
            if (Base.LoginSession == null)
                return RedirectToAction("login");

            if (AccountRepository.ChangePassword(Base.LoginSession.intUserId, EnCryption.HashUserPassword(Base.LoginSession.strUserName, model.OldPassword), EnCryption.HashUserPassword(Base.LoginSession.strUserName, model.NewPassword)))
            {
                return RedirectToAction("changepasswordsuccess");
            }
            else
            {
                ModelState.AddModelError("Error", Resource.msgInvalidCurrentPassword);
            }
            ViewBag.OldPassword = model.OldPassword;
            ViewBag.NewPassword = model.NewPassword;
            ViewBag.ConfirmPassword = model.ConfirmPassword;

            // If we got this far, something failed, redisplay form
            return View(model);
        }

        //
        // GET: /Account/ChangePasswordSuccess

        public ActionResult ChangePasswordSuccess()
        {
            Login.AuthorizeLogin();
            return View();
        }

        public ActionResult RequestResetPassword(string errormessage)
        {
            var redirecterror = errormessage;
            if (redirecterror != null)
            {
                ModelState.AddModelError("Error", redirecterror);
            }
            return View();
        }

        [HttpPost]
        public ActionResult RequestResetPassword(RequestResetPassword model)
        {
            if (!ModelState.IsValid)
                return View(model);

            int resetPasswordRequestSucceeded = AccountRepository.RequestResetPassword(model.strEmail);

            if (resetPasswordRequestSucceeded == 1)
            {
                return RedirectToAction("RequestResetPasswordConfirmation");
            }
            else
            {
                ModelState.AddModelError("Error", Resource.msgInvalidEmail);
            }
            ModelState.AddModelError("Error", Resource.msgSendMailError);
            return View(model);
        }

        public ActionResult RequestResetPasswordConfirmation()
        {
            return View();
        }

        public ActionResult VerifyResetPassword(string email, string securecheck)
        {
            //replacing " " with "+" due to URL mappped parameters
            securecheck = securecheck.Replace(" ", "+");
            int intUserID = AccountRepository.VerifyResetPassword(email, securecheck);
            if (intUserID <= 0)
            {
                return RedirectToAction("RequestResetPassword", new { errormessage = Resource.msgInvalidUrlVerification });
            }
            else
            {
                TempData["Email"] = email;
                TempData["CurrentPassword"] = securecheck ?? "";
                return RedirectToAction("ResetPassword");
            }
        }

        public ActionResult ResetPassword()
        {
            var model = new ResetPassword
            {
                strEmail = (string)TempData["Email"],
                OldPassword = (string)TempData["CurrentPassword"]
            };
            return View(model);
        }

        [HttpPost]
        public ActionResult ResetPassword(ResetPassword model)
        {
            if (!ModelState.IsValid)
            {
                ModelState.AddModelError("Error", Resource.msgInvalidResetPasswordRequest);
                return View(model);
            }
            int intUserID = AccountRepository.ResetPassword(model.strEmail, model.OldPassword, model.NewPassword);
            if (intUserID <= 0)
            {
                ModelState.AddModelError("Error", Resource.msgInvalidResetPasswordRequest);
            }
            else
            {
                return RedirectToAction("ResetPasswordSuccess");
            }
            return View(model);
        }


        public ActionResult ResetPasswordSuccess()
        {
            return View();
        }
        private void FormViewBag()
        {
            if (Base.LoginType == LoginType.Internal)
            {
                var domainList = Base.GetConfig("DomainList");
                var domainDictionary = new Dictionary<string, string>();
                string selectedItem = null;
                domainList.Split(',').ForEach(d =>
                {
                    d = d.Trim();
                    domainDictionary.Add(d, d);
                    if (Request["cboDomain"] == d)
                    {
                        selectedItem = d;
                    }
                });

                ViewBag.cboDomainList = new SelectList(domainDictionary, "Value", "Key", selectedItem);
            }
        }
    }
}