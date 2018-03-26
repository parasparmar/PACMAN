


<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ExceptionTracker.aspx.cs" Inherits="ExceptionTracker" %><%--CodeFile="IntervalTracker.aspx.cs" Inherits="IntervalTracker"--%>


<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="index.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="IntervalTracker.aspx">
            <i class="fa fa-exclamation-circle"></i>Interval Tracker</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon">
            <span class="fa fa-exclamation-circle"></span>
        </div>
        <div class="pagetitle">
            <h5>Track & Log Performance Data <strong>Client and LOB Intervals</strong></h5>
            <h1>Exception Tracker</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <section class="content">
        <div class="box box-primary">
            <div class="box-body">
                <div class="row">
                    <div class="col-lg-4">
                        <div class="form-group">
                            <label>Select Account</label>
                            <div class="input-group">
                                <span class="input-group-addon"><i class="fa fa-circle"></i></span>
                                <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlExceptionAccount" runat="server" OnSelectedIndexChanged="ddlExceptionAccount_SelectedIndexChanged" AutoPostBack="true">
                                </asp:DropDownList>
                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="form-group">
                            <label>Select LOB</label>
                            <div class="input-group">
                                <span class="input-group-addon"><i class="fa fa-circle"></i></span>
                                <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlExceptionLOB" runat="server">
                                </asp:DropDownList>
                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="form-group">
                            <label>Select KPI</label>
                            <div class="input-group">
                                <span class="input-group-addon"><i class="fa fa-circle"></i></span>
                                <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlExceptionKPI" runat="server">
                                </asp:DropDownList>
                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>
                    
                </div>

                <div class="row">

                    <div class="col-lg-4">
                        <div class="form-group">
                            <label>Month</label>
                            <div class="input-group">
                                <span class="input-group-addon"><i class="fa fa-circle"></i></span>
                                <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlMonth" runat="server">
                                            
                                </asp:DropDownList>
                                </div>
                            </div>
                            <!-- /.input group -->
                        </div>
                    

                    <div class="col-lg-4">
                        <div class="form-group">
                            <label>Date</label>
                            <asp:CheckBox ID="cbDate" runat="server"  OnCheckedChanged="cbDate_CheckedChanged" AutoPostBack="true"/>
                            <div class="input-group">
                                <span class="input-group-addon"><i class="fa fa-circle"></i></span>
                                <asp:TextBox ID="tbDate" CssClass="form-control datepicker" runat="server" Enabled="false"></asp:TextBox>
                                <%--<asp:TextBox runat="server" ID="txtIssue" CssClass="form-control select" TextMode="MultiLine" Rows="2"/>--%><%----%>
                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" Display="Dynamic" ErrorMessage="Issue Description is required" ForeColor="Red" ControlToValidate="txtIssue" ValidationGroup="downtime"></asp:RequiredFieldValidator>--%>

                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>
                    
                    <div class="col-lg-4">
                        <div class="form-group">
                            <label>Intervals</label>
                            <asp:CheckBox ID="cbInterval" runat="server" AutoPostBack="true" OnCheckedChanged="cbInterval_CheckedChanged"/>
                            <div class="input-group">
                                <span class="input-group-addon"><i class="fa fa-circle"></i></span>
                                <div class="row">
                                    <div class="col-lg-6">
                                <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlFromInterval" runat="server" AutoPostBack="true" Enabled="false">
<%--                                    <asp:ListItem Enabled="true" Selected="True" Text="From" Value="0"></asp:ListItem>
                                <asp:ListItem Enabled="true" Text="00:00" Value="1"></asp:ListItem>
                                <asp:ListItem Enabled="true" Text="01:00" Value="2"></asp:ListItem>--%>
                                </asp:DropDownList>
</div>
<div class="col-lg-6">
                                <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlToInterval" runat="server" AutoPostBack="true" Enabled="false">
                                 <%--   <asp:ListItem Enabled="true" Selected="True" Text="To" Value="0"></asp:ListItem>
                                <asp:ListItem Enabled="true" Text="00:00" Value="1"></asp:ListItem>
                                <asp:ListItem Enabled="true" Text="01:00" Value="2"></asp:ListItem>--%>
                                </asp:DropDownList>
                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" Display="Dynamic" ErrorMessage="Select Incident Type" ForeColor="Red" ControlToValidate="ddlIncident" ValidationGroup="downtime"></asp:RequiredFieldValidator>--%>
    </div>
                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>
                    
                </div>
                </div>

                <div class="row">

                     <div class="col-lg-4">
                    <div class="form-group">
                        <label>Add Attachment</label>
                        <div class="input-group">
                            <%--<asp:ListBox  ItemType="text" CssClass="form-control select" ID="lbSites" SelectionMode="Multiple" runat="server">
                            </asp:ListBox>--%>
                            <asp:FileUpload ID="AttachExceptionMail" runat="server"  accept=".msg" Width="100%" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" Display="Dynamic" ErrorMessage="Attach refrence Mail" ForeColor="Red" ControlToValidate="AttachExceptionMail" ValidationGroup="downtime"></asp:RequiredFieldValidator><%--ValidationGroup="downtime"--%>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidatorAttachment" ValidationExpression="([a-zA-Z0-9\s_\\.\-:])+(.msg)$"

    ControlToValidate="AttachExceptionMail" runat="server" ForeColor="Red" ErrorMessage="Please select a valid mail file."

    Display="Dynamic" />
                        </div>
                        <!-- /.input group -->
                    </div>
                </div>

                    <div class="col-lg-4">
                        <div class="form-group">
                            <label>Notes</label>
                            <div class="input-group">
                                <span class="input-group-addon"><i class="fa fa-circle"></i></span>
                                <asp:TextBox runat="server" ID="txtException" CssClass="form-control select" TextMode="MultiLine" Rows="2"/>
                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" Display="Dynamic" ErrorMessage="Sitel Ticket is Required" ForeColor="Red" ControlToValidate="txtSitelTicket" ValidationGroup="downtime"></asp:RequiredFieldValidator>--%>

                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>

                    <div class="col-lg-4" ><%--style="margin-top:1%;"--%>
               <%-- <div class="pull-right" >--%>
<div class="row" style="margin-top:6%;">
    <div class="col-lg-6">
        <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btnSave_Click" Width="100%" ValidationGroup="downtime"/>                   
                    </div><%--&nbsp--%>
    <div class="col-lg-6">
                   <asp:Button ID="btnDiscardEsc" runat="server" Text="Discard" CssClass="btn btn-default"  Width="100%" />     
    </div>
    </div>            
    <%--</div>--%>
                    </div>

                </div>

            </div>

           <%-- <div class="box-footer">               
            </div>--%>
        </div>
        <%--</div>--%>

        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">Exception Log </h3>
                    </div>
                    <div class="box-body" style="overflow-x:scroll">
                        
                       <asp:GridView ID="gvPendingLog" runat="server" CssClass="table table-bordered table-hover ExceptionlogDataTable"
                           AutoGenerateColumns="false" ShowHeaderWhenEmpty="true"
                           OnRowDataBound="gvPendingLog_RowDataBound" OnPreRender="gv_PreRender"> <%----%>
                           <Columns>
                               <asp:BoundField DataField="ID" HeaderText="ExceptionID"></asp:BoundField>
                               <asp:BoundField DataField="Account" HeaderText="Account" ></asp:BoundField>
                               <asp:BoundField DataField="LOB_A" HeaderText="LOB" ></asp:BoundField>
                               <asp:BoundField DataField="KPI" HeaderText="KPI" ></asp:BoundField>
                               <asp:BoundField DataField="TextDescription" HeaderText="Month" ></asp:BoundField>
                               <asp:BoundField DataField="Date" HeaderText="Date" ></asp:BoundField>
                               <asp:BoundField DataField="FromInterval" HeaderText="FromInterval"></asp:BoundField>
                               <asp:BoundField DataField="ToInterval" HeaderText="ToInterval" ></asp:BoundField>
                               <%--<asp:HyperLinkField DataNavigateUrlFields="Attachment" DataTextField="Attachment" HeaderText ="Attachment" />--%>
                               <%--<asp:BoundField DataField="Attachment" HeaderText="Attachment" ></asp:BoundField>--%>                     
                               <asp:TemplateField HeaderText="Attcahment" >
                                   <ItemTemplate>
                                       <asp:LinkButton ID="lbDownload" Text="download" CommandArgument='<%# Eval("Attachment") %>' runat="server" OnClick="lbDownload_Click"></asp:LinkButton>
                                   </ItemTemplate>
                               </asp:TemplateField>
                               <asp:BoundField DataField="notes" HeaderText="notes"></asp:BoundField>
                               <asp:BoundField DataField="RaisedBy" HeaderText="RaisedBy"></asp:BoundField>
                               <asp:BoundField DataField="RaisedOn" HeaderText="RaisedOn" ></asp:BoundField>
                               <%--<asp:ButtonField CommandName="Approve" Text="Approve" ShowHeader="True" HeaderText="Approved" ></asp:ButtonField>--%>
                               <asp:TemplateField HeaderText="Approve" HeaderStyle-CssClass="mid" >
                                  <ItemTemplate>
                                     <asp:Button ID="btn_Approve" runat="server" CssClass="btn btn-xs btn-success" Text="Approve" OnClick="btn_Approve_Click"/>
                                  </ItemTemplate>
                               </asp:TemplateField>
                               <asp:TemplateField HeaderText="Decline" HeaderStyle-CssClass="mid" >
                                  <ItemTemplate>
                                     <asp:Button ID="btn_Decline" runat="server" CssClass="btn btn-xs btn-danger" Text="Decline" OnClick="btn_Decline_Click"/>
                                  </ItemTemplate>
                               </asp:TemplateField>
                               <asp:TemplateField HeaderText="Cancel" HeaderStyle-CssClass="mid" >
                                  <ItemTemplate>
                                     <asp:Button ID="btn_Cancel" runat="server" CssClass="btn btn-xs btn-warning" Text="Cancel" OnClick="btn_Cancel_Click"/>
                                  </ItemTemplate>
                               </asp:TemplateField>
                               <asp:BoundField DataField="Status" HeaderText="Status" ></asp:BoundField>
                               <asp:BoundField DataField="Employee_ID" HeaderText="Employee_ID" ></asp:BoundField>
                               <%--<asp:ButtonField CommandName="Decline" Text="Decline" ShowHeader="True" HeaderText="Declined"></asp:ButtonField>
                               <asp:ButtonField CommandName="Cancel" Text="Cancel" ShowHeader="True" HeaderText="Delete"></asp:ButtonField>--%>
                           </Columns>
                       </asp:GridView>

                    </div>
                    <div class="box-footer clearfix">
                       
                    </div>
                </div>
                <!-- /.box -->
            </div>


            <!-- /.col -->

<%--            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">Actioned Exception Log </h3>
                    </div>

                    <div class="box-body">
                        
                       <asp:GridView ID="GridView1" runat="server" CssClass="table table-bordered table-hover" AutoGenerateColumns="false" ShowHeaderWhenEmpty="true">
                           <Columns>
                               <asp:BoundField DataField="Date" HeaderText="Account" SortExpression="Date"></asp:BoundField>
                               <asp:BoundField DataField="Interval" HeaderText="LOB" SortExpression="Interval"></asp:BoundField>
                               <asp:BoundField DataField="AccountName" HeaderText="KPI" SortExpression="Account"></asp:BoundField>
                               <asp:BoundField DataField="LOB" HeaderText="DataLevel" SortExpression="LOB"></asp:BoundField>
                               <asp:BoundField DataField="Sites" HeaderText="Role" SortExpression="Sites"></asp:BoundField>
                               <asp:BoundField DataField="Issue" HeaderText="Raised By" SortExpression="Issue"></asp:BoundField>
                               <asp:BoundField DataField="IncidentType" HeaderText="Raised On" SortExpression="IncidentType"></asp:BoundField>
                               <asp:BoundField DataField="ClientTicket" HeaderText="Status" SortExpression="ClientTicket"></asp:BoundField>
                               <asp:BoundField DataField="ClientTicket" HeaderText="Actioned By" SortExpression="ClientTicket"></asp:BoundField>
                               <asp:BoundField DataField="ClientTicket" HeaderText="Actioned On" SortExpression="ClientTicket"></asp:BoundField>
                           </Columns>
                       </asp:GridView>

                    </div>

                    <div class="box-footer clearfix">
                       
                    </div>
                </div>

            </div>--%>

        </div>
        <!-- /.row -->

    </section>
</asp:Content>

<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <!-- Select2 -->
    <script src="AdminLTE/bower_components/select2/dist/js/select2.full.min.js"></script>
    <script src="Sitel/plugins/bootstrap-toggle/js/bootstrap-toggle.min.js"></script>
    <script>
        //Date picker
        $(document).ready(function () {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);

            function EndRequestHandler(sender, args) {
                $('#tbEffectiveDate').datepicker({ dateFormat: 'dd-mm-yy' });
            }

            $('#tbDate').datepicker({
                format: 'dd-MM-yyyy',
                //orientation: "bottom auto",
                autoclose: true
            });

        });

        function ValidateCheckBoxList(sender, args) {

           <%-- var checkBoxList = document.getElementById("<%=lbSites.ClientID %>");--%>

            var checkboxes = checkBoxList.getElementsByTagName("input");

            var isValid = false;

            for (var i = 0; i < checkboxes.length; i++) {

                if (checkboxes[i].checked) {

                    isValid = true;

                    break;

                }

            }

            args.IsValid = isValid;

        }
    </script>
    <script>
        function pluginsInitializer() {
            $('.select2').select2({

            });

            $("#gvPendingLog tbody tr").each(function () {
                $(this).find("th:nth-child(1)").hide();
                $(this).find("td:nth-child(1)").hide();
                $(this).find("th:nth-child(17)").hide();
                $(this).find("td:nth-child(17)").hide();
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

        $(function () {
            $('.ExceptionlogDataTable').DataTable({
                "sPaginationType": "full_numbers",
                "lengthMenu": [5, 10, 25, 50, 75, 100],
                "aaSortingFixed": [[0, 'asc']],
                "bSort": true,
                dom: 'Bfrltip',
                "columnDefs": [{ "orderable": false, "targets": 0 }],
                buttons: [
                    { extend: 'copyHtml5', text: 'Copy Data' },
                    { extend: 'excelHtml5', text: 'Export to Excel' },
                    { extend: 'csvHtml5', text: 'Export to CSV' },
                    { extend: 'pdfHtml5', text: 'Export to PDF' },
                ],
                "columnDefs": [{
                    "targets": [0,16], //Comma separated values
                    "visible": false,
                    "searchable": false
                }
                ],

            });
        });
    </script>

</asp:Content>
