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
            tbDataSource.Text = dataSourceElement.InnerText;

            var databaseElement = rootElement.SelectSingleNode("//Database");
            tbDatabase.Text = databaseElement.InnerText;

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
                var dataSource = tbDataSource.Text;
                var database = tbDatabase.Text;
                var reportsFolder = tbReportsFolder.Text;
                var isRemember = chkRemember.Checked;

                Deploy(serverName, dataSource, database, reportsFolder);
                if (_deploySuccess)
                {
                    SaveInput(serverName, dataSource, database, reportsFolder, isRemember);
                }
            }
        }

        private void Deploy(string serverName, string dataSource, string database, string reportsFolder)
        {
            var serverPath = "https://" + serverName + "/ReportServer/ReportService2010.asmx";
            string username = tbUsername.Text;
            string password = tbPassword.Text;
            string connectionString = PopulateConnectionString(dataSource, database, tbDbUsername.Text, tbDbPassword.Text);
            string reportFilePath = reportsFolder;

            //serverPath = "http://10.9.11.27/ReportServer/ReportService2010.asmx";
            //string serverPath = "https://aswvnsql01.aswigsyd.int/Reportserver/reportservice2010.asmx";
            //string username = "admin";
            //string password = "pa$$w0rd";
            //string connectionString = "Data Source=10.9.0.21;Initial Catalog=Dart;Persist Security Info=True;User ID=vnteam;Password=vnteam";
            var parentFolderPath = "/EMReporting";
            string reportFolderName = "Reports";
            string datasetFolderName = "Dataset";
            string datasourceFolderName = "Data Sources";
            //string varReportFilePath = @"I:\My Data\DART\branches\DashboardProject\ReportingProject";

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
                var helper = new SSRSDeployHelper(serverPath, username, password, connectionString, parentFolderPath, reportFolderName, datasetFolderName, datasourceFolderName, "", reportFilePath);

                lblStatus.Text = "Deploying ...";

                var cachingOptions = new SSRSCacheOptions
                {
                    Cache_Dataset_At_Hour = 6,
                    Cache_Dataset_At_Minute = 0,
                    Refresh_Cache_Dataset_At_Hour = 7,
                    Refresh_Cache_Dataset_At_Minute = 0,
                    DatasetFolderPath = parentFolderPath + "/" + datasetFolderName,
                };

                var snapshotOptions = new SSRSSnapshotOptions
                {
                    Snapshot_At_Hour = 7,
                    Snapshot_At_Minute = 30,
                    SnapshotReports = new List<string> { "level0", "level1", "level2" },
                    ReportFolderPath = parentFolderPath + "/" + reportFolderName,
                    CreateSnaphot = chkSnapshot.Checked
                };


                helper.Deploy(cachingOptions, snapshotOptions);

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

        private void SaveInput(string serverPath, string dataSource, string database, string reportsFolder, bool isRemember)
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
                dataSourceElement.InnerText = dataSource;

                var databaseElement = rootElement.SelectSingleNode("//Database");
                databaseElement.InnerText = database;

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
               || string.IsNullOrEmpty(tbPassword.Text)
               || string.IsNullOrEmpty(tbDataSource.Text)
               || string.IsNullOrEmpty(tbDatabase.Text)
               || string.IsNullOrEmpty(tbDbUsername.Text)
               || string.IsNullOrEmpty(tbDbPassword.Text)
               || string.IsNullOrEmpty(tbReportsFolder.Text))
            {
                MessageBox.Show("Missing fields");
                return false;
            }

            return true;
        }
    }
}
