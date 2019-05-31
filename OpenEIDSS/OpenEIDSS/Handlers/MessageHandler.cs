using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Web;

namespace OpenEIDSS.Handlers
{
    /// <summary>
    /// 
    /// </summary>
    public abstract class MessageHandler : DelegatingHandler
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        /// <param name="cancellationToken"></param>
        /// <returns></returns>
        protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
        {
            var corrId = string.Format("{0}{1}", DateTime.Now.Ticks, Thread.CurrentThread.ManagedThreadId);
            var requestInfo = string.Format("{0} {1}", request.Method, request.RequestUri);
            ThreadContext.Properties["AppMethodObject"] = request.Method.ToString();
            var requestMessage = await request.Content.ReadAsByteArrayAsync();

            await IncommingMessageAsync(corrId, requestInfo, requestMessage);

            var response = await base.SendAsync(request, cancellationToken);

            byte[] responseMessage;

            if (response.IsSuccessStatusCode)
                if (response.Content != null)
                    responseMessage = await response.Content.ReadAsByteArrayAsync();
                else
                    responseMessage = new byte[] { };
            else
                responseMessage = Encoding.UTF8.GetBytes(response.ReasonPhrase);

            await OutgoingMessageAsync(corrId, requestInfo, responseMessage);

            return response;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="correlationId"></param>
        /// <param name="requestInfo"></param>
        /// <param name="message"></param>
        /// <returns></returns>
        protected abstract Task IncommingMessageAsync(string correlationId, string requestInfo, byte[] message);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="correlationId"></param>
        /// <param name="requestInfo"></param>
        /// <param name="message"></param>
        /// <returns></returns>
        protected abstract Task OutgoingMessageAsync(string correlationId, string requestInfo, byte[] message);
    }

}