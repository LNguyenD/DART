using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using EM_Report.Controllers;
using System.Web.Mvc;
using System.Web;
using Moq;
using System.Web.Routing;
using System.Collections.Specialized;
using EM_Report.Tests.Helpers;
using EM_Report.Helpers;
using EM_Report.Domain.Enums;

namespace EM_Report.Tests.Controllers
{
    [TestFixture]
    public class AccountControllerTests
    {
        #region Index

        [Test]
        public void Index_ReturnsToLoginPage()
        {
            // Arrange

            // Act
            var controller = new AccountController();
            RedirectToRouteResult result = controller.Index() as RedirectToRouteResult;

            // Assert
            Assert.AreEqual("/login", result.RouteValues["action"]);
        }

        #endregion

        //#region Login GET

        //[Test]
        //public void Login_GetMethod_Fail_ForbidAjaxRequest()
        //{
        //    // Arrange
        //    var requestMock = new Mock<HttpRequestBase>();
        //    requestMock.MockAjaxRequest();

        //    var contextMock = new Mock<ControllerContext>();
        //    contextMock.SetupGet(c => c.HttpContext.Request).Returns(requestMock.Object);

        //    // Act
        //    var controller = new AccountController();
        //    controller.ControllerContext = contextMock.Object;
        //    var result = controller.LogIn() as HttpStatusCodeResult;

        //    // Assert
        //    Assert.AreEqual(403, result.StatusCode);
        //}

        //[Test]
        //public void Logout_GetMethod_Success()
        //{
        //    // Arrange
        //    HttpContext.Current = MvcMockHelpers.FakeHttpContext();
        //    HttpContext.Current.Session["LoginSession"] = new LoginSession();

        //    var requestMock = new Mock<HttpRequestBase>();
        //    requestMock.SetupGet(r => r["logout"]).Returns("true");

        //    var applicationMock = new Mock<HttpApplicationStateBase>();
        //    applicationMock.SetupGet(s => s["RS2010"]).Returns(null);

        //    var httpContextMock = new Mock<HttpContextBase>();
        //    httpContextMock.SetupGet(c => c.Request).Returns(requestMock.Object);
        //    httpContextMock.SetupGet(c => c.Application).Returns(applicationMock.Object);

        //    var controllerContextMock = new Mock<ControllerContext>();
        //    controllerContextMock.SetupGet(c => c.HttpContext).Returns(httpContextMock.Object);

        //    // Act
        //    var controller = new AccountController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    var result = controller.LogIn() as ViewResult;

        //    // Assert
        //    Assert.IsNull(HttpContext.Current.Session["LoginSession"]);
        //    Assert.IsNull(HttpContext.Current.Session["AccessToken"]);
        //    Assert.AreEqual("", result.ViewName);
        //}

        //[Test]
        //public void Login_GetMethod_Internal_Success_SessionNotNull()
        //{
        //    // Arrange
        //    var loginSession = new LoginSession { strUserName = "test", strEmail = "test", strPassWord = "test" };
        //    HttpContext.Current = MvcMockHelpers.FakeHttpContext();
        //    HttpContext.Current.Session["LoginSession"] = loginSession;

        //    var controllerContext = CreateValidLoginControllerContext();

        //    var activeDirectoryServiceMock = new Mock<IActiveDirectoryService>();
        //    activeDirectoryServiceMock.Setup(s => s.Authenticate(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>())).Returns(true);

        //    // Act
        //    var controller = new AccountController();
        //    controller.ControllerContext = controllerContext;
        //    //var result = controller.LogIn();

        //    // Assert
        //}

        //[Test]
        //public void Login_GetMethod_Internal_Fail_SessionNotNull_AuthenticateFail()
        //{
        //}

        //[Test]
        //public void Login_GetMethod_Internal_Success_CookieNotNull()
        //{
        //}

        //[Test]
        //public void Login_GetMethod_Internal_Fail_CookieNotNull_AuthenticateFail()
        //{
        //}

        //[Test]
        //public void Login_GetMethod_External_Success_SessionNotNull()
        //{
        //}

        //[Test]
        //public void Login_GetMethod_External_Fail_SessionNotNull_AuthenticateFail()
        //{
        //}

        //[Test]
        //public void Login_GetMethod_External_Success_CookieNotNull()
        //{
        //}

        //[Test]
        //public void Login_GetMethod_External_Fail_CookieNotNull_AuthenticateFail()
        //{
        //}

        //[Test]
        //public void Login_GetMethod_Fail_SessionNull_CookieNull()
        //{
        //}

        //#endregion

        //#region Login POST

        //[Test]
        //public void Login_PostMethod_Internal_Success()
        //{
        //}

        //[Test]
        //public void Login_PostMethod_Internal_Fail()
        //{
        //}

        //[Test]
        //public void Login_PostMethod_External_Success()
        //{
        //}

        //[Test]
        //public void Login_PostMethod_External_Fail()
        //{
        //}

        //#endregion

        //#region Change password GET

        //[Test]
        //public void ChangePassword_GetMethod_Success()
        //{
        //}

        //[Test]
        //public void ChangePassword_GetMethod_Fail()
        //{
        //}

        //#endregion

        //#region Change password POST

        //[Test]
        //public void ChangePassword_PostMethod_Fail_InvalidModel()
        //{
        //}

        //[Test]
        //public void ChangePassword_PostMethod_Fail_SessionNull()
        //{
        //}

        //[Test]
        //public void ChangePassword_PostMethod_Success()
        //{
        //}

        //[Test]
        //public void ChangePassword_PostMethod_Fail_WrongCurrentPassword()
        //{
        //}

        //#endregion

        //#region Reset password GET

        //[Test]
        //public void ResetPassword_Getmethod_Success()
        //{
        //}

        //#endregion

        //#region Reset password POST

        //[Test]
        //public void ResetPassword_PostMethod_Fail_InvalidModel()
        //{
        //}

        //[Test]
        //public void ResetPassword_PostMethod_Success()
        //{
        //}

        //[Test]
        //public void ResetPassword_PostMethod_Fail()
        //{
        //}

        //#endregion

        //#region Helpers

        //private ControllerContext CreateValidLoginControllerContext()
        //{
        //    var applicationMock = new Mock<HttpApplicationStateBase>();
        //    applicationMock.SetupGet(s => s["RS2010"]).Returns(null);

        //    var httpContextMock = new Mock<HttpContextBase>();
        //    httpContextMock.SetupGet(c => c.Application).Returns(applicationMock.Object);

        //    var controllerContextMock = new Mock<ControllerContext>();
        //    controllerContextMock.SetupGet(c => c.HttpContext).Returns(httpContextMock.Object);

        //    return controllerContextMock.Object;
        //}

        //#endregion
    }
}
