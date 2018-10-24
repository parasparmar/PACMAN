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
        /* Inline style div.widget-user-header */
        div.widget-user-header {
            padding-top: 10px !important;
            padding-bottom: 40px !important;
        }

        /* AdminLTE.css (3063, 42) */
        .widget-user-2 .widget-user-image > img {
            width: 65px !important;
            height: 65px !important;
            float: left;
        }
    </style>


</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">

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

    <asp:Panel ID="pnlOverall" CssClass="row" runat="server" Visible="false">
        <div id="leftSection" class="col-md-4">
            <asp:Repeater ID="rptOverAll" runat="server">
                <HeaderTemplate>
                    <!-- Widget: user widget style 1 -->
                    <div class="box box-widget widget-user-2">
                        <!-- Add the bg color to the header using any of the bg-* classes -->
                        <div class="widget-user-header bg-primary">
                            <div class="widget-user-image">
                                <asp:Image ID="imgReportee" CssClass="img-circle" ImageUrl="~/Sitel/user_images/unknownPerson.jpg" runat="server" AlternateText="Avatar" />
                            </div>
                            <!-- /.widget-user-image -->
                            <h1 class="widget-user-desc"></h1>
                            <h1 class="widget-user-desc"></h1>
                            <h4 class="widget-user-username" style="font-size: large">
                                <asp:Literal ID="ltlUserName" runat="server" Text="My Name"></asp:Literal>
                            </h4>

                        </div>
                        <div id="leftBox" class="box-footer no-padding">
                            <ul class="nav nav-stacked">
                </HeaderTemplate>
                <ItemTemplate>
                    <li>
                        <a>
                            <asp:Literal ID="ltlHeader" runat="server" Text='<%# Eval("Row")%>'></asp:Literal>
                            <span class="pull-right badge">
                                <asp:Literal ID="ltlValue" runat="server" Text='<%# Eval("Column")%>'></asp:Literal>
                            </span>
                        </a>
                    </li>
                </ItemTemplate>
                <FooterTemplate>
                    </ul>
                                </div>                            
                            <!-- /.widget-user -->
                    </div>
                </FooterTemplate>
            </asp:Repeater>
        </div>
        <div id="rightSection" class="col-md-8">
            <!-- Widget: user widget style 1 -->
            <div class="box box-widget widget-user-2">
                <!-- Add the bg color to the header using any of the bg-* classes -->
                <div class="widget-user-header bg-gray" id="rightWidgetUserHeader">
                    <div class="widget-user-image">
                        <asp:Image ID="imgReportingMgr" CssClass="img-circle" ImageUrl="~/Sitel/user_images/unknownPerson.jpg" runat="server" AlternateText="Avatar" />
                    </div>
                    <!-- /.widget-user-image -->
                    <h1 class="widget-user-desc"></h1>
                    <h1 class="widget-user-desc"></h1>
                    <h4 class="widget-user-username" style="font-size: large">Reporting Manager's Comments for the Cycle.</h4>

                </div>
                <div class="box-footer no-padding">
                    <ul class="nav nav-stacked">

                        <asp:TextBox ID="tbManualComments" CssClass="form-control bg-info"
                            TextMode="MultiLine" Wrap="True" ReadOnly="true" BorderStyle="None"
                            BorderWidth="0" Font-Names="Tahoma"
                            Style="overflow: auto;" runat="server"></asp:TextBox>

                        <li id="rightFooter">
                            <asp:Label ID="lblOverAll" runat="server" CssClass="text text-primary text-uppercase form-control" Text=""></asp:Label>
                        </li>
                    </ul>
                </div>
            </div>
            <!-- /.widget-user -->
        </div>
    </asp:Panel>
    <div class="row">
        <!-- Left col -->
        <section class="col-lg-12 connectedSortable">
            <!-- Custom tabs (Charts with tabs)-->
            <div class="nav-tabs-custom">
                <!-- Tabs within a box -->
                <ul class="nav nav-tabs pull-right">
                    <li class="active" style="font-size: 16px"><a href="#monthly-scorecard" data-toggle="tab">Overall Scorecard</a></li>
                    <li class="pull-left header" style="font-size: 16px"><i class="fa fa-inbox"></i>
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
                                        <h3 class="box-title">Overall Score :
                                            <asp:Literal ID="ltlFinalRating" Text="0" runat="server"></asp:Literal>
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
                                                                    <a data-toggle="collapse" data-parent="#accordion" href="#collapse<%# Eval("KPIID") %>">
                                                                        <asp:Literal ID="ltlKPIName" Text='<%#Eval("Metric") %>' runat="server"></asp:Literal>
                                                                    </a>
                                                                </h4>
                                                            </div>
                                                            <div class="col-md-3">
                                                                <a data-toggle="collapse" data-parent="#accordion" href="#collapse<%# Eval("KPIID") %>">
                                                                    <h4 class="box-title">Wtg %:
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
                                                                <a data-toggle="collapse" data-parent="#accordion" href="#collapse<%# Eval("KPIID") %>">
                                                                    <h4 class="box-title" style="color: white">Wtd Score :
                                                                    <asp:Literal ID="ltlWeightedScore" Text="0" runat="server"></asp:Literal>
                                                                    </h4>
                                                                </a>
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
    <script>
        //  tbManualComments.height = rptOverAll.height - rightWidgetUserHeader - rightFooter.height
        $(function () {
           
            if ($("#pnlOverall") !== null) {
                var tbManualCommentsPadding = $("#tbManualComments").innerHeight() - $("#tbManualComments").height();
                var leftBox = $("#leftBox").height();
                var rightFooter = $("#rightFooter").height();

                var desiredHeight = leftBox - rightFooter - tbManualCommentsPadding;
                $("#tbManualComments").height(desiredHeight);
            }
        });
    </script>
</asp:Content>

