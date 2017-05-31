<%@ Page Title="SMS System" Language="C#" MasterPageFile="master.master" AutoEventWireup="true" CodeFile="home.aspx.cs" Inherits="sys_home"
    EnableTheming="false" EnableViewState="false" ViewStateMode="Disabled" EnableSessionState="ReadOnly" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/Content/sys/assets/css/dashboard.min.css" rel="stylesheet" />
    <script src="/Scripts/sys/DataService.min.js"></script>
    <script src="/Scripts/sys/DefaultGridVariables.min.js"></script>
    <script src="/Scripts/sys/Common.min.js"></script>
    <script src="/Scripts/sys/jquery.xml2json.min.js"></script>
    <script src="/Scripts/sys/dashboard.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="breadcrumbs ace-save-state" id="breadcrumbs">
        <ul class="breadcrumb">
            <li>
                <i class="ace-icon fa fa-home home-icon"></i>
                <a>Home</a>
            </li>
            <li class="active">Dashboard</li>
        </ul>
    </div>
    <div class="page-content">
        <div class="page-header">
            <h1>Dashboard</h1>
        </div>
        <div class="row">
            <div class="col-xs-12">
                <div class="alert alert-block alert-info">
                    <strong>WELCOME</strong> To SMS/SOCIAL MANAGEMENT SYSTEM (DAR ALQIMAH FASHION)
                   <button type="button" class="close" data-dismiss="alert"><i class="ace-icon fa fa-times"></i></button>
                </div>
            </div>
            <div class="col-md-12">
                <div class="page">
                    <div class="metr">
                        <a class="metrostyle orgmetro" href="users">
                            <span class="fa fa-user tile-ico"></span>
                            <span class="tile-count" id="UsersCount">1</span>
                            <span class="tile-title tile-title-80">Login</span>
                        </a>
                        <a class="metrostyle eenmetro" href="settings">
                            <span class="fa fa-cogs tile-ico"></span>
                            <span class="tile-count" id="SettingsCount">0</span>
                            <span class="tile-title tile-title-80">Settings</span>
                        </a>
                        <a class="metrostyle toometro" href="ImportSheet">
                            <span class="fa fa-cloud-upload tile-ico"></span>
                            <span class="tile-count">&nbsp;</span>
                            <span class="tile-title tile-title-80">Upload</span>
                        </a>
                        <a class="metrostyle yoometro" href="Clients">
                            <span class="fa fa-phone tile-ico"></span>
                            <span class="tile-count" id="ClientsCount">0</span>
                            <span class="tile-title tile-title-80">Contacts</span>
                        </a>
                        <a class="metrostyle metrostylelarge boometro" href="sendsms">
                            <span class="fa fa-paper-plane tile-ico"></span>
                            <span class="tile-count">&nbsp;</span>
                            <span class="tile-title tile-title-180">New SMS</span>
                        </a>
                    </div>
                    <div class="metr">
                        <a class="metrostyle lightpurple" href="Cities">
                            <span class="fa fa-globe tile-ico"></span>
                            <span class="tile-count" id="CitiesCount">0</span>
                            <span class="tile-title tile-title-100">Cities</span>
                        </a>
                        <a class="metrostyle metrostylelarge reemetro" href="SMSReport">
                            <span class="fa fa-envelope-o tile-ico"></span>
                            <span class="tile-count" id="SMSCount">0</span>
                            <span class="tile-title tile-title-180">SMS`s list</span>
                        </a>
                        <a class="metrostyle tilepink margin-left-45" href="social/posts">
                            <span class="fa fa-retweet tile-ico"></span>
                            <span class="tile-count">&nbsp;</span>
                            <span class="tile-title tile-title-70">Posts list</span>
                        </a>
                        <a class="metrostyle metrostylelarge tileblue" href="Social/AddPost">
                            <span class="fa fa-facebook tile-ico"></span>
                            <span class="tile-count">&nbsp;</span>
                            <span class="tile-title tile-title-120">Adding a new post</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ContentPlaceHolder2">
    <script>pageManager.Init();</script>
</asp:Content>

