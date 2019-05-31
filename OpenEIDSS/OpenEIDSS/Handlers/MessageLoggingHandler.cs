using log4net;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace OpenEIDSS.Handlers
{
    /// <summary>
    /// 
    /// </summary>
    public class MessageLoggingHandler : MessageHandler
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="correlationId"></param>
        /// <param name="requestInfo"></param>
        /// <param name="message"></param>
        /// <returns></returns>
        protected override async Task IncommingMessageAsync(string correlationId, string requestInfo, byte[] message)
        {
            ThreadContext.Properties["AuditCreateUser"] = "Lamont";
            ThreadContext.Properties["AppSessionId"] = correlationId;
            ThreadContext.Properties["MethodInParams"] = Encoding.UTF8.GetString(message);
        
            await Task.Run(() =>
                Debug.WriteLine(string.Format("{0} - Request: {1}\r\n{2}", correlationId, requestInfo, Encoding.UTF8.GetString(message))));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="correlationId"></param>
        /// <param name="requestInfo"></param>
        /// <param name="message"></param>
        /// <returns></returns>
        protected override async Task OutgoingMessageAsync(string correlationId, string requestInfo, byte[] message)
        {
            ThreadContext.Properties["AuditCreateUser"] = "Lamont";
            ThreadContext.Properties["AppSessionId"] = correlationId;
            ThreadContext.Properties["MethodOutParams"] = string.Format("{0} - Response: {1}\r\n{2}", correlationId, requestInfo, Encoding.UTF8.GetString(message));


            await Task.Run(() =>
                Debug.WriteLine(string.Format("{0} - Response: {1}\r\n{2}", correlationId, requestInfo, Encoding.UTF8.GetString(message))));
        }
    }
}