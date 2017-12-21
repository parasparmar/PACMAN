<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="IntervalTracker.aspx.cs" Inherits="IntervalTracker" %>


<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="index.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="IntervalTracker.aspx">
            <i class="fa fa-sliders"></i>Interval Tracker</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon">
            <span class="fa fa-sliders"></span>
        </div>
        <div class="pagetitle">
            <h5>Track & Log Performance Data <strong>Client and LOB Intervals</strong></h5>
            <h1>Interval Tracker</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <section class="content">
        <div class="box">
            <div class="box-body">
                <div class="form-group">

                    <div class="col-lg-4">
                        <label for="ddlAccount" class="col-lg-2 control-label">Select Account</label>
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-calendar-check-o"></i></span>
                            <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlAccount" runat="server">
                            </asp:DropDownList>
                        </div>
                    </div>


                    <div class="col-lg-4">
                        <label for="ddlLOB" class="col-lg-2 control-label">LOB</label>
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                            <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlLOB" runat="server">
                            </asp:DropDownList>
                        </div>
                    </div>


                    <div class="col-lg-4">
                        <label for="ddlSites" class="col-lg-2 control-label">Sites</label>
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-user"></i></span>
                            <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlSites" runat="server">
                            </asp:DropDownList>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="box">
                    <div class="box-header with-border">
                        <h3 class="box-title">Intervals for Account - LOB - Sites : </h3>
                    </div>
                    <!-- /.box-header -->
                    <div class="box-body">

                        <table class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th>Interval</th>
                                    <th>Description</th>
                                    <th>Incident Type</th>
                                    <th>Client Ticket</th>
                                    <th>Internal Ticket</th>
                                    <th>Attachment</th>
                                    <th>Save</th>
                                    <th>Edit</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>09:30 - 10.00</td>
                                    <td>Issue 1</td>
                                    <td>Client - External</td>
                                    <td>24671</td>
                                    <td>39678</td>
                                    <td>
                                        <asp:FileUpload ID="FileUpload1" runat="server" /></td>
                                    <td>
                                        <asp:Button ID="btn1" runat="server" Text="Save" CssClass="btn btn-primary" /></td>
                                    <td>
                                        <asp:Button ID="btn2" runat="server" Text="Edit" CssClass="btn btn-info" /></td>
                                </tr>
                                <tr>
                                    <td>09:30 - 10.00</td>
                                    <td>Issue 2</td>
                                    <td>Sitel - Internal</td>
                                    <td>14015</td>
                                    <td>71666</td>
                                    <td>
                                        <asp:FileUpload ID="FileUpload2" runat="server" /></td>
                                    <td>
                                        <asp:Button ID="Button1" runat="server" Text="Save" CssClass="btn btn-primary" /></td>
                                    <td>
                                        <asp:Button ID="Button2" runat="server" Text="Edit" CssClass="btn btn-info" /></td>
                                </tr>
                                <tr>
                                    <td>10:30 - 11.00</td>
                                    <td>Issue 3</td>
                                    <td>Client - External</td>
                                    <td>33712</td>
                                    <td>33520</td>
                                    <td>
                                        <asp:FileUpload ID="FileUpload3" runat="server" /></td>
                                    <td>
                                        <asp:Button ID="Button3" runat="server" Text="Save" CssClass="btn btn-primary" /></td>
                                    <td>
                                        <asp:Button ID="Button4" runat="server" Text="Edit" CssClass="btn btn-info" /></td>
                                </tr>
                                <tr>
                                    <td>10:30 - 11.00</td>
                                    <td>Issue 4</td>
                                    <td>Sitel - Internal</td>
                                    <td>55761</td>
                                    <td>21741</td>
                                    <td>
                                        <asp:FileUpload ID="FileUpload4" runat="server" /></td>
                                    <td>
                                        <asp:Button ID="Button5" runat="server" Text="Save" CssClass="btn btn-primary" /></td>
                                    <td>
                                        <asp:Button ID="Button6" runat="server" Text="Edit" CssClass="btn btn-info" /></td>
                                </tr>
                                <tr>
                                    <td>11:30 - 12.00</td>
                                    <td>Outage 1</td>
                                    <td>Client - External</td>
                                    <td>35361</td>
                                    <td>79717</td>
                                    <td>
                                        <asp:FileUpload ID="FileUpload5" runat="server" /></td>
                                    <td>
                                        <asp:Button ID="Button7" runat="server" Text="Save" CssClass="btn btn-primary" /></td>
                                    <td>
                                        <asp:Button ID="Button8" runat="server" Text="Edit" CssClass="btn btn-info" /></td>
                                </tr>
                                <tr>
                                    <td>11:30 - 12.00</td>
                                    <td>Outage 2</td>
                                    <td>Sitel - Internal</td>
                                    <td>54362</td>
                                    <td>60868</td>
                                    <td>
                                        <asp:FileUpload ID="FileUpload6" runat="server" /></td>
                                    <td>
                                        <asp:Button ID="Button9" runat="server" Text="Save" CssClass="btn btn-primary" /></td>
                                    <td>
                                        <asp:Button ID="Button10" runat="server" Text="Edit" CssClass="btn btn-info" /></td>
                                </tr>
                                <tr>
                                    <td>11:30 - 12.00</td>
                                    <td>Outage 3</td>
                                    <td>Client - External</td>
                                    <td>86282</td>
                                    <td>99255</td>
                                    <td>
                                        <asp:FileUpload ID="FileUpload7" runat="server" /></td>
                                    <td>
                                        <asp:Button ID="Button11" runat="server" Text="Save" CssClass="btn btn-primary" /></td>
                                    <td>
                                        <asp:Button ID="Button12" runat="server" Text="Edit" CssClass="btn btn-info" /></td>
                                </tr>
                                <tr>
                                    <td>11:30 - 12.00</td>
                                    <td>Outage 4</td>
                                    <td>Sitel - Internal</td>
                                    <td>73436</td>
                                    <td>16373</td>
                                    <td>
                                        <asp:FileUpload ID="FileUpload8" runat="server" /></td>
                                    <td>
                                        <asp:Button ID="Button13" runat="server" Text="Save" CssClass="btn btn-primary" /></td>
                                    <td>
                                        <asp:Button ID="Button14" runat="server" Text="Edit" CssClass="btn btn-info" /></td>
                                </tr>
                            </tbody>
                        </table>

                    </div>
                    <!-- /.box-body -->
                    <div class="box-footer clearfix">
                        <ul class="pagination pagination-sm no-margin pull-right">
                            <li><a href="#">&laquo;</a></li>
                            <li><a href="#">1</a></li>
                            <li><a href="#">2</a></li>
                            <li><a href="#">3</a></li>
                            <li><a href="#">&raquo;</a></li>
                        </ul>
                    </div>
                </div>
                <!-- /.box -->
            </div>
            <!-- /.col -->

        </div>
        <!-- /.row -->

    </section>
</asp:Content>

