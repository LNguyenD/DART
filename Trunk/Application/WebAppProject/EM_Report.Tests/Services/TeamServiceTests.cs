using System;
using System.Collections.Generic;
using EM_Report.BLL.Services;
using EM_Report.Domain;
using Moq;
using NUnit.Framework;

namespace EM_Report.Tests.Services
{
    [TestFixture]
    public class TeamServiceTests : BaseServiceTests
    {
        // Repositories

        private Mock<I_TeamService> mockTeamRepository;
        private Mock<I_UserService> mockUserRepository;

        // Fake data collections

        private List<Team> _teamList;
        private List<User> _userList;

        [TestFixtureSetUp]
        public void Init()
        {
            _teamList = new List<Team>
            {
                new Team() {TeamId = 1,SystemId = 1,Name = "1B",Description = "Test1",Status = 2,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
                new Team() {TeamId = 2,SystemId = 1,Name = "RIG5",Description = "Test2",Status = 2,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
                new Team() {TeamId = 3,SystemId = 1,Name = "5B",Description = "Test3",Status = 2,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
                new Team() {TeamId = 4,SystemId = 1,Name = "CORP",Description = "Test4",Status = 1,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
                new Team() {TeamId = 5,SystemId = 1,Name = "HEM",Description = "Test5",Status = 1,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
                new Team() {TeamId = 6,SystemId = 1,Name = "HEM1",Description = "Test6",Status = 2,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
                new Team() {TeamId = 7,SystemId = 1,Name = "No Group",Description ="Test7",Status = 2,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
                new Team() {TeamId = 8,SystemId = 1,Name = "RIG6",Description = "Test8",Status = 1,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
                new Team() {TeamId = 9,SystemId = 1,Name = "RIG6A",Description = "Test9",Status = 1,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
                new Team() {TeamId = 10,SystemId = 1,Name = "RIG6C",Description = "Test10",Status = 1,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
                new Team() {TeamId = 11,SystemId = 1,Name = "RIGTMF6",Description = "Test11",Status = 2,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179}
            };
            _userList = new List<User>()
            {
                // admin
                new User(){UserId = 1, UserName = "admin", Password = "password",Status = 1, Is_System_User = true},

                // external users
                new User(){UserId = 2, UserName = "report_user1", Password = "password", Status = 1, Is_System_User = false},
            };

            // initial mocks
            this.mockTeamRepository = new Mock<I_TeamService>();
            this.mockUserRepository = new Mock<I_UserService>();

            // mock GetById method and return result in fake data collection
            mockTeamRepository.Setup(m => m.GetById(It.IsAny<int>())).Returns((int i) => _teamList.Find(x => x.TeamId == i));
            mockUserRepository.Setup(m => m.GetById(It.IsAny<int>())).Returns((int i) => _userList.Find(x => x.UserId == i));
            
            // mock GetAll method and return results in fake data collection
            mockTeamRepository.Setup(t => t.GetAll()).Returns(_teamList);
            mockUserRepository.Setup(t => t.GetAll()).Returns(_userList);
        }

        [Test]
        public void TestUpdateStatus_Success()
        {
            // status need to update
            const int updatedStatus = 4;

            // fetch team from fake data for updating
            var team = this.mockTeamRepository.Object.GetById(4);

            // setup UpdateStatus method
            mockTeamRepository.Setup(m => m.UpdateStatus(It.IsAny<Team>(), updatedStatus)).Callback(
            () =>
            {
                _teamList[updatedStatus - 1].Status = updatedStatus;
                this.mockTeamRepository.Object.Update(_teamList[updatedStatus - 1], _teamList[updatedStatus - 1].TeamId);
            });

            // update status
            this.mockTeamRepository.Object.UpdateStatus(team, updatedStatus);

            var teams = (List<Team>)this.mockTeamRepository.Object.GetAll();

            // verify the count of the list
            Assert.IsNotNull(teams);
            Assert.AreEqual(11, teams.Count);   // the count is the same

            team = this.mockTeamRepository.Object.GetById(team.TeamId);

            Assert.IsNotNull(team); // the new team exist in the list
            Assert.AreEqual(updatedStatus, team.Status); //make sure can get the team successfully
        }

        [Test]
        public void TestIsRIG_ReturnFalse()
        {
            // status need to update
            const string site = "HEM";

            // fetch team from fake data for checking
            var user = this.mockUserRepository.Object.GetById(1);

            // setup IsRIG method
            mockTeamRepository.Setup(m => m.IsRIG(It.IsAny<string>(), site)).Returns(false);

            // check
            bool result = this.mockTeamRepository.Object.IsRIG(user, site);

            // verify
            Assert.IsFalse(result);
        }
    }
}