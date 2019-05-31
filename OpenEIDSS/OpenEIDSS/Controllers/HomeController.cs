using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    public class HomeController : Controller
    {
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public ActionResult Index()
        {
            //ViewBag.Title = "Home Page";

            //return View();

            // Redirect to swagger...
            return new RedirectResult("~/swagger");
        }
    }
}
