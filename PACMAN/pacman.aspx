<%@ Page Title="My PACMAN" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="pacman.aspx.cs" Inherits="pacman" %>


<%@ MasterType VirtualPath="~/MasterPage.master" %>

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
            <h5>The Monthly Performance Management Dashboard <strong>
                <asp:Label ID="lblName" runat="server"></asp:Label>,<asp:Label ID="lblPC" runat="server"></asp:Label></strong></h5>
            <h1>My PACMAN</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">

    <!-- Small boxes (Stat box) -->
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
    <!-- /.row -->
    <div class="box">
        <div class="box-body">
            <div class="form-group">
                <label for="ddlReviewPeriod" class="col-lg-2 control-label">select Review Period</label>
                <div class="col-lg-4">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-calendar-check-o"></i></span>
                        <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlReviewPeriod" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlReviewPeriod_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Main row -->
    <div class="row">
        <!-- Left col -->
        <section class="col-lg-12 connectedSortable">
            <!-- Custom tabs (Charts with tabs)-->
            <div class="nav-tabs-custom">
                <!-- Tabs within a box -->
                <ul class="nav nav-tabs pull-right">
                    <%--<li><a href="#itemized-details" data-toggle="tab">Itemized Details</a></li>--%>
                    <li><a href="#monthly-scorecard" data-toggle="tab">Overall Score</a></li>
                    <li class="active"><a href="#all-my-accounts" data-toggle="tab">My Accounts</a></li>
                    <li class="pull-left header"><i class="fa fa-inbox"></i>My Performance Management Cycle</li>
                </ul>
                <div class="tab-content no-padding">
                    <div class="box-body tab-pane active" id="all-my-accounts" style="position: relative">
                        <asp:GridView ID="gvAllMyAccounts" runat="server" CssClass="table DataTable table-condensed table-bordered table-responsive"
                            AutoGenerateColumns="false" OnPreRender="gv_PreRender">
                            <Columns>

                                <asp:BoundField DataField="Account" HeaderText="Client" />
                                <asp:BoundField DataField="Skillset" HeaderText="My Role" />
                                <asp:BoundField DataField="PrimaryKPI" HeaderText="Primary KPI" />
                                <asp:BoundField DataField="InBO" HeaderText="Data in BO" />

                            </Columns>
                        </asp:GridView>
                    </div>
                    <div class="box-body tab-pane" id="monthly-scorecard" style="position: relative; height: 300px;">
                        <!-- START ACCORDION & CAROUSEL-->
                        <div class="row">
                            <div class="col-md-12">
                                <!-- /.box-header -->
                                <div class="box-body">
                                    <h3 class="box-title">Overall Score :
                                            <asp:Literal ID="ltlfinalScore" Text="0" runat="server"></asp:Literal></h3>
                                    <div class="box-group" id="accordion">
                                        <!-- we are adding the .panel class so bootstrap.js collapse plugin detects it -->

                                        <!--Common KPI for RTA, Scheduler, Planner-->
                                        <asp:Panel ID="pnl_KPI" CssClass="panel box box-primary" runat="server" Visible="false">
                                            <div class="box-header with-border">
                                                <h4 class="box-title">
                                                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">
                                                        <asp:Literal ID="ltlPrimaryKPI" runat="server" Text="Primary KPI : "></asp:Literal>
                                                        <asp:Literal ID="ltl_KPI" Text="0" runat="server"></asp:Literal>
                                                    </a>
                                                </h4>
                                            </div>
                                            <div id="collapseOne" class="panel-collapse collapse in">
                                                <div class="box-body">
                                                    <asp:Panel ID="pnlKPI" runat="server">
                                                    </asp:Panel>
                                                </div>
                                            </div>
                                        </asp:Panel>
                                        <!--Primary KPI-->
                                        <asp:Panel ID="pnl_BTP" CssClass="panel box box-primary" runat="server" Visible="false">
                                            <div class="box-header with-border">
                                                <h4 class="box-title">
                                                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">
                                                        <asp:Literal ID="ltlBTP" runat="server" Text="BTP : Billed To Pay Ratio"></asp:Literal>
                                                        <asp:Literal ID="ltl_BTP" Text="0" runat="server"></asp:Literal>
                                                    </a>
                                                </h4>
                                            </div>
                                            <div id="collapseTwo" class="panel-collapse collapse">
                                                <div class="box-body">
                                                    <asp:Panel ID="pnlBTP" runat="server">
                                                    </asp:Panel>
                                                </div>
                                            </div>
                                        </asp:Panel>
                                        <!--BTP-->
                                        <asp:Panel ID="pnl_Escalations" CssClass="panel box box-primary" runat="server" Visible="false">
                                            <div class="box-header with-border">
                                                <h4 class="box-title">
                                                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseThree">
                                                        <asp:Literal ID="ltlEI" runat="server" Text="Escalations & Initiatives : "></asp:Literal>
                                                        <asp:Literal ID="ltl_Escalations" Text="0" runat="server"></asp:Literal>
                                                    </a>
                                                </h4>
                                            </div>
                                            <%--<div id="collapseThree" class="panel-collapse collapse">
                                                    <div class="box-body">
                                                        
                   
                                                    </div>
                                                </div>--%>
                                        </asp:Panel>
                                        <!--Escalations & Initiatives-->

                                        <!--Commom KPI for all(RTA, Scheduler, Planner, Analytics)-->
                                        <asp:Panel ID="pnl_Absenteeism" CssClass="panel box box-primary" runat="server" Visible="false">
                                            <div class="box-header with-border">
                                                <h4 class="box-title">
                                                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseFour">
                                                        <asp:Literal ID="ltlAbsenteeism" runat="server" Text="Absenteeism : "></asp:Literal>
                                                        <asp:Literal ID="ltl_Absenteeism" Text="0" runat="server"></asp:Literal>
                                                    </a>
                                                </h4>
                                            </div>
                                            <%--<div id="collapseFour" class="panel-collapse collapse">
                                                    <div class="box-body">
                                                    </div>
                                                </div>--%>
                                        </asp:Panel>
                                        <!--Self-Attendance-->

                                        <!--RTA KPI's-->
                                        <asp:Panel ID="pnl_Real_Time_Optimization" CssClass="panel box box-primary" runat="server" Visible="false">
                                            <div class="box-header with-border">
                                                <h4 class="box-title">
                                                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseFive">
                                                        <asp:Literal ID="ltlOptimization" runat="server" Text="Real Time Optimization KPI : "></asp:Literal>
                                                        <asp:Literal ID="ltl_Real_Time_Optimization" Text="0" runat="server"></asp:Literal>
                                                    </a>
                                                </h4>
                                            </div>
                                            <div id="collapseFive" class="panel-collapse collapse">
                                                <div class="box-body">
                                                    <asp:Panel ID="pnlOptimization" runat="server">
                                                    </asp:Panel>

                                                </div>
                                            </div>
                                        </asp:Panel>
                                        <!--Real Time Optimization KPI-->

                                        <!-- Planner KPI's -->
                                        <asp:Panel ID="pnl_Forecasting_Accuracy" CssClass="panel box box-primary" runat="server" Visible="false">
                                            <div class="box-header with-border">
                                                <h4 class="box-title">
                                                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseSix">
                                                        <asp:Literal ID="ltlForecasting_Accuracy" runat="server" Text="Forecast Accuracy : "></asp:Literal>
                                                        <asp:Literal ID="ltl_Forecasting_Accuracy" Text="0" runat="server"></asp:Literal>

                                                    </a>
                                                </h4>
                                            </div>
                                            <div id="collapseSix" class="panel-collapse collapse in">
                                                <div class="box-body">
                                                    <asp:Panel ID="pnlForecasting_Accuracy" runat="server">
                                                    </asp:Panel>
                                                </div>
                                            </div>
                                        </asp:Panel>
                                        <!--Forecast Accuracy-->

                                        <asp:Panel ID="pnl_Headcount_Accuracy" CssClass="panel box box-primary" runat="server" Visible="false">
                                            <div class="box-header with-border">
                                                <h4 class="box-title">
                                                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseSeven">
                                                        <asp:Literal ID="ltlHeadcount_Accuracy" runat="server" Text="Headcount Accuracy"></asp:Literal>
                                                        <asp:Literal ID="ltl_Headcount_Accuracy" Text="0" runat="server"></asp:Literal>
                                                    </a>
                                                </h4>
                                            </div>
                                            <div id="collapseSeven" class="panel-collapse collapse in">
                                                <div class="box-body">
                                                    <asp:Panel ID="pnlHeadcount_Accuracy" runat="server">
                                                    </asp:Panel>
                                                </div>
                                            </div>
                                        </asp:Panel>
                                        <!--Headcount Accuracy-->

                                        <!--Scheduler KPI's-->
                                        <asp:Panel ID="pnl_Scheduling_Accuracy" CssClass="panel box box-primary" runat="server" Visible="false">
                                            <div class="box-header with-border">
                                                <h4 class="box-title">
                                                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseNine">
                                                        <asp:Literal ID="ltlSchedulingAccuracy" runat="server" Text="Scheduling Accuracy"></asp:Literal>
                                                        <asp:Literal ID="ltl_Scheduling_Accuracy" Text="0" runat="server"></asp:Literal>
                                                    </a>
                                                </h4>
                                            </div>
                                            <div id="collapseNine" class="panel-collapse collapse in">
                                                <div class="box-body">
                                                    <asp:Panel ID="pnlSchedulingAccuracy" runat="server">
                                                    </asp:Panel>
                                                </div>
                                            </div>
                                        </asp:Panel>
                                        <!--Scheduling Accuracy-->

                                        <asp:Panel ID="pnl_IEX_Management" CssClass="panel box box-primary" runat="server" Visible="false">
                                            <div class="box-header with-border">
                                                <h4 class="box-title">
                                                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseEight">
                                                        <asp:Literal ID="ltlIEX_Management" runat="server" Text="IEX Management"></asp:Literal>
                                                        <asp:Literal ID="ltl_IEX_Management" Text="0" runat="server"></asp:Literal>
                                                    </a>
                                                </h4>
                                            </div>
                                            <div id="collapseEight" class="panel-collapse collapse in">
                                                <div class="box-body">
                                                    <asp:Panel ID="pnlIEX_Management" runat="server">

                                                    </asp:Panel>
                                                </div>
                                            </div>
                                        </asp:Panel>
                                        <!--IEX Management-->

                                        <!--Analytics KPI-->
                                        <asp:Panel ID="pnl_Analytics" runat="server" Visible="false">
                                            
                                            <div class="panel box box-warning">
                                                <div class="box-header with-border">
                                                    <h4 class="box-title">
                                                        <a data-toggle="collapse" data-parent="#accordion" href="#collapseTen">
                                                            <asp:Literal ID="ltlCoachingFeedback" runat="server" Text="Coaching  & Feedback"></asp:Literal></a>
                                                    </h4>
                                                </div>
                                                <div id="collapseTen" class="panel-collapse collapse">
                                                    <div class="box-body">
                                                        <asp:Panel ID="Panel5" runat="server">
                                                        </asp:Panel>

                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel box box-warning">
                                                <div class="box-header with-border">
                                                    <h4 class="box-title">
                                                        <a data-toggle="collapse" data-parent="#accordion" href="#collapseEleven">
                                                            <asp:Literal ID="ltlOntimeDelivery" runat="server" Text="On-Time Delivery"></asp:Literal>
                                                        </a>
                                                    </h4>
                                                </div>
                                                <div id="collapseEleven" class="panel-collapse collapse">
                                                    <div class="box-body">
                                                        <asp:Panel ID="Panel6" runat="server">
                                                        </asp:Panel>

                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel box box-warning">
                                                <div class="box-header with-border">
                                                    <h4 class="box-title">
                                                        <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwelve">
                                                            <asp:Literal ID="ltlAccuracy" runat="server" Text="Accuracy"></asp:Literal></a>
                                                    </h4>
                                                </div>
                                                <div id="collapseTwelve" class="panel-collapse collapse">
                                                    <div class="box-body">
                                                        <asp:Panel ID="Panel7" runat="server">
                                                        </asp:Panel>

                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel box box-warning">
                                                <div class="box-header with-border">
                                                    <h4 class="box-title">
                                                        <a data-toggle="collapse" data-parent="#accordion" href="#collapseProject">
                                                            <asp:Literal ID="ltlAnalyticProject" runat="server" Text="Projects"></asp:Literal>
                                                        </a>
                                                    </h4>
                                                </div>
                                                <div id="collapseProject" class="panel-collapse collapse">
                                                    <div class="box-body">
                                                        <asp:Panel ID="Panel8" runat="server">
                                                        </asp:Panel>

                                                    </div>
                                                </div>
                                            </div>

                                        </asp:Panel>
                                    </div>
                                </div>
                                <!-- /.box-body -->
                            </div>
                            <!-- /.col -->
                        </div>
                        <!-- /.row -->
                        <!-- END ACCORDION & CAROUSEL-->
                    </div>
                    <%--<div class="chart tab-pane" id="itemized-details" style="position: relative">
                        <asp:GridView ID="tblKPI" runat="server" CssClass="table DataTable table-condensed table-bordered table-responsive"
                            AutoGenerateColumns="true" OnPreRender="gv_PreRender">
                        </asp:GridView>

                    </div>--%>
                </div>
                <div class="box-footer"></div>
            </div>
            <!-- /.nav-tabs-custom -->
        </section>
        <!-- /.Left col -->
        <div class="col-md-6">
            <div class="box">
                <div class="box-body">
                    <div class="form-group">
                        <h4>Have you discussed your PACMAN with your Manager?
                 <span class="btn-group pull-right">
                     <asp:Button ID="btnNotDiscussed" runat="server" Text="Not Discussed" CssClass="btn btn-default" />
                     <asp:Button ID="btnYesDiscussed" runat="server" Text="Discussed" CssClass="btn btn-primary" OnClick="btnYesDiscussed_Click" />
                 </span>
                        </h4>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="box">
                <div class="box-body">
                    <div class="form-group">
                        <h4>I acknowledge my performance as shown above.
                 <span class="btn-group pull-right">
                     <%--<asp:Button ID="btnDoNotAgree" runat="server" Text="I Do Not Agree" CssClass="btn btn-warning" />--%>
                     <asp:Button ID="btnAgree" runat="server" Text="Acknowledged" CssClass="btn btn-success" OnClick="btnAgree_Click" />
                 </span>
                        </h4>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- /.row (main row) -->

</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">

    <!-- Bootstrap WYSIHTML5 -->
    <script src="plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js"></script>


</asp:Content>

