<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="EscalationsInitiatives.aspx.cs" Inherits="EscalationsInitiatives" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
   <%-- <link href="Sitel/plugins/bootstrap-toggle/css/bootstrap-toggle.min.css" rel="stylesheet" />
    <!-- iCheck for checkboxes and radio inputs -->
    <link rel="stylesheet" href="AdminLTE/plugins/iCheck/all.css">--%>
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

        .border-between > [class*='col-']:first-child:before {
            display: none;
        }

        span.radio {
            padding: 0px;
        }

            span.radio > input[type="radio"] {
                margin: 0px -5px 7px 0px;
            }

            span.radio > label {
                /*float: left;*/
                margin-right: 20%; /*5px;*/
                /*padding: 0px 5px 0px 10px;*/
            }
    </style>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="index.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="movement.aspx"><i class="fa fa-line-chart"></i>Escalations & Initiatives</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-line-chart"></span></div>
        <div class="pagetitle">
            <h5>Listing of Escalations raised against an employee and Initiatives taken by an employee</h5>
            <h1>Escalations & Initiatives</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <%-- <asp:UpdatePanel ID="UpdatePanel1" runat="server" EnableViewState="true" UpdateMode="Conditional">
        <ContentTemplate>--%>
    <!-- Pending Transfers List -->
    <div class="box box-primary">
        <%--        <div class="box-header">
            <i class="fa fa-flag"></i>
            <h3 class="box-title">Actions</h3>
            <div class="box-tools pull-right">
            </div>
        </div>--%>
        <!-- /.box-header -->
        <div class="box-body">
            <div class="form-group">
                <label for="ddlSelectEmployee" class="col-lg-2 control-label">Select Employee</label>
                <div class="col-lg-4">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-user"></i></span>
                        <asp:DropDownList ID="ddlSelectEmployee" ItemType="text" CssClass="form-control select" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSelectEmployee_SelectedIndexChanged">
                            <asp:ListItem Selected="True" Text="None" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                </div>

                <label for="ddlPacmanCycle" class="col-lg-2 control-label">select Pacman Cycle</label>
                <div class="col-lg-4">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-calendar-check-o"></i></span>
                        <asp:DropDownList ID="ddlPacmanCycle" ItemType="text" CssClass="form-control select" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlPacmanCycle_SelectedIndexChanged">
                            <asp:ListItem Selected="True" Text="None" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>
        </div>
        <!-- /.box-body -->
        <%--        <div class="box-footer clearfix no-border">
        </div>--%>
    </div>
    <!-- /.box -->
    <!-- Completed Transfers List -->

    <%--    <div class="box">--%>
    <%--<div class="box-header">
            <i class="fa fa-flag-checkered"></i>
            <h3 class="box-title">Completed Transfers</h3>
            <div class="box-tools pull-right">
            </div>
        </div>--%>
    <!-- /.box-header -->
    <div class="row">
        <div class="col-lg-6">
            <div class="box box-solid box-danger">
                <div class="box-header">
                    <i class="fa fa-warning"></i>
                    <h3 class="box-title">Escalations</h3>
                    <h3 class="box-title pull-right">Score:
                                <asp:Label ID="lblEscalationScoreTop" runat="server"></asp:Label></h3>
                </div>
                <div class="box-body">
                    <div class="form-group">
                        <div class="radio">
                            <div class="col-lg-12">
                                <asp:RadioButtonList ID="rbEscalation" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" CssClass="radio">
                                    <asp:ListItem Text="Internal" Value="Internal"></asp:ListItem>
                                    <asp:ListItem Text="Operations" Value="Operations"></asp:ListItem>
                                    <asp:ListItem Text="Client" Value="Client"></asp:ListItem>
                                </asp:RadioButtonList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Display="Dynamic" ErrorMessage="Select a category" ForeColor="Red" ControlToValidate="rbEscalation" ValidationGroup="Escalation"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>
                    <asp:TextBox ID="txtEscalation" TextMode="multiline" Columns="74" Rows="4" runat="server" CssClass="form-control" placeholder="Enter Escalation..."></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="Dynamic" ErrorMessage="Escalation Description required" ForeColor="Red" ControlToValidate="txtEscalation" ValidationGroup="Escalation"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" Display="Dynamic" ControlToValidate="txtEscalation" ErrorMessage="enter valid reason" ForeColor="Red" ValidationExpression="^[a-zA-Z0-9 ]+$" ValidationGroup="Escalation"></asp:RegularExpressionValidator>
                    <br />
                    <div class="pull-left" style="margin-top: 1%">
                        <asp:FileUpload ID="FileUploadAttachMailEsc" runat="server"  accept=".msg" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" Display="Dynamic" ErrorMessage="Escalation Mail required" ForeColor="Red" ControlToValidate="FileUploadAttachMailEsc" ValidationGroup="Escalation"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidatorAttachment" ValidationExpression="([a-zA-Z0-9\s_\\.\-:])+(.msg)$"

    ControlToValidate="FileUploadAttachMailEsc" runat="server" ForeColor="Red" ErrorMessage="Please select a valid mail file."

    Display="Dynamic" />

                    </div>

                    <div class="pull-right">
                        <%--<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>--%>
                        <asp:Button ID="btnDiscardEsc" runat="server" Text="Discard" CssClass="btn btn-default" OnClick="btnDiscardEsc_Click" />
                        &nbsp
                        <asp:Button ID="btnSaveEsc" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btnSaveEsc_Click" ValidationGroup="Escalation" />
                    </div>

                    <br>
                    <br>
                    <br>

                    <div class="box box-danger">
                        <div class="box-header">
                            <h3 class="box-title">Escalation List</h3>
                        </div>
                        <!-- /.box-header -->
                        <div class="box-body table-responsive no-padding">

                            <asp:GridView ID="gvEscalationlog" runat="server" CssClass="table table-bordered table-hover" AutoGenerateColumns="false" ShowHeaderWhenEmpty="true" ><%--OnPreRender="gv_PreRender"--%>
                                <Columns>
                                    <asp:BoundField DataField="Category" HeaderText="Escalation Category"></asp:BoundField>
                                    <asp:BoundField DataField="Description" HeaderText="Description"></asp:BoundField>
                                    <asp:TemplateField HeaderText="Attachment">
                                   <ItemTemplate>
                                       <asp:LinkButton ID="lbDownload" Text="download" CommandArgument='<%# Eval("Attachment") %>' runat="server" OnClick="lbDownload_Click"></asp:LinkButton>
                                   </ItemTemplate>
                               </asp:TemplateField>
                                    <asp:BoundField DataField="Wtg" HeaderText="Penalty"></asp:BoundField>
                                </Columns>
                                <EmptyDataTemplate>No Record Available</EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                        <!-- /.box-body -->
                    </div>
                    <!-- /.box -->

                </div>
                <div class="box-footer">
                    <h3 class="box-title pull-right">Score:
                                <asp:Label ID="lblEscalationScoreBottom" runat="server"></asp:Label></h3>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="box box-solid box-success">
                <div class="box-header">
                    <i class="fa fa-lightbulb-o"></i>
                    <h3 class="box-title">Initiatives</h3>
                    <h3 class="box-title pull-right">Score:
                                <asp:Label ID="lblInitiativeScoreTop" runat="server"></asp:Label>
                    </h3>
                </div>
                <div class="box-body">
                    <div class="form-group">
                        <div class="radio">
                            <div class="col-lg-12">
                                <asp:RadioButtonList ID="rbInitiative" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" CssClass="radio">
                                    <asp:ListItem Text="Internal" Value="Internal"></asp:ListItem>
                                    <asp:ListItem Text="Operations" Value="Operations"></asp:ListItem>
                                    <asp:ListItem Text="Client" Value="Client"></asp:ListItem>
                                </asp:RadioButtonList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" Display="Dynamic" ErrorMessage="Select a category" ForeColor="Red" ControlToValidate="rbInitiative" ValidationGroup="Initiative"></asp:RequiredFieldValidator>

                            </div>
                        </div>
                    </div>
                    <asp:TextBox ID="txtInitiative" TextMode="multiline" Columns="74" Rows="4" runat="server" CssClass="form-control" placeholder="Enter Initiative..."></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" Display="Dynamic" ErrorMessage="Initiative Description required" ForeColor="Red" ControlToValidate="txtInitiative" ValidationGroup="Initiative"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" Display="Dynamic" ControlToValidate="txtInitiative" ErrorMessage="enter valid reason" ForeColor="Red" ValidationExpression="^[a-zA-Z ]+$" ValidationGroup="Initiative"></asp:RegularExpressionValidator>
                    <br />
                    <div class="pull-left" style="margin-top: 1%">
                        <asp:FileUpload ID="FileUploadAttachMailIni" runat="server"  accept=".msg" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" Display="Dynamic" ErrorMessage="Email-Attachment is required." ForeColor="Red" ControlToValidate="FileUploadAttachMailIni" ValidationGroup="Initiative"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator3" ValidationExpression="([a-zA-Z0-9\s_\\.\-:])+(.msg)$"

    ControlToValidate="FileUploadAttachMailIni" runat="server" ForeColor="Red" ErrorMessage="Please select a valid mail file."

    Display="Dynamic" />
                    </div>

                    <div class="pull-right">
                        <%--                                <button type="button" class="btn btn-default" data-dismiss="modal">Discard</button>--%>
                        <asp:Button ID="btnInDiscard" runat="server" Text="Discard" CssClass="btn btn-default" OnClick="btnInDiscard_Click" />
                        &nbsp
                        <asp:Button ID="btnSaveIni" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btnSaveIni_Click" ValidationGroup="Initiative" />
                    </div>
                    <br>
                    <br>
                    <br>

                    <div class="box  box-success">
                        <div class="box-header">
                            <h3 class="box-title">Initiatives List</h3>
                        </div>
                        <!-- /.box-header -->
                        <div class="box-body table-responsive no-padding">
                            <asp:GridView ID="gvInitiativeLog" runat="server" CssClass="table table-bordered table-hover " AutoGenerateColumns="false" ShowHeaderWhenEmpty="true" ><%--OnPreRender="gv_PreRender"DataTable--%>
                                <Columns>
                                    <asp:BoundField DataField="Category" HeaderText="Initiative Category"></asp:BoundField>
                                    <asp:BoundField DataField="Description" HeaderText="Description"></asp:BoundField>
                                    <asp:TemplateField HeaderText="Attachment">
                                   <ItemTemplate>
                                       <asp:LinkButton ID="lbDownload" Text="download" CommandArgument='<%# Eval("Attachment") %>' runat="server" OnClick="lbDownload_Click"></asp:LinkButton>
                                   </ItemTemplate>
                               </asp:TemplateField>
                                    <asp:BoundField DataField="Wtg" HeaderText="Points"></asp:BoundField>
                                </Columns>
                                <EmptyDataTemplate>No Record Available</EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                        <!-- /.box-body -->
                    </div>
                    <!-- /.box -->

                </div>
                <div class="box-footer">
                    <h3 class="box-title pull-right">Score:
                                <asp:Label ID="lblInitiativeScoreBottom" runat="server"></asp:Label></h3>
                    </h3>
                </div>
            </div>
        </div>
    </div>


    <%--    <div class="box-body">



    </div>--%>
    <!-- /.box-body -->
    <div class="box-footer clearfix no-border">
        <div class="box box-primary">
            <h3>Total combined score for Escalation and Initiative is
                <asp:Label ID="lblTotalScore" runat="server"></asp:Label></h3>
        </div>
    </div>
    <%--    </div>

    <!-- /.box -->


    --%>
    <%--</ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnDiscardEsc" />

</Triggers>

    </asp:UpdatePanel>--%>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <!-- Select2 -->
    <script src="AdminLTE/bower_components/select2/dist/js/select2.full.min.js"></script>
    <script src="Sitel/plugins/bootstrap-toggle/js/bootstrap-toggle.min.js"></script>
    <script>
        //Date picker
        //$(document).ready(function () {
        //    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);

        //    function EndRequestHandler(sender, args) {
        //        $('#tbEffectiveDate').datepicker({ dateFormat: 'dd-mm-yy' });
        //    }

        //    //$.ajax({
        //    //    url: "MailUploadHandler.ashx",
        //    //    type: "POST",
        //    //    data: data,
        //    //    contentType: false,
        //    //    processData: false,
        //    //    success: function (result) {
        //    //        alert(result);
        //    //        location.reload();
        //    //    },
        //    //    error: function (err) { alert(err.statusText) }
        //    //});

        //});
    </script>
    <script>
        //function pluginsInitializer() {
        //    $('.select2').select2({

        //    });

        //}


        //$(function () {
        //    pluginsInitializer();
        //});

        ////On UpdatePanel Refresh
        //var prm = Sys.WebForms.PageRequestManager.getInstance();
        //if (prm != null) {
        //    prm.add_endRequest(function (sender, e) {
        //        if (sender._postBackSettings.panelsToUpdate != null) {
        //            pluginsInitializer();
        //        }
        //    });
        //};


    </script>

</asp:Content>

