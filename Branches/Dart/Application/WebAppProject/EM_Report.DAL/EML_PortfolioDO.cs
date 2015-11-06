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
    
    public partial class EML_PortfolioDO
    {
        public int Id { get; set; }
        public string Team { get; set; }
        public string Case_Manager { get; set; }
        public string Policy_No { get; set; }
        public string EMPL_SIZE { get; set; }
        public string Account_Manager { get; set; }
        public string Portfolio { get; set; }
        public System.DateTime Reporting_Date { get; set; }
        public string Claim_No { get; set; }
        public string WIC_Code { get; set; }
        public string Company_Name { get; set; }
        public string Worker_Name { get; set; }
        public string Employee_Number { get; set; }
        public string Worker_Phone_Number { get; set; }
        public string Claims_Officer_Name { get; set; }
        public Nullable<System.DateTime> Date_Of_Birth { get; set; }
        public Nullable<System.DateTime> Date_Of_Injury { get; set; }
        public Nullable<System.DateTime> Date_Of_Notification { get; set; }
        public Nullable<int> Notification_Lag { get; set; }
        public Nullable<int> Entered_Lag { get; set; }
        public string Claim_Liability_Indicator_Group { get; set; }
        public Nullable<decimal> Investigation_Incurred { get; set; }
        public Nullable<decimal> Total_Paid { get; set; }
        public Nullable<bool> Is_Time_Lost { get; set; }
        public string Claim_Closed_Flag { get; set; }
        public Nullable<System.DateTime> Date_Claim_Entered { get; set; }
        public Nullable<System.DateTime> Date_Claim_Closed { get; set; }
        public Nullable<System.DateTime> Date_Claim_Received { get; set; }
        public Nullable<System.DateTime> Date_Claim_Reopened { get; set; }
        public Nullable<int> Result_Of_Injury_Code { get; set; }
        public Nullable<double> WPI { get; set; }
        public Nullable<bool> Common_Law { get; set; }
        public Nullable<double> Total_Recoveries { get; set; }
        public Nullable<bool> Is_Working { get; set; }
        public Nullable<double> Physio_Paid { get; set; }
        public Nullable<double> Chiro_Paid { get; set; }
        public Nullable<double> Massage_Paid { get; set; }
        public Nullable<double> Osteopathy_Paid { get; set; }
        public Nullable<double> Acupuncture_Paid { get; set; }
        public Nullable<System.DateTime> Create_Date { get; set; }
        public Nullable<bool> Is_Stress { get; set; }
        public Nullable<bool> Is_Inactive_Claims { get; set; }
        public Nullable<bool> Is_Medically_Discharged { get; set; }
        public Nullable<bool> Is_Exempt { get; set; }
        public Nullable<bool> Is_Reactive { get; set; }
        public Nullable<bool> Is_Medical_Only { get; set; }
        public Nullable<bool> Is_D_D { get; set; }
        public string NCMM_Actions_This_Week { get; set; }
        public string NCMM_Actions_Next_Week { get; set; }
        public Nullable<decimal> HoursPerWeek { get; set; }
        public Nullable<bool> Is_Industrial_Deafness { get; set; }
        public Nullable<double> Rehab_Paid { get; set; }
        public string Action_Required { get; set; }
        public string RTW_Impacting { get; set; }
        public Nullable<int> Weeks_In { get; set; }
        public string Weeks_Band { get; set; }
        public string Hindsight { get; set; }
        public string Active_Weekly { get; set; }
        public string Active_Medical { get; set; }
        public string Cost_Code { get; set; }
        public string Cost_Code2 { get; set; }
        public string CC_Injury { get; set; }
        public string CC_Current { get; set; }
        public string Med_Cert_Status_This_Week { get; set; }
        public string Capacity { get; set; }
        public Nullable<decimal> Entitlement_Weeks { get; set; }
        public string Med_Cert_Status_Prev_1_Week { get; set; }
        public string Med_Cert_Status_Prev_2_Week { get; set; }
        public string Med_Cert_Status_Prev_3_Week { get; set; }
        public string Med_Cert_Status_Prev_4_Week { get; set; }
        public Nullable<bool> Is_Last_Month { get; set; }
        public Nullable<bool> IsPreClosed { get; set; }
        public Nullable<bool> IsPreOpened { get; set; }
        public Nullable<System.DateTime> NCMM_Complete_Action_Due { get; set; }
        public Nullable<int> NCMM_Complete_Remaining_Days { get; set; }
        public Nullable<System.DateTime> NCMM_Prepare_Action_Due { get; set; }
        public Nullable<int> NCMM_Prepare_Remaining_Days { get; set; }
    }
}
