using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using EM_Report.Common.Utilities;

namespace EM_Report.Tests.Services
{
    [TestFixture]
    public class BaseServiceTests
    {
        protected I_LoginSession _loginSession;

        [TestFixtureSetUp]
        public void Setup()
        {
            var sessionMock = new Moq.Mock<I_LoginSession>();
            sessionMock.Setup(e => e.intUserId).Returns(1);
            sessionMock.Setup(e => e.isSystemUser).Returns(true);
            _loginSession = sessionMock.Object;
        }
    }
}
