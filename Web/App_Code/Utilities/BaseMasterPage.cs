using System;
using System.Globalization;
using System.Threading;
using System.Web.UI;


public class Base : Page
{
    protected override void InitializeCulture()
    {
        string lang = Request["lang"];
        
        if (string.IsNullOrEmpty(lang))
            lang = SessionManager.Current.Lang;
        
        Thread.CurrentThread.CurrentCulture = new CultureInfo(lang);
        Thread.CurrentThread.CurrentUICulture = CultureInfo.CreateSpecificCulture(lang);
    }


    protected override void OnLoadComplete(EventArgs e)
    {
        base.OnLoadComplete(e);


        if (!SessionManager.Current.Lang.Equals(Thread.CurrentThread.CurrentCulture.Name))
        {
            SessionManager.Current.Lang = Thread.CurrentThread.CurrentCulture.Name;
        }
    }
}