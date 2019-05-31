using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class AdminArchiveSettingsSetParams
    {
        public long archiveSettingUid{get;set;}
        public DateTime archiveBeginDate{get;set;}
        public TimeSpan archiveScheduledStartTime{get;set;}
        public int dataAgeforArchiveInYears{get;set;}
        public int  archiveFrequencyInDays{get;set;}
        public string auditCreateUser { get; set; }
    }
}
