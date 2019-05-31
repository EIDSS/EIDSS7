using System;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;
using Newtonsoft.Json;
using System.Runtime.Caching;
using log4net.Core;
using System.Threading;
using OpenEIDSS.Extensions.Helpers;
using System.Collections.Generic;
using static OpenEIDSS.Extensions.Helpers.CacheOpps;

namespace OpenEIDSS.Extensions.Attributes
{
    /// <summary>
    /// 
    /// </summary>
    public class CacheHttpGetAttribute : ActionFilterAttribute
    {
        // cache length in seconds
        private int _timespan;
        // client cache length in seconds
        private int _clientTimeSpan;
        // cache for anonymous users only?
        private bool ? _anonymousOnly;
        // cache key
        private string _cachekey;
        // cache repository
        private static readonly ObjectCache WebApiCache = MemoryCache.Default;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="timespan"></param>
        /// <param name="clientTimeSpan"></param>
        /// <param name="anonymousOnly"></param>
        public CacheHttpGetAttribute(int timespan, int clientTimeSpan, bool anonymousOnly)
        {

            _timespan = String.IsNullOrEmpty(System.Configuration.ConfigurationManager.AppSettings["APICacheLength"]) ? timespan : Int32.Parse(System.Configuration.ConfigurationManager.AppSettings["APICacheLength"]);
            _clientTimeSpan =   String.IsNullOrEmpty(System.Configuration.ConfigurationManager.AppSettings["APICacheClientTimeSpan"]) ? clientTimeSpan : Int32.Parse(System.Configuration.ConfigurationManager.AppSettings["APICacheClientTimeSpan"]);
            _anonymousOnly = String.IsNullOrEmpty(System.Configuration.ConfigurationManager.AppSettings["APICacheAnonymousOnly"]) ? anonymousOnly : Boolean.Parse(System.Configuration.ConfigurationManager.AppSettings["APICacheAnonymousOnly"]);
        }

      
        private bool _isCacheable(HttpActionContext ac)
        {
            if (_timespan > 0 && _clientTimeSpan > 0)
            {
                if (_anonymousOnly.Value)
                    if (Thread.CurrentPrincipal.Identity.IsAuthenticated)
                        return false;
                if (ac.Request.Method == HttpMethod.Get | ac.Request.Method == HttpMethod.Post) return true;
            }
            else
            {
                throw new InvalidOperationException("Wrong Arguments");
            }
            return false;
        }

        private CacheControlHeaderValue setClientCache()
        {
            var cachecontrol = new CacheControlHeaderValue();
            cachecontrol.MaxAge = TimeSpan.FromSeconds(_clientTimeSpan);
            cachecontrol.MustRevalidate = true;
            return cachecontrol;
        }

        private static string GetServerCacheKey(HttpRequestMessage request)
        {
            var acceptHeaders = request.Headers.Accept;
            var acceptHeader = acceptHeaders.Any() ? acceptHeaders.First().ToString() : "*/*";
            return string.Join(":", new[]
            {
            request.RequestUri.AbsoluteUri,
            acceptHeader,
        });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ac"></param>
        public override void OnActionExecuting(HttpActionContext ac)
        {
            IEnumerable<string> CacheKey;
            IEnumerable<string> values;
            IHashGen hashGen = new HashGen();
            string hashString = string.Empty;
            if (ac.Request.Headers.TryGetValues("CacheKey", out CacheKey))
            {
                 hashString = hashGen.GenerateSHA256String(CacheKey.ToList()[0]);
                _cachekey = hashString; //string.Join(":", new string[] { ac.Request.RequestUri.AbsolutePath +"/" + hashString, ac.Request.Headers.Accept.FirstOrDefault().ToString() });


                if (ac.Request.Headers.TryGetValues("CacheAction", out values))
                {
                    if (CachAction.DELETE.ToString() == values.ToList()[0])
                    {
                        if (WebApiCache.Contains(_cachekey))
                        {
                            WebApiCache.Remove(_cachekey);
                        }
                    }
                    if (CachAction.GET.ToString() == values.ToList()[0])
                    {
                        if (ac != null)
                        {
                            if (_isCacheable(ac))
                            {
                                if (WebApiCache.Contains(_cachekey))
                                {
                                    var val = (string)WebApiCache.Get(_cachekey);
                                    if (val != null)
                                    {
                                        ac = SetHttpActionContext(ac, val);
                                        return;
                                    }
                                }
                            }
                        }
                        else
                        {
                            throw new ArgumentNullException("actionContext");
                        }
                    }
                }
                else
                {
                    hashString = hashGen.GenerateSHA256String(CacheKey.ToList()[0]);
                    _cachekey = string.Join(":", new string[] { ac.Request.RequestUri.AbsolutePath +"/" + hashString, ac.Request.Headers.Accept.FirstOrDefault().ToString() });
                    ac = SetHttpActionContext(ac, _cachekey);
                    return;
                }
            }
        }


        private HttpActionContext SetHttpActionContext(HttpActionContext ac ,string val)
        {


            ac.Response = ac.Request.CreateResponse();
            ac.Response.Content = new StringContent(val);
            var contenttype = (MediaTypeHeaderValue)WebApiCache.Get(_cachekey + ":response-ct");
            if (contenttype == null)
                contenttype = new MediaTypeHeaderValue(_cachekey.Split(':')[1]);
            ac.Response.Content.Headers.ContentType = contenttype;
            ac.Response.Headers.CacheControl = setClientCache();
            return ac;

        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="actionExecutedContext"></param>
        public override void OnActionExecuted(HttpActionExecutedContext actionExecutedContext)
        {
            IEnumerable<string> values;
            if (actionExecutedContext.Request.Headers.TryGetValues("CacheAction", out values))
            {
                if (CachAction.ADD.ToString() == values.ToList()[0])
                {
                    if (_cachekey != null & !(WebApiCache.Contains(_cachekey)))
                    {
                        var body = actionExecutedContext.Response.Content.ReadAsStringAsync().Result;
                        WebApiCache.Add(_cachekey, body, DateTime.Now.AddSeconds(_timespan));
                        WebApiCache.Add(_cachekey + ":response-ct", actionExecutedContext.Response.Content.Headers.ContentType, DateTime.Now.AddSeconds(_timespan));
                    }
                    if (_isCacheable(actionExecutedContext.ActionContext))
                        actionExecutedContext.ActionContext.Response.Headers.CacheControl = setClientCache();
                }
            }
        }
    }
}