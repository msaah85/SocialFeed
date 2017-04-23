using System.Web.Http;
using Share.Social;

public class SocialController : ApiController
{
    // POST url: api/Social/PostToAll
    //[ActionName("AddPost")]
    public string PostToAll([FromBody]SocialPostModel post)
    {
        return SocialAutoPosting.PostingToAll(post.message, post.image);
    }
}

// post model
public class SocialPostModel
{
    public string message { get; set; }
    public string image { get; set; }
}
