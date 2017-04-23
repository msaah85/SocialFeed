using Facebook;
using Hangfire;
using InstaSharp;
using System;
using System.Dynamic;
using System.IO;
using System.Security;
using System.Web.Hosting;
using TweetSharp;

namespace Share.Social
{
    /// <summary>
    /// Summary description for SocialAutoPosting
    /// </summary>
    public static class SocialAutoPosting
    {
        #region "Post to Social"

        // options
        // long live page token from: https://developers.facebook.com/tools/explorer/
        // fb.com/DarAlQimaFashion
        static string fb_page_access_token = "EAAS1raXmcQsBANW9UZAdTa5FGQGf3miklbPutZAR24RTQ3dfECRoLSN9AbQCXYqyQhGt5YlEOEXcecMcKu1P7Nn1cOZA4vRHoZAZCfZCvbngM0op85NzI55ZCZCdDSvCqiIQtivrl4ZCBbeqWDZAw19fV894P5pMVZBeVQZD",
                      fb_page_url = "/DarAlQimaFashion/feed",
                      // instagram
                      inst_page_id = "daralqimafashionuae",
                      inst_pass = "Firas*1972",
                      // twitter
                      tw_App_ConsumerKey = "2YAJa38FdK8Rr9IQQO9HTSURB",
                      tw_App_ConsumerSecret = "KsFxwgVKPz2fcVGG9GqP7Uc8H4UP01txQoqDhG6IVrlHFaPxCN",
                      tw_accessToken = "3625117704-WhjSMI6BKywqTGLv8U34HW2qcEetHqQcspglcxT",
                      tw_tokenSecret = "wNcZjPnkMcBC6xxpRbHtwL0drNW7BxEGldu5jirmzlMH5";


        public static string PostingToAll(string postMsg, string picture)
        {
            // Fire-and-forget jobs are executed only once and almost immediately after creation.
            // facebook page
            var facebookJobId = BackgroundJob.Enqueue(() => PostToFB(postMsg, picture));


            ////Delayed jobs are executed only once too, but not immediately, after a certain time interval.
            //// twitter page
            //var twitterJobId = BackgroundJob.Schedule(() => PostToTwitter(postMsg, link), TimeSpan.FromMinutes(1));


            //Continuations are executed when its parent job has been finished.
            // instagram page
            var instagramJobId = BackgroundJob.ContinueWith(facebookJobId, () => PostToInstagram(postMsg, picture));


            return string.Format("{0},{1}", facebookJobId, instagramJobId);
        }

        #endregion

        #region "Instagram"
        public static void PostToInstagram(string Message, string PhotoUrl)
        {
            var uploader = new InstagramUploader(inst_page_id, ConvertToSecureString(inst_pass));
            uploader.InvalidLoginEvent += InvalidLoginEvent;
            uploader.ErrorEvent += ErrorEvent;
            uploader.OnCompleteEvent += OnCompleteEvent;

            try
            {
                // System.Web.HttpContext.Current.Server.MapPath
                // System.AppDomain.CurrentDomain.BaseDirectory
                string postImgaePath = HostingEnvironment.MapPath("~/public/images/65d77318-a2d8-42e5-bf81-9be1a51cf7ca.jpg");
                //string postTitle = Message + "\r\n" + Link;

                uploader.UploadImage(postImgaePath, Message);
            }
            catch (Exception ex)
            {
                //error to log file
            }
        }

        // Instagram utilities
        static SecureString ConvertToSecureString(string strPassword)
        {
            var secureStr = new SecureString();
            if (strPassword.Length > 0)
            {
                foreach (var c in strPassword.ToCharArray()) secureStr.AppendChar(c);
            }
            return secureStr;
        }

        static void OnCompleteEvent(object sender, EventArgs e)
        {
            // success
        }

        static void ErrorEvent(object sender, EventArgs e)
        {
            // error to log file
        }

        static void InvalidLoginEvent(object sender, EventArgs e)
        {
            // error to log file
        }
        #endregion

        #region Twitter
        public static void PostToTwitter(string Message, string Link)
        {
            try
            {
                var twitterApp = new TwitterService(tw_App_ConsumerKey, tw_App_ConsumerSecret);
                twitterApp.AuthenticateWith(tw_accessToken, tw_tokenSecret);
                string msg = string.Format("{0}\r\n{1}", Message, Link);


                var twitterStatus = twitterApp.SendTweet(new SendTweetOptions { Status = msg });
                var responseText = twitterApp.Response.Response;

                // success
            }
            catch
            {
                // error to log file.
            }
        }
        #endregion

        #region "Facebook"
        public static void PostToFB(string postMsg, string picture)
        {
            #region "Post to Fan Page"
            try
            {
                var client = new FacebookClient(fb_page_access_token);


                // fb post paramerters
                dynamic parameters = new ExpandoObject();
                parameters.subject = postMsg;
                parameters.message = "Dar AlQima Fashion"; // picture caption
                parameters.source = new FacebookMediaObject
                {
                    ContentType = "image/jpeg",
                    FileName = Path.GetFileName(picture)
                }.SetValue(Convert.FromBase64String(picture));

                //parameters.source = new FacebookMediaObject
                //{
                //    ContentType = "image/jpeg",
                //    FileName = Path.GetFileName(picture)
                //}.SetValue(File.ReadAllBytes(HostingEnvironment.MapPath(picture))); // physical image path.


                dynamic result = client.Post(fb_page_url, parameters);


                // success message by post id
                //client.Delete(result.id);
            }
            catch (FacebookOAuthException ex)
            {
                // ex1 call log file
            }
            catch (FacebookApiException ex)
            {
                //ex2 call log file
            }

            #endregion
        }
        #endregion
    }
}