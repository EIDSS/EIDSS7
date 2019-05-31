namespace OpenEIDSS.Domain.Return_Contracts
{
    /// <summary>
    /// 
    /// </summary>
    public class DepartmentSetResult : SPReturnResult
    {
        public long? DepartmentId { get; set; }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="departmentId"></param>
        public DepartmentSetResult(int resultCode, long? departmentId) : base(resultCode)
        {
            DepartmentId = departmentId;
        }
    }
}
