using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.BLL.Logger;
using EM_Report.DAL.Infrastructure;
using Microsoft.Reporting.WebForms;
using System.Web;

namespace EM_Report.BLL.Services
{
    public class ExportService
    {
        private string exportDriver = ConfigurationManager.AppSettings[EM_Report.BLL.Commons.Constants.STR_EXPORT_DRIVER];
        private string reportServerUrl = ConfigurationManager.AppSettings[EM_Report.BLL.Commons.Constants.STR_REPORT_SERVER_URL];
        private string rsConnectionString = ConfigurationManager.ConnectionStrings[Constants.STR_RS_CONNECTIONSTRING].ToString();
        private I_Logger _logger;

        public I_Logger Logger
        {
            get { return _logger; }
            set { _logger = value; }
        }

        public ExportService() {
            _logger = new Log4Net();
        }
        public string ExportFile(string strParams, string reportPath, string exportFormat, string username, bool IsRig)
        {
            
            IList<ReportParameter> rptParameters = this.GetReportParameters(strParams, reportPath, username, IsRig);
            DataTable tblAgencies = GetAllAgencies(
                rptParameters.FirstOrDefault(p => p.Name == "start_date").Values[0].ToString(),
                rptParameters.FirstOrDefault(p => p.Name == "end_date").Values[0].ToString(), 
                IsRig,
                bool.Parse(rptParameters.FirstOrDefault(p => p.Name == "IsAll").Values[0].ToString()));

            string exportDirectory = CreateExportDirectory(username);

            byte[] bytes = null;
            string fileName = null;
            string fullName = null;

            foreach (DataRow r in tblAgencies.Rows)
            {
                rptParameters.FirstOrDefault(p => p.Name == "Agency" + Constants.STR_HIDDEN).Values[0] = r[0].ToString();
                bytes = SSRSExportHelper.GetByteStream(reportServerUrl, reportPath, rptParameters, exportFormat);
                fileName = SSRSExportHelper.ValidateFileName(r[0].ToString() + " - Employer Notification");
                fullName = Path.Combine(exportDriver, exportDirectory, fileName + "." + exportFormat);
                SSRSExportHelper.SaveFile(bytes, fullName, exportFormat);
            }
            fullName = Path.Combine(exportDriver, exportDirectory, "Summary" + "." + exportFormat);
            rptParameters.FirstOrDefault(p => p.Name == "Agency" + Constants.STR_HIDDEN).Values[0] = "summary";
            rptParameters.FirstOrDefault(p => p.Name == "All_Agencies_in_one").Values[0] = "true";
            bytes = SSRSExportHelper.GetByteStream(reportServerUrl, reportPath, rptParameters, exportFormat);
            SSRSExportHelper.SaveFile(bytes, fullName, exportFormat);

            return exportDirectory;
        }

        public MemoryStream Zip(string directory)
        {
            MemoryStream ms = new MemoryStream();
            SSRSExportHelper.ZipToStream(directory.Substring(directory.LastIndexOf('\\')), directory, ms);
            return ms;
        }

        private IList<ReportParameter> GetReportParameters(string strParams, string reportPath, string username, bool isRig)
        {
            ReportParameterService paramService = new ReportParameterService();
            IEnumerable<EM_Report.Models.RS2005.ReportParameter> ssrsParameters = paramService.GetVisibleParametersInfo(reportPath);
            if (strParams.Length > 0)
            {
                List<ReportParameter> reportParameter = new List<ReportParameter>();
                reportParameter.Add(new ReportParameter(EM_Report.BLL.Commons.Constants.STR_IS_RIG, isRig.ToString()));
                reportParameter.Add(new ReportParameter(EM_Report.BLL.Commons.Constants.STR_USERNAME_PARAM, username));
                reportParameter.Add(new ReportParameter(EM_Report.BLL.Commons.Constants.STR_DATABASE_PARAM, rsConnectionString));
                reportParameter.Add(new ReportParameter("Agency" + EM_Report.BLL.Commons.Constants.STR_HIDDEN, ""));
                foreach (string param in strParams.Split(';'))
                {
                    var items = param.Split('|');
                    if (items.Length > 0 && items[0].StartsWith("prm") && !items[0].EndsWith(Constants.STR_HIDDEN))
                    {
                        var name = items[0].Substring(3);
                        var reportInfo = ssrsParameters.FirstOrDefault(r => r.Name == name);
                        if (reportInfo != null)
                        {
                            reportParameter.Add(new ReportParameter(name, items[1], true));
                        }
                    }

                }
                return reportParameter;
            }
            return null;
        }

        private DataTable GetAllAgencies(string startDate, string endDate, bool isAll, bool isRig)
        {
            if (startDate.Length > 10)
                startDate = startDate.Substring(0, startDate.IndexOf(" "));
            if (endDate.Length > 10)
                endDate = endDate.Substring(0, endDate.IndexOf(" "));
            if (startDate.Length < 10)
                startDate = '0' + startDate;
            Dictionary<string, object> prms = new Dictionary<string, object>();
            prms.Add("start_date", DateTime.ParseExact(startDate, new string[] { "dd/MM/yyyy", "d/M/yyyy" }, null, System.Globalization.DateTimeStyles.None));
            prms.Add("end_date", DateTime.ParseExact(endDate, new string[] { "dd/MM/yyyy", "d/M/yyyy" }, null, System.Globalization.DateTimeStyles.None));
            prms.Add("IsAll", isAll);
            prms.Add("IsRig", isRig);
            DataTable allAgencies = RepositoryBaseExtension.ExecuteQueryStoreProcedure("usp_EmployerNotification_Agency", prms);
            if (allAgencies.Rows.Count <= 0)
                throw new Exception("No Agencies Found");
            return allAgencies;
        }

        private string CreateExportDirectory(string username)
        {
            string fileLocation = Path.Combine("TMF Agency Employer Notification", username + " - Agency Employer Notification - " + DateTime.Now.ToString());
            fileLocation = SSRSExportHelper.ValidatePath(fileLocation);
            fileLocation = Path.Combine(exportDriver, fileLocation);
            try
            {
                Directory.CreateDirectory(fileLocation);
            }
            catch (Exception ex)
            {
                throw new Exception("Could not create export folder", ex);
            }
            return fileLocation;
        }

        public bool ExportFile(ref string message, string user, string reportPath, string summaryReportpath, string exportFormat, IList<Microsoft.Reporting.WebForms.ReportParameter> parammeters)
        {
            string exportDriver = ConfigurationManager.AppSettings[EM_Report.BLL.Commons.Constants.STR_EXPORT_DRIVER];
            string reportServerUrl = ConfigurationManager.AppSettings[EM_Report.BLL.Commons.Constants.STR_REPORT_SERVER_URL];

            ReportParameterService paramService = new ReportParameterService();
            IEnumerable<EM_Report.Models.RS2005.ReportParameter> ssrsParameters = paramService.GetVisibleParametersInfo(reportPath);

            List<Microsoft.Reporting.WebForms.ReportParameter> wParameters = ReportParameterService.GetInvisibleParameter(user, null).ToList();
            foreach (EM_Report.Models.RS2005.ReportParameter p in ssrsParameters)
            {
                wParameters.Add(new Microsoft.Reporting.WebForms.ReportParameter(p.Name));
            }

            return true;
        }
    }
}