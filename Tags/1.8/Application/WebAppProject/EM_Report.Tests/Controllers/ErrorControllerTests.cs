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
    public class ErrorControllerTests
    {
        [Test]
        public void Error_404()
        {
            // Arrange

            // Act
            var errorController = new ErrorController();
            var result = errorController.Error_404("test") as ViewResult;

            // Assert
            Assert.AreEqual("", result.ViewName);
        }

        public void Error_500()
        {
            // Arrange

            // Act

            // Assert
        }
    }
}
