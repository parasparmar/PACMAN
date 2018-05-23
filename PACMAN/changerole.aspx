<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="changerole.aspx.cs" Inherits="changerole" %>


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
        <li class="active"><a href="PacmanDiscussion.aspx"><i class="fa fa-film"></i>Change Role</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-film"></span></div>
        <div class="pagetitle">
            <h5>Assign & Change roles for your team for this PACMAN cycle</h5>
            <h1>Change Role</h1>
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

                <div class="col-lg-3">
                    <div class="form-group">
                        <label>Select New Role</label>
                        <div class="input-group">
                            <div class="input-group-addon">
                                <i class="fa fa-calendar"></i>
                            </div>
                            <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlRole" runat="server" OnSelectedIndexChanged="ddlRole_SelectedIndexChanged" AutoPostBack="true">
                                <asp:ListItem Value="0" Text="-- Please Select --"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <!-- /.input group -->
                    </div>
                </div>

                <div class="col-lg-3">
                    <div class="form-group">
                        <label>Submit Role Change for Selected Employees</label>
                        <div class="input-group">
                            <div class="input-group-addon">
                                <i class="fa fa-film"></i>
                            </div>
                            <asp:Button CssClass="btn btn-primary btn-flat form-control" ID="btnRolechangeSubmit" Text="Submit Role Change" runat="server" OnClick="btnRolechangeSubmit_Click"></asp:Button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Main row -->
    <div class="row">
        <!-- Left col -->
        <section class="col-lg-12 connectedSortable">
            <div class="row">
                <div class="col-md-12">
                    <div class="box">
                        <div class="box-header">
                            <h4 class="box-title">
                                <asp:Literal ID="ltlRoleTitle" runat="server"></asp:Literal></h4>
                        </div>
                        <div class="box-body">
                            <asp:GridView ID="gvTeam" runat="server" DataKeyNames="EligibilityID"
                                CssClass="table table-condensed table-bordered table-striped table-hover table-responsive DataTable" AutoGenerateColumns="false" OnPreRender="gv_PreRender">
                                <Columns>
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="cbSelectAllEmpID" Text="" runat="server" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="cbEmpID" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="EmpCode" HeaderText="EmpCode" />
                                    <asp:BoundField DataField="Name" HeaderText="Name" />
                                    <asp:BoundField DataField="Role" HeaderText="Role" />
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:TextBox ID="tbMsg" runat="server" CssClass="form-control" Width="100%"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="EligibilityID" HeaderText="Eligibility ID" ItemStyle-ForeColor="White" HeaderStyle-ForeColor="White"/>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>

        </section>
        <!-- /.Left col -->
        <!-- /.Left col -->

    </div>
    <!-- /.row (main row) -->

</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">

    <!-- Bootstrap WYSIHTML5 -->
    <script src="plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js"></script>
    <script>
        function pluginsInitializer() {
            $('.Datatable').DataTable({
                "sPaginationType": "full_numbers",
                "lengthMenu": [100, 5, 10, 25, 50, 75],
                "aaSortingFixed": [[0, 'asc']],
                "bSort": true,
                //dom: 'Bfrltip',
                "columnDefs": [{ "orderable": false, "targets": 0 }],
            });

            $("#cbSelectAllEmpID").click(function () {
                var isChecked = $(this).prop("checked");
                var cb = $('[id*="cbEmpID"]');
                if (isChecked) {
                    cb.each(function () {
                        $(this).prop('checked', true);
                    });
                } else {
                    cb.each(function () {
                        $(this).prop('checked', false);
                    });
                }
            });
        }


        $(function () {
            pluginsInitializer();
        });



        //On UpdatePanel Refresh
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        if (prm != null) {
            prm.add_endRequest(function (sender, e) {
                if (sender._postBackSettings.panelsToUpdate != null) {
                    pluginsInitializer();


                }
            });
        };

    </script>

</asp:Content>

