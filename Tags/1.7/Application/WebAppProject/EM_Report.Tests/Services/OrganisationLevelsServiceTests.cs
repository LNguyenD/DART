using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EM_Report.BLL.Services;
using EM_Report.Common.Utilities;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Domain;
using Moq;
using NUnit.Framework;

namespace EM_Report.Tests.Services
{
    [TestFixture]
    public class OrganisationLevelsServiceTests : BaseServiceTests
    {
        private List<Organisation_Levels> _organisation_LevelList;

        [TestFixtureSetUp]
        public void Init()
        {
            _organisation_LevelList = new List<Organisation_Levels>
            {
                new Organisation_Levels() {LevelId = 1,SystemId = 2,Name = "Level 6 - CM",Description = "Test1",Sort = 2,Status = 1,Create_Date = DateTime.Now,Owner = 193,UpdatedBy = 179},
                new Organisation_Levels() {LevelId = 3,SystemId = 1,Name = "Level 3 - AM",Description = "Test2",Sort = 2,Status = 1,Create_Date = DateTime.Now,Owner = 489,UpdatedBy = 179},
                new Organisation_Levels() {LevelId = 2,SystemId = 2,Name = "Level 5 - SCM",Description = "Test3",Sort = 2,Status = 1,Create_Date = DateTime.Now,Owner = 1,UpdatedBy = 179},
                new Organisation_Levels() {LevelId = 4,SystemId = 1,Name = "Level 0 - Executives",Description = "Test4",Sort = 2,Status = 1,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
            };
        }

        [Test]
        public void TestCreateOrUpdate()
        {
            // Arrange
            var organizationLevelDO = new Organisation_LevelDO { LevelId = 1 };
            var organizationLevel = new Organisation_Levels { LevelId = 1 };
            
            var organizationLevelRepoMock = new Mock<I_Repository<Organisation_LevelDO>>();
            organizationLevelRepoMock.Setup(r => r.Update(It.IsAny<Organisation_LevelDO>(), 1)).Returns(organizationLevelDO);
            organizationLevelRepoMock.Setup(r => r.Insert(It.IsAny<Organisation_LevelDO>())).Returns(organizationLevelDO);

            // Act
            var organizationLevelService = new Organisation_Levels_Service(organizationLevelRepoMock.Object, _loginSession);
            var result = organizationLevelService.CreateOrUpdate(organizationLevel);

            // Assert
            //Assert.AreEqual(result, organizationLevel);
            organizationLevelRepoMock.Verify(r => r.Update(It.IsAny<Organisation_LevelDO>(), 1), Times.Once());
        }

        [Test]
        public void TestReArrangeLevel_UpdatedSuccess()
        {
            //init
            //var organisationLevel = this.mockOrganisationLevel.Object.GetById(1);
            var organisationLevel = _organisation_LevelList[1];
            int updatedBy = (int)organisationLevel.UpdatedBy;
            string data = "12|0,3|1,2|2,5|3,6|4,10|5,1|6,42|7,4|8";

            //Arrange
            Dictionary<string, object> dicParams = new Dictionary<string, object>();
            dicParams.Add("@data", data);
            dicParams.Add("@updatedby", updatedBy);

            var repoMock = new Mock<I_Repository<Organisation_LevelDO>>();
            repoMock.Setup(r => r.ExecuteNonQueryStoreProcedure("sp_ArrangeLevel_Role", dicParams));

            var organisationLevelService = new Organisation_Levels_Service(repoMock.Object, _loginSession);
            
            //Assert
            try
            {
                //this.mockOrganisationLevel.Object.ReArrangeLevel(data, (int)organisationLevel.UpdatedBy);
                organisationLevelService.ReArrangeLevel(data, updatedBy);
            }
            catch (Exception ex)
            {
                //Assert
                //@TODO message will be corrected later
                Assert.AreEqual("Error", ex.Message);
            }
        }
    }
}
