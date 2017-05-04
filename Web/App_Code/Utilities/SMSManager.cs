
using System.Collections;
using System.IO;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace Share.SMS
{
    public static class SMSManager
    {
        #region sync code
        //// Send SMS message throgh Mobishaster API.
        //public static string SMSSend(string mobileNo, string message)
        //{
        //    mobileNo = InhanceMobileNo(mobileNo);
        //    string baseurl = string.Format("http://mshastra.com/sendurlcomma.aspx?user=20078016&pwd=2pnpr4&senderid=ALIRAQCARS&mobileno={0}&msgtext={1}&priority=High&CountryCode=ALL", mobileNo, message), sentMessage = "";
        //    using (WebClient client = new WebClient())
        //    {
        //        using (Stream data = client.OpenRead(baseurl))
        //        {
        //            using (StreamReader reader = new StreamReader(data))
        //            {
        //                sentMessage = reader.ReadToEnd();
        //                reader.Close();
        //            }
        //            data.Close();
        //        }
        //    }
        //    return sentMessage;
        //}
        #endregion

        public static async Task<string> SMSSend(string mobileNo, string message, int unicode = 0)
        {
            //mobileNo = InhanceMobileNo(mobileNo);

            #region "sending api"

            /*Profileid = You will get a unique profile id once your account is logged in. It will be a 8 character numeric id (200XXXXX).
             password = Password will be the part of credentials provided to you. You can change them innumerable times
             ABC = This will be the approved Sender ID from the operator. User can have 
             multiple approved Sender IDs & can use any of them. In case, the sender ID 
             doesn’t match with the approved ones, SMS will go from the default ID
             mobileno = The UAE mobile no. to which user wants to send SMS. They can be 
             in any format (+9715XX, 9715XX, 05XX, 5XX). Only numbers are allowed. 
             System will automatically reject less than 9 digit & nos. not starting with 5.
             Hello = The SMS content. 160 English characters counted as 1 SMS. 70
             Unicode characters counted as 1 SMS. If SMS length is more than 1 SMS 
             than the SMS counts are in multiple of 153 in case of English & 63 in case of Unicode.
             */


            string baseurl = string.Format("http://smartcall.ae/httpv2/SubmitHTTP.aspx?MessageText={1}&MobileNumber={0}&UserId=shop4arab@smartcall.ae&Password=s4a01&unicode={2}", mobileNo, message, unicode),
                sentMessage = "";

            #endregion

            using (WebClient client = new WebClient())
            {
                using (Stream data = client.OpenRead(baseurl))
                {
                    using (StreamReader reader = new StreamReader(data))
                    {
                        sentMessage = await reader.ReadToEndAsync();
                        reader.Close();
                    }
                    data.Close();
                }
            }
            return sentMessage;
        }

        /// <summary>
        /// Send SMS to multiple  mobile number using smartcall.ae web API.
        /// using xml parameters
        /// </summary>
        /// <param name="mobileNo"></param>
        /// <param name="message"></param>
        /// <param name="unicode"></param>
        /// <returns></returns>
        public static async Task<string> SMSXml(string mobileNo, string message, int unicode = 0)
        {

            string url = "http://www.smartcall.ae/ClientAPIV3/submitXML.aspx";
            var xmlData = new StringBuilder("<?xml version='1.0' encoding='utf-8' ?>");

            xmlData.Append("<SMS>");
            xmlData.Append("<MobileNumber>" + mobileNo + "</MobileNumber>");
            xmlData.Append("<Message>" + message + "</Message>");
            xmlData.Append("<Unicode>" + unicode + "</Unicode>");
            xmlData.Append("<CampaignID>0</CampaignID>");
            xmlData.Append("<UserID>shop4arab@smartcall.ae</UserID>");
            xmlData.Append("<Pwd>s4a01</Pwd>");
            xmlData.Append("</SMS>");


            var request = (HttpWebRequest)WebRequest.Create(url);
            byte[] bytes = Encoding.UTF8.GetBytes(xmlData.ToString());

            request.ContentType = "text/xml; encoding='utf-8'";
            request.ContentLength = bytes.Length;
            request.Method = "POST";

            Stream requestStream = request.GetRequestStream();
            requestStream.Write(bytes, 0, bytes.Length);
            requestStream.Close();

            using (var response = (HttpWebResponse)request.GetResponse())
            {
                if (response.StatusCode == HttpStatusCode.OK)
                {
                    Stream responseStream = response.GetResponseStream();
                    string responseStr = await new StreamReader(responseStream).ReadToEndAsync();
                    return responseStr;
                }
            }

            return null;
        }

        // remove every starting 00 in (00971xxxxxx) would be (971xxxxxx).        
        static string InhanceMobileNo(string no)
        {
            var nombs = no.Split(',');
            var list = new ArrayList();

            foreach (var n in nombs)
            {
                if (n.StartsWith("00"))
                    list.Add(n.Substring(2));
                else if (n.StartsWith("+"))
                    list.Add(n.Substring(1));
            }

            return string.Join(",", list.ToArray());
        }
    }
}