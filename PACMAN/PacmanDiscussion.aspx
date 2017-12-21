<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="PacmanDiscussion.aspx.cs" Inherits="PacmanDiscussion" %>


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
            <h5>Discussion of Monthly Performance <strong>for my team</strong></h5>
            <h1>PACMAN Discussion</h1>
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

                <div class="col-lg-3">
                    <label for="ddlReviewPeriod" class="col-lg-2 control-label">select Review Period</label>
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-calendar-check-o"></i></span>
                        <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlReviewPeriod" runat="server">
                            <asp:ListItem Enabled="true" Selected="True" Text="December 2017" Value="01-12-2017"></asp:ListItem>
                            <asp:ListItem Enabled="true" Text="January 2018" Value="01-01-2018"></asp:ListItem>
                            <asp:ListItem Enabled="true" Text="February 2018" Value="01-02-2018"></asp:ListItem>
                            <asp:ListItem Enabled="true" Text="March 2018" Value="01-03-2018"></asp:ListItem>
                            <asp:ListItem Enabled="true" Text="April 2018" Value="01-04-2018"></asp:ListItem>
                            <asp:ListItem Enabled="true" Text="May 2018" Value="01-05-2018"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>


                <div class="col-lg-3">
                    <label for="ddlReviewStage" class="col-lg-2 control-label">Review Stage</label>
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                        <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlReviewStage" runat="server">
                            <asp:ListItem Enabled="true" Text="For Entire Team" Value="0"></asp:ListItem>
                            <asp:ListItem Enabled="true" Selected="True" Text="Discussion Pending - 5" Value="1"></asp:ListItem>
                            <asp:ListItem Enabled="true" Text="Acknowledgement Pending - 2" Value="2"></asp:ListItem>
                            <asp:ListItem Enabled="true" Text="Completed - 1" Value="3"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>


                <div class="col-lg-3">
                    <label for="inputSkills" class="col-lg-2 control-label">Reportee</label>
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-user"></i></span>
                        <asp:DropDownList ItemType="text" CssClass="form-control select" ID="DropDownList1" runat="server">
                            <asp:ListItem Enabled="true" Selected="True" Text="Paras Chandrakant Parmar" Value="931040"></asp:ListItem>
                            <asp:ListItem Enabled="true" Text="Komal Trivedi" Value="931041"></asp:ListItem>
                            <asp:ListItem Enabled="true" Text="Gurdeep Singh" Value="931042"></asp:ListItem>
                            <asp:ListItem Enabled="true" Text="Vishal Shirsat" Value="931043"></asp:ListItem>
                            <asp:ListItem Enabled="true" Text="Ashok Vishwakarma" Value="931044"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-lg-3">
                    <label for="inputSkills" class="col-lg-2 control-label">Is SPI</label>
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-user"></i></span>
                        <asp:TextBox ItemType="text" CssClass="form-control select" ID="tbIsSPI" Text="TRUE" runat="server">                            
                        </asp:TextBox>
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

                    <li class="pull-left header"><i class="fa fa-inbox"></i>Paras Chandrakant Parmar's Performance Management Cycle : December 2017 - Final Rating : 4.447</li>
                </ul>
                <div class="tab-content no-padding">
                    <!-- Morris chart - Sales -->
                    <div class="box-body tab-pane active" id="monthly-scorecard" style="position: relative; height: 300px;">
                        <table class="table table-responsive">
                            <thead>
                                <tr>
                                    <th>Metrics</th>
                                    <th>Weightage</th>
                                    <th>Fair Weightage</th>
                                    <th>Difference</th>
                                    <th>Applied Score</th>
                                    <th>Weighted % Score</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Service Levels</td>
                                    <td>20</td>
                                    <td>16.67</td>
                                    <td>3.33</td>
                                    <td>3.59</td>
                                    <td>3.710</td>
                                </tr>
                                <tr>
                                    <td>Bill To Pay</td>
                                    <td>20</td>
                                    <td>16.67</td>
                                    <td>3.33</td>
                                    <td>2.48</td>
                                    <td>2.563</td>
                                </tr>
                                <tr>
                                    <td>Coaching & Feedback</td>
                                    <td>5</td>
                                    <td>16.67</td>
                                    <td>-11.67</td>
                                    <td>3.60</td>
                                    <td>3.180</td>
                                </tr>
                                <tr>
                                    <td>Escalations</td>
                                    <td>5</td>
                                    <td>16.67</td>
                                    <td>-11.67</td>
                                    <td>5.00</td>
                                    <td>4.417</td>
                                </tr>
                                <tr>
                                    <td>Attendance</td>
                                    <td>10</td>
                                    <td>16.67</td>
                                    <td>-6.67</td>
                                    <td>5.00</td>
                                    <td>4.667</td>
                                </tr>
                                <tr>
                                    <td>Real-Time Optimizations</td>
                                    <td>40</td>
                                    <td>16.67</td>
                                    <td>23.33</td>
                                    <td>3.00</td>
                                    <td>3.700</td>
                                </tr>
                                <tr>
                                    <td>Totals</td>
                                    <td>100</td>
                                    <td>100</td>
                                    <td>0.00</td>
                                    <td>&nbsp;</td>
                                    <td><strong>4.447</strong></td>
                                </tr>
                            </tbody>
                        </table>


                    </div>
                    <div class="chart tab-pane" id="itemized-details" style="position: relative; height: 300px;"></div>
                </div>
                <div class="box-footer"></div>
            </div>
            <!-- /.nav-tabs-custom -->
        </section>
        <!-- /.Left col -->
        <!-- /.Left col -->
        <div class="col-md-6">
            <div class="box">
                <div class="box-body">
                    <div class="form-group">
                        <h4>Has the above Reportee's PACMAN been discussed?
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
                        <h4>Submit PACMAN for Employee's Acknowledgement
                 <span class="btn-group pull-right">
                     <%--<asp:Button ID="btnDoNotAgree" runat="server" Text="I Do Not Agree" CssClass="btn btn-warning" />--%>
                     <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-success" />
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

