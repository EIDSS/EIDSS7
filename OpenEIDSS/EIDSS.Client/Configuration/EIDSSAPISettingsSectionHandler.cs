using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using EIDSS.Client.Enumerations;
using System.Xml;
using System.Xml.Linq;
using System.Runtime.Caching;

namespace EIDSS.Client.Configuration
{
    /// <summary>
    /// EIDSS API Configuration Settings Section Handler
    /// This section handler manages the EIDSSAPISettings Section in the web.config file.
    /// </summary>
    public sealed class EIDSSAPISettingsSection : ConfigurationSection
    {

        /// <summary>
        /// Create a new instance of the class.
        /// </summary>
        public EIDSSAPISettingsSection()
            : base()
        {
        }

        [ConfigurationProperty("resources")]
        public ResourcesCollection HashKeys
        {
            get { return ((ResourcesCollection)(base["resources"])); }
        }

        [ConfigurationProperty("environmentConfiguration")]
        public EnvironmentConfigurationCollection EIDSSAPIEnvironmentConfiguration
        {
            get { return ((EnvironmentConfigurationCollection)(base["environmentConfiguration"])); }
        }

        [ConfigurationProperty("environmentVariables")]
        public EnvironmentVariablesCollection EIDSSAPIEnvironmentKeyValues
        {
            get { return ((EnvironmentVariablesCollection)(base["environmentVariables"])); }
        }

    }

    /// <summary>
    /// The collection class that will store the list of each "EnvironmentConfiguration" item that
    /// is returned back from the configuration manager.
    /// </summary>
    [ConfigurationCollection(typeof(EnvironmentConfigurationElement))]
    public class EnvironmentConfigurationCollection : ConfigurationElementCollection
    {
        protected override ConfigurationElement CreateNewElement()
        {
            return new EnvironmentConfigurationElement();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((EnvironmentConfigurationElement)(element)).ConfiguredEnvironment.ToString();
        }

        public EnvironmentConfigurationElement this[int idx]
        {
            get
            {
                return (EnvironmentConfigurationElement)BaseGet(idx);
            }
        }
    }

    /// <summary>
    /// The class that persists each "EnvironmentConfiguration" element returned by the configuration manager.
    /// </summary>
    public class EnvironmentConfigurationElement : ConfigurationElement
    {
        [ConfigurationProperty("activeEnvironment", IsRequired = true)]
        public string ConfiguredEnvironment
        {
            get { return ((string)(base["activeEnvironment"])); }
            set { base["activeEnvironment"] = value; }
        }


        /// <summary>
        /// Indicates the default media type used.  Default is BSON.  Additionally, the system supports JSON and XML
        /// </summary>
        [ConfigurationProperty("defaultMediaType", DefaultValue = "2" )]
        public int DefaultMediaType
        {
            get { return ((int)base["defaultMediaType"]); }
            set { base["defaultMediaType"] = (int)value; }
        }

        /// <summary>
        /// Toggles data paging for get requests
        /// </summary>
        [ConfigurationProperty("pagingEnabled", DefaultValue = "true")]
        public bool PagingEnabled
        {
            get { return ((bool)(base["pagingEnabled"])); }
            set { base["pagingEnabled"] = value; }
        }

        /// <summary>
        /// When paging is enabled for get requests, this property specifies the number of records retrieved per page
        /// </summary>
        [ConfigurationProperty( "pageSize", DefaultValue = "50" )]
        public int pageSize
        {
            get { return ((int)(base["pagingEnabled"])); }
            set { base["pagingEnabled"] = value; }
        }
    }

    /// <summary>
    /// The collection class that will store the list of each "EnvironmentConfiguration" item that
    /// is returned back from the configuration manager.
    /// </summary>
    [ConfigurationCollection(typeof(EnvironmentVariableElement))]
    public class EnvironmentVariablesCollection : ConfigurationElementCollection
    {
        protected override ConfigurationElement CreateNewElement()
        {
            return new EnvironmentVariableElement();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((EnvironmentVariableElement)(element)).Environment.ToString();
        }

        public EnvironmentVariableElement this[int idx]
        {
            get
            {
                return (EnvironmentVariableElement)BaseGet(idx);
            }
        }
    }

    /// <summary>
    /// The class that persists each "EnvironmentConfiguration" element returned by the configuration manager.
    /// </summary>
    public class EnvironmentVariableElement : ConfigurationElement
    {
        private ObjectCache cache = MemoryCache.Default;

        [ConfigurationProperty("environment", IsRequired = true)]
        public string Environment
        {
            get { return ((string)(base["environment"])); }
            set { base["environment"] = value; }
        }

        [ConfigurationProperty("href", IsRequired = true)]
        public string href
        {
            get

            {
                return _getServiceConfig();
                //return((string)(base["href"]));
            }
            set
            {
                base["href"] = value;
            }
        }

        private string _getServiceConfig()
        {
            var apioverride = cache.Get("apioverride") as string;

            if (!string.IsNullOrEmpty(apioverride))
                return apioverride;

            XmlDocument doc = new XmlDocument();
            string file = System.IO.Path.Combine(
                    System.IO.Path.GetDirectoryName(
                AppDomain.CurrentDomain.SetupInformation.ConfigurationFile), "APIOverride.config");
            
            if (System.IO.File.Exists(file))
            {
                var f = System.IO.File.ReadAllText(file);
                var str = XElement.Parse(f);
                try
                {
                    var ret = str.Value;
                    if( ret.EndsWith( @"\")) ret = ret.Substring( 0, ret.Length-1);

                    var kick = new CacheItemPolicy { SlidingExpiration = new TimeSpan(1, 0, 0) };
                    cache.Set("apioverride", ret, kick);

                    return ret;
                }
                catch(Exception ex )
                {
                    return ((string)(base["href"]));
                }
            }
            else return ((string)(base["href"]));
        }
    }
    /// <summary>
    /// The collection class that will store the list of each "Resources" item that
    /// is returned back from the configuration manager.
    /// </summary>
    [ConfigurationCollection(typeof(ResourceElement))]
    public class ResourcesCollection : ConfigurationElementCollection
    {
        protected override ConfigurationElement CreateNewElement()
        {
            return new ResourceElement();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((ResourceElement)(element)).ResourceName.ToString(); // + ((ResourceElement)(element)).href;
        }

        public ResourceElement this[int idx]
        {
            get
            {
                return (ResourceElement)BaseGet(idx);
            }
        }

        public ResourceElement this[string elementName]
        {
            get
            {
                return (ResourceElement)BaseGet(elementName);
            }
        }

        public new IEnumerator<ResourceElement> GetEnumerator()
        {
            int count = base.Count;
            for (int i = 0; i < count; i++)
            {
                yield return base.BaseGet(i) as ResourceElement;
            }
        }


        /// <summary>
        /// The class that persists each "Resource" element returned by the configuration manager.
        /// </summary>
        public class ResourceElement : ConfigurationElement
        {

            [ConfigurationProperty("resourceName", IsRequired = true)]
            public string ResourceName
            {
                get { return ((string)(base["resourceName"])); }
                set { base["resourceName"] = value; }
            }

            [ConfigurationProperty("href", IsRequired = true)]
            public string href
            {
                get
                {
                    return ((string)(base["href"]));
                }
                set
                {
                    base["href"] = value;
                }
            }

            //[ConfigurationProperty("query", IsRequired = false)]
            //public string query
            //{
            //    get { return ((string)(base["query"])); }
            //    set { base["query"] = value; }
            //}
        }
    }


}

