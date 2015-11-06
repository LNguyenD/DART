using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using NUnit.Framework;
using EM_Report.BLL.Services;
using Moq;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Common.Utilities;
using EM_Report.Domain;
using EM_Report.Domain.Enums;

namespace EM_Report.Tests.Services
{
    [TestFixture]
    public class AccountServiceTests : BaseServiceTests
    {
        private const string username = "test";
        private const string email = "test@test.com";
        private const string password = "6Nx0M207QM8sWqmWWZoiiQ==";
        private const int limitLoginAttemptsNumber = 3;
        private const int daysBlockedAttemptsNumber = 1;
        private const int systemId = 1;
        private Dictionary<string, object> dicParamsForInternalLogin;
        private Dictionary<string, object> dicParamsForExternalLogin;

        [TestFixtureSetUp]
        public void Init()
        {
            dicParamsForExternalLogin = new Dictionary<string, object>();
            dicParamsForExternalLogin.Add("@NoLimitLoginAttempts", limitLoginAttemptsNumber);
            dicParamsForExternalLogin.Add("@NoDaysBlockedAttempts", daysBlockedAttemptsNumber);
            dicParamsForExternalLogin.Add("@SystemId", systemId);
            dicParamsForExternalLogin.Add("@Email", email);
            dicParamsForExternalLogin.Add("@PassWord", password);

            dicParamsForInternalLogin = new Dictionary<string, object>();
            dicParamsForInternalLogin.Add("@NoLimitLoginAttempts", limitLoginAttemptsNumber);
            dicParamsForInternalLogin.Add("@NoDaysBlockedAttempts", daysBlockedAttemptsNumber);
            dicParamsForInternalLogin.Add("@SystemId", systemId);
            dicParamsForInternalLogin.Add("@Username", username);
        }

        //[Test]
        //public void TestExternalLogin_Success()
        //{
        //    // Arrange
        //    var repoMock = new Mock<I_Repository<UserDO>>();
        //    repoMock.Setup(r => r.ExecuteScalarStoreProcedure("dbo.PRO_Login", dicParamsForExternalLogin)).Returns(1);

        //    // Act
        //    var accountService = new AccountService(repoMock.Object, _loginSession);
        //    var result = accountService.Login(0, email, password, limitLoginAttemptsNumber, daysBlockedAttemptsNumber, LoginType.External);

        //    //Assert
        //    Assert.AreEqual(result, 1);
        //}

        //[Test]
        //public void TestExternalLogin_Fail()
        //{
        //    // Arrange
        //    var repoMock = new Mock<I_Repository<UserDO>>();
        //    repoMock.Setup(r => r.ExecuteScalarStoreProcedure("dbo.PRO_Login", dicParamsForExternalLogin)).Returns(-1);

        //    // Act
        //    var accountService = new AccountService(repoMock.Object, _loginSession);
        //    var result = accountService.Login(0, email, password, limitLoginAttemptsNumber, daysBlockedAttemptsNumber, LoginType.External);

        //    //Assert
        //    Assert.IsNotNull(result);
        //    //Assert.Less(result, 0, "Invalid log in UserName and Password. Please try again.");
        //}

        //[Test]
        //public void TestInternalLogin_Success()
        //{
        //    // Arrange
        //    var repoMock = new Mock<I_Repository<UserDO>>();
        //    repoMock.Setup(r => r.ExecuteScalarStoreProcedure("dbo.PRO_Internal_Login", dicParamsForInternalLogin)).Returns(1);

        //    // Act
        //    var accountService = new AccountService(repoMock.Object, _loginSession);
        //    var result = accountService.Login(0, username, null, limitLoginAttemptsNumber, daysBlockedAttemptsNumber, LoginType.Internal);

        //    //Assert
        //    Assert.AreEqual(result, 1);
        //}

        //[Test]
        //public void TestInternalLogin_Fail()
        //{
        //    // Arrange
        //    var repoMock = new Mock<I_Repository<UserDO>>();
        //    repoMock.Setup(r => r.ExecuteScalarStoreProcedure("dbo.PRO_Internal_Login", dicParamsForInternalLogin)).Returns(-1);

        //    // Act
        //    var accountService = new AccountService(repoMock.Object, _loginSession);
        //    var result = accountService.Login(0, username, null, limitLoginAttemptsNumber, daysBlockedAttemptsNumber, LoginType.Internal);

        //    //Assert
        //    Assert.AreEqual(result, -1);
        //}

        //[Test]
        //public void InternalAutoLogin_Success()
        //{
        //    // Arrange
        //    var user = new UserDO { UserId = 1, UserName = "test" };

        //    var userRepoMock = new Moq.Mock<I_Repository<UserDO>>();
        //    userRepoMock.Setup(r => r.GetByPK(1)).Returns(user);
        //    userRepoMock.Setup(r => r.ExecuteScalarStoreProcedure("dbo.PRO_Internal_Login", dicParamsForInternalLogin)).Returns(1);

        //    // Act
        //    var accountService = new AccountService(userRepoMock.Object, _loginSession);
        //    var result = accountService.Login(1, "test", null, limitLoginAttemptsNumber, daysBlockedAttemptsNumber, LoginType.Internal);

        //    // Assert
        //    Assert.AreEqual(1, result);
        //}

        //[Test]
        //public void InternalAutoLogin_Fail()
        //{
        //    // Arrange
        //    var user = new UserDO { UserId = 1, UserName = "test" };

        //    var userRepoMock = new Moq.Mock<I_Repository<UserDO>>();
        //    userRepoMock.Setup(r => r.GetByPK(1)).Returns(user);
        //    userRepoMock.Setup(r => r.ExecuteScalarStoreProcedure("dbo.PRO_Internal_Login", dicParamsForInternalLogin)).Returns(-1);

        //    // Act
        //    var accountService = new AccountService(userRepoMock.Object, _loginSession);
        //    var result = accountService.Login(1, "test", null, limitLoginAttemptsNumber, daysBlockedAttemptsNumber, LoginType.Internal);

        //    // Assert
        //    Assert.AreEqual(-1, result);
        //}

        //[Test]
        //public void ExternalAutoLogin_Success()
        //{
        //    // Arrange
        //    var user = new UserDO { UserId = 1, Email = email, Password = password };

        //    var userRepoMock = new Moq.Mock<I_Repository<UserDO>>();
        //    userRepoMock.Setup(r => r.GetByPK(1)).Returns(user);
        //    userRepoMock.Setup(r => r.ExecuteScalarStoreProcedure("dbo.PRO_Login", dicParamsForExternalLogin)).Returns(1);

        //    // Act
        //    var accountService = new AccountService(userRepoMock.Object, _loginSession);
        //    var result = accountService.Login(1, email, password, limitLoginAttemptsNumber, daysBlockedAttemptsNumber, LoginType.External);

        //    // Assert
        //    Assert.AreEqual(1, result);
        //}

        //[Test]
        //public void ExternalAutoLogin_Fail()
        //{
        //    // Arrange
        //    var user = new UserDO { UserId = 1, Email = email, Password = password };

        //    var userRepoMock = new Moq.Mock<I_Repository<UserDO>>();
        //    userRepoMock.Setup(r => r.GetByPK(1)).Returns(user);
        //    userRepoMock.Setup(r => r.ExecuteScalarStoreProcedure("dbo.PRO_Login", dicParamsForExternalLogin)).Returns(-1);

        //    // Act
        //    var accountService = new AccountService(userRepoMock.Object, _loginSession);
        //    var result = accountService.Login(1, email, password, limitLoginAttemptsNumber, daysBlockedAttemptsNumber, LoginType.External);

        //    // Assert
        //    Assert.AreEqual(-1, result);
        //}

        //[Test]
        //public void TestResetPassWordSuccess()
        //{
        //    const string userOrEmail = "C.Ozdemir@employersmutual.com.au";
        //    const string newPassWord = "qX0ZgIFaiv0GnUxx23FqXQ==";
        //    const string securitynumber = "qX0ZgIFaiv0GnUxx23FqXQSS";
        //    const string confirmnumber = "qX0ZgIFaiv0GnUxx23FqXQSS";
        //    const bool isexternaluser = true;

        //    Dictionary<string, object> dicParams = new Dictionary<string, object>();
        //    dicParams.Add("@SecurityNumber", securitynumber);
        //    dicParams.Add("@ConfirmNumber", confirmnumber);
        //    dicParams.Add("@isExternalUser", isexternaluser);
        //    dicParams.Add("@UserNameOrEmail", userOrEmail);
        //    dicParams.Add("@PassWordReset", newPassWord);

        //    var repoMock = new Mock<I_Repository<UserDO>>();
        //    repoMock.Setup(r => r.ExecuteScalarStoreProcedure("PRO_ResetPassword", dicParams)).Returns(1);

        //    var accountService = new AccountService(repoMock.Object, _loginSession);
        //    int result = accountService.ResetPassword(securitynumber, confirmnumber, isexternaluser, userOrEmail, newPassWord);

        //    // Assert 
        //    Assert.IsNotNull(result);
        //    Assert.Greater(result, -1, "Password reset successfully");
        //}

        //[Test]
        //public void TestResetPassWordFail()
        //{
        //    const string userOrEmail = "abc@employersmutual.com.au";
        //    const string newPassWord = "qX0ZgIFaiv0GnUxx23FqXQ==";
        //    const string securitynumber = "qX0ZgIFaiv0GnUxx23FqXQSS";
        //    const string confirmnumber = "qX0ZgIFaiv0GnUxx23FqXQFF";
        //    const bool isexternaluser = true;

        //    Dictionary<string, object> dicParams = new Dictionary<string, object>();
        //    dicParams.Add("@UserNameOrEmail", userOrEmail);
        //    dicParams.Add("@PassWordReset", newPassWord);

        //    var repoMock = new Mock<I_Repository<UserDO>>();
        //    repoMock.Setup(r => r.ExecuteScalarStoreProcedure("PRO_ResetPassword", dicParams)).Returns(-1);

        //    var accountService = new AccountService(repoMock.Object, _loginSession);
        //    int result = accountService.ResetPassword(securitynumber, confirmnumber, isexternaluser, userOrEmail, newPassWord);

        //    // Assert 
        //    Assert.IsNotNull(result);
        //    Assert.Less(result, 0, "Password reset successfully");
        //}
    }
}

