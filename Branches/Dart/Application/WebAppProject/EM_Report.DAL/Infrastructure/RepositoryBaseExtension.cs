using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using EM_Report.Common.Utilities;

namespace EM_Report.DAL.Infrastructure
{
    //public class RepositoryBaseExtension
    //{
    //    private const string STR_RS_CONNECTIONSTRING = "DartEntities";
    //    public static string rsConnectionString = Common.Utilities.EnCryption.Decrypt(ConfigurationManager.ConnectionStrings[STR_RS_CONNECTIONSTRING].ToString());
        
    //    public static DataTable ExecuteQueryStoreProcedure(string storename, IDictionary<string, object> dicParams)
    //    {
    //        DataTable tblTable = new DataTable();
    //        using (SqlConnection myConnection = new SqlConnection(rsConnectionString))
    //        {
    //            SqlCommand command = new SqlCommand();
    //            command.Connection = myConnection;

    //            myConnection.Open();
    //            if (dicParams != null && dicParams.Count() > 0)
    //            {
    //                foreach (KeyValuePair<string, object> dictitem in dicParams)
    //                {
    //                    command.Parameters.AddWithValue(dictitem.Key, dictitem.Value == null ? DBNull.Value : dictitem.Value);
    //                }
    //            }

    //            command.CommandText = storename;
    //            command.CommandType = System.Data.CommandType.StoredProcedure;

    //            SqlDataAdapter adapter = new SqlDataAdapter(command);
    //            adapter.Fill(tblTable);
    //            myConnection.Close();
    //            return tblTable;
    //        }
    //    }

    //    public static DataTable ExecuteQueryStoreProcedure(string systemName, string storename, IDictionary<string, object> dicParams)
    //    {
    //        DataTable tblTable = new DataTable();
    //        using (SqlConnection myConnection = new SqlConnection(Common.Utilities.EnCryption.Decrypt(Common.Utilities.Commons.GetConnectionStringBySystemName(systemName))))
    //        {
    //            SqlCommand command = new SqlCommand();
    //            command.Connection = myConnection;

    //            myConnection.Open();
    //            if (dicParams != null && dicParams.Count() > 0)
    //            {
    //                foreach (KeyValuePair<string, object> dictitem in dicParams)
    //                {
    //                    command.Parameters.AddWithValue(dictitem.Key, dictitem.Value == null ? DBNull.Value : dictitem.Value);
    //                }
    //            }

    //            command.CommandText = storename;
    //            command.CommandType = System.Data.CommandType.StoredProcedure;

    //            SqlDataAdapter adapter = new SqlDataAdapter(command);
    //            adapter.Fill(tblTable);
    //            myConnection.Close();
    //            return tblTable;
    //        }
    //    }
    //}
}