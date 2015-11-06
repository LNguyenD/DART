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
    
    public partial class UserDO
    {
        public UserDO()
        {
            this.ReportUserDOs = new HashSet<ReportUserDO>();
        }
    
        public int UserId { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Address { get; set; }
        public string Email { get; set; }
        public Nullable<short> Status { get; set; }
        public string Phone { get; set; }
        public Nullable<System.DateTime> Online_Locked_Until_Datetime { get; set; }
        public Nullable<short> Online_No_Of_Login_Attempts { get; set; }
        public Nullable<System.DateTime> Last_Online_Login_Date { get; set; }
        public Nullable<System.DateTime> Create_Date { get; set; }
        public Nullable<int> Owner { get; set; }
        public Nullable<int> UpdatedBy { get; set; }
        public bool Is_System_User { get; set; }
        public Nullable<int> Default_System_Id { get; set; }
    
        public virtual ICollection<ReportUserDO> ReportUserDOs { get; set; }
        public virtual SystemUserDO SystemUserDO { get; set; }
    }
}
