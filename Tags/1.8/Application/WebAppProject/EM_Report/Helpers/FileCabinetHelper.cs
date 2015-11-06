using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using EM_Report.Domain;
using EM_Report.Domain.Enums;

namespace EM_Report.Helpers
{
    public class FileCabinetHelper
    {
        public static List<ActuarialItem> GetActuarialReports(string folderPath)
        {
            var result = new List<ActuarialItem>();

            Uri uri = new Uri(folderPath);

            var files = Directory.GetFiles(uri.LocalPath);
            if (files != null && files.Any())
            {
                foreach (var file in files)
                {
                    var fileInfo = new FileInfo(file);
                    var report = new ActuarialItem
                    {
                        Name = fileInfo.Name,
                        ModifiedDate = fileInfo.LastWriteTime,
                        Path = file,
                        Type = ActuarialItemType.File
                    };

                    result.Add(report);
                }
            }

            return result.OrderBy(f => f.Name).ToList();
        }

        public static List<ActuarialItem> GetActuarialFolders(string cabinetRootPath, string systemName)
        {
            var subFolders = new List<ActuarialItem>();

            Uri uri = new Uri(cabinetRootPath + "\\" + systemName);

            try
            {
                var folders = Directory.GetDirectories(uri.LocalPath);
                if (folders != null && folders.Any())
                {
                    foreach (var folder in folders)
                    {
                        var folderInfo = new DirectoryInfo(folder);
                        var subFolder = new ActuarialItem
                        {
                            Name = folderInfo.Name,
                            ModifiedDate = folderInfo.LastWriteTime,
                            Path = folder,
                            Type = ActuarialItemType.Folder
                        };

                        subFolders.Add(subFolder);
                    }
                }
            }
            catch { }

            return subFolders.OrderBy(f => f.Name).ToList();
        }
    }
}