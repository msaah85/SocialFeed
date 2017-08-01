using Share.Business;
using Minutesuae.SystemUtilities;
using System;
using System.Web.Services;
using System.Web.UI;

public partial class sys_Default : Page
{
    void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Session.Abandon();
            CookiesManager.ResetCookie();
        }
    }

    [WebMethod]
    public static bool login(string text1, string text2)
    {
        bool login_state = false;

        string _pass = EncryptDecryptString.Encrypt(text2, "Taj$$Key");

        // create filter paramters
        string[,] _params = { { "UserName", text1 }, { "Password", _pass } };

        // get all of data.
        var _ds = new Select().SelectLists("Users_Login", _params);
        var dt = _ds.Tables[0];
        
        if (dt.Rows.Count > 0)
        {
            SessionManager.Current.ID = string.Format("{0}", dt.Rows[0][0]);
            SessionManager.Current.Name = string.Format("{0}", dt.Rows[0][1]);
            //SessionManager.Current.Lang = string.Format("{0}", dt.Rows[0][2]);

            CookiesManager.SaveCoockie();

            login_state = true;
        }

        return login_state;
    }    
}