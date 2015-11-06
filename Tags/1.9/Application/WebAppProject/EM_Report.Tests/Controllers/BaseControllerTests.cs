using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using Moq;
using EM_Report.Helpers;
using EM_Report.Domain;
using EM_Report.Tests.Helpers;
using System.Web;
using EM_Report.Repositories;

namespace EM_Report.Tests.Controllers
{
    [TestFixture]
    public class BaseControllerTests
    {
        protected Mock<IStatusRepository> statusRepoMock;
        protected Mock<IUserRepository> userRepoMock;
        protected List<Systems> systems;

        [TestFixtureSetUp]
        public void Setup()
        {
            var loginSession = new LoginSession
            {
                strUserName = "test",
                strEmail = "test",
                strPassWord = "test",
                lstSystems = new List<Systems>(),
                isSystemUser = true,                
                defaultSystemName = "tmf",
                intUserId = 1
            };

            HttpContext.Current = MvcMockHelpers.FakeHttpContext();
            HttpContext.Current.Session["LoginSession"] = loginSession;

            var statusList = new List<Status> { new Status { StatusId = 0 }, new Status { StatusId = 1 }, new Status { StatusId = 2 } };
            statusRepoMock = new Mock<IStatusRepository>();
            statusRepoMock.Setup(r => r.StatusList()).Returns(statusList);

            systems = new List<Systems> { new Systems { Name = "test" } };
            userRepoMock = new Mock<IUserRepository>();
            userRepoMock.Setup(r => r.GetSystemList()).Returns(systems.ToArray());
            userRepoMock.Setup(r => r.GetSystemNameById(It.IsAny<int>())).Returns("tmf");
            userRepoMock.Setup(r => r.GetSystemIdByName("TMF")).Returns(1);
        }
    }
}
