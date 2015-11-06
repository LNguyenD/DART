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
    public class ExternalControllerTests : BaseControllerTests
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

            var externalGroups = new List<External_Group> { new External_Group { External_GroupId = 1 }, new External_Group { External_GroupId = 2 } };
            var externalGroupRepoMock = new Mock<IExternal_GroupRepository>();
            externalGroupRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), GroupStatusFilter.All)).Returns(externalGroups);

            // Act
            var controller = new ExternalController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.External_GroupRepository = externalGroupRepoMock.Object;
            var result = controller.Index() as ViewResult;

            // Assert
            Assert.AreEqual(externalGroups, ((List<External_Group>)result.Model));
            Assert.AreEqual("", result.ViewName);
        }

        #endregion

        #region Index POST

        //[Test]
        //public void Index_PostMethod()
        //{
        //    // Arrange
        //    var formData = new NameValueCollection();
        //    formData.Add("cboDisplayEntry", "10");
        //    var requestMock = new Mock<HttpRequestBase>();
        //    requestMock.MockFormData(formData).MockCookies();
        //    requestMock.SetupGet(r => r["systemid"]).Returns("1");
        //    requestMock.SetupGet(r => r["cboSystem"]).Returns("1");
        //    requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));
        //    requestMock.SetupGet(r => r.UrlReferrer).Returns(new Uri("http://localhost?systemid=1"));

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var externalGroups = new List<External_Group> { new External_Group { External_GroupId = 1 }, new External_Group { External_GroupId = 2 } };
        //    var externalGroupRepoMock = new Mock<IExternal_GroupRepository>();
        //    externalGroupRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), GroupStatusFilter.All)).Returns(externalGroups);

        //    // Act
        //    var controller = new ExternalController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    controller.External_GroupRepository = externalGroupRepoMock.Object;
        //    var result = controller.Index(null, "test", "test", "test") as ViewResult;

        //    // Assert
        //    Assert.AreEqual(externalGroups, ((List<External_Group>)result.Model));
        //    Assert.AreEqual("", result.ViewName);
        //    Assert.AreEqual(10, result.ViewBag.PageSize);
        //}

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

            var externalGroupRepoMock = new Mock<IExternal_GroupRepository>();
            externalGroupRepoMock.Setup(r => r.GetById(It.IsAny<int>()));

            // Act
            var controller = new ExternalController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.External_GroupRepository = externalGroupRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.Details((int?)null) as ViewResult;

            // Assert
            externalGroupRepoMock.Verify(r => r.GetById(It.IsAny<int>()), Times.Never());
            Assert.AreEqual("", result.ViewName);
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(0, cboStatus.SelectedValue);
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

            var externalGroupRepoMock = new Mock<IExternal_GroupRepository>();
            externalGroupRepoMock.Setup(r => r.GetById(1)).Returns(new External_Group { External_GroupId = 1, Status = 1 });

            // Act
            var controller = new ExternalController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.External_GroupRepository = externalGroupRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.Details(1) as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        #endregion

        #region Details POST

        [Test]
        public void Details_PostMethod_InvalidExternalGroup()
        {
            // Arrange
            var externalGroup = new External_Group { External_GroupId = 1, Status = 1 };

            // Act
            var controller = new ExternalController();
            controller.ModelState.AddModelError("test", "test");
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.Details(externalGroup) as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        [Test]
        public void Details_PostMethod_UpdateExternalGroup()
        {
            // Arrange
            var queryStrings = new NameValueCollection();
            queryStrings.Add("systemid", "1");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockQueryStrings(queryStrings).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var externalGroup = new External_Group { External_GroupId = 1, Status = 1 };

            var externalGroupRepoMock = new Mock<IExternal_GroupRepository>();
            externalGroupRepoMock.Setup(r => r.Update(externalGroup));

            // Act
            var controller = new ExternalController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            controller.External_GroupRepository = externalGroupRepoMock.Object;
            var result = controller.Details(externalGroup) as ViewResult;

            // Assert
            externalGroupRepoMock.Verify(r => r.Update(externalGroup), Times.Once());
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Success"));
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        [Test]
        public void Details_PostMethod_InsertExternalGroup()
        {
            // Arrange
            var queryStrings = new NameValueCollection();
            queryStrings.Add("systemid", "1");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockQueryStrings(queryStrings).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var externalGroup = new External_Group { External_GroupId = -1 };

            var externalGroupRepoMock = new Mock<IExternal_GroupRepository>();
            externalGroupRepoMock.Setup(r => r.Insert(externalGroup));

            // Act
            var controller = new ExternalController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.External_GroupRepository = externalGroupRepoMock.Object;
            var result = controller.Details(externalGroup) as RedirectToRouteResult;

            // Assert
            externalGroupRepoMock.Verify(r => r.Insert(externalGroup), Times.Once());
            Assert.IsTrue(result.RouteValues["action"].ToString().Equals("Index", StringComparison.InvariantCultureIgnoreCase));
            Assert.IsTrue(result.RouteValues["controller"].ToString().Equals("External", StringComparison.InvariantCultureIgnoreCase));
        }

        #endregion
    }
}
