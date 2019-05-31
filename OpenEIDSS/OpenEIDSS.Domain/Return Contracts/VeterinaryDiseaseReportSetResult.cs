namespace OpenEIDSS.Domain.Return_Contracts
{
    /// <summary>
    /// 
    /// </summary>
    public class VeterinaryDiseaseReportSetResult : SPReturnResult
    {
        public long? VeterinaryDiseaseReportId { get; set; }
        public string EIDSSID { get; set; }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="resultCode"></param>
        /// <param name="veterinaryDiseaseReportId"></param>
        /// <param name="eidssId"></param>
        public VeterinaryDiseaseReportSetResult(int resultCode, long? veterinaryDiseaseReportId, string eidssId) : base(resultCode)
        {
            VeterinaryDiseaseReportId = veterinaryDiseaseReportId;
            EIDSSID = eidssId;
        }
    }
}
