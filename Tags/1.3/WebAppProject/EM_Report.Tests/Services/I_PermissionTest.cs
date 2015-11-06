using EM_Report.BLL.Commons;
using EM_Report.BLL.Services;
using EM_Report.Models;
using NUnit.Framework;
using Moq;

namespace EM_Report.Tests.Services
{
    [TestFixture]
    public class I_PermissionTest
    {
        I_PermissionService service;

        [TestFixtureSetUp]
        public void Init()
        {
            var session = new Mock<I_LoginSession>();
            session.Setup(e => e.lngUserId).Returns(1);
            service = new PermissionService(session.Object);
        }

        [Test]
        public void Create_NewItem_CreatedSuccess()
        {
            //init
            var modelObj = new PermissionModel { Name = "Permission1", Description = "Lorem ipsum", Status = ResourcesHelper.StatusActive };
            var result = service.CreateOrUpdate(modelObj);

            //assert
            Assert.IsNotNull(result);
            Assert.Greater(result.PermissionId, 0);

            //clean
            service.Delete(result);
        }

        [Test]
        public void Delete_ItemExisted_DeleteSuccess()
        {
            //init
            var modelObj = new PermissionModel { Name = "Permission1", Description = "Lorem ipsum", Status = ResourcesHelper.StatusActive };
            var result = service.CreateOrUpdate(modelObj);
            var id = result.PermissionId;
            service.Delete(result);
            //assert
            
            //clean
            
        }

        [Test]
        public void Update_ValidData_SaveSuccess()
        {
            //init
            var modelObj = new PermissionModel { Name = "Permission1", Description = "Lorem ipsum", Status = ResourcesHelper.StatusActive };
            modelObj = service.CreateOrUpdate(modelObj);

            modelObj = service.GetById(modelObj.PermissionId);
            modelObj.Description = "New lorem ipsum";
            service.Update(modelObj, modelObj.PermissionId);

            var result = service.GetById(modelObj.PermissionId);
            
            //assert
            Assert.IsNotNull(result);
            Assert.AreEqual(result.Description, "New lorem ipsum");

            //clean
            service.Delete(result);
        }
    }
}
