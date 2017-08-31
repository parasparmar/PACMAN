﻿<%@ Page Title="Movement" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="movement.aspx.cs" Inherits="movement" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
    <link href="Sitel/plugins/bootstrap-toggle/css/bootstrap-toggle.min.css" rel="stylesheet" />
</asp:Content>


<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="Summary.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="movement.aspx"><i class="fa fa-random"></i>Review Period Master</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-random"></span></div>
        <div class="pagetitle">
            <h5>Request to initiate and accept employee and team movements</h5>
            <h1>Movement</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" EnableViewState="true" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="row-fluid">
                <div class="col-md-12">
                    <!-- Custom Tabs -->
                    <div class="box box-solid box-primary" style="height: auto;">
                        <div class="box-header with-border">
                            <h4 class="box-title">Choose a Movement Type</h4>
                            <div class="box-tools pull-right">
                                <button class="btn btn-box-tool" type="button" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                            </div>
                        </div>
                        <div class="box-body">
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="input-group">
                                        <span class="input-group-addon">
                                            <asp:RadioButton ID="rdoDeptMovement" runat="server" GroupName="Movement"
                                                OnCheckedChanged="rdoDeptMovement_CheckedChanged" AutoPostBack="true" />
                                        </span>
                                        <asp:Button ID="btnDeptMovement" CssClass="btn btn-primary btn-flat" Text="Department Movement"
                                            OnClick="btnDeptMovement_Click" runat="server" />
                                    </div>
                                </div>
                                <div class="col-md-8">
                                    <div class="form-group">
                                        <div class="input-group">
                                            <span class="input-group-addon">
                                                <asp:RadioButton ID="rdoMgrMovement" runat="server" GroupName="Movement"
                                                    OnCheckedChanged="rdoMgrMovement_CheckedChanged" AutoPostBack="true" />
                                            </span>
                                            <asp:Button ID="btnMgrMovement" CssClass="btn btn-info btn-flat"
                                                Text="Reporting Manager Movement" OnClick="btnMgrMovement_Click" runat="server" />
                                        </div>
                                       <asp:Panel ID="pnlMgrActions" CssClass="span" Visible="false" runat="server">
                                        <input type="checkbox" checked runat="server" ID="cbxTransferDirection" class="checkbox2ToggleSwitch" data-toggle="toggle" data-off="Transfer In" data-on="Transfer Out" />
                                        <asp:Button ID="btnMgrPush" runat="server" CssClass="btn btn-primary btn-flat" Text="Initiate Transfer Out" OnClick="btnMgrPush_Click" />
                                        <asp:Button ID="btnMgrPull" runat="server" CssClass="btn btn-info btn-flat" Text="Request Transfer In" OnClick="btnMgrPull_Click" />
                                    </asp:Panel>
                                            
                                       
                                    </div>

                                    
                                </div>

                            </div>
                        </div>
                        <!--tabcontent-->
                    </div>
                    <!-- /.col -->
                </div>
                <div class="row-fluid">
                    <div class="col-md-12">
                        <!-- Custom Tabs -->
                        <div class="box box-solid box-primary" style="height: auto;">
                            <div class="box-header with-border">
                                <h4 class="box-title">
                                    <asp:Literal ID="ltlMovementTypeHeading" runat="server" Text="Movement Type : "></asp:Literal></h4>
                                <div class="box-tools pull-right">
                                    <button class="btn btn-box-tool" type="button" data-widget="collapse">
                                        <i class="fa fa-minus"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="box-body">
                                <div class="form-group">
                                    <div class="col-md-12">
                                        <asp:Panel ID="pnlDeptMovement" runat="server" CssClass="box-body" Visible="false">
                                            <asp:DropDownList ID="ddlFromDept" runat="server" CssClass="form-control select2" Style="width: 100%;"></asp:DropDownList>
                                            <asp:DropDownList ID="ddlToDept" runat="server" CssClass="form-control select2" Style="width: 100%;"></asp:DropDownList>
                                            <asp:DropDownList ID="ddlFromDeptMgr" runat="server" CssClass="form-control select2" Style="width: 100%;"></asp:DropDownList>
                                            <asp:DropDownList ID="ddlToDeptMgr" runat="server" CssClass="form-control select2" Style="width: 100%;"></asp:DropDownList>
                                        </asp:Panel>
                                        <!--Choose Dep and Teams---->
                                        <asp:Panel ID="pnlMgrMovement" runat="server" CssClass="box-body" Visible="false">
                                            <div class="row">
                                                <div class="col-md-5">
                                                    <asp:Label Text="From" ID="lblFromMgr" runat="server"></asp:Label>
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="ddlFromMgr" runat="server" CssClass="form-control select2" Style="width: 100%;" OnSelectedIndexChanged="ddlFromMgr_SelectedIndexChanged"
                                                            AutoPostBack="true">
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="col-md-1">
                                                    <asp:Literal ID="ltlDirection" Text="" runat="server"></asp:Literal>
                                                </div>
                                                <div class="col-md-5">
                                                    <asp:Label Text="To" ID="lblToMgr" runat="server"></asp:Label>
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="ddlToMgr" runat="server" CssClass="form-control select2" Style="width: 100%;" OnSelectedIndexChanged="ddlToMgr_SelectedIndexChanged"
                                                            OnTextChanged="ddlToMgr_SelectedIndexChanged" AutoPostBack="true">
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label>My Team</label>
                                                        <asp:GridView ID="gv_LeftHandSideTeamList" runat="server" CssClass="table table-condensed table-responsive datatable display compact hover stripe" AutoGenerateColumns="false"
                                                            OnPreRender="gv_PreRender" ShowHeader="true" Style="border: none">
                                                            <Columns>
                                                                <asp:TemplateField HeaderText="Selection">
                                                                    <ItemTemplate>
                                                                        <asp:CheckBox ID="cbMyTeamListID" CssClass="" runat="server" />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:BoundField DataField="Employee_ID" HeaderText="Employee Id" />
                                                                <asp:BoundField DataField="Name" HeaderText="Name" />
                                                                <asp:TemplateField HeaderText="Effective Date(As on)">
                                                                    <ItemTemplate>
                                                                        <asp:TextBox ID="tbEffectiveDate" CssClass="form-control datepicker" runat="server" Visible="true"></asp:TextBox>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                            <EmptyDataTemplate>
                                                                <h5>No Team Members found.</h5>
                                                            </EmptyDataTemplate>

                                                        </asp:GridView>
                                                    </div>
                                                </div>
                                                <!---LHS Team---->
                                                <div class="col-md-6">
                                                    <label>His Team</label>
                                                    <div class="form-group">
                                                        <asp:GridView ID="gv_RightHandSideTeamList" runat="server"
                                                            CssClass="table table-condensed table-responsive datatable display compact hover stripe"
                                                            AutoGenerateColumns="false"
                                                            OnPreRender="gv_PreRender" ShowHeader="true" Style="border: none">
                                                            <Columns>
                                                                <asp:TemplateField HeaderText="Selection">
                                                                    <ItemTemplate>
                                                                        <asp:CheckBox ID="cbHisTeamListID" runat="server" />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:BoundField DataField="Employee_ID" HeaderText="Employee Id" />
                                                                <asp:BoundField DataField="Name" HeaderText="Name" />
                                                                <asp:TemplateField HeaderText="Effective Date(As on)">
                                                                    <ItemTemplate>
                                                                        <asp:TextBox ID="tbEffectiveDate" CssClass="form-control datepicker" runat="server" Visible="true"></asp:TextBox>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                            <EmptyDataTemplate>
                                                                <h5>No Team Members found.</h5>
                                                            </EmptyDataTemplate>

                                                        </asp:GridView>
                                                    </div>
                                                </div>
                                                <!---RHS Team---->
                                            </div>
                                        </asp:Panel>
                                        <!--Choose Mgr Teams---->
                                    </div>
                                </div>
                            </div>
                            <div class="box-footer">
                                <div class="input-group">
                                    <span class="input-group-btn">
                                        <asp:Button ID="btnSubmitPush" runat="server" CssClass="btn btn-primary btn-flat" Text="Submit Transfer Out Request" />
                                        <asp:Button ID="btnSubmitPull" runat="server" CssClass="btn btn-info btn-flat" Text="Submit Transfer In Request" />
                                    </span>
                                </div>
                            </div>
                            <!-- /.box-footer-->
                        </div>
                        <!--tabcontent-->
                    </div>
                    <!-- /.col -->
                </div>
                <!---LHS Panel---->
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnDeptMovement" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnMgrMovement" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="rdoDeptMovement" EventName="CheckedChanged" />
            <asp:AsyncPostBackTrigger ControlID="rdoMgrMovement" EventName="CheckedChanged" />
            <asp:AsyncPostBackTrigger ControlID="ddlToMgr" EventName="SelectedIndexChanged" />
        </Triggers>
    </asp:UpdatePanel>
    
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <!-- Select2 -->
    <script src="AdminLTE/bower_components/select2/dist/js/select2.full.min.js"></script>
    <script src="Sitel/plugins/bootstrap-toggle/js/bootstrap-toggle.min.js"></script>
    <script>
        $(function () {
            //Initialize Select2 Elements
            $('.select2').select2();
            //Date picker
            $("[class*='datepicker']").datepicker({
                autoclose: true
            })
            $('.checkbox2ToggleSwitch').bootstrapToggle({
                on: 'Transfer Out',
                off: 'Transfer In'
            });


        });

        //On UpdatePanel Refresh
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        if (prm != null) {
            prm.add_endRequest(function (sender, e) {
                if (sender._postBackSettings.panelsToUpdate != null) {
                    //Initialize Select2 Elements
                    $('.select2').select2();
                    //Date picker
                    $("[class*='datepicker']").datepicker({
                        autoclose: true
                    })
                    $('.checkbox2ToggleSwitch').bootstrapToggle({
                        on: 'Transfer Out',
                        off: 'Transfer In'
                    });
                }
            });
        };
    </script>

</asp:Content>
