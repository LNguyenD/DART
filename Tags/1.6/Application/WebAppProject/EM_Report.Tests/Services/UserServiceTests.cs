using System;
using System.Linq;
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
    public class UserServiceTests : BaseServiceTests
    {
        // Service
        private UserService _userService;

        // Repository mocks

        private Mock<I_Repository<UserDO>> _repositoryUser;
        private Mock<I_Repository<SystemUserDO>> _repositorySystemUsers;
        private Mock<I_Repository<SystemDO>> _repositorySystem;
        private Mock<I_Repository<Organisation_LevelDO>> _repositoryOrganisationLevel;
        private Mock<I_Repository<Organisation_RoleDO>> _repositoryOrganisationRole;
        private Mock<I_Repository<ReportUserDO>> _repositoryReportUsers;

        private Mock<I_LoginSession> _sessionMock = new Mock<I_LoginSession>();

        // Fake data collections

        private UserDO[] _userList;
        private SystemDO[] _systemList;
        private External_GroupDO[] _externalList;
        private Organisation_LevelDO[] _levelList;
        private Organisation_RoleDO[] _roleList;
        private ReportUserDO[] _reportUser;
        private SystemUserDO[] _systemUser;

        [TestFixtureSetUp]
        public void Init()
        {
            _repositoryUser = new Mock<I_Repository<UserDO>>();
            _repositorySystem = new Mock<I_Repository<SystemDO>>();
            _repositoryOrganisationLevel = new Mock<I_Repository<Organisation_LevelDO>>();
            _repositoryOrganisationRole = new Mock<I_Repository<Organisation_RoleDO>>();
            _repositoryReportUsers = new Mock<I_Repository<ReportUserDO>>();
            _repositorySystemUsers = new Mock<I_Repository<SystemUserDO>>();

            // mock login session
            _sessionMock = new Mock<I_LoginSession>();
            _sessionMock.Setup(e => e.intUserId).Returns(1);
            _sessionMock.Setup(e => e.isSystemUser).Returns(false);

            _externalList = new External_GroupDO[]
            {
                new External_GroupDO(){ External_GroupId = 1, Name ="External group 1", Status = 1},
                new External_GroupDO(){ External_GroupId = 2, Name ="External group 2", Status = 1},
            };
            _levelList = new Organisation_LevelDO[]
            {
                new Organisation_LevelDO() { LevelId = 1,SystemId = 1,Name ="Level1", Sort = 0, Status = 1 },
                new Organisation_LevelDO() { LevelId = 2,SystemId = 2,Name ="Level2", Sort = 1, Status = 1 },
                new Organisation_LevelDO() { LevelId = 3,SystemId = 1,Name ="Level3", Sort = 2, Status = 1 },
            };
            _roleList = new Organisation_RoleDO[]
            {
                new Organisation_RoleDO() { Organisation_RoleId = 1, Name = "Lvl1 Role1", Status = 1, LevelId = 1, Organisation_LevelDO = _levelList[0] },
                new Organisation_RoleDO() { Organisation_RoleId = 2, Name = "Lvl1 Role2", Status = 1, LevelId = 1, Organisation_LevelDO = _levelList[0] },
                new Organisation_RoleDO() { Organisation_RoleId = 3, Name = "Lvl2 Role1", Status = 1, LevelId = 2, Organisation_LevelDO = _levelList[1] },
                new Organisation_RoleDO() { Organisation_RoleId = 4, Name = "Lvl2 Role2", Status = 1, LevelId = 2, Organisation_LevelDO = _levelList[1] },
                new Organisation_RoleDO() { Organisation_RoleId = 5, Name = "Lvl3 Role1", Status = 1, LevelId = 3, Organisation_LevelDO = _levelList[2] },
                new Organisation_RoleDO() { Organisation_RoleId = 6, Name = "Lvl3 Role2", Status = 1, LevelId = 3, Organisation_LevelDO = _levelList[2] }
            };
            _reportUser = new ReportUserDO[]
            {
                new ReportUserDO(){UserId = 1,Is_External_User = false,TeamId = 1,Organisation_RoleId = 1},
                new ReportUserDO(){UserId = 2,Is_External_User = false,TeamId = 3,Organisation_RoleId = 2},
                new ReportUserDO(){UserId = 3,Is_External_User = false,TeamId = 2,Organisation_RoleId = 17},
                new ReportUserDO(){UserId = 4,Is_External_User = false,TeamId = 6,Organisation_RoleId = 11},
            };
            _systemUser = new SystemUserDO[]
            {
                new SystemUserDO(){ UserId = 10, System_RoleId = 1 }
            };
            _userList = new UserDO[]
            {
                //test users
                new UserDO() { UserId = 10, UserName = "reportTests", Password = "6Nx0M207QM8sWqmWWZoiiQ==", FirstName = "report2", LastName = "angle authorny", Address = "123 main street", Email = "same.amy@aswigit.vn", Status = 1, SystemUserDO = new SystemUserDO(){ UserId = 10, System_RoleId = 1}, Phone = "80953445", Online_Locked_Until_Datetime = DateTime.Now, Online_No_Of_Login_Attempts = 1, Last_Online_Login_Date = DateTime.Now, Create_Date = DateTime.Now, Owner = 179, UpdatedBy = 179, Is_System_User = true },

                //admin
                new UserDO() { UserId = 1, UserName = "admin", Password = "password",Email = "admin@aswigsolutions.com", Status = 1, SystemUserDO = new SystemUserDO(){ System_RoleId = 1}, Is_System_User = true },

                //external users
                new UserDO() { UserId = 2, UserName = "testuser2", Password = "password",Email = "A.Lam@employersmutual.com.au", Status = 1, Is_System_User = false, ReportUserDOs = {new ReportUserDO() { Is_External_User = true, External_GroupId = 1, External_GroupDO = _externalList[0] }}},
                new UserDO() { UserId = 3, UserName = "testuser3", Password = "password",Email = "H.Yao@employersmutual.com.au", Status = 1, Is_System_User = false, ReportUserDOs = {new ReportUserDO() { Is_External_User = false, External_GroupId = 1, External_GroupDO = _externalList[0] }}},

                //organisation users
                new UserDO() { UserId = 4, UserName = "testuser4", Password = "password",Email = "I.DiManno@employersmutual.com.au", Status = 1, Is_System_User = false, ReportUserDOs = {new ReportUserDO() { Is_External_User = false, Organisation_RoleId = 1, Organisation_RoleDO = _roleList[0] }}},
                new UserDO() { UserId = 5, UserName = "testuser5", Password = "password",Email = "jody@employersmutual.com.au", Status = 1, Is_System_User = false, ReportUserDOs = {new ReportUserDO() { Is_External_User = false, Organisation_RoleId = 2, Organisation_RoleDO = _roleList[1] }}},
                new UserDO() { UserId = 6, UserName = "testuser6", Password = "password",Email = "j.lim@employersmutual.com.au", Status = 1, Is_System_User = false, ReportUserDOs = {new ReportUserDO() { Is_External_User = false, Organisation_RoleId = 3, Organisation_RoleDO = _roleList[2] }}},
                new UserDO() { UserId = 7, UserName = "testuser7", Password = "password",Email = "Jill@employersmutual.com.au", Status = 1, Is_System_User = false, ReportUserDOs = {new ReportUserDO() { Is_External_User = false, Organisation_RoleId = 4, Organisation_RoleDO = _roleList[3] }}},
                new UserDO() { UserId = 8, UserName = "testuser8", Password = "password",Email = "j.wells@employersmutual.com.au", Status = 1, Is_System_User = false, ReportUserDOs = {new ReportUserDO() { Is_External_User = false, Organisation_RoleId = 5, Organisation_RoleDO = _roleList[4] }}},
                new UserDO() { UserId = 9, UserName = "testuser9", Password = "password",Email = "A.Lam@employersmutual.com.au", Status = 1, Is_System_User = false, ReportUserDOs = {new ReportUserDO() { Is_External_User = false, Organisation_RoleId = 6, Organisation_RoleDO = _roleList[5] }}}
            };
            _systemList = new SystemDO[]
            {
                new SystemDO(){SystemId = 1,Name = "HEM",Description = "System for HEM",Owner = 1,UpdatedBy = 179,Create_Date = DateTime.Now,Status = 1},
                new SystemDO(){SystemId = 2,Name = "TMF",Description = "System for TMF",Owner = 1,UpdatedBy = 179,Create_Date = DateTime.Now,Status = 1},
                new SystemDO(){SystemId = 3,Name = "EML",Description = "System for EML",Owner = 1,UpdatedBy = 179,Create_Date = DateTime.Now,Status = 1}
            };
        }

        [TestFixtureTearDown]
        public void Cleanup()
        {
            _userList = null;
            _systemList = null;
            _externalList = null;
            _levelList = null;
            _roleList = null;
            _reportUser = null;
            _systemUser = null;
        }

        [Test]
        public void TestGetAllSystemReturnSuccess()
        {
            _userService = new UserService(_repositoryUser.Object, _sessionMock.Object);
            _userService.RepositorySystem = _repositorySystem.Object;

            //attach data to Mock
            _repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());
            _repositorySystem.Setup(t => t.GetQueryable()).Returns(_systemList.AsQueryable());

            //assert
            var result = _userService.GetListSystem();
            Assert.GreaterOrEqual(3, result.Count());
        }

        [Test]
        public void TestGetAllSystemReturn_ThrowException()
        {
            _userService = new UserService(_repositoryUser.Object, _sessionMock.Object);
            _userService.RepositorySystem = _repositorySystem.Object;

            //attach data to Mock
            _repositorySystem.Setup(t => t.GetQueryable()).Throws(new Exception("Error"));
            try
            {
                var result = _userService.GetListSystem();
            }
            catch (Exception ex)
            {
                //Assert
                Assert.AreEqual("Error", ex.Message);
            }
        }

        [Test]
        public void TestGetListSystemByUserSuccess()
        {
            // init
            const string email = "admin@aswigsolutions.com";

            _userService = new UserService(_repositoryUser.Object, _sessionMock.Object);

            _userService.RepositoryReportUser = _repositoryReportUsers.Object;
            _userService.RepositorySystem = _repositorySystem.Object;
            _userService.RepositoryOrganisationLevel = _repositoryOrganisationLevel.Object;
            _userService.RepositoryOrganisationRole = _repositoryOrganisationRole.Object;

            //attach data to Mock
            _repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());
            _repositorySystem.Setup(t => t.GetQueryable()).Returns(_systemList.AsQueryable());
            _repositoryOrganisationLevel.Setup(t => t.GetQueryable()).Returns(_levelList.AsQueryable());
            _repositoryOrganisationRole.Setup(t => t.GetQueryable()).Returns(_roleList.AsQueryable());
            _repositoryReportUsers.Setup(t => t.GetQueryable()).Returns(_reportUser.AsQueryable());

            var result = _userService.GetListSystemByUser(email);

            Assert.GreaterOrEqual(1, result.Count());
        }

        [Test]
        public void TestGetListSystemByUser_ThrowException()
        {
            // init
            const string email = "admin@aswigsolutions.com";

            _userService = new UserService(_repositoryUser.Object, _sessionMock.Object);

            //attach data to Mock
            _repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());
            _repositorySystem.Setup(t => t.GetQueryable()).Throws(new Exception("Error"));
            _repositoryOrganisationLevel.Setup(t => t.GetQueryable()).Returns(_levelList.AsQueryable());
            _repositoryOrganisationRole.Setup(t => t.GetQueryable()).Returns(_roleList.AsQueryable());
            _repositoryReportUsers.Setup(t => t.GetQueryable()).Returns(_reportUser.AsQueryable());

            _userService.RepositoryReportUser = _repositoryReportUsers.Object;
            _userService.RepositorySystem = _repositorySystem.Object;
            _userService.RepositoryOrganisationLevel = _repositoryOrganisationLevel.Object;
            _userService.RepositoryOrganisationRole = _repositoryOrganisationRole.Object;

            try
            {
                var result = _userService.GetListSystemByUser(email);
            }
            catch (Exception ex)
            {
                //Assert
                Assert.AreEqual("Error", ex.Message);
            }
        }

        [Test]
        public void TestIsValidUserResultValid()
        {
            // init
            var user = new User()
            {
                UserName = "admin",
                Password = "x/r4zsVD2y5FTpKYCQGMUw==#####",
                FirstName = "admin",
                LastName = "admin",
                Email = "admin@aswigsolutions.com"
            };

            _userService = new UserService(_repositoryUser.Object, _sessionMock.Object);

            //attach data to Mock
            _repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());

            var result = _userService.IsValidUser(user);
            Assert.IsFalse(result);
        }

        [Test]
        public void TestIsValidUserByUserIdResultUnValid()
        {
            // init
            var user = new User()
            {
                UserId = 1,
                UserName = "admin",
                Password = "6Nx0M207QM8sWqmWWZoiiQ==",
                FirstName = "admin",
                LastName = "admin",
                Email = "admin@aswigsolutions.com"
            };

            _userService = new UserService(_repositoryUser.Object, _sessionMock.Object);

            //attach data to Mock
            _repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());

            var result = _userService.IsValidUser(user, user.UserId);
            Assert.IsTrue(result);
        }

        [Test]
        public void TestGetUserByUserNameOrEmail()
        {
            var _statusList = new StatusDO[]
            {
                new StatusDO() {StatusId = 1, Name = "Active"},
                new StatusDO() {StatusId = 2, Name = "Deactive"}
            };

            var _repositoryStatus = new Mock<I_Repository<StatusDO>>();
            // init
            const string email = "admin@aswigsolutions.com";

            _userService = new UserService(_repositoryUser.Object, _sessionMock.Object);
            _userService.StatusRepository = _repositoryStatus.Object;

            //attach data to Mock
            _repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());
            _repositoryStatus.Setup(t => t.GetQueryable()).Returns(_statusList.AsQueryable());

            var result = _userService.GetUserByUserNameOrEmail(email);
            Assert.Greater(3, result.UserId);
        }

        [Test]
        public void TestGetUserByIdSuccess()
        {
            // init
            var _statusList = new StatusDO[]
            {
                new StatusDO() {StatusId = 1, Name = "Active"},
                new StatusDO() {StatusId = 2, Name = "Deactive"}
            };

            var _repositoryStatus = new Mock<I_Repository<StatusDO>>();

            _userService = new UserService(_repositoryUser.Object, _sessionMock.Object);

            _userService.RepositoryOrganisationRole = _repositoryOrganisationRole.Object;
            _userService.RepositoryOrganisationLevel = _repositoryOrganisationLevel.Object;
            _userService.StatusRepository = _repositoryStatus.Object;
            _userService.RepositoryReportUser = _repositoryReportUsers.Object;
            _userService.RepositorySystem = _repositorySystem.Object;

            //attach data to Mock
            _repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());
            _repositoryStatus.Setup(t => t.GetQueryable()).Returns(_statusList.AsQueryable());
            _repositoryReportUsers.Setup(t => t.GetQueryable()).Returns(_reportUser.AsQueryable());
            _repositorySystem.Setup(t => t.GetQueryable()).Returns(_systemList.AsQueryable());

            var result = _userService.GetUserById(2);
            Assert.GreaterOrEqual(2, result.UserId);
        }

        [Test]
        public void TestIsvalidUserSuccess()
        {
            // init
            var user = new User()
            {
                UserName = "admintest",
                Password = "6Nx0M207QM8sWqmWWZoiiQ==",
                FirstName = "admin",
                LastName = "Stevens",
                Address = "123 main street",
                Email = "l.le@aswigit.vn",
                Status = 1,
                Phone = "8095834958",
                Online_Locked_Until_Datetime = DateTime.Now,
                Online_No_Of_Login_Attempts = 1,
                Last_Online_Login_Date = DateTime.Now,
                Create_Date = DateTime.Now,
                Owner = 179,
                UpdatedBy = 179,
                Is_System_User = true
            };

            _userService = new UserService(_repositoryUser.Object, _sessionMock.Object);

            //attach data to Mock
            _repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());

            var result = _userService.IsValidUser(user, user.UserId);
            Assert.IsTrue(result);
        }

        [Test]
        public void TestIsvalidUser_ThrowException()
        {
            // init
            var user = new User()
            {
                UserName = "admintest",
                Password = "6Nx0M207QM8sWqmWWZoiiQ==",
                FirstName = "admin",
                LastName = "Stevens",
                Address = "123 main street",
                Email = "l.le@aswigit.vn",
                Status = 1,
                Phone = "8095834958"
            };

            _userService = new UserService(_repositoryUser.Object, _sessionMock.Object);

            //attach data to Mock
            _repositoryUser.Setup(t => t.GetQueryable()).Throws(new Exception("Error"));
            try
            {
                var result = _userService.IsValidUser(user, user.UserId);
            }
            catch (Exception ex)
            {
                // Assert
                Assert.AreEqual("Error", ex.Message);
            }
        }

        [Test]
        public void TestCreateUserSuccess()
        {
            // init
            var user = new User()
            {
                UserName = "reportTests",
                Password = "6Nx0M207QM8sWqmWWZoiiQ==",
                FirstName = "report2",
                LastName = "angle authorny",
                Address = "123 main street",
                Email = "same.amy@aswigit.vn",
                Status = 1,
                Phone = "80953445",
                Online_Locked_Until_Datetime = DateTime.Now,
                Online_No_Of_Login_Attempts = 1,
                Last_Online_Login_Date = DateTime.Now,
                Create_Date = DateTime.Now,
                System_RoleId = 1,
                LevelId = 0,
                Owner = 179,
                UpdatedBy = 179,
                Is_System_User = true,
                SystemId = 2
            };

            //init
            _repositoryUser = new Mock<I_Repository<UserDO>>();
            _repositoryUser.Setup(t => t.Insert(It.IsAny<UserDO>())).Returns(_userList[0]);

            _userService = new UserService(_repositoryUser.Object, _loginSession);
            _userService.RepositorySystemUser = _repositorySystemUsers.Object;

            var result = _userService.CreateUser(user);

            //assert
            Assert.IsNotNull(result);
            Assert.AreEqual(_userList[0].UserId, result.UserId);
            _repositoryUser.Verify(t => t.Insert(It.IsAny<UserDO>()), Times.Once());
        }

        [Test]
        public void TestCreateUser_ThrowException()
        {
            // init
            var user = new User()
            {
                UserName = "reportTests",
                Password = "123456789",
                FirstName = "Test User",
                LastName = "angle authorny",
                Address = "123 main street",
                Email = "test.amy@aswigit.vn",
                Status = 1,
                Phone = "453466564",
                Online_Locked_Until_Datetime = DateTime.Now,
                Online_No_Of_Login_Attempts = 1,
                Last_Online_Login_Date = DateTime.Now
            };

            //init
            _userService = new UserService(_repositoryUser.Object, _loginSession);

            _repositoryUser = new Mock<I_Repository<UserDO>>();
            _repositoryUser.Setup(t => t.Insert(It.IsAny<UserDO>())).Throws(new Exception("Object reference not set to an instance of an object."));
            _userService.Repository = _repositoryUser.Object;

            try
            {
                var result = _userService.CreateUser(user);
            }
            catch (Exception ex)
            {
                //Assert
                Assert.AreEqual("Object reference not set to an instance of an object.", ex.Message);
            }
        }

        [Test]
        public void TestUpdateUserSuccess()
        {
            // init
            var user = new User()
            {
                UserName = "reportTests",
                Password = "6Nx0M207QM8sWqmWWZoiiQ==",
                FirstName = "report2",
                LastName = "angle authorny",
                Address = "123 main street",
                Email = "same.amy@aswigit.vn",
                Status = 1,
                Phone = "80953445",
                Online_Locked_Until_Datetime = DateTime.Now,
                Online_No_Of_Login_Attempts = 1,
                Last_Online_Login_Date = DateTime.Now,
                Create_Date = DateTime.Now,
                System_RoleId = 1,
                LevelId = 0,
                Owner = 179,
                UpdatedBy = 179,
                Is_System_User = true,
                SystemId = 2
            };

            //init
            _userService = new UserService(_repositoryUser.Object, _loginSession);

            _repositoryUser = new Mock<I_Repository<UserDO>>();
            _repositoryUser.Setup(t => t.Insert(It.IsAny<UserDO>())).Returns(_userList[0]);
            _userService.Repository = _repositoryUser.Object;

            _repositorySystemUsers = new Mock<I_Repository<SystemUserDO>>();
            _userService.RepositorySystemUser = _repositorySystemUsers.Object;

            _repositoryReportUsers = new Mock<I_Repository<ReportUserDO>>();
            _repositoryReportUsers.Setup(t => t.GetQueryable()).Returns(_reportUser.AsQueryable());
            _userService.RepositoryReportUser = _repositoryReportUsers.Object;

            var result = _userService.CreateUser(user);
            result.UserName = "Edit username";

            result = _userService.UpdateUser(result);

            Assert.IsNotNull(result);
            Assert.Greater(result.UserId, 0);
            Assert.AreEqual(result.UserName, "Edit username");
        }
    }
}