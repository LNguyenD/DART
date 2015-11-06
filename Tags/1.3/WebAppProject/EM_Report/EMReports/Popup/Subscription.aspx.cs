using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Xml;
using System.Xml.Serialization;
using System.IO;
using EM_Report.BLL.RS2005;

namespace EM_Report.EMReports.Popup
{
    public partial class Popup : System.Web.UI.Page
    {
        string _reportServerUrl = ConfigurationManager.AppSettings["ReportServerUrl"];
        ReportingService2005 rs = new ReportingService2005();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                ReportingService2005 rs05 = new ReportingService2005();
                rs05.Url = "http://aswlap08/reportserver/reportservice2005.asmx?wsdl";
                rs05.Credentials = System.Net.CredentialCache.DefaultCredentials;

                // get parameters of the report
                string historyID = null;
                ParameterValue[] praValues = null;
                DataSourceCredentials[] credentials = null;
                DataSourceCredentials cre = new DataSourceCredentials();
                ReportParameter[] parameters = rs05.GetReportParameters("/Report1", historyID, false, praValues, credentials);
                rptParameters.DataSource = parameters;
                rptParameters.DataBind();
            }
        }

        protected void btnSchedule_Click(object sender, EventArgs e)
        {
            Response.Redirect("Schedule.aspx");
        }

        protected void btnOk_Click(object sender, EventArgs e)
        {
            Init_Services();
            string description = "";
            string eventType = "TimedSubscription";
            string matchData = Session["ScheduleDefinition"].ToString();

            ExtensionSettings extSettings = GetExtensionSettings(
                txtSavedReportName.Text,
                ConfigurationManager.AppSettings["SavedReportPath_RecurrentSchedule"],
                drlFormats.SelectedValue.ToString(),
                ConfigurationManager.AppSettings["CAFS_UserName"],
                ConfigurationManager.AppSettings["CAFS_Password"]
                );

            rs.CreateSubscription(Session["ReportPath"].ToString(), extSettings, description, eventType, matchData, GetParameterValues().ToArray<ParameterValue>());
        }

        private List<ParameterValue> GetParameterValues()
        {
            List<ParameterValue> prmValues = new List<ParameterValue>();
            foreach (RepeaterItem item in rptParameters.Items)
            {
                Label lblParamName = (Label)item.FindControl("lblParamName");
                TextBox txtParameter = (TextBox)item.FindControl("txtParameter");
                prmValues.Add(new ParameterValue(){ Name=lblParamName.Text, Value = txtParameter.Text});
            }
            return prmValues;
        }

        private void Init_Services()
        {
            rs.Url = _reportServerUrl + "/reportservice2005.asmx";
            rs.Credentials = System.Net.CredentialCache.DefaultCredentials;
        }

        private ExtensionSettings GetExtensionSettings(string fileName, string savePath,
           string renderFormat, string username, string password)
        {
            ParameterValue[] extensionParams = new ParameterValue[7];

            for (int i = 0; i < extensionParams.Length; i++)
                extensionParams[i] = new ParameterValue();

            extensionParams[0].Name = "FILENAME";
            extensionParams[0].Value = fileName;

            extensionParams[1].Name = "FILEEXTN";
            extensionParams[1].Value = "true";

            extensionParams[2].Name = "PATH";
            extensionParams[2].Value = savePath;

            extensionParams[3].Name = "RENDER_FORMAT";
            extensionParams[3].Value = renderFormat;

            extensionParams[4].Name = "WRITEMODE";
            extensionParams[4].Value = "Overwrite";

            extensionParams[5].Name = "USERNAME";
            extensionParams[5].Value = username;

            extensionParams[6].Name = "PASSWORD";
            extensionParams[6].Value = password;

            ExtensionSettings extensionSettings = new ExtensionSettings();
            extensionSettings.Extension = "Report Server FileShare";
            extensionSettings.ParameterValues = extensionParams;

            return extensionSettings;
        }
    }
}