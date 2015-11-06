using System;
using System.Configuration;
using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models.Report_Data_Object;

namespace EM_Report.BLL.Services
{
    using System.Collections.Generic;
    using System.Data;

    public interface I_PaymentService : I_Service<PaymentTypeModel>
    {
        IQueryable<PaymentTypeModel> Search(string paymentType, string paymentDescription, string claimNumber, string orderBy);
        IQueryable<PaymentTypeModel> Search(string paymentType, string paymentDescription, string orderBy);
    }

    public class PaymentService : ServiceBase<PaymentTypeModel, PAYMENT_TYPE>, I_PaymentService
    {
        private I_Repository<Payment_Description> _repositoryPaymentDesc;

        public I_Repository<Payment_Description> RepositoryPaymentDesc
        {
            get { return this._repositoryPaymentDesc; }
            set { this._repositoryPaymentDesc = value; }
        }

        private I_Repository<Payment_Recovery> _repositoryPaymentRecovery;

        public I_Repository<Payment_Recovery> RepositoryPaymentRecovery
        {
            get { return this._repositoryPaymentRecovery; }
            set { this._repositoryPaymentRecovery = value; }
        }

        public PaymentService(I_LoginSession session)
            : base(session)
        {
            base.Repository = new RepositoryBase<PAYMENT_TYPE>(new EmicsModelDataContext(ConfigurationManager.ConnectionStrings[Constants.STR_RS_CONNECTIONSTRING].ToString()));

            _repositoryPaymentDesc = new RepositoryBase<Payment_Description>(((RepositoryBase<PAYMENT_TYPE>)Repository).Context);
            //_repositoryPaymentRecovery = new RepositoryBase<Payment_Recovery>(((RepositoryBase<PAYMENT_TYPE>)Repository).Context);
        }

        protected override PaymentTypeModel MappingToModel(PAYMENT_TYPE table)
        {
            return table == null ? null : new PaymentTypeModel()
            {
                Type = table.Payment_Type,
                Group = table.Payment_Group,
                ActiveFromDate = table.Active_From_Date,
                ActiveToDate = table.Active_To_Date
            };
        }

        protected override PAYMENT_TYPE MappingToDAL(PaymentTypeModel model)
        {
            return model == null ? null : new PAYMENT_TYPE()
            {
                Payment_Type = model.Type,
                Payment_Group = model.Group,
                Active_From_Date = model.ActiveFromDate,
                Active_To_Date = model.ActiveToDate
            };
        }

        protected override IQueryable<PaymentTypeModel> GetMapping(IQueryable<PAYMENT_TYPE> query)
        {
            var paymentDesc = RepositoryPaymentDesc.GetQueryable();
            //var paymentRecovery = RepositoryPaymentRecovery.GetQueryable();

            var result = from pt in query
                         join pd in paymentDesc on pt.Payment_Type equals pd.Payment_Type
                         where pt.Active_From_Date.CompareTo(DateTime.Now) < 0 
                                    && (pt.Active_To_Date.Equals(null) || pt.Active_To_Date >= DateTime.Now) 

                         select new PaymentTypeModel()
                         {
                             Type = pt.Payment_Type,
                             Group = pt.Payment_Group,
                             Description = pd.Description,
                         };
            return result;
        }

        public IQueryable<PaymentTypeModel> Search(string paymentType, string paymentDescription, string orderBy)
        {
            var query = this.GetAllQueryable(orderBy, string.Empty);
            var predicate = PredicateBuilder.False<PaymentTypeModel>();
            if (!string.IsNullOrEmpty(paymentType))
            {
                predicate = predicate.Or(p => p.Type.Contains(paymentType));
            }
            if (!string.IsNullOrEmpty(paymentDescription))
            {
                predicate = predicate.And(p => p.Description.Contains(paymentDescription));
            }
            
            return query.Where(predicate);
        }

        public IQueryable<PaymentTypeModel> Search(string paymentType, string paymentDescription, string claimNumber, string orderBy)
        {
            Dictionary<string, object> prms = new Dictionary<string, object>();
            prms.Add("PaymentType", paymentType);
            prms.Add("Description", paymentDescription);
            prms.Add("ClaimNumber", claimNumber);

            DataTable allPaymentTypes = RepositoryBaseExtension.ExecuteQueryStoreProcedure("usp_GetAllPaymentTypes", prms);

            List<PaymentTypeModel> result = new List<PaymentTypeModel>();
            foreach (DataRow row in allPaymentTypes.Rows)
            {
                PaymentTypeModel payment = new PaymentTypeModel()
                {
                    Type = row["Type"].ToString(),
                    Description = row["Description"].ToString(),
                };
                result.Add(payment);
            }

            return result.AsQueryable();
        }
    }
}