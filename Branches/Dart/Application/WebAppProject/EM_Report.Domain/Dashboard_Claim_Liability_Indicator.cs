namespace EM_Report.Domain
{
    using System.Runtime.Serialization;

    [DataContract(Name = "Dashboard_Claim_Liability_Indicator", Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_Claim_Liability_Indicator
    {
        [DataMember]
        public int Id { get; set; }

        [DataMember]
        public string System { get; set; }

        [DataMember]
        public int? Liability_Id { get; set; }

        [DataMember]
        public string Liability_Code { get; set; }

        [DataMember]
        public string Description { get; set; }
    }
}