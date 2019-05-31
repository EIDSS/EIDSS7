using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OmmContactGetListParams
    {
        public string langId { get; set; }
        public long? OutbreakCaseReportUID { get; set; }
        public string QuickSearch { get; set; }

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

        public int FollowUp { get; set; }
    }
}