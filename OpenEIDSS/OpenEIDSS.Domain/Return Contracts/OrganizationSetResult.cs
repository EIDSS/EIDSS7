namespace OpenEIDSS.Domain.Return_Contracts
{
    /// <summary>
    /// 
    /// </summary>
    public class OrganizationSetResult : SPReturnResult
    {
        public long? OrganizationId { get; set; }
        public long? LocationId { get; set; }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="resultCode"></param>
        /// <param name="organizationId"></param>
        /// <param name="locationId"></param>
        public OrganizationSetResult(int resultCode, long? organizationId, long? locationId) : base(resultCode)
        {
            OrganizationId = organizationId;
            LocationId = locationId;
        }
    }
}
