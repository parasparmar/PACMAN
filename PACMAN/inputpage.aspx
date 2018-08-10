<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="inputpage.aspx.cs" Inherits="inputpage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
    <!-- bootstrap wysihtml5 - text editor -->
    <link rel="stylesheet" href="AdminLTE/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css">
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <div class="row">
        <div class="col-md-12">
            <div class="box">
                <div class="box-header">
                    <h3 class="box-title">Parameters               
                        <small></small>
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
                <div class="box-body">
                    <div class="form-group">
                        <div class="col-lg-2">
                            <div class="form-group">
                                <label>Select Month</label>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-calendar"></i>
                                    </div>
                                    <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlMonth" runat="server" OnSelectedIndexChanged="ddlMonth_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>
                                <!-- /.input group -->
                            </div>
                        </div>
                        <div class="col-lg-3">
                            <div class="form-group">
                                <label>Select Market</label>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-calendar"></i>
                                    </div>
                                    <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlMarket" runat="server" OnSelectedIndexChanged="ddlMarket_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>
                                <!-- /.input group -->
                            </div>
                        </div>
                        <div class="col-lg-3">
                            <div class="form-group">
                                <label>Select Facility Name</label>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-calendar"></i>
                                    </div>
                                    <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlFacility" runat="server" OnSelectedIndexChanged="ddlFacility_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>
                                <!-- /.input group -->
                            </div>
                        </div>
                        <div class="col-lg-2">
                            <div class="form-group">
                                <label>Select Account</label>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-calendar"></i>
                                    </div>
                                    <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlAccount" runat="server" OnSelectedIndexChanged="ddlAccount_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>
                                <!-- /.input group -->
                            </div>
                        </div>
                        <div class="col-lg-2">
                            <div class="form-group">
                                <label>Fetch</label>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-calendar"></i>
                                    </div>
                                    <%--<asp:LinkButton ID="btnFetch" runat="server" OnClick="btnFetch_Click" Text="Fetch" CssClass="btn btn-primary"></asp:LinkButton>--%>
                                    <input type="button" id="btnFetch" class="btn btn-primary" value="Fetch" />

                                </div>
                                <!-- /.input group -->
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="nav-tabs-custom">
        <ul class="nav nav-tabs">
            <li class="active"><a href="#tabOverall" data-toggle="tab"><span>Overall&nbsp</span></a></li>
            <li><a href="#tabComparison" data-toggle="tab">Comparison&nbsp</a></li>
            <li><a href="#tabSkill" data-toggle="tab">Additional&nbsp</a></li>

        </ul>
        <div id="tabPrintable" class="tab-content">
            <!-- /.tab-pane -->
            <div class="tab-pane" id="tabOverall">
            </div>
            <div class="tab-pane active" id="tabComparison">
                <div id="divTable" style="overflow:scroll">
                </div>
                <%--<asp:UpdatePanel ID="up1" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:GridView ID="gvInputGrid" DataKeyNames="EMPCODE" CssClass="table table-responsive table-bordered makeDataTable" runat="server" AutoGenerateColumns="false" OnPreRender="gv_PreRender" OnRowCommand="gvInputGrid_RowCommand" OnRowEditing="gvInputGrid_RowEditing" OnRowUpdating="gvInputGrid_RowUpdating">
                            <Columns>
                                <asp:BoundField DataField="EMPCODE" HeaderText="EMPCODE" />
                                <asp:BoundField DataField="NAME" HeaderText="NAME" />
                                <asp:BoundField DataField="MARKET" HeaderText="MARKET" />
                                <asp:BoundField DataField="FACILITY NAME" HeaderText="FACILITY NAME" />
                                <asp:BoundField DataField="ACCOUNT" HeaderText="ACCOUNT" />
                                <asp:BoundField DataField="W@H" HeaderText="W@H" />
                                <asp:BoundField DataField="KRONOS HRS" HeaderText="KRONOS HRS" />
                                <asp:BoundField DataField="OVERTIME HRS" HeaderText="OVERTIME HRS" />
                                <asp:BoundField DataField="BO HRS" HeaderText="BO HRS" />
                                <asp:BoundField DataField="IN BOOST" HeaderText="IN BOOST" />
                                <asp:BoundField DataField="IN KRONOS" HeaderText="IN KRONOS" />
                                <asp:BoundField DataField="IN BO" HeaderText="IN BO" />
                                <asp:TemplateField ControlStyle-Width="150">
                                    <HeaderTemplate>
                                        <label>Comments</label>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <div class="row">
                                            <div>
                                                <asp:TextBox ID="lblComments" Width="130" Text='<%#Bind("Comments") %>' runat="server" CssClass="form-control" ToolTip="Edit Comments" Rows="3">
                                                </asp:TextBox>
                                            </div>
                                            <div>
                                                <div class="btn btn-group  form-control">
                                                    <asp:LinkButton ID="lnkSaveComments" Width="20" CommandName="Update" CommandArgument='<%#DataBinder.Eval(Container, "RowIndex")%>' runat="server" CssClass="btn btn-primary btn-flat btn-sm" Text="Save" OnClick="lnkSaveComments_Click">
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

                </asp:UpdatePanel>--%>
            </div>
            <!-- /.tab-pane -->
            <div class="tab-pane" id="tabSkill">
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="box">
                <div class="box-header">
                </div>
                <!-- /.box-header -->
                <div class="box-body pad" style="overflow-x: scroll;">
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hfNTID" runat="server" />
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

        $("#btnFetch").click(function () {
            
            //var repObj = {
            //    xMonth: $("#ddlMonth option:selected").val(),
            //    xMarket: $("#ddlMarket option:selected").val(),
            //    xFacility: $("#ddlFacility option:selected").val(),
            //    xAccount: $("#ddlAccount option:selected").val(),
            //};

            $.ajax({
                url: "inputpage.aspx/GetData",
                //data: JSON.stringify(repObj),
                data: "{ 'xMonth': '" + $("#ddlMonth option:selected").val() + "', 'xMarket': '" + $("#ddlMarket option:selected").val() + "', 'xFacility': '" + $("#ddlFacility option:selected").val() + "', 'xAccount': '" + $("#ddlAccount option:selected").val() + "'}",
                type: "POST",
                async: false,
                contentType: "application/json;charset=utf-8",
                //dataType: "json",
                success: function (result) {
                    
                    BindDataTable(result.d);
                },
                error: function (errormessage) {
                    
                    alert(errormessage.responseText);

                }
            });

        });

        var BindDataTable = function (response) {
            
            $("#divTable").show();
            $("#divTable").html("");
            $("#divTable").html(response);
            //var table =
            $("#MyDataTable").DataTable({
                //dom: 'Bfrtip',
                "bDestroy": true,
                
                responsive: true,
                
            });

            $('#MyDataTable > thead > tr > th:eq(10)').hide();
            $('#MyDataTable > thead > tr > th:eq(11)').hide();

            if ($('#MyDataTable > tbody > tr').length > 0) {
                debugger;
                $('#MyDataTable > tbody > tr').each(function () {
                    //alert($(this).html());
                    var xEmpCode = $(this).find('td:eq(0)').html();
                    var xMonth = $("#ddlMonth option:selected").val();
                    //$(this).find('td:eq(12)').css("color","#fff");
                    var comments = $(this).find('td:eq(12)').text();
                    $(this).find('td:eq(12)').text("");
                    $(this).find('td:eq(12)').append('<textarea id="btn' + xEmpCode + '" style="width: 136px; height: 43px;resize:none;">' + comments + '</textarea><input style="float:right;width:50px;height:25px;" type="button" value="Save" empcode="' + xEmpCode + '" month="' + xMonth + '" onClick="xSave(this);">');
                    $(this).find('td:eq(12)').append('<DIV style="color:#fff;">' + comments + '</DIV>');
                    $(this).find('td:eq(10)').hide();
                    $(this).find('td:eq(11)').hide();
                });
                    
            }


        }

        function xSave(xThis) {
            var empcode = $(xThis).attr("empcode");
            var month = $(xThis).attr("month");
            var comments = $("#btn" + empcode).val();
            var updatedby = $("#hfNTID").val();

            $.ajax({
                url: "inputpage.aspx/SaveComments",
                //data: JSON.stringify(repObj),
                data: "{ 'empcode': '" + empcode + "', 'month': '" + month + "', 'comments': '" + comments + "'}",
                type: "POST",
                async: false,
                contentType: "application/json;charset=utf-8",
                //dataType: "json",
                success: function (result) {
                    debugger;
                    $(xThis).parent().parent().find('td:eq(13)').html("");
                    $(xThis).parent().parent().find('td:eq(13)').html(updatedby);

                    $(xThis).parent().parent().find('td:eq(14)').html("");
                    $(xThis).parent().parent().find('td:eq(14)').html(result.d);


                    $(xThis).parent().text(comments).append('<textarea id="btn' + empcode + '" style="width: 136px; height: 43px;resize:none;">' + comments +'</textarea><input style="float:right;width:50px;height:25px;" type="button" value="Save" empcode="' + empcode + '" month="' + month + '" onClick="xSave(this);">');
                    //$(xThis).parent().css("color", "#fff");
                },
                error: function (errormessage) {
                    alert(errormessage.responseText);
                }
            });

            
        }



    </script>
</asp:Content>

