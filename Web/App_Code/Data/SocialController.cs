using System.Web.Http;
using Share.Social;

public class SocialController : ApiController
{
    // POST url: api/Social/PostToAll
    //[ActionName("AddPost")]
    public string PostToAll([FromBody]SocialPostModel post)
    {
        return SocialAutoPosting.PostingToAll(post);
    }
}

// post model
public class SocialPostModel
{
    public string Message { get; set; }
    public string ImageBase64 { get; set; }
    public bool FacebookActive { get; set; }
    public bool InstagramActive { get; set; }
    public string FacebookPostURL { get; set; }
    public string FacebookToken { get; set; }
    public string InstagramID { get; set; }    // ID
    public string InstagramToken { get; set; } // Password
}
