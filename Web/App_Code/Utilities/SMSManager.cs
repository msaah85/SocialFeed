
using System;
using System.IO;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace Share.SMS
{
    public static class SMSManager
    {
        /// <summary>
        /// Send SMS to multiple  mobile number using smartcall.ae web API.
        /// using xml parameters
        /// </summary>
        /// <param name="msg">SMSMessage</param>
        /// <returns>XML object</returns>
        public static async Task<string> SMSXml(SMSMessage msg)
        {
            string url = "http://www.smartsmsgateway.com/api/api_xml.php";
            var xmlData = new StringBuilder("<?xml version='1.0' encoding='utf-8' ?>");
            xmlData.Append($@"<message>
                <to>{msg.MobileNo}</to>
                <text>{msg.Message}</text>
                <type>{(msg.Unicode == 0 ? "text" : "unicode")}</type>
                <datetime>{DateTime.Now}</datetime>
                <username>{msg.UserID}</username>
                <password>{msg.Password}</password>
                <senderid>{msg.SenderID}</senderid>
            </message>");


            var request = (HttpWebRequest)WebRequest.Create(url);
            byte[] bytes = Encoding.UTF8.GetBytes(xmlData.ToString());

            request.ContentType = "text/xml; encoding='utf-8'";
            request.ContentLength = bytes.Length;
            request.Method = "POST";

            var requestStream = request.GetRequestStream();
            requestStream.Write(bytes, 0, bytes.Length);
            requestStream.Close();

            using (var response = (HttpWebResponse)request.GetResponse())
            {
                if (response.StatusCode == HttpStatusCode.OK)
                {
                    Stream responseStream = response.GetResponseStream();
                    var result = await new StreamReader(responseStream).ReadToEndAsync();
                    return result;
                }

                return null;
            }
        }
    }

    public class SMSMessage
    {
        public string MobileNo { get; set; }
        public string Message { get; set; }
        public string UserID { get; set; }
        public string Password { get; set; }
        public string SenderID { get; set; }
        public int Unicode { get; set; } = 0; // default value 0
    }
}