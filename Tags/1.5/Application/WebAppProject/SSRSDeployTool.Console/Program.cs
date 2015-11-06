using SSRSDeployTool.Lib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SSRSDeployTool.Console
{
    class Program
    {
        static void Main(string[] args)
        {
            var parentFolderPath = "/EMReporting";
            string reportFolderName = "Reports";
            string datasetFolderName = "Dataset";
            string datasourceFolderName = "Data Sources";

            var serverPath = args[0];
            var username = args[1];
            var password = args[2];
            var connectionString = args[3];
            var reportFilePath = args[4];

            // Bypass SSL
            System.Net.ServicePointManager.ServerCertificateValidationCallback +=
                (se, cert, chain, sslerror) =>
                {
                    return true;
                };

            var helper = new SSRSDeployHelper(serverPath, username, password, connectionString, parentFolderPath, reportFolderName, datasetFolderName, datasourceFolderName, "", reportFilePath);
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
                CreateSnaphot = true
            };

            helper.Deploy(cachingOptions, snapshotOptions);
        }
    }
}
