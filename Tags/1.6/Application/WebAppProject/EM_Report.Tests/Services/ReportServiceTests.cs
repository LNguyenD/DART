using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using NUnit.Framework;
using EM_Report.BLL.Services;
using Moq;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Common.Utilities;
using EM_Report.Domain;

namespace EM_Report.Tests.Services
{
    [TestFixture]
    public class ReportServiceTests : BaseServiceTests
    {
        //Service
        private ReportService _service;

        //Repository
        private Mock<I_ReportService> _mock;
        private Mock<I_Repository<ReportDO>> repositoryReport;
        private Mock<I_Repository<Report_External_AccessDO>> _repositoryReport_External_Access;
        private Mock<I_Repository<Report_Organisation_LevelDO>> repositoryReport_Organisation_Level;
        private Mock<I_Repository<UserDO>> repositoryUser;
        private Mock<I_Repository<Organisation_RoleDO>> repositoryOrganisation_Role;
        private Mock<I_Repository<Organisation_LevelDO>> repositoryOrganisation_Level;
        private Mock<I_Repository<External_GroupDO>> repositoryExternal_Group;
        private Mock<I_Repository<Report_CategoryDO>> repositoryReport_Category;
        private Mock<I_Repository<StatusDO>> repositoryStatus;
        private Mock<I_Repository<Report_FavoriteDO>> repositoryFavorite;
        private Mock<I_Repository<Report_RecentlyDO>> _repositoryReportRecently;
        private Mock<I_Repository<ReportUserDO>> _repositoryReportUser;
        

        //init values
        private List<ReportDO> _reportList;
        private List<StatusDO> _statusList;
        private List<Report_CategoryDO> _categoryList;
        private List<UserDO> _userList;
        private List<External_GroupDO> _externalList;
        private List<Report_External_AccessDO> _accessList;
        private List<Organisation_LevelDO> _levelList;
        private List<Organisation_RoleDO> _roleList;
        private List<Report_Organisation_LevelDO> _reportOrganisationLevelList;
        private List<Report_FavoriteDO> _favoriteList;
        private List<Report_RecentlyDO> _reportRecently;
        private List<ReportUserDO> _reportUser;

        [TestFixtureSetUp]
        public void Init()
        {
            //var session = new Mock<I_LoginSession>();
            //session.Setup(e => e.intUserId).Returns(1);
            //session.Setup(e => e.isSystemUser).Returns(true);
            //_service = new ReportService(session.Object);

            repositoryReport = new Mock<I_Repository<ReportDO>>();
            _repositoryReport_External_Access = new Mock<I_Repository<Report_External_AccessDO>>();
            repositoryReport_Organisation_Level = new Mock<I_Repository<Report_Organisation_LevelDO>>();
            repositoryUser = new Mock<I_Repository<UserDO>>();
            repositoryOrganisation_Role = new Mock<I_Repository<Organisation_RoleDO>>();
            repositoryOrganisation_Level = new Mock<I_Repository<Organisation_LevelDO>>();
            repositoryExternal_Group = new Mock<I_Repository<External_GroupDO>>();
            repositoryReport_Category = new Mock<I_Repository<Report_CategoryDO>>();
            repositoryStatus = new Mock<I_Repository<StatusDO>>();
            repositoryFavorite = new Mock<I_Repository<Report_FavoriteDO>>();
            _repositoryReportRecently = new Mock<I_Repository<Report_RecentlyDO>>();
            _repositoryReportUser = new Mock<I_Repository<ReportUserDO>>();

            _reportList = new List<ReportDO>
                              { new ReportDO(){ReportId = 1,Name = "report1",ShortName = "shortname1",CategoryId = 1,Create_Date = DateTime.Now,Owner = 1,Status = ResourcesHelper.StatusActive,Url = "4.0.MonthEndPortfolioSnapshot", Description ="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus velit libero, pellentesque at accumsan sed, suscipit auctor mauris. Maecenas tincidunt fringilla aliquam"},
                                new ReportDO(){ReportId = 2,Name = "report2",ShortName = "shortname2",CategoryId = 1,Create_Date = DateTime.Now,Owner = 1,Status = ResourcesHelper.StatusActive,Url = "4.36.FinancialPerformanceTotalClaimsCosts", Description ="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus velit libero, pellentesque at accumsan sed, suscipit auctor mauris. Maecenas tincidunt fringilla aliquam"},
                                new ReportDO(){ReportId = 3,Name = "report3", ShortName = "shortname3",CategoryId = 2,Create_Date = DateTime.Now,Owner = 1,Status = ResourcesHelper.StatusActive,Url = "4.37.FinancialPerformanceWeeklyBenefitPaymentsBreakdown",Description ="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus velit libero, pellentesque at accumsan sed, suscipit auctor mauris. Maecenas tincidunt fringilla aliquam"},
                                new ReportDO(){ReportId = 4,Name = "report4",ShortName = "shortname4",CategoryId = 2,Create_Date = DateTime.Now,Owner = 1,Status = ResourcesHelper.StatusActive,Url = "4.12.TOOCSCoding",Description = "description"},
                                new ReportDO(){ReportId = 5,Name = "report5",ShortName = "shortname5",CategoryId = 1,Create_Date = DateTime.Now,Owner = 1,Status = ResourcesHelper.StatusActive,Url = "4.38.FinancialPerformanceMedicalPaymentsBreakdown",Description = "description"},
                                new ReportDO(){ReportId = 6,Name = "report6",ShortName = "Morbi vel ante dolor, nec aliquet elit.",CategoryId = 1, Create_Date = DateTime.Now,Owner = 1,Status = ResourcesHelper.StatusActive,Url = "Morbi vel ante dolor, nec aliquet elit.",Description = "description"},
                                new ReportDO(){ReportId = 7,Name = "report7",ShortName = "Morbi vel ante dolor, nec aliquet elit.",CategoryId = 2, Create_Date = DateTime.Now, Owner = 2,Status = ResourcesHelper.StatusActive,Url = "Morbi vel ante dolor, nec aliquet elit.",Description = "description"},
                                new ReportDO(){ReportId = 8,Name = "report8",ShortName = "Morbi vel ante dolor, nec aliquet elit.",CategoryId = 2, Create_Date = DateTime.Now,Owner = 2,Status = ResourcesHelper.StatusActive,Url = "Morbi vel ante dolor, nec aliquet elit.",Description = "description"},
                                new ReportDO(){ReportId = 9,Name = "Lorem ipsum dolor sit amet 1",ShortName = "shortname9",CategoryId = 1,Create_Date = DateTime.Now,Owner = 2,Status = ResourcesHelper.StatusInactive,Url = "4.11.ClaimInjuryManagementReviewTemplate",Description = "description"},
                                new ReportDO(){ReportId = 10,Name = "Lorem ipsum dolor sit amet 2",ShortName = "shortname10",CategoryId = 1,Create_Date = DateTime.Now, Owner = 2,Status = ResourcesHelper.StatusInactive,Url = "4.23.WeeklyBenefitsReport",Description = "description"},
                                new ReportDO(){ReportId = 11,Name = "Lorem ipsum dolor sit amet 3",ShortName = "shortname11",CategoryId = 1,Create_Date = DateTime.Now,Owner = 2,Status = ResourcesHelper.StatusInactive,Url = "4.33.Payments and Average Claim Cost",Description = "description"},
                              };
            _reportUser = new List<ReportUserDO>
                              {
                                  new ReportUserDO(){UserId = 1,Is_External_User = false,TeamId = 1,Organisation_RoleId = 1,External_GroupId = 1},
                                  new ReportUserDO(){UserId = 2, Is_External_User = false,TeamId = 2,Organisation_RoleId = 2,External_GroupId = 2},
                                  new ReportUserDO(){UserId = 3,Is_External_User = false,TeamId = 3,Organisation_RoleId = 3,External_GroupId = 3}
                              };
            _reportRecently = new List<Report_RecentlyDO>
                                  {
                                new Report_RecentlyDO(){Id = 1,ReportId = 4,UserId = 1,Create_Date = DateTime.Now},
                                new Report_RecentlyDO(){Id = 2,ReportId = 5,UserId = 2,Create_Date = DateTime.Now},
                                new Report_RecentlyDO(){Id = 3,ReportId = 3,UserId = 2,Create_Date = DateTime.Now},
                                new Report_RecentlyDO(){Id = 4,ReportId = 2,UserId = 1,Create_Date = DateTime.Now},
                                new Report_RecentlyDO(){Id = 5,ReportId = 1,UserId = 1,Create_Date = DateTime.Now}, 
                                  };
            _favoriteList = new List<Report_FavoriteDO>
                                {
                                new Report_FavoriteDO() {ReportId = 1, UserId = 2, Create_Date = DateTime.Now},
                                new Report_FavoriteDO() {ReportId = 2, UserId = 1, Create_Date = DateTime.Now},
                                new Report_FavoriteDO() {ReportId = 3, UserId = 2, Create_Date = DateTime.Now},
                                new Report_FavoriteDO() {ReportId = 4, UserId = 3, Create_Date = DateTime.Now},
                                new Report_FavoriteDO() {ReportId = 5, UserId = 4, Create_Date = DateTime.Now},
                                new Report_FavoriteDO() {ReportId = 6, UserId = 2, Create_Date = DateTime.Now}
                                };
            _statusList = new List<StatusDO>
                              {
                                new StatusDO() {StatusId = 1, Name = "Active"},
                                new StatusDO() {StatusId = 2, Name = "Deactive"}
                              };

            _categoryList = new List<Report_CategoryDO>
                                {
                                 new Report_CategoryDO() {CategoryId = 1, Name = "cate1", Owner = 1},
                                 new Report_CategoryDO() {CategoryId = 2, Name = "cate2", Owner = 1}};

            _externalList = new List<External_GroupDO>
                                {
                                new External_GroupDO() {External_GroupId = 1, Name = "External group 1", Status = 1},
                                new External_GroupDO() {External_GroupId = 2, Name = "External group 2", Status = 1}
                                };

            _accessList = new List<Report_External_AccessDO>
                              {
                                new Report_External_AccessDO(){External_GroupId = 1, ReportId = 1, External_GroupDO = _externalList[0]},
                                new Report_External_AccessDO(){External_GroupId = 2, ReportId = 2, External_GroupDO = _externalList[0]},
                                new Report_External_AccessDO(){External_GroupId = 3, ReportId = 3, External_GroupDO = _externalList[0]},
                                new Report_External_AccessDO(){External_GroupId = 4, ReportId = 1, External_GroupDO = _externalList[1]}
                              };
            _levelList = new List<Organisation_LevelDO>
                             {
                                 //level 1 -> level 2 -> level 3 (high level -> low level)
                                 new Organisation_LevelDO() {LevelId = 1, Name = "Level1", Sort = 0, Status = 1,SystemId = 2},
                                 new Organisation_LevelDO() {LevelId = 2, Name = "Level2", Sort = 1, Status = 1,SystemId = 1},
                                 new Organisation_LevelDO() {LevelId = 3, Name = "Level3", Sort = 2, Status = 1,SystemId = 1},
                             };

            _roleList = new List<Organisation_RoleDO>
                            {
                                new Organisation_RoleDO(){Organisation_RoleId = 1,Name = "Lvl1 Role1", Status = 1,LevelId = 1,Organisation_LevelDO = _levelList[0]},
                                new Organisation_RoleDO(){Organisation_RoleId = 2,Name = "Lvl1 Role2",Status = 1,LevelId = 1,Organisation_LevelDO = _levelList[0]},
                                new Organisation_RoleDO(){Organisation_RoleId = 3,Name = "Lvl2 Role1", Status = 1,LevelId = 2, Organisation_LevelDO = _levelList[1]},
                                new Organisation_RoleDO(){Organisation_RoleId = 4,Name = "Lvl2 Role2", Status = 1, LevelId = 2, Organisation_LevelDO = _levelList[1]},
                                new Organisation_RoleDO(){Organisation_RoleId = 5,Name = "Lvl3 Role1",Status = 1, LevelId = 3, Organisation_LevelDO = _levelList[2] },
                                new Organisation_RoleDO(){Organisation_RoleId = 6,Name = "Lvl3 Role2",Status = 1,LevelId = 3,Organisation_LevelDO = _levelList[2]}
                            };
            _userList = new List<UserDO>
                            {
                                //admin
                                new UserDO(){UserId = 1,UserName = "admin",Password = "password",Status = 1,Email = "l.le@aswigit.vn",SystemUserDO = new SystemUserDO() {System_RoleId = 1},Is_System_User = true},
                                //external users
                                new UserDO(){UserId = 2,UserName = "testuser2",Password = "password",Status = 1,Is_System_User = false, ReportUserDOs = {new ReportUserDO(){Is_External_User = true,External_GroupId = 1,External_GroupDO = _externalList[0]}}},
                                new UserDO(){UserId = 3,UserName = "testuser3",Password = "password", Status = 1,Is_System_User = false,ReportUserDOs = {new ReportUserDO(){Is_External_User = false,External_GroupId = 1,External_GroupDO = _externalList[0]}}},
                                //organisation users
                                new UserDO(){UserId = 4,UserName = "testuser4",Password = "password",Status = 1,Email = "admin@employersmutual.com.au",Is_System_User = false, ReportUserDOs = {new ReportUserDO(){Is_External_User = false,Organisation_RoleId = 1,Organisation_RoleDO = _roleList[0]}}},
                                new UserDO(){UserId = 5,UserName = "testuser5",Password = "password",Status = 1,Email = "H.Yao@employersmutual.com.au",Is_System_User = false,ReportUserDOs ={new ReportUserDO(){Is_External_User = false,Organisation_RoleId = 2,Organisation_RoleDO = _roleList[1]}}},
                                new UserDO(){UserId = 6,UserName = "testuser6",Password = "password",Status = 1,Is_System_User = false,ReportUserDOs = {new ReportUserDO(){Is_External_User = false, Organisation_RoleId = 3,Organisation_RoleDO = _roleList[2]}}},
                                new UserDO(){UserId = 7,UserName = "testuser7",Password = "password",Status = 1,Is_System_User = false,ReportUserDOs = {new ReportUserDO(){Is_External_User = false, Organisation_RoleId = 4,Organisation_RoleDO = _roleList[3]}}},
                                new UserDO(){UserId = 8,UserName = "testuser8",Password = "password",Status = 1,Is_System_User = false,ReportUserDOs = {new ReportUserDO(){Is_External_User = false,Organisation_RoleId = 5,Organisation_RoleDO = _roleList[4]}}},
                                new UserDO(){UserId = 9,UserName = "testuser9",Password = "password",Status = 1,Email = "A.Dang@hotelemployersmutual.com.au",Is_System_User = false,ReportUserDOs = {new ReportUserDO(){Is_External_User = false,Organisation_RoleId = 6,Organisation_RoleDO = _roleList[5]}}}
                            };
            _reportOrganisationLevelList = new List<Report_Organisation_LevelDO>
                            {
                                //level 1
                                new Report_Organisation_LevelDO(){ReportId = 1, LevelId = 1, Organisation_LevelDO = _levelList[0]},
                                new Report_Organisation_LevelDO(){ReportId = 4, LevelId = 1, Organisation_LevelDO = _levelList[0]},
                                //level 2
                                new Report_Organisation_LevelDO(){ReportId = 2, LevelId = 2, Organisation_LevelDO = _levelList[1]} ,
                                new Report_Organisation_LevelDO(){ReportId = 5, LevelId = 2, Organisation_LevelDO = _levelList[1]},
                                new Report_Organisation_LevelDO(){ReportId = 7, LevelId = 3, Organisation_LevelDO = _levelList[1]},
                                //level 3 - active report
                                new Report_Organisation_LevelDO(){ReportId = 3, LevelId = 3, Organisation_LevelDO = _levelList[2]},
                                new Report_Organisation_LevelDO(){ReportId = 6, LevelId = 3, Organisation_LevelDO = _levelList[2]},
                                //level 3 - inactive report
                                new Report_Organisation_LevelDO(){ReportId = 9, LevelId = 3, Organisation_LevelDO = _levelList[2]},
                                new Report_Organisation_LevelDO(){ReportId = 10,LevelId = 3,Organisation_LevelDO = _levelList[2] },
                                new Report_Organisation_LevelDO(){ReportId = 11,LevelId = 3,Organisation_LevelDO = _levelList[2]},
                            };
        }

        [TestFixtureTearDown]
        public void Cleanup()
        {
            _reportList = null;
            _statusList = null;
            _categoryList = null;
            _userList = null;
            _externalList = null;
            _accessList = null;
            _levelList = null;
            _roleList = null;
            _reportOrganisationLevelList = null;
        }

        [Test]
        public void GetAllReportIdUserCanAcess_UserInExternalGroups_ReturnSuccess()
        {
            //init
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(false);
            
            _service = new ReportService(repositoryReport.Object, session.Object);

            _service.Repository = repositoryReport.Object;
            _service.RepositoryStatus = repositoryStatus.Object;
            _service.RepositoryReport_Category = repositoryReport_Category.Object;
            _service.RepositoryExternal_Group = repositoryExternal_Group.Object;
            _service.RepositoryReport_External_Access = _repositoryReport_External_Access.Object;
            _service.RepositoryUser = repositoryUser.Object;

            repositoryReport.Setup(t => t.GetQueryable()).Returns(_reportList.AsQueryable());
            repositoryStatus.Setup(t => t.GetQueryable()).Returns(_statusList.AsQueryable());
            repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(_categoryList.AsQueryable());
            repositoryExternal_Group.Setup(t => t.GetQueryable()).Returns(_externalList.AsQueryable());
            _repositoryReport_External_Access.Setup(t => t.GetQueryable()).Returns(_accessList.AsQueryable());
            repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());

            //assert
            var result = _service.GetAllReporIdUserCanAccess(2);// { UserId = 2, UserName = "testuser2", Password = "password", Status = 1, Is_System_User = false, ReportUser = new ReportUser() { Is_External_User = true, External_GroupId = 1}},
            Assert.AreEqual(3, result.Count());
            //clean
        }

        [Test]
        public void GetAllReportIdUserCanAcess_UserNotInExternalGroups_ReturnSuccess()
        {
            //init, systemUser is true
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(true);
            _service = new ReportService(repositoryReport.Object, session.Object);

            _service.Repository = repositoryReport.Object;
            _service.RepositoryStatus = repositoryStatus.Object;
            _service.RepositoryReport_Category = repositoryReport_Category.Object;
            _service.RepositoryExternal_Group = repositoryExternal_Group.Object;
            _service.RepositoryReport_External_Access = _repositoryReport_External_Access.Object;
            _service.RepositoryUser = repositoryUser.Object;

            repositoryReport.Setup(t => t.GetQueryable()).Returns(_reportList.AsQueryable());
            repositoryStatus.Setup(t => t.GetQueryable()).Returns(_statusList.AsQueryable());
            repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(_categoryList.AsQueryable());
            repositoryExternal_Group.Setup(t => t.GetQueryable()).Returns(_externalList.AsQueryable());
            _repositoryReport_External_Access.Setup(t => t.GetQueryable()).Returns(_accessList.AsQueryable());
            repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());

            //assert
            var result = _service.GetAllReporIdUserCanAccess(3);//{ UserId = 3, UserName = "testuser3", Password = "password", Status = 1, Is_System_User = false, ReportUser = new ReportUser() { Is_External_User = false, External_GroupId = 1}},
            Assert.AreEqual(11, result.Count());
            //clean
        }

        [Test]
        public void GetAllReportIdUserCanAcess_UserInOrganisation_Level3_ReturnReportsOfThisLevel()
        {
            //init
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(false);
            //_service.Session = session.Object;
            _service = new ReportService(repositoryReport.Object, session.Object);

            repositoryReport.Setup(t => t.GetQueryable()).Returns(_reportList.AsQueryable());
            repositoryStatus.Setup(t => t.GetQueryable()).Returns(_statusList.AsQueryable());
            repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(_categoryList.AsQueryable());
            repositoryOrganisation_Level.Setup(t => t.GetQueryable()).Returns(_levelList.AsQueryable());
            repositoryReport_Organisation_Level.Setup(t => t.GetQueryable()).Returns(_reportOrganisationLevelList.AsQueryable());
            repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());
            repositoryOrganisation_Level.Setup(m => m.GetByPK(It.IsAny<int>())).Returns((int i) => _levelList.Find(x => x.LevelId == i));


            _service.Repository = repositoryReport.Object;
            _service.RepositoryStatus = repositoryStatus.Object;
            _service.RepositoryReport_Category = repositoryReport_Category.Object;
            _service.RepositoryOrganisation_Level = repositoryOrganisation_Level.Object;
            _service.RepositoryReport_Organisation_Level = repositoryReport_Organisation_Level.Object;
            _service.RepositoryUser = repositoryUser.Object;

            var test = _service.RepositoryOrganisation_Level.GetByPK(3);

            //assert
            var result = _service.GetAllReporIdUserCanAccess(9);
            Assert.AreEqual(5, result.Count());//return only ACTIVE reports belongs to this level 3
        }

        [Test]
        public void GetAllReportIdUserCanAcess_UserInOrganisation_Level2_ReturnReportsOfThisLevel()
        {
            //init
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(false);
            //_service.Session = session.Object;
            _service = new ReportService(repositoryReport.Object, session.Object);

            _service.Repository = repositoryReport.Object;
            _service.RepositoryStatus = repositoryStatus.Object;
            _service.RepositoryReport_Category = repositoryReport_Category.Object;
            _service.RepositoryOrganisation_Level = repositoryOrganisation_Level.Object;
            _service.RepositoryReport_Organisation_Level = repositoryReport_Organisation_Level.Object;
            _service.RepositoryUser = repositoryUser.Object;

            repositoryReport.Setup(t => t.GetQueryable()).Returns(_reportList.AsQueryable());
            repositoryStatus.Setup(t => t.GetQueryable()).Returns(_statusList.AsQueryable());
            repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(_categoryList.AsQueryable());
            repositoryOrganisation_Level.Setup(t => t.GetQueryable()).Returns(_levelList.AsQueryable());
            repositoryReport_Organisation_Level.Setup(t => t.GetQueryable()).Returns(
            _reportOrganisationLevelList.AsQueryable());
            repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());
            repositoryOrganisation_Level.Setup(m => m.GetByPK(It.IsAny<int>())).Returns((int i) => _levelList.Find(x => x.LevelId == i));

            //assert
            var result = _service.GetAllReporIdUserCanAccess(7);
            Assert.AreEqual(8, result.Count()); //return ACTIVE reports belongs to this level 2 and it child level 3
            //clean
        }

        [Test]
        public void GetAllReportIdUserCanAcess_UserInOrganisation_Level1_ReturnReportsOfThisLevel()
        {
            //init
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(false);
            //_service.Session = session.Object;
            _service = new ReportService(repositoryReport.Object, session.Object);

            _service.Repository = repositoryReport.Object;
            _service.RepositoryStatus = repositoryStatus.Object;
            _service.RepositoryReport_Category = repositoryReport_Category.Object;
            _service.RepositoryOrganisation_Level = repositoryOrganisation_Level.Object;
            _service.RepositoryReport_Organisation_Level = repositoryReport_Organisation_Level.Object;
            _service.RepositoryUser = repositoryUser.Object;

            repositoryReport.Setup(t => t.GetQueryable()).Returns(_reportList.AsQueryable());
            repositoryStatus.Setup(t => t.GetQueryable()).Returns(_statusList.AsQueryable());
            repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(_categoryList.AsQueryable());
            repositoryOrganisation_Level.Setup(t => t.GetQueryable()).Returns(_levelList.AsQueryable());
            repositoryReport_Organisation_Level.Setup(t => t.GetQueryable()).Returns(_reportOrganisationLevelList.AsQueryable());
            repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());
            repositoryOrganisation_Level.Setup(m => m.GetByPK(It.IsAny<int>())).Returns((int i) => _levelList.Find(x => x.LevelId == i));

            //assert
            var result = _service.GetAllReporIdUserCanAccess(4);
            Assert.AreEqual(2, result.Count()); //return ACTIVE reports belongs to this level 1 and it child level 2,3
            //clean
        }

        [Test]
        public void GetAllQueryable_DontHaveFilter_ReturnAll()
        {
            //init
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(true);
            _service = new ReportService(repositoryReport.Object, session.Object);

            _service.Repository = repositoryReport.Object;
            _service.RepositoryStatus = repositoryStatus.Object;
            _service.RepositoryReport_Category = repositoryReport_Category.Object;
            _service.RepositoryReport_Organisation_Level = repositoryReport_Organisation_Level.Object;
            _service.RepositoryUser = repositoryUser.Object;
            _service.RepositoryReport_Favorite = repositoryFavorite.Object;

            repositoryReport.Setup(t => t.GetQueryable()).Returns(_reportList.AsQueryable());
            repositoryStatus.Setup(t => t.GetQueryable()).Returns(_statusList.AsQueryable());
            repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(_categoryList.AsQueryable());
            repositoryReport_Organisation_Level.Setup(t => t.GetQueryable()).Returns(
                _reportOrganisationLevelList.AsQueryable());
            repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());
            //assert

            var result = _service.GetAllQueryable("", "");
            Assert.AreEqual(_reportList.Count(), result.Count());

            //clean
        }

        [Test]
        public void GetAllReportIdUserCanAcess_IsSystemUser_ReturnAllReports()
        {
            //init
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(true);
            _service = new ReportService(repositoryReport.Object, session.Object);

            _service.Repository = repositoryReport.Object;
            _service.RepositoryStatus = repositoryStatus.Object;
            _service.RepositoryReport_Category = repositoryReport_Category.Object;
            _service.RepositoryReport_Organisation_Level = repositoryReport_Organisation_Level.Object;
            _service.RepositoryUser = repositoryUser.Object;

            repositoryReport.Setup(t => t.GetQueryable()).Returns(_reportList.AsQueryable());
            repositoryStatus.Setup(t => t.GetQueryable()).Returns(_statusList.AsQueryable());
            repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(_categoryList.AsQueryable());
            repositoryReport_Organisation_Level.Setup(t => t.GetQueryable()).Returns(_reportOrganisationLevelList.AsQueryable());
            repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());
            repositoryOrganisation_Level.Setup(m => m.GetByPK(It.IsAny<int>())).Returns((int i) => _levelList.Find(x => x.LevelId == i));

            //assert
            var result = _service.GetAllReporIdUserCanAccess(1);// userId 1
            Assert.AreEqual(_reportList.Count, result.Count()); //return reports that user is owner

            //clean
        }

        [Test]
        public void FilterReport_KeywordExistInNameAndDescription_SearchSuccess()
        {
            //init
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(true);
            _service = new ReportService(repositoryReport.Object, session.Object);

            _service.Repository = repositoryReport.Object;
            _service.RepositoryStatus = repositoryStatus.Object;
            _service.RepositoryReport_Category = repositoryReport_Category.Object;
            _service.RepositoryReport_Organisation_Level = repositoryReport_Organisation_Level.Object;
            _service.RepositoryUser = repositoryUser.Object;

            repositoryReport.Setup(t => t.GetQueryable()).Returns(_reportList.AsQueryable());
            repositoryStatus.Setup(t => t.GetQueryable()).Returns(_statusList.AsQueryable());
            repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(_categoryList.AsQueryable());
            repositoryReport_Organisation_Level.Setup(t => t.GetQueryable()).Returns(
                _reportOrganisationLevelList.AsQueryable());
            repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());

            //assert
            var result = _service.GetAllQueryable(string.Empty, "Lorem ipsum", null);
            Assert.AreEqual(6, result.Count()); //return reports that user is owner

            //clean
        }

        [Test]
        public void FilterReport_KeywordNotExistInNameAndDescription_SearchReturnEmty()
        {
            //init
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(true);
            _service = new ReportService(repositoryReport.Object, session.Object);

            _service.Repository = repositoryReport.Object;
            _service.RepositoryStatus = repositoryStatus.Object;
            _service.RepositoryReport_Category = repositoryReport_Category.Object;
            _service.RepositoryReport_Organisation_Level = repositoryReport_Organisation_Level.Object;
            _service.RepositoryUser = repositoryUser.Object;

            repositoryReport.Setup(t => t.GetQueryable()).Returns(_reportList.AsQueryable());
            repositoryStatus.Setup(t => t.GetQueryable()).Returns(_statusList.AsQueryable());
            repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(_categoryList.AsQueryable());
            repositoryReport_Organisation_Level.Setup(t => t.GetQueryable()).Returns(
                _reportOrganisationLevelList.AsQueryable());
            repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());

            //assert
            var result = _service.GetAllQueryable(string.Empty, "Morbi vel ", null);
            Assert.AreEqual(0, result.Count()); //return no report

            //clean
        }

        //[Test]
        //public void TestGetReportByReportPathReturnSuccess()
        //{
        //    //init
        //    var session = new Mock<I_LoginSession>();
        //    session.Setup(e => e.intUserId).Returns(1);
        //    session.Setup(e => e.isSystemUser).Returns(true);
        //    _service = new ReportService(repositoryReport.Object, session.Object);

        //    _service.Repository = repositoryReport.Object;

        //    repositoryReport.Setup(t => t.GetQueryable()).Returns(_reportList.AsQueryable());

        //    var result = _service.GetReportByReportPath("4.12.TOOCSCoding");
        //    //assert
        //    Assert.IsNotNull(result);

        //}

        [Test]
        public void TestGetReportByReportPath_ThrownException()
        {
            //init
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(true);
            _service = new ReportService(repositoryReport.Object, session.Object);

            _service.Repository = repositoryReport.Object;

            repositoryReport.Setup(t => t.GetQueryable()).Throws(new Exception("Error")); ;

            //Act
            try
            {
                var result = _service.GetReportByReportPath("4.12.TOOCSCoding");
            }
            catch (Exception ex)
            {
                // Assert
                Assert.AreEqual("Error", ex.Message);
            }
            //assert
        }

        [Test]
        public void TestCreateOrUpdateReportReturnSuccess()
        {
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(true);
            _service = new ReportService(repositoryReport.Object, session.Object);

            repositoryReport.Setup(t => t.Insert(It.IsAny<ReportDO>())).Returns(_reportList[1]);
            //_service.Repository = repositoryReport.Object;

            var result = _service.CreateOrUpdate(new Report());

            //assert
            Assert.IsNotNull(result);
            Assert.AreEqual(_reportList[1].ReportId, result.ReportId);
            repositoryReport.Verify(t => t.Insert(It.IsAny<ReportDO>()), Times.AtLeastOnce());
        }

        [Test]
        public void TestCreateOrUpdateReport_ThrownException()
        {
            //Arrange
            ReportDO data = null;
            repositoryReport.Setup(t => t.Insert(It.IsAny<ReportDO>())).Throws(new Exception()); ;
            _service.Repository = repositoryReport.Object;

            var result = _service.CreateOrUpdate(new Report());

            //assert
            Assert.IsNull(result);
        }

        [Test]
        public void TestGetAllReporIdUserCanAccessSuccess()
        {
            //init
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(false); // assign systemuser is false
            //_service.Session = session.Object;
            _service = new ReportService(repositoryReport.Object, session.Object);

            _service.Repository = repositoryReport.Object;
            _service.RepositoryStatus = repositoryStatus.Object;
            _service.RepositoryReport_Category = repositoryReport_Category.Object;
            _service.RepositoryReport_Organisation_Level = repositoryReport_Organisation_Level.Object;
            _service.RepositoryUser = repositoryUser.Object;

            repositoryReport.Setup(t => t.GetQueryable()).Returns(_reportList.AsQueryable());
            repositoryStatus.Setup(t => t.GetQueryable()).Returns(_statusList.AsQueryable());
            repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(_categoryList.AsQueryable());
            repositoryReport_Organisation_Level.Setup(t => t.GetQueryable()).Returns(
                _reportOrganisationLevelList.AsQueryable());
            repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());

            var result = _service.GetAllReporIdUserCanAccess(_userList[2].UserId);

            //assert
            Assert.IsNotNull(result);
            Assert.GreaterOrEqual(1, result.Count());
        }

        //[Test]
        //public void TestGetAllReportUserCanAccessByFilter_UserInExternalGroups_ReturnSuccess()
        //{
        //    //init
        //    var session = new Mock<I_LoginSession>();
        //    session.Setup(e => e.intUserId).Returns(1);
        //    session.Setup(e => e.isSystemUser).Returns(false);
        //    //_service.Session = session.Object;
        //    _service = new ReportService(repositoryReport.Object, session.Object);

        //    _service.Repository = repositoryReport.Object;
        //    _service.RepositoryReport_Category = repositoryReport_Category.Object;
        //    _service.RepositoryReport_Favorite = repositoryFavorite.Object;
        //    _service.RepositoryExternal_Group = repositoryExternal_Group.Object;
        //    _service.RepositoryReport_External_Access = _repositoryReport_External_Access.Object;
        //    _service.RepositoryUser = repositoryUser.Object;

        //    repositoryReport.Setup(t => t.GetQueryable()).Returns(_reportList.AsQueryable());
        //    repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(_categoryList.AsQueryable());
        //    repositoryExternal_Group.Setup(t => t.GetQueryable()).Returns(_externalList.AsQueryable());
        //    _repositoryReport_External_Access.Setup(t => t.GetQueryable()).Returns(_accessList.AsQueryable());
        //    repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());
        //    repositoryFavorite.Setup(t => t.GetQueryable()).Returns(_favoriteList.AsQueryable());

        //    var result = _service.GetAllReportUserCanAccess(0, _userList[1].UserId, _userList[1].Is_System_User,
        //                                                    "Name|desc", "report");
        //    //assert
        //    Assert.IsNotNull(result);
        //    Assert.AreEqual(3, result.Count()); // return list reports belongs to User 1
        //}

        //[Test]
        //public void TestGetAllReportUserCanAccess_ByCategoryFilter_UserNotExternalGroups_ReturnEmpty()
        //{
        //    //init
        //    _service.Repository = repositoryReport.Object;
        //    _service.RepositoryStatus = repositoryStatus.Object;
        //    _service.RepositoryReport_Category = repositoryReport_Category.Object;
        //    _service.RepositoryExternal_Group = repositoryExternal_Group.Object;
        //    _service.RepositoryOrganisation_Level = repositoryOrganisation_Level.Object;
        //    _service.RepositoryReport_External_Access = _repositoryReport_External_Access.Object;
        //    _service.RepositoryUser = repositoryUser.Object;


        //    repositoryReport.Setup(t => t.GetQueryable()).Returns(_reportList.AsQueryable());
        //    repositoryStatus.Setup(t => t.GetQueryable()).Returns(_statusList.AsQueryable());
        //    repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(_categoryList.AsQueryable());
        //    repositoryExternal_Group.Setup(t => t.GetQueryable()).Returns(_externalList.AsQueryable());
        //    _repositoryReport_External_Access.Setup(t => t.GetQueryable()).Returns(_accessList.AsQueryable());
        //    repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());

        //    var result = _service.GetAllReportUserCanAccess(0, _userList[3].UserId, _userList[1].Is_System_User,
        //                                                    _categoryList[1].CategoryId, "Name|desc", "report");
        //    //assert
        //    Assert.AreEqual(0, result.Count());
        //}

        //[Test]
        //public void TestGetFavoriteReportReturnEmpty()
        //{
        //    //init
        //    var session = new Mock<I_LoginSession>();
        //    session.Setup(e => e.intUserId).Returns(1);
        //    session.Setup(e => e.isSystemUser).Returns(true);
        //    _service = new ReportService(repositoryReport.Object, session.Object);

        //    _service.Repository = repositoryReport.Object;
        //    _service.RepositoryReport_Favorite = repositoryFavorite.Object;
        //    _service.RepositoryReport_Category = repositoryReport_Category.Object;
        //    _service.RepositoryExternal_Group = repositoryExternal_Group.Object;
        //    _service.RepositoryOrganisation_Level = repositoryOrganisation_Level.Object;
        //    _service.RepositoryReport_External_Access = _repositoryReport_External_Access.Object;
        //    _service.RepositoryUser = repositoryUser.Object;


        //    repositoryReport.Setup(t => t.GetQueryable()).Returns(_reportList.AsQueryable());
        //    repositoryFavorite.Setup(t => t.GetQueryable()).Returns(_favoriteList.AsQueryable());
        //    repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(_categoryList.AsQueryable());
        //    repositoryExternal_Group.Setup(t => t.GetQueryable()).Returns(_externalList.AsQueryable());
        //    _repositoryReport_External_Access.Setup(t => t.GetQueryable()).Returns(_accessList.AsQueryable());
        //    repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());

        //    var result = _service.GetFavoriteReport(0, _userList[2].UserId);//UserId = 2,UserName = "testuser2",Password = "password",Status = 1,Is_System_User = false,
        //    Assert.AreEqual(0, result.Count());
        //}

        //[Test]
        //public void TestGetRecentlyReportReturnSuccess()
        //{
        //    //init
        //    _service.Repository = repositoryReport.Object;
        //    _service.RepositoryReport_Recently = _repositoryReportRecently.Object;
        //    _service.RepositoryReport_Category = repositoryReport_Category.Object;
        //    _service.RepositoryExternal_Group = repositoryExternal_Group.Object;
        //    _service.RepositoryOrganisation_Level = repositoryOrganisation_Level.Object;
        //    _service.RepositoryReport_External_Access = _repositoryReport_External_Access.Object;
        //    _service.RepositoryUser = repositoryUser.Object;


        //    repositoryReport.Setup(t => t.GetQueryable()).Returns(_reportList.AsQueryable());
        //    _repositoryReportRecently.Setup(t => t.GetQueryable()).Returns(_reportRecently.AsQueryable());
        //    repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(_categoryList.AsQueryable());
        //    repositoryExternal_Group.Setup(t => t.GetQueryable()).Returns(_externalList.AsQueryable());
        //    _repositoryReport_External_Access.Setup(t => t.GetQueryable()).Returns(_accessList.AsQueryable());
        //    repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());

        //    var result = _service.GetRecentlyReport(0, _userList[1].UserId);//UserId = 1,UserName = "testuser1",Password = "password",Status = 1,Is_System_User = false
        //    Assert.GreaterOrEqual(1, result.Count());// return report3
        //}

        [Test]
        public void TestCountReportByCategoryUserCanAccess()
        {
            //init
            _reportOrganisationLevelList = new List<Report_Organisation_LevelDO>
                            {
                                //level 1
                                new Report_Organisation_LevelDO(){ReportId = 1, LevelId = 1, Organisation_LevelDO = _levelList[0]},
                                new Report_Organisation_LevelDO(){ReportId = 4, LevelId = 1, Organisation_LevelDO = _levelList[0]},
                                //level 2
                                new Report_Organisation_LevelDO(){ReportId = 2, LevelId = 2, Organisation_LevelDO = _levelList[1]} ,
                                new Report_Organisation_LevelDO(){ReportId = 5, LevelId = 2, Organisation_LevelDO = _levelList[1]},
                                new Report_Organisation_LevelDO(){ReportId = 7, LevelId = 3, Organisation_LevelDO = _levelList[1]},
                                //level 3 - active report
                                new Report_Organisation_LevelDO(){ReportId = 3, LevelId = 3, Organisation_LevelDO = _levelList[2]},
                                new Report_Organisation_LevelDO(){ReportId = 6, LevelId = 3, Organisation_LevelDO = _levelList[2]},
                                //level 3 - inactive report
                                new Report_Organisation_LevelDO(){ReportId = 9, LevelId = 3, Organisation_LevelDO = _levelList[2]},
                                new Report_Organisation_LevelDO(){ReportId = 10,LevelId = 3,Organisation_LevelDO = _levelList[2] },
                                new Report_Organisation_LevelDO(){ReportId = 11,LevelId = 3,Organisation_LevelDO = _levelList[2]},
                            };

            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(false);
            _service = new ReportService(repositoryReport.Object, session.Object);

            _service.Repository = repositoryReport.Object;
            _service.RepositoryReport_Recently = _repositoryReportRecently.Object;
            _service.RepositoryReport_Category = repositoryReport_Category.Object;
            _service.RepositoryExternal_Group = repositoryExternal_Group.Object;
            _service.RepositoryOrganisation_Level = repositoryOrganisation_Level.Object;
            _service.RepositoryReport_External_Access = _repositoryReport_External_Access.Object;
            _service.RepositoryUser = repositoryUser.Object;
            _service.RepositoryReport_Organisation_Level = repositoryReport_Organisation_Level.Object;


            repositoryReport.Setup(t => t.GetQueryable()).Returns(_reportList.AsQueryable());
            _repositoryReportRecently.Setup(t => t.GetQueryable()).Returns(_reportRecently.AsQueryable());
            repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(_categoryList.AsQueryable());
            repositoryExternal_Group.Setup(t => t.GetQueryable()).Returns(_externalList.AsQueryable());
            _repositoryReport_External_Access.Setup(t => t.GetQueryable()).Returns(_accessList.AsQueryable());
            repositoryUser.Setup(t => t.GetQueryable()).Returns(_userList.AsQueryable());
            repositoryReport_Organisation_Level.Setup(t => t.GetQueryable()).Returns(_reportOrganisationLevelList.AsQueryable());
            repositoryOrganisation_Level.Setup(t => t.GetQueryable()).Returns(_levelList.AsQueryable());

            var result = _service.CountReportByCategoryUserCanAccess(_userList[3].UserId, _categoryList[1].CategoryId);

            //assert
            Assert.IsNotNull(result);
            Assert.GreaterOrEqual(1, result);// return report7
        }

        [Test]
        public void TestAddOrRemoveFavoriteReportSeccess()
        {
            //init

            _mock = new Mock<I_ReportService>();
            _mock.Object.AddOrRemoveFavoriteReport(_favoriteList[0].UserId, _favoriteList[0].ReportId);

            // verify result
            _mock.Verify(c => c.AddOrRemoveFavoriteReport(_favoriteList[0].UserId, _favoriteList[0].ReportId), "Added Favorite Report fail");

        }

        [Test]
        public void TestAddReportExternalAccessSuccess()
        {
            //init 
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(true);
            _service = new ReportService(repositoryReport.Object, session.Object);

            _repositoryReport_External_Access.Setup(t => t.GetQueryable()).Returns(_accessList.AsQueryable());
            _service.RepositoryReport_External_Access = _repositoryReport_External_Access.Object;

            var reportPermission = new ReportPermission()
            {
                ReportId = 4
            ,
                ReportExternalAccessList = new List<Report_External_Access>() { new Report_External_Access() { ReportId = 4, ReportName = "report3", Create_Date = DateTime.Now, ExternalGroupName = "External group 3" } }
            ,
                ReportOrganisationLevelList = new List<Report_Organisation_Levels>() { new Report_Organisation_Levels() { LevelId = 1, LevelName = "level 1", ReportId = 4, Create_Date = DateTime.Now } }
            };
            var reportExternalAccess = new Report_External_Access() { External_GroupId = 2, ReportId = 4, ExternalGroupName = "Test", Create_Date = DateTime.Now, ReportName = "report4" };

            //set up to test add new ReportCategory
            _repositoryReport_External_Access.Setup(m => m.Insert(It.IsAny<Report_External_AccessDO>())).Callback(
                (Report_External_AccessDO target) =>
                {
                    if (target.External_GroupId > 0)
                    {
                        target.External_GroupId = _accessList.Count + 1;
                        _accessList.Add(target);
                    }
                });

            _service.AddReportExternalAccess(reportPermission, reportExternalAccess);
            var result = _service.RepositoryReport_External_Access.GetQueryable();
            //verify
            Assert.GreaterOrEqual(5, result.Count()); // adding Successfully

        }

        [Test]
        public void TestAddReportExternalAccess_ThrowException()
        {
            //init 
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(true);
            _service = new ReportService(repositoryReport.Object, session.Object);

            _repositoryReport_External_Access.Setup(t => t.GetQueryable()).Returns(_accessList.AsQueryable());
            _service.RepositoryReport_External_Access = _repositoryReport_External_Access.Object;

            var reportPermission = new ReportPermission()
            {
                ReportId = 4
            ,
                ReportExternalAccessList = new List<Report_External_Access>() { new Report_External_Access() { ReportId = 4, ReportName = "report3", Create_Date = DateTime.Now, ExternalGroupName = "External group 3" } }
            ,
                ReportOrganisationLevelList = new List<Report_Organisation_Levels>() { new Report_Organisation_Levels() { LevelId = 1, LevelName = "level 1", ReportId = 4, Create_Date = DateTime.Now } }
            };
            var reportExternalAccess = new Report_External_Access() { External_GroupId = 2, ReportId = 4, ExternalGroupName = "Test", Create_Date = DateTime.Now, ReportName = "report4" };

            //set up to test add new ReportCategory
            _repositoryReport_External_Access.Setup(m => m.Insert(It.IsAny<Report_External_AccessDO>())).Throws(new Exception("Error"));

            //Act
            try
            {
                _service.AddReportExternalAccess(reportPermission, reportExternalAccess);
            }
            catch (Exception ex)
            {
                // Assert
                Assert.AreEqual("Error", ex.Message);
            }

        }

        [Test]
        public void TestRemoveReportExternalAccessSuccess()
        {
            //init 
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(true);
            _service = new ReportService(repositoryReport.Object, session.Object);

            _repositoryReport_External_Access.Setup(t => t.GetQueryable()).Returns(_accessList.AsQueryable());
            _service.RepositoryReport_External_Access = _repositoryReport_External_Access.Object;
            _repositoryReport_External_Access.Setup(m => m.GetByPK(It.IsAny<int>())).Returns((int i) => _accessList.Find(x => x.External_GroupId == i));

            var reportPermission = new ReportPermission()
            {
                ReportId = 4
            ,
                ReportExternalAccessList = new List<Report_External_Access>() { new Report_External_Access() { ReportId = 4, ReportName = "report3", Create_Date = DateTime.Now, ExternalGroupName = "External group 3" } }
            ,
                ReportOrganisationLevelList = new List<Report_Organisation_Levels>() { new Report_Organisation_Levels() { LevelId = 1, LevelName = "level 1", ReportId = 4, Create_Date = DateTime.Now } }
            };
            var reportExternalAccess = new Report_External_Access() { External_GroupId = 2, ReportId = 2, ExternalGroupName = "External group 1", Create_Date = DateTime.Now, ReportName = "report4" };

            //set up to test add new ReportCategory
            this._repositoryReport_External_Access.Setup(m => m.Delete(It.IsAny<Report_External_AccessDO>())).Callback((Report_External_AccessDO target) =>
            {
                var empl = this._repositoryReport_External_Access.Object.GetByPK(target.External_GroupId);
                _accessList.Remove(empl);
            });

            _service.RemoveReportExternalAccess(reportPermission, reportExternalAccess);
            var result = _service.RepositoryReport_External_Access.GetQueryable();
            //verify
            Assert.GreaterOrEqual(4, result.Count()); // remove Successfully
        }

        [Test]
        public void TestRemoveReportExternalAccess_ThrowException()
        {
            //init 
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(true);
            _service = new ReportService(repositoryReport.Object, session.Object);

            _repositoryReport_External_Access.Setup(t => t.GetQueryable()).Returns(_accessList.AsQueryable());
            _service.RepositoryReport_External_Access = _repositoryReport_External_Access.Object;
            _repositoryReport_External_Access.Setup(m => m.GetByPK(It.IsAny<int>())).Returns((int i) => _accessList.Find(x => x.External_GroupId == i));

            var reportPermission = new ReportPermission()
            {
                ReportId = 4
            ,
                ReportExternalAccessList = new List<Report_External_Access>() { new Report_External_Access() { ReportId = 4, ReportName = "report3", Create_Date = DateTime.Now, ExternalGroupName = "External group 3" } }
            ,
                ReportOrganisationLevelList = new List<Report_Organisation_Levels>() { new Report_Organisation_Levels() { LevelId = 1, LevelName = "level 1", ReportId = 4, Create_Date = DateTime.Now } }
            };
            var reportExternalAccess = new Report_External_Access() { External_GroupId = 2, ReportId = 2, ExternalGroupName = "External group 1", Create_Date = DateTime.Now, ReportName = "report4" };

            //set up to test add new ReportCategory
            this._repositoryReport_External_Access.Setup(m => m.Delete(It.IsAny<Report_External_AccessDO>())).Throws(new Exception("Error"));
            //Act
            try
            {
                _service.RemoveReportExternalAccess(reportPermission, reportExternalAccess);
            }
            catch (Exception ex)
            {
                // Assert
                Assert.AreEqual("Error", ex.Message);
            }

        }

        [Test]
        public void TestAddOrganisationRoleSuccess()
        {
            //init 
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(true);
            _service = new ReportService(repositoryReport.Object, session.Object);

            repositoryReport_Organisation_Level.Setup(t => t.GetQueryable()).Returns(_reportOrganisationLevelList.AsQueryable());
            _service.RepositoryReport_Organisation_Level = repositoryReport_Organisation_Level.Object;

            var reportPermission = new ReportPermission()
            {
                ReportId = 4
            ,
                ReportExternalAccessList = new List<Report_External_Access>() { new Report_External_Access() { ReportId = 4, ReportName = "report3", Create_Date = DateTime.Now, ExternalGroupName = "External group 3" } }
            ,
                ReportOrganisationLevelList = new List<Report_Organisation_Levels>() { new Report_Organisation_Levels() { LevelId = 1, LevelName = "level 1", ReportId = 4, Create_Date = DateTime.Now } }
            };
            var reportOrganisationLevel = new Report_Organisation_Levels() { LevelId = 2, ReportId = 4, LevelName = "Test", Create_Date = DateTime.Now, ReportName = "report4" };

            //set up to test add new  ReportOrganisationLevel
            repositoryReport_Organisation_Level.Setup(m => m.Insert(It.IsAny<Report_Organisation_LevelDO>())).Callback(
                (Report_Organisation_LevelDO target) =>
                {
                    if (target.ReportId > 0)
                    {
                        _reportOrganisationLevelList.Add(target);
                    }
                });

            _service.AddOrganisationRole(reportPermission, reportOrganisationLevel);
            var result = _service.RepositoryReport_Organisation_Level.GetQueryable();
            //verify
            Assert.GreaterOrEqual(11, result.Count()); // adding Successfully
        }

        [Test]
        public void TestAddOrganisationRoleSuccess_ThrowException()
        {
            //init 
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(true);
            _service = new ReportService(repositoryReport.Object, session.Object);

            repositoryReport_Organisation_Level.Setup(t => t.GetQueryable()).Returns(_reportOrganisationLevelList.AsQueryable());
            _service.RepositoryReport_Organisation_Level = repositoryReport_Organisation_Level.Object;

            var reportPermission = new ReportPermission()
            {
                ReportId = 4
            ,
                ReportExternalAccessList = new List<Report_External_Access>() { new Report_External_Access() { ReportId = 4, ReportName = "report3", Create_Date = DateTime.Now, ExternalGroupName = "External group 3" } }
            ,
                ReportOrganisationLevelList = new List<Report_Organisation_Levels>() { new Report_Organisation_Levels() { LevelId = 1, LevelName = "level 1", ReportId = 4, Create_Date = DateTime.Now } }
            };
            var reportOrganisationLevel = new Report_Organisation_Levels() { LevelId = 2, ReportId = 4, LevelName = "Test", Create_Date = DateTime.Now, ReportName = "report4" };

            //set up to test add new  ReportOrganisationLevel
            repositoryReport_Organisation_Level.Setup(m => m.Insert(It.IsAny<Report_Organisation_LevelDO>())).Throws(new Exception("Error"));

            //Act
            try
            {
                _service.AddOrganisationRole(reportPermission, reportOrganisationLevel);
            }
            catch (Exception ex)
            {
                // Assert
                Assert.AreEqual("Error", ex.Message);
            }
        }
    }
}