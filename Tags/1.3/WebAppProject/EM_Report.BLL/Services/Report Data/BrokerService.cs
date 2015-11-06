using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EM_Report.Models.Report_Data_Object;
using EM_Report.DAL;
using EM_Report.BLL.Commons;
using EM_Report.DAL.Infrastructure;
using System.Configuration;

namespace EM_Report.BLL.Services
{
    public interface I_BrokerService : I_Service<BrokerModel>
    {
        IQueryable<BrokerModel> Search(string name, string contactName, string orderBy);
    }

    public class BrokerService : ServiceBase<BrokerModel, BROKER>, I_BrokerService
    {
        private I_Repository<person> _repositoryPerson;
        private I_Repository<contact_extension> _repositoryContactExtension;

        public I_Repository<person> RepositoryPerson
        {
            get { return this._repositoryPerson; }
            set { this._repositoryPerson = value; }
        }

        public I_Repository<contact_extension> RepositoryContactExtension
        {
            get { return this._repositoryContactExtension; }
            set { this._repositoryContactExtension = value; }
        }
 
        public BrokerService(I_LoginSession session)
            : base(session)
        {
            base.Repository = new RepositoryBase<BROKER>(new EmicsModelDataContext(ConfigurationManager.ConnectionStrings[Constants.STR_RS_CONNECTIONSTRING].ToString()));
            
            _repositoryPerson = new RepositoryBase<person>(((RepositoryBase<BROKER>)Repository).Context);
            _repositoryContactExtension = new RepositoryBase<contact_extension>(((RepositoryBase<BROKER>)Repository).Context);
        }
        
        protected override BrokerModel MappingToModel(BROKER table)
        {
            return table == null ? null : new BrokerModel()
            {
                BrokerNo = table.BROKER_NO,
                Name = table.NAME
            };
        }
        
        protected override BROKER MappingToDAL(BrokerModel model)
        {
            return model == null ? null : new BROKER()
            {
                BROKER_NO = model.BrokerNo,
                NAME = model.Name
            };
        }

        protected override IQueryable<BrokerModel> GetMapping(IQueryable<BROKER> query)
        {
            try
            {
                var personQuery = RepositoryPerson.GetQueryable();
                var contactExQuery = RepositoryContactExtension.GetQueryable();

                var result = from b in query 
                             join cx in contactExQuery on b.BROKER_NO equals cx.object_ref
                             join p in personQuery on cx.person_id equals p.ID
                             where b.is_deleted.Equals(0) && (cx.is_primary.Equals(1) || cx.person_id.Equals(null))
                             select new BrokerModel()
                             {
                                 BrokerNo = b.BROKER_NO,
                                 Name = b.NAME,
                                 ContactName = p.FIRSTNAME + " " + p.LASTNAME
                             };
                return result;
            }
            catch (Exception ex)
            {
                Logger.Error("GetMapping error", ex);
                return null;
            }
        }

        public IQueryable<BrokerModel> Search(string name, string contactName, string orderBy)
        {
            var query = this.GetAllQueryable(orderBy, string.Empty);
            var predicate = PredicateBuilder.False<BrokerModel>();   

            if(string.IsNullOrEmpty(name) && string.IsNullOrEmpty(contactName))
            {
                predicate = PredicateBuilder.True<BrokerModel>();   
            }
            
            if (!string.IsNullOrEmpty(name))
            {
                predicate = predicate.Or(p => p.Name.Contains(name));
            }
            if (!string.IsNullOrEmpty(contactName))
            {
                predicate = predicate.Or(p => p.ContactName.Contains(contactName));
            }
            
            return query.Where(predicate);
        }
    }
}