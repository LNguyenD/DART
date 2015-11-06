using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using System.Collections.Specialized;
using System.Web;
using Moq;
using EM_Report.Tests.Helpers;
using EM_Report.Domain;
using EM_Report.Repositories;
using EM_Report.Controllers;
using System.Web.Mvc;
using EM_Report.Domain.Enums;

namespace EM_Report.Tests.Controllers
{
    [TestFixture]
    public class UserControllerTests : BaseControllerTests
    {
        //#region Index GET

        //[Test]
        //public void Index_GetMethod()
        //{
        //    // Arrange
        //    var queryStrings = new NameValueCollection();
        //    queryStrings.Add("systemid", "1");
        //    var requestMock = new Mock<HttpRequestBase>();
        //    requestMock.MockQueryStrings(queryStrings).MockCookies();
        //    requestMock.SetupGet(r => r["systemid"]).Returns("1");
        //    requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var users = new List<User> { new User { UserId = 1 }, new User { UserId = 2 } };
        //    var userRepoMock = new Mock<IUserRepository>();
        //    userRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string>())).Returns(users);

        //    // Act
        //    var controller = new UserController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    controller.UserRepository = userRepoMock.Object;
        //    var result = controller.Index() as ViewResult;

        //    // Assert
        //    Assert.AreEqual(users, ((List<User>)result.Model));
        //    Assert.AreEqual("", result.ViewName);
        //}

        //#endregion

        //#region Index POST

        ////[Test]
        ////public void Index_PostMethod()
        ////{
        ////    // Arrange
        ////    var formData = new NameValueCollection();
        ////    formData.Add("cboDisplayEntry", "10");
        ////    formData.Add("cboUserType", "system");
        ////    var requestMock = new Mock<HttpRequestBase>();
        ////    requestMock.MockFormData(formData).MockCookies();
        ////    requestMock.SetupGet(r => r["systemid"]).Returns("1");
        ////    requestMock.SetupGet(r => r["cboSystem"]).Returns("1");
        ////    requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

        ////    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        ////    var users = new List<User> { new User { UserId = 1 }, new User { UserId = 2 } };
        ////    var userRepoMock = new Mock<IUserRepository>();
        ////    userRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string>())).Returns(users);
        ////    userRepoMock.Setup(r => r.UpdateStatus(It.IsAny<string>()));

        ////    // Act
        ////    var controller = new UserController();
        ////    controller.ControllerContext = controllerContextMock.Object;
        ////    controller.UserRepository = userRepoMock.Object;
        ////    var result = controller.Index("test", "test", "test") as ViewResult;

        ////    // Assert
        ////    Assert.AreEqual(users, ((List<User>)result.Model));
        ////    Assert.AreEqual("", result.ViewName);
        ////    Assert.AreEqual(10, result.ViewBag.PageSize);
        ////}

        //#endregion

        //#region Details GET

        //[Test]
        //public void Details_GetMethod_IdNull()
        //{
        //    // Arrange
        //    var queryStrings = new NameValueCollection();
        //    queryStrings.Add("systemid", "1");
        //    var requestMock = new Mock<HttpRequestBase>();
        //    requestMock.MockQueryStrings(queryStrings).MockCookies();
        //    requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var userRepoMock = new Mock<IUserRepository>();
        //    userRepoMock.Setup(r => r.Get(It.IsAny<int>()));
        //    userRepoMock.Setup(r => r.GetSystemList()).Returns(systems.ToArray());

        //    // Act
        //    var controller = SetupController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    controller.UserRepository = userRepoMock.Object;
        //    var result = controller.Details((int?)null) as ViewResult;

        //    // Assert
        //    userRepoMock.Verify(r => r.Get(It.IsAny<int>()), Times.Never());
        //    Assert.AreEqual("", result.ViewName);
        //    var cboStatus = (SelectList)result.ViewBag.cboStatus;
        //    Assert.AreEqual(0, cboStatus.SelectedValue);
        //}

        //[Test]
        //public void Details_GetMethod_IdNotNull()
        //{
        //    // Arrange
        //    var queryStrings = new NameValueCollection();
        //    queryStrings.Add("systemid", "1");
        //    var requestMock = new Mock<HttpRequestBase>();
        //    requestMock.MockQueryStrings(queryStrings).MockCookies();
        //    requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var userRepoMock = new Mock<IUserRepository>();
        //    userRepoMock.Setup(r => r.Get(1)).Returns(new User { UserId = 1, Status = 1 });          
        //    userRepoMock.Setup(r => r.GetSystemList()).Returns(systems.ToArray());

        //    // Act
        //    var controller = SetupController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    controller.UserRepository = userRepoMock.Object;
        //    var result = controller.Details(1) as ViewResult;

        //    // Assert
        //    Assert.AreEqual("", result.ViewName);
        //    var cboStatus = (SelectList)result.ViewBag.cboStatus;
        //    Assert.AreEqual(1, cboStatus.SelectedValue);
        //}
        
        //#endregion

        //#region Details POST

        //[Test]
        //public void Details_PostMethod_Fail_InvalidUser()
        //{
        //    // Arrange
        //    var user = new User { UserId = 1, Status = 1 };

        //    var queryStrings = new NameValueCollection();
        //    queryStrings.Add("systemid", "1");
        //    var requestMock = new Mock<HttpRequestBase>();
        //    requestMock.MockQueryStrings(queryStrings).MockCookies();
        //    requestMock.SetupGet(r => r.UrlReferrer).Returns(new Uri("http://localhost?systemid=1"));

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var userRepoMock = new Mock<IUserRepository>();
        //    userRepoMock.Setup(r => r.GetSystemList()).Returns(systems.ToArray());

        //    // Act
        //    var controller = SetupController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    controller.UserRepository = userRepoMock.Object;
        //    controller.ModelState.AddModelError("test", "test");
        //    var result = controller.Details(user) as ViewResult;

        //    // Assert
        //    Assert.AreEqual("", result.ViewName);
        //    Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
        //    var cboStatus = (SelectList)result.ViewBag.cboStatus;
        //    Assert.AreEqual(1, cboStatus.SelectedValue);
        //}

        //[Test]
        //public void Details_PostMethod_Fail_UserExist()
        //{
        //    // Arrange
        //    var user = new User { UserId = 1, Status = 1 };

        //    var queryStrings = new NameValueCollection();
        //    queryStrings.Add("systemid", "1");
        //    var requestMock = new Mock<HttpRequestBase>();
        //    requestMock.MockQueryStrings(queryStrings).MockCookies();
        //    requestMock.SetupGet(r => r.UrlReferrer).Returns(new Uri("http://localhost?systemid=1"));

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var userRepoMock = new Mock<IUserRepository>();
        //    userRepoMock.Setup(r => r.IsValidUser(user)).Returns(false);
        //    userRepoMock.Setup(r => r.GetSystemList()).Returns(systems.ToArray());

        //    // Act
        //    var controller = SetupController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    controller.UserRepository = userRepoMock.Object;
        //    var result = controller.Details(user) as ViewResult;

        //    // Assert
        //    Assert.AreEqual("", result.ViewName);
        //    Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
        //    var cboStatus = (SelectList)result.ViewBag.cboStatus;
        //    Assert.AreEqual(1, cboStatus.SelectedValue);
        //}

        //[Test]
        //public void Details_PostMethod_Success_IsExternalUser_ExternalGroupIdNotNull_InsertUser()
        //{
        //    // Arrange
        //    var user = new User { UserId = -1, Status = 1, External_GroupId = 1 };

        //    var queryStrings = new NameValueCollection();
        //    queryStrings.Add("systemid", "1");
        //    var formData = new NameValueCollection();
        //    formData.Add("cboOrganisation_Roles_test", "1");
        //    formData.Add("cboTeams_test", "1");
        //    var requestMock = new Mock<HttpRequestBase>();
        //    requestMock.MockFormData(formData).MockQueryStrings(queryStrings).MockCookies();
        //    requestMock.Setup(r => r["Is_External_User"]).Returns("True");
        //    requestMock.SetupGet(r => r.UrlReferrer).Returns(new Uri("http://localhost?systemid=1"));

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var userRepoMock = new Mock<IUserRepository>();
        //    userRepoMock.Setup(r => r.Insert(user));
        //    userRepoMock.Setup(r => r.IsValidUser(user)).Returns(true);
        //    userRepoMock.Setup(r => r.GetSystemList()).Returns(systems.ToArray());

        //    // Act
        //    var controller = SetupController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    controller.UserRepository = userRepoMock.Object;
        //    var result = controller.Details(user) as RedirectToRouteResult;

        //    // Assert
        //    userRepoMock.Verify(r => r.Insert(user), Times.Once());
        //    Assert.IsTrue(result.RouteValues["action"].ToString().Equals("index", StringComparison.InvariantCultureIgnoreCase));
        //    Assert.IsTrue(result.RouteValues["controller"].ToString().Equals("user", StringComparison.InvariantCultureIgnoreCase));
        //}

        //[Test]
        //public void Details_PostMethod_Fail_IsExternalUser_ExternalGroupIdNull_InsertUser()
        //{
        //    // Arrange
        //    var user = new User { UserId = -1, Status = 1 };

        //    var queryStrings = new NameValueCollection();
        //    queryStrings.Add("systemid", "1");
        //    var formData = new NameValueCollection();
        //    formData.Add("cboOrganisation_Roles_test", "1");
        //    formData.Add("cboTeams_test", "1");
        //    var requestMock = new Mock<HttpRequestBase>();
        //    requestMock.MockFormData(formData).MockQueryStrings(queryStrings).MockCookies();
        //    requestMock.Setup(r => r["Is_External_User"]).Returns("True");
        //    requestMock.SetupGet(r => r.UrlReferrer).Returns(new Uri("http://localhost?systemid=1"));

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var userRepoMock = new Mock<IUserRepository>();
        //    userRepoMock.Setup(r => r.Insert(user));
        //    userRepoMock.Setup(r => r.IsValidUser(user)).Returns(true);
        //    userRepoMock.Setup(r => r.GetSystemList()).Returns(systems.ToArray());

        //    // Act
        //    var controller = SetupController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    controller.UserRepository = userRepoMock.Object;
        //    var result = controller.Details(user) as ViewResult;

        //    // Assert
        //    userRepoMock.Verify(r => r.Insert(user), Times.Never());
        //    Assert.AreEqual("", result.ViewName);
        //    Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
        //    var cboStatus = (SelectList)result.ViewBag.cboStatus;
        //    Assert.AreEqual(1, cboStatus.SelectedValue);
        //}

        //[Test]
        //public void Details_PostMethod_Success_IsInternalUser_OrgRoleNotNull_InsertUser()
        //{
        //    // Arrange
        //    var user = new User { UserId = -1, Status = 1, External_GroupId = 1 };

        //    var queryStrings = new NameValueCollection();
        //    queryStrings.Add("systemid", "1");
        //    var formData = new NameValueCollection();
        //    formData.Add("cboOrganisation_Roles_test", "1");
        //    formData.Add("cboTeams_test", "1");
        //    var requestMock = new Mock<HttpRequestBase>();
        //    requestMock.MockQueryStrings(queryStrings).MockFormData(formData).MockCookies();
        //    requestMock.Setup(r => r["Is_External_User"]).Returns("False");
        //    requestMock.Setup(r => r["Is_System_User"]).Returns("False");
        //    requestMock.SetupGet(r => r.UrlReferrer).Returns(new Uri("http://localhost?systemid=1"));

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var userRepoMock = new Mock<IUserRepository>();
        //    userRepoMock.Setup(r => r.Insert(user));
        //    userRepoMock.Setup(r => r.IsValidUser(user)).Returns(true);
        //    userRepoMock.Setup(r => r.GetSystemList()).Returns(systems.ToArray());

        //    // Act
        //    var controller = SetupController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    controller.UserRepository = userRepoMock.Object;
        //    var result = controller.Details(user) as RedirectToRouteResult;

        //    // Assert
        //    userRepoMock.Verify(r => r.Insert(user), Times.Once());
        //    Assert.IsTrue(result.RouteValues["action"].ToString().Equals("index", StringComparison.InvariantCultureIgnoreCase));
        //    Assert.IsTrue(result.RouteValues["controller"].ToString().Equals("user", StringComparison.InvariantCultureIgnoreCase));
        //}

        //[Test]
        //public void Details_PostMethod_Fail_IsInternalUser_OrgRoleNull_InsertUser()
        //{
        //    // Arrange
        //    var user = new User { UserId = -1, Status = 1, External_GroupId = 1 };

        //    var queryStrings = new NameValueCollection();
        //    queryStrings.Add("systemid", "1");
        //    var formData = new NameValueCollection();
        //    formData.Add("cboOrganisation_Roles_test", "0");
        //    formData.Add("cboTeams_test", "1");
        //    var requestMock = new Mock<HttpRequestBase>();
        //    requestMock.MockQueryStrings(queryStrings).MockFormData(formData).MockCookies();
        //    requestMock.Setup(r => r["Is_External_User"]).Returns("False");
        //    requestMock.Setup(r => r["Is_System_User"]).Returns("False");
        //    requestMock.SetupGet(r => r.UrlReferrer).Returns(new Uri("http://localhost?systemid=1"));

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var userRepoMock = new Mock<IUserRepository>();
        //    userRepoMock.Setup(r => r.Insert(user));
        //    userRepoMock.Setup(r => r.IsValidUser(user)).Returns(true);
        //    userRepoMock.Setup(r => r.GetSystemList()).Returns(systems.ToArray());

        //    // Act
        //    var controller = SetupController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    controller.UserRepository = userRepoMock.Object;
        //    var result = controller.Details(user) as ViewResult;

        //    // Assert
        //    userRepoMock.Verify(r => r.Insert(user), Times.Never());
        //    Assert.AreEqual("", result.ViewName);
        //    Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
        //    var cboStatus = (SelectList)result.ViewBag.cboStatus;
        //    Assert.AreEqual(1, cboStatus.SelectedValue);
        //}

        //[Test]
        //public void Details_PostMethod_Success_IsExternalUser_ExternalGroupIdNotNull_UpdateUser()
        //{
        //    // Arrange
        //    var user = new User { UserId = 1, Status = 1, External_GroupId = 1 };

        //    var queryStrings = new NameValueCollection();
        //    queryStrings.Add("systemid", "1");
        //    var requestMock = new Mock<HttpRequestBase>();
        //    requestMock.MockQueryStrings(queryStrings).MockCookies();
        //    requestMock.Setup(r => r["Is_External_User"]).Returns("True");
        //    requestMock.SetupGet(r => r.UrlReferrer).Returns(new Uri("http://localhost?systemid=1"));

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var userRepoMock = new Mock<IUserRepository>();
        //    userRepoMock.Setup(r => r.Update(user));
        //    userRepoMock.Setup(r => r.IsValidUser(user)).Returns(true);
        //    userRepoMock.Setup(r => r.GetSystemList()).Returns(systems.ToArray());

        //    // Act
        //    var controller = SetupController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    controller.UserRepository = userRepoMock.Object;
        //    var result = controller.Details(user) as ViewResult;

        //    // Assert
        //    userRepoMock.Verify(r => r.Update(user), Times.Once());
        //    Assert.AreEqual("", result.ViewName);
        //    Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Success"));
        //    var cboStatus = (SelectList)result.ViewBag.cboStatus;
        //    Assert.AreEqual(1, cboStatus.SelectedValue);
        //}

        //[Test]
        //public void Details_PostMethod_Fail_IsExternalUser_ExternalGroupIdNull_UpdateUser()
        //{
        //    // Arrange
        //    var user = new User { UserId = 1, Status = 1 };

        //    var queryStrings = new NameValueCollection();
        //    queryStrings.Add("systemid", "1");
        //    var requestMock = new Mock<HttpRequestBase>();
        //    requestMock.MockQueryStrings(queryStrings).MockCookies();
        //    requestMock.Setup(r => r["Is_External_User"]).Returns("True");
        //    requestMock.SetupGet(r => r.UrlReferrer).Returns(new Uri("http://localhost?systemid=1"));

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var userRepoMock = new Mock<IUserRepository>();
        //    userRepoMock.Setup(r => r.Update(user));
        //    userRepoMock.Setup(r => r.IsValidUser(user)).Returns(true);
        //    userRepoMock.Setup(r => r.GetSystemList()).Returns(systems.ToArray());

        //    // Act
        //    var controller = SetupController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    controller.UserRepository = userRepoMock.Object;
        //    var result = controller.Details(user) as ViewResult;

        //    // Assert
        //    userRepoMock.Verify(r => r.Update(user), Times.Never());
        //    Assert.AreEqual("", result.ViewName);
        //    Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
        //    var cboStatus = (SelectList)result.ViewBag.cboStatus;
        //    Assert.AreEqual(1, cboStatus.SelectedValue);
        //}

        //[Test]
        //public void Details_PostMethod_Success_IsInternalUser_OrgRoleNotNull_UpdateUser()
        //{
        //    // Arrange
        //    var user = new User { UserId = 1, Status = 1, External_GroupId = 1 };

        //    var queryStrings = new NameValueCollection();
        //    queryStrings.Add("systemid", "1");
        //    var formData = new NameValueCollection();
        //    formData.Add("cboOrganisation_Roles_test", "1");
        //    formData.Add("cboTeams_test", "1");
        //    var requestMock = new Mock<HttpRequestBase>();
        //    requestMock.MockQueryStrings(queryStrings).MockFormData(formData).MockCookies();
        //    requestMock.Setup(r => r["Is_External_User"]).Returns("False");
        //    requestMock.Setup(r => r["Is_System_User"]).Returns("False");
        //    requestMock.SetupGet(r => r.UrlReferrer).Returns(new Uri("http://localhost?systemid=1"));

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var userRepoMock = new Mock<IUserRepository>();
        //    userRepoMock.Setup(r => r.Update(user));
        //    userRepoMock.Setup(r => r.IsValidUser(user)).Returns(true);
        //    userRepoMock.Setup(r => r.GetSystemList()).Returns(systems.ToArray());

        //    // Act
        //    var controller = SetupController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    controller.UserRepository = userRepoMock.Object;
        //    var result = controller.Details(user) as ViewResult;

        //    // Assert
        //    userRepoMock.Verify(r => r.Update(user), Times.Once());
        //    Assert.AreEqual("", result.ViewName);
        //    Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Success"));
        //    var cboStatus = (SelectList)result.ViewBag.cboStatus;
        //    Assert.AreEqual(1, cboStatus.SelectedValue);
        //}

        //[Test]
        //public void Details_PostMethod_Fail_IsInternalUser_OrgRoleNull_UpdateUser()
        //{
        //    // Arrange
        //    var user = new User { UserId = 1, Status = 1, External_GroupId = 1 };

        //    var queryStrings = new NameValueCollection();
        //    queryStrings.Add("systemid", "1");
        //    var formData = new NameValueCollection();
        //    formData.Add("cboOrganisation_Roles_test", "0");
        //    var requestMock = new Mock<HttpRequestBase>();
        //    requestMock.MockQueryStrings(queryStrings).MockFormData(formData).MockCookies();
        //    requestMock.Setup(r => r["Is_External_User"]).Returns("False");
        //    requestMock.Setup(r => r["Is_System_User"]).Returns("False");
        //    requestMock.SetupGet(r => r.UrlReferrer).Returns(new Uri("http://localhost?systemid=1"));

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var userRepoMock = new Mock<IUserRepository>();
        //    userRepoMock.Setup(r => r.Update(user));
        //    userRepoMock.Setup(r => r.IsValidUser(user)).Returns(true);
        //    userRepoMock.Setup(r => r.GetSystemList()).Returns(systems.ToArray());

        //    // Act
        //    var controller = SetupController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    controller.UserRepository = userRepoMock.Object;
        //    var result = controller.Details(user) as ViewResult;

        //    // Assert
        //    userRepoMock.Verify(r => r.Update(user), Times.Never());
        //    Assert.AreEqual("", result.ViewName);
        //    Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
        //    var cboStatus = (SelectList)result.ViewBag.cboStatus;
        //    Assert.AreEqual(1, cboStatus.SelectedValue);
        //}
        
        //#endregion

        //#region Import POST

        //[Test]
        //public void Import_PostMethod_Fail_InvalidModel()
        //{
        //    // TODO: mock import helper
        //}

        //[Test]
        //public void Import_PostMethod_Success_ProcessData()
        //{
        //}

        //[Test]
        //public void Import_PostMethod_Success_SubmitData()
        //{
        //}

        //#endregion

        //private UserController SetupController()
        //{
        //    var controller = new UserController();

        //    var externalGroupRepoMock = new Mock<IExternal_GroupRepository>();
        //    externalGroupRepoMock.Setup(r => r.GetList("", "", GroupStatusFilter.All)).Returns(new List<External_Group>());

        //    var teamRepoMock = new Mock<ITeamRepository>();
        //    teamRepoMock.Setup(r => r.GetList("", "")).Returns(new List<Team>());

        //    var systemRoleRepoMock = new Mock<ISystemRoleRepository>();
        //    systemRoleRepoMock.Setup(r => r.GetList("", "")).Returns(new List<System_Roles>());

        //    var orgRoleRepoMock = new Mock<IOrganisationRolesRepository>();
        //    orgRoleRepoMock.Setup(r => r.GetList("", "")).Returns(new List<Organisation_Roles>());

        //    var orgLevelRepoMock = new Mock<IOrganisationLevelsRepository>();
        //    orgLevelRepoMock.Setup(r => r.GetList("", "")).Returns(new List<Organisation_Levels>());

        //    controller.External_GroupRepository = externalGroupRepoMock.Object;
        //    controller.TeamRepository = teamRepoMock.Object;
        //    controller.SystemRoleRepository = systemRoleRepoMock.Object;
        //    controller.OrganisationRoleRepository = orgRoleRepoMock.Object;
        //    controller.OrganisationLevelRepository = orgLevelRepoMock.Object;
        //    controller.StatusRepository = statusRepoMock.Object;

        //    return controller;
        //}
    }
}
