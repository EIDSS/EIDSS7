using OpenEIDSS.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Formatting;
using System.Net.Http.Headers;
using System.Web.Http;
using Unity;
using Unity.Lifetime;
using Microsoft.AspNet;
using OpenEIDSS.Security;

namespace OpenEIDSS
{
    /// <summary>
    /// 
    /// </summary>
    public static class WebApiConfig
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="config"></param>
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services

            ////  Dependency Injection.... Resolves the IEIDSSRepository... SV 10/26/2018
            //var container = new UnityContainer();
            //container.RegisterType<IEIDSSRepository, EIDSSRepository>(new HierarchicalLifetimeManager());
            //config.DependencyResolver = new EIDSSUnityResolver(container);
            
            // Web API routes
            config.MapHttpAttributeRoutes();
            config.EnableCors();
            

            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional }

            );

            //  BSON Support... SV 10/22/2018
            //config.Formatters.Add(new BsonMediaTypeFormatter());

            //config.Formatters.Remove(config.Formatters.XmlFormatter);
            var bson = new BsonMediaTypeFormatter();
            bson.SupportedMediaTypes.Add(new MediaTypeHeaderValue("application/json"));
            config.Formatters.Add(bson);

            //config.Filters.Add(new SecuredAccessAttribute());


        }
    }
}
