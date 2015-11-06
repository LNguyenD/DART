using System;
using System.Collections.Generic;
using System.Linq;

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
        T Insert(T entity);
        //T Update(T entity);
        T Update(T entity,object id);
        void Delete(T entity);
        void DeleteById(object id);
        void CommitChanges();
    }
}
