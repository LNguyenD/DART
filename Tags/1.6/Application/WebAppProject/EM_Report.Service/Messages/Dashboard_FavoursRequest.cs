using System.Runtime.Serialization;
using EM_Report.Service.Criteria;
using EM_Report.Service.MessageBase;
using EM_Report.Domain;

namespace EM_Report.Service.Messages
{
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_FavoursRequest : RequestBase
    {
        [DataMember]
        public int FavourId;

        [DataMember]
        public int UserId;

        [DataMember]
        public string Name;

        [DataMember]
        public int UpdatedBy;

        [DataMember]
        public Dashboard_Favours Dashboard_Favours;
    }
}
