using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EM_Report.Domain;
using EM_Report.Domain.Enums;

namespace EM_Report.Domain
{
    public class FileCabinet
    {
        private IEnumerable<Report> _normalReports;
        public IEnumerable<Report> NormalReports 
        {
            get 
            {
                if (_normalReports == null)
                    return new List<Report>();

                return _normalReports;
            }
            set
            {
                _normalReports = value;
            }
        }

        private IEnumerable<Report> _actuarialReports;
        public IEnumerable<Report> ActuarialReports
        {
            get
            {
                if (_actuarialReports == null)
                    return new List<Report>();

                return _actuarialReports;
            }
            set
            {
                _actuarialReports = value;
            }
        }

        private IEnumerable<ActuarialItem> _reportFolders;
        public IEnumerable<ActuarialItem> ReportFolders 
        {
            get
            {
                if (_reportFolders == null)
                    return new List<ActuarialItem>();

                return _reportFolders;
            }
            set
            {
                _reportFolders = value;
            }
        }
    }

    public class ActuarialItem
    {
        public string Name { get; set; }
        public string Path { get; set; }
        public DateTime ModifiedDate { get; set; }
        public ActuarialItemType Type { get; set; }
    }    
}