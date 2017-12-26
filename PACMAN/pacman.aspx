<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="pacman.aspx.cs" Inherits="pacman" %>


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
            <h5>The Monthly Performance Management Dashboard <strong>for Paras Parmar, January 2018</strong></h5>
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
                    <li><a href="#itemized-details" data-toggle="tab">Itemized Details</a></li>
                    <li class="active"><a href="#monthly-scorecard" data-toggle="tab">Overall Scorecard</a></li>
                    <li class="pull-left header"><i class="fa fa-inbox"></i>My Performance Management Cycle</li>
                </ul>
                <div class="tab-content no-padding">
                    <!-- Morris chart - Sales -->
                    <div class="box-body tab-pane active" id="monthly-scorecard" style="position: relative; height: 300px;">
                        <asp:GridView ID="gvScoreCard" runat="server" CssClass="table table-condensed table-bordered table-responsive"
                            AutoGenerateColumns="true">
                        </asp:GridView>



                        <!-- START ACCORDION & CAROUSEL-->
                        <%--<h2 class="page-header"></h2>--%>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="box box-solid">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">Score Card</h3>
                                    </div>
                                    <!-- /.box-header -->
                                    <div class="box-body">
                                        <div class="box-group" id="accordion">
                                            <!-- we are adding the .panel class so bootstrap.js collapse plugin detects it -->
                                            <div class="panel box box-success">
                                                <div class="box-header with-border">
                                                    <h4 class="box-title">
                                                        <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne"><asp:Literal ID="ltlPrimaryKPI" runat="server" Text="Primary KPI : Service Level"></asp:Literal></a>
                                                    </h4>
                                                </div>
                                                <div id="collapseOne" class="panel-collapse collapse in">
                                                    <div class="box-body">
                                                        <asp:Panel ID="pnlKPI" runat="server">
                                                            
                                                        </asp:Panel>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel box box-success">
                                                <div class="box-header with-border">
                                                    <h4 class="box-title">
                                                        <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">BTP : Billed To Pay Ratio</a>
                                                    </h4>
                                                </div>
                                                <div id="collapseTwo" class="panel-collapse collapse">
                                                    <div class="box-body">
                                                        
                   
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel box box-warning">
                                                <div class="box-header with-border">
                                                    <h4 class="box-title">
                                                        <a data-toggle="collapse" data-parent="#accordion" href="#collapseThree">Escalations & Initiatives</a>
                                                    </h4>
                                                </div>
                                                <div id="collapseThree" class="panel-collapse collapse">
                                                    <div class="box-body">
                                                        
                   
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel box box-warning">
                                                <div class="box-header with-border">
                                                    <h4 class="box-title">
                                                        <a data-toggle="collapse" data-parent="#accordion" href="#collapseFour">Self-Attendance</a>
                                                    </h4>
                                                </div>
                                                <div id="collapseFour" class="panel-collapse collapse">
                                                    <div class="box-body">
                                                        
                   
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel box box-warning">
                                                <div class="box-header with-border">
                                                    <h4 class="box-title">
                                                        <a data-toggle="collapse" data-parent="#accordion" href="#collapseFive"><asp:Literal ID="ltlOptimizationKPI" runat="server" Text="Real Time Optimization KPI"></asp:Literal></a>
                                                    </h4>
                                                </div>
                                                <div id="collapseFive" class="panel-collapse collapse">
                                                    <div class="box-body">
                                                        <asp:Panel ID="pnlOptimization" runat="server">
                                                                                                                        
                                                        </asp:Panel>
                   
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
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
                    <div class="chart tab-pane" id="itemized-details" style="position: relative">
                        <asp:GridView ID="tblKPI" runat="server" CssClass="table table-condensed table-bordered table-responsive"
                            AutoGenerateColumns="true">
                        </asp:GridView>

                    </div>
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
                     <asp:Button ID="btnYesDiscussed" runat="server" Text="Discussed" CssClass="btn btn-primary" />
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
                     <asp:Button ID="btnAgree" runat="server" Text="Acknowledged" CssClass="btn btn-success" />
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

