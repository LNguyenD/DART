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
using EM_Report.Domain.Enums;

namespace EM_Report.Tests.Controllers
{
    [TestFixture]
    public class ReportControllerTests : BaseControllerTests
    {
        #region Get report parameter

        [Test]
        public void GetReportParameter()
        {
            // TODO mock ReportParametersHelper
        }

        [Test]
        public void GetReportParameter_TypeEqualsEmployerSize()
        {
        }

        [Test]
        public void GetReportParameter_TypeEqualsGroup()
        {
        }

        [Test]
        public void GetReportParameter_StartDateNull_EndDateNull()
        {
        }

        #endregion

        #region Category details GET

        [Test]
        public void CategoryDetails_GetMethod_IdNull()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var categoryRepoMock = new Mock<IReportCategoryRepository>();
            categoryRepoMock.Setup(r => r.Get(It.IsAny<int>()));

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.ReportCategoryRepository = categoryRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.CategoryDetails(null) as ViewResult;

            // Assert
            categoryRepoMock.Verify(r => r.Get(It.IsAny<int>()), Times.Never());
            Assert.AreEqual("", result.ViewName);
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(0, cboStatus.SelectedValue);
        }

        [Test]
        public void CategoryDetails_GetMethod_IdNotNull()
        {
            // Arrange
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var categoryRepoMock = new Mock<IReportCategoryRepository>();
            categoryRepoMock.Setup(r => r.Get(1)).Returns(new Report_Categories { CategoryId = 1, Status = 1 });

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.ReportCategoryRepository = categoryRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.CategoryDetails(1) as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        #endregion

        #region Category details POST

        [Test]
        public void CategoryDetails_PostMethod_ActionSave_Update_Fail_InvalidModel()
        {
            // Arrange
            var formData = new NameValueCollection();
            formData.Add("action", "save");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var category = new Report_Categories { CategoryId = 1, Status = 1 };

            var categoryRepoMock = new Mock<IReportCategoryRepository>();
            categoryRepoMock.Setup(r => r.Update(category));

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.ReportCategoryRepository = categoryRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            controller.ModelState.AddModelError("test", "test");
            var result = controller.CategoryDetails(null, category) as ViewResult;

            // Assert
            categoryRepoMock.Verify(r => r.Update(category), Times.Never());
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        [Test]
        public void CategoryDetails_PostMethod_ActionSave_Update_Fail_ThrowException()
        {
            // Arrange
            var formData = new NameValueCollection();
            formData.Add("action", "save");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var category = new Report_Categories { CategoryId = 1, Status = 1 };

            var categoryRepoMock = new Mock<IReportCategoryRepository>();
            categoryRepoMock.Setup(r => r.Update(category)).Throws<Exception>();

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.ReportCategoryRepository = categoryRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.CategoryDetails(null, category) as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        [Test]
        public void CategoryDetails_PostMethod_ActionSave_Update_Success()
        {
            // Arrange
            var formData = new NameValueCollection();
            formData.Add("action", "save");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var category = new Report_Categories { CategoryId = 1, Status = 1 };

            var categoryRepoMock = new Mock<IReportCategoryRepository>();
            categoryRepoMock.Setup(r => r.Update(category));

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.ReportCategoryRepository = categoryRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.CategoryDetails(null, category) as ViewResult;

            // Assert
            categoryRepoMock.Verify(r => r.Update(category), Times.Once());
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Success"));
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        [Test]
        public void CategoryDetails_PostMethod_ActionSave_Insert_Fail_InvalidModel()
        {
            // Arrange
            var formData = new NameValueCollection();
            formData.Add("action", "save");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var category = new Report_Categories { CategoryId = -1, Status = 1 };

            var categoryRepoMock = new Mock<IReportCategoryRepository>();
            categoryRepoMock.Setup(r => r.Insert(category));

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.ReportCategoryRepository = categoryRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            controller.ModelState.AddModelError("test", "test");
            var result = controller.CategoryDetails(null, category) as ViewResult;

            // Assert
            categoryRepoMock.Verify(r => r.Insert(category), Times.Never());
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        [Test]
        public void CategoryDetails_PostMethod_ActionSave_Insert_Fail_ThrowException()
        {
            // Arrange
            var formData = new NameValueCollection();
            formData.Add("action", "save");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var category = new Report_Categories { CategoryId = -1, Status = 1 };

            var categoryRepoMock = new Mock<IReportCategoryRepository>();
            categoryRepoMock.Setup(r => r.Insert(category)).Throws<Exception>();

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.ReportCategoryRepository = categoryRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.CategoryDetails(null, category) as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        [Test]
        public void CategoryDetails_PostMethod_ActionSave_Insert_Success()
        {
            // Arrange
            var formData = new NameValueCollection();
            formData.Add("action", "save");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var category = new Report_Categories { CategoryId = -1, Status = 1 };

            var categoryRepoMock = new Mock<IReportCategoryRepository>();
            categoryRepoMock.Setup(r => r.Insert(category));

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.ReportCategoryRepository = categoryRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.CategoryDetails(null, category) as RedirectToRouteResult;

            // Assert
            categoryRepoMock.Verify(r => r.Insert(category), Times.Once());
            Assert.IsTrue(result.RouteValues["action"].ToString().Equals("Category", StringComparison.InvariantCultureIgnoreCase));
        }

        [Test]
        public void CategoryDetails_PostMethod_ActionDelete_Success()
        {
            // Arrange
            var formData = new NameValueCollection();
            formData.Add("action", "delete");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var category = new Report_Categories { CategoryId = 1, Status = 1 };

            var categoryRepoMock = new Mock<IReportCategoryRepository>();
            categoryRepoMock.Setup(r => r.Delete(category.CategoryId));

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.ReportCategoryRepository = categoryRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.CategoryDetails(null, category) as RedirectToRouteResult;

            // Assert
            categoryRepoMock.Verify(r => r.Delete(category.CategoryId), Times.Once());
            Assert.IsTrue(result.RouteValues["action"].ToString().Equals("Category", StringComparison.InvariantCultureIgnoreCase));
        }

        [Test]
        public void CategoryDetails_PostMethod_ActionDelete_Fail_ThrowException()
        {
            // Arrange
            var formData = new NameValueCollection();
            formData.Add("action", "delete");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var category = new Report_Categories { CategoryId = 1, Status = 1 };

            var categoryRepoMock = new Mock<IReportCategoryRepository>();
            categoryRepoMock.Setup(r => r.Delete(category.CategoryId)).Throws<Exception>();

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.ReportCategoryRepository = categoryRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.CategoryDetails(null, category) as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        #endregion

        #region Category GET

        [Test]
        public void Category_GetMethod()
        {
            // Arrange
            var queryStrings = new NameValueCollection();
            queryStrings.Add("systemid", "1");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockQueryStrings(queryStrings).MockCookies();
            requestMock.SetupGet(r => r["systemid"]).Returns("1");
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var categories = new List<Report_Categories> { new Report_Categories { CategoryId = 1 }, new Report_Categories { CategoryId = 2 } };
            var categoryRepoMock = new Mock<IReportCategoryRepository>();
            categoryRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(categories);

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.ReportCategoryRepository = categoryRepoMock.Object;
            var result = controller.Category() as ViewResult;

            // Assert
            Assert.AreEqual(categories, ((List<Report_Categories>)result.Model));
            Assert.AreEqual("", result.ViewName);
        }

        #endregion

        #region Category POST

        [Test]
        public void Category_PostMethod()
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

            var categories = new List<Report_Categories> { new Report_Categories { CategoryId = 1 }, new Report_Categories { CategoryId = 2 } };
            var categoryRepoMock = new Mock<IReportCategoryRepository>();
            categoryRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(categories);
            categoryRepoMock.Setup(r => r.UpdateStatus(It.IsAny<string>()));

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.ReportCategoryRepository = categoryRepoMock.Object;
            var result = controller.Category(null, "test", "test", "test") as ViewResult;

            // Assert
            Assert.AreEqual(categories, ((List<Report_Categories>)result.Model));
            Assert.AreEqual("", result.ViewName);
            Assert.AreEqual(10, result.ViewBag.PageSize);
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

            var reports = new List<Report> { new Report { ReportId = 1 }, new Report { ReportId = 2 } };
            var reportRepoMock = new Mock<IReportRepository>();
            reportRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<int>())).Returns(reports);

            var categoryRepoMock = new Mock<IReportCategoryRepository>();
            categoryRepoMock.Setup(r => r.GetList()).Returns(new List<Report_Categories>());

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.ReportRepository = reportRepoMock.Object;
            controller.ReportCategoryRepository = categoryRepoMock.Object;
            var result = controller.Index() as ViewResult;

            // Assert
            Assert.AreEqual(reports, ((List<Report>)result.Model));
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
            formData.Add("cboCategory", "1");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r["systemid"]).Returns("1");
            requestMock.SetupGet(r => r["cboSystem"]).Returns("1");
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var reports = new List<Report> { new Report { ReportId = 1 }, new Report { ReportId = 2 } };
            var reportRepoMock = new Mock<IReportRepository>();
            reportRepoMock.Setup(r => r.GetListByCategory(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<int>())).Returns(reports);
            reportRepoMock.Setup(r => r.UpdateStatus(It.IsAny<string>()));

            var categoryRepoMock = new Mock<IReportCategoryRepository>();
            categoryRepoMock.Setup(r => r.GetList()).Returns(new List<Report_Categories>());

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.ReportRepository = reportRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            controller.ReportCategoryRepository = categoryRepoMock.Object;
            var result = controller.Index(null, "test", "test", "test") as ViewResult;

            // Assert
            Assert.AreEqual(reports, ((List<Report>)result.Model));
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

            var reportRepoMock = new Mock<IReportRepository>();
            reportRepoMock.Setup(r => r.Get(It.IsAny<int>()));

            var categoryRepoMock = new Mock<IReportCategoryRepository>();
            categoryRepoMock.Setup(r => r.GetList()).Returns(new List<Report_Categories>());

            var orgLevelRepoMock = new Mock<IOrganisationLevelsRepository>();
            orgLevelRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>())).Returns(new List<Organisation_Levels>());

            var externalGroupRepoMock = new Mock<IExternal_GroupRepository>();
            externalGroupRepoMock.Setup(r => r.GetList(GroupStatusFilter.All)).Returns(new List<External_Group>());

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.ReportRepository = reportRepoMock.Object;
            controller.ReportCategoryRepository = categoryRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.OrganisationLevelRepository = orgLevelRepoMock.Object;
            controller.External_GroupRepository = externalGroupRepoMock.Object;
            var result = controller.Details(null, "test") as ViewResult;

            // Assert
            reportRepoMock.Verify(r => r.Get(It.IsAny<int>()), Times.Never());
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

            var report = new Report { ReportId = 1, Status = 1 };
            var reportRepoMock = new Mock<IReportRepository>();
            reportRepoMock.Setup(r => r.Get(1)).Returns(report);

            var categoryRepoMock = new Mock<IReportCategoryRepository>();
            categoryRepoMock.Setup(r => r.GetList()).Returns(new List<Report_Categories>());

            var orgLevelRepoMock = new Mock<IOrganisationLevelsRepository>();
            orgLevelRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>())).Returns(new List<Organisation_Levels>());

            var externalGroupRepoMock = new Mock<IExternal_GroupRepository>();
            externalGroupRepoMock.Setup(r => r.GetList(GroupStatusFilter.All)).Returns(new List<External_Group>());

            var permission = new ReportPermission { ReportExternalAccessList = new List<Report_External_Access>(), ReportOrganisationLevelList = new List<Report_Organisation_Levels>() };
            var reportPermissionRepoMock = new Mock<IReportPermissionRepository>();
            reportPermissionRepoMock.Setup(r => r.Get(It.IsAny<object>())).Returns(permission);

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.ReportRepository = reportRepoMock.Object;
            controller.ReportCategoryRepository = categoryRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.OrganisationLevelRepository = orgLevelRepoMock.Object;
            controller.External_GroupRepository = externalGroupRepoMock.Object;
            controller.ReportPermissionRepository = reportPermissionRepoMock.Object;
            var result = controller.Details(1, "test") as ViewResult;

            // Assert
            reportRepoMock.Verify(r => r.Get(It.IsAny<int>()), Times.Once());
            Assert.AreEqual("", result.ViewName);
            Assert.AreEqual(0, result.ViewBag.AssignLevel);
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        #endregion

        #region Details POST

        [Test]
        public void Details_PostMethod_Fail_InvalidReport()
        {
            // Arrange
            var report = new Report { ReportId = 1, Status = 1 };

            var categoryRepoMock = new Mock<IReportCategoryRepository>();
            categoryRepoMock.Setup(r => r.GetList()).Returns(new List<Report_Categories>());

            var orgLevelRepoMock = new Mock<IOrganisationLevelsRepository>();
            orgLevelRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>())).Returns(new List<Organisation_Levels>());

            var externalGroupRepoMock = new Mock<IExternal_GroupRepository>();
            externalGroupRepoMock.Setup(r => r.GetList(GroupStatusFilter.All)).Returns(new List<External_Group>());

            // Act
            var controller = new ReportController();
            controller.ModelState.AddModelError("test", "test");
            controller.ReportCategoryRepository = categoryRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.OrganisationLevelRepository = orgLevelRepoMock.Object;
            controller.External_GroupRepository = externalGroupRepoMock.Object;
            var result = controller.Details(null, report, "test", "test") as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        [Test]
        public void Details_PostMethod_Success_ActionSave_Update()
        {
            // Arrange
            var formData = new NameValueCollection();
            formData.Add("action", "save");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var report = new Report { ReportId = 1, Status = 1 };

            var reportRepoMock = new Mock<IReportRepository>();
            reportRepoMock.Setup(r => r.Update(report));

            var categoryRepoMock = new Mock<IReportCategoryRepository>();
            categoryRepoMock.Setup(r => r.GetList()).Returns(new List<Report_Categories>());

            var orgLevelRepoMock = new Mock<IOrganisationLevelsRepository>();
            orgLevelRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>())).Returns(new List<Organisation_Levels>());

            var externalGroupRepoMock = new Mock<IExternal_GroupRepository>();
            externalGroupRepoMock.Setup(r => r.GetList(GroupStatusFilter.All)).Returns(new List<External_Group>());

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.ReportRepository = reportRepoMock.Object;
            controller.ReportCategoryRepository = categoryRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.OrganisationLevelRepository = orgLevelRepoMock.Object;
            controller.External_GroupRepository = externalGroupRepoMock.Object;
            var result = controller.Details(null, report, "test", "test") as ViewResult;

            // Assert
            reportRepoMock.Verify(r => r.Update(report), Times.Once());
            Assert.AreEqual("", result.ViewName);
        }

        [Test]
        public void Details_PostMethod_Success_ActionSave_Insert()
        {
            // Arrange
            var formData = new NameValueCollection();
            formData.Add("action", "save");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var report = new Report { ReportId = -1, Status = 1 };

            var reportRepoMock = new Mock<IReportRepository>();
            reportRepoMock.Setup(r => r.Insert(report));

            var categoryRepoMock = new Mock<IReportCategoryRepository>();
            categoryRepoMock.Setup(r => r.GetList()).Returns(new List<Report_Categories>());

            var orgLevelRepoMock = new Mock<IOrganisationLevelsRepository>();
            orgLevelRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>())).Returns(new List<Organisation_Levels>());

            var externalGroupRepoMock = new Mock<IExternal_GroupRepository>();
            externalGroupRepoMock.Setup(r => r.GetList(GroupStatusFilter.All)).Returns(new List<External_Group>());

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.ReportRepository = reportRepoMock.Object;
            controller.ReportCategoryRepository = categoryRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.OrganisationLevelRepository = orgLevelRepoMock.Object;
            controller.External_GroupRepository = externalGroupRepoMock.Object;
            var result = controller.Details(null, report, "test", "test") as RedirectToRouteResult;

            // Assert
            reportRepoMock.Verify(r => r.Insert(report), Times.Once());
            Assert.IsTrue(result.RouteValues["action"].ToString().Equals("index", StringComparison.InvariantCultureIgnoreCase));
        }

        [Test]
        public void Details_PostMethod_Success_ActionDelete()
        {
            // Arrange
            var formData = new NameValueCollection();
            formData.Add("action", "delete");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockFormData(formData).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var report = new Report { ReportId = 1, Status = 1 };

            var reportRepoMock = new Mock<IReportRepository>();
            reportRepoMock.Setup(r => r.Delete(report.ReportId));

            var orgLevelRepoMock = new Mock<IOrganisationLevelsRepository>();
            orgLevelRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>())).Returns(new List<Organisation_Levels>());

            var externalGroupRepoMock = new Mock<IExternal_GroupRepository>();
            externalGroupRepoMock.Setup(r => r.GetList(GroupStatusFilter.All)).Returns(new List<External_Group>());

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.ReportRepository = reportRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.OrganisationLevelRepository = orgLevelRepoMock.Object;
            controller.External_GroupRepository = externalGroupRepoMock.Object;
            var result = controller.Details(null, report, "test", "test") as RedirectToRouteResult;

            // Assert
            reportRepoMock.Verify(r => r.Delete(report.ReportId), Times.Once());
            Assert.IsTrue(result.RouteValues["action"].ToString().Equals("index", StringComparison.InvariantCultureIgnoreCase));
        }

        #endregion

        #region External group GET

        [Test]
        public void ExternalGroup_GetMethod_Success_IdNull()
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
            externalGroupRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), GroupStatusFilter.All)).Returns(externalGroups);

            var reportPermissionRepoMock = new Mock<IReportPermissionRepository>();
            reportPermissionRepoMock.Setup(r => r.Get(It.IsAny<int>()));

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.External_GroupRepository = externalGroupRepoMock.Object;
            controller.ReportPermissionRepository = reportPermissionRepoMock.Object;
            var result = controller.ExternalGroup(null, "test") as ViewResult;

            // Assert
            Assert.IsNotNull(result.Model);
            reportPermissionRepoMock.Verify(r => r.Get(It.IsAny<int>()), Times.Never());
            Assert.AreEqual("", result.ViewName);
        }

        [Test]
        public void ExternalGroup_GetMethod_Success_IdNotNull()
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
            externalGroupRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), GroupStatusFilter.All)).Returns(externalGroups);

            var reportPermission = new ReportPermission();
            var reportPermissionRepoMock = new Mock<IReportPermissionRepository>();
            reportPermissionRepoMock.Setup(r => r.Get(It.IsAny<object>())).Returns(reportPermission);

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.External_GroupRepository = externalGroupRepoMock.Object;
            controller.ReportPermissionRepository = reportPermissionRepoMock.Object;
            var result = controller.ExternalGroup(1, "test") as ViewResult;

            // Assert
            Assert.IsNotNull(result.Model);
            reportPermissionRepoMock.Verify(r => r.Get(It.IsAny<object>()), Times.Once());
            Assert.AreEqual("", result.ViewName);
        }

        [Test]
        public void ExternalGroup_GetMethod_Fail_ThrowException()
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
            externalGroupRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), GroupStatusFilter.All)).Returns(externalGroups);

            var reportPermissionRepoMock = new Mock<IReportPermissionRepository>();
            reportPermissionRepoMock.Setup(r => r.Get(It.IsAny<object>())).Throws<Exception>();

            // Act
            var controller = new ReportController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.External_GroupRepository = externalGroupRepoMock.Object;
            controller.ReportPermissionRepository = reportPermissionRepoMock.Object;
            var result = controller.ExternalGroup(1, "test") as ViewResult;

            // Assert
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
            Assert.AreEqual("", result.ViewName);
        }

        #endregion

        #region External group POST

        [Test]
        public void ExternalGroup_PostMethod_ActionAssign()
        {
        }

        [Test]
        public void ExternalGroup_PostMethod_ActionUnassign()
        {
        }

        #endregion       

        #region Organization role POST

        [Test]
        public void OrganizationRole_PostMethod_ActionAssign()
        {
        }

        [Test]
        public void OrganizationRole_PostMethod_ActionUnassign()
        {
        }

        [Test]
        public void OrganizationRole_PostMethod_NoAction()
        {
        }

        #endregion

        #region View info GET

        [Test]
        public void ViewInfo_GetMethod()
        {
            // TODO mock ReportParameterHelper
        }

        #endregion       

        #region Report raw data

        [Test]
        public void ReportRawData_Success()
        {
        }

        [Test]
        public void ReportRawData_Fail_ThrowException()
        {
        }

        #endregion

        #region File cabinet

        [Test]
        public void GetFileCabinetReports()
        {
            // TODO mock FileCabinetHelper
        }

        [Test]
        public void GetActurialReports()
        {
        }

        [Test]
        public void GetActurialFolders()
        {
        }
        
        #endregion
    }
}
