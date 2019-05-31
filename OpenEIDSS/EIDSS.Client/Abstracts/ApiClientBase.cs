using EIDSS.Client.Configuration;
using EIDSS.Client.Responses;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Reflection;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Threading.Tasks;

namespace EIDSS.Client.Abstracts
{
    /// <summary>
    /// EIDSS Http client base class.
    /// </summary>
    public abstract class APIClientBase : IDisposable
    {
        private const string ClientUserAgent = "EIDSS-Api-Client-v1";

        protected internal string _baseurl;
        protected internal HttpClient _apiclient;
        protected internal EIDSSAPIConfigSettings _settings;
        private MediaTypeFormatter _formatter;

     
        public System.Net.Http.Headers.HttpRequestHeaders CustomHeaders { get; set; }
        /// <summary>
        /// Api resource helper.
        /// </summary>
        public EIDSSAPIConfigSettings Settings { get { return _settings; } }

        /// <summary>
        /// Gets the Http Client.
        /// </summary>
        protected internal HttpClient APIClient
        {
            get { return _apiclient; }
        }

        private HttpClientHandler _httpClientHandler;
        private TimeSpan _timeout; 

        /// <summary>
        /// The Media Type Formatter used by this http client...
        /// </summary>
        public MediaTypeFormatter Formatter
        {
            get { return this._formatter; }
        }

        /// <summary>
        /// Instantiates a new instance of the class. 
        /// </summary>
        public APIClientBase()
        {
            _settings = new EIDSSAPIConfigSettings();
            _timeout = new TimeSpan(0, 0, 90); // default to 90 seconds... move this to config!!!

            this._baseurl = NormalizeBaseUrl(this._settings.ServerUri);
            this.CreateHttpClient();

            // Auto accept certificate.... modify this for production...
            ServicePointManager.ServerCertificateValidationCallback = delegate { return true; };

            // For all derivations of this class with the exception of the AccountServiceClient, the token
            // will already be set.  Because the logon process occurs via the AccountServiceClient, the token doesn't
            // get set until after the EIDSSLogon enpoint returns said token.  
            if (!String.IsNullOrEmpty(EIDSSAuthenticatedUser.AccessToken))
            {
                // Set the token!
                this._apiclient.DefaultRequestHeaders.Authorization =
                new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", EIDSSAuthenticatedUser.AccessToken);

                // Add the UserId to the header...
                _apiclient.DefaultRequestHeaders.Add("USERID", EIDSSAuthenticatedUser.EIDSSUserId.ToString());
            }
        }

        /// <summary>
        /// Sets the media type format requested from/posted to the API given the configured default response type in configuration. 
        /// </summary>
        internal void SetMediaFormatter()
        {
            this._apiclient.DefaultRequestHeaders.Accept.Clear();

            switch (this._settings.DefaultMediaType)
            {
                case Enumerations.ResponseTypeEnum.JSON:
                    _formatter = new JsonMediaTypeFormatter();
                    break;
                case Enumerations.ResponseTypeEnum.BSON:
                    _formatter = new BsonMediaTypeFormatter();
                    break;
                case Enumerations.ResponseTypeEnum.XML:
                    _formatter = new XmlMediaTypeFormatter();
                    break;
            }

            // Add the supported media types to client.
            foreach( var mt in _formatter.SupportedMediaTypes)
                this._apiclient.DefaultRequestHeaders.Accept.Add(
                    new System.Net.Http.Headers.MediaTypeWithQualityHeaderValue( 
                        mt.MediaType.ToString()));

        }

        /// <summary>
        /// Dispose
        /// </summary>
        public void Dispose()
        {
            _httpClientHandler?.Dispose();
            _apiclient?.Dispose();

        }

        /// <summary>
        /// Creates a new http client
        /// </summary>
        private void CreateHttpClient()
        {
            _httpClientHandler = new HttpClientHandler
            {
                AutomaticDecompression = DecompressionMethods.Deflate | DecompressionMethods.GZip
            };

            _apiclient = new HttpClient(_httpClientHandler, false)
            {
                Timeout = _timeout
            };

            _apiclient.DefaultRequestHeaders.UserAgent.ParseAdd(ClientUserAgent);

            if (!string.IsNullOrWhiteSpace(_baseurl))
            {
                _apiclient.BaseAddress = new Uri(_baseurl);
            }

            this.SetMediaFormatter();
        }

        ///// <summary>
        ///// Ensures that the http client is created, if not one is created.
        ///// </summary>
        //private void EnsureHttpClientCreated()
        //{
        //    if (_apiclient == null)
        //    {
        //        CreateHttpClient();
        //    }
        //}

        /// <summary>
        /// Ensures that the url is properly formulated.
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        protected internal static string NormalizeBaseUrl(string url)
        {
            return url.EndsWith("/") ? url : url + "/";
        }

        ///// <summary>
        ///// Serializes the parameter class into a list of key/value pairs for transmission to the service.
        ///// </summary>
        ///// <param name="parameterClass"></param>
        ///// <returns></returns>
        //protected internal List<KeyValuePair<string,string>> SerializeParameters(object parameterClass)
        //{
        //    List<KeyValuePair<string, string>> parms = new List<KeyValuePair<string, string>>();

        //    // Will definitely have to add conditional code here depending upon the property type...
        //    foreach (var property in parameterClass.GetType().GetProperties())
        //    {
        //        var val = property.GetValue(parameterClass);
        //        if (val != null)
        //            parms.Add(new KeyValuePair<string, string>(property.Name, val.ToString()));
        //    }

        //    return parms;
        //}

        /// <summary>
        /// Creates an ObjectContent of class T which is used to serialize complex service method parameters prior to transmission
        /// to the API.
        /// </summary>
        /// <typeparam name="T">The type which will be contained within the ObjectContent.  Type must be a class!</typeparam>
        /// <param name="parms">The parameter collection to wrap in the Object Content class.</param>
        /// <returns>Returns an ObjectContent of type T.</returns>
        protected ObjectContent<T> CreateRequestContent<T>( T parms ) where T: class
        {
            return new ObjectContent<T>(parms, this._formatter);
        }

        ///// <summary>
        ///// Serializes an HttpResponseMessage into a T using the JSON Serializer.
        ///// </summary>
        ///// <typeparam name="T"></typeparam>
        ///// <param name="response"></param>
        ///// <returns></returns>
        //private T HandleJSONResponse<T>(HttpResponseMessage response) where T : class, new()
        //{

        //    return JsonConvert.DeserializeObject<T>(response.Content.ReadAsStringAsync().Result, new JsonSerializerSettings
        //    {
        //        ContractResolver = new CamelCasePropertyNamesContractResolver()
        //    });


        //}



    }
}
