<%@ Page Title="Add Social Post" Language="C#" MasterPageFile="~/sys/master.master" AutoEventWireup="true" CodeFile="AddPost.aspx.cs" Inherits="sys_Social_Add" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="breadcrumbs ace-save-state" id="breadcrumbs">
        <ul class="breadcrumb">
            <li>
                <i class="ace-icon fa fa-home home-icon"></i>
                <a href="home">Home</a>
            </li>
            <li class="active">Send SMS</li>
        </ul>
    </div>
    <div class="page-content">
        <div class="page-header">
            <h1>Send SMS</h1>
        </div>
        <div class="row">
            <form class="form-horizontal" role="form" id="masterForm">
                <div class="message"></div>
                <div class="col-xs-10">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="title">Title <span class="text-danger">*</span></label>
                        <div class="col-sm-7">
                            <input type="text" name="title" id="title" class="required form-control" required placeholder="Title" />
                        </div>
                    </div>
                </div>
                <div class="col-xs-10">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="message">Message <span class="text-danger">*</span></label>
                        <div class="col-sm-7">
                            <textarea cols="15" rows="3" id="message" name="message" class="required form-control autosize" required placeholder="Message..."></textarea>
                        </div>
                    </div>
                </div>
                <div class="col-xs-10">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="image">Image <span class="text-danger">*</span></label>
                        <div class="col-sm-7">
                            <input type="file" id="image" name="image" required class="form-control" />
                        </div>
                    </div>
                </div>
                <div class="col-xs-10">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="caption">Caption</label>
                        <div class="col-sm-7">
                            <input type="text" name="caption" id="caption" class="required form-control" required placeholder="Caption" />
                        </div>
                    </div>
                </div>
                <div class="col-xs-10">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="link">Link <span class="text-danger">*</span></label>
                        <div class="col-sm-7">
                            <input type="text" name="link" id="link" class="required form-control" required placeholder="URL" />
                        </div>
                    </div>
                </div>
                <div class="col-xs-10">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="link">To <span class="text-danger">*</span></label>
                        <div class="col-sm-7">
                            

                        </div>
                    </div>
                </div>
                <div class="col-xs-10">
                    <div class="form-group">
                        <div class="col-sm-3"></div>
                        <div class="col-sm-7">
                            <button class="btn btn-app btn-success" id="SendAll" type="submit">
                                <span class="ace-icon glyphicon glyphicon-share"></span>
                                Send
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
        <hr class="hr-10" />
    </div>
    <script src="/Scripts/sys/jquery.xml2json.min.js"></script>
    <script src="/Scripts/sys/DefaultGridManager.min.js"></script>
    <script src="/Scripts/sys/utilities.min.js"></script>
    <script src="/Content/sys/assets/js/autosize.min.js"></script>
    <script src="/Content/sys/assets/js/jquery.inputlimiter.1.3.1.min.js"></script>
    <script>
        var potingToSocial = function () {
            var
                data = {
                    title: $('#name').val(),
                    message: $('#message').val(),
                    url: $('#link').val(),
                    image: $('#picture').val(),
                },
                showMessage = function (typeID, message) {
                    var msg = "<div class='alert alert-" + (typeID > 1 ? "danger" : "success") + "'>" + message + "</div>";
                    $('.message').html(msg);
                },
                PostedSocialCallBack = function (d) {
                    showMessage(1, 'تم نشر الصورة على صفحات الشركة على فيس بوك - تويتر - انستجرام.');
                };


            dataService.callAjax('Post', JSON.stringify(data), '/api/social.aspx/postToAll',
                PostedSocialCallBack, commonManger.errorException);
        };


        // start post to all pages
        $('.btnSocial').click(function (e) {
            e.preventDefault();
            potingToSocial();

        });
    </script>
</asp:Content>
