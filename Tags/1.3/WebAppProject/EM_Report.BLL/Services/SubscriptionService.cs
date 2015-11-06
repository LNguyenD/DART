using System;
using System.Collections.Generic;
using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{
    public interface I_SubscriptionService : I_Service<SubscriptionModel>
    {
        SubscriptionModel SetStatus(string subscriptionID, short status);
        SubscriptionModel SetScheduleType(string subscriptionID, short stype);
    }
    public class SubscriptionService : ServiceBase<SubscriptionModel, Subscription>, I_SubscriptionService
    {
        private I_LoginSession session;
        private I_Repository<Status> _statusRepository;
        private I_Repository<Report> _reportRepository;

        public I_Repository<Report> ReportRepository
        {
            get { return _reportRepository; }
            set { _reportRepository = value; }
        }
         
        public I_Repository<Status> StatusRepository
        {
            get { return _statusRepository; }
            set { _statusRepository = value; }
        }

        public SubscriptionService(I_LoginSession session) : base(session) 
        {
            this.session = session;
            _statusRepository = new RepositoryBase<Status>(((RepositoryBase<Subscription>)Repository).Context);
            _reportRepository = new RepositoryBase<Report>(((RepositoryBase<Subscription>)Repository).Context);
        }

        protected override SubscriptionModel MappingToModel(EM_Report.DAL.Subscription tbSubscriptons)
        {
            return tbSubscriptons == null ? null : new SubscriptionModel()
            {
                SubscriptionID = tbSubscriptons.SubscriptionID,
                Owner = tbSubscriptons.Owner,
                Status = tbSubscriptons.Status,
                ScheduleID = tbSubscriptons.ScheduleID,
                ScheduleType = tbSubscriptons.ScheduleType,
                ReportId = tbSubscriptons.ReportId.Value,
                UpdatedBy = session.intUserId,
                ReportName = tbSubscriptons.Report != null ? tbSubscriptons.Report.Name : string.Empty
            };
        }

        protected override Subscription MappingToDAL(SubscriptionModel subOwnerModel)
        {
            return subOwnerModel == null ? null : new Subscription()
            {
                SubscriptionID = subOwnerModel.SubscriptionID,
                Owner = subOwnerModel.Owner,
                Status = subOwnerModel.Status,
                ScheduleID = subOwnerModel.ScheduleID,
                ScheduleType = subOwnerModel.ScheduleType,
                ReportId = subOwnerModel.ReportId
            };
        }

        protected override IQueryable<SubscriptionModel> GetMapping(IQueryable<Subscription> query)
        {
            try
            {
                var statusQuery = StatusRepository.GetQueryable();
                var result = from subscription in query
                             join status in statusQuery on subscription.Status equals status.StatusId
                             where (subscription.Report != null && subscription.Report.Status == ResourcesHelper.StatusActive)
                             select new SubscriptionModel()
                             {
                                 SubscriptionID = subscription.SubscriptionID,
                                 Owner = subscription.Owner,
                                 Status = subscription.Status,
                                 ScheduleID = subscription.ScheduleID,
                                 ScheduleType = subscription.ScheduleType,
                                 ReportId = subscription.ReportId.Value,
                                 StatusName = status.Name,
                                 UpdatedBy = subscription.UpdatedBy,
                                 ReportName = subscription.Report != null ? subscription.Report.Name : string.Empty
                             };
                return result;
            }
            catch (Exception ex)
            {
                Logger.Error("GetMapping error", ex);
                return null;
            }
        }

        protected override IQueryable<Subscription> Authorization(IQueryable<Subscription> query)
        {
            if (Session != null && Session.isSystemUser)
            {
                return query;
            }
            var canAccesstList = _reportRepository.GetQueryable().Select(e => e.ReportId);
            var result = from subscription in query
                         where (canAccesstList.Contains(subscription.ReportId.Value) && subscription.Status == ResourcesHelper.StatusActive)
                         select subscription;
            return result;
        }

        public SubscriptionModel SetStatus(string subscriptionID, short status)
        {
            var subscription = GetById(subscriptionID);
            subscription.Status = status;
            Update(subscription, subscription.SubscriptionID);
            return subscription;
        }

        public SubscriptionModel SetScheduleType(string subscriptionID, short stype)
        {
            var subscription = GetById(subscriptionID);
            subscription.ScheduleType = stype;
            Update(subscription, subscription.SubscriptionID);
            return subscription;
        }
    }
}