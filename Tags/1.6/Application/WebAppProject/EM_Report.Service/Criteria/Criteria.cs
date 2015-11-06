namespace EM_Report.Service.Criteria
{
    using System.Runtime.Serialization;

    /// <summary>
    /// Base class that holds criteria for queries.
    /// </summary>
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Criteria
    {         
        /// <summary>
        /// Sort expression of the criteria.
        /// </summary>
        [DataMember]
        public string SortExpression { get; set; }

        /// <summary>
        /// Search keyword of the criteria.
        /// </summary>
        [DataMember]
        public string SearchKeyWord { get; set; }

        /// <summary>
        /// Status of the criteria.
        /// </summary>
        [DataMember]
        public short Status { get; set; }

        /// <summary>
        /// Status of the criteria.
        /// </summary>
        [DataMember]
        public int PageSize { get; set; }

        /// <summary>
        /// Status of the criteria.
        /// </summary>
        [DataMember]
        public int PageIndex { get; set; }

        /// <summary>
        /// System of the criteria.
        /// </summary>
        [DataMember]
        public int SystemId { get; set; }

        /// <summary>
        /// System of the criteria.
        /// </summary>
        [DataMember]
        public string SystemName { get; set; }       
    }
}