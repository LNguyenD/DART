using System.Configuration;
using System.Web.Mvc;
using System.Web.Security;
using System.Collections.Generic;
using EM_Report.BLL.Commons;
using EM_Report.BLL.Resources;
using EM_Report.BLL.Services;
using EM_Report.Helpers;
using EM_Report.Models;
using System.Web;

namespace EM_Report.Controllers
{
    public class AccountController : Controller
    {
        private I_AccountService _qAccountService;
        private I_UserService _qUserService;

        public ActionResult Index()
        {
            return RedirectToAction("/login");
        }
        
        public ActionResult LogIn()
        {
            Login.InitLogin();
            return View();
        }

        //
        // POST: /Account/LogIn

        public AccountController()
            : base()
        {
            var session = Base.LoginSession;
            _qUserService = new UserService(session);
            _qAccountService = new AccountService(session);

        }

        [HttpPost]
        public ActionResult LogIn(LogInModel model, string returnUrl)
        {
            if (!ModelState.IsValid)
                return View(model);

            int login = (int)_qAccountService.Login(model.UserName, CryptMD5.EncryptMD5WithSalt(model.Password, ConfigurationManager.AppSettings["PassWordSalt"]));

            if (login > 0)
            {
                Login.LoginAction(login, model.Is_RememberMe);

                if (Login.AuthorizeSystemPermission(int.Parse(EM_Report.BLL.Resources.Control.System_User), int.Parse(EM_Report.BLL.Resources.Control.Permission_View)))
                {
                    return RedirectToAction("Index", "user");
                }
                return RedirectToAction("Index", "report");
            }
            if (login == -1)
            {
                ModelState.AddModelError("Error", string.Format(Resource.msgInvalidUserNameOrPassLogin, ConfigurationManager.AppSettings["No_Limit_Login_Attempts"]));
                Login.CacheBlockLogin(model.UserName);
            }
            else if (login == -2)
            {
                ModelState.AddModelError("Error", string.Format(Resource.msgBlockedLogin, ConfigurationManager.AppSettings["No_Days_Blocked_Attempts"]));
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
        public ActionResult ChangePassword(ChangePasswordModel model)
        {
            if (!ModelState.IsValid)
                return View(model);

            // ChangePassword will throw an exception rather
            // than return false in certain failure scenarios.
            if (Base.LoginSession == null)
                return RedirectToAction("login");

            bool changePasswordSucceeded = _qAccountService.ChangePassword(Base.LoginSession.intUserId, CryptMD5.EncryptMD5WithSalt(model.OldPassword, ConfigurationManager.AppSettings["PassWordSalt"]), CryptMD5.EncryptMD5WithSalt(model.NewPassword, ConfigurationManager.AppSettings["PassWordSalt"]));
            if (changePasswordSucceeded)
            {
                return RedirectToAction("changepasswordsuccess");
            }
            ViewBag.OldPassword = model.OldPassword;
            ViewBag.NewPassword = model.NewPassword;
            ModelState.AddModelError("Error", Resource.msgInvalidCurrentPassword);

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
        public ActionResult ResetPassword(ResetPasswordModel model)
        {
            if (!ModelState.IsValid)
                return View(model);

            string NewPassword = Base.CreateRandomPassword(6);
            int resetPasswordSucceeded = _qAccountService.ResetPassword(model.strUserNameOrEmail, CryptMD5.EncryptMD5WithSalt(NewPassword, ConfigurationManager.AppSettings["PassWordSalt"]));

            if (resetPasswordSucceeded <= 0)
            {
                ModelState.AddModelError("Error", Resource.msgInvalidUserNameOrEmail);
            }
            else
            {
                var usermodel = _qUserService.GetById(resetPasswordSucceeded);
                string mailbody = ConfigurationManager.AppSettings["MailResetPasswordBody"];
                mailbody = mailbody.Replace("[FullName]", usermodel.FirstName + " " + usermodel.LastName);
                mailbody = mailbody.Replace("[NewPassWord]", NewPassword);
                mailbody = mailbody.Replace("[UserName]", usermodel.UserName);
                if (usermodel != null && Base.SendMail(usermodel.Email, ConfigurationManager.AppSettings["MailResetPasswordSubject"], mailbody))
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

        public ActionResult AccessDenied()
        {            
            return View();
        }

        #region Status Codes
        private static string ErrorCodeToString(MembershipCreateStatus createStatus)
        {
            // See http://go.microsoft.com/fwlink/?LinkID=177550 for
            // a full list of status codes.
            switch (createStatus)
            {
                case MembershipCreateStatus.DuplicateUserName:
                    return "User name already exists. Please enter a different user name.";

                case MembershipCreateStatus.DuplicateEmail:
                    return "A user name for that e-mail address already exists. Please enter a different e-mail address.";

                case MembershipCreateStatus.InvalidPassword:
                    return "The password provided is invalid. Please enter a valid password value.";

                case MembershipCreateStatus.InvalidEmail:
                    return "The e-mail address provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.InvalidAnswer:
                    return "The password retrieval answer provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.InvalidQuestion:
                    return "The password retrieval question provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.InvalidUserName:
                    return "The user name provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.ProviderError:
                    return "The authentication provider returned an error. Please verify your entry and try again. If the problem persists, please contact your system administrator.";

                case MembershipCreateStatus.UserRejected:
                    return "The user creation request has been canceled. Please verify your entry and try again. If the problem persists, please contact your system administrator.";

                default:
                    return "An unknown error occurred. Please verify your entry and try again. If the problem persists, please contact your system administrator.";
            }
        }
        #endregion        
    }
}
