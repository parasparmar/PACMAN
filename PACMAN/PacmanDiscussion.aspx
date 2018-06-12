<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="PacmanDiscussion.aspx.cs" Inherits="PacmanDiscussion" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>

<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="index.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="PacmanDiscussion.aspx"><i class="fa fa-file-text"></i>Pacman Discussion</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-file-text"></span></div>
        <div class="pagetitle">
            <h5>Discussion of Monthly Performance</h5>
            <h1>PACMAN Discussion</h1>
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

    <!-- Small boxes (Stat box) -->

    <!-- /.row -->
    <div class="box">
        <div class="box-body">
            <div class="form-group">
                <div class="col-lg-3">
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
                <asp:Panel ID="pnlIsPacmanDiscussion" runat="server" Visible="true">
                    <div class="col-lg-3">
                        <div class="form-group">
                            <label>Select Review Stage</label>
                            <div class="input-group">
                                <div class="input-group-addon">
                                    <i class="fa fa-calendar"></i>
                                </div>
                                <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlStage" runat="server" OnSelectedIndexChanged="ddlStage_SelectedIndexChanged" AutoPostBack="true">
                                </asp:DropDownList>
                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="form-group">
                            <label>Select Reportee</label>
                            <div class="input-group">
                                <div class="input-group-addon">
                                    <i class="fa fa-user"></i>
                                </div>
                                <asp:DropDownList ItemType="text" CssClass="form-control select2" ID="ddlReportee"
                                    runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlReportee_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="form-group">
                            <label>Is SPI</label>
                            <div class="input-group">
                                <div class="input-group-addon">
                                    <i class="fa fa-user"></i>
                                </div>
                                <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlSPI" runat="server">
                                    <%--<asp:ListItem Enabled="true" Selected="True" Text="Select SPI Status" Value="2"></asp:ListItem>--%>
                                    <asp:ListItem Enabled="true" Text="False" Value="0"></asp:ListItem>
                                    <asp:ListItem Enabled="true" Text="True" Value="1"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </div>
    </div>

    <asp:Panel ID="pnlOverall" runat="server" Visible="false">
        <div class="col-md-2">
            <!-- Widget: user widget style 1 -->
            <div class="box box-widget widget-user-2">
                <!-- Add the bg color to the header using any of the bg-* classes -->
                <div class="widget-user-header bg-navy">
                    <div class="widget-user-image">                        
                        <asp:Image ID="imgbtnUserImage" CssClass="img-circle" AlternateText="User Avatar" runat="server" />
                    </div>
                    <!-- /.widget-user-image -->
                    <h3 class="widget-user-username"><asp:Label ID="lblName" runat="server"></asp:Label></h3>
                    <h5 class="widget-user-desc"><asp:Label ID="lblRole" runat="server"></asp:Label></h5>
                </div>
                <div class="box-footer no-padding">
                    <ul class="nav nav-stacked">
                        <li><a href="#">&nbsp &nbsp Rep. Mgr. Score <span class="pull-right badge bg-blue">2.5</span></a></li>                        
                        <li><a href="#">&nbsp + Grace <span class="pull-right badge bg-yellow">0.6</span></a></li>
                        <li><a href="#">&nbsp = Final Score <span class="pull-right badge bg-green">3.10</span></a></li>
                        <li><a href="#">&nbsp ~ Final Rating <span class="pull-right badge bg-green">3</span></a></li>
                    </ul>
                </div>
            </div>
            <!-- /.widget-user -->
        </div>
       

            <label>
            <asp:Literal ID="ltlOverAll" runat="server" Text="Pacman Cycle"></asp:Literal>
            </label>
            <asp:GridView ID="gvOverAll" runat="server"
                CssClass="table table-condensed table-bordered table-responsive PageSpecificDataTable"
                AutoGenerateColumns="true"
                OnPreRender="gv_PreRender">
            </asp:GridView>

       
    </asp:Panel>

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
                                                                        <asp:Literal ID="Literal5" runat="server" Text="Select rating"></asp:Literal>
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
                                                                        <asp:TextBox ID="txtManualComments" runat="server" CssClass="form-control select" TextMode="MultiLine" Rows="2" CausesValidation="false"></asp:TextBox>
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                        <asp:Label ID="lbl" Text="." runat="server"></asp:Label>
                                                                        <asp:Button ID="btnManualScoreSubmit" runat="server" Text="submit" CommandArgument='<%#Eval("KPIID") %>' CssClass="btn btn-primary" OnClick="btnManualScoreSubmit_Click" CausesValidation="false"/>
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
                    <%--<div class="chart tab-pane" id="itemized-details" style="position: relative">
                        <asp:GridView ID="tblKPI" runat="server" CssClass="table table-condensed table-bordered table-responsive"
                            AutoGenerateColumns="true">
                        </asp:GridView>

                    </div>--%>
                    <%--<div class="chart tab-pane" id="itemized-details2" style="position: relative; height: 300px;"></div>--%>
                </div>
                <div class="box-footer"></div>
            </div>
            <!-- /.nav-tabs-custom -->

            <!-- /.Left col -->
            <asp:Panel ID="pnlSubmission" runat="server" Visible="false">
                <div class="row">
                    <div class="col-md-12">
                        <!-- quick email widget -->
                        <div class="box box-info">
                            <div class="box-header">
                                <i class="fa fa-envelope"></i>
                                <h3 class="box-title">Feedback</h3>
                            </div>
                            <div class="box-body">
                                <div>
                                    <asp:TextBox ID="tbFeedback" CssClass="textarea" TextMode="MultiLine" placeholder="Feedback" runat="server" MaxLength="254"
                                        Style="width: 100%; height: 125px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfv" runat="server" ErrorMessage="Feedback is mandatory." ForeColor="Red" ControlToValidate="tbFeedback"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegExp1" runat="server"
                                        ErrorMessage="Character length should not exceed 254 characters" ForeColor="Red"
                                        ControlToValidate="tbFeedback"
                                        ValidationExpression="^.{10,254}$" />
                                </div>
                                <input type="text" style="width: 50px; border: none;" class="pull-right" readonly="readonly" disabled id="tbChLength" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div class="box">
                            <div class="box-body">
                                <div class="form-group">
                                    <h4>Has the above Reportee's PACMAN been discussed?
                 <span class="btn-group pull-right">
                     <asp:Button ID="btnAcknowledged" runat="server" Enabled="false" Text="Discussed" CssClass="btn btn-primary" OnClick="btnAcknowledged_Click" />
                 </span>
                                    </h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </asp:Panel>
        </section>
        <!-- /.Left col -->
    </div>
    <!-- /.row (main row) -->

</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">

    <!-- Bootstrap WYSIHTML5 -->
    <script src="plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js"></script>
    <script>
        $(function () {
            $("#tbFeedback").change(function () {
                $("#tbChLength").val($(this).text().length);
            });

        });

    </script>

</asp:Content>

