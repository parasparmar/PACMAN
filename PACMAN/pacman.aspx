<%@ Page Title="My PACMAN" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="pacman.aspx.cs" Inherits="pacman" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>


<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="index.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="pacman.aspx">
            <img src="sitel/img/performance-360_bw.png" style="height: 10px" alt="" />PACMAN</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon">
            <img src="sitel/img/performance-360_bw.png" style="height: 60px" alt="" />
        </div>
        <div class="pagetitle">
            <h5>The Monthly Performance Management Dashboard</h5>
            <h1>My PACMAN</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
    <link href="Sitel/plugins/bootstrap-toggle/css/bootstrap-toggle.min.css" rel="stylesheet" />
    <!-- iCheck for checkboxes and radio inputs -->
    <link rel="stylesheet" href="AdminLTE/plugins/iCheck/all.css">
    <style>
        .border-between > [class*='col-']:before {
            background: #e3e3e3;
            bottom: 0;
            content: " ";
            left: 0;
            position: absolute;
            width: 1px;
            top: 0;
        }

        .content-wrapper {
            min-height: 897.76px !important;
        }

        .border-between > [class*='col-']:first-child:before {
            display: none;
        }
    </style>


</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">


    <%--<div class="row">
        <div class="col-lg-2 col-xs-4">
            <!-- small box -->
            <div class="small-box bg-green">
                <div class="inner">
                    <h3>3.59</h3>
                    <p>service level</p>
                </div>
                <div class="icon">
                </div>
                <a href="#" class="small-box-footer">more info <i class="fa fa-arrow-circle-right"></i></a>
            </div>
        </div>
        <!-- ./col -->
        <div class="col-lg-2 col-xs-4">
            <!-- small box -->
            <div class="small-box bg-yellow">
                <div class="inner">
                    <h3>2.48<sup style="font-size: 20px"></sup></h3>

                    <p>btp</p>
                </div>
                <div class="icon">
                </div>
                <a href="#" class="small-box-footer">more info <i class="fa fa-arrow-circle-right"></i></a>
            </div>
        </div>
        <!-- ./col -->
        <div class="col-lg-2 col-xs-4">
            <!-- small box -->
            <div class="small-box bg-green">
                <div class="inner">
                    <h3>3.6</h3>

                    <p>coaching</p>
                </div>
                <div class="icon">
                </div>
                <a href="#" class="small-box-footer">more info <i class="fa fa-arrow-circle-right"></i></a>
            </div>
        </div>
        <!-- ./col -->
        <div class="col-lg-2 col-xs-4">
            <!-- small box -->
            <div class="small-box bg-aqua">
                <div class="inner">
                    <h3>5.0</h3>

                    <p>escalations</p>
                </div>
                <div class="icon">
                </div>
                <a href="#" class="small-box-footer">more info <i class="fa fa-arrow-circle-right"></i></a>
            </div>
        </div>
        <!-- ./col -->
        <div class="col-lg-2 col-xs-4">
            <!-- small box -->
            <div class="small-box bg-aqua">
                <div class="inner">
                    <h3>5.0</h3>

                    <p>attendance</p>
                </div>
                <div class="icon">
                </div>
                <a href="#" class="small-box-footer">more info <i class="fa fa-arrow-circle-right"></i></a>
            </div>
        </div>
        <!-- ./col -->
        <div class="col-lg-2 col-xs-4">
            <!-- small box -->
            <div class="small-box bg-green">
                <div class="inner">
                    <h3>3.0</h3>

                    <p>rta optimization</p>
                </div>
                <div class="icon">
                </div>
                <a href="#" class="small-box-footer">more info <i class="fa fa-arrow-circle-right"></i></a>
            </div>
        </div>
        <!-- ./col -->
    </div>--%>
    <!-- Small boxes (Stat box) -->

    <!-- /.row -->
    <div class="box">
        <div class="box-body">
            <div class="form-group">
                <div class="col-lg-6">
                    <div class="form-group">
                        <label>Select Pacman Cycle</label>
                        <div class="input-group">
                            <div class="input-group-addon">
                                <i class="fa fa-calendar-check-o"></i>
                            </div>
                            <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlReviewPeriod" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlReviewPeriod_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                        <!-- /.input group -->
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Review Selection Row -->

    <asp:Panel ID="pnlOverall" CssClass="box" runat="server" Visible="true">
        <div class="box-body">
            <div class="form-group">
                <div class="col-lg-12">
                    <div class="form-group">                        
                            <asp:Label ID="lblOverAll" runat="server" Text="Pacman Cycle"></asp:Label>
                        <asp:GridView ID="gvOverAll" runat="server"
                            CssClass="table table-condensed table-bordered table-responsive PageSpecificDataTable"
                            AutoGenerateColumns="true"
                            OnPreRender="gv_PreRender">
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>


    <div class="row">
        <!-- Left col -->
        <section class="col-lg-12 connectedSortable">
            <!-- Custom tabs (Charts with tabs)-->
            <div class="nav-tabs-custom">
                <!-- Tabs within a box -->
                <ul class="nav nav-tabs pull-right">
                    <li class="active"><a href="#monthly-scorecard" data-toggle="tab">Overall Scorecard</a></li>
                    <li class="pull-left header"><i class="fa fa-inbox"></i>
                        <asp:Literal ID="ltlEmployeeBanner" runat="server"></asp:Literal>
                    </li>
                </ul>
                <div class="tab-content no-padding">
                    <!-- Morris chart - Sales -->
                    <div class="box-body tab-pane active" id="monthly-scorecard" style="position: relative; height: 300px;">
                        <!-- START ACCORDION & CAROUSEL-->
                        <%--<h2 class="page-header"></h2>--%>
                        <div class="row" id="one" runat="server">
                            <div class="col-md-12">
                                <div class="box box-solid">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">Overall Score : <asp:Literal ID="ltlFinalRating" Text="0" runat="server"></asp:Literal>
                                        </h3>
                                    </div>
                                    <!-- /.box-header -->
                                    <div class="box-body">
                                        <asp:Repeater ID="rp" runat="server" OnItemDataBound="rp_ItemDataBound">
                                            <HeaderTemplate>
                                                <div class="box-group" id="accordion">
                                                    <!-- we are adding the .panel class so bootstrap.js collapse plugin detects it -->
                                                    <!--Common KPI for RTA, Scheduler, Planner-->
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Panel ID="pnl_KPI" CssClass="panel box box-primary" runat="server" Visible="true">
                                                    <div class="box-header with-border">
                                                        <div class="row">
                                                            <div class="col-md-3">
                                                                <h4 class="box-title">
                                                                    <a data-toggle="collapse" data-parent="#accordion" href="#collapse<%# Eval("KPIID") %>">KPI Name :
                                                                        <asp:Literal ID="ltlKPIName" Text='<%#Eval("Metric") %>' runat="server"></asp:Literal>
                                                                    </a>
                                                                </h4>
                                                            </div>
                                                            <div class="col-md-3">
                                                                <a data-toggle="collapse" data-parent="#accordion" href="#collapse<%# Eval("KPIID") %>">
                                                                    <h4 class="box-title">Weightage %:
                                                                    <asp:Literal ID="ltlKPIWeightage" Text='<%#Convert.ToDecimal(Eval("KPIWtg"))*100 %>' runat="server"></asp:Literal>
                                                                    </h4>
                                                                </a>
                                                            </div>
                                                            <div class="col-md-3">
                                                                <a data-toggle="collapse" data-parent="#accordion" href="#collapse<%# Eval("KPIID") %>">
                                                                    <h4 class="box-title">Score :
                                                                    <asp:Literal ID="ltlKPIScore" Text="0" runat="server"></asp:Literal>
                                                                    </h4>
                                                                </a>
                                                            </div>
                                                            <div class="col-md-2">
                                                                <%--<a data-toggle="collapse" data-parent="#accordion" href="#collapse<%# Eval("KPIID") %>">
                                                                    <h4 class="box-title">Wtd Score :
                                                                    <asp:Literal ID="ltlWeightedScore" Text="0" runat="server"></asp:Literal>
                                                                    </h4>
                                                                </a>--%>
                                                            </div>
                                                            <div class="col-md-1">
                                                                <asp:LinkButton ID="btnKPI" CssClass="btn btn-primary btn-flat pull-right"
                                                                    CommandArgument='<%# Eval("KPIID") %>' Text="Download Details"
                                                                    runat="server" CausesValidation="false" OnClick="btnKPI_Click"><i class="fa fa-download"></i></asp:LinkButton>
                                                            </div>
                                                        </div>
                                                        <!-- /.box-tools -->
                                                    </div>
                                                    <!-- /.box-header -->
                                                    <div id="collapse<%# Eval("KPIID") %>" class="panel-collapse collapse">
                                                        <div class="box-body">
                                                            <asp:Panel ID="pnlKPI" runat="server">

                                                                <div class="row">
                                                                    <asp:Panel ID="dvKPI" class="col-md-12" runat="server">
                                                                        <asp:GridView ID="gvKPI" runat="server" CssClass="table table-condensed"></asp:GridView>
                                                                    </asp:Panel>
                                                                </div>
                                                            </asp:Panel>
                                                            <!--Auto KPI Panel-->
                                                            <asp:Panel ID="pnlManualKPI" runat="server" Visible="false">
                                                                <div class="row">
                                                                    <div class="col-md-3">
                                                                        <label>Select Rating</label>
                                                                        <asp:DropDownList ID="ddlManualScore" runat="server" CssClass="form-control select">
                                                                            <asp:ListItem Value="5" Text="5" runat="server"></asp:ListItem>
                                                                            <asp:ListItem Value="4" Text="4" runat="server"></asp:ListItem>
                                                                            <asp:ListItem Value="3" Text="3" runat="server"></asp:ListItem>
                                                                            <asp:ListItem Value="2" Text="2" runat="server"></asp:ListItem>
                                                                            <asp:ListItem Value="1" Text="1" runat="server"></asp:ListItem>
                                                                        </asp:DropDownList>
                                                                    </div>
                                                                    <div class="col-md-6">
                                                                        <asp:Label ID="label1" runat="server">Please enter comments</asp:Label>
                                                                        <asp:TextBox ID="txtManualComments" runat="server" CssClass="form-control select" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                                                    </div>
                                                                   
                                                                </div>
                                                            </asp:Panel>
                                                            <!--Manual KPI Panel-->
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                                <!--Primary KPI-->
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                </div>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                    </div>
                                    <!-- /.box-body -->
                                </div>
                                <!-- /.box -->
                            </div>
                            <!-- /.col -->
                        </div>
                        <!-- /.row -->
                        <!-- END ACCORDION & CAROUSEL-->

                    </div>
                </div>
            </div>
            <!-- /.nav-tabs-custom -->
            <asp:Panel ID="pnlSubmission" CssClass="row" runat="server" Visible="false">

                <div class="col-md-6">
                    <div class="box">
                        <div class="box-body">
                            <div class="form-group">
                                <h4>I acknowledge
                             <span class="btn-group pull-right">
                                 <asp:Button ID="btnAcknowledged" runat="server" Enabled="false" Text="Acknowledged" CssClass="btn btn-primary" OnClick="btnAcknowledged_Click" />
                             </span>
                                </h4>
                            </div>
                        </div>
                    </div>
                </div>

            </asp:Panel>
        </section>
        <!-- /.Left col -->
    </div>
    <!-- KPI Breakup Row -->
    <!-- /.row (main row) -->
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">

    <!-- Bootstrap WYSIHTML5 -->
    <script src="plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js"></script>


</asp:Content>

