using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.SqlClient;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using EntityFramework.BulkInsert.Extensions;

namespace EM_Report.DAL.Infrastructure
{
    public interface I_Repository<T> : IDisposable
    {
        IQueryable<T> GetQueryable();
        T GetByPK( object id);
        object ExecuteScalarStoreProcedure(string storename, IDictionary<string, object> dicParams);
        int ExecuteNonQueryStoreProcedure(string storename, IDictionary<string, object> dicParams);
        DataTable ExecuteDataStoreProcedure(string storename, IDictionary<string, object> dicParams, string connectionString = null);
        T Insert(T entity);        
        T Update(T entity,object id);
        void Delete(T entity);
        void DeleteById(object id);
        void CommitChanges();
        void BulkInsert(IEnumerable<T> data, string tableName);
        void DeleteAll();

        IQueryable<T> ExecStoreProcedure(string query, params object[] parameters);
    }
}
