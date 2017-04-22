
using Share.SMS;
using System.Collections.Generic;
using System.Web.Http;

public class SMSController : ApiController
{
    public object SendSMS(string phones, string message)
    {
        var task = SMSManager.SMSSend(phones, message);
        return task;
    }

    public object BulkSMS(string[] nums, string msg, int enAr)
    {
        // collect all sending reports    
        var isSent = new List<string>();


        // loop all messages
        for (int i = 0; i < nums.Length; i++)
        {
            // split mobile and client name
            string[] num = nums[i].Split('|');

            // start sending the message to one or more mobile number
            //                                     phone   message
            var sent = SMSManager.SMSSend(num[0], msg, enAr);


            // register sending report for every sms/client name.
            isSent.Add(sent.Result + "|" + num[1]);
        }


        // return all reports
        return isSent;
    }

    public object BulkSMS3(string nums, string msg, int enAr)
    {
        // start sending the message to one or more mobile number
        //                                    phone numbers  message  Unicode
        var sent = SMSManager.SMSXml(nums, msg, enAr);


        // return all reports
        return sent;
    }
}
