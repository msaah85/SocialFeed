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
                <div class="col-xs-12">
                    <div class="alert alert-info text-center">
                        Please select a large image and enter post message.
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
                        <label class="col-sm-3 control-label no-padding-right" for="message">Post <span class="text-danger">*</span></label>
                        <div class="col-sm-7">
                            <textarea cols="15" rows="6" id="message" name="message" class="required form-control autosize-transition autosize" required placeholder="Set post message..."></textarea>
                        </div>
                    </div>
                </div>
                <div class="col-xs-10">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="message">Post to:</label>
                        <div class="col-sm-7 socialActivePages"></div>
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
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ContentPlaceHolder2">
    <script src="/Scripts/sys/DataService.min.js"></script>
    <script src="/Scripts/sys/Common.min.js"></script>
    <script src="/Scripts/sys/jquery.xml2json.min.js"></script>
    <script src="/Scripts/sys/DefaultGridManager.min.js"></script>
    <script src="/Scripts/sys/utilities.min.js"></script>
    <script src="/Content/sys/assets/js/jquery.inputlimiter.1.3.1.min.js"></script>
    <script src="/Scripts/sys/addPost.js?v=1.6"></script>
</asp:Content>
