using OpenEIDSS.Domain.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OmmSessionGetListParams
    {
        public string langId { get; set; }
        public string strOutbreakID { get; set; }
        [Optional]
        public long? outbreakTypeId { get; set; }
        [Optional]
        public long? searchDiagnosesGroup { get; set; }
        [Optional]
        public System.DateTime? startDateFrom { get; set; }
        [Optional]
        public System.DateTime? startDateTo { get; set; }
        [Optional]
        public long? idfsOutbreakStatus { get; set; }
        [Optional]
        public long? idfsRegion { get; set; }
        [Optional]
        public long? idfsRayon { get; set; }
        public string quickSearch { get; set; }

        private int _paginationSet = 1;
        public int paginationSet
        {
            get { return _paginationSet; }
            set { _paginationSet = value; }
        }

        private int _pageSize = 10;
        public int pageSize

        {
            get { return _pageSize; }
            set { _pageSize = value; }
        }

        private int _maxPagesPerFetch = 10;
        public int maxPagesPerFetch
        {
            get { return _maxPagesPerFetch; }
            set { _maxPagesPerFetch = value; }
        }
    }
}