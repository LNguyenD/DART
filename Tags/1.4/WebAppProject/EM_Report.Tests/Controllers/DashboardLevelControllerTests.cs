using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using System.Collections.Specialized;
using Moq;
using System.Web;
using EM_Report.Tests.Helpers;
using EM_Report.Domain;
using EM_Report.Repositories;
using EM_Report.Controllers;
using System.Web.Mvc;

namespace EM_Report.Tests.Controllers
{
    [TestFixture]
    public class DashboardLevelControllerTests : BaseControllerTests
    {
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

            var levels = new List<Dashboard_Levels> { new Dashboard_Levels { DashboardLevelId = 1 }, new Dashboard_Levels { DashboardLevelId = 2 } };
            var levelRepoMock = new Mock<IDashboardLevelRepository>();
            levelRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>())).Returns(levels);

            // Act
            var controller = new DashboardLevelController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.DashboardLevelRepository = levelRepoMock.Object;
            var result = controller.Index() as ViewResult;

            // Assert
            Assert.AreEqual(levels, ((List<Dashboard_Levels>)result.Model));
            Assert.AreEqual("", result.ViewName);
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

            var levels = new List<Dashboard_Levels> { new Dashboard_Levels { DashboardLevelId = 1 }, new Dashboard_Levels { DashboardLevelId = 2 } };
            var levelRepoMock = new Mock<IDashboardLevelRepository>();
            levelRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(levels);
            levelRepoMock.Setup(r => r.UpdateStatus(It.IsAny<string>()));

            // Act
            var controller = new DashboardLevelController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.DashboardLevelRepository = levelRepoMock.Object;
            var result = controller.Index(null, "test", "test", "test") as ViewResult;

            // Assert
            Assert.AreEqual(levels, ((List<Dashboard_Levels>)result.Model));
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

            var levelRepoMock = new Mock<IDashboardLevelRepository>();
            levelRepoMock.Setup(r => r.GetById(It.IsAny<int>()));

            // Act
            var controller = new DashboardLevelController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.DashboardLevelRepository = levelRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.Details(null, "test") as ViewResult;

            // Assert
            levelRepoMock.Verify(r => r.GetById(It.IsAny<int>()), Times.Never());
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

            var levelRepoMock = new Mock<IDashboardLevelRepository>();
            levelRepoMock.Setup(r => r.GetById(1)).Returns(new Dashboard_Levels { DashboardLevelId = 1, Status = 1 });

            // Act
            var controller = new DashboardLevelController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.DashboardLevelRepository = levelRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.Details(1, "test") as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        #endregion

        #region Details POST

        [Test]
        public void Details_PostMethod_InvalidDashboardLevel()
        {
            // Arrange
            var level = new Dashboard_Levels { DashboardLevelId = 1, Status = 1 };

            // Act
            var controller = new DashboardLevelController();
            controller.ModelState.AddModelError("test", "test");
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.Details(level) as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        [Test]
        public void Details_PostMethod_UpdateDashboardLevel()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var level = new Dashboard_Levels { DashboardLevelId = 1, Status = 1 };

            var levelRepoMock = new Mock<IDashboardLevelRepository>();
            levelRepoMock.Setup(r => r.Update(level));

            // Act
            var controller = new DashboardLevelController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.DashboardLevelRepository = levelRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.Details(level) as ViewResult;

            // Assert
            levelRepoMock.Verify(r => r.Update(level), Times.Once());
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Success"));
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        [Test]
        public void Details_PostMethod_InsertDashboardLevel()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var level = new Dashboard_Levels { DashboardLevelId = -1 };

            var levelRepoMock = new Mock<IDashboardLevelRepository>();
            levelRepoMock.Setup(r => r.Insert(level));
            levelRepoMock.Setup(r => r.GetList("", "")).Returns(new List<Dashboard_Levels>());

            // Act
            var controller = new DashboardLevelController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.DashboardLevelRepository = levelRepoMock.Object;
            var result = controller.Details(level) as RedirectToRouteResult;

            // Assert
            levelRepoMock.Verify(r => r.Insert(level), Times.Once());
            Assert.IsTrue(result.RouteValues["action"].ToString().Equals("Index", StringComparison.InvariantCultureIgnoreCase));
            Assert.IsTrue(result.RouteValues["controller"].ToString().Equals("DashboardLevel", StringComparison.InvariantCultureIgnoreCase));
        }

        #endregion
    }
}
