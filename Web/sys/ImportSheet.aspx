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
            <div class="col-xs-12">
                <form class="form-horizontal" role="form" id="masterForm" runat="server">
                    <div class="row">
                        <div class="col-xs-12">
                            <asp:Literal ID="doneMessage" runat="server"></asp:Literal>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="form-group">
                                <label class="col-sm-3 control-label no-padding-right" for="CityID">Select Excel (*.xlsx) file <span class="text-danger">*</span></label>
                                <div class="col-sm-5">
                                    <asp:FileUpload ID="Upload" runat="server" required />
                                    <asp:RequiredFieldValidator CssClass="red" runat="server" ControlToValidate="Upload" ValidationGroup="s">Please select excel file.</asp:RequiredFieldValidator>
                                </div>
                                <div class="col-sm-3">
                                    <asp:LinkButton CssClass="btn btn-sm btn-info" ID="btnImport" ValidationGroup="s" runat="server"><i class="fa fa-upload"></i> Upload</asp:LinkButton>
                                    <a role="button" data-rel="tooltip" title="Send SMS" href="SendSMS.aspx" class="btn btn-white btn-success btn-bold"><i class="fa fa-send"></i></a>
                                    <a role="button" data-rel="tooltip" class="btn btn-white btn-primary btn-bold" href="Clients.aspx"
                                        tabindex="0" title="Add contact"><i class="fa fa-plus bigger-110"></i></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12">
                <div class="alert alert-info">
                    <strong>Excel format:</strong>
                    Please import excel sheet with header format:
                    Receiver, Mobile, City, Sub Area
                </div>
                <img alt="excel sheet format sample" src="/Content/sys/assets/images/sheet-format.jpg" />
                <p>Excel sheet format sample</p>
            </div>
        </div>
    </div>
    <script src="/Scripts/sys/excelFileUtil.min.js"></script>
</asp:Content>

