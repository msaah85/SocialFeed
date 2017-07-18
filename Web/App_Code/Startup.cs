using Cireson.HttpResponseCompression.Owin;
using Microsoft.Owin;
using Owin;

[assembly: OwinStartup(typeof(Shared.Marketing.Web.Startup))]
namespace Shared.Marketing.Web
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            //ConfigureAuth(app);
            app.UseResponseCompressingMiddleware();
        }
    }
}
