using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace EIDSS.Client
{
    /// <summary>
    /// Support for self signed certificates for the EIDSSService.
    /// This solution is only required until the EIDSSService is retired.
    /// </summary>
    public class GeriatricServiceSupport
    {

        #region static constructor (called by the CLR)

        /// <summary>
        /// Register the certificate callback...
        /// </summary>
        static GeriatricServiceSupport()
        {
            SetCertificateValidationCallBack();
        }

        #endregion

        /// <summary>
        /// Auto accept the server's certificate.  Not suitable for production environments.
        /// The EIDSSService will be deprecated prior to production.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="cert"></param>
        /// <param name="chain"></param>
        /// <param name="error"></param>
        /// <returns></returns>
        private static bool CustomCertificateValidation(object sender, X509Certificate cert, X509Chain chain, SslPolicyErrors error)
        {
            return true;
        }

        /// <summary>
        /// Sets the callback
        /// </summary>
        private static void SetCertificateValidationCallBack()
        {
            System.Net.ServicePointManager.ServerCertificateValidationCallback += new RemoteCertificateValidationCallback(CustomCertificateValidation);
        }
    }

}
