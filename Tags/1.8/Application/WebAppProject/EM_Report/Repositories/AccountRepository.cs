
using EM_Report.Domain.Enums;
using EM_Report.Helpers;
using System.ServiceModel;
using EM_Report.Service.Messages;
using EM_Report.Service.Criteria;
using EM_Report.Service.ServiceContracts;
using EM_Report.Service.MessageBase;
using EM_Report.Domain.Resources;
using System.Configuration;

namespace EM_Report.Repositories
{
    /// <summary>
    /// Authentication Repository interface.
    /// Note: does not derive from IRepository.
    /// </summary>
    public interface IAccountRepository
    {
        LoginResponse Login(int userid, string username, string password, LoginType loginType);
        bool Logout();
        bool ChangePassword(int userid, string oldpassword, string newpassword);
        int RequestResetPassword(string email);
        int VerifyResetPassword(string email, string oldpassword);
        int ResetPassword(string email, string oldpassword, string newpassword);
    }

    /// <summary>
    /// Authentication Repository class.
    /// Note: this repository class is different from others (i.e. no CRUD operations) 
    /// and therefore does not need to implement IRepository<T> (like all other repositories).
    /// </summary>
    public class AccountRepository : RepositoryBase, IAccountRepository
    {
        /// <summary>
        /// Login to the system.
        /// </summary>
        /// <param name="username">Email for external users, Domain name for internal users</param>
        /// <param name="password">Password.</param>
        /// <returns>Success or failure flag.</returns>
        public LoginResponse Login(int userid, string username, string password, LoginType loginType)
        {
            var request = new LoginRequest();
            request.UserName = username;
            request.LoginType = loginType;
            request.Password = password;
            request.UserId = userid;

            LoginResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.Login(request);
            });

            return response;
        }

        /// <summary>
        /// Logout from from the system.
        /// </summary>
        /// <returns>Success or failure flag.</returns>
        public bool Logout()
        {
            var request = new LogoutRequest().Prepare();

            LogoutResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.Logout(request);
            });


            return response.Acknowledge == AcknowledgeType.Success;
        }

        /// <summary>
        /// Change password of user.
        /// </summary>
        /// <returns>Success or failure flag.</returns>
        public bool ChangePassword(int userid, string oldpassword, string newpassword)
        {
            var request = new ChangePasswordRequest().Prepare();
            request.UserId = userid;
            request.OldPassword = oldpassword;
            request.NewPassword = newpassword;

            ChangePasswordResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.ChangePassword(request);
            });

            return response.returnValue;
        }

        public int RequestResetPassword(string email)
        {
            var request = new ResetPasswordRequest();
            request.Email = email;
            request.ResetPassword_Activation_Url = System.Web.HttpContext.Current.Request.Url.AbsoluteUri;
            request.LoadOptions = new string[] { Resource.Request_Reset_Password };
            ResetPasswordResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.ResetPassword(request);
            });

            return response.returnValue;
        }

        public int VerifyResetPassword(string email, string oldpassword)
        {
            var request = new ResetPasswordRequest();
            request.Email = email;
            request.OldPassword = oldpassword;
            request.LoadOptions = new string[] { Resource.Verify_URL_Reset_Password };
            ResetPasswordResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.ResetPassword(request);
            });
            return response.returnValue;
        }

        public int ResetPassword(string email, string oldpassword, string newpassword)
        {
            var request = new ResetPasswordRequest();
            request.Email = email;
            request.OldPassword = oldpassword;
            request.NewPassword = newpassword;
            request.LoadOptions = new string[] { Resource.Reset_Password };
            ResetPasswordResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.ResetPassword(request);
            });
            return response.returnValue;

        }
    }
}