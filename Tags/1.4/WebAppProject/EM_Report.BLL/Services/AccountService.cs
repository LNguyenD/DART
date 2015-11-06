using System;
using System.Collections.Generic;
using System.Configuration;
using EM_Report.Common.Utilities;
using EM_Report.DAL;
using EM_Report.Domain;
using EM_Report.Domain.Enums;
using EM_Report.DAL.Infrastructure;


namespace EM_Report.BLL.Services
{
    public interface I_AccountService
    {
        int Login(string username, string password, int limitLoginAttemptsNumber, int daysBlockedAttemptsNumber, int systemid, LoginType loginType);
        int AutoLogin(int userId, string usernameCookie, string passwordCookie, int limitLoginAttemptsNumber, int daysBlockedAttemptsNumber, int systemid, LoginType loginType);
        bool ChangePassword(int userid, string oldpassword, string newpassword);
        int ResetPassword(string usernamoremail, string passwordreset);
    }

    public class AccountService : ServiceBase<User, UserDO>, I_AccountService
    {
        public AccountService(I_LoginSession session) : base(session) { }

        public AccountService(I_Repository<UserDO> repo, I_LoginSession session) : base(repo, session) { }

        public int Login(string username, string password, int limitLoginAttemptsNumber, int daysBlockedAttemptsNumber, int systemid, LoginType loginType)
        {
            Dictionary<string, object> dicParams = new Dictionary<string, object>();
            dicParams.Add("@NoLimitLoginAttempts", limitLoginAttemptsNumber);
            dicParams.Add("@NoDaysBlockedAttempts", daysBlockedAttemptsNumber);
            dicParams.Add("@SystemId", systemid);

            switch (loginType)
            {
                case LoginType.Internal:
                    dicParams.Add("@Username", username);
                    return int.Parse(Repository.ExecuteScalarStoreProcedure("dbo.PRO_Internal_Login", dicParams).ToString());
                case LoginType.External:
                    dicParams.Add("@Email", username);
                    dicParams.Add("@PassWord", password);
                    return int.Parse(Repository.ExecuteScalarStoreProcedure("dbo.PRO_Login", dicParams).ToString());
                default:
                    return 0;
            }            
        }

        public int AutoLogin(int userId, string usernameCookie, string passwordCookie, int limitLoginAttemptsNumber, int daysBlockedAttemptsNumber, int systemid, LoginType loginType)
        {
            var result = 0;

            var userInfo = Repository.GetByPK(userId);
            if (userInfo != null)
            {
                switch (loginType)
                {
                    case LoginType.Internal:
                        if (userInfo.UserName == usernameCookie)
                            result = Login(usernameCookie, null, limitLoginAttemptsNumber, daysBlockedAttemptsNumber, systemid, loginType);
                        break;
                    case LoginType.External:
                        if (userInfo.Password == passwordCookie && userInfo.Email == usernameCookie)
                            result = Login(usernameCookie, passwordCookie, limitLoginAttemptsNumber, daysBlockedAttemptsNumber, systemid, loginType);
                        break;
                }
            }

            return result;
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

        public int ResetPassword(string usernamoremail, string passwordreset)
        {
            Dictionary<string, object> dicParams = new Dictionary<string, object>();
            dicParams.Add("@UserNameOrEmail", usernamoremail);
            dicParams.Add("@PassWordReset", passwordreset);
            return int.Parse(Repository.ExecuteScalarStoreProcedure("PRO_ResetPassword", dicParams).ToString());
        }
    }
}
