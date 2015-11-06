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
    public class DashboardTimeAccessControllerTests : BaseControllerTests
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

            var timeAccessList = new List<Dashboard_TimeAccess> { new Dashboard_TimeAccess { Id = 1 }, new Dashboard_TimeAccess { Id = 2 } };
            var timeAccessRepoMock = new Mock<IDashboard_TimeAccessRepository>();
            timeAccessRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<int>())).Returns(timeAccessList);

            // Act
            var controller = new Dashboard_TimeAccessController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.Dashboard_TimeAccessRepository = timeAccessRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            var result = controller.Index("test", "test") as ViewResult;

            // Assert
            Assert.AreEqual(timeAccessList, ((List<Dashboard_TimeAccess>)result.Model));
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

            var timeAccessList = new List<Dashboard_TimeAccess> { new Dashboard_TimeAccess { Id = 1 }, new Dashboard_TimeAccess { Id = 2 } };
            var timeAccessRepoMock = new Mock<IDashboard_TimeAccessRepository>();
            timeAccessRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<int>())).Returns(timeAccessList);

            // Act
            var controller = new Dashboard_TimeAccessController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.Dashboard_TimeAccessRepository = timeAccessRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            var result = controller.Index(null, "test", "test", "test") as ViewResult;

            // Assert
            Assert.AreEqual(timeAccessList, ((List<Dashboard_TimeAccess>)result.Model));
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

            var timeAccessRepoMock = new Mock<IDashboard_TimeAccessRepository>();
            timeAccessRepoMock.Setup(r => r.GetById(It.IsAny<int>()));

            // Act
            var controller = new Dashboard_TimeAccessController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.Dashboard_TimeAccessRepository = timeAccessRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            var result = controller.Details((int?)null) as ViewResult;

            // Assert
            timeAccessRepoMock.Verify(r => r.GetById(It.IsAny<int>()), Times.Never());
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

            var timeAccessRepoMock = new Mock<IDashboard_TimeAccessRepository>();
            timeAccessRepoMock.Setup(r => r.GetById(1)).Returns(new Dashboard_TimeAccess { Id = 1 });

            // Act
            var controller = new Dashboard_TimeAccessController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.Dashboard_TimeAccessRepository = timeAccessRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            var result = controller.Details(1) as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            //var cboSystemSite = (SelectList)result.ViewBag.cboSystemSite;
            //Assert.AreEqual(1, cboSystemSite.SelectedValue);
        }

        #endregion

        #region Details POST

        public void Details_PostMethod()
        {
        }

        #endregion
    }
}
