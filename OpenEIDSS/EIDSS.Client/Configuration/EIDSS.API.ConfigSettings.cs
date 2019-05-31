using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using EIDSS.Client.Enumerations;

namespace EIDSS.Client.Configuration
{
    /// <summary>
    /// Manages the EIDSS.Api.Settings section of the web.config file where EIDSSApi resources are stored.
    /// </summary>
    public class EIDSSAPIConfigSettings
    {
        private EIDSSAPISettingsSection _handler = null;

        public EIDSSAPIConfigSettings()
        {
            this._handler = (EIDSSAPISettingsSection)ConfigurationManager.GetSection("EIDSS.Api.Settings");
        }

        /// <summary>
        /// Gets the currently configured environment.
        /// </summary>
        public string ConfiguredEnvironment
        {
            get
            {
                return this._handler.EIDSSAPIEnvironmentConfiguration[0].ConfiguredEnvironment;
            }
        }

        /// <summary>
        /// Indicates the format used to negotiate content between the API and a client.
        /// </summary>
        public ResponseTypeEnum DefaultMediaType
        {
            get
            {
                return (ResponseTypeEnum)this._handler.EIDSSAPIEnvironmentConfiguration[0].DefaultMediaType;
            }
        }

        /// <summary>
        /// Indicates where paging is enabled for calls that return large result sets.
        /// </summary>
        public bool PagingEnabled
        {
            get { return this._handler.EIDSSAPIEnvironmentConfiguration[0].PagingEnabled; }
        }

        /// <summary>
        /// When paging is enabled, determines the number of records that make up a page of data subsequently returned with
        /// a single call to the database
        /// </summary>
        public int PageSize
        {
            get { return this._handler.EIDSSAPIEnvironmentConfiguration[0].pageSize; }
        }

        #region Implement Later (Maybe)
        ///// <summary>
        ///// Gets the currently configuration data page size from the configuration file.
        ///// </summary>
        //public int PageSize
        //{
        //    get { return Convert.ToInt16(System.Configuration.ConfigurationManager.AppSettings["PageSize"].ToString()); }
        //}


        //public bool PagingEnabled
        //{
        //    get { return Convert.ToBoolean(System.Configuration.ConfigurationManager.AppSettings["Paging_Enabled"].ToString()); }
        //}

        //public bool PersistServiceRequests
        //{
        //    get { return Convert.ToBoolean(System.Configuration.ConfigurationManager.AppSettings["PersistServiceRequests"].ToString()); }
        //}

        //public bool PersistServiceResponses
        //{
        //    get { return Convert.ToBoolean(System.Configuration.ConfigurationManager.AppSettings["PersistServiceResponses"].ToString()); }
        //}

        //public int SendResultThreshold
        //{
        //    get { return Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["SendResultThreshold"].ToString()); }
        //}
        #endregion

        /// <summary>
        /// Returns the server portion of the url for the currently configured environment.
        /// </summary>
        public string ServerUri
        {
            get
            {
                return _getServerUri();
            }
        }

        /// <summary>
        /// Gets the list of available EIDSS API resources.
        /// </summary>
        public ResourcesCollection Resources
        {
            get { return this._handler.HashKeys; }
        }

        /// <summary>
        /// Given the resource key name, gets the complete uri to a resource including the servername.
        /// </summary>
        /// <param name="resourceName"></param>
        /// <returns></returns>
        public string GetFullyQualifiedResourceURI(string resourceName)
        {
            return this._getFullyQualifiedHref(this.GetResourceValue(resourceName));
        }

        /// <summary>
        /// Given the resource name, gets a resource key value identified by the "href" key of a resource in the 
        /// EIDSS.Api.Settings.resources section of the web.config
        /// </summary>
        /// <param name="keyName"></param>
        /// <returns></returns>
        public string GetResourceValue(string resourceName)
        {
            string resource = null;
            foreach (var r in this._handler.HashKeys)
                if (r.ResourceName.ToLower().Trim() == resourceName.ToLower().Trim())
                {
                    resource = r.href;
                    break;
                }
            if (resource == null) throw new KeyNotFoundException(string.Format("Unable to locate the API resource {0} in the EIDSS.Api.Settings section of the web.config file.", resourceName));
            return resource;
        }

        #region Helpers

        private string _getFullyQualifiedHref(string href)
        {
            var s = this._getServerUri();
            s += !s.Trim().EndsWith(@"/") ? @"/" + href : "" + href;

            return s;
        }

   
        private string _getServerUri()
        {
            string uri = string.Empty;

            var env = this._handler.EIDSSAPIEnvironmentKeyValues;

            foreach (EnvironmentVariableElement i in env)
            {
                if (i.Environment == this._handler.EIDSSAPIEnvironmentConfiguration[0].ConfiguredEnvironment)
                {
                    uri = i.href;
                    break;
                }
            }

            if (uri == string.Empty)
                throw new KeyNotFoundException(String.Format("Unable to set the server Uri because no matching configuration could be found for the '{0}' configuration specified int the environmentConfiguration element", this._handler.EIDSSAPIEnvironmentConfiguration[0].ConfiguredEnvironment));
            return uri;
        }

    
        #endregion
    }
}
