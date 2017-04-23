using System.Threading;
using System.Web;

public class SessionManager
{
    private SessionManager()
    {
        ID = "0";
        IP = HttpContext.Current.Request.UserHostAddress;
        Lang = Thread.CurrentThread.CurrentCulture.Name;
    }

    public static SessionManager Current
    {
        get
        {
            if (HttpContext.Current != null)
            {
                var session = (SessionManager)HttpContext.Current.Session["_ShareSession_"];
                if (session == null)
                {
                    session = new SessionManager();
                    HttpContext.Current.Session["_ShareSession_"] = session;
                }
                return session;
            }
            else
            {
                var session = new SessionManager();
                HttpContext.Current.Session["_ShareSession_"] = session;
                return session;
            }
        }
    }

    public string ID { get; set; }
    public string Name { get; set; }
    public string Lang { get; set; }
    public string IP { get; set; }
}
