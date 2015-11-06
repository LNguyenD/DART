using System;
using System.Configuration;
using System.Data.Linq;
using System.Linq;
using EM_Report.Common.Utilities;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using NUnit.Framework;

namespace EM_Report.Tests.Repository
{
    [TestFixture]
    public class RepositoryTests
    {
        private const string STR_DartConnectionString = "DartConnectionString";

        private I_Repository<UserDO> _repository;
        private I_Repository<Organisation_RoleDO> _repositoryOrganisation_Role;

        public RepositoryTests()
        {
            DataContext context = new ReportModelDataContext(Common.Utilities.EnCryption.Decrypt(ConfigurationManager.ConnectionStrings[STR_DartConnectionString].ToString()));

            _repository = new RepositoryBase<UserDO>(context);
            _repositoryOrganisation_Role = new RepositoryBase<Organisation_RoleDO>(context);
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
            var id = 179;
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
            var id = 179;
            var user = _repository.GetByPK(id);
            var result = _repository.GetQueryable().Where(t => t.UserName == user.UserName);

            //assert
            Assert.IsNotNull(result);
            Assert.AreEqual(result.First().UserName, user.UserName);

            //clean
        }

        [Test]
        public void Insert_ValidValues_Success()
        {
            //init
            var user = new UserDO()
            {
                UserName = "test user",
                Password = "password",
                FirstName = "firstname",
                LastName = "lastname",
                Address = "address",
                Email = "email@aswigit.vn",
                Status = (short)ResourcesHelper.StatusActive,
                Phone = string.Empty,
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
            var user = new UserDO()
            {
                UserName = "test user",
                Password = "password",
                FirstName = "firstname",
                LastName = "lastname",
                Address = "address",
                Email = "email@aswigit.vn",
                Status = (short)ResourcesHelper.StatusActive,
                Phone = string.Empty,
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
            var user = new UserDO()
            {
                UserName = "test user",
                Password = "password",
                FirstName = "firstname",
                LastName = "lastname",
                Address = " address",
                Email = "email@aswigit.vn",
                Status = (short)ResourcesHelper.StatusActive,
                Phone = string.Empty,
            };

            user = _repository.Insert(user);
            _repository.Delete(user);
            var result = _repository.GetByPK(user.UserId);

            //assert
            Assert.IsNull(result);

            //clean
        }

        [Test]
        public void DeleteById_InvalidId_NoError()
        {
            //init
            var id = 10000000;

            //assert
            Assert.Throws(typeof(ArgumentNullException), delegate { _repository.DeleteById(id); });

            //clean
        }

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
            Assert.AreEqual(result.Name, typeof(int).Name);

            //clean
        }

        [Test]
        public void UpdateLevelIdOfOrganisationRole_ReturnSuccess()
        {
            var role = _repositoryOrganisation_Role.GetQueryable().FirstOrDefault();
            int? oldLevelId = role.LevelId;
            role.LevelId = role.LevelId > 1 ? oldLevelId - 1 : oldLevelId + 1;
            int? newLevelId = role.LevelId;

            role = _repositoryOrganisation_Role.Update(role, role.Organisation_RoleId);
            Assert.AreEqual(newLevelId, role.LevelId);

            role.LevelId = oldLevelId;
            _repositoryOrganisation_Role.Update(role, role.Organisation_RoleId);
        }
    }
}