using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EIDSS.Client.Enumerations
{
    /// <summary>
    /// EIDSS role membership.
    /// </summary>
    public enum EIDSSRoleEnum
    {
        [Description("Administrator")]
        Administrator = -501,

        [Description("Chief Epidemiologist")]
        ChiefEpidemiologist = -502,

        [Description("Chief Epizootologist")]
        ChiefEpizootologist = -503,

        [Description("Chief of Laboratory (Human)")]
        ChiefofLaboratory_Human = -504,

        [Description("Chief of Laboratory (Vet)")]
        ChiefofLaboratory_Vet = -505,

        [Description("Default")]
        Default = -1,

        [Description("Default Role")]
        DefaultRole = -506,

        [Description("Entomologist")]
        Entomologist = -507,

        [Description("Epidemiologist")]
        Epidemiologist = -508,

        [Description("Epizootologist")]
        Epizootologist = -509,

        [Description("Lab Technician (Human)")]
        LabTechnician_Human = -510,

        [Description("Lab Technician (Vet)")]
        LabTechnician_Vet = -511,

        [Description("Notifiers")]
        Notifiers = -512
    }


    /// <summary>
    /// Extension that allows the caller to get the enum description.
    /// </summary>
    public static class RoleEnumExtension
    {
        public static string ToEnumString(this EIDSSRoleEnum val)
        {
            DescriptionAttribute[] attributes = (DescriptionAttribute[])val
               .GetType()
               .GetField(val.ToString())
               .GetCustomAttributes(typeof(DescriptionAttribute), false);
            return attributes.Length > 0 ? attributes[0].Description : string.Empty;
        }
    }
}
