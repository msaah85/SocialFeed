using Facebook;
using Hangfire;
using InstaSharp;
using System;
using System.Dynamic;
using System.Security;
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
        public static string PostingToAll(SocialPostModel options)
        {
            // Fire-and-forget jobs are executed only once and almost immediately after creation.
            // facebook page
            string facebookJobId = "", instagramJobId = "";

            if (options.FacebookActive)
                facebookJobId = BackgroundJob.Enqueue(() => PostToFB(options.Message, options.ImageBase64, options.FacebookPostURL, options.FacebookToken, options.InstagramID));

            ////Delayed jobs are executed only once too, but not immediately, after a certain time interval.
            //// twitter page
            //var twitterJobId = BackgroundJob.Schedule(() => PostToTwitter(postMsg, link), TimeSpan.FromMinutes(1));

            //Continuations are executed when its parent job has been finished.
            // instagram page
            if (options.InstagramActive)
                instagramJobId = BackgroundJob.ContinueWith(facebookJobId, () => PostToInstagram(options.Message, options.ImageBase64, options.InstagramID, options.InstagramToken));

            return string.Format("{0}, {1}", facebookJobId, instagramJobId);
        }
        #endregion

        #region "Instagram"
        public static void PostToInstagram(string Message, string base64Image, string inst_page_id, string inst_pass)
        {
            var uploader = new InstagramUploader(inst_page_id, ConvertToSecureString(inst_pass));
            uploader.InvalidLoginEvent += InvalidLoginEvent;
            uploader.ErrorEvent += ErrorEvent;
            uploader.OnCompleteEvent += OnCompleteEvent;

            try
            {
                uploader.UploadBase64Image(base64Image, Message);
            }
            catch (Exception ex)
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
        public static void PostToTwitter(string Message, string Link, string tw_App_ConsumerKey, string tw_App_ConsumerSecret, string tw_accessToken, string tw_tokenSecret)
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
            { }
        }
        #endregion

        #region "Facebook"
        public static void PostToFB(string postMsg, string picture, string fb_post_url, string fb_token, string externalLink)
        {
            #region "Post to Fan Page"
            try
            {
                var client = new FacebookClient(fb_token);

                // fb post paramerters
                dynamic parameters = new ExpandoObject();
                parameters.caption = "Dar AlQimah Fashion";
                parameters.message = postMsg; // picture caption
                parameters.link = string.Format("https://www.instagr.am/{0}", externalLink);

                // we can add multiple image in one post
                parameters.source = new FacebookMediaObject
                {
                    ContentType = "image/jpeg",
                    FileName = Guid.NewGuid().ToString()
                }.SetValue(Convert.FromBase64String(picture));

                //parameters.source = new FacebookMediaObject
                //{
                //    ContentType = "image/jpeg",
                //    FileName = Path.GetFileName(picture)
                //}.SetValue(File.ReadAllBytes(HostingEnvironment.MapPath(picture))); // physical image path.

                dynamic result = client.Post(fb_post_url, parameters);

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