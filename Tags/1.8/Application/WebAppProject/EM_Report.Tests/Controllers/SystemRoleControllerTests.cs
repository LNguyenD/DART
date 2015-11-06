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

namespace EM_Report.Tests.Controllers
{
    [TestFixture]
    public class SystemRoleControllerTests : BaseControllerTests
    {
        private Mock<ISystemPermissionRepository> systemPermissionRepoMock;
        private Mock<IPermissionRepository> permissionRepoMock;
        private Mock<ISystemRole_PermissionRepository> systemRolePermissionRepoMock;

        [TestFixtureSetUp]
        public void SetupMock()
        {
            systemPermissionRepoMock = new Mock<ISystemPermissionRepository>();
            systemPermissionRepoMock.Setup(r => r.GetList()).Returns(new List<System_Permission>());

            systemRolePermissionRepoMock = new Mock<ISystemRole_PermissionRepository>();
            systemRolePermissionRepoMock.Setup(r => r.GetList()).Returns(new List<System_Role_Permissions>());

            permissionRepoMock = new Mock<IPermissionRepository>();
            permissionRepoMock.Setup(r => r.GetList()).Returns(new List<Permission>());
        }

        #region Index GET

        [Test]
        public void Index_GetMethod()
        {
            // Arrange
            var queryStrings = new NameValueCollection();
            queryStrings.Add("systemid", "1");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockQueryStrings(queryStrings).MockCookies();
            requestMock.SetupGet(r => r["systemid"]).Returns("1");
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var roles = new List<System_Roles> { new System_Roles { System_RoleId = 1 }, new System_Roles { System_RoleId = 2 } };
            var roleRepoMock = new Mock<ISystemRoleRepository>();
            roleRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(roles);

            // Act
            var controller = new SystemRoleController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.SystemRoleRepository = roleRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            var result = controller.Index("test", "test") as ViewResult;

            // Assert
            Assert.AreEqual(roles, ((List<System_Roles>)result.Model));
        }

        #endregion

        #region Index POST

        [Test]
        public void Index_PostMethod()
        {
            // Arrange
            var formData = new NameValueCollection();
            formData.Add("cboDisplayEntry", "10");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r["systemid"]).Returns("1");
            requestMock.SetupGet(r => r["cboSystem"]).Returns("1");
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var roles = new List<System_Roles> { new System_Roles { System_RoleId = 1 }, new System_Roles { System_RoleId = 2 } };
            var roleRepoMock = new Mock<ISystemRoleRepository>();
            roleRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(roles);

            // Act
            var controller = new SystemRoleController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.SystemRoleRepository = roleRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            var result = controller.Index(null, "test", "test", "test") as ViewResult;

            // Assert
            Assert.AreEqual(roles, ((List<System_Roles>)result.Model));
            Assert.AreEqual("", result.ViewName);
            Assert.AreEqual(10, result.ViewBag.PageSize);
        }

        #endregion

        #region Details GET

        [Test]
        public void Details_GetMethod_IdNull()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var roleRepoMock = new Mock<ISystemRoleRepository>();
            roleRepoMock.Setup(r => r.GetById(It.IsAny<int>()));          

            // Act
            var controller = new SystemRoleController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.SystemRoleRepository = roleRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.SystemPermissionRepository = systemPermissionRepoMock.Object;
            controller.PermissionRepository = permissionRepoMock.Object;
            var result = controller.Details((int?)null) as ViewResult;

            // Assert
            roleRepoMock.Verify(r => r.GetById(It.IsAny<int>()), Times.Never());
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

            var roleRepoMock = new Mock<ISystemRoleRepository>();
            roleRepoMock.Setup(r => r.GetById(It.IsAny<int>())).Returns(new System_Roles { System_RoleId = 1 });

            // Act
            var controller = new SystemRoleController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.SystemRoleRepository = roleRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.SystemPermissionRepository = systemPermissionRepoMock.Object;
            controller.PermissionRepository = permissionRepoMock.Object;
            controller.SysRolePermissionRepository = systemRolePermissionRepoMock.Object;
            var result = controller.Details(1) as ViewResult;

            // Assert
            roleRepoMock.Verify(r => r.GetById(It.IsAny<int>()), Times.Once());
            Assert.AreEqual("", result.ViewName);
        }

        #endregion

        #region Details POST

        [Test]
        public void Details_PostMethod_Fail_InvalidSystemRole()
        {
            // Arrange
            var role = new System_Roles { System_RoleId = 1 };

            // Act
            var controller = new SystemRoleController();
            controller.ModelState.AddModelError("test", "test");
            controller.UserRepository = userRepoMock.Object;
            controller.SystemPermissionRepository = systemPermissionRepoMock.Object;
            controller.PermissionRepository = permissionRepoMock.Object;
            var result = controller.Details(role, "test") as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
        }

        [Test]
        public void Details_PostMethod_Success_SystemRoleIdGreaterThanZero()
        {
            // Arrange
            var role = new System_Roles { System_RoleId = 1 };

            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var roleRepoMock = new Mock<ISystemRoleRepository>();
            roleRepoMock.Setup(r => r.Save(role, It.IsAny<string>(), It.IsAny<int>())).Returns(true);

            // Act
            var controller = new SystemRoleController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.SystemRoleRepository = roleRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.SystemPermissionRepository = systemPermissionRepoMock.Object;
            controller.PermissionRepository = permissionRepoMock.Object;
            controller.SysRolePermissionRepository = systemRolePermissionRepoMock.Object;
            var result = controller.Details(role, "test") as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Success"));
        }

        [Test]
        public void Details_PostMethod_Fail_SystemRoleIdGreaterThanZero_SaveFail()
        {
            // Arrange
            var role = new System_Roles { System_RoleId = 1 };

            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var roleRepoMock = new Mock<ISystemRoleRepository>();
            roleRepoMock.Setup(r => r.Save(role, It.IsAny<string>(), It.IsAny<int>())).Returns(false);

            // Act
            var controller = new SystemRoleController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.SystemRoleRepository = roleRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.SystemPermissionRepository = systemPermissionRepoMock.Object;
            controller.PermissionRepository = permissionRepoMock.Object;
            controller.SysRolePermissionRepository = systemRolePermissionRepoMock.Object;
            var result = controller.Details(role, "test") as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
        }

        [Test]
        public void Details_PostMethod_Success_SystemRoleIdLessThanOrEqualZero()
        {
            // Arrange
            var role = new System_Roles { System_RoleId = -1 };

            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var roleRepoMock = new Mock<ISystemRoleRepository>();
            roleRepoMock.Setup(r => r.Save(role, It.IsAny<string>(), It.IsAny<int>())).Returns(true);

            // Act
            var controller = new SystemRoleController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.SystemRoleRepository = roleRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.SystemPermissionRepository = systemPermissionRepoMock.Object;
            controller.PermissionRepository = permissionRepoMock.Object;
            controller.SysRolePermissionRepository = systemRolePermissionRepoMock.Object;
            var result = controller.Details(role, "test") as RedirectToRouteResult;

            // Assert
            Assert.IsTrue(result.RouteValues["action"].ToString().Equals("index", StringComparison.InvariantCultureIgnoreCase));
            Assert.IsTrue(result.RouteValues["controller"].ToString().Equals("systemrole", StringComparison.InvariantCultureIgnoreCase));
        }

        [Test]
        public void Details_PostMethod_Fail_SystemRoleIdLessThanOrEqualZero_SaveFail()
        {
            // Arrange
            var role = new System_Roles { System_RoleId = -1 };

            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var roleRepoMock = new Mock<ISystemRoleRepository>();
            roleRepoMock.Setup(r => r.Save(role, It.IsAny<string>(), It.IsAny<int>())).Returns(false);

            // Act
            var controller = new SystemRoleController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.SystemRoleRepository = roleRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.SystemPermissionRepository = systemPermissionRepoMock.Object;
            controller.PermissionRepository = permissionRepoMock.Object;
            controller.SysRolePermissionRepository = systemRolePermissionRepoMock.Object;
            var result = controller.Details(role, "test") as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
        }

        #endregion
    }
}
