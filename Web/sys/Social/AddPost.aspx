<%@ Page Title="Add Social Post" Language="C#" MasterPageFile="../master.master" AutoEventWireup="true" CodeFile="AddPost.aspx.cs" Inherits="sys_Social_Add" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        img.thumb-image {
            max-width: 200px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="breadcrumbs ace-save-state" id="breadcrumbs">
        <ul class="breadcrumb">
            <li>
                <i class="ace-icon fa fa-home home-icon"></i>
                <a href="home">Home</a>
            </li>
            <li class="active">Send Social Post</li>
        </ul>
    </div>
    <div class="page-content">
        <div class="page-header">
            <h1>Send Social Post</h1>
        </div>
        <div class="row">
            <form class="form-horizontal" role="form" id="masterForm">
                <div class="message"></div>
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
                            <div id="picture"></div>
                            <input type="file" id="image" name="image" required class="form-control" />
                        </div>
                    </div>
                </div>
                <div class="col-xs-10">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="link">Post to <span class="text-danger">*</span></label>
                        <div class="col-sm-7">
                            <div class="checkbox">
                                <label class="inline">
                                    <input type="checkbox" class="ace input-lg" checked />
                                    <span class="lbl bigger-120">Facebook</span>
                                </label>
                                <label class="inline">
                                    <input type="checkbox" class="ace input-lg" checked />
                                    <span class="lbl bigger-120">Twitter</span>
                                </label>
                                <label class="inline">
                                    <input type="checkbox" class="ace input-lg" checked />
                                    <span class="lbl bigger-120">Instagram</span>
                                </label>
                            </div>
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
    <script src="/Scripts/sys/DataService.js"></script>
    <script src="/Scripts/sys/Common.js"></script>
    <script src="/Scripts/sys/jquery.xml2json.min.js"></script>
    <script src="/Scripts/sys/DefaultGridManager.min.js"></script>
    <script src="/Scripts/sys/utilities.min.js"></script>
    <script src="/Content/sys/assets/js/autosize.min.js"></script>
    <script src="/Content/sys/assets/js/jquery.inputlimiter.1.3.1.min.js"></script>
    <script>
        // 

        var
            getImageName = function () {
                var nme = $('input[type=file]').eq(0).val().replace(/.*(\/|\\)/, '');
                return nme.split(".")[0];
            },
            uploadImage = function (imgStr) {
                var uRL = "/api/Upload/Save",
                    uploadCallBack = function (data) {
                        console.log(data);
                    },
                    data = { Name: imgStr };


                dataService.callAjax('POST', JSON.stringify(data), uRL,
                    uploadCallBack, commonManger.errorException);
            },
            potingToSocial = function () {
                var
                    img = $('#picture img'),
                    data = {
                        message: $('#message').val(),
                        image: img ? img.attr('src').split(',').pop() : '',
                    },
                    showMessage = function (typeID, message) {
                        var msg = "<div class='alert alert-" + (typeID > 1 ? "danger" : "success") + "'>" + message + "</div>";
                        $('.message').html(msg);
                    },
                    PostedSocialCallBack = function (d) {
                        showMessage(1, 'This post has been added to your social page.');
                    },
                    uRL = '/api/social/posttoall';


                console.log(data)
                // get data
                dataService.callAjax('POST', JSON.stringify(data), uRL,
                    PostedSocialCallBack, commonManger.errorException);
            };


        // events
        // start post to all pages
        $('#SendAll').click(function (e) {
            e.preventDefault();
            potingToSocial();

        });
        //
        $("#image").on('change', function () {

            //Get count of selected files
            var countFiles = $(this)[0].files.length,
                imgPath = $(this)[0].value,
                extn = imgPath.substring(imgPath.lastIndexOf('.') + 1).toLowerCase(),
                image_holder = $("#picture");

            image_holder.empty();

            if (extn == "gif" || extn == "png" || extn == "jpg" || extn == "jpeg") {
                if (typeof (FileReader) != "undefined") {
                    //loop for each file selected for uploaded.
                    for (var i = 0; i < countFiles; i++) {

                        var reader = new FileReader();
                        reader.onload = function (e) {
                            var base64String = e.target.result;
                            $("<img />", {
                                "src": base64String,
                                "class": "thumb-image"
                            }).appendTo(image_holder);
                            
                            // upload img to sever
                            //uploadImage(base64String);
                        }

                        image_holder.show();
                        reader.readAsDataURL($(this)[0].files[i]);
                    }
                } else {
                    alert("This browser does not support FileReader.");
                }
            } else {
                alert("Pls select only images");
            }
        });
    </script>
</asp:Content>
