using EM_Report.ActionServiceReference;
using EM_Report.Domain.Enums;

namespace EM_Report.Repositories
{
    /// <summary>
    /// Authentication Repository interface.
    /// Note: does not derive from IRepository.
    /// </summary>
    public interface IAccountRepository
    {
        string GetToken();
        LoginResponse Login(string username, string password, int systemid, LoginType loginType);
        LoginResponse AutoLogin(int userid, string usernamecookie, string passwordcookie, int systemid, LoginType loginType); 
        bool Logout();
        bool ChangePassword(int userid, string oldpassword, string newpassword);
        int ResetPassword(string usernameoremail, string password);
    }
    
    /// <summary>
    /// Authentication Repository class.
    /// Note: this repository class is different from others (i.e. no CRUD operations) 
    /// and therefore does not need to implement IRepository<T> (like all other repositories).
    /// </summary>
    public class AccountRepository : RepositoryBase, IAccountRepository
    {
        /// <summary>
        /// GetToken must be the first call into web service. 
        /// It establishes a session on the server and retrieves a newly created accesstoken.
        /// </summary>
        /// <returns>Unique access token that is valid for the duration of the session.</returns>
        public string GetToken()
        {
            var request = new TokenRequest();
            request.RequestId = RequestHelper.RequestId;
            request.ClientTag = RequestHelper.ClientTag;

            var response = Client.GetToken(request);            

            Correlate(request, response);
           
            return response.AccessToken;
        }

        /// <summary>
        /// Login to the system.
        /// </summary>
        /// <param name="username">Email for external users, Domain name for internal users</param>
        /// <param name="password">Password.</param>
        /// <returns>Success or failure flag.</returns>
        public LoginResponse Login(string username, string password, int systemid, LoginType loginType)
        {
            var request = new LoginRequest().Prepare();
            request.UserName = username;
            request.LoginType = loginType;
            request.Password = password;            
            request.SystemId = systemid;
            var response = Client.Login(request);

            Correlate(request, response);

            return response;
        }

        /// <summary>
        /// Login to the system.
        /// </summary>
        /// <param name="username">Email for external users, Domain name for internal users</param>
        /// <param name="password">Password.</param>
        /// <returns>Success or failure flag.</returns>
        public LoginResponse AutoLogin(int userid, string usernameCookie, string passwordcookie, int systemid, LoginType loginType)
        {
            var request = new LoginRequest().Prepare();

            request.LoginType = loginType;
            request.UserId = userid;
            request.UserName = usernameCookie;
            request.Password = passwordcookie;           
            request.SystemId = systemid;

            var response = Client.AutoLogin(request);

            Correlate(request, response);

            return response;
        }

        /// <summary>
        /// Logout from from the system.
        /// </summary>
        /// <returns>Success or failure flag.</returns>
        public bool Logout()
        {
            var request = new LogoutRequest().Prepare();
            var response = Client.Logout(request);

            Correlate(request, response);

            return response.Acknowledge == AcknowledgeType.Success;
        }

        /// <summary>
        /// Change password of user.
        /// </summary>
        /// <returns>Success or failure flag.</returns>
        public bool ChangePassword(int userid,string oldpassword,string newpassword)
        {
            var request = new ChangePasswordRequest().Prepare();
            request.UserId = userid;
            request.OldPassword = oldpassword;
            request.NewPassword = newpassword;
            
            var response = Client.ChangePassword(request);

            Correlate(request, response);

            return response.returnValue;           
        }

        public int ResetPassword(string usernameoremail,string password)
        {
            var request = new ResetPasswordRequest().Prepare();
            request.UserName_Email = usernameoremail;
            request.Password = password;            

            var response = Client.ResetPassword(request);

            Correlate(request, response);

            return response.returnValue;       
        }
    }
}