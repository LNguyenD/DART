using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using EM_Report.Controllers;
using System.Web.Mvc;

namespace EM_Report.Tests.Controllers
{
    [TestFixture]
    public class WelcomeControllerTests
    {
        [Test]
        public void Index()
        {
            // Arrange

            //Act
            var controller = new WelcomeController();
            var result = controller.Index() as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
        }
    }
}
