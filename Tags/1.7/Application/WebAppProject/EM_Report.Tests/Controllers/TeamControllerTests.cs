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
    public class TeamControllerTests : BaseControllerTests
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

            var teams = new List<Team> { new Team { TeamId = 1 }, new Team { TeamId = 2 } };
            var teamRepoMock = new Mock<ITeamRepository>();
            teamRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<int>())).Returns(teams);

            // Act
            var controller = new TeamController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.TeamRepository = teamRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            var result = controller.Index("test", "test") as ViewResult;

            // Assert
            Assert.AreEqual(teams, ((List<Team>)result.Model));
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

            var teams = new List<Team> { new Team { TeamId = 1 }, new Team { TeamId = 2 } };
            var teamRepoMock = new Mock<ITeamRepository>();
            teamRepoMock.Setup(r => r.GetList(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<int>())).Returns(teams);

            // Act
            var controller = new TeamController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.TeamRepository = teamRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            var result = controller.Index(null, "test", "test", "test") as ViewResult;

            // Assert
            Assert.AreEqual(teams, ((List<Team>)result.Model));
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

            var teamRepoMock = new Mock<ITeamRepository>();
            teamRepoMock.Setup(r => r.GetById(It.IsAny<int>()));

            // Act
            var controller = new TeamController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.TeamRepository = teamRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.Details((int?)null) as ViewResult;

            // Assert
            teamRepoMock.Verify(r => r.GetById(It.IsAny<int>()), Times.Never());
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

            var teamRepoMock = new Mock<ITeamRepository>();
            teamRepoMock.Setup(r => r.GetById(1)).Returns(new Team { TeamId = 1, Status = 1 });

            // Act
            var controller = new TeamController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.TeamRepository = teamRepoMock.Object;
            controller.UserRepository = userRepoMock.Object;
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
        public void Details_PostMethod_Success_UpdateTeam()
        {
            // Arrange
            var queryStrings = new NameValueCollection();
            queryStrings.Add("systemid", "1");
            var requestMock = new Mock<HttpRequestBase>();
            requestMock.MockQueryStrings(queryStrings).MockCookies();
            requestMock.SetupGet(r => r.Url).Returns(new Uri("http://localhost"));

            var controllerContextMock = MvcMockHelpers.MockControllerContext(requestMock);

            var team = new Team { TeamId = 1, Status = 1 };

            var teamRepoMock = new Mock<ITeamRepository>();
            teamRepoMock.Setup(r => r.Update(team));

            // Act
            var controller = new TeamController();
            controller.ControllerContext = controllerContextMock.Object;
            controller.UserRepository = userRepoMock.Object;
            controller.TeamRepository = teamRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.Details(team) as ViewResult;

            // Assert
            teamRepoMock.Verify(r => r.Update(team), Times.Once());
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Success"));
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        [Test]
        public void Details_PostMethod_Success_InsertTeam()
        {
            // TODO: Base.Absolute can not mock
        }

        [Test]
        public void Details_PostMethod_Fail_InvalidTeam()
        {
            // Arrange
            var team = new Team { TeamId = 1, Status = 1 };

            // Act
            var controller = new TeamController();
            controller.ModelState.AddModelError("test", "test");
            controller.UserRepository = userRepoMock.Object;
            controller.StatusRepository = statusRepoMock.Object;
            var result = controller.Details(team) as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
            Assert.IsTrue(result.ViewData.ModelState.ContainsKey("Error"));
            var cboStatus = (SelectList)result.ViewBag.cboStatus;
            Assert.AreEqual(1, cboStatus.SelectedValue);
        }

        #endregion
    }
}
