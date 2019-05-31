using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Attributes
{
    [AttributeUsage(AttributeTargets.Property,
      Inherited = false,
      AllowMultiple = false)]
    internal sealed class OptionalAttribute : Attribute 
    {
    }
}
