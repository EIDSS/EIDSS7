using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class AggregateSettingsSetParam
    {

        public string IdfsAggrCaseType { get; set; }
        public string IdfCustomizationPackage { get; set; }
        public string StrValue { get; set; }
        public string IdfsStatisticAreaType { get; set; }
        public string IdfsStatisticPeriodType { get; set; }
    }
}
