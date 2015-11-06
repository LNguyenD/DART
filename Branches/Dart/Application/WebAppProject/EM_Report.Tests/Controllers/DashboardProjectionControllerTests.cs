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
    public class DashboardProjectionControllerTests : BaseControllerTests
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

            var projections = new List<Dashboard_Projection> { new Dashboard_Projection { Id = 1 }, new Dashboard_Projection { Id = 2 } };
            var projectionRepoMock = new Mock<IDashboard_ProjectionRepository>();
            projectionRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(projections);

            // Act
            var controller = new Dashboard_ProjectionController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.Dashboard_ProjectionRepository = projectionRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            var result = controller.Index("test", "test") as ViewResult;

            // Assert
            Assert.AreEqual(projections, ((List<Dashboard_Projection>)result.Model));
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

            var projections = new List<Dashboard_Projection> { new Dashboard_Projection { Id = 1 }, new Dashboard_Projection { Id = 2 } };
            var projectionRepoMock = new Mock<IDashboard_ProjectionRepository>();
            projectionRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(projections);

            // Act
            var controller = new Dashboard_ProjectionController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.Dashboard_ProjectionRepository = projectionRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            var result = controller.Index(null, "test", "test", "test") as ViewResult;

            // Assert
            Assert.AreEqual(projections, ((List<Dashboard_Projection>)result.Model));
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

            var projectionRepoMock = new Mock<IDashboard_ProjectionRepository>();
            projectionRepoMock.Setup(r => r.GetById(It.IsAny<string>(), It.IsAny<int>()));

            // Act
            var controller = new Dashboard_ProjectionController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.Dashboard_ProjectionRepository = projectionRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            var result = controller.Details((int?)null) as ViewResult;

            // Assert
            projectionRepoMock.Verify(r => r.GetById(It.IsAny<string>(), It.IsAny<int>()), Times.Never());
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

            var projectionRepoMock = new Mock<IDashboard_ProjectionRepository>();
            projectionRepoMock.Setup(r => r.GetById("tmf", 1)).Returns(new Dashboard_Projection { Id = 1 });

            // Act
            var controller = new Dashboard_ProjectionController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.Dashboard_ProjectionRepository = projectionRepoMock.Object;
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
            var projection = new Dashboard_Projection { Id = 1 };

            // Act
            var controller = new Dashboard_ProjectionController();
            controller.ModelState.AddModelError("test", "test");
            controller.UserRepository = userRepoMock.Object;
            var result = controller.Details(projection) as ViewResult;

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

            var projection = new Dashboard_Projection { Id = 1 };

            var projectionRepoMock = new Mock<IDashboard_ProjectionRepository>();
            projectionRepoMock.Setup(r => r.Update("tmf", projection));

            // Act
            var controller = new Dashboard_ProjectionController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.Dashboard_ProjectionRepository = projectionRepoMock.Object;
            var result = controller.Details(projection) as ViewResult;

            // Assert
            projectionRepoMock.Verify(r => r.Update("tmf", projection), Times.Once());
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

            var projection = new Dashboard_Projection { Id = -1 };

            var projectionRepoMock = new Mock<IDashboard_ProjectionRepository>();
            projectionRepoMock.Setup(r => r.Insert("tmf", projection));

            // Act
            var controller = new Dashboard_ProjectionController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.Dashboard_ProjectionRepository = projectionRepoMock.Object;
            var result = controller.Details(projection) as RedirectToRouteResult;

            // Assert
            projectionRepoMock.Verify(r => r.Insert("tmf", projection), Times.Once());
            Assert.IsTrue(result.RouteValues["action"].ToString().Equals("Index", StringComparison.InvariantCultureIgnoreCase));
            Assert.IsTrue(result.RouteValues["controller"].ToString().Equals("Dashboard_Projection", StringComparison.InvariantCultureIgnoreCase));
        }

        #endregion

        #region Import POST

        [Test]
        public void Import_PostMethod_Fail_InvalidModel()
        {
            // Arrange

            // Act
            var controller = new Dashboard_ProjectionController();
            controller.ModelState.AddModelError("test", "test");
            var result = controller.Import(new Dashboard_Projection_Import()) as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
        }

        [Test]
        public void Import_PostMethod_Success_ProcessData()
        {
        }

        [Test]
        public void Import_PostMethod_Success_SubmitData()
        {
        }

        #endregion

        #region Delete all

        [Test]
        public void DeleteAll_Success()
        {
            // Arrange
            var projectionRepoMock = new Mock<IDashboard_ProjectionRepository>();
            projectionRepoMock.Setup(r => r.DeleteAll(It.IsAny<string>()));

            // Act
            var controller = new Dashboard_ProjectionController();
            controller.Dashboard_ProjectionRepository = projectionRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            var result = controller.DeleteAll(1) as HttpStatusCodeResult;

            // Assert
            Assert.AreEqual(200, result.StatusCode);
        }

        [Test]
        public void DeleteAll_Fail_ThrowException()
        {
            // Arrange
            var projectionRepoMock = new Mock<IDashboard_ProjectionRepository>();
            projectionRepoMock.Setup(r => r.DeleteAll(It.IsAny<string>())).Throws<Exception>();

            // Act
            var controller = new Dashboard_ProjectionController();
            controller.Dashboard_ProjectionRepository = projectionRepoMock.Object;
            var result = controller.DeleteAll(1) as HttpStatusCodeResult;

            // Assert
            Assert.AreEqual(500, result.StatusCode);
        }

        #endregion
    }
}
