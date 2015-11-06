using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using EM_Report.Models;
using System.Web.Mvc;

namespace EM_Report.Tests.Controllers
{
    [TestFixture]
    public class PermissionControllerTest
    {
        private PermissionController permissionController = new PermissionController();
        
        [Test]
        public void GetAllPermission_HaveItems_ReturnRightResult()
        {
        //    ActionResult result = permissionController.Index() as ActionResult;
        //    Assert.IsNotNull(result);
        }

        [Test]
        public void GetAllPermission_HaveNoItems_ReturnEmpty()
        {
          //  ActionResult result = permissionController.Index() as ActionResult;
       //     Assert.IsNull(result);
        }
    }
}
