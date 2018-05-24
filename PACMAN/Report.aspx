<%@ Page Title="My PACMAN" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Report.aspx.cs" Inherits="Report" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
</asp:Content>


<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="Summary.aspx"><i class=""></i>Home</a></li>
        <li class="active"><a href="/PMS_ReviewMaster.aspx"><i class="fa fa-list-alt"></i>Employee Report</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-list-alt"></span></div>
        <div class="pagetitle">
            <h5>View Employee Report</h5>
            <h1>Employee Report</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
     
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" EnableViewState="true" UpdateMode="Conditional">
        <ContentTemplate>

            <div class="box box-solid box-primary">
         <div class="box-header ui-sortable-handle">
             <h5 class="box-title">Select Pacman Cycle</h5>
             <div class="pull-right box-tools">
                 <button class="btn btn-primary btn-sm" type="button" data-widget="collapse">
                     <i class="fa fa-minus"></i>
                 </button>
             </div>
         </div>
        <div class="box-body">
            <div class="form-group">
                <div class="col-lg-6">
                    <div class="form-group">
<%--                        <label>Select Pacman Cycle</label>--%>
                        <div class="input-group">
                            <div class="input-group-addon">
                                <i class="fa fa-calendar-check-o"></i>
                            </div>
                            <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlPeriod" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlPeriod_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                        <!-- /.input group -->
                    </div>
                </div>
                </div>
            </div>
         </div>


            <%--<div class="box">--%>
            <%--<div class="row-fluid">--%>
                <%--<div class="col-md-12">--%>
                    <!-- Custom Tabs -->
                    <div class="box box-solid box-primary" style="height: auto;">
                        <div class="box-header with-border">
                            <h4 class="box-title">Employee Report</h4>
<%--                           <div class="box-tools pull-right">
                                <button class="btn btn-box-tool" type="button" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                            </div>--%>
                        </div>
                        <div class="box-body">
                            <div class="form-group">
                                <asp:GridView ID="gv_EmpList" runat="server" CssClass=" DataTable table table-condensed table-responsive datatable display compact hover stripe" AutoGenerateColumns="false"
                                    OnPreRender="gv_PreRender" ShowHeader="true" Style="border: none">
                                    <Columns>
                                        <asp:BoundField DataField="EmpCode" HeaderText="Emp_ID" />
                                        <asp:BoundField DataField="Name" HeaderText="Name" />
                                        <%--<asp:BoundField DataField="SkillSet" HeaderText="SkillSet" />--%>
                                        <asp:BoundField DataField="Role" HeaderText="Role" />
                                        <asp:BoundField DataField="RepMgrName" HeaderText="RepMgr" />
                                        <asp:BoundField DataField="RepMgrScore" HeaderText="RepMgr Score" />
                                        <asp:BoundField DataField="RepMgrRating" HeaderText="RepMgr Rating" />
                                        <asp:BoundField DataField="Grace" HeaderText="Grace" />
                                        <asp:BoundField DataField="FinalScore" HeaderText="Final Score" />
                                        <asp:BoundField DataField="FinalRating" HeaderText="Final Rating" />
                                        <asp:BoundField DataField="IsSPI" HeaderText="IsSPI" />
                                        <asp:BoundField DataField="IsDefault" HeaderText="IsDefault" />
                                        <asp:BoundField DataField="DefaultRatingComments" HeaderText="Default Comments" />                                       
                                        <asp:BoundField DataField="Status" HeaderText="Status" />
                                        
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <h5>No Report generated.</h5>
                                    </EmptyDataTemplate>

                                </asp:GridView>
                           <%-- </div>--%>
                        <%--</div>--%>
                    <%--</div>--%>
                    <!--tabcontent-->
                </div>
                <!-- /.col -->
            </div>
                </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="ddlPeriod" EventName="SelectedIndexChanged" />
        </Triggers>
    </asp:UpdatePanel>
<%--    <asp:Panel ID="pnlModal" runat="server" CssClass="modal modal-primary fade" Visible="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body">
                    <p>
                        <asp:Label ID="lblResult" runat="server"></asp:Label>&hellip;
                    </p>
                </div>
                <div class="modal-footer">
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </asp:Panel>--%>

</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
</asp:Content>