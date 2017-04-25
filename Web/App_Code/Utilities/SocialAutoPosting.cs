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
        static string fb_page_access_token = "EAAS1raXmcQsBAFSV3iGQd1biGRu4NvT9g7gmWkeETVAewfQrADhp0OVu3UwOn18RZAQyZAoFUMG5EUBsXCZBnd9IFR7k04AmpnJ4wsCn0gtTEILGvplmLZCvbGenSAa9xFYWT5j7Uj31kXZAPzXYo3zQmJLGnvTTjqJ0yad3njAZDZD",
                      fb_page_url = "/DarAlQimaFashion/photos", // Page ID: 1395835067129431 
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
            var facebookJobId = BackgroundJob.Enqueue(() => PostToFB(postMsg, picture)); // 


            ////Delayed jobs are executed only once too, but not immediately, after a certain time interval.
            //// twitter page
            //var twitterJobId = BackgroundJob.Schedule(() => PostToTwitter(postMsg, link), TimeSpan.FromMinutes(1));


            //Continuations are executed when its parent job has been finished.
            // instagram page
            var instagramJobId = BackgroundJob.ContinueWith(facebookJobId, () => PostToInstagram(postMsg, picture));


            return string.Format("{0}, {1}", facebookJobId, instagramJobId);
        }

        #endregion

        #region "Instagram"
        public static void PostToInstagram(string Message, string base64Image)
        {
            var uploader = new InstagramUploader(inst_page_id, ConvertToSecureString(inst_pass));
            uploader.InvalidLoginEvent += InvalidLoginEvent;
            uploader.ErrorEvent += ErrorEvent;
            uploader.OnCompleteEvent += OnCompleteEvent;

            try
            {
                uploader.UploadBase64Image(base64Image, Message);
            }
            catch(Exception ex)
            {

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
                parameters.caption = "Dar AlQima Fashion";
                parameters.message = postMsg; // picture caption
                parameters.link = "https://www.instagr.am/daralqimafashionuae";

                // we can add multiple image in one post
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