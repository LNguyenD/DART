using System;
using System.Collections.Generic;
using System.Configuration;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.Models;


namespace EM_Report.BLL.Services
{
    public interface I_AccountService
    {        
        int Login(string username, string password);
        int AutoLogin(int userid, string usernamecookie, string passwordcookie);
        int Register(string username, string password, string email, string firstname, string lastname, string address, int status);
        bool ChangePassword(int userid, string oldpassword, string newpassword);
        int ResetPassword(string usernamoremail, string passwordreset);
    }

    public class AccountService : ServiceBase<UserModel, User>, I_AccountService
    {
        public AccountService(I_LoginSession session) : base(session) { }

        public int Login(string username, string password)
        {
            Dictionary<string, object> dicParams = new Dictionary<string, object>();
            dicParams.Add("@UserName", username);
            dicParams.Add("@PassWord", password);
            return int.Parse(Repository.ExecuteScalarStoreProcedure("dbo.PRO_Login", dicParams).ToString());     
        }

        public int AutoLogin(int userid, string usernamecookie, string passwordcookie)
        {
            var UserInfo = Repository.GetByPK(userid);
            if (UserInfo != null && UserInfo.Password == passwordcookie && Commons.CryptMD5.EncryptMD5WithSalt(UserInfo.UserName, ConfigurationManager.AppSettings["PassWordSalt"]) == usernamecookie)
                return Login(UserInfo.UserName, UserInfo.Password);
            else
                return Login("12345678910ABCD", "12345678910ABCD"); 
        } 

        public int Register(string username, string password, string email, string firstname, string lastname, string address, int status)
        {
            Dictionary<string, object> dicParams = new Dictionary<string, object>();
            dicParams.Add("@UserName", username);
            dicParams.Add("@PassWord", password);
            dicParams.Add("@Email", email??string.Empty);
            dicParams.Add("@FirstName", firstname??string.Empty);
            dicParams.Add("@LastName", lastname??string.Empty);
            dicParams.Add("@Address", address??string.Empty);
            dicParams.Add("@i_Status", status);
            return int.Parse(Repository.ExecuteScalarStoreProcedure("PRO_Register", dicParams).ToString());  
        }

        public bool ChangePassword(int userid,string oldpassword,string newpassword)
        {
            var UserInfo = Repository.GetByPK(userid);
            
            try
            {
                if (UserInfo != null && UserInfo.Password == oldpassword)
                {
                    UserInfo.Password = newpassword;
                    Repository.Update(UserInfo, UserInfo.UserId);
                    return true;
                }
                else
                {
                    return false;
                }
            }

            catch (Exception)
            {
                return false;
            }
        }

        public int ResetPassword(string usernamoremail, string passwordreset)
        {
            Dictionary<string, object> dicParams = new Dictionary<string, object>();
            dicParams.Add("@UserNameOrEmail", usernamoremail);
            dicParams.Add("@PassWordReset", passwordreset);
            return int.Parse(Repository.ExecuteScalarStoreProcedure("PRO_ResetPassword", dicParams).ToString());          
        }        
    }
}
