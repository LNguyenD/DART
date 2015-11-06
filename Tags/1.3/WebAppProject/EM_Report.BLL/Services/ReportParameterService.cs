using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using EM_Report.BLL.Logger;
using EM_Report.Models.RS2005;
using EM_Report.Models;
using System.Xml;
using System.IO;
using EM_Report.BLL.Commons;
using System.Xml.Linq;

namespace EM_Report.BLL.Services
{
    public interface I_ReportParameterService
    {
        IEnumerable<ReportParameter> GetVisibleParametersInfo(string reportPath);
        IEnumerable<ReportParameter> GetVisibleParametersInfo(string reportPath, IEnumerable<ParameterValue> prmValues);
        ParameterValue[] GetParameterValues(string subid);
        IList<FilterItemModel> GetFields(string UrlReportPath);
    }
    public class ReportParameterService : I_ReportParameterService
    {
        ReportingService2005 _rs;
        private I_Logger _logger;

        public ReportingService2005 Rs
        {
            get { return _rs; }
            set { _rs = value; }
        }

        public I_Logger Logger
        {
            get { return _logger; }
            set { _logger = value; }
        }
        public ReportParameterService()
        {
            _rs = new ReportingService2005();
            _rs.Url = ConfigurationManager.AppSettings[Constants.STR_REPORT_SERVER_URL] + ConfigurationManager.AppSettings["ReportServicePath"];
            _rs.Credentials = new ReportViewerCredentials().NetworkCredentials;
            _logger = new Log4Net();
        }
        public IList<FilterItemModel> GetFields(string UrlReportPath)
        {
            IList<FilterItemModel> filterItemList = new List<FilterItemModel>();
            string strHeader = string.Empty;
            string strField = string.Empty;
            FilterItemModel filterItem;
            int count = 0;
            byte[] bytes = _rs.GetReportDefinition(UrlReportPath);

            MemoryStream stream = new MemoryStream(bytes);
            XDocument xdoc = new XDocument();
            xdoc = XDocument.Load(stream);
            XNamespace ns = xdoc.Root.GetDefaultNamespace();
            XNamespace nsRd = xdoc.Root.GetNamespaceOfPrefix("rd");

            IEnumerable<XElement> bookElements = from r in xdoc.Descendants(ns + "DataSet")
                                                 where (string)r.Attribute("Name") == "DataSet"
                                                 select r;

            var bookField = from f in bookElements.Descendants(ns + "Field") select f;

            var elements = from f in bookField
                            select new
                        {
                                DataFields = f.Element(ns+"DataField").Value,
                                DataType = (f.Element(nsRd+"TypeName") == null) ? Commons.Commons.ConvertDataTypeToString(f.Element(nsRd+"UserDefined").Value) : Commons.Commons.ConvertDataTypeToString(f.Element(nsRd + "TypeName").Value)
                            };

            foreach (var item in elements)
                                    {
                                        filterItem = new FilterItemModel();
                    filterItem.FieldName = item.DataFields;
                    filterItem.DataType = item.DataType;
                                        filterItemList.Add(filterItem);
                                    }

            // get Header value and field value
            IEnumerable<XElement> bookTablixRow = from tablix in xdoc.Descendants(ns + "TablixRow")
                                                  select tablix;
            //var tablixCells;
            foreach (var itemTablixRow in bookTablixRow)
                {
                var bookTablixCell = from t in itemTablixRow.Descendants(ns + "TablixCell") select t;

                foreach (var itemTablixCell in bookTablixCell)
                                {
                                    if (count == 0)
                                    {
                        var headerValue = from h in itemTablixCell.Descendants(ns + "Value") select h.Value;
                        string strHeaderValue = string.Empty;
                        foreach (var headerItem in headerValue)
                            strHeaderValue = strHeaderValue + headerItem.ToString();
                        strHeader = strHeader + strHeaderValue + ";";
                                    }
                                    else if (count == 1)
                                    {
                        var fieldValue = from h in itemTablixCell.Descendants(ns + "Textbox").Attributes() select h;
                        strField = strField + fieldValue.FirstOrDefault().Value + ";";
                                    }
                                }
                                count++;
                                if (count == 2)
                                    break;

            }
            //Split headerName & fieldName string Update to List of Filter Items
            string [] headerName = strHeader.Split(';');
            string[] fieldName = strField.Split(';');
            foreach (FilterItemModel item in filterItemList)
            {
                for (int j = 0; j < headerName.Length; j++)
                {
                    if (fieldName[j].ToUpper() == item.FieldName.ToString().ToUpper())
                        item.HeaderName = string.IsNullOrEmpty(headerName[j]) ? "" : headerName[j];
                }
            }
            return filterItemList;
        }
        public IEnumerable<ReportParameter> GetVisibleParametersInfo(string reportPath)
        {
            return GetVisibleParametersInfo(reportPath, null);
        }
        public IEnumerable<ReportParameter> GetVisibleParametersInfo(string reportPath, IEnumerable<ParameterValue> prmValues)
        {
            string historyID = null;
            DataSourceCredentials[] credentials = null;
            
            //must assign the DataParam first before get the parameters
            if (prmValues == null)
            {
                prmValues = Enumerable.Empty<ParameterValue>();
            }
            if (!prmValues.Any(p => p.Name.Equals(Constants.STR_DATABASE_PARAM)))
            {
                var dbParam = new [] { new ParameterValue() { Name = Constants.STR_DATABASE_PARAM, Value = ConfigurationManager.ConnectionStrings[Constants.STR_RS_CONNECTIONSTRING].ToString() }};
                prmValues = prmValues.Concat(dbParam);
            }

            try
            {
                var result = _rs.GetReportParameters(reportPath, historyID, true, prmValues.ToArray(), credentials);
                // replace connectionstring immediately to avoid subdataset in .rdl error get default connectionstring
                if (prmValues.Any(p => p.Name.Equals(Constants.STR_DATABASE_PARAM)))
                {
                    _rs.SetReportParameters(reportPath, result);
                }
                return result;
            }
            catch (Exception ex)
            {                
                Logger.Error("Can't retrieve Report Information, Report doesn't exists!", ex);
                throw;
                //return null;
            }
        }

        public ParameterValue[] GetParameterValues(string subid)
        {
            ExtensionSettings ext = null;
            string desc = null;
            ActiveState activeState = null;
            string status = null;
            string eventType = null;
            string matchDate = null;
            ParameterValue[] pvs = null;
            try
            {
                _rs.GetSubscriptionProperties(subid, out ext, out desc, out activeState, out status, out eventType, out matchDate, out pvs);
            }
            catch (Exception ex)
            {
                Logger.Error("Cann't retrieve Report Information, Report doesn't exists!", ex);
            }
            return pvs;
        }

        public static List<Microsoft.Reporting.WebForms.ReportParameter> GetInvisibleParameter(string userName, IList<string> exception)
        {
            List<Microsoft.Reporting.WebForms.ReportParameter> reportParams = new List<Microsoft.Reporting.WebForms.ReportParameter>();
            if (exception == null || !exception.Contains(Constants.STR_DATABASE_PARAM))
            {
                reportParams.Add(new Microsoft.Reporting.WebForms.ReportParameter(Constants.STR_DATABASE_PARAM, ConfigurationManager.ConnectionStrings[Constants.STR_RS_CONNECTIONSTRING].ToString(), false));
            }
            if (exception == null || !exception.Contains(Constants.STR_USERNAME_PARAM))
            {
                reportParams.Add(new Microsoft.Reporting.WebForms.ReportParameter(Constants.STR_USERNAME_PARAM, userName, false));
            }
            return reportParams;
        }

        public static IList<ParameterValue> GetInvisibleParameterValue(string userName, IList<string> exception)
        {
            List<ParameterValue> reportParams = new List<ParameterValue>();
            if (exception == null || !exception.Contains(Constants.STR_DATABASE_PARAM))
            {
                reportParams.Add(new ParameterValue() { Name = Constants.STR_DATABASE_PARAM, Value = ConfigurationManager.ConnectionStrings[Constants.STR_RS_CONNECTIONSTRING].ToString() });
            }
            if (exception == null || !exception.Contains(Constants.STR_USERNAME_PARAM))
            {
                reportParams.Add(new ParameterValue() { Name = Constants.STR_USERNAME_PARAM, Value = userName });
            }
            return reportParams;
        }
    }
}