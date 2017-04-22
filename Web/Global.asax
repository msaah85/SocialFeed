<%@ Application Language="C#" %>
<%@ Import Namespace="Shared.Marketing.Web" %>
<%@ Import Namespace="System.Web.Optimization" %>
<%@ Import Namespace="System.Web.Routing" %>

<script runat="server">
    void Application_Start(object sender, EventArgs e)
    {
        RouteConfig.RegisterRoutes(RouteTable.Routes);
        BundleConfig.RegisterBundles(BundleTable.Bundles);
    }
    void Session_Start(object sender, EventArgs e)
    {
        // Code that runs when a new session is started
        HttpCookie _userInfo = Request.Cookies[Config._cookName]; // get saved cockie.
        if (_userInfo != null)
        {
            CookiesManager.UserLogin(_userInfo);
        }
    }
</script>
