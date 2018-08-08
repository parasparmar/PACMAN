<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="inputpage.aspx.cs" Inherits="inputpage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
    <!-- bootstrap wysihtml5 - text editor -->
    <link rel="stylesheet" href="AdminLTE/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css">
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <div class="row">
        <div class="col-md-12">
            <div class="box">
                <div class="box-body">
                    <div class="form-group">
                        <div class="col-lg-3">
                            <div class="form-group">
                                <label>Select Period</label>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-calendar"></i>
                                    </div>
                                    <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlPeriod" runat="server">
                                    </asp:DropDownList>

                                </div>
                                <!-- /.input group -->
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="box">
                <div class="box-header">
                    <h3 class="box-title">Input Comments               
                        <small>For Pacman related Items</small>
                    </h3>
                    <!-- tools box -->
                    <div class="pull-right box-tools">
                        <button type="button" class="btn btn-default btn-sm" data-widget="collapse" data-toggle="tooltip"
                            title="Collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                        <button type="button" class="btn btn-default btn-sm" data-widget="remove" data-toggle="tooltip"
                            title="Remove">
                            <i class="fa fa-times"></i>
                        </button>
                    </div>
                    <!-- /. tools -->
                </div>
                <!-- /.box-header -->
                <div class="box-body pad">
                    <asp:UpdatePanel ID="up1" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:GridView ID="gvInputGrid" DataKeyNames="Id" CssClass="table table-responsive table-bordered makeDataTable" runat="server" AutoGenerateColumns="false" OnPreRender="gv_PreRender" OnRowCommand="gvInputGrid_RowCommand" OnRowEditing="gvInputGrid_RowEditing" OnRowUpdating="gvInputGrid_RowUpdating">
                                <Columns>
                                    <asp:BoundField DataField="Id" HeaderText="Id" />
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <label>Comments</label>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <asp:TextBox ID="lblComments" Text='<%#Bind("Comments") %>' runat="server" CssClass="form-control" ToolTip="Edit Comments" Rows="3">
                                                    </asp:TextBox>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="btn btn-group  form-control">
                                                        <asp:LinkButton ID="lnkSaveComments" CommandName="Update" CommandArgument='<%#DataBinder.Eval(Container, "RowIndex")%>' runat="server" CssClass="btn btn-primary btn-flat btn-sm" Text="Save" OnClick="lnkSaveComments_Click">
                                                        </asp:LinkButton>
                                                    </div>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="UpdatedBy" HeaderText="Updatedby" />
                                    <asp:BoundField DataField="UpdatedOn" HeaderText="UpdatedOn" />
                                </Columns>
                            </asp:GridView>
                        </ContentTemplate>
                        
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <!-- CK Editor -->
    <script src="AdminLTE/bower_components/ckeditor/ckeditor.js"></script>
    <!-- Bootstrap WYSIHTML5 -->
    <script src="AdminLTE/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js"></script>
    <script>
        $(function () {
            pluginsInitializer();
        });
        function pluginsInitializer() {
            var table = $('[class*="makeDataTable"]').dataTable({
                destroy: true,
                "responsive": true,
                "fixedHeader": true,
                "sPaginationType": "full_numbers",
                "lengthMenu": [15, 10, 25, 50, 75],
                "aaSortingFixed": [[0, 'asc']],
                "bSort": true,
                //dom: 'Bfrltip',
                "columnDefs": [{ "orderable": false, "targets": 0 }],
            });
            $(".makeDataTable").css('width', '');
            //new $.fn.dataTable.FixedHeader(table);

            toastr.options = {
                "closeButton": true,
                "debug": false,
                "newestOnTop": false,
                "progressBar": false,
                "positionClass": "toast-top-right",
                "preventDuplicates": false,
                "onclick": null,
                "showDuration": "300",
                "hideDuration": "1000",
                "timeOut": "5000",
                "extendedTimeOut": "1000",
                "showEasing": "swing",
                "hideEasing": "linear",
                "showMethod": "fadeIn",
                "hideMethod": "fadeOut"
            }
        }
</script>
</asp:Content>

