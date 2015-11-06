using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Xml;
using System.Net;
using System.Web.Services.Protocols;
using SSRSDeployTool.Lib;
using System.Configuration;

namespace DesktopApp
{
    public partial class MainForm : Form
    {
        const string dataFileName = "data.dat";
        private bool _deploySuccess = false;

        public MainForm()
        {
            InitializeComponent();

            System.Net.ServicePointManager.ServerCertificateValidationCallback +=
                (se, cert, chain, sslerror) =>
                {
                    return true;
                };

            if (File.Exists(dataFileName))
            {
                var doc = new XmlDocument();
                doc.Load(dataFileName);

                if (IsRemember(doc))
                {
                    RestoreUserInput(doc);
                }
            }
        }

        private bool IsRemember(XmlDocument doc)
        {
            var rootElement = doc.DocumentElement;
            if (rootElement == null)
                return false;

            var isRememberElement = rootElement.SelectSingleNode("//IsRemember");
            if (isRememberElement == null)
                return false;

            var isRemember = bool.Parse(isRememberElement.InnerText);
            chkRemember.Checked = isRemember;

            return isRemember;
        }

        private void RestoreUserInput(XmlDocument doc)
        {
            var rootElement = doc.DocumentElement;

            var serverPathElement = rootElement.SelectSingleNode("//ServerName");
            tbServerName.Text = serverPathElement.InnerText;

            var dataSourceElement = rootElement.SelectSingleNode("//DataSource");

            var databaseElement = rootElement.SelectSingleNode("//Database");

            var reportsFolderElement = rootElement.SelectSingleNode("//ReportsFolder");
            tbReportsFolder.Text = reportsFolderElement.InnerText;
        }

        private void btnBrowse_Click(object sender, EventArgs e)
        {
            if (folderDialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                tbReportsFolder.Text = folderDialog.SelectedPath;
        }

        private void btnDeploy_Click(object sender, EventArgs e)
        {
            if (!backgroundWorker.IsBusy)
            {
                backgroundWorker.RunWorkerAsync();
            }
        }

        private string PopulateConnectionString(string dataSource, string database, string username, string password)
        {
            return string.Format("Data Source={0};Initial Catalog={1};Persist Security Info=True;User ID={2};Password={3}", dataSource, database, username, password);
        }

        private void backgroundWorker_DoWork(object sender, DoWorkEventArgs e)
        {
            if (ValidateNotEmptyFields())
            {
                var serverName = tbServerName.Text;
                var reportsFolder = tbReportsFolder.Text;
                var isRemember = chkRemember.Checked;

                Deploy(serverName, reportsFolder);
                if (_deploySuccess)
                {
                    SaveInput(serverName, reportsFolder, isRemember);
                }
            }
        }

        private void Deploy(string serverName, string reportsFolder)
        {
            var serverPath = "https://" + serverName + "/ReportServer/ReportService2010.asmx";
            string username = tbUsername.Text;
            string password = tbPassword.Text;
            string reportFilePath = reportsFolder;

            var parentFolderPath = "/EMReporting";
            string reportFolderName = "Reports";
            string datasetFolderName = "Dataset";
            string datasourceFolderName = "Data Sources";

            // Populate deploy options
            var deployList = new List<SSRSDeployModel>();
            foreach (Control ctrl in Controls)
            {
                var grpBox = ctrl as GroupBox;
                if (grpBox == null)
                    continue;

                if (grpBox.Name.StartsWith("grpBox"))
                {
                    var dashBoardType = grpBox.Name.Replace("grpBox", "");
                    var cacheHour = int.Parse(((TextBox)grpBox.Controls.Find("txtSSRSCacheAtHour_" + dashBoardType, true).FirstOrDefault()).Text);
                    var cacheMinute = int.Parse(((TextBox)grpBox.Controls.Find("txtSSRSCacheAtMinute_" + dashBoardType, true).FirstOrDefault()).Text);
                    var refreshHour = int.Parse(((TextBox)grpBox.Controls.Find("txtRefreshSSRSCacheAtHour_" + dashBoardType, true).FirstOrDefault()).Text);
                    var refreshMinute = int.Parse(((TextBox)grpBox.Controls.Find("txtRefreshSSRSCacheAtMinute_" + dashBoardType, true).FirstOrDefault()).Text);
                    var snapshotHour = int.Parse(((TextBox)grpBox.Controls.Find("txtSSRSSnapshotAtHour_" + dashBoardType, true).FirstOrDefault()).Text);
                    var snapshotMinute = int.Parse(((TextBox)grpBox.Controls.Find("txtSSRSSnapshotAtMinute_" + dashBoardType, true).FirstOrDefault()).Text);

                    var model = new SSRSDeployModel
                    {
                        DashboardType = dashBoardType,
                        CacheOptions = new SSRSCacheOptions
                        {
                            Cache_Dataset_At_Hour = cacheHour,
                            Cache_Dataset_At_Minute = cacheMinute,
                            Refresh_Cache_Dataset_At_Hour = refreshHour,
                            Refresh_Cache_Dataset_At_Minute = refreshMinute,
                            DatasetFolderPath = parentFolderPath + "/" + datasetFolderName,
                        },
                        SnapshotOptions = new SSRSSnapshotOptions
                        {
                            Snapshot_At_Hour = snapshotHour,
                            Snapshot_At_Minute = snapshotMinute,
                            SnapshotReports = new List<string> { "level0", "level1", "level2", "cpr_week_month_summary" },
                            ReportFolderPath = parentFolderPath + "/" + reportFolderName,
                            CreateSnaphot = chkSnapshot.Checked
                        },
                    };

                    deployList.Add(model);
                }
            }

            // Deploy
            var reportFolder = new DirectoryInfo(reportFilePath);
            var dataSetCount = reportFolder.GetFiles("*.rds").Length;
            var dataSourceCount = reportFolder.GetFiles("*.rsd").Length;
            var reportCount = reportFolder.GetFiles("*.rdl").Length;
            if (dataSetCount + dataSourceCount + reportCount == 0)
            {
                MessageBox.Show("No SSRS file was found");
                return;
            }

            try
            {
                lblStatus.Text = "Initiating deployment ...";
                prgBar.MarqueeAnimationSpeed = 10;
                var helper = new SSRSDeployHelper(serverPath, username, password, parentFolderPath, reportFolderName, datasetFolderName, datasourceFolderName, "", reportFilePath);

                lblStatus.Text = "Deploying ...";
                deployList.ForEach(x =>
                {
                    helper.Deploy(x);
                });

                _deploySuccess = true;
            }
            catch (WebException ex)
            {
                MessageBox.Show("Server name is in correct");
                _deploySuccess = false;
            }
            catch (SoapException ex)
            {
                if (ex.Actor.Contains(serverName))
                {
                    MessageBox.Show("Report server username or password is incorrect");
                }
                else if (ex.Message.Contains("SQL Server"))
                {
                    MessageBox.Show("Dart connection string is incorrect");
                }
                else if (ex.Message.Contains("Login failed"))
                {
                    MessageBox.Show("Dart database username or password is incorrect");
                }

                _deploySuccess = false;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }

        }

        private void SaveInput(string serverPath, string reportsFolder, bool isRemember)
        {
            XmlDocument doc = new XmlDocument();

            if (!File.Exists(dataFileName))
            {
                doc.LoadXml("<Data><ServerName></ServerName><DataSource></DataSource><Database></Database><ReportsFolder></ReportsFolder><IsRemember></IsRemember></Data>");
                doc.Save(dataFileName);
            }

            doc.Load(dataFileName);
            var rootElement = doc.DocumentElement;
            if (rootElement != null)
            {
                var serverPathElement = rootElement.SelectSingleNode("//ServerName");
                serverPathElement.InnerText = serverPath;

                var dataSourceElement = rootElement.SelectSingleNode("//DataSource");

                var databaseElement = rootElement.SelectSingleNode("//Database");

                var reportsFolderElement = rootElement.SelectSingleNode("//ReportsFolder");
                reportsFolderElement.InnerText = reportsFolder;

                var isRememberElement = rootElement.SelectSingleNode("//IsRemember");
                isRememberElement.InnerText = isRemember.ToString();

                doc.Save(dataFileName);
            }
        }

        private void backgroundWorker_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            if (_deploySuccess)
                lblStatus.Text = "Completed!";
            else
                lblStatus.Text = "Error!";

            _deploySuccess = false;
            prgBar.MarqueeAnimationSpeed = 0;
        }

        private bool ValidateNotEmptyFields()
        {
            if (string.IsNullOrEmpty(tbServerName.Text)
               || string.IsNullOrEmpty(tbUsername.Text)               
               || string.IsNullOrEmpty(txtSSRSCacheAtHour_AWC.Text)
               || string.IsNullOrEmpty(txtSSRSCacheAtMinute_AWC.Text)
               || string.IsNullOrEmpty(txtRefreshSSRSCacheAtHour_AWC.Text)
               || string.IsNullOrEmpty(txtRefreshSSRSCacheAtMinute_AWC.Text)
               || string.IsNullOrEmpty(txtSSRSSnapshotAtHour_AWC.Text)
               || string.IsNullOrEmpty(txtSSRSSnapshotAtMinute_AWC.Text)
               || string.IsNullOrEmpty(txtSSRSCacheAtHour_CPR.Text)
               || string.IsNullOrEmpty(txtSSRSCacheAtMinute_CPR.Text)
               || string.IsNullOrEmpty(txtRefreshSSRSCacheAtHour_CPR.Text)
               || string.IsNullOrEmpty(txtRefreshSSRSCacheAtMinute_CPR.Text)
               || string.IsNullOrEmpty(txtSSRSSnapshotAtHour_CPR.Text)
               || string.IsNullOrEmpty(txtSSRSSnapshotAtMinute_CPR.Text)
               || string.IsNullOrEmpty(txtSSRSCacheAtHour_RTW.Text)
               || string.IsNullOrEmpty(txtSSRSCacheAtMinute_RTW.Text)
               || string.IsNullOrEmpty(txtRefreshSSRSCacheAtHour_RTW.Text)
               || string.IsNullOrEmpty(txtRefreshSSRSCacheAtMinute_RTW.Text)
               || string.IsNullOrEmpty(txtSSRSSnapshotAtHour_RTW.Text)
               || string.IsNullOrEmpty(txtSSRSSnapshotAtMinute_RTW.Text)
               || string.IsNullOrEmpty(txtSSRSCacheAtHour_Others.Text)
               || string.IsNullOrEmpty(txtSSRSCacheAtMinute_Others.Text)
               || string.IsNullOrEmpty(txtRefreshSSRSCacheAtHour_Others.Text)
               || string.IsNullOrEmpty(txtRefreshSSRSCacheAtMinute_Others.Text)
               || string.IsNullOrEmpty(txtSSRSSnapshotAtH_Others.Text)
               || string.IsNullOrEmpty(txtSSRSSnapshotAtM_Others.Text)
               || string.IsNullOrEmpty(tbReportsFolder.Text))
            {
                MessageBox.Show("Missing fields");
                return false;
            }

            return true;
        }
    }
}
