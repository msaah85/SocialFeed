<%@ Page Title="Posts" Language="C#" MasterPageFile="../master.master" AutoEventWireup="true" CodeFile="Posts.aspx.cs" Inherits="sys_Social_Posts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <form runat="server" id="pagesIds">
        <asp:HiddenField runat="server" ID="InstaPage" Value="" />
        <asp:HiddenField runat="server" ID="fbPage" Value="" />
    </form>
    <div class="breadcrumbs ace-save-state" id="breadcrumbs">
        <ul class="breadcrumb">
            <li>
                <i class="ace-icon fa fa-home home-icon"></i>
                <a href="home">Home</a>
            </li>
            <li class="active">Posts</li>
        </ul>
    </div>
    <div class="page-content">
        <div class="page-header">
            <h1>Posts</h1>
        </div>
        <div class="row">
            <div class="col-md-6 col-xs-12">
                <h2><i class="fa fa-instagram"></i>
                    Instagram</h2>
                <iframe class="instagram-media instagram-media-rendered" id="instagram-embed-0"
                    src="https://elfsight.com/wp-content/themes/elfsight/instalink/includes/instalink.php?username=<%:InstaPage.Value %>&hashtag=&lang=en&show_heading=true&scroll=true&image_size=xlarge&width=500px&responsive=false&height=600px&bg_color=%23595359&content_bg_color=%23F8F8F8&font_color=%23FFFFFF&ban=&cache_media_time=0"
                    allowtransparency="true" frameborder="0" width="100%" height="700" data-instgrm-payload-id="instagram-media-payload-0"
                    scrolling="no"></iframe>
            </div>
            <div class="col-md-6 col-xs-12">
                <h2><i class="fa fa-facebook-square"></i>
                    Facebook</h2>
                <div class="fb-page" data-href="https://www.facebook.com/<%:fbPage.Value %>/" data-tabs="timeline" data-width="600" data-height="600" data-small-header="true" data-adapt-container-width="true" data-hide-cover="false" data-show-facepile="false">
                    <blockquote cite="https://www.facebook.com/<%:fbPage.Value %>/" class="fb-xfbml-parse-ignore"><a href="https://www.facebook.com/<%:fbPage.Value %>/"><i class="fa fa-facebook-f"></i>‎</a></blockquote>
                </div>
                <div id="fb-root"></div>
                <script src="/scripts/fb.min.js"></script>
            </div>
        </div>
    </div>
</asp:Content>