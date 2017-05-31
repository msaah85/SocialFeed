using IraqCars.Business.Business;
using Share.SMS;
using System.Web.Http;
using System.Xml;

public class SMSController : ApiController
{
    [ActionName("SMSToGroup")]
    public object PostBulkSMS(SMSMessage message)
    {
        // send sms message
        var res = SMSManager.SMSXml(message);


        // save to db
        var resultXML = new XmlDocument();
        resultXML.LoadXml(res.Result);
        
        string msgStatus = resultXML.SelectSingleNode("Response/Status").InnerText,
            msgID = resultXML.SelectSingleNode("Response/msgid").InnerText;

        // check the sms has been sent.
        if (!msgStatus.Equals("error") && !string.IsNullOrEmpty(msgID))
        {
            string[] names = { "SMSID", "Message", "Numbers", "Sent", "NumbersCount", "MsgID" },
                values = { "0", message.Message, message.MobileNo, "1", string.Format("{0}", message.MobileNo.Split(',').Length), msgID };

            var saved = new Save().SaveRow("SMS_Save", names, values);
        }


        return res.Result;
    }
}
