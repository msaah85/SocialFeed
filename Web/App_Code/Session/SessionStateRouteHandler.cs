﻿using System.Web;
using System.Web.Http.WebHost;
using System.Web.Routing;
using System.Web.SessionState;

public class SessionStateRouteHandler : IRouteHandler
{
    IHttpHandler IRouteHandler.GetHttpHandler(RequestContext requestContext)
    {
        return new SessionableControllerHandler(requestContext.RouteData);
    }
}

public class SessionableControllerHandler : HttpControllerHandler, IRequiresSessionState
{
    public SessionableControllerHandler(RouteData routeData)
        : base(routeData)
    { }
}