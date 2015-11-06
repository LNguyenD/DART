using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Data;
using System.ComponentModel;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using EntityFramework.BulkInsert.Extensions;

namespace EM_Report.DAL.Infrastructure
{
    public class RepositoryBase<T> : I_Repository<T>
        where T : class
    {
        //private string STR_DartConnectionString = Common.Utilities.EnCryption.Decrypt(ConfigurationManager.ConnectionStrings["DartEntities"].ToString());
        //private string DartSQLConnectionString = Common.Utilities.EnCryption.Decrypt(ConfigurationManager.ConnectionStrings["DartSQL"].ToString());
        private string DartEFConnectionString = Common.Utilities.EnCryption.Decrypt(ConfigurationManager.ConnectionStrings["DartEF"].ToString());        

        #region private member variables
        private string connectionStr;

        private DbContext context;

        public string ConnectionStr
        {
            get { return connectionStr; }
            set { connectionStr = value; }
        }

        public DbContext Context
        {
            get { return context; }
            set { context = value; }
        }

        public string TableName { get; set; }

        #endregion

        #region private methods
        private DbSet<T> Table
        {
            get
            {
                return context.Set<T>();
            }
        }
        #endregion

        #region constructors
        public RepositoryBase()
        {
            context = new DartEntities(DartEFConnectionString);
        }

        public RepositoryBase(DbContext db)
        {
            context = db;
        }
        #endregion

        #region public methods
        public IQueryable<T> GetQueryable()
        {
            return context.Set<T>();
        }

        public T GetByPK(object id)
        {
            var result = Table.Find(id);
            return result;
        }

        public T Insert(T entity)
        {
            try
            {
                Table.Add(entity);
                context.SaveChanges();
                return entity;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public T Update(T entity, object id)
        {
            object propertyValue = null;

            T entityFromDB = GetByPK(id);
            if (null == entityFromDB)
            {
                throw new NullReferenceException("Query Supplied to " + "Get entity from DB is invalid, NULL value returned");
            }

            PropertyInfo[] properties = entityFromDB.GetType().GetProperties();

            foreach (PropertyInfo property in properties)
            {
                propertyValue = null;
                if (null != property.GetSetMethod())
                {
                    PropertyInfo entityProperty = entity.GetType().GetProperty(property.Name);
                    if (property.Name != "Create_Date" && property.Name != "Owner")
                    {
                        if (entityProperty.PropertyType.BaseType == Type.GetType("System.ValueType") || entityProperty.PropertyType == Type.GetType("System.String"))
                        {
                            propertyValue = entity.GetType().GetProperty(property.Name).GetValue(entity, null);
                        }
                        if ((null == propertyValue && entityProperty.PropertyType == Type.GetType("System.String")) || null != propertyValue)
                        {
                            if (propertyValue != null && propertyValue.ToString() == "0")
                            {
                                propertyValue = null;
                            }
                            property.SetValue(entityFromDB, propertyValue, null);
                        }
                    }
                }
            }

            context.Entry<T>(entityFromDB).State = EntityState.Modified;
            CommitChanges();
            return entity;
        }

        public void DeleteById(object id)
        {
            var entity = GetByPK(id);
            try
            {
                Table.Remove(entity);
            }
            catch (Exception)
            {
                context = new DartEntities();
                Table.Attach(entity);
                Table.Remove(GetByPK(id));
            }
            CommitChanges();
        }

        public void Delete(T entity)
        {
            try
            {
                Table.Remove(entity);
            }
            catch (InvalidOperationException)
            {
                context = new DartEntities();
                Table.Attach(entity);
                Table.Remove(entity);
            }
            CommitChanges();
        }

        public int ExecuteNonQueryStoreProcedure(string storename, IDictionary<string, object> dicParams)
        {
            int objNoneQuery;

            var connection = context.Database.Connection;
            if (connection.State != ConnectionState.Open)
                connection.Open();

            try
            {
                var command = connection.CreateCommand();
                command.CommandText = storename;
                command.CommandType = System.Data.CommandType.StoredProcedure;
                if (dicParams != null && dicParams.Count() > 0)
                {
                    foreach (KeyValuePair<string, object> dictitem in dicParams)
                    {
                        command.Parameters.Add(new SqlParameter(dictitem.Key, dictitem.Value == null ? DBNull.Value : dictitem.Value));
                    }
                }

                objNoneQuery = command.ExecuteNonQuery();
                return objNoneQuery;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                if (connection.State != ConnectionState.Open)
                    connection.Close();
            }
        }

        public object ExecuteScalarStoreProcedure(string storename, IDictionary<string, object> dicParams)
        {
            object objScalar;

            var connection = context.Database.Connection;
            if (connection.State != ConnectionState.Open)
                connection.Open();

            try
            {
                var command = connection.CreateCommand();
                command.CommandText = storename;
                command.CommandType = System.Data.CommandType.StoredProcedure;
                if (dicParams != null && dicParams.Count() > 0)
                {
                    foreach (KeyValuePair<string, object> dictitem in dicParams)
                    {
                        command.Parameters.Add(new SqlParameter(dictitem.Key, dictitem.Value == null ? DBNull.Value : dictitem.Value));
                    }
                }

                objScalar = command.ExecuteScalar();
                return objScalar;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                if (connection.State != ConnectionState.Open)
                    connection.Close();
            }
        }

        public DataTable ExecuteDataStoreProcedure(string storename, IDictionary<string, object> dicParams, string connectionString = null)
        {
            DataTable tblTable = new DataTable();

            var connection = context.Database.Connection;
            if (connection.State != ConnectionState.Open)
                connection.Open();

            try
            {
                var command = connection.CreateCommand();
                command.CommandText = storename;
                command.CommandType = System.Data.CommandType.StoredProcedure;
                if (dicParams != null && dicParams.Count() > 0)
                {
                    foreach (KeyValuePair<string, object> dictitem in dicParams)
                    {
                        command.Parameters.Add(new SqlParameter(dictitem.Key, dictitem.Value == null ? DBNull.Value : dictitem.Value));
                    }
                }

                using (var reader = command.ExecuteReader())
                {
                    tblTable.Load(reader);
                }

                return tblTable;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                if (connection.State != ConnectionState.Open)
                    connection.Close();
            }
        }

        public void CommitChanges()
        {
            bool saveFailed = false;

            do
            {
                try
                {
                    context.SaveChanges();

                    saveFailed = false;

                }
                catch (DbUpdateConcurrencyException ex)
                {
                    saveFailed = true;

                    ex.Entries.ToList()
                              .ForEach(entry =>
                              {
                                  entry.OriginalValues.SetValues(entry.GetDatabaseValues());
                              });

                }
            } while (saveFailed);
        }

        public void BulkInsert(IEnumerable<T> data, string tableName)
        {
            // USING EF BULK INSERT LIB
            context.BulkInsert(data);
        }

        public void DeleteAll()
        {
            var sql = string.Format("TRUNCATE TABLE {0}", TableName);
            Context.Database.ExecuteSqlCommand(sql);
        }

        public void Dispose()
        {
            context.Dispose();
        }

        public IQueryable<T> ExecStoreProcedure(string query, params object[] parameters)
        {                     
            return context.Database.SqlQuery<T>(query, parameters).AsQueryable();
        }
       
        #endregion
    }
}
