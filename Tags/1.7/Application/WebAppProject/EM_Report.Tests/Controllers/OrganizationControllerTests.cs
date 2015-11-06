using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using System.Web;
using Moq;
using EM_Report.Tests.Helpers;
using EM_Report.Repositories;
using EM_Report.Controllers;
using System.Web.Mvc;
using EM_Report.Domain;
using System.Collections.Specialized;

namespace EM_Report.Tests.Controllers
{
    [TestFixture]
    public class OrganizationControllerTests : BaseControllerTests
    {
        private Mock<IOrganisationLevelsRepository> _orgLevelRepoMock;

        [TestFixtureSetUp]
        public void SetupMock()
        {
            _orgLevelRepoMock = new Mock<IOrganisationLevelsRepository>();
            _orgLevelRepoMock.Setup(r => r.GetList()).Returns(new List<Organisation_Levels>());
        }

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
            orgRoleRepoMock.Setup(r => r.Get(It.IsAny<int>()));

            // Act
            var controller = new OrganisationController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.OrganisationRoleRepository = orgRoleRepoMock.Object;
            controller.OrganisationLevelRepository = _orgLevelRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.Details((int?)null) as ViewResult;

            // Assert
            orgRoleRepoMock.Verify(r => r.Get(It.IsAny<int>()), Times.Never());
            Assert.AreEqual("", result.ViewName);
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(0, cboStatus.SelectedValue);
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
            orgRoleRepoMock.Setup(r => r.Get(1)).Returns(new Organisation_Roles { Status = 1 });

            // Act
            var controller = new OrganisationController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.OrganisationRoleRepository = orgRoleRepoMock.Object;
            controller.OrganisationLevelRepository = _orgLevelRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.Details(1) as ViewResult;

            // Assert
            orgRoleRepoMock.Verify(r => r.Get(1), Times.Once());
            Assert.AreEqual("", result.ViewName);
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        #endregion

        #region Details POST

        [Test]
        public void Details_PostMethod_Fail_InvalidOrganizationRole()
        {
            // Arrange
            var role = new Organisation_Roles { LevelId = 1, Status = 1 };

            // Act
            var controller = new OrganisationController();
            controller.ModelState.AddModelError("test", "test");
            controller.OrganisationLevelRepository = _orgLevelRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.Details(role) as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        [Test]
        public void Details_PostMethod_UpdateOrganizationRole()
        {
            // Arrange
            var formData = new NameValueCollection();
            formData.Add("cboLevel", "1");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var role = new Organisation_Roles { Organisation_RoleId = 1, Status = 1 };

            var orgRoleRepoMock = new Mock<IOrganisationRolesRepository>();
            orgRoleRepoMock.Setup(r => r.Update(role));

            // Act
            var controller = new OrganisationController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.OrganisationRoleRepository = orgRoleRepoMock.Object;
            controller.OrganisationLevelRepository = _orgLevelRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.Details(role) as ViewResult;

            // Assert
            orgRoleRepoMock.Verify(r => r.Update(role), Times.Once());
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Success"));
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        [Test]
        public void Details_PostMethod_InsertOrganizationRole()
        {
            // Arrange
            var formData = new NameValueCollection();
            formData.Add("cboLeveltest", "1");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var role = new Organisation_Roles { Organisation_RoleId = -1, Status = 1 };

            var orgRoleRepoMock = new Mock<IOrganisationRolesRepository>();
            orgRoleRepoMock.Setup(r => r.Create(role));

            // Act
            var controller = new OrganisationController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.OrganisationRoleRepository = orgRoleRepoMock.Object;
            controller.OrganisationLevelRepository = _orgLevelRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.Details(role) as RedirectToRouteResult;

            // Assert
            orgRoleRepoMock.Verify(r => r.Create(role), Times.Once());
            Assert.IsTrue(result.RouteValues["action"].ToString().Equals("index", StringComparison.InvariantCultureIgnoreCase));
            Assert.IsTrue(result.RouteValues["controller"].ToString().Equals("organisation_level", StringComparison.InvariantCultureIgnoreCase));
        }

        #endregion
    }
}
