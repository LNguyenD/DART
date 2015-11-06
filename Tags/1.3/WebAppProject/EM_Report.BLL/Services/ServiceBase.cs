using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using EM_Report.BLL.Commons;
using EM_Report.BLL.Logger;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{
    public class ServiceBase<TModel, TTable> : I_Service<TModel>
        where TModel : class
        where TTable : class 
    {
        #region private member variables
        private I_Repository<TTable> _repository;
        private I_LoginSession _session;
        private I_Logger _logger;
        #endregion

        #region private properties
        #endregion

        #region private methods
        protected virtual TModel MappingToModel(TTable table)
        {
            throw new NotImplementedException();
        }

        protected virtual TTable MappingToDAL(TModel entity)
        {
            throw new NotImplementedException();
        }

        private static IQueryable<TModel> Sort(string sort, IQueryable<TModel> query)
        {
            if (string.IsNullOrEmpty(sort))
                return query;

            string[] sortSplit = sort.Split('|');

            if (sortSplit[1] != null && sortSplit[1].ToLower().IndexOf(Constants.G_ORDER_DESC) >= 0)
            {
                query = query.OrderBy<TModel>(sortSplit[0], Constants.G_ORDER_DESC);
            }
            else
            {
                query = query.OrderBy<TModel>(sortSplit[0], Constants.G_ORDER_ASC);
            }
            return query;
        }

        protected virtual IQueryable<TModel> Filter(string keyword, IQueryable<TModel> query, Expression<Func<TModel, bool>> expression)
        {
            return query;
        }

        protected virtual IQueryable<TModel> Filter(string keyword, IQueryable<TModel> query)
        {
            return query;
        }

        protected virtual IQueryable<TModel> Filter(string keyword, string startdate, string enddate, IQueryable<TModel> query)
        {
            return query;
        }

        protected virtual IQueryable<TTable> Authorization(IQueryable<TTable> query)
        {
            return query;
        }

        private IQueryable<TModel> FilterActiveItems(IQueryable<TModel> query)
        {
            if (Session != null && Session.isSystemUser)
            {
                return query;
            }
            return query.Where(e => e is I_Status ? ((I_Status)e).Status == ResourcesHelper.StatusActive : true);
        }
        #endregion

        #region constructors
        public ServiceBase(I_LoginSession session)
        {
            _repository = new RepositoryBase<TTable>();
            _session = session;
            _logger = new Log4Net();
        }

        public ServiceBase(I_Repository<TTable> repository, I_LoginSession session)
        {
            _repository = repository;
            _session = session;
            _logger = new Log4Net();
        }
        #endregion

        #region public properties
        public I_Logger Logger
        {
            get { return _logger; }
            set { _logger = value; }
        }
        public I_LoginSession Session
        {
            get { return _session; }
            set { _session = value; }
        }

        public I_Repository<TTable> Repository
        {
            get { return _repository; }
            set { _repository = value; }
        }
        #endregion

        #region public methods
        public virtual IEnumerable<TModel> GetAll()
        {
            try
            {
                return GetAllQueryable(string.Empty, string.Empty).ToList();
                //_repository.GetQueryable().Select(e => MappingToModel(e));
            }
            catch (Exception ex)
            {
                Logger.Error(ex.Message, ex);
                return new List<TModel>();
            }
        }

        public virtual TModel GetById(object id)
        {
            try
            {
                return MappingToModel(_repository.GetByPK(id));
            }
            catch (Exception ex)
            {
                Logger.Error(ex.Message, ex);
                return null;
            }
            
        }

        //public virtual TModel Update(TModel model)
        //{
        //    var entity = MappingToDAL(model);
        //    return MappingToModel(_repository.Update(entity));
        //}

        public virtual TModel Update(TModel model,object id)
        {
            TModel result = null;
            try
            {
                var entity = MappingToDAL(model);
                result = MappingToModel(_repository.Update(entity, id));
            }
            catch (Exception ex)
            {
                Logger.Error(ex.Message, ex);
            }
            return result;
        }

        public virtual TModel Create(TModel model)
        {
            TModel result = null;
            try
            {
                var entity = MappingToDAL(model);
                result =  MappingToModel(_repository.Insert(entity));
            }
            catch (Exception ex)
            {
                Logger.Error(ex.Message, ex);
            }
            return result;
        }

        //public virtual void Delete(TModel model)
        //{
        //    var entity = MappingToDAL(model);
        //    _repository.Delete(entity);
        //}       

        public virtual void Delete(object id)
        {
            try
            {
                _repository.DeleteById(id);
            }
            catch (InvalidOperationException e)
            {
                Logger.Warning("InvalidOperationException when delete object", e);
            }
            catch (Exception ex)
            {
                Logger.Error(ex.Message, ex);
            }
        }

        public virtual IEnumerable<TModel> GetAllAuthorization()
        {
            try
            {
                var query = Repository.GetQueryable();
                query = Authorization(query);
                return from report in query
                       select MappingToModel(report);
            }
            catch(Exception ex)
            {
                Logger.Error(ex.Message, ex);
            }
            return new List<TModel>(); ;
        }

        public virtual IQueryable<TModel> GetAllQueryable(string sort, string keyword)
        {
            return GetAllQueryable(sort, keyword, null);
        }

        public virtual IQueryable<TModel> GetAllQueryable(string sort, string keyword, Expression<Func<TModel, bool>> expression)
        {
            try
            {
                var query = Repository.GetQueryable();

                query = Authorization(query);

                var result = GetMapping(query);

                if (expression != null)
                    result = Filter(keyword, result, expression);
                else
                    result = Filter(keyword, result);

                result = FilterActiveItems(result);

                result = Sort(sort, result);

                return result;
            }
            catch (Exception ex) 
            {
                Logger.Error(ex.Message, ex);
            }
            return null;
        }

        public virtual IQueryable<TModel> GetAllQueryable(string sort, string keyword, string startdate, string enddate)
        {
            try
            {
                var query = Repository.GetQueryable();

                query = Authorization(query);

                var result = GetMapping(query);
                
                result = Filter(keyword, startdate, enddate, result);

                result = Sort(sort, result);

                return result;
            }
            catch (Exception ex)
            {
                Logger.Error(ex.Message, ex);
            }
            return null;
        }

        protected virtual IQueryable<TModel> GetMapping(IQueryable<TTable> query)
        {
            try
            {
                return query.Select(e => MappingToModel(e));
            }
            catch (Exception ex)
            {
                Logger.Error(ex.Message, ex);
                return null;
            }
        }

        public bool IsExist(long id)
        {
            return (id > 0) && Repository.GetByPK(id) != null;
        }

        public object ExecuteScalarStoreProcedure(string storename, IDictionary<string, object> dicParams)
        {
            try
            {
                return Repository.ExecuteScalarStoreProcedure(storename, dicParams);
            }
            catch (Exception ex)
            {
                Logger.Error(ex.Message, ex);
            }
            return null;
        }

        public int ExecuteNonQueryStoreProcedure(string storename, IDictionary<string, object> dicParams)
        {
            try
            {
                return Repository.ExecuteNonQueryStoreProcedure(storename, dicParams);
            }
            catch (Exception ex)
            {
                Logger.Error(ex.Message, ex);
                throw;
            }
        }
        #endregion
    }
}