using IraqCars.Business.Business;
using System;

public partial class sys_Social_Posts : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            getSocialPagesNames();
    }

    void getSocialPagesNames()
    {
        var data = new Select().SelectLists("Settings_Social");

        if (data != null) // dataset
        {
            var dt = data.Tables[0]; // table inside
            if (dt != null)
            {
                // rows from the table
                var fbRow = dt.Select("Name = 'Facebook_PageID'");
                var instRow = dt.Select("Name = 'Instagram_UserID'");

                // bind page ids
                fbPage.Value = fbRow != null ? string.Format("{0}", fbRow[0]["Value"]) : "";
                InstaPage.Value = instRow != null ? string.Format("{0}", instRow[0]["Value"]) : "";
            }
        }
    }
}