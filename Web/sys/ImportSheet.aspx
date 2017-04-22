<%@ Page Title="Upload Excel" Language="C#" MasterPageFile="master.master" AutoEventWireup="true" CodeFile="ImportSheet.aspx.cs" Inherits="sys_ImportSheet" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="breadcrumbs ace-save-state" id="breadcrumbs">
        <ul class="breadcrumb">
            <li>
                <i class="ace-icon fa fa-home home-icon"></i>
                <a href="home">Home</a>
            </li>
            <li class="active">Upload Excel Sheet</li>
        </ul>
    </div>
    <div class="page-content">
        <div class="page-header">
            <h1>Import contacts from Excel sheet</h1>
        </div>
        <div class="row">
            <form class="form-horizontal" role="form" id="masterForm" runat="server">
                <div class="row">
                    <div class="col-xs-12">
                        <asp:Literal ID="doneMessage" runat="server"></asp:Literal>
                    </div>
                </div>
                <div class="row">
                    <div class="col-xs-10">
                        <div class="form-group">
                            <label class="col-sm-3 control-label no-padding-right" for="CityID">Select (*.xlsx) file <span class="text-danger">*</span></label>
                            <div class="col-sm-5">
                                <asp:FileUpload ID="Upload" runat="server" />
                            </div>
                            <div class="col-sm-3">
                                <asp:LinkButton CssClass="btn btn-sm btn-info" ID="btnImport" runat="server"><i class="fa fa-upload"></i> Upload</asp:LinkButton>
                                <a href="SendSMS.aspx" class="btn btn-sm btn-success">Send SMS <i class="fa fa-arrow-circle-right"></i></a>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <script>
        jQuery(function ($) {
            $('input[type="file"]').ace_file_input({
                no_file: 'No File ...',
                btn_choose: 'Choose',
                btn_change: 'Change',
                droppable: false,
                onchange: null,
                thumbnail: 'large' //| true | large
                , whitelist: 'xls|xlsx|csv|xlsb'
                , blacklist: 'exe|php|asp|aspx|jpg|png'
                , before_change: function (file, dropped) {
                    // validate the selected file type as excel
                    if (file[0]) {
                        var ext = file[0].name.split('.').pop().toLowerCase();
                        if ($.inArray(ext, ['xlsx']) == -1) {
                            alert('Invalid extension!, please select excel file');
                            removeSelectedFile();
                            return false;
                        }
                        // validate file size
                        if (file[0].size > 10000000) { // 10 MB
                            alert('Large size!, a maximum size of excel file 10 MB.');
                            removeSelectedFile();
                            return false;
                        }
                    }
                    return true;
                }
            });
        });</script>
</asp:Content>

