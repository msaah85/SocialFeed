﻿<%@ Page Title="Contacts" Language="C#" MasterPageFile="master.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="/Scripts/sys/Common.min.js"></script>
    <script src="/Scripts/sys/DataService.min.js"></script>
    <script src="/Scripts/sys/DefaultGridVariables.min.js"></script>
    <script src="/Scripts/sys/jquery.xml2json.min.js"></script>
    <script src="/content/sys/assets/js/jquery.validate.min.js"></script>
    <script src="/content/sys/assets/js/additional-methods.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="breadcrumbs ace-save-state" id="breadcrumbs">
        <ul class="breadcrumb">
            <li>
                <i class="ace-icon fa fa-home home-icon"></i>
                <a href="home">Home</a>
            </li>
            <li class="active">Contacts</li>
        </ul>
    </div>
    <div class="page-content">
        <div class="page-header">
            <h1>Contacts Manager</h1>
        </div>
        <div class="row">
            <div class="col-xs-12 widget-container-col">
                <div class="clearfix">
                    <a role="button" class="btn btn-white btn-default btn-bold" href="ImportSheet.aspx"
                        tabindex="0" title="Upload Contacts"><i class="fa fa-upload bigger-110"></i>
                        Upload Excel</a>
                    <a role="button" class="btn btn-white btn-primary btn-bold" href="SendSMS.aspx"
                        tabindex="0" title="Send SMS"><i class="fa fa-send bigger-110"></i>
                        Send SMS</a>
                    <a role="button" href="#addModal" data-toggle="modal" class="btn btn-white btn-warning btn-bold"
                        tabindex="0" title="Add new contact"><i class="fa fa-plus bigger-110"></i>
                        Add contact</a>
                    <div class="pull-right tableTools-container"></div>
                </div>
                <div class="widget-box widget-color-blue" id="widget-box-2">
                    <div class="widget-header">
                        <h5 class="widget-title bigger lighter">
                            <i class="ace-icon fa fa-table"></i>
                            Clients List
                        </h5>
                        <div class="widget-toolbar">
                            <a href="#" data-action="fullscreen" class="white">
                                <i class="1 ace-icon fa fa-expand bigger-125"></i>
                            </a>
                        </div>
                    </div>
                    <div class="widget-body">
                        <div class="widget-main no-padding">
                            <table id="listItems" class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Client name</th>
                                        <th>Mobile</th>
                                        <th>City</th>
                                        <th class="hidden-480">Address</th>
                                        <th class="hidden-print" width="77px">Options</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div id="addModal" class="modal fade" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header no-padding">
                                <div class="table-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                                        <span class="white">&times;</span>
                                    </button>
                                    Add/Edit Client
                                </div>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-xs-12 col-sm-12">
                                        <form class="form-horizontal" role="form" id="aspnetForm">
                                            <div>
                                                <input type="hidden" id="ClientID" value="0" />
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label no-padding-right">Client name <span class="text-danger">*</span></label>
                                                <div class="col-sm-9">
                                                    <input type="text" class="col-sm-10 required" required id="ClientName" name="ClientName" placeholder="Client name" />
                                                </div>
                                            </div>
                                            <!--<div class="form-group">
                                                <label class="col-sm-3 control-label no-padding-right" for="Phone">Phone</label>
                                                <div class="col-sm-9">
                                                    <input type="text" class="col-sm-10" id="Phone" placeholder="05000000000" />
                                                </div>
                                            </div>-->
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label no-padding-right" for="Mobile">Mobile <span class="text-danger">*</span></label>
                                                <div class="col-sm-9">
                                                    <input type="text" class="col-sm-10 required" id="Mobile" name="Mobile" required placeholder="056000000000" />
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label no-padding-right">City <span class="text-danger">*</span></label>
                                                <div class="col-sm-9">
                                                    <select class="col-sm-10 required" required id="CityID" name="CityID">
                                                        <option value="">Select</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label no-padding-right" for="Mobile">Address</label>
                                                <div class="col-sm-9">
                                                    <input type="text" class="col-sm-10" id="Address" name="Address" placeholder="Client address" />
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer no-margin-top">
                                <button class="btn btn-sm btn-primary" id="btnSave">
                                    <i class="ace-icon fa fa-check"></i>
                                    Save
                                </button>
                                <button class="btn btn-sm btn-danger" data-dismiss="modal">
                                    <i class="ace-icon fa fa-times"></i>
                                    Close
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="deleteModal" class="modal fade" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header no-padding">
                                <div class="table-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                                        <span class="white">&times;</span>
                                    </button>
                                    Delete item
                                </div>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-xs-12 col-sm-12">
                                        <form action="#" class="form-horizontal" id="removeForm">
                                            <label id="Label2">Are you sure to delete the selected item (<label class="removeField"></label>)?</label>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer no-margin-top">
                                <button class="btn btn-sm btn-primary btn-delete" id="btnDelete">
                                    <i class="ace-icon fa fa-check"></i>
                                    Delete
                                </button>
                                <button class="btn btn-sm btn-danger" data-dismiss="modal">
                                    <i class="ace-icon fa fa-times"></i>
                                    Cancel
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="/Scripts/sys/DefaultGridManager.min.js?v=1.2"></script>
    <script src="/Scripts/sys/numeral.min.js"></script>
    <script src="/Scripts/sys/clientsManager.min.js?v=1.1"></script>
</asp:Content>
