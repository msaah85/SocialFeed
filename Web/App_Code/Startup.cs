using Cireson.HttpResponseCompression.Owin;
using Hangfire;
using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Shared.Marketing.Web.Startup))]
namespace Shared.Marketing.Web
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
            app.UseResponseCompressingMiddleware();
            
            GlobalConfiguration.Configuration
                .UseSqlServerStorage("Aliraqcars.Domain.Properties.Settings.AliraqCarsConnectionString");

            //app.UseHangfireDashboard();
            app.UseHangfireServer();
        }
    }
}
