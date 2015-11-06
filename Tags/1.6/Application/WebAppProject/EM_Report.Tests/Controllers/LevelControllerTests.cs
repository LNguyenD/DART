using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using System.Web;
using Moq;
using EM_Report.Tests.Helpers;
using EM_Report.Controllers;
using System.Web.Mvc;
using EM_Report.Domain;
using EM_Report.Repositories;
using System.Collections.Specialized;

namespace EM_Report.Tests.Controllers
{
    [TestFixture]
    public class LevelControllerTests : BaseControllerTests
    {
        #region Details GET

        [Test]
        public void Details_GetMethod_IdNull()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var orgRoleRepoMock = new Mock<IOrganisationRolesRepository>();
            orgRoleRepoMock.Setup(r => r.GetRolesOfLevel(It.IsAny<int>()));

            // Act
            var controller = new LevelController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.OrganisationRoleRepository = orgRoleRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.Details(null, "test") as ViewResult;

            // Assert
            Assert.IsNull(result.Model);
            Assert.AreEqual("", result.ViewName);
        }

        [Test]
        public void Details_GetMethod_IdNotNull()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var orgRoleRepoMock = new Mock<IOrganisationRolesRepository>();
            orgRoleRepoMock.Setup(r => r.GetRolesOfLevel(It.IsAny<int>()));

            var orgLevel = new Organisation_Levels();
            var orgLevelRepoMock = new Mock<IOrganisationLevelsRepository>();
            orgLevelRepoMock.Setup(r => r.Get(1)).Returns(orgLevel);

            // Act
            var controller = new LevelController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.OrganisationRoleRepository = orgRoleRepoMock.Object;
            controller.OrganisationLevelRepository = orgLevelRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.Details(1, "test") as ViewResult;

            // Assert
            Assert.IsNotNull(result.Model);
            Assert.AreEqual(orgLevel, result.Model);
            Assert.AreEqual("", result.ViewName);
        }

        [Test]
        public void Details_GetMethod_ThrowException()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var orgRoleRepoMock = new Mock<IOrganisationRolesRepository>();
            orgRoleRepoMock.Setup(r => r.GetRolesOfLevel(It.IsAny<int>()));

            var orgLevelRepoMock = new Mock<IOrganisationLevelsRepository>();
            orgLevelRepoMock.Setup(r => r.Get(It.IsAny<int>())).Throws<Exception>();

            // Act
            var controller = new LevelController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.OrganisationRoleRepository = orgRoleRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.Details(null, "test") as ViewResult;

            // Assert
            //Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
        }

	    #endregion

        #region Details POST

        [Test]
        public void Details_PostMethod_SaveOrganizationLevel_Fail_InvalidModel()
        {
            // Arrange
            var orgLevel = new Organisation_Levels { LevelId = 1 };

            var formData = new NameValueCollection();
            formData.Add("action", "save");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var orgRoleRepoMock = new Mock<IOrganisationRolesRepository>();
            orgRoleRepoMock.Setup(r => r.GetRolesOfLevel(It.IsAny<int>()));

            // Act
            var controller = new LevelController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.OrganisationRoleRepository = orgRoleRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            controller.ModelState.AddModelError("test", "test");
            var result = controller.Details(orgLevel, "test", "test") as ViewResult;

            // Assert
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
        }

        [Test]
        public void Details_PostMethod_SaveOrganizationLevel_UpdateLevel_Success()
        {
            // Arrange
            var orgLevel = new Organisation_Levels { LevelId = 1 };

            var formData = new NameValueCollection();
            formData.Add("action", "save");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var orgRoleRepoMock = new Mock<IOrganisationRolesRepository>();
            orgRoleRepoMock.Setup(r => r.GetRolesOfLevel(It.IsAny<int>()));

            var orgLevelRepoMock = new Mock<IOrganisationLevelsRepository>();
            orgLevelRepoMock.Setup(r => r.Update(orgLevel));

            // Act
            var controller = new LevelController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.OrganisationRoleRepository = orgRoleRepoMock.Object;
            controller.OrganisationLevelRepository = orgLevelRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.Details(orgLevel, "test", "test") as ViewResult;

            // Assert
            orgLevelRepoMock.Verify(r => r.Update(orgLevel), Times.Once());
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Success"));
            Assert.AreEqual(orgLevel, result.Model);
        }

        [Test]
        public void Details_PostMethod_SaveOrganizationLevel_InsertLevel_Success()
        {
            // Arrange
            var orgLevel = new Organisation_Levels { LevelId = -1 };

            var formData = new NameValueCollection();
            formData.Add("action", "save");
            formData.Add("chkSystem_test", "1");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var orgRoleRepoMock = new Mock<IOrganisationRolesRepository>();
            orgRoleRepoMock.Setup(r => r.GetRolesOfLevel(It.IsAny<int>()));

            var orgLevelRepoMock = new Mock<IOrganisationLevelsRepository>();
            orgLevelRepoMock.Setup(r => r.Create(orgLevel));
            orgLevelRepoMock.Setup(r => r.GetList("", "")).Returns(new List<Organisation_Levels> { new Organisation_Levels { Sort = 1 } });

            // Act
            var controller = new LevelController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.OrganisationRoleRepository = orgRoleRepoMock.Object;
            controller.OrganisationLevelRepository = orgLevelRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.Details(orgLevel, "test", "test") as RedirectToRouteResult;

            // Assert
            orgLevelRepoMock.Verify(r => r.Create(orgLevel), Times.Once());
            Assert.IsTrue(result.RouteValues["action"].ToString().Equals("index", StringComparison.InvariantCultureIgnoreCase));
            Assert.IsTrue(result.RouteValues["controller"].ToString().Equals("organisation_level", StringComparison.InvariantCultureIgnoreCase));
        }

        [Test]
        public void Details_PostMethod_DeleteOrganizationLevel_Success()
        {
            // Arrange
            var orgLevel = new Organisation_Levels { LevelId = 1, SystemId = 1 };

            var formData = new NameValueCollection();
            formData.Add("action", "delete");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var orgLevelRepoMock = new Mock<IOrganisationLevelsRepository>();
            orgLevelRepoMock.Setup(r => r.Delete(1));

            // Act
            var controller = new LevelController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.OrganisationLevelRepository = orgLevelRepoMock.Object;
            var result = controller.Details(orgLevel, "test", "test") as RedirectToRouteResult;

            // Assert
            orgLevelRepoMock.Verify(r => r.Delete(1), Times.Once());
            Assert.IsTrue(result.RouteValues["action"].ToString().Equals("index", StringComparison.InvariantCultureIgnoreCase));
            Assert.IsTrue(result.RouteValues["systemid"].ToString().Equals("1"));
        }

        [Test]
        public void Details_PostMethod_DeleteOrganizationLevel_Fail_ThrowException()
        {
            // Arrange
            var orgLevel = new Organisation_Levels { LevelId = 1, SystemId = 1 };

            var formData = new NameValueCollection();
            formData.Add("action", "delete");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var orgLevelRepoMock = new Mock<IOrganisationLevelsRepository>();
            orgLevelRepoMock.Setup(r => r.Delete(1)).Throws<Exception>();

            // Act
            var controller = new LevelController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.OrganisationLevelRepository = orgLevelRepoMock.Object;
            var result = controller.Details(orgLevel, "test", "test") as ViewResult;

            // Assert
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
        }

        [Test]
        public void Details_PostMethod_AssignRolesToLevel()
        {
            // Arrange
            var orgLevel = new Organisation_Levels { LevelId = 1 };

            var formData = new NameValueCollection();
            formData.Add("action", "assign");
            formData.Add("firstList", "0,1,2");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var orgRoleRepoMock = new Mock<IOrganisationRolesRepository>();
            orgRoleRepoMock.Setup(r => r.GetRolesOfLevel(It.IsAny<int>()));
            orgRoleRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>())).Returns(new List<Organisation_Roles> { new Organisation_Roles { Organisation_RoleId = 1 } });
            orgRoleRepoMock.Setup(r => r.Update(It.IsAny<Organisation_Roles>()));

            // Act
            var controller = new LevelController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.OrganisationRoleRepository = orgRoleRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.Details(orgLevel, "test", "test") as ViewResult;

            // Assert
            orgRoleRepoMock.Verify(r => r.Update(It.IsAny<Organisation_Roles>()), Times.Once());
        }

        #endregion
    }
}
