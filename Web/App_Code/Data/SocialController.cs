using System.Web.Http;
using Share.Social;

namespace Share.Social
{
    public class SocialController : ApiController
    {
        // POST url: api/Social/AddPost
        [HttpPost]
        public string PostFeed([FromBody]SocialPostModel value)
        {
            return SocialAutoPosting.PostingToAll(value);
        }
    }

    // Post model
    public class SocialPostModel
    {
        public bool FacebookActive { get; set; }
        public string FacebookPostURL { get; set; }
        public string FacebookToken { get; set; }
        public string ImageBase64 { get; set; }
        public bool InstagramActive { get; set; }
        public string InstagramID { get; set; }  // ID
        public string InstagramToken { get; set; } // Password
        public string Message { get; set; }
    }
}