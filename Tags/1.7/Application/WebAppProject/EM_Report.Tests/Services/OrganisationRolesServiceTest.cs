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
  public class OrganisationRolesServiceTest : BaseServiceTests
   {
       //Service

        private Organisation_RolesService _service;
        private Mock<I_Repository<Organisation_RoleDO>> _repositoryOrganisationRole;
        private List<Organisation_RoleDO> _organisationRoleList;
        private Mock<Organisation_RolesService> mockOrganisationRoleRepository;   //mock the teamRepository
        private List<Organisation_Roles> _OrganisationRoleList;                     //a list of teams to test
        private I_LoginSession _loginSession;

        [TestFixtureSetUp]
        public void Init()
        {
            _repositoryOrganisationRole = new Mock<I_Repository<Organisation_RoleDO>>();

            _organisationRoleList = new List<Organisation_RoleDO>
                {
                  new Organisation_RoleDO() {Organisation_RoleId = 1,LevelId = 1,Name = "Senior Claims Assessor",Description = "Test case1",Status = 2,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
                  new Organisation_RoleDO() {Organisation_RoleId = 2,LevelId = 2,Name = "xx Case Manager in Training",Description = "Test case2",Status = 2,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
                  new Organisation_RoleDO() {Organisation_RoleId = 3,LevelId = 3,Name = "Case Manager",Description = "Test case3",Status = 2,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
                  new Organisation_RoleDO() {Organisation_RoleId = 4,LevelId = 2,Name = "Claims Assistant",Description = "Test case4",Status = 2,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
                  new Organisation_RoleDO() {Organisation_RoleId = 5,LevelId = 2,Name = "Team Leader",Description = "Test case5",Status = 2,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179}
                };
            _repositoryOrganisationRole.Setup(m => m.GetByPK(It.IsAny<int>())).Returns((int i) => _organisationRoleList.Find(x => x.Organisation_RoleId == i));
            _repositoryOrganisationRole.Setup(t => t.GetQueryable()).Returns(_organisationRoleList.AsQueryable());


            _OrganisationRoleList = new List<Organisation_Roles>()
                {
                  new Organisation_Roles() {Organisation_RoleId = 1,LevelId = 1,Name = "Senior Claims Assessor",Description = "Test case1",Status = 2,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179,LevelName = "Leve2",SystemId = 1},
                  new Organisation_Roles() {Organisation_RoleId = 2,LevelId = 2,Name = "xx Case Manager in Training",Description = "Test case2",Status = 2,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179,LevelName = "Leve1",SystemId = 1}
                };
            this.mockOrganisationRoleRepository = new Mock<Organisation_RolesService>(_loginSession);
            mockOrganisationRoleRepository.Setup(m => m.GetById(It.IsAny<int>())).Returns((int i) => _OrganisationRoleList.Find(x => x.Organisation_RoleId == i));
            mockOrganisationRoleRepository.Setup(t => t.GetAll()).Returns(_OrganisationRoleList);
       }
       //[Test]
       //public void TestUpdateStatusOrganisationRole_ReturnSuccess()
       // {
       //     //init
       //     var organisationRole = this.mockOrganisationRoleRepository.Object.GetById(2);

       //     this.mockOrganisationRoleRepository.Object.UpdateStatus(organisationRole, 9);

       //     List<Organisation_Roles> emps = (List<Organisation_Roles>)this.mockOrganisationRoleRepository.Object.GetAll();
       //     //verify the count of the list
       //     Assert.IsNotNull(emps);
       //     Assert.AreEqual(2, emps.Count);// the count is the same

       //     var emp = this.mockOrganisationRoleRepository.Object.GetById(organisationRole.Organisation_RoleId);
       //     Assert.IsNotNull(emp); // the new Organisation exist in the list
       //     Assert.AreEqual(9, emp.Status); //make sure can get the Organisation successfully
       // }

        //[Test]
        //public void TestUpdateLevelOrganisationRole_ReturnSuccess()
        //{
        //    //init
        //    //var organisationRole = this.mockOrganisationRoleRepository.Object.GetById(1);

        //    const int roleid = 2;
        //    const int levelid = 3;
        //    const int userId = 179;

        //    _repositoryOrganisationRole.Setup(r => r.ExecuteNonQueryStoreProcedure("sp_Update_OrganisationRole_Level", It.IsAny<Dictionary<String, object>>()));   

        //    //updated roleid,levelId,UserId
        //    //this.mockOrganisationRoleRepository.Object.UpdateLevel(2, 3, 179);
        //    var organisationRoleService = new Organisation_RolesService(_repositoryOrganisationRole.Object, _loginSession);
        //    organisationRoleService.UpdateLevel(roleid, levelid, userId);

        //    var result = this.mockOrganisationRoleRepository.Object.Repository.GetByPK(2);

        //    //Assert
        //    Assert.IsNotNull(result);
        //    Assert.AreEqual(3, result.LevelId);
        //    Assert.AreEqual(179, result.UpdatedBy);
        //    //reset the previous result
        //    //this.mockOrganisationRoleRepository.Object.UpdateLevel(2, 4, 179);
        //}

       //[Test]
       //public void TestGetRoleOfLevel_ReturnListOfOrganisationLevel()
       //{
       //    _repositoryOrganisationRole.Setup(t => t.GetQueryable()).Returns(_organisationRoleList.AsQueryable().Where(t => t.LevelId == 2));
       //    //_service.Repository = _repositoryOrganisationRole.Object;
       //    _service = new Organisation_RolesService(_repositoryOrganisationRole.Object, _loginSession);

       //    var result = _service.GetRoleOfLevel(2);
       //    //assert
       //    Assert.IsNotNull(result);
       //    Assert.AreEqual(3,result.Count());
       //}

        //[Test]
        //public void TestIsTeamLeaderOrAbove_IsnotTeamLeader()
        //{
        //    //Arrange 
        //    _repositoryOrganisationRole.Setup(t => t.GetQueryable()).Returns(_organisationRoleList.AsQueryable());
        //    _service.Repository = _repositoryOrganisationRole.Object;

        //    var result = _service.IsTeamLeaderOrAbove(_organisationRoleList[0].Organisation_RoleId);
        //    // Assert      
        //    Assert.IsNotNull(result);
        //    Assert.IsFalse(result);
        //}

       //[Test]
       //public void TestIsTeamLeaderOrAbove_IsTeamLeader()
       //{
       //    //Arrange 
       //    _repositoryOrganisationRole.Setup(t => t.GetQueryable()).Returns(_organisationRoleList.AsQueryable());
       //    _service.Repository = _repositoryOrganisationRole.Object;

       //    var result = _service.IsTeamLeaderOrAbove(_organisationRoleList[4].Organisation_RoleId);
       //    // Assert      
       //    Assert.IsNotNull(result);
       //    Assert.IsTrue(result);
       //}
   }
}
