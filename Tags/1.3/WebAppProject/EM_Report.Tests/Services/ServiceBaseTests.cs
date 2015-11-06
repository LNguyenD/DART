using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.BLL.Services;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models;
using Moq;
using NUnit.Framework;

namespace EM_Report.Tests.Services
{
    [TestFixture]
    public class ServiceBaseTests
    {
        private ServiceBase<UserModel, User> _service;
        private Mock<I_Repository<User>> mockRepository;

        [TestFixtureSetUp]
        public void Init()
        {
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.intUserId).Returns(1);
            session.Setup(e => e.isSystemUser).Returns(true);
            
            _service = new UserService(session.Object);
        }

        private User[] userlist;

        public ServiceBaseTests()
        {
            userlist = new User[] 
            {
                new User() { UserId = 1, Address = "address", UserName = "testuser1", Password = "password", Email = "email@aswigit.vn", FirstName = "firstname1", LastName = "lastname1", Phone = string.Empty, Status = 1},
                new User() { UserId = 2, Address = "address", UserName = "testuser2", Password = "password", Email = "email@aswigit.vn", FirstName = "firstname2", LastName = "lastname2", Phone = string.Empty, Status = 1},
                new User() { UserId = 3, Address = "address", UserName = "testuser3", Password = "password", Email = "email@aswigit.vn", FirstName = "firstname3", LastName = "lastname3", Phone = string.Empty, Status = 1},
                new User() { UserId = 4, Address = "address", UserName = "testuser4", Password = "password", Email = "email@aswigit.vn", FirstName = "firstname4", LastName = "lastname4", Phone = string.Empty, Status = 1},
                new User() { UserId = 5, Address = "address", UserName = "testuser5", Password = "password", Email = "email@aswigit.vn", FirstName = "firstname5", LastName = "lastname5", Phone = string.Empty, Status = 1},
                new User() { UserId = 6, Address = "address", UserName = "testuser6", Password = "password", Email = "email@aswigit.vn", FirstName = "firstname6", LastName = "lastname6", Phone = string.Empty, Status = 1},
                new User() { UserId = 7, Address = "address", UserName = "testuser7", Password = "password", Email = "email@aswigit.vn", FirstName = "firstname7", LastName = "lastname7", Phone = string.Empty, Status = 1},
                new User() { UserId = 8, Address = "address", UserName = "testuser8", Password = "password", Email = "email@aswigit.vn", FirstName = "firstname8", LastName = "lastname8", Phone = string.Empty, Status = 1},
                new User() { UserId = 9, Address = "address", UserName = "testuser9", Password = "password", Email = "email@aswigit.vn", FirstName = "firstname9", LastName = "lastname9", Phone = string.Empty, Status = 1},
                new User() { UserId = 10, Address = "address", UserName = "testuser10", Password = "password", Email = "email@aswigit.vn", FirstName = "firstname10", LastName = "lastname10", Phone = string.Empty, Status = 1},
                new User() { UserId = 11, Address = "address", UserName = "testuser11", Password = "password", Email = "email@aswigit.vn", FirstName = "firstname11", LastName = "lastname11", Phone = string.Empty, Status = 1},
                new User() { UserId = 12, Address = "address", UserName = "testuser12", Password = "password", Email = "email@aswigit.vn", FirstName = "firstname12", LastName = "lastname12", Phone = string.Empty, Status = 1},
            };
        }

        [Test]
        public void GetAll_HaveValue_ReturnAllItems()
        {
            //init
            mockRepository = new Mock<I_Repository<User>>();
            mockRepository.Setup(t => t.GetQueryable()).Returns(userlist.AsQueryable());
            _service.Repository = mockRepository.Object;

            var result = _service.GetAll();
            //assert
            Assert.IsNotNull(result);
            Assert.AreEqual(userlist.Count(), result.Count());
            //clean
        }

        [Test]
        public void GetAll_Novalue_ReturnEmptyList()
        {
            //init
            mockRepository = new Mock<I_Repository<User>>();
            _service.Repository = mockRepository.Object;

            var result = _service.GetAll();
            //assert
            Assert.IsNotNull(result);
            Assert.AreEqual(0, result.Count());
            //clean
        }

        [Test]
        public void GetById_ValidId_ReturnValue()
        {
            //init
            mockRepository = new Mock<I_Repository<User>>();
            mockRepository.Setup(t => t.GetByPK(userlist[0].UserId)).Returns(userlist[0]);
            _service.Repository = mockRepository.Object;

            var result = _service.GetById(userlist[0].UserId);
            //assert
            Assert.IsNotNull(result);
            Assert.AreEqual(userlist[0].UserName, result.UserName);
            //clean
        }

        [Test]
        public void GetById_InvalidId_ReturnNull()
        {
            //init
            mockRepository = new Mock<I_Repository<User>>();
            _service.Repository = mockRepository.Object;

            var result = _service.GetById((long)1000);
            //assert
            mockRepository.Verify(t => t.GetByPK(It.IsAny<object>()), Times.Once());
            Assert.IsNull(result);
            //clean
        }

        //[Test]
        //public void GetPage_Page1_ReturnSucess()
        //{
        //    //init
        //    mockRepository = new Mock<I_Repository<User>>();
        //    mockRepository.Setup(t => t.GetQueryable()).Returns(userList.AsQueryable());
        //    _service.Repository = mockRepository.Object;

        //    var result = _service.GetPaged(1, 5, string.Empty, string.Empty);
        //    //assert
        //    Assert.AreEqual(result.AsEnumerable().Count(), 5);
        //    Assert.AreEqual(result.AsEnumerable().First().UserId, userList[0].UserId);
        //    Assert.AreEqual(result.AsEnumerable().Last().UserId, userList[4].UserId);
        //    //clean
        //}

        //[Test]
        //public void GetPage_Page2_ReturnSucess()
        //{
        //    //init
        //    mockRepository = new Mock<I_Repository<User>>();
        //    mockRepository.Setup(t => t.GetQueryable()).Returns(userList.AsQueryable());
        //    _service.Repository = mockRepository.Object;

        //    var result = _service.GetPaged(2, 5, string.Empty, string.Empty);
        //    //assert
        //    Assert.AreEqual(result.AsEnumerable().Count(), 5);
        //    Assert.AreEqual(result.AsEnumerable().First().UserId, userList[5].UserId);
        //    Assert.AreEqual(result.AsEnumerable().Last().UserId, userList[9].UserId);
        //    //clean
        //}

        //[Test]
        //public void GetPage_PageIdInvalid_ReturnEmpty()
        //{
        //    //init
        //    mockRepository = new Mock<I_Repository<User>>();
        //    mockRepository.Setup(t => t.GetQueryable()).Returns(userList.AsQueryable());
        //    _service.Repository = mockRepository.Object;

        //    var result = _service.GetPaged(100, 5, string.Empty, string.Empty);
        //    //assert
        //    Assert.AreEqual(result.AsEnumerable().Count(), 0);
        //    //clean
        //}

        [Test]
        public void Create_ValidParams_Success()
        {
            //init
            mockRepository = new Mock<I_Repository<User>>();
            mockRepository.Setup(t => t.Insert(It.IsAny<User>())).Returns(userlist[0]);
            _service.Repository = mockRepository.Object;

            var result = _service.Create(new UserModel());
            //assert
            Assert.IsNotNull(result);
            Assert.AreEqual(result.UserId, userlist[0].UserId);
            mockRepository.Verify(t => t.Insert(It.IsAny<User>()), Times.Once());
            //clean
        }
    }
}

