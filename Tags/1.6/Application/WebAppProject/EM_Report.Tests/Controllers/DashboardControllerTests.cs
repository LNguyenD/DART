using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using EM_Report.Tests.Helpers;
using System.Collections.Specialized;
using Moq;
using EM_Report.Repositories;
using EM_Report.Domain;
using EM_Report.Controllers;
using System.Web.Mvc;
using System.Web;
using EM_Report.Helpers;
using System.ComponentModel.DataAnnotations;

namespace EM_Report.Tests.Controllers
{
    [TestFixture]
    public class DashboardControllerTests : BaseControllerTests
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

            var dashboards = new List<Dashboard> { new Dashboard { DashboardId = 1 }, new Dashboard { DashboardId = 2 } };
            var dashboardRepoMock = new Mock<IDashboardRepository>();
            dashboardRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), 1)).Returns(dashboards);

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.DashboardRepository = dashboardRepoMock.Object;
            var result = dashboardController.Index() as ViewResult;

            // Assert
            Assert.AreEqual(dashboards, ((List<Dashboard>)result.Model));
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

            var dashboards = new List<Dashboard> { new Dashboard { DashboardId = 1 }, new Dashboard { DashboardId = 2 } };
            var dashboardRepoMock = new Mock<IDashboardRepository>();
            dashboardRepoMock.Setup(r => r.UpdateStatus(It.IsAny<string>()));
            dashboardRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), 1)).Returns(dashboards);

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.DashboardRepository = dashboardRepoMock.Object;
            var result = dashboardController.Index(null, "test", "test", "test") as ViewResult;

            // Assert
            dashboardRepoMock.Verify(r => r.UpdateStatus(It.IsAny<string>()), Times.Once());
            Assert.AreEqual(dashboards, ((List<Dashboard>)result.Model));
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

            var dashboardRepoMock = new Mock<IDashboardRepository>();
            dashboardRepoMock.Setup(r => r.GetById(It.IsAny<int>()));

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.DashboardRepository = dashboardRepoMock.Object;
            dashboardController.StatusRepository = statusRepoMock.Object;
            var result = dashboardController.Details(null, null) as ViewResult;

            // Assert
            dashboardRepoMock.Verify(r => r.GetById(It.IsAny<int>()), Times.Never());
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

            var dashboardRepoMock = new Mock<IDashboardRepository>();
            dashboardRepoMock.Setup(r => r.GetById(1)).Returns(new Dashboard { Status = 1 });

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.DashboardRepository = dashboardRepoMock.Object;
            dashboardController.StatusRepository = statusRepoMock.Object;
            var result = dashboardController.Details(1, null) as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        #endregion

        #region Details POST

        [Test]
        public void Details_PostMethod_Fail_InvalidDashboard()
        {
            // Arrange
            var dashboard = new Dashboard();

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ModelState.AddModelError("test", "test");
            var result = dashboardController.Details(dashboard) as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
        }

        [Test]
        public void Details_PostMethod_Success_UpdateDashboard()
        {
            // Arrange
            var dashboard = new Dashboard { DashboardId = 1, Status = 1 };

            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var dashBoardLevelRepoMock = new Mock<IDashboardLevelRepository>();
            dashBoardLevelRepoMock.Setup(r => r.GetList()).Returns(new List<Dashboard_Levels>());

            var dashboard_OrganisationRole_LevelsRepoMock = new Mock<IDashboard_OrganisationRole_LevelsRepository>();
            dashboard_OrganisationRole_LevelsRepoMock.Setup(r => r.GetList(1)).Returns(new List<Dashboard_OrganisationRole_Levels>());

            var dashboardRepoMock = new Mock<IDashboardRepository>();
            dashboardRepoMock.Setup(r => r.Update(dashboard));

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.DashboardRepository = dashboardRepoMock.Object;
            dashboardController.DashboardLevelRepository = dashBoardLevelRepoMock.Object;
            dashboardController.Dashboard_OrganisationRole_LevelsRepository = dashboard_OrganisationRole_LevelsRepoMock.Object;
            dashboardController.StatusRepository = statusRepoMock.Object;
            var result = dashboardController.Details(dashboard) as ViewResult;

            // Assert
            dashboardRepoMock.Verify(r => r.Update(dashboard), Times.Once());
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Success"));
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        [Test]
        public void Details_PostMethod_Success_InsertDashboard()
        {
            // Arrange
            var dashboard = new Dashboard { DashboardId = -1, Status = 1 };

            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var dashBoardLevelRepoMock = new Mock<IDashboardLevelRepository>();
            dashBoardLevelRepoMock.Setup(r => r.GetList()).Returns(new List<Dashboard_Levels>());

            var dashboardRepoMock = new Mock<IDashboardRepository>();
            dashboardRepoMock.Setup(r => r.Insert(dashboard));
            dashboardRepoMock.Setup(r => r.GetList("", "")).Returns(new List<Dashboard> { new Dashboard { DashboardId = 1 } });

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.DashboardRepository = dashboardRepoMock.Object;
            dashboardController.DashboardLevelRepository = dashBoardLevelRepoMock.Object;
            dashboardController.StatusRepository = statusRepoMock.Object;
            var result = dashboardController.Details(dashboard) as RedirectToRouteResult;

            // Assert
            dashboardRepoMock.Verify(r => r.Insert(dashboard), Times.Once());
            Assert.IsTrue(result.RouteValues["action"].ToString().Equals("index", StringComparison.InvariantCultureIgnoreCase));
            Assert.IsTrue(result.RouteValues["controller"].ToString().Equals("dashboard", StringComparison.InvariantCultureIgnoreCase));
        }

        #endregion

        #region Level 0

        [Test]
        public void Level0_Fail_NotHavePermission()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.SetupGet(r => r["reportpath"]).Returns("test");

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var dashboard_OrganisationRole_LevelsRepoMock = new Mock<IDashboard_OrganisationRole_LevelsRepository>();
            dashboard_OrganisationRole_LevelsRepoMock.Setup(r => r.HaveDashboardPermission(It.IsAny<bool>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(false);

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.Dashboard_OrganisationRole_LevelsRepository = dashboard_OrganisationRole_LevelsRepoMock.Object;
            //var result = dashboardController.Level0() as RedirectResult;

            //TODO: Base.AbsoluteUrl throws exception

            // Assert

        }

        [Test]
        public void Level0_Success()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var dashboard_OrganisationRole_LevelsRepoMock = new Mock<IDashboard_OrganisationRole_LevelsRepository>();
            dashboard_OrganisationRole_LevelsRepoMock.Setup(r => r.HaveDashboardPermission(It.IsAny<bool>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(true);

            var dashboardRepoMock = new Mock<IDashboardRepository>();
            var trafficLightRules = new List<Dashboard_Traffic_Light_Rule>{ new Dashboard_Traffic_Light_Rule{ Id = 1 }, new Dashboard_Traffic_Light_Rule{ Id = 2 } };
            dashboardRepoMock.Setup(r => r.GetList_TrafficLight(1)).Returns(trafficLightRules);

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.Dashboard_OrganisationRole_LevelsRepository = dashboard_OrganisationRole_LevelsRepoMock.Object;
            dashboardController.DashboardRepository = dashboardRepoMock.Object;
            dashboardController.UserRepository = userRepoMock.Object;
            //var result = dashboardController.Level0() as ViewResult;

            // Assert
            //Assert.AreEqual("", result.ViewName);
            //Assert.AreEqual(trafficLightRules, result.ViewBag.List_TrafficLight);

            // TODO: mock Base.GetConfig          
        }

        [Test]
        public void Level0_Fail_ThrowException()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.SetupGet(r => r["reportpath"]).Returns("test");

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var dashboard_OrganisationRole_LevelsRepoMock = new Mock<IDashboard_OrganisationRole_LevelsRepository>();
            dashboard_OrganisationRole_LevelsRepoMock.Setup(r => r.HaveDashboardPermission(It.IsAny<bool>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Throws<Exception>();

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.Dashboard_OrganisationRole_LevelsRepository = dashboard_OrganisationRole_LevelsRepoMock.Object;
            var result = dashboardController.Level0() as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsNotNull(result.ViewBag.ErrorAccess);
        }

        #endregion

        #region Level 1

        [Test]
        public void Level1_Fail_NotHavePermission()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.SetupGet(r => r["reportpath"]).Returns("test");

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var dashboard_OrganisationRole_LevelsRepoMock = new Mock<IDashboard_OrganisationRole_LevelsRepository>();
            dashboard_OrganisationRole_LevelsRepoMock.Setup(r => r.HaveDashboardPermission(It.IsAny<bool>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(false);

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.Dashboard_OrganisationRole_LevelsRepository = dashboard_OrganisationRole_LevelsRepoMock.Object;
            var result = dashboardController.Level1() as RedirectToRouteResult;

            // Assert
            Assert.AreEqual("index", result.RouteValues["action"]);
            Assert.AreEqual("welcome", result.RouteValues["controller"]);
        }

        [Test]
        public void Level1_Success()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var dashboard_OrganisationRole_LevelsRepoMock = new Mock<IDashboard_OrganisationRole_LevelsRepository>();
            dashboard_OrganisationRole_LevelsRepoMock.Setup(r => r.HaveDashboardPermission(It.IsAny<bool>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(true);

            var dashboardRepoMock = new Mock<IDashboardRepository>();
            var trafficLightRules = new List<Dashboard_Traffic_Light_Rule> { new Dashboard_Traffic_Light_Rule { Id = 1 }, new Dashboard_Traffic_Light_Rule { Id = 2 } };
            dashboardRepoMock.Setup(r => r.GetList_TrafficLight(1)).Returns(trafficLightRules);

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.Dashboard_OrganisationRole_LevelsRepository = dashboard_OrganisationRole_LevelsRepoMock.Object;
            dashboardController.DashboardRepository = dashboardRepoMock.Object;
            dashboardController.UserRepository = userRepoMock.Object;
            //var result = dashboardController.Level1() as ViewResult;

            // Assert
            //Assert.AreEqual("", result.ViewName);
            //Assert.AreEqual(trafficLightRules, result.ViewBag.List_TrafficLight);
        }

        [Test]
        public void Level1_Fail_ThrowException()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.SetupGet(r => r["reportpath"]).Returns("test");

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var dashboard_OrganisationRole_LevelsRepoMock = new Mock<IDashboard_OrganisationRole_LevelsRepository>();
            dashboard_OrganisationRole_LevelsRepoMock.Setup(r => r.HaveDashboardPermission(It.IsAny<bool>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Throws<Exception>();

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.Dashboard_OrganisationRole_LevelsRepository = dashboard_OrganisationRole_LevelsRepoMock.Object;
            var result = dashboardController.Level1() as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsNotNull(result.ViewBag.ErrorAccess);
        }

        #endregion

        #region Level 2

        [Test]
        public void Level2_Fail_NotHavePermission()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.SetupGet(r => r["reportpath"]).Returns("test");
            requestMock.SetupGet(r => r["type"]).Returns("test");

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var dashboard_OrganisationRole_LevelsRepoMock = new Mock<IDashboard_OrganisationRole_LevelsRepository>();
            dashboard_OrganisationRole_LevelsRepoMock.Setup(r => r.HaveDashboardPermission(It.IsAny<bool>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(false);

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.Dashboard_OrganisationRole_LevelsRepository = dashboard_OrganisationRole_LevelsRepoMock.Object;
            var result = dashboardController.Level2("test") as RedirectToRouteResult;

            // Assert
            Assert.AreEqual("index", result.RouteValues["action"]);
            Assert.AreEqual("welcome", result.RouteValues["controller"]);
        }

        [Test]
        public void Level2_Success()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.SetupGet(r => r["reportpath"]).Returns("test");

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var dashboard_OrganisationRole_LevelsRepoMock = new Mock<IDashboard_OrganisationRole_LevelsRepository>();
            dashboard_OrganisationRole_LevelsRepoMock.Setup(r => r.HaveDashboardPermission(It.IsAny<bool>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(true);

            var dashboardRepoMock = new Mock<IDashboardRepository>();
            var trafficLightRules = new List<Dashboard_Traffic_Light_Rule> { new Dashboard_Traffic_Light_Rule { Id = 1 }, new Dashboard_Traffic_Light_Rule { Id = 2 } };
            dashboardRepoMock.Setup(r => r.GetList_TrafficLight(1)).Returns(trafficLightRules);

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.Dashboard_OrganisationRole_LevelsRepository = dashboard_OrganisationRole_LevelsRepoMock.Object;
            dashboardController.DashboardRepository = dashboardRepoMock.Object;
            dashboardController.UserRepository = userRepoMock.Object;
            //var result = dashboardController.Level2("test_tmf") as ViewResult;

            // Assert
            //Assert.AreEqual("", result.ViewName);
            //Assert.AreEqual(trafficLightRules, result.ViewBag.List_TrafficLight);
        }

        [Test]
        public void Level2_Fail_ThrowException()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.SetupGet(r => r["reportpath"]).Returns("test");

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var dashboard_OrganisationRole_LevelsRepoMock = new Mock<IDashboard_OrganisationRole_LevelsRepository>();
            dashboard_OrganisationRole_LevelsRepoMock.Setup(r => r.HaveDashboardPermission(It.IsAny<bool>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Throws<Exception>();

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.Dashboard_OrganisationRole_LevelsRepository = dashboard_OrganisationRole_LevelsRepoMock.Object;
            var result = dashboardController.Level2("test") as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsNotNull(result.ViewBag.ErrorAccess);
        }

        #endregion

        #region Level 3

        [Test]
        public void Level3_Fail_NotHavePermission()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.SetupGet(r => r["reportpath"]).Returns("test");

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var dashboard_OrganisationRole_LevelsRepoMock = new Mock<IDashboard_OrganisationRole_LevelsRepository>();
            dashboard_OrganisationRole_LevelsRepoMock.Setup(r => r.HaveDashboardPermission(It.IsAny<bool>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(false);

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.Dashboard_OrganisationRole_LevelsRepository = dashboard_OrganisationRole_LevelsRepoMock.Object;
            var result = dashboardController.Level3("test") as RedirectToRouteResult;

            // Assert
            Assert.AreEqual("index", result.RouteValues["action"]);
            Assert.AreEqual("welcome", result.RouteValues["controller"]);
        }

        [Test]
        public void Level3_Success()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.SetupGet(r => r["reportpath"]).Returns("test");

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var dashboard_OrganisationRole_LevelsRepoMock = new Mock<IDashboard_OrganisationRole_LevelsRepository>();
            dashboard_OrganisationRole_LevelsRepoMock.Setup(r => r.HaveDashboardPermission(It.IsAny<bool>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(true);

            var dashboardRepoMock = new Mock<IDashboardRepository>();
            var trafficLightRules = new List<Dashboard_Traffic_Light_Rule> { new Dashboard_Traffic_Light_Rule { Id = 1 }, new Dashboard_Traffic_Light_Rule { Id = 2 } };
            dashboardRepoMock.Setup(r => r.GetList_TrafficLight(1)).Returns(trafficLightRules);

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.Dashboard_OrganisationRole_LevelsRepository = dashboard_OrganisationRole_LevelsRepoMock.Object;
            dashboardController.DashboardRepository = dashboardRepoMock.Object;
            dashboardController.UserRepository = userRepoMock.Object;
            //var result = dashboardController.Level3("test_tmf") as ViewResult;

            // Assert
            //Assert.AreEqual("", result.ViewName);
            //Assert.AreEqual(trafficLightRules, result.ViewBag.List_TrafficLight);
        }

        [Test]
        public void Level3_Fail_ThrowException()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.SetupGet(r => r["reportpath"]).Returns("test");

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var dashboard_OrganisationRole_LevelsRepoMock = new Mock<IDashboard_OrganisationRole_LevelsRepository>();
            dashboard_OrganisationRole_LevelsRepoMock.Setup(r => r.HaveDashboardPermission(It.IsAny<bool>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Throws<Exception>();

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.Dashboard_OrganisationRole_LevelsRepository = dashboard_OrganisationRole_LevelsRepoMock.Object;
            var result = dashboardController.Level3("test") as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsNotNull(result.ViewBag.ErrorAccess);
        }

        #endregion

        #region Level 4

        [Test]
        public void Level4_Fail_NotHavePermission()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.SetupGet(r => r["reportpath"]).Returns("test");

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var dashboard_OrganisationRole_LevelsRepoMock = new Mock<IDashboard_OrganisationRole_LevelsRepository>();
            dashboard_OrganisationRole_LevelsRepoMock.Setup(r => r.HaveDashboardPermission(It.IsAny<bool>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(false);

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.Dashboard_OrganisationRole_LevelsRepository = dashboard_OrganisationRole_LevelsRepoMock.Object;
            var result = dashboardController.Level4("test") as RedirectToRouteResult;

            // Assert
            Assert.AreEqual("index", result.RouteValues["action"]);
            Assert.AreEqual("welcome", result.RouteValues["controller"]);
        }

        [Test]
        public void Level4_Success()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.SetupGet(r => r["reportpath"]).Returns("test");

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var dashboard_OrganisationRole_LevelsRepoMock = new Mock<IDashboard_OrganisationRole_LevelsRepository>();
            dashboard_OrganisationRole_LevelsRepoMock.Setup(r => r.HaveDashboardPermission(It.IsAny<bool>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(true);

            var dashboardRepoMock = new Mock<IDashboardRepository>();
            var trafficLightRules = new List<Dashboard_Traffic_Light_Rule> { new Dashboard_Traffic_Light_Rule { Id = 1 }, new Dashboard_Traffic_Light_Rule { Id = 2 } };
            dashboardRepoMock.Setup(r => r.GetList_TrafficLight(1)).Returns(trafficLightRules);

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.Dashboard_OrganisationRole_LevelsRepository = dashboard_OrganisationRole_LevelsRepoMock.Object;
            dashboardController.DashboardRepository = dashboardRepoMock.Object;
            dashboardController.UserRepository = userRepoMock.Object;
            //var result = dashboardController.Level4("test_tmf") as ViewResult;

            // Assert
            //Assert.AreEqual("", result.ViewName);
            //Assert.AreEqual(trafficLightRules, result.ViewBag.List_TrafficLight);
        }

        [Test]
        public void Level4_Fail_ThrowException()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.SetupGet(r => r["reportpath"]).Returns("test");

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var dashboard_OrganisationRole_LevelsRepoMock = new Mock<IDashboard_OrganisationRole_LevelsRepository>();
            dashboard_OrganisationRole_LevelsRepoMock.Setup(r => r.HaveDashboardPermission(It.IsAny<bool>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Throws<Exception>();

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.Dashboard_OrganisationRole_LevelsRepository = dashboard_OrganisationRole_LevelsRepoMock.Object;
            var result = dashboardController.Level4("test") as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsNotNull(result.ViewBag.ErrorAccess);
        }

        #endregion

        #region Level 5

        [Test]
        public void Level5_Fail_NotHavePermission()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.SetupGet(r => r["reportpath"]).Returns("test");

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var dashboard_OrganisationRole_LevelsRepoMock = new Mock<IDashboard_OrganisationRole_LevelsRepository>();
            dashboard_OrganisationRole_LevelsRepoMock.Setup(r => r.HaveDashboardPermission(It.IsAny<bool>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(false);

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.Dashboard_OrganisationRole_LevelsRepository = dashboard_OrganisationRole_LevelsRepoMock.Object;
            var result = dashboardController.Level5("test") as RedirectToRouteResult;

            // Assert
            Assert.AreEqual("index", result.RouteValues["action"]);
            Assert.AreEqual("welcome", result.RouteValues["controller"]);
        }

        [Test]
        public void Level5_Success()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.SetupGet(r => r["reportpath"]).Returns("test");

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var dashboard_OrganisationRole_LevelsRepoMock = new Mock<IDashboard_OrganisationRole_LevelsRepository>();
            dashboard_OrganisationRole_LevelsRepoMock.Setup(r => r.HaveDashboardPermission(It.IsAny<bool>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(true);

            var dashboardRepoMock = new Mock<IDashboardRepository>();
            var trafficLightRules = new List<Dashboard_Traffic_Light_Rule> { new Dashboard_Traffic_Light_Rule { Id = 1 }, new Dashboard_Traffic_Light_Rule { Id = 2 } };
            dashboardRepoMock.Setup(r => r.GetList_TrafficLight(1)).Returns(trafficLightRules);

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.Dashboard_OrganisationRole_LevelsRepository = dashboard_OrganisationRole_LevelsRepoMock.Object;
            dashboardController.DashboardRepository = dashboardRepoMock.Object;
            dashboardController.UserRepository = userRepoMock.Object;
            //var result = dashboardController.Level5("test_tmf") as ViewResult;

            // Assert
            //Assert.AreEqual("", result.ViewName);
            //Assert.AreEqual(trafficLightRules, result.ViewBag.List_TrafficLight);
        }

        [Test]
        public void Level5_Fail_ThrowException()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.SetupGet(r => r["reportpath"]).Returns("test");

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var dashboard_OrganisationRole_LevelsRepoMock = new Mock<IDashboard_OrganisationRole_LevelsRepository>();
            dashboard_OrganisationRole_LevelsRepoMock.Setup(r => r.HaveDashboardPermission(It.IsAny<bool>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Throws<Exception>();

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            dashboardController.Dashboard_OrganisationRole_LevelsRepository = dashboard_OrganisationRole_LevelsRepoMock.Object;
            var result = dashboardController.Level5("test") as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsNotNull(result.ViewBag.ErrorAccess);
        }

        #endregion

        #region Raw data

        [Test]
        public void RawData_Success()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            // Act
            var dashboardController = new DashboardController();
            dashboardController.ControllerContext = controllerContextMock.Object;
            var result = dashboardController.RawData("test") as ViewResult;

            //TODO: can not mock ReportParameterService

            // Assert
            //Assert.AreEqual("", result.ViewName);
            //Assert.IsNotNull(result.ViewBag.ReportParams);
            //Assert.AreEqual("tmftest", result.ViewBag.ReportPath);
        }

        [Test]
        public void RawData_ThrowException()
        {
            //TODO: can not mock ReportParameterService
        }

        #endregion

        #region Cache

        [Test]
        public void Cache_Fail_SessionNull()
        {
            //TODO: can not mock Cache
        }

        [Test]
        public void Cache_Fail_NotSystemUser()
        {
            //TODO: can not mock Cache
        }

        [Test]
        public void Cache_Success()
        {
            //TODO: can not mock Cache
        }

        [Test]
        public void Cache_Fail_ThrowException()
        {
            //TODO: can not mock Cache
        }

        #endregion
    }
}
