using System;

public partial class _Default : Base
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.RedirectPermanent("/sys/");

    }
}