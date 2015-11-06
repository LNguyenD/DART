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
    public class DashboardTargetBaseControllerTests : BaseControllerTests
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

            var targetBaseList = new List<Dashboard_Target_Base> { new Dashboard_Target_Base { Id = 1 }, new Dashboard_Target_Base { Id = 2 } };
            var targetBaseRepoMock = new Mock<IDashboard_Target_BaseRepository>();
            targetBaseRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(targetBaseList);

            // Act
            var controller = new Dashboard_Target_BaseController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.Dashboard_Target_BaseRepository = targetBaseRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            var result = controller.Index("test", "test") as ViewResult;

            // Assert
            Assert.AreEqual(targetBaseList, ((List<Dashboard_Target_Base>)result.Model));
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
            requestMock.SetupGet(r => r.UrlReferrer).Returns(new Uri("http://localhost?systemid=1"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var targetBaseList = new List<Dashboard_Target_Base> { new Dashboard_Target_Base { Id = 1 }, new Dashboard_Target_Base { Id = 2 } };
            var targetBaseRepoMock = new Mock<IDashboard_Target_BaseRepository>();
            targetBaseRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(targetBaseList);

            // Act
            var controller = new Dashboard_Target_BaseController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.Dashboard_Target_BaseRepository = targetBaseRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            var result = controller.Index(null, "test", "test", "test") as ViewResult;

            // Assert
            Assert.AreEqual(targetBaseList, ((List<Dashboard_Target_Base>)result.Model));
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

            var targetBaseRepoMock = new Mock<IDashboard_Target_BaseRepository>();
            targetBaseRepoMock.Setup(r => r.GetById(It.IsAny<string>(), It.IsAny<int>()));

            // Act
            var controller = new Dashboard_Target_BaseController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.Dashboard_Target_BaseRepository = targetBaseRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            var result = controller.Details((int?)null) as ViewResult;

            // Assert
            targetBaseRepoMock.Verify(r => r.GetById(It.IsAny<string>(), It.IsAny<int>()), Times.Never());
            Assert.AreEqual("", result.ViewName);
            var cboSystemSite = result.ViewBag.cboSystemSite;
            Assert.AreEqual(systems, cboSystemSite);
        }

        [Test]
        public void Details_GetMethod_IdNotNull()
        {
            // Arrange
            var queryStrings = new NameValueCollection();
            queryStrings.Add("systemid", "1");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockQueryStrings(queryStrings).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var targetBaseRepoMock = new Mock<IDashboard_Target_BaseRepository>();
            targetBaseRepoMock.Setup(r => r.GetById("tmf", 1)).Returns(new Dashboard_Target_Base { Id = 1 });

            // Act
            var controller = new Dashboard_Target_BaseController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.Dashboard_Target_BaseRepository = targetBaseRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            var result = controller.Details(1) as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            var cboSystemSite = (SelectList)result.ViewBag.cboSystemSite;
            Assert.AreEqual(1, cboSystemSite.SelectedValue);
        }

        #endregion

        #region Details POST

        [Test]
        public void Details_PostMethod_Fail_InvalidModel()
        {
            // Arrange
            var targetBase = new Dashboard_Target_Base { Id = 1 };

            // Act
            var controller = new Dashboard_Target_BaseController();
            controller.ModelState.AddModelError("test", "test");
            controller.UserRepository = userRepoMock.Object;
            var result = controller.Details(targetBase) as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
            var cboSystemSite = (SelectList)result.ViewBag.cboSystemSite;
            Assert.AreEqual(1, cboSystemSite.SelectedValue);
        }

        [Test]
        public void Details_PostMethod_Success_UpdateModel()
        {
            // Arrange
            var queryStrings = new NameValueCollection();
            queryStrings.Add("systemid", "1");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockQueryStrings(queryStrings).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var targetBase = new Dashboard_Target_Base { Id = 1 };

            var targetBaseRepoMock = new Mock<IDashboard_Target_BaseRepository>();
            targetBaseRepoMock.Setup(r => r.Update("tmf", targetBase));

            // Act
            var controller = new Dashboard_Target_BaseController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.Dashboard_Target_BaseRepository = targetBaseRepoMock.Object;
            var result = controller.Details(targetBase) as ViewResult;

            // Assert
            targetBaseRepoMock.Verify(r => r.Update("tmf", targetBase), Times.Once());
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Success"));
            var cboSystemSite = (SelectList)result.ViewBag.cboSystemSite;
            Assert.AreEqual(1, cboSystemSite.SelectedValue);
        }

        [Test]
        public void Details_PostMethod_Success_InsertModel()
        {
            // Arrange
            var queryStrings = new NameValueCollection();
            queryStrings.Add("systemid", "1");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockQueryStrings(queryStrings).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var targetBase = new Dashboard_Target_Base { Id = -1 };

            var targetBaseRepoMock = new Mock<IDashboard_Target_BaseRepository>();
            targetBaseRepoMock.Setup(r => r.Insert("tmf", targetBase));

            // Act
            var controller = new Dashboard_Target_BaseController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.Dashboard_Target_BaseRepository = targetBaseRepoMock.Object;
            var result = controller.Details(targetBase) as RedirectToRouteResult;

            // Assert
            targetBaseRepoMock.Verify(r => r.Insert("tmf", targetBase), Times.Once());
            Assert.IsTrue(result.RouteValues["action"].ToString().Equals("Index", StringComparison.InvariantCultureIgnoreCase));
            Assert.IsTrue(result.RouteValues["controller"].ToString().Equals("Dashboard_Target_Base", StringComparison.InvariantCultureIgnoreCase));
        }

        #endregion

        #region Delete all

        [Test]
        public void DeleteAll_Success()
        {
            // Arrange
            var targetBaseRepoMock = new Mock<IDashboard_Target_BaseRepository>();
            targetBaseRepoMock.Setup(r => r.DeleteAll(It.IsAny<string>()));

            // Act
            var controller = new Dashboard_Target_BaseController();
            controller.Dashboard_Target_BaseRepository = targetBaseRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            var result = controller.DeleteAll(1) as HttpStatusCodeResult;

            // Assert
            Assert.AreEqual(200, result.StatusCode);
        }

        [Test]
        public void DeleteAll_Fail_ThrowException()
        {
            // Arrange
            var targetBaseRepoMock = new Mock<IDashboard_Target_BaseRepository>();
            targetBaseRepoMock.Setup(r => r.DeleteAll(It.IsAny<string>())).Throws<Exception>();

            // Act
            var controller = new Dashboard_Target_BaseController();
            controller.Dashboard_Target_BaseRepository = targetBaseRepoMock.Object;
            var result = controller.DeleteAll(1) as HttpStatusCodeResult;

            // Assert
            Assert.AreEqual(500, result.StatusCode);
        }

        #endregion
    }
}
