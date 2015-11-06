using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using EM_Report.Domain;
using EM_Report.Repositories;
using EM_Report.Controllers;
using Moq;
using System.Web;
using EM_Report.Tests.Helpers;
using EM_Report.Helpers;
using System.Web.Mvc;
using System.Collections.Specialized;

namespace EM_Report.Tests.Controllers
{
    [TestFixture]
    public class DashboardGraphDescriptionControllerTests : BaseControllerTests
    {
        #region Get all description

        [Test]
        public void GetAllDescription_SystemIdNull()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var graphDescriptions = new List<Dashboard_Graph_Description>();
            var graphDescriptionRepoMock = new Mock<IDashboard_Graph_DescriptionRepository>();
            graphDescriptionRepoMock.Setup(r => r.GetList(It.IsAny<string>(), 1)).Returns(graphDescriptions);

            // Act
            var graphDescriptionController = new Dashboard_Graph_DescriptionController();
            graphDescriptionController.ControllerContext = controllerContextMock.Object;
            graphDescriptionController.Dashboard_Graph_DescriptionRepository = graphDescriptionRepoMock.Object;
            var result = graphDescriptionController.GetAllDescription("1", "test") as PartialViewResult;

            // Assert
            Assert.AreEqual("GetAllDescription", result.ViewName);
            Assert.AreEqual(graphDescriptions, result.ViewData.Model);
        }

        [Test]
        public void GetAllDescription_SystemIdNotNull()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var graphDescriptions = new List<Dashboard_Graph_Description>();
            var graphDescriptionRepoMock = new Mock<IDashboard_Graph_DescriptionRepository>();
            graphDescriptionRepoMock.Setup(r => r.GetList()).Returns(graphDescriptions);

            // Act
            var graphDescriptionController = new Dashboard_Graph_DescriptionController();
            graphDescriptionController.ControllerContext = controllerContextMock.Object;
            graphDescriptionController.Dashboard_Graph_DescriptionRepository = graphDescriptionRepoMock.Object;
            var result = graphDescriptionController.GetAllDescription(null, "test") as PartialViewResult;

            // Assert
            Assert.AreEqual("GetAllDescription", result.ViewName);
            Assert.AreEqual(graphDescriptions, result.ViewData.Model);
        }

        #endregion

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

            var graphDescriptions = new List<Dashboard_Graph_Description> { new Dashboard_Graph_Description { DescriptionId = 1 }, new Dashboard_Graph_Description { DescriptionId = 2 } };
            var graphDescriptionRepoMock = new Mock<IDashboard_Graph_DescriptionRepository>();
            graphDescriptionRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), 1)).Returns(graphDescriptions);

            // Act
            var controller = new Dashboard_Graph_DescriptionController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.Dashboard_Graph_DescriptionRepository = graphDescriptionRepoMock.Object;
            var result = controller.Index("test", "test") as ViewResult;

            // Assert
            Assert.AreEqual(graphDescriptions, ((List<Dashboard_Graph_Description>)result.Model));
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

            var graphDescriptions = new List<Dashboard_Graph_Description> { new Dashboard_Graph_Description { DescriptionId = 1 }, new Dashboard_Graph_Description { DescriptionId = 2 } };
            var graphDescriptionRepoMock = new Mock<IDashboard_Graph_DescriptionRepository>();
            graphDescriptionRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), 0)).Returns(graphDescriptions);

            // Act
            var controller = new Dashboard_Graph_DescriptionController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.Dashboard_Graph_DescriptionRepository = graphDescriptionRepoMock.Object;
            var result = controller.Index(null, "test", "test", "test") as ViewResult;

            // Assert
            Assert.AreEqual(graphDescriptions, ((List<Dashboard_Graph_Description>)result.Model));
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

            var graphDescriptionRepoMock = new Mock<IDashboard_Graph_DescriptionRepository>();
            graphDescriptionRepoMock.Setup(r => r.GetById(It.IsAny<int>()));

            // Act
            var controller = new Dashboard_Graph_DescriptionController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.Dashboard_Graph_DescriptionRepository = graphDescriptionRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            var result = controller.Details((int?)null) as ViewResult;

            // Assert
            graphDescriptionRepoMock.Verify(r => r.GetById(It.IsAny<int>()), Times.Never());
            Assert.AreEqual("", result.ViewName);
            var cboSystemSite = result.ViewBag.cboSystemSite;
            Assert.AreEqual(systems, cboSystemSite);
        }

        [Test]
        public void Details_GetMethod_IdNotNull()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var graphDescriptionRepoMock = new Mock<IDashboard_Graph_DescriptionRepository>();
            graphDescriptionRepoMock.Setup(r => r.GetById(1)).Returns(new Dashboard_Graph_Description { DescriptionId = 1 });

            // Act
            var controller = new Dashboard_Graph_DescriptionController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.Dashboard_Graph_DescriptionRepository = graphDescriptionRepoMock.Object;
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
            var graphDescription = new Dashboard_Graph_Description { DescriptionId = 1 };

            // Act
            var controller = new Dashboard_Graph_DescriptionController();
            controller.ModelState.AddModelError("test", "test");
            controller.UserRepository = userRepoMock.Object;
            var result = controller.Details(graphDescription) as ViewResult;

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
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var graphDescription = new Dashboard_Graph_Description { DescriptionId = 1 };

            var graphDescriptionRepoMock = new Mock<IDashboard_Graph_DescriptionRepository>();
            graphDescriptionRepoMock.Setup(r => r.Update(graphDescription));

            // Act
            var controller = new Dashboard_Graph_DescriptionController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.Dashboard_Graph_DescriptionRepository = graphDescriptionRepoMock.Object;
            var result = controller.Details(graphDescription) as ViewResult;

            // Assert
            graphDescriptionRepoMock.Verify(r => r.Update(graphDescription), Times.Once());
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Success"));
            var cboSystemSite = (SelectList)result.ViewBag.cboSystemSite;
            Assert.AreEqual(1, cboSystemSite.SelectedValue);
        }

        [Test]
        public void Details_PostMethod_Success_InsertModel()
        {
            // Arrange
            var formData = new FormCollection();
            formData.Add("chkSystem_test", "1");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var graphDescription = new Dashboard_Graph_Description { DescriptionId = -1 };

            var graphDescriptionRepoMock = new Mock<IDashboard_Graph_DescriptionRepository>();
            graphDescriptionRepoMock.Setup(r => r.Insert(graphDescription));

            // Act
            var controller = new Dashboard_Graph_DescriptionController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.Dashboard_Graph_DescriptionRepository = graphDescriptionRepoMock.Object;
            var result = controller.Details(graphDescription) as RedirectToRouteResult;

            // Assert
            graphDescriptionRepoMock.Verify(r => r.Insert(graphDescription), Times.AtLeastOnce());
            Assert.IsTrue(result.RouteValues["action"].ToString().Equals("Index", StringComparison.InvariantCultureIgnoreCase));
            Assert.IsTrue(result.RouteValues["controller"].ToString().Equals("Dashboard_Graph_Description", StringComparison.InvariantCultureIgnoreCase));
        }

        #endregion

        #region Import POST

        [Test]
        public void Import_PostMethod_Fail_InvalidModel()
        {
            // Arrange

            // Act
            var controller = new Dashboard_Graph_DescriptionController();
            controller.ModelState.AddModelError("test", "test");
            var result = controller.Import(new Dashboard_Graph_Description_Import()) as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
        }

        [Test]
        public void Import_PostMethod_Success_ProcessData()
        {
            // TODO mock import helper
        }

        [Test]
        public void Import_PostMethod_Success_SubmitData()
        {
            // TODO mock import helper
        }

        #endregion

        #region Delete all

        [Test]
        public void DeleteAll_Success()
        {
            // Arrange
            var graphDescriptionRepoMock = new Mock<IDashboard_Graph_DescriptionRepository>();
            graphDescriptionRepoMock.Setup(r => r.DeleteAll());

            // Act
            var controller = new Dashboard_Graph_DescriptionController();
            controller.Dashboard_Graph_DescriptionRepository = graphDescriptionRepoMock.Object;
            var result = controller.DeleteAll() as HttpStatusCodeResult;

            // Assert
            Assert.AreEqual(200, result.StatusCode);
        }

        [Test]
        public void DeleteAll_Fail_ThrowException()
        {
            // Arrange
            var graphDescriptionRepoMock = new Mock<IDashboard_Graph_DescriptionRepository>();
            graphDescriptionRepoMock.Setup(r => r.DeleteAll()).Throws<Exception>();

            // Act
            var controller = new Dashboard_Graph_DescriptionController();
            controller.Dashboard_Graph_DescriptionRepository = graphDescriptionRepoMock.Object;
            var result = controller.DeleteAll() as HttpStatusCodeResult;

            // Assert
            Assert.AreEqual(500, result.StatusCode);
        }

        #endregion
    }
}
