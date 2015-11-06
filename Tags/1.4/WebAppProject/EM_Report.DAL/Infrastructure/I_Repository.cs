using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.SqlClient;
using System.Data;
namespace EM_Report.DAL.Infrastructure
{
    public interface I_Repository<T> : IDisposable
    {
        IQueryable<T> GetQueryable();
        T GetByPK( object id);
        string GetPrimaryKeyName();
        Type GetPrimaryKeyType();
        object ExecuteScalarStoreProcedure(string storename, IDictionary<string, object> dicParams);
        int ExecuteNonQueryStoreProcedure(string storename, IDictionary<string, object> dicParams);
        DataTable ExecuteDataStoreProcedure(string storename, IDictionary<string, object> dicParams, string connectionString);
        T Insert(T entity);        
        T Update(T entity,object id);
        void Delete(T entity);
        void DeleteById(object id);
        void CommitChanges();
        void BulkInsert(IEnumerable<T> data, string tableName);
        void DeleteAll();
    }
}
