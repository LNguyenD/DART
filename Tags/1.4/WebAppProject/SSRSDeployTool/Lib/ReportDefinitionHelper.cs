using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;

namespace Lib
{
    class ReportDefinitionHelper
    {
        private XmlDocument _xmlDoc;

        public ReportDefinitionHelper(string reportPath)
        {
            _xmlDoc = new XmlDocument();
            _xmlDoc.Load(reportPath);
        }

        public List<SSRSDataSet> GetSharedDataset()
        {
            var result = new List<SSRSDataSet>();

            var docElement = _xmlDoc.DocumentElement;
            if (docElement == null)
                throw new Exception("More than 1 document element appear");

            var datasets = _xmlDoc.DocumentElement.GetElementsByTagName("DataSet");
            foreach (XmlElement dataset in datasets)
            {
                var sharedDataSetNodes = dataset.GetElementsByTagName("SharedDataSetReference");
                foreach (XmlElement sharedDataSetNode in sharedDataSetNodes)
                {
                    var sharedDataSet = new SSRSDataSet();
                    sharedDataSet.Name = dataset.GetAttribute("Name");
                    sharedDataSet.Reference = sharedDataSetNode.InnerText;
                    result.Add(sharedDataSet);
                }
            }

            return result;
        }
    }

    class SSRSDataSet
    {
        public string Name { get; set; }
        public string Reference { get; set; }
    }
}
