<%@ Page Title="Add Social Post" Language="C#" MasterPageFile="../master.master" AutoEventWireup="true" CodeFile="AddPost.aspx.cs" Inherits="sys_Social_Add" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/cropper/2.3.4/cropper.min.css" rel="stylesheet" />
    <link href="/Scripts/cropper/main.min.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cropper/2.3.4/cropper.min.js"></script>
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
                        Please select your photo, crop the selected area, add post message and press send button.
                    </div>
                </div>
                <div class="col-xs-10">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right cls-select" for="inputImage">Select photo <span class="text-danger">*</span></label>
                        <div class="col-sm-7">
                            <div class="img-container">
                                <img id="image2" src="5.jpg" />
                            </div>
                            <div class="row">
                                <div class="col-md-12 docs-buttons text-center">
                                    <label class="btn btn-danger btn-upload" for="inputImage" title="Upload image file">
                                        <input type="file" class="sr-only" id="inputImage" name="file" accept=".jpg,.jpeg,.png,.gif,.bmp,.tiff" />
                                        <span class="docs-tooltip" data-toggle="tooltip" data-animation="false" title="" data-original-title="Import photo">Select photo <span class="fa fa-upload"></span>
                                        </span>
                                    </label>
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-primary" data-method="setDragMode" data-option="move" title="Move">
                                            <span class="docs-tooltip" data-toggle="tooltip" data-animation="false" title="" data-original-title="Move">
                                                <span class="fa fa-arrows"></span>
                                            </span>
                                        </button>
                                        <button type="button" class="btn btn-primary" data-method="setDragMode" data-option="crop" title="Crop">
                                            <span class="docs-tooltip" data-toggle="tooltip" data-animation="false" title="" data-original-title="Crop by mouse">
                                                <span class="fa fa-crop"></span>
                                            </span>
                                        </button>
                                    </div>
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-primary" data-method="zoom" data-option="0.1" title="Zoom In">
                                            <span class="docs-tooltip" data-toggle="tooltip" data-animation="false" title="" data-original-title="Zoom In">
                                                <span class="fa fa-search-plus"></span>
                                            </span>
                                        </button>
                                        <button type="button" class="btn btn-primary" data-method="zoom" data-option="-0.1" title="Zoom Out">
                                            <span class="docs-tooltip" data-toggle="tooltip" data-animation="false" title="" data-original-title="Zoom Out">
                                                <span class="fa fa-search-minus"></span>
                                            </span>
                                        </button>
                                        <button type="button" class="btn btn-primary" data-method="zoomTo" data-option="1">
                                            <span class="docs-tooltip" data-toggle="tooltip" data-animation="false" title="" data-original-title="Zoom To"><i class="fa fa-arrows-alt"></i>
                                            </span>
                                        </button>
                                    </div>
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-primary" data-method="move" data-option="-10" data-second-option="0" title="Move Left">
                                            <span class="docs-tooltip" data-toggle="tooltip" data-animation="false" title="" data-original-title="Move Left">
                                                <span class="fa fa-arrow-left"></span>
                                            </span>
                                        </button>
                                        <button type="button" class="btn btn-primary" data-method="move" data-option="10" data-second-option="0" title="Move Right">
                                            <span class="docs-tooltip" data-toggle="tooltip" data-animation="false" title="" data-original-title="Move Right">
                                                <span class="fa fa-arrow-right"></span>
                                            </span>
                                        </button>
                                        <button type="button" class="btn btn-primary" data-method="move" data-option="0" data-second-option="-10" title="Move Up">
                                            <span class="docs-tooltip" data-toggle="tooltip" data-animation="false" title="" data-original-title="Move Up">
                                                <span class="fa fa-arrow-up"></span>
                                            </span>
                                        </button>
                                        <button type="button" class="btn btn-primary" data-method="move" data-option="0" data-second-option="10" title="Move Down">
                                            <span class="docs-tooltip" data-toggle="tooltip" data-animation="false" title="" data-original-title="Move Down">
                                                <span class="fa fa-arrow-down"></span>
                                            </span>
                                        </button>
                                    </div>
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-primary" data-method="rotate" data-option="-45" title="Rotate Left">
                                            <span class="docs-tooltip" data-toggle="tooltip" data-animation="false" title="" data-original-title="Rotate Left">
                                                <span class="fa fa-rotate-left"></span>
                                            </span>
                                        </button>
                                        <button type="button" class="btn btn-primary" data-method="rotate" data-option="45" title="Rotate Right">
                                            <span class="docs-tooltip" data-toggle="tooltip" data-animation="false" title="" data-original-title="Rotate Right">
                                                <span class="fa fa-rotate-right"></span>
                                            </span>
                                        </button>
                                    </div>
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-primary" data-method="scaleX" data-option="-1" title="Flip Horizontal">
                                            <span class="docs-tooltip" data-toggle="tooltip" data-animation="false" title="" data-original-title="Flip Horizontal">
                                                <span class="fa fa-arrows-h"></span>
                                            </span>
                                        </button>
                                        <button type="button" class="btn btn-primary" data-method="scaleY" data-option="-1" title="Flip Vertical">
                                            <span class="docs-tooltip" data-toggle="tooltip" data-animation="false" title="" data-original-title="Flip Vertical">
                                                <span class="fa fa-arrows-v"></span>
                                            </span>
                                        </button>
                                    </div>
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-primary" data-method="crop" title="Crop">
                                            <span class="docs-tooltip" data-toggle="tooltip" data-animation="false" title="" data-original-title="Start cropt">
                                                <span class="fa fa-check"></span>
                                            </span>
                                        </button>
                                        <button type="button" class="btn btn-primary" data-method="clear" title="Clear">
                                            <span class="docs-tooltip" data-toggle="tooltip" data-animation="false" title="" data-original-title="Remove photo crop area">
                                                <span class="fa fa-remove"></span>
                                            </span>
                                        </button>
                                        <button type="button" class="btn btn-primary" data-method="reset" title="Reset">
                                            <span class="docs-tooltip" data-toggle="tooltip" data-animation="false" title="" data-original-title="Reset crop">
                                                <span class="fa fa-refresh"></span>
                                            </span>
                                        </button>
                                    </div>
                                    <button type="button" class="btn btn-success" data-method="getCroppedCanvas">
                                        <span class="docs-tooltip" data-toggle="tooltip" data-animation="false" title="" data-original-title="Crop photo to post">Crop photo <i class="fa fa-download"></i>
                                        </span>
                                    </button>
                                    <div class="result-img"></div>
                                </div>
                                <!-- /.docs-buttons -->
                            </div>
                            <!-- /.docs-toggles -->
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
                            <button class="btn btn-app btn-success hidden" id="SendAll" type="submit">
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
    <script src="/Scripts/sys/addPost.min.js?v=2.0"></script>
    <script src="/Scripts/cropper/main.min.js"></script>
</asp:Content>
