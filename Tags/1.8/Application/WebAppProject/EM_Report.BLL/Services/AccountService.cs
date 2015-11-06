using System;
using System.Collections.Generic;
using System.Configuration;
using EM_Report.Common.Utilities;
using EM_Report.DAL;
using EM_Report.Domain;
using EM_Report.Domain.Enums;
using EM_Report.DAL.Infrastructure;
using System.Data.SqlClient;
using System.Data;


namespace EM_Report.BLL.Services
{
    public interface I_AccountService
    {
        User_Ext Login(int UserId, string usernameoremail, string password, int limitLoginAttemptsNumber, int daysBlockedAttemptsNumber, LoginType loginType);        
        bool ChangePassword(int userid, string oldpassword, string newpassword);
        int ResetPassword(string securecheck, string verifysecurecheck, bool isexternaluser, string usernamoremail, string passwordreset);

        int VerifyURLResetPassword(string securecheck, string verifysecurecheck, bool isexternaluser);
    }

    public class AccountService : ServiceBase<User, UserDO>, I_AccountService
    {
        public AccountService(I_LoginSession session) : base(session) { }

        public AccountService(I_Repository<UserDO> repo, I_LoginSession session) : base(repo, session) { }

        public User_Ext Login(int userId, string usernameoremail, string password, int limitLoginAttemptsNumber, int daysBlockedAttemptsNumber, LoginType loginType)
        {
            I_UserService UserService = new UserService(null);
            var userExt = UserService.GetUserExtInfo(usernameoremail);
            
            if (userId <= 0 && userExt.UserId > 0 && userExt.Is_External_User && userExt.Password == EnCryption.HashUserPassword(userExt.UserName, password)
                && userExt.Online_Locked_Until_Datetime != null && DateTime.Now > userExt.Online_Locked_Until_Datetime) // unlock external user
            {
                UnlockUser(userExt, limitLoginAttemptsNumber, daysBlockedAttemptsNumber);                      
            }
            else if (userId <= 0 && userExt.UserId > 0 && userExt.Is_External_User && userExt.Password != EnCryption.HashUserPassword(userExt.UserName, password)) // increase attempt time when fail
            {
                Adjust_Fail_Attempt_Login(userExt, limitLoginAttemptsNumber, daysBlockedAttemptsNumber);               
            }
            if (!userExt.Is_External_User || (userExt.Is_External_User && ((userId > 0 && password == userExt.Password) || (userId <= 0 && EnCryption.HashUserPassword(userExt.UserName, password) == userExt.Password))))
                return userExt;
            else
                return new User_Ext() { };
        }      

        public bool ChangePassword(int userid, string oldpassword, string newpassword)
        {
            I_UserService UserService = new UserService(null);
            var UserInfo = UserService.GetUserById(userid);

            try
            {
                if (UserInfo != null && oldpassword != newpassword && UserInfo.Password == oldpassword)
                {
                    UserInfo.Password = newpassword;
                    UserService.UpdateUser(UserInfo);
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

        public int ResetPassword(string securecheck, string verifysecurecheck, bool isexternaluser, string usernamoremail, string passwordreset)
        {
            if (securecheck == verifysecurecheck && isexternaluser == true)
            {
                Dictionary<string, object> dicParams = new Dictionary<string, object>();
                dicParams.Add("@UserNameOrEmail", usernamoremail);
                dicParams.Add("@PassWordReset", passwordreset);
                return int.Parse(Repository.ExecuteScalarStoreProcedure("PRO_ResetPassword", dicParams).ToString());
            }
            else
                return 0;
        }

        public int VerifyURLResetPassword (string securecheck, string verifysecurecheck, bool isexternaluser)
        {
            if (securecheck == verifysecurecheck && isexternaluser == true)
                return 1;
            else
                return 0;
        }

        private void UnlockUser(User_Ext userExt, int limitLoginAttemptsNumber, int daysBlockedAttemptsNumber)
        {
            var storeParams = new Dictionary<string, object>();
            storeParams.Add("UserId", userExt.UserId);
            storeParams.Add("Type", "Unlock");
            storeParams.Add("NoLimitLoginAttempts", limitLoginAttemptsNumber);
            storeParams.Add("NoDaysBlockedAttempts", daysBlockedAttemptsNumber);
            Repository.ExecuteDataStoreProcedure("usp_Adjust_Attempt_Login", storeParams);
        }

        private void Adjust_Fail_Attempt_Login(User_Ext userExt, int limitLoginAttemptsNumber, int daysBlockedAttemptsNumber)
        {
            var storeParams = new Dictionary<string, object>();
            storeParams.Add("UserId", userExt.UserId);
            storeParams.Add("Type", "");
            storeParams.Add("NoLimitLoginAttempts", limitLoginAttemptsNumber);
            storeParams.Add("NoDaysBlockedAttempts", daysBlockedAttemptsNumber);
            Repository.ExecuteDataStoreProcedure("usp_Adjust_Attempt_Login", storeParams);   
        }
    }
}
