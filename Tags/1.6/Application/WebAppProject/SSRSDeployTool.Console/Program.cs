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

            // Populate deploy options
            var deployList = new List<SSRSDeployModel>();
            for(var i = 5; ; i++)
            {
                try
                {
                    var deployInfo = args[i].Split('|');
                    var dashBoardType = deployInfo[0];
                    var cacheHour = int.Parse(deployInfo[1]);
                    var cacheMinute = int.Parse(deployInfo[2]);
                    var refreshHour = int.Parse(deployInfo[3]);
                    var refreshMinute = int.Parse(deployInfo[4]);
                    var snapshotHour = int.Parse(deployInfo[5]);
                    var snapshotMinute = int.Parse(deployInfo[6]);
                    var createSnapshot = bool.Parse(deployInfo[7]);

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
                            SnapshotReports = new List<string> { "level0", "level1", "level2" },
                            ReportFolderPath = parentFolderPath + "/" + reportFolderName,
                            CreateSnaphot = createSnapshot
                        },
                    };

                    deployList.Add(model);
                }
                catch(IndexOutOfRangeException)
                {
                    break;
                }
            }

            var helper = new SSRSDeployHelper(serverPath, username, password, parentFolderPath, reportFolderName, datasetFolderName, datasourceFolderName, "", reportFilePath);
            deployList.ForEach(x => 
            {
                helper.Deploy(x);
            });
        }
    }
}
