using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using Moq;
using System.Web;
using EM_Report.Tests.Helpers;
using EM_Report.Repositories;
using EM_Report.Domain;
using EM_Report.Controllers;
using System.Web.Mvc;
using EM_Report.Helpers;

namespace EM_Report.Tests.Controllers
{
    [TestFixture]
    public class DashboardFavourControllerTests : BaseControllerTests
    {
        //#region Index GET

        //[Test]
        //public void Index_GetMethod_Success()
        //{
        //    // Arrange
        //    var requestMock = new Mock<HttpRequestBase>();

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var dashboardFavours = new List<Dashboard_Favours>();
        //    var dashboardFavourRepoMock = new Mock<IDashboard_FavoursRepository>();
        //    dashboardFavourRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>())).Returns(dashboardFavours);

        //    // Act
        //    var controller = new Dashboard_FavourController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    controller.Dashboard_FavourRepository = dashboardFavourRepoMock.Object;
        //    var result = controller.Index(1) as PartialViewResult;

        //    // Assert
        //    Assert.IsTrue(result.ViewName.Equals("Index", StringComparison.InvariantCultureIgnoreCase));
        //    Assert.AreEqual(dashboardFavours, result.ViewData.Model);
        //}

        //#endregion

        //#region Index POST

        //[Test]
        //public void Index_PostMethod_Success()
        //{
        //    // Arrange
        //    var requestMock = new Mock<HttpRequestBase>();

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var dashboardFavours = new List<Dashboard_Favours>();
        //    var dashboardFavourRepoMock = new Mock<IDashboard_FavoursRepository>();
        //    dashboardFavourRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>())).Returns(dashboardFavours);
        //    dashboardFavourRepoMock.Setup(r => r.Delete(1));

        //    // Act
        //    var controller = new Dashboard_FavourController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    controller.Dashboard_FavourRepository = dashboardFavourRepoMock.Object;
        //    var result = controller.Index(new FormCollection(), "1", "1") as PartialViewResult;

        //    // Assert
        //    dashboardFavourRepoMock.Verify(r => r.Delete(1), Times.Once());
        //    Assert.IsTrue(result.ViewName.Equals("Index", StringComparison.InvariantCultureIgnoreCase));
        //    Assert.AreEqual(dashboardFavours, result.ViewData.Model);
        //}

        //[Test]
        //public void Index_PostMethod_Fail_FavourIdNull_FlagNull()
        //{
        //    // Arrange
        //    var requestMock = new Mock<HttpRequestBase>();

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var dashboardFavours = new List<Dashboard_Favours>();
        //    var dashboardFavourRepoMock = new Mock<IDashboard_FavoursRepository>();
        //    dashboardFavourRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>())).Returns(dashboardFavours);
        //    dashboardFavourRepoMock.Setup(r => r.Delete(1));

        //    // Act
        //    var controller = new Dashboard_FavourController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    controller.Dashboard_FavourRepository = dashboardFavourRepoMock.Object;
        //    var result = controller.Index(new FormCollection(), "", "") as PartialViewResult;

        //    // Assert
        //    dashboardFavourRepoMock.Verify(r => r.Delete(1), Times.Never());
        //    Assert.IsTrue(result.ViewName.Equals("Index", StringComparison.InvariantCultureIgnoreCase));
        //    Assert.AreEqual(dashboardFavours, result.ViewData.Model);
        //}

        //#endregion

        //#region Details GET

        //[Test]
        //public void Details_GetMethod_UserIdNull()
        //{
        //    // Arrange
        //    var requestMock = new Mock<HttpRequestBase>();

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var dashboardFavourRepoMock = new Mock<IDashboard_FavoursRepository>();
        //    dashboardFavourRepoMock.Setup(r => r.GetByUserId(It.IsAny<int>()));

        //    // Act
        //    var dashboardController = new Dashboard_FavourController();
        //    dashboardController.ControllerContext = controllerContextMock.Object;
        //    dashboardController.Dashboard_FavourRepository = dashboardFavourRepoMock.Object;
        //    dashboardController.StatusRepository = statusRepoMock.Object;
        //    var result = dashboardController.Details(null) as PartialViewResult;

        //    // Assert
        //    dashboardFavourRepoMock.Verify(r => r.GetByUserId(It.IsAny<int>()), Times.Never());
        //    Assert.AreEqual("Details", result.ViewName);
        //    Assert.IsNull(result.ViewData.Model);
        //}

        //[Test]
        //public void Details_GetMethod_UserIdNotNull()
        //{
        //    // Arrange
        //    var requestMock = new Mock<HttpRequestBase>();

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var dashboardFavour = new Dashboard_Favours { Status = 1 };
        //    var dashboardFavourRepoMock = new Mock<IDashboard_FavoursRepository>();
        //    dashboardFavourRepoMock.Setup(r => r.GetByUserId(1)).Returns(dashboardFavour);

        //    // Act
        //    var controller = new Dashboard_FavourController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    controller.Dashboard_FavourRepository = dashboardFavourRepoMock.Object;
        //    controller.StatusRepository = statusRepoMock.Object;
        //    var result = controller.Details("1") as PartialViewResult;

        //    // Assert
        //    dashboardFavourRepoMock.Verify(r => r.GetByUserId(1), Times.Once());
        //    Assert.AreEqual("Details", result.ViewName);
        //    Assert.AreEqual(dashboardFavour, result.ViewData.Model);
        //}

        //#endregion

        //#region Details POST

        //[Test]
        //public void Details_PostMethod_InsertNewFavour()
        //{
        //    // Arrange
        //    var requestMock = new Mock<HttpRequestBase>();

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var dashboardFavour = new Dashboard_Favours { Status = 1 };
        //    var dashboardFavourRepoMock = new Mock<IDashboard_FavoursRepository>();
        //    dashboardFavourRepoMock.Setup(r => r.GetList("1", "")).Returns(new List<Dashboard_Favours> { dashboardFavour });
        //    dashboardFavourRepoMock.Setup(r => r.Insert(It.IsAny<Dashboard_Favours>()));

        //    // Act
        //    var controller = new Dashboard_FavourController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    controller.Dashboard_FavourRepository = dashboardFavourRepoMock.Object;
        //    var result = controller.Details("1", "test", "test", "-1", false) as PartialViewResult;

        //    // Assert
        //    dashboardFavourRepoMock.Verify(r => r.Insert(It.IsAny<Dashboard_Favours>()), Times.Once());
        //    Assert.AreEqual("Details", result.ViewName);
        //    Assert.IsNull(result.ViewData.Model);
        //}

        //[Test]
        //public void Details_PostMethod_UpdateDuplicatedFavour()
        //{
        //    // Arrange
        //    var requestMock = new Mock<HttpRequestBase>();

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var dashboardFavour = new Dashboard_Favours { Status = 1, Url = "test", UserId = 1 };
        //    var dashboardFavourRepoMock = new Mock<IDashboard_FavoursRepository>();
        //    dashboardFavourRepoMock.Setup(r => r.GetList("1", "")).Returns(new List<Dashboard_Favours> { dashboardFavour });
        //    dashboardFavourRepoMock.Setup(r => r.Update(It.IsAny<Dashboard_Favours>(), "test", 1));

        //    // Act
        //    var controller = new Dashboard_FavourController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    controller.Dashboard_FavourRepository = dashboardFavourRepoMock.Object;
        //    var result = controller.Details("1", "test", "test", "-1", false) as PartialViewResult;

        //    // Assert
        //    dashboardFavourRepoMock.Verify(r => r.Update(It.IsAny<Dashboard_Favours>(), "test", 1), Times.Once());
        //    Assert.AreEqual("Details", result.ViewName);
        //    Assert.IsNull(result.ViewData.Model);
        //}

        //[Test]
        //public void Details_PostMethod_UpdateSelectedFavour()
        //{
        //    // Arrange
        //    var requestMock = new Mock<HttpRequestBase>();

        //    var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

        //    var dashboardFavour = new Dashboard_Favours { Status = 1, Url = "test", UserId = 1, Name = "test" };
        //    var dashboardFavourRepoMock = new Mock<IDashboard_FavoursRepository>();
        //    dashboardFavourRepoMock.Setup(r => r.GetById(1)).Returns(new Dashboard_Favours { Status = 1, Url = "test000", UserId = 1 });
        //    dashboardFavourRepoMock.Setup(r => r.GetList("1", "")).Returns(new List<Dashboard_Favours> { dashboardFavour });
        //    dashboardFavourRepoMock.Setup(r => r.Update(It.IsAny<Dashboard_Favours>(), "test", 1));

        //    // Act
        //    var controller = new Dashboard_FavourController();
        //    controller.ControllerContext = controllerContextMock.Object;
        //    controller.Dashboard_FavourRepository = dashboardFavourRepoMock.Object;
        //    var result = controller.Details("1", "test", "test001", "1", true) as PartialViewResult;

        //    // Assert
        //    dashboardFavourRepoMock.Verify(r => r.Update(It.IsAny<Dashboard_Favours>(), "test", 1), Times.AtLeastOnce());
        //    Assert.AreEqual("Details", result.ViewName);
        //    Assert.IsNull(result.ViewData.Model);
        //}

        //#endregion
    }
}
