using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using EM_Report.DAL.Infrastructure;
using EM_Report.DAL;
using EM_Report.BLL.Commons;

namespace EM_Report.Tests.Repository
{
    [TestFixture]
    public class RepositoryTests
    {
        private I_Repository<User> _repository;
        public RepositoryTests()
        {
            _repository = new RepositoryBase<User>();
        }

        [Test]
        public void GetAll_HaveData_ReturnAllValue()
        {
            //init
            var result = _repository.GetQueryable().ToList();

            //assert
            Assert.IsNotNull(result);
            Assert.Greater(result.Count(), 0);

            //clean
        }

        [Test]
        public void GetById_ValidID_ReturnItem()
        {
            //init
            var id = 1;
            var result = _repository.GetByPK(id);

            //assert
            Assert.IsNotNull(result);
            Assert.AreEqual(result.UserId, id);

            //clean
        }

        [Test]
        public void GetById_InValidID_ReturnNull()
        {
            //init
            var id = 10000000;
            var result = _repository.GetByPK(id);

            //assert
            Assert.IsNull(result);

            //clean
        }

        [Test]
        public void Get_ValidID_ReturnItem()
        {
            //init
            var id = 1;
            var user = _repository.GetByPK(id);
            var result = _repository.GetQueryable().Where(t => t.UserName == user.UserName);

            //assert
            Assert.IsNotNull(result);
            Assert.AreEqual(result.First().UserName, user.UserName);

            //clean
        }
        /*
        [Test]
        public void Last_ValidID_ReturnItem()
        {
            //init
            var user = _repository.GetAll().Last();
            var result = _repository.Last(t => t.UserName == user.UserName);

            //assert
            Assert.IsNotNull(result);
            Assert.AreEqual(result.UserName, user.UserName);

            //clean
        }

        [Test]
        public void First_ValidID_ReturnItem()
        {
            //init
            var user = _repository.GetAll().First();
            var result = _repository.First(t => t.UserName == user.UserName);

            //assert
            Assert.IsNotNull(result);
            Assert.AreEqual(result.UserName, user.UserName);

            //clean
        }

        [Test]
        public void First_InvalidQuery_ThrowException()
        {
            //init
            //assert
            Assert.Throws(typeof(InvalidOperationException), delegate { _repository.First(t => t.UserName == "randome test"); });

            //clean
        }
        */
        [Test]
        public void Insert_ValidValues_Success()
        {
            //init
            var user = new User(){ 
                Address = " address",
                UserName = "test user",
                Password = "password",
                Email = "email@aswigit.vn",
                //External_Group = null,
                FirstName = "firstname",
                LastName ="lastname",
                Phone = string.Empty,
                Status = (short)ResourcesHelper.StatusActive,
                //System_Role = null,
                //Team = null
            };
            var result = _repository.Insert(user);

            //assert
            Assert.IsNotNull(result);
            Assert.Greater(result.UserId, 0);

            //clean
            _repository.Delete(user);
        }

        [Test]
        public void Update_ValidValues_Success()
        {
            //init
            var user = new User()
            {
                Address = " address",
                UserName = "test user",
                Password = "password",
                Email = "email@aswigit.vn",
                //External_Group = null,
                FirstName = "firstname",
                LastName = "lastname",
                Phone = string.Empty,
                Status = (short)ResourcesHelper.StatusActive,
                //System_Role = null,
                //Team = null
            };
            var result = _repository.Insert(user);
            result.Address = "new address";
            result = _repository.Update(result, result.UserId);

            //assert
            Assert.IsNotNull(result);
            Assert.Greater(result.UserId, 0);
            Assert.AreEqual(result.Address, "new address");

            //clean
            _repository.Delete(user);
        }

        [Test]
        public void Delete_ValidValues_Success()
        {
            //init
            var user = new User()
            {
                Address = " address",
                UserName = "test user",
                Password = "password",
                Email = "email@aswigit.vn",
                //External_Group = null,
                FirstName = "firstname",
                LastName = "lastname",
                Phone = string.Empty,
                Status = (short)ResourcesHelper.StatusActive,
                //System_Role = null,
                //Team = null
            };
            user = _repository.Insert(user);
            _repository.Delete(user);
            var result = _repository.GetByPK(user.UserId);

            //assert
            Assert.IsNull(result);
            //clean
        }

        //[Test]
        //public void Delete_InvalidId_NoError()
        //{
        //    //init
        //    var user = new User()
        //    {
        //        Address = " address",
        //        UserName = "test user",
        //        Password = "password",
        //        Email = "email@aswigit.vn",
        //        //External_Group = null,
        //        FirstName = "firstname",
        //        LastName = "lastname",
        //        Phone = string.Empty,
        //        Status = (short)ResourcesHelper.StatusActive,
        //        //System_Role = null,
        //        //Team = null
        //    };
        //    //assert
        //    Assert.Throws(typeof(InvalidOperationException), delegate { _repository.Delete(user); });
        //    //clean
        //}

        [Test]
        public void GetPrimaryKeyName_ReturnSuccess()
        {
            //init
            var result = _repository.GetPrimaryKeyName();

            //assert
            Assert.IsNotNull(result);
            Assert.AreEqual(result, "UserId");

            //clean
        }

        [Test]
        public void GetPrimaryKeyType_ReturnSuccess()
        {
            //init
            var result = _repository.GetPrimaryKeyType();

            //assert
            Assert.IsNotNull(result);
            Assert.AreEqual(result.Name, typeof(int).Name); ;

            //clean
        }
    }
}
