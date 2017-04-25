using System;
using System.IO;
using System.Drawing;
using System.Web.Hosting;
using System.Web.Http;
using System.Drawing.Imaging;

public class UploadController : ApiController
{
    // upload image to server.
    [ActionName("Save")]
    public void PostImage([FromBody]uploadModel value)
    {
        //string base64String = value;

        // Convert Base64 String to byte[]
        byte[] imageBytes = Convert.FromBase64String(value.Name);
        var ms = new MemoryStream(imageBytes, 0, imageBytes.Length);

        // Convert byte[] to Image
        ms.Write(imageBytes, 0, imageBytes.Length);
        var image = Image.FromStream(ms, true);


        string newFile = string.Format("{0}.jpg", Guid.NewGuid()),
               filePath = Path.Combine(HostingEnvironment.MapPath("~/Public/images/"), newFile);


        try
        {
            image.Save(filePath, ImageFormat.Jpeg);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
}

public class uploadModel
{
    public string Name { get; set; }
}