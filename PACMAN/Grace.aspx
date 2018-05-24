<%@ Page Title="My PACMAN" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Grace.aspx.cs" Inherits="Grace" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
</asp:Content>


<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="Summary.aspx"><i class=""></i>Home</a></li>
        <li class="active"><a href="PMS_ReviewMaster.aspx"><i class="fa fa-list-alt"></i>Grace</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon">
            <img src="Sitel/img/grace1.png" height="65" />
        </div>
        <div class="pagetitle">
            <h5>View Grace</h5>
            <h1>Grace</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <asp:UpdatePanel ID="upnlOne" runat="server" UpdateMode="Always">
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
                                <%--<label>Select Pacman Cycle</label>--%>
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

            <div class="box box-solid box-primary" style="height: auto;">
                <div class="box-header with-border">
                    <h4 class="box-title">Grace</h4>
                    <%--                    <div class="box-tools pull-right">
                        <button class="btn btn-box-tool" type="button" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>--%>
                </div>
                <div class="box-body">
                    <asp:GridView ID="gvEmpList" runat="server" CssClass=" DataTable table table-condensed table-responsive 
                    datatable display compact hover stripe"
                        AutoGenerateColumns="false"
                        OnPreRender="gv_PreRender" ShowHeader="true" BorderStyle="None" OnRowCommand="gvEmpList_RowCommand" DataKeyNames="EmpCode">
                        <Columns>
                            <asp:BoundField DataField="EmpCode" HeaderText="Emp_ID" />
                            <asp:BoundField DataField="Name" HeaderText="Name" />
                            <asp:BoundField DataField="Role" HeaderText="Role" />
                            <asp:BoundField DataField="RepMgrName" HeaderText="RepMgr" />
                            <asp:BoundField DataField="RepMgrScore" ItemStyle-CssClass="rms" HeaderText="RepMgr Score" />
                            <asp:BoundField DataField="RepMgrRating" HeaderText="RepMgr Rating" />
                            <asp:TemplateField HeaderText="Grace">
                                <ItemTemplate>
                                    <span class="form-group">
                                        <span class="input-group">
                                            <asp:TextBox ID="tbGrace" CssClass="form-control flat sm grace" runat="server" Text='<%#Bind("Grace")%>'></asp:TextBox>
                                            <span class="input-group-addon">
                                                <asp:ImageButton ID="ibGrace" ImageUrl="~/Sitel/img/grace1.png" CommandName="Grace" CommandArgument='<%# Eval("EmpCode") %>'
                                                    runat="server" Height="20px" />
                                            </span>
                                        </span>
                                        <label id="lblGrace" class="grace"></label>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="FinalScore" ItemStyle-CssClass="fs" HeaderText="Final Score" />
                            <asp:BoundField DataField="FinalRating" ItemStyle-CssClass="fr" HeaderText="Final Rating" />
                            <asp:BoundField DataField="IsSPI" HeaderText="IsSPI" />
                            <asp:BoundField DataField="IsDefault" HeaderText="IsDefault" />
                            <asp:BoundField DataField="DefaultRatingComments" HeaderText="Default Comments" />
                            <asp:BoundField DataField="Status" HeaderText="Status" />
                        </Columns>
                        <EmptyDataTemplate>
                            <h5>No Report generated.</h5>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>

        </ContentTemplate>
        <Triggers>
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <script>
        function pluginsInitializer() {

            $('input[class*="grace"]').change(function () {
                var tbGrace = $(this);
                var btnGrace = $(this).parent().find('#ibGrace');
                btnGrace.removeAttr("disabled");
                //alert(btnGrace.attr('id'));
                var value = parseFloat(tbGrace.val());
                var RepMgrScore = parseFloat(tbGrace.closest("tr").find(".rms").text());
                var FinalScore = parseFloat(tbGrace.closest("tr").find(".fs").text());

                var parentFormGroup = tbGrace.parents(".form-group").eq(0);
                var lblGrace = parentFormGroup.find("#lblGrace");
                var message = "";
                if (value) {
                    if (value < 0 || value > 5) {
                        value = Math.round(value).toFixed(2);
                        tbGrace.val(value);
                        message = "A valid Grace should lie between 0 and 5";
                        parentFormGroup.addClass("has-error");
                        btnGrace.attr('disabled', 'disabled');
                        //tbGrace.val(0);
                    } else if (value >= 0 && value <= 5) {
                        message = "";
                        parentFormGroup.removeClass("has-error");
                        parentFormGroup.addClass("has-success");
                    }
                } else {
                    message = "";

                    parentFormGroup.removeClass("has-error");
                }

                if (value >= 0 && value <= 5) {
                    if (value + RepMgrScore > 5) {
                        message = "A valid Grace should not elevate the Final Score beyond 5";
                        parentFormGroup.addClass("has-error");
                        btnGrace.attr('disabled', 'disabled');
                    } else {
                        tbGrace.closest("tr").find(".fs").text((value + RepMgrScore).toFixed(2));
                        tbGrace.closest("tr").find(".fr").text(Math.round(value + RepMgrScore));
                    }
                }
                lblGrace.text(message);
            })
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
