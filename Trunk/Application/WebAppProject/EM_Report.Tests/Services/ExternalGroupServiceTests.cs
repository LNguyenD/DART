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
   public class ExternalGroupServiceTests
    {
       private Mock<I_External_GroupService> _mockexternalGroupRepository;
       private List<External_Group> _externalGroups;

       [TestFixtureSetUp]
       public void Init()
       {
           var session = new Mock<I_LoginSession>();
           session.Setup(e => e.intUserId).Returns(1);
           session.Setup(e => e.isSystemUser).Returns(true);
           _externalGroups = new List<External_Group>
            {
                new External_Group() {External_GroupId = 1,Name = "Doctors and Service Providers",Description = "Doctors and Service Providers",Status = 2,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
                new External_Group() {External_GroupId = 2,Name = "Workers",Description = "Workers",Status = 1,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
                new External_Group() {External_GroupId = 3,Name = "Agency",Description = "Agency",Status = 1,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
                new External_Group() {External_GroupId = 4,Name = "Employers",Description = "Employers",Status = 2,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179}
            };
           // Mock the Report_Categories Repository using Moq           
           this._mockexternalGroupRepository = new Mock<I_External_GroupService>();
           //return employer by employerId
           _mockexternalGroupRepository.Setup(m => m.GetById(It.IsAny<int>())).Returns((int i) => _externalGroups.Find(x => x.External_GroupId == i));
           //return all the Report_Categories
           _mockexternalGroupRepository.Setup(m => m.GetAll()).Returns(_externalGroups);
       }
       [Test]
       public void TestUpdateStatus_ReturnSuccess()
       {
           //Arrange      
           const int categoryId = 4;
           const int status = 4;
           var emp = this._mockexternalGroupRepository.Object.GetById(categoryId);

           _mockexternalGroupRepository.Setup(m => m.UpdateStatus(It.IsAny<External_Group>(), status)).Callback(
            () =>
            {
                _externalGroups[status - 1].Status = status;
                this._mockexternalGroupRepository.Object.Update(_externalGroups[status - 1], _externalGroups[status - 1].External_GroupId);

            });
           this._mockexternalGroupRepository.Object.UpdateStatus(emp, status);   // try to update External Group

           //verify the count of the list
           List<External_Group> emps = (List<External_Group>)this._mockexternalGroupRepository.Object.GetAll();
           Assert.IsNotNull(emps);
           Assert.AreEqual(4, emps.Count);// the count is the same

           //verify the changed External Group
           emp = this._mockexternalGroupRepository.Object.GetById(categoryId);
           Assert.IsNotNull(emp);
           Assert.AreEqual(status, emp.Status); // changes effectedly
       }
       [Test]
       public void TestUpdateStatus_ThrowException()
       {
           //Arrange   
           const int categoryId = 3;
           const int status = 3;
           this._mockexternalGroupRepository.Setup(m => m.Update(It.IsAny<External_Group>(), status)).Throws(new Exception("Error"));
           //Act
           try
           {
               var emp = this._mockexternalGroupRepository.Object.GetById(categoryId);
               //change status
               this._mockexternalGroupRepository.Object.UpdateStatus(emp, status);
           }
           catch (Exception ex)
           {
               // Assert
               Assert.AreEqual("Error", ex.Message);
           }
       }
    }
}
