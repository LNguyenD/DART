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
   public class ReportCategoriesServiceTest : BaseServiceTests
    {
        private Mock<I_ReportCategoriesService> _mockReportCategoryRepository;
        private Mock<ReportCategoriesService> _reportCategoryRepository;
        private Mock<ReportService> _mockReportRepository;
        private List<Report_Categories> _reportCategories;
        private List<Report> _reports;

        [TestFixtureSetUp]
        public void Init()
        {
            _reportCategories = new List<Report_Categories>
             {
                 new Report_Categories() {CategoryId = 1,Name = "Standard Reports",Description = "Standard Reports ",Status = 2,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
                 new Report_Categories() {CategoryId = 2,Name = "Management Reports",Description = "Management Reports",Status = 1,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
                 new Report_Categories() {CategoryId = 3,Name = "Board and Executive Reports",Description = "Board and Executive Reports ",Status = 1,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
                 new Report_Categories() {CategoryId = 4,Name = "Senior Management Reports",Description = "Senior Management Report",Status = 2,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179},
                 new Report_Categories() {CategoryId = 5,Name = "Operational Reports",Description = "Operational Reports",Status = 1,Create_Date = DateTime.Now,Owner = 179,UpdatedBy = 179}
             };
            _reports = new List<Report>
             { 
             new Report(){ReportId = 1,Name = "report1",ShortName = "shortname1",CategoryId = 1,Create_Date = DateTime.Now,Owner = 1,Status = ResourcesHelper.StatusActive,Url = "4.0.MonthEndPortfolioSnapshot", Description ="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus velit libero, pellentesque at accumsan sed, suscipit auctor mauris. Maecenas tincidunt fringilla aliquam"},
             new Report(){ReportId = 2,Name = "report2",ShortName = "shortname2",CategoryId = 1,Create_Date = DateTime.Now,Owner = 1,Status = ResourcesHelper.StatusActive,Url = "4.36.FinancialPerformanceTotalClaimsCosts", Description ="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus velit libero, pellentesque at accumsan sed, suscipit auctor mauris. Maecenas tincidunt fringilla aliquam"},
             new Report(){ReportId = 3,Name = "report3", ShortName = "shortname3",CategoryId = 2,Create_Date = DateTime.Now,Owner = 1,Status = ResourcesHelper.StatusActive,Url = "4.37.FinancialPerformanceWeeklyBenefitPaymentsBreakdown",Description ="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus velit libero, pellentesque at accumsan sed, suscipit auctor mauris. Maecenas tincidunt fringilla aliquam"},
             new Report(){ReportId = 4,Name = "report4",ShortName = "shortname4",CategoryId = 2,Create_Date = DateTime.Now,Owner = 1,Status = ResourcesHelper.StatusActive,Url = "4.12.TOOCSCoding",Description = "description"},
             new Report(){ReportId = 5,Name = "report5",ShortName = "shortname5",CategoryId = 1,Create_Date = DateTime.Now,Owner = 1,Status = ResourcesHelper.StatusActive,Url = "4.38.FinancialPerformanceMedicalPaymentsBreakdown",Description = "description"},
             new Report(){ReportId = 6,Name = "report6",ShortName = "Morbi vel ante dolor, nec aliquet elit.",CategoryId = 1, Create_Date = DateTime.Now,Owner = 1,Status = ResourcesHelper.StatusActive,Url = "Morbi vel ante dolor, nec aliquet elit.",Description = "description"},
             new Report(){ReportId = 7, Name = "report7",ShortName = "Morbi vel ante dolor, nec aliquet elit.",CategoryId = 2, Create_Date = DateTime.Now, Owner = 2,Status = ResourcesHelper.StatusActive,Url = "Morbi vel ante dolor, nec aliquet elit.",Description = "description"}
             };
            // Mock the Report_Categories Repository using Moq           
            this._mockReportCategoryRepository = new Mock<I_ReportCategoriesService>();
            this._mockReportRepository = new Mock<ReportService>(_loginSession);
            this._reportCategoryRepository = new Mock<ReportCategoriesService>(_loginSession);

            //return employer by employerId
            _mockReportCategoryRepository.Setup(m => m.GetById(It.IsAny<int>())).Returns((int i) => _reportCategories.Find(x => x.CategoryId == i));
            //return all the Report_Categories
            _mockReportCategoryRepository.Setup(m => m.GetAll()).Returns(_reportCategories);
            _reportCategoryRepository.Setup(m => m.GetAll()).Returns(_reportCategories);
            _mockReportRepository.Setup(m => m.GetAll()).Returns(_reports);
        }

        [Test]
        public void TestCreateOrUpdate_ReturnSuccess()
        {
            //Arrange
            var newCategory = new Report_Categories
            {
                CategoryId = 6,
                Name = "Test App",
                Description = "RTW",
                Status = 2,
                Create_Date = DateTime.Now,
                Owner = 179,
                UpdatedBy = 179
            };
            //set up to test add new ReportCategory
            _mockReportCategoryRepository.Setup(m => m.CreateOrUpdate(It.IsAny<Report_Categories>())).Callback(
                (Report_Categories target) =>
                {
                    if (target.CategoryId > 0)
                    {
                        target.CategoryId = _reportCategories.Count + 1;
                        _reportCategories.Add(target);
                    }
                });

            //verify the count of the list before adding new ReportCategory
            List<Report_Categories> emps = (List<Report_Categories>)this._mockReportCategoryRepository.Object.GetAll();
            Assert.AreEqual(5, emps.Count);

            this._mockReportCategoryRepository.Object.CreateOrUpdate(newCategory);  // try to insert new ReportCategory

            emps = (List<Report_Categories>)this._mockReportCategoryRepository.Object.GetAll();
            Assert.AreEqual(6, emps.Count); // recheck the count of the list

            var emp = this._mockReportCategoryRepository.Object.GetById(newCategory.CategoryId);
            Assert.IsNotNull(emp); // the new ReportCategory exist in the list
            Assert.AreEqual("RTW", emp.Description); //make sure can get the ReportCategory successfully

            // reset mock data
            _reportCategories.Remove(newCategory);
        }

        [Test]
        public void TestCreateOrUpdate_ThrowException()
        {
            //Arrange
            var newCategory = new Report_Categories
            {
                CategoryId = 6,
                Name = "Test",
                Description = "AWC",
                Status = 2,
                Create_Date = DateTime.Now,
                Owner = 179,
                UpdatedBy = 179
            };
            this._mockReportCategoryRepository.Setup(m => m.CreateOrUpdate(It.IsAny<Report_Categories>())).Throws(new Exception("Error"));
            //Act
            try
            {
                //try to insert new ReportCategory
                this._mockReportCategoryRepository.Object.CreateOrUpdate(newCategory);
            }
            catch (Exception ex)
            {
                // Assert
                Assert.AreEqual("Error", ex.Message);
            }
        }

        [Test]
        public void TestUpdateStatus_ReturnSuccess()
        {
            //Arrange      
            const int categoryId = 3;
            const int status = 3;
            var emp = this._mockReportCategoryRepository.Object.GetById(categoryId);

            _mockReportCategoryRepository.Setup(m => m.UpdateStatus(It.IsAny<Report_Categories>(), status)).Callback(
             () =>
             {
                 _reportCategories[status - 1].Status = status;
                 this._mockReportCategoryRepository.Object.Update(_reportCategories[status - 1], _reportCategories[status - 1].CategoryId);

             });
            this._mockReportCategoryRepository.Object.UpdateStatus(emp, status);   // try to update ReportCategory

            //verify the count of the list
            List<Report_Categories> emps = (List<Report_Categories>)this._mockReportCategoryRepository.Object.GetAll();
            Assert.IsNotNull(emps);
            Assert.AreEqual(5, emps.Count);// the count is the same

            //verify the changed ReportCategory
            emp = this._mockReportCategoryRepository.Object.GetById(categoryId);
            Assert.IsNotNull(emp);
            Assert.AreEqual(status, emp.Status); // changes effectedly
        }

        [Test]
        public void TestUpdateStatus_ThrowException()
        {
            //Arrange   
            const int categoryId = 3;
            const int status = 3;
            this._mockReportCategoryRepository.Setup(m => m.Update(It.IsAny<Report_Categories>(), status)).Throws(new Exception("Error"));
            //Act
            try
            {
                var emp = this._mockReportCategoryRepository.Object.GetById(categoryId);
                //change status
                this._mockReportCategoryRepository.Object.UpdateStatus(emp, status);
            }
            catch (Exception ex)
            {
                // Assert
                Assert.AreEqual("Error", ex.Message);
            }
        }

        [Test]
        public void TestGetCategories_ReturnList()
        {
            this._mockReportCategoryRepository.Setup(m => m.GetCategories()).Returns(from reportCat in _reportCategories select new { reportCat.CategoryId, reportCat.Name });

            var emp = this._mockReportCategoryRepository.Object.GetCategories();
            //assert
            Assert.IsNotNull(emp);
        }

        [Test]
        public void TestGetCategories_ThrowException()
        {
            this._mockReportCategoryRepository.Setup(m => m.GetCategories()).Throws(new Exception("Error"));
            try
            {
                var emp = this._mockReportCategoryRepository.Object.GetCategories();
            }
            catch (Exception ex)
            {
                // Assert
                Assert.AreEqual("Error", ex.Message);
            }
        }

        [Test]
        public void TestGetCategoriesUserCanAccess_ReturnEmpty()
        {
            const int userId = 179;
            var emp = this._mockReportCategoryRepository.Object.GetCategoriesUserCanAccess(userId);
            //assert
            Assert.IsEmpty(emp);
        }
    }
}
