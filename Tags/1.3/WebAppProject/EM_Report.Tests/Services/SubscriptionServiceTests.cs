using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using NUnit.Framework;
using EM_Report.BLL.Services;
using Moq;
using EM_Report.BLL.Commons;
using EM_Report.Models;

namespace EM_Report.Tests.Services
{
    [TestFixture]
    public class SubscriptionServiceTests
    {
        //private RS_SubscriptionService _service;
        //private Mock<I_LoginSession> loginSession;
        //private List<SubscriptionModel> listSubscription;

        //[TestFixtureSetUp]
        //public void Init()
        //{
        //    var session = new Mock<I_LoginSession>();
        //    session.Setup(e => e.intUserId).Returns(1);
        //    session.Setup(e => e.isSystemUser).Returns(true);
        //    _service = new RS_SubscriptionService(session.Object);

        //    listSubscription = new List<SubscriptionModel>();
        //}

        //private RS_SubscriptionModel InitSubscritptionModel(string format, string email, string subject, string comment, int reportId, string delivery)
        //{
        //    RS_SubscriptionModel sub = new RS_SubscriptionModel();
        //    sub.Format = format;
        //    sub.ToEmail = email;
        //    sub.Subject = subject;
        //    sub.Comment = comment;
        //    sub.ReportId = reportId;
        //    sub.DeliveryMethod = delivery;

        //    return sub;
        //}

        //[Test]
        //public void CreateSubscription_ValidParams_IsSuccessful()
        //{
        //    RS_SubscriptionModel sub = new RS_SubscriptionModel();
        //    sub = InitSubscritptionModel("XML", "test@abc.com", "Report 4.00", "test", 17, Constants.DeliveryMethodNames[DeliveryMethod.EMAIL]);
            
        //    string subId = _service.Create(sub);
        //    Assert.IsNotNull(subId);
        //    SubscriptionModel newSub = null;
        //    newSub = _service.GetSubscriptionModel(subId);
        //    Assert.IsNotNull(newSub);
        //    listSubscription.Add(newSub);
        //}

        //[TestFixtureTearDown]
        //public void Clean()
        //{
        //    foreach (SubscriptionModel rsSubscriptionModel in listSubscription)
        //    {
        //        _service.DeleteExpiredRS_Subscription(rsSubscriptionModel);
        //    }
        //}
    }
}
