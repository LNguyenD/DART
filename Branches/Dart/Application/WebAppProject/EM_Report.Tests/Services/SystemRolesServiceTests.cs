using System;
using System.Collections.Generic;
using System.Linq;
using EM_Report.BLL.Services;
using EM_Report.Common.Utilities;
using EM_Report.Domain;
using Moq;
using NUnit.Framework;
using EM_Report.DAL.Infrastructure;
using EM_Report.DAL;

namespace EM_Report.Tests.Services
{
    [TestFixture]
    public class SystemRolesServiceTests : BaseServiceTests
    {
        [Test]
        public void TestSaveSystemRole_ReturnSuccess()
        {
            // Arrange
            var systemRolesRepoMock = new Moq.Mock<I_Repository<System_RoleDO>>();
            systemRolesRepoMock.Setup(r => r.ExecuteScalarStoreProcedure(It.IsAny<string>(), It.IsAny<Dictionary<string, object>>())).Returns("1");

            // Act
            var systemRolesService = new System_RolesService(systemRolesRepoMock.Object, _loginSession);
            var result = systemRolesService.Save(1, "name", "description", "systemroles", 1);

            // Assert
            Assert.IsTrue(result);
        }

        [Test]
        public void TestSaveSystemRole_ReturnFail()
        {
            // Arrange
            var systemRolesRepoMock = new Moq.Mock<I_Repository<System_RoleDO>>();
            systemRolesRepoMock.Setup(r => r.ExecuteScalarStoreProcedure(It.IsAny<string>(), It.IsAny<Dictionary<string, object>>())).Returns("0");

            // Act
            var systemRolesService = new System_RolesService(systemRolesRepoMock.Object, _loginSession);
            var result = systemRolesService.Save(1, "name", "description", "systemroles", 1);

            // Assert
            Assert.IsFalse(result);
        }
    }
}