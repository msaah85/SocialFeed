<%@ Page Title="Send SMS" MasterPageFile="master.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/Content/sys/assets/css/chosen.min.css" rel="stylesheet" />
    <script src="/Scripts/sys/Common.min.js"></script>
    <script src="/Scripts/sys/DataService.min.js"></script>
    <script src="/Scripts/sys/DefaultGridVariables.min.js"></script>
    <script src="/content/sys/assets/js/jquery.validate.min.js"></script>
    <script src="/content/sys/assets/js/additional-methods.min.js"></script>
    <style>
        .chosen-container {
            line-height: 35px;
        }

        .results tr[visible='false'],
        .no-result {
            display: none;
        }

        .results tr[visible='true'] {
            display: table-row;
        }

        input.search {
            margin-top: 2px;
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
            <li class="active">Send SMS</li>
        </ul>
    </div>
    <div class="page-content">
        <div class="page-header">
            <h1>Send SMS</h1>
        </div>
        <div class="row">
            <form class="form-horizontal" role="form" id="masterForm">
                <div class="col-xs-10">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="CityID">Choose a city <span class="text-danger">*</span></label>
                        <div class="col-sm-7">
                            <input type="hidden" id="SMSID" value="0" />
                            <select multiple id="CityID" name="CityID" class="required chosen-select form-control tag-input-style" required data-placeholder="Choose a city...">
                                <option value="-1">--- All Cities ---</option>
                            </select>
                        </div>
                        <div class="col-sm-2">
                            <a role="button" data-rel="tooltip" class="btn btn-white btn-primary btn-bold" href="Clients.aspx"
                                tabindex="0" title="Add contact"><i class="fa fa-plus bigger-110"></i></a>
                            <a data-rel="tooltip" href="ImportSheet.aspx" class="btn btn-info btn-white btn-bold" title="Upload excel contacts"><i class="fa fa-upload"></i></a>
                        </div>
                    </div>
                </div>
                <div class="col-xs-2"></div>
            </form>
        </div>
        <div class="row">
            <div class="col-xs-12 widget-container-col hidden" id="clientsListPanel">
                <div class="widget-box widget-color-blue" id="widget-box-2">
                    <div class="widget-header">
                        <h5 class="widget-title bigger lighter">
                            <i class="ace-icon fa fa-table"></i>
                            Clients 
                             <span class="lighter inline">
                                 [# 
                            <span class="counter"></span>
                                 rows]
                             </span>
                        </h5>
                        <div class="widget-toolbar">
                            <a href="#" data-action="fullscreen" class="white">
                                <i class="1 ace-icon fa fa-expand bigger-125"></i>
                            </a>
                        </div>
                        <div class="widget-toolbar no-border">
                            <button class="btn btn-xs bigger btn-yellow dropdown-toggle" data-toggle="dropdown">
                                Select
                                <i class="ace-icon fa fa-chevron-down icon-on-right"></i>
                            </button>
                            <ul class="dropdown-menu dropdown-yellow dropdown-menu-right dropdown-caret dropdown-close">
                                <li>
                                    <a class="select-rows" href="javascript:void(0);" data-rows="0">All</a>
                                </li>
                                <li>
                                    <a class="select-rows" href="javascript:void(0);" data-rows="49">50</a>
                                </li>
                                <li>
                                    <a class="select-rows" href="javascript:void(0);" data-rows="99">100</a>
                                </li>
                                <li>
                                    <a class="select-rows" href="javascript:void(0);" data-rows="499">500</a>
                                </li>
                                <li>
                                    <a class="select-rows" href="javascript:void(0);" data-rows="999">1,000</a>
                                </li>
                                <li>
                                    <a class="select-rows" href="javascript:void(0);" data-rows="9999">10,000</a>
                                </li>
                            </ul>
                        </div>
                        <div class="widget-toolbar no-border">
                            <input type="text" class="search form-control" placeholder="What you looking for?" />
                        </div>
                    </div>
                    <div class="widget-body">
                        <div class="widget-main no-padding">
                            <table id="itemsDataTable" class="table table-striped table-bordered table-hover results">
                                <thead>
                                    <tr>
                                        <th class="center">
                                            <label title="Select all" class="pos-rel">
                                                <input name="cbSelectAll" type="checkbox" class="ace" />
                                                <span class="lbl"></span>
                                            </label>
                                        </th>
                                        <th>Client</th>
                                        <th>City</th>
                                        <th>Mobile</th>
                                    </tr>
                                    <tr class="warning no-result">
                                        <td colspan="4"><i class="fa fa-warning"></i>
                                            No search result</td>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="hr hr-18 dotted hr-double"></div>
            </div>
        </div>
        <hr class="hr-10" />
        <div class="row">
            <form class="form-horizontal hidden" role="form" id="aspnetForm">
                <div class="col-xs-12 col-md-1"></div>
                <div class="col-xs-12 col-md-8">
                    <div class="form-group">
                        <label class="col-sm-2 control-label no-padding-right" for="Message">Message <span class="text-danger">*</span></label>
                        <div class="col-sm-10">
                            <textarea cols="15" rows="3" id="Message" name="Message" class="required form-control autosize limited" required placeholder="SMS message..."></textarea>
                        </div>
                    </div>
                </div>
                <div class="col-xs-12 col-md-2">
                    <div class="form-group">
                        <span class="inline" title="Select SMS message language" data-rel="tooltip">
                            <span class="grey"></span>
                            <span class="btn-toolbar inline middle no-margin" id="Lang">
                                <span id="chosen-multiple-style" data-toggle="buttons" class="btn-group no-margin">
                                    <label class="btn btn-xs btn-yellow active">
                                        Arabic
                                        <input type="radio" name="Lang" value="1" />
                                    </label>
                                    <label class="btn btn-xs btn-yellow">
                                        English
                                        <input type="radio" name="Lang" value="0" />
                                    </label>
                                </span>
                            </span>
                        </span>
                    </div>
                    <div class="form-group">
                        <button class="btn btn-sm btn-success" id="SendAll">
                            <i class="ace-icon fa fa-envelope"></i>
                            Send SMS
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <script src="/Scripts/sys/jquery.xml2json.min.js"></script>
    <script src="/Scripts/sys/DefaultGridManager.min.js"></script>
    <script src="/Scripts/sys/utilities.min.js"></script>
    <script src="/Content/sys/assets/js/autosize.min.js"></script>
    <script src="/Content/sys/assets/js/jquery.inputlimiter.1.3.1.min.js"></script>
    <script src="/Scripts/sys/sendSMS.min.js?v=1.3"></script>
    <script>pageManager.Init();</script>
</asp:Content>
