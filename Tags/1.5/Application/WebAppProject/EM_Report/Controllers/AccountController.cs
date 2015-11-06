using EM_Report.ActionServiceReference;
using EM_Report.Common.Utilities;
using EM_Report.Domain;
using EM_Report.Domain.Enums;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Repositories;
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

        public ActionResult LogIn()
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
                    if (Base.LoginSession.strUserName != null)
                    {
                        var model = new LogIn
                        {
                            Username = Base.LoginSession.strUserName,
                            Email = Base.LoginSession.strEmail,
                            Password = Base.LoginSession.strPassWord
                        };

                        var response = Login.Authenticate(model);
                        if (response != null && response.returnValue > 0)
                        {
                            Login.LoginAction(response, Base.LoginSession.isRememberme);
                            returnValue = true;
                        }
                    }
                    else
                    {
                        returnValue = false;
                    }
                }
                else
                {
                    HttpCookie userInfo = Request.Cookies[Constants.STR_UserInfoSecurity];
                    if (userInfo == null)
                        returnValue = false;
                    else
                    {
                        string[] values = userInfo.Value.Split('|');
                        if (values.Length != 3)
                        {
                            returnValue = false;
                        }
                        else
                        {
                            var response = Login.Authenticate(values);
                            if (response == null || response.returnValue <= 0)
                            {
                                returnValue = false;
                            }
                            else
                            {
                                Login.LoginAction(response, true);
                                returnValue = true;
                            }
                        }
                    }
                }

                if (returnValue)
                {
                    return Redirect(Login.GetLandingPageUrl());
                }
            }

            return View();
        }

        [HttpPost]
        public ActionResult LogIn(LogIn model, string returnUrl)
        {
            var response = Login.Authenticate(model);
            if (response != null)
            {
                if (response.Acknowledge == AcknowledgeType.Success)
                {
                    Login.LoginAction(response, model.Is_RememberMe);

                    // we do not store domain account password in db, so we have to add cookie and password session here
                    Base.LoginSession.strPassWord = EnCryption.Encrypt(model.Password);
                    if (model.Is_RememberMe && Base.LoginType == LoginType.Internal)
                    {
                        Login.AddLoginCookie(response.User.UserId, model.Username, EnCryption.Encrypt(model.Password));                        
                    }
                        
                    return Redirect(Login.GetLandingPageUrl());
                }
                else
                {
                    var errorMessage = Login.GetInvalidLoginErrorMessage(Base.LoginType);

                    if (response.returnValue == -2)
                    {
                        errorMessage = Resource.msgBlockedLogin;
                    }

                    ModelState.AddModelError("Error", errorMessage);
                }
            }
            else
            {
                var errorMessage = Login.GetInvalidLoginErrorMessage(Base.LoginType);
                ModelState.AddModelError("Error", errorMessage);
            }

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

            if (AccountRepository.ChangePassword(Base.LoginSession.intUserId, EnCryption.Encrypt(model.OldPassword), EnCryption.Encrypt(model.NewPassword)))
            {
                return RedirectToAction("changepasswordsuccess");
            }
            else
            {
                ModelState.AddModelError("Error", Resource.msgInvalidCurrentPassword);
            }
            ViewBag.OldPassword = model.OldPassword;
            ViewBag.NewPassword = model.NewPassword;

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

        public ActionResult ResetPassword()
        {
            return View();
        }

        [HttpPost]
        public ActionResult ResetPassword(ResetPassword model)
        {
            if (!ModelState.IsValid)
                return View(model);

            string NewPassword = Base.CreateRandomPassword(6);
            int resetPasswordSucceeded = AccountRepository.ResetPassword(model.strUserNameOrEmail, NewPassword);

            if (resetPasswordSucceeded <= 0)
            {
                ModelState.AddModelError("Error", Resource.msgInvalidUserNameOrEmail);
            }
            else
            {
                var usermodel = UserRepository.Get(resetPasswordSucceeded);
                if (usermodel != null)
                {
                    return RedirectToAction("resetpasswordsuccess");
                }
                ModelState.AddModelError("Error", Resource.msgSendMailError);
            }
            // If we got this far, something failed, redisplay form
            return View(model);
        }

        public ActionResult ResetPasswordSuccess()
        {
            return View();
        }
    }
}