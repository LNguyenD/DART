namespace EM_Report.Domain
{
    using System;
    using System.Runtime.Serialization;

    [DataContract(Name = "Systems", Namespace = "http://www.yourcompany.com/types/")]
    public class Systems
    {
        [DataMember]
        public int SystemId { get; set; }

        [DataMember]
        public string Name { get; set; }

        [DataMember]
        public string Description { get; set; }

        [DataMember]
        public int Owner { get; set; }

        [DataMember]
        public int UpdatedBy { get; set; }

        [DataMember]
        public DateTime? Create_Date { get; set; }

        [DataMember]
        public short Status { get; set; }

        [DataMember]
        public int LevelId { get; set; }
    }
}