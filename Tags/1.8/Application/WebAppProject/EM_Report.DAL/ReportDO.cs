//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace EM_Report.DAL
{
    using System;
    using System.Collections.Generic;
    
    public partial class ReportDO
    {
        public ReportDO()
        {
            this.Report_External_AccessDOs = new HashSet<Report_External_AccessDO>();
            this.Report_Organisation_LevelDOs = new HashSet<Report_Organisation_LevelDO>();
        }
    
        public int ReportId { get; set; }
        public int CategoryId { get; set; }
        public string Name { get; set; }
        public string ShortName { get; set; }
        public string Url { get; set; }
        public string Description { get; set; }
        public Nullable<short> Status { get; set; }
        public Nullable<System.DateTime> Create_Date { get; set; }
        public Nullable<int> Owner { get; set; }
        public Nullable<int> UpdatedBy { get; set; }
        public Nullable<bool> ForSubscription { get; set; }
    
        public virtual Report_CategoryDO Report_CategoryDOs { get; set; }
        public virtual ICollection<Report_External_AccessDO> Report_External_AccessDOs { get; set; }
        public virtual ICollection<Report_Organisation_LevelDO> Report_Organisation_LevelDOs { get; set; }
    }
}
