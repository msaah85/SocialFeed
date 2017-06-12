using System.Web;
using System.Web.Routing;
using Microsoft.AspNet.FriendlyUrls;
using System.Web.Http;
using System.Web.UI;
using Microsoft.AspNet.FriendlyUrls.Resolvers;

namespace Shared.Marketing.Web
{
    public static class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.MapHttpRoute(
                name: "ApiByName",
                routeTemplate: "api/{controller}/{action}/{name}",
                defaults: null,
                constraints: new { name = @"^[a-z]+$" }
            ).RouteHandler = new SessionStateRouteHandler();

            routes.MapHttpRoute(
                name: "ApiByAction",
                routeTemplate: "api/{controller}/{action}",
                defaults: new { action = "Get" }
            ).RouteHandler = new SessionStateRouteHandler();

            routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional },
                constraints: new { id = @"^[0-9]+$" }
            );


            var settings = new FriendlyUrlSettings();
            settings.AutoRedirectMode = RedirectMode.Permanent;
            routes.EnableFriendlyUrls(settings, new BugFixFriendlyUrlResolver());
        }
    }

    /// <summary>
    /// This is a hack to force no mobile URL resolution in FriendlyUrls.  There's some kind of bug in the current version that
    /// causes it to do an internal failed resolve of a mobile master even though there is none.
    /// </summary>
    public class BugFixFriendlyUrlResolver : WebFormsFriendlyUrlResolver
    {
        protected override bool TrySetMobileMasterPage(HttpContextBase httpContext, Page page, string mobileSuffix)
        {
            return false;
            //return base.TrySetMobileMasterPage(httpContext, page, mobileSuffix);
        }
    }
}