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
    
    public partial class TMF_RTW_Target_BaseDO
    {
        public int Id { get; set; }
        public string Type { get; set; }
        public string Value { get; set; }
        public string Sub_Value { get; set; }
        public Nullable<int> Measure { get; set; }
        public Nullable<double> Target { get; set; }
        public Nullable<double> Base { get; set; }
        public Nullable<int> UpdatedBy { get; set; }
        public Nullable<System.DateTime> Create_Date { get; set; }
        public Nullable<short> Status { get; set; }
        public string Remuneration { get; set; }
    }
}
