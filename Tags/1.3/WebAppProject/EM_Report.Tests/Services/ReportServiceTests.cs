using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using NUnit.Framework;
using EM_Report.BLL.Services;
using Moq;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.BLL.Commons;

namespace EM_Report.Tests.Services
{
    [TestFixture]
    public class ReportServiceTests
    {
        //Service
        private ReportService _service;
        
        //Repository
        private Mock<I_Repository<Report>> repositoryReport;
        private Mock<I_Repository<Report_External_Access>> repositoryReport_External_Access;
        private Mock<I_Repository<Report_Organisation_Level>> repositoryReport_Organisation_Level;
        private Mock<I_Repository<User>> repositoryUser;
        private Mock<I_Repository<Organisation_Role>> repositoryOrganisation_Role;
        private Mock<I_Repository<Organisation_Level>> repositoryOrganisation_Level;
        private Mock<I_Repository<External_Group>> repositoryExternal_Group;
        private Mock<I_Repository<Report_Category>> repositoryReport_Category;
        private Mock<I_Repository<Status>> repositoryStatus;
        private Mock<I_Repository<Report_Favorite>> repositoryFavorite;
        
        //_session
        private Mock<EM_Report.BLL.Commons.I_LoginSession> loginSession;
       
        //init values
        private Report[] reportList;
        private Status[] statusList;
        private Report_Category[] categoryList;
        private User[] userList;
        private External_Group[] externalList;
        private Report_External_Access[] accessList;
        private Organisation_Level[] levelList;
        private Organisation_Role[] roleList;
        private Report_Organisation_Level[] reportOrganisationLevelList;

        [TestFixtureSetUp]
        public void Init()
        {
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(true);
            _service = new ReportService(session.Object);

            repositoryReport = new Mock<I_Repository<Report>>();
            repositoryReport_External_Access = new Mock<I_Repository<Report_External_Access>>();
            repositoryReport_Organisation_Level = new Mock<I_Repository<Report_Organisation_Level>>();
            repositoryUser = new Mock<I_Repository<User>>();
            repositoryOrganisation_Role = new Mock<I_Repository<Organisation_Role>>();
            repositoryOrganisation_Level = new Mock<I_Repository<Organisation_Level>>();
            repositoryExternal_Group = new Mock<I_Repository<External_Group>>();
            repositoryReport_Category = new Mock<I_Repository<Report_Category>>();
            repositoryStatus = new Mock<I_Repository<Status>>();
            repositoryFavorite = new Mock<I_Repository<Report_Favorite>>();

            loginSession = new Mock<I_LoginSession>();

            reportList = new Report[] 
            {
                new Report() { ReportId = 1, Name = "report1", ShortName = "shortname1", CategoryId = 1, Create_Date = DateTime.Now, Owner = 1, Status = ResourcesHelper.StatusActive, Url = "", Description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus velit libero, pellentesque at accumsan sed, suscipit auctor mauris. Maecenas tincidunt fringilla aliquam" },
                new Report() { ReportId = 2, Name = "report2", ShortName = "shortname2", CategoryId = 1, Create_Date = DateTime.Now, Owner = 1, Status = ResourcesHelper.StatusActive, Url = "", Description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus velit libero, pellentesque at accumsan sed, suscipit auctor mauris. Maecenas tincidunt fringilla aliquam" },
                new Report() { ReportId = 3, Name = "report3", ShortName = "shortname3", CategoryId = 1, Create_Date = DateTime.Now, Owner = 1, Status = ResourcesHelper.StatusActive, Url = "", Description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus velit libero, pellentesque at accumsan sed, suscipit auctor mauris. Maecenas tincidunt fringilla aliquam" },
                new Report() { ReportId = 4, Name = "report4", ShortName = "shortname4", CategoryId = 1, Create_Date = DateTime.Now, Owner = 1, Status = ResourcesHelper.StatusActive, Url = "", Description = "description" },
                new Report() { ReportId = 5, Name = "report5", ShortName = "shortname5", CategoryId = 1, Create_Date = DateTime.Now, Owner = 1, Status = ResourcesHelper.StatusActive, Url = "", Description = "description" },
                new Report() { ReportId = 6, Name = "report6", ShortName = "Morbi vel ante dolor, nec aliquet elit.", CategoryId = 1, Create_Date = DateTime.Now, Owner = 1, Status = ResourcesHelper.StatusActive, Url = "Morbi vel ante dolor, nec aliquet elit.", Description = "description" },
                new Report() { ReportId = 7, Name = "report7", ShortName = "Morbi vel ante dolor, nec aliquet elit.", CategoryId = 1, Create_Date = DateTime.Now, Owner = 2, Status = ResourcesHelper.StatusActive, Url = "Morbi vel ante dolor, nec aliquet elit.", Description = "description" },
                new Report() { ReportId = 8, Name = "report8", ShortName = "Morbi vel ante dolor, nec aliquet elit.", CategoryId = 1, Create_Date = DateTime.Now, Owner = 2, Status = ResourcesHelper.StatusActive, Url = "Morbi vel ante dolor, nec aliquet elit.", Description = "description" },
                new Report() { ReportId = 9, Name = "Lorem ipsum dolor sit amet 1", ShortName = "shortname9", CategoryId = 1, Create_Date = DateTime.Now, Owner = 2, Status = ResourcesHelper.StatusInactive, Url = "", Description = "description" },
                new Report() { ReportId = 10, Name = "Lorem ipsum dolor sit amet 2", ShortName = "shortname10", CategoryId = 1, Create_Date = DateTime.Now, Owner = 2, Status = ResourcesHelper.StatusInactive, Url = "", Description = "description" },
                new Report() { ReportId = 11, Name = "Lorem ipsum dolor sit amet 3", ShortName = "shortname11", CategoryId = 1, Create_Date = DateTime.Now, Owner = 2, Status = ResourcesHelper.StatusInactive, Url = "", Description = "description" },
            };

            statusList = new Status[]
            {
                new Status() { StatusId = 1, Name = "Active"},
                new Status() { StatusId = 2, Name = "Deactive"},
            };

            categoryList = new Report_Category[]
            {
                new Report_Category() { CategoryId = 1, Name = "cate1", Owner = 1},
                new Report_Category() { CategoryId = 2, Name = "cate2", Owner = 1},
            };

            externalList = new External_Group[]
            {
                new External_Group(){ External_GroupId = 1, Name ="External group 1", Status = 1},
                new External_Group(){ External_GroupId = 2, Name ="External group 2", Status = 1},
            };

            accessList = new Report_External_Access[]
            {
                new Report_External_Access() { External_GroupId = 1, ReportId = 1, External_Group = externalList[0] },
                new Report_External_Access() { External_GroupId = 1, ReportId = 2, External_Group = externalList[0] },
                new Report_External_Access() { External_GroupId = 1, ReportId = 3, External_Group = externalList[0] },
                new Report_External_Access() { External_GroupId = 2, ReportId = 1, External_Group = externalList[1] }
            };

            levelList = new Organisation_Level[]
            {
                //level 1 -> level 2 -> level 3 (high level -> low level)
                new Organisation_Level() { LevelId = 1, Name ="Level1", Sort = 0, Status = 1 },
                new Organisation_Level() { LevelId = 2, Name ="Level2", Sort = 1, Status = 1 },
                new Organisation_Level() { LevelId = 3, Name ="Level3", Sort = 2, Status = 1 },
            };

            roleList = new Organisation_Role[]
            {
                new Organisation_Role() { Organisation_RoleId = 1, Name = "Lvl1 Role1", Status = 1, LevelId = 1, Organisation_Level = levelList[0] },
                new Organisation_Role() { Organisation_RoleId = 2, Name = "Lvl1 Role2", Status = 1, LevelId = 1, Organisation_Level = levelList[0] },
                new Organisation_Role() { Organisation_RoleId = 3, Name = "Lvl2 Role1", Status = 1, LevelId = 2, Organisation_Level = levelList[1] },
                new Organisation_Role() { Organisation_RoleId = 4, Name = "Lvl2 Role2", Status = 1, LevelId = 2, Organisation_Level = levelList[1] },
                new Organisation_Role() { Organisation_RoleId = 5, Name = "Lvl3 Role1", Status = 1, LevelId = 3, Organisation_Level = levelList[2] },
                new Organisation_Role() { Organisation_RoleId = 6, Name = "Lvl3 Role2", Status = 1, LevelId = 3, Organisation_Level = levelList[2] }
            };

            userList = new User[] 
            {
                //admin
                new User() { UserId = 1, UserName = "admin", Password = "password", Status = 1, SystemUser = new SystemUser(){ System_RoleId = 1}, Is_System_User = true },
                //external users
                new User() { UserId = 2, UserName = "testuser2", Password = "password", Status = 1, Is_System_User = false, ReportUser = new ReportUser() { Is_External_User = true, External_GroupId = 1, External_Group = externalList[0] }},
                new User() { UserId = 3, UserName = "testuser3", Password = "password", Status = 1, Is_System_User = false, ReportUser = new ReportUser() { Is_External_User = false, External_GroupId = 1, External_Group = externalList[0] }},
                //organisation users
                new User() { UserId = 4, UserName = "testuser4", Password = "password", Status = 1, Is_System_User = false, ReportUser = new ReportUser() { Is_External_User = false, Organisation_RoleId = 1, Organisation_Role = roleList[0] }},
                new User() { UserId = 5, UserName = "testuser5", Password = "password", Status = 1, Is_System_User = false, ReportUser = new ReportUser() { Is_External_User = false, Organisation_RoleId = 2, Organisation_Role = roleList[1] }},
                new User() { UserId = 6, UserName = "testuser6", Password = "password", Status = 1, Is_System_User = false, ReportUser = new ReportUser() { Is_External_User = false, Organisation_RoleId = 3, Organisation_Role = roleList[2] }},
                new User() { UserId = 7, UserName = "testuser7", Password = "password", Status = 1, Is_System_User = false, ReportUser = new ReportUser() { Is_External_User = false, Organisation_RoleId = 4, Organisation_Role = roleList[3] }},
                new User() { UserId = 8, UserName = "testuser8", Password = "password", Status = 1, Is_System_User = false, ReportUser = new ReportUser() { Is_External_User = false, Organisation_RoleId = 5, Organisation_Role = roleList[4] }},
                new User() { UserId = 9, UserName = "testuser9", Password = "password", Status = 1, Is_System_User = false, ReportUser = new ReportUser() { Is_External_User = false, Organisation_RoleId = 6, Organisation_Role = roleList[5] }}
            };

            reportOrganisationLevelList = new Report_Organisation_Level[]
            {
                //level 1
                new Report_Organisation_Level() { ReportId = 1, LevelId = 1, Organisation_Level = levelList[0] },
                new Report_Organisation_Level() { ReportId = 4, LevelId = 1, Organisation_Level = levelList[0] },
                //level 2
                new Report_Organisation_Level() { ReportId = 2, LevelId = 2, Organisation_Level = levelList[1] },
                new Report_Organisation_Level() { ReportId = 5, LevelId = 2, Organisation_Level = levelList[1] },
                new Report_Organisation_Level() { ReportId = 7, LevelId = 3, Organisation_Level = levelList[1] },
                //level 3 - active report
                new Report_Organisation_Level() { ReportId = 3, LevelId = 3, Organisation_Level = levelList[2] },
                new Report_Organisation_Level() { ReportId = 6, LevelId = 3, Organisation_Level = levelList[2] },
                //level 3 - inactive report
                new Report_Organisation_Level() { ReportId = 9, LevelId = 3, Organisation_Level = levelList[2] },
                new Report_Organisation_Level() { ReportId = 10, LevelId = 3, Organisation_Level = levelList[2] },
                new Report_Organisation_Level() { ReportId = 11, LevelId = 3, Organisation_Level = levelList[2] },
            };
        }

        [TestFixtureTearDown]
        public void Cleanup()
        {
            reportList = null;
            statusList = null;
            categoryList = null;
            userList = null;
            externalList = null;
            accessList = null;
            levelList = null;
            roleList = null;
            reportOrganisationLevelList = null;
        }

        [Test]
        public void GetAllReportIdUserCanAcess_UserInExternalGroups_ReturnSuccess()
        {
            //init
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(false);
            _service.Session = session.Object;

            _service.Repository = repositoryReport.Object;
            _service.RepositoryStatus = repositoryStatus.Object;
            _service.RepositoryReport_Category = repositoryReport_Category.Object;
            _service.RepositoryExternal_Group = repositoryExternal_Group.Object;
            _service.RepositoryReport_External_Access = repositoryReport_External_Access.Object;
            _service.RepositoryUser = repositoryUser.Object;

            repositoryReport.Setup(t => t.GetQueryable()).Returns(reportList.AsQueryable());
            repositoryStatus.Setup(t => t.GetQueryable()).Returns(statusList.AsQueryable());
            repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(categoryList.AsQueryable());
            repositoryExternal_Group.Setup(t => t.GetQueryable()).Returns(externalList.AsQueryable());
            repositoryReport_External_Access.Setup(t => t.GetQueryable()).Returns(accessList.AsQueryable());
            repositoryUser.Setup(t => t.GetQueryable()).Returns(userList.AsQueryable());
                        
            //assert
            var result = _service.GetAllReporIdUserCanAccess(2);// { UserId = 2, UserName = "testuser2", Password = "password", Status = 1, Is_System_User = false, ReportUser = new ReportUser() { Is_External_User = true, External_GroupId = 1}},
            Assert.AreEqual(3, result.Count());
    
            //clean
        }

        [Test]
        public void GetAllReportIdUserCanAcess_UserNotInExternalGroups_ReturnEmpty()
        {
            //init
            _service.Repository = repositoryReport.Object;
            _service.RepositoryStatus = repositoryStatus.Object;
            _service.RepositoryReport_Category = repositoryReport_Category.Object;
            _service.RepositoryExternal_Group = repositoryExternal_Group.Object;
            _service.RepositoryReport_External_Access = repositoryReport_External_Access.Object;
            _service.RepositoryUser = repositoryUser.Object;

            repositoryReport.Setup(t => t.GetQueryable()).Returns(reportList.AsQueryable());
            repositoryStatus.Setup(t => t.GetQueryable()).Returns(statusList.AsQueryable());
            repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(categoryList.AsQueryable());
            repositoryExternal_Group.Setup(t => t.GetQueryable()).Returns(externalList.AsQueryable());
            repositoryReport_External_Access.Setup(t => t.GetQueryable()).Returns(accessList.AsQueryable());
            repositoryUser.Setup(t => t.GetQueryable()).Returns(userList.AsQueryable());

            //assert
            var result = _service.GetAllReporIdUserCanAccess(3);//{ UserId = 3, UserName = "testuser3", Password = "password", Status = 1, Is_System_User = false, ReportUser = new ReportUser() { Is_External_User = false, External_GroupId = 1}},
            Assert.AreEqual(0, result.Count());

            //clean
        }

        [Test]
        public void GetAllReportIdUserCanAcess_UserInOrganisation_Level3_ReturnReportsOfThisLevel()
        {
            //init
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(false);
            _service.Session = session.Object;

            _service.Repository = repositoryReport.Object;
            _service.RepositoryStatus = repositoryStatus.Object;
            _service.RepositoryReport_Category = repositoryReport_Category.Object;
            _service.RepositoryOrganisation_Level = repositoryOrganisation_Level.Object;
            _service.RepositoryReport_Organisation_Level = repositoryReport_Organisation_Level.Object;
            _service.RepositoryUser = repositoryUser.Object;

            repositoryReport.Setup(t => t.GetQueryable()).Returns(reportList.AsQueryable());
            repositoryStatus.Setup(t => t.GetQueryable()).Returns(statusList.AsQueryable());
            repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(categoryList.AsQueryable());
            repositoryOrganisation_Level.Setup(t => t.GetQueryable()).Returns(levelList.AsQueryable());
            repositoryReport_Organisation_Level.Setup(t => t.GetQueryable()).Returns(reportOrganisationLevelList.AsQueryable());
            repositoryUser.Setup(t => t.GetQueryable()).Returns(userList.AsQueryable());

            //assert
            var result = _service.GetAllReporIdUserCanAccess(9);
            Assert.AreEqual(2, result.Count());//return only ACTIVE reports belongs to this level 3

            //clean
        }

        [Test]
        public void GetAllReportIdUserCanAcess_UserInOrganisation_Level2_ReturnReportsOfThisLevel()
        {
            //init
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(false);
            _service.Session = session.Object;

            _service.Repository = repositoryReport.Object;
            _service.RepositoryStatus = repositoryStatus.Object;
            _service.RepositoryReport_Category = repositoryReport_Category.Object;
            _service.RepositoryOrganisation_Level = repositoryOrganisation_Level.Object;
            _service.RepositoryReport_Organisation_Level = repositoryReport_Organisation_Level.Object;
            _service.RepositoryUser = repositoryUser.Object;

            repositoryReport.Setup(t => t.GetQueryable()).Returns(reportList.AsQueryable());
            repositoryStatus.Setup(t => t.GetQueryable()).Returns(statusList.AsQueryable());
            repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(categoryList.AsQueryable());
            repositoryOrganisation_Level.Setup(t => t.GetQueryable()).Returns(levelList.AsQueryable());
            repositoryReport_Organisation_Level.Setup(t => t.GetQueryable()).Returns(reportOrganisationLevelList.AsQueryable());
            repositoryUser.Setup(t => t.GetQueryable()).Returns(userList.AsQueryable());


            //assert
            var result = _service.GetAllReporIdUserCanAccess(7);
            Assert.AreEqual(5, result.Count());//return ACTIVE reports belongs to this level 2 and it child level 3

            //clean
        }

        [Test]
        public void GetAllReportIdUserCanAcess_UserInOrganisation_Level1_ReturnReportsOfThisLevel()
        {
            //init
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(false);
            _service.Session = session.Object;

            _service.Repository = repositoryReport.Object;
            _service.RepositoryStatus = repositoryStatus.Object;
            _service.RepositoryReport_Category = repositoryReport_Category.Object;
            _service.RepositoryOrganisation_Level = repositoryOrganisation_Level.Object;
            _service.RepositoryReport_Organisation_Level = repositoryReport_Organisation_Level.Object;
            _service.RepositoryUser = repositoryUser.Object;

            repositoryReport.Setup(t => t.GetQueryable()).Returns(reportList.AsQueryable());
            repositoryStatus.Setup(t => t.GetQueryable()).Returns(statusList.AsQueryable());
            repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(categoryList.AsQueryable());
            repositoryOrganisation_Level.Setup(t => t.GetQueryable()).Returns(levelList.AsQueryable());
            repositoryReport_Organisation_Level.Setup(t => t.GetQueryable()).Returns(reportOrganisationLevelList.AsQueryable());
            repositoryUser.Setup(t => t.GetQueryable()).Returns(userList.AsQueryable());

            //assert
            var result = _service.GetAllReporIdUserCanAccess(4);
            Assert.AreEqual(7, result.Count());//return ACTIVE reports belongs to this level 1 and it child level 2,3

            //clean
        }

        //[Test]
        //public void GetAllReportIdUserCanAcess_UserIsOwner_ReturnAllReportOfUser()
        //{
        //    //init
        //    var session = new Mock<I_LoginSession>();
        //    session.Setup(e => e.intUserId).Returns(1);
        //    session.Setup(e => e.isSystemUser).Returns(false);
        //    _service.Session = session.Object;

        //    _service.Repository = repositoryReport.Object;
        //    _service.RepositoryStatus = repositoryStatus.Object;
        //    _service.RepositoryReport_Category = repositoryReport_Category.Object;
        //    _service.RepositoryReport_Organisation_Level = repositoryReport_Organisation_Level.Object;
        //    _service.RepositoryUser = repositoryUser.Object;

        //    repositoryReport.Setup(t => t.GetQueryable()).Returns(reportList.AsQueryable());
        //    repositoryStatus.Setup(t => t.GetQueryable()).Returns(statusList.AsQueryable());
        //    repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(categoryList.AsQueryable());
        //    repositoryReport_Organisation_Level.Setup(t => t.GetQueryable()).Returns(reportOrganisationLevelList.AsQueryable());
        //    repositoryUser.Setup(t => t.GetQueryable()).Returns(userList.AsQueryable());

        //    //assert
        //    var result = _service.GetAllReporIdUserCanAccess(1);
        //    Assert.AreEqual(6, result.Count());//return reports that user is owner

        //    //clean
        //}

        [Test]
        public void GetAllQueryable_DontHaveFilter_ReturnAll()
        {
            //init
            _service.Repository = repositoryReport.Object;
            _service.RepositoryStatus = repositoryStatus.Object;
            _service.RepositoryReport_Category = repositoryReport_Category.Object;
            _service.RepositoryReport_Organisation_Level = repositoryReport_Organisation_Level.Object;
            _service.RepositoryUser = repositoryUser.Object;
            _service.RepositoryReport_Favorite = repositoryFavorite.Object;

            repositoryReport.Setup(t => t.GetQueryable()).Returns(reportList.AsQueryable());
            repositoryStatus.Setup(t => t.GetQueryable()).Returns(statusList.AsQueryable());
            repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(categoryList.AsQueryable());
            repositoryReport_Organisation_Level.Setup(t => t.GetQueryable()).Returns(reportOrganisationLevelList.AsQueryable());
            repositoryUser.Setup(t => t.GetQueryable()).Returns(userList.AsQueryable());
            //assert
            
            var result = _service.GetAllQueryable("", "");
            Assert.AreEqual(reportList.Length, result.Count());

            //clean
        }

        [Test]
        public void GetAllReportIdUserCanAcess_IsSystemUser_ReturnAllReports()
        {
            //init
            _service.Repository = repositoryReport.Object;
            _service.RepositoryStatus = repositoryStatus.Object;
            _service.RepositoryReport_Category = repositoryReport_Category.Object;
            _service.RepositoryReport_Organisation_Level = repositoryReport_Organisation_Level.Object;
            _service.RepositoryUser = repositoryUser.Object;

            repositoryReport.Setup(t => t.GetQueryable()).Returns(reportList.AsQueryable());
            repositoryStatus.Setup(t => t.GetQueryable()).Returns(statusList.AsQueryable());
            repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(categoryList.AsQueryable());
            repositoryReport_Organisation_Level.Setup(t => t.GetQueryable()).Returns(reportOrganisationLevelList.AsQueryable());
            repositoryUser.Setup(t => t.GetQueryable()).Returns(userList.AsQueryable());

            //assert
            var result = _service.GetAllReporIdUserCanAccess(1);
            Assert.AreEqual(reportList.Length, result.Count());//return reports that user is owner

            //clean
        }

        [Test]
        public void FilterReport_KeywordExistInNameAndDescription_SearchSuccess()
        {
            //init
            _service.Repository = repositoryReport.Object;
            _service.RepositoryStatus = repositoryStatus.Object;
            _service.RepositoryReport_Category = repositoryReport_Category.Object;
            _service.RepositoryReport_Organisation_Level = repositoryReport_Organisation_Level.Object;
            _service.RepositoryUser = repositoryUser.Object;

            repositoryReport.Setup(t => t.GetQueryable()).Returns(reportList.AsQueryable());
            repositoryStatus.Setup(t => t.GetQueryable()).Returns(statusList.AsQueryable());
            repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(categoryList.AsQueryable());
            repositoryReport_Organisation_Level.Setup(t => t.GetQueryable()).Returns(reportOrganisationLevelList.AsQueryable());
            repositoryUser.Setup(t => t.GetQueryable()).Returns(userList.AsQueryable());

            //assert
            var result = _service.GetAllQueryable(string.Empty, "Lorem ipsum",null);
            Assert.AreEqual(6, result.Count());//return reports that user is owner

            //clean
        }

        [Test]
        public void FilterReport_KeywordNotExistInNameAndDescription_SearchReturnNoresult()
        {
            //init
            _service.Repository = repositoryReport.Object;
            _service.RepositoryStatus = repositoryStatus.Object;
            _service.RepositoryReport_Category = repositoryReport_Category.Object;
            _service.RepositoryReport_Organisation_Level = repositoryReport_Organisation_Level.Object;
            _service.RepositoryUser = repositoryUser.Object;

            repositoryReport.Setup(t => t.GetQueryable()).Returns(reportList.AsQueryable());
            repositoryStatus.Setup(t => t.GetQueryable()).Returns(statusList.AsQueryable());
            repositoryReport_Category.Setup(t => t.GetQueryable()).Returns(categoryList.AsQueryable());
            repositoryReport_Organisation_Level.Setup(t => t.GetQueryable()).Returns(reportOrganisationLevelList.AsQueryable());
            repositoryUser.Setup(t => t.GetQueryable()).Returns(userList.AsQueryable());

            //assert
            var result = _service.GetAllQueryable(string.Empty, "Morbi vel ",null);
            Assert.AreEqual(0, result.Count());//return reports that user is owner

            //clean
        }
    }
}

