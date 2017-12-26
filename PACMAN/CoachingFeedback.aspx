<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="CoachingFeedback.aspx.cs" Inherits="CoachingFeedback" %>

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

        .border-between > [class*='col-']:first-child:before {
            display: none;
        }
    </style>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="index.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="movement.aspx"><i class="fa fa-flag-o"></i>Coaching & Feedback</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-flag-o"></span></div>
        <div class="pagetitle">
            <h5>Listing of Feedback and monitoring its progress</h5>
            <h1>Coaching & Feedback</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <!-- Pending Transfers List -->
    <div class="box box-primary">
        <%--        <div class="box-header with-border">
            <h3 class="box-title">Apply Leave</h3>
        </div>--%>
        <div class="box-body">
            <div class="row">
                <div class="col-md-2">
                    <div class="form-group">
                        <label for="ddlSelectEmployee">Select Employee</label>
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-user"></i></span>
                            <asp:DropDownList ID="ddlSelectEmployee" ItemType="text" CssClass="form-control select" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSelectEmployee_SelectedIndexChanged">
                                <asp:ListItem Selected="True" Text="None" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <!-- /.input group -->
                    </div>    
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label for="ddlPacmanCycle">select Pacman Cycle</label>
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-calendar-check-o"></i></span>
                            <asp:DropDownList ID="ddlPacmanCycle" ItemType="text" CssClass="form-control select" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlPacmanCycle_SelectedIndexChanged">
                                <asp:ListItem Selected="True" Text="None" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <!-- /.input group -->
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="txt_leave_reason" class="col-lg-2 control-label">Feedback</label>
                            <%--<asp:TextBox ID="txtEscalation" TextMode="multiline" Columns="74" Rows="4" runat="server" CssClass="form-control" placeholder="Enter Escalation..."></asp:TextBox>--%>

                        <asp:TextBox ID="txt_leave_reason" CssClass="form-control" runat="server" placeholder="Enter Feedback....."></asp:TextBox>
                        <%--<textarea id="txt_leave_reason" placeholder="Enter Reason....." class="form-control" runat="server"></textarea>--%>
                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="Dynamic" ErrorMessage="Leave Reason required" ForeColor="Red" ControlToValidate="txt_leave_reason" ValidationGroup="Proceed"></asp:RequiredFieldValidator>--%>
                        <%--<asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" Display="Dynamic" ControlToValidate="txt_leave_reason" ErrorMessage="enter valid reason" ForeColor="Red" ValidationExpression="^[a-zA-Z ]+$" ValidationGroup="Proceed"></asp:RegularExpressionValidator>--%>
                    </div>
                </div>
                <div class="col-md-1" style="padding-top: 2%">
                    <asp:Button ID="btn_proceed" CssClass="btn btn-primary pull-right" runat="server" Text="Proceed" />
                </div>
            </div>
        </div>

    </div>
    <!-- Pending Transfers List -->
    <div class="box box-solid  box-warning">
        <div class="box-header">
            <i class="fa fa-flag"></i>
            <h3 class="box-title">Incomplete Tasks</h3>
            <div class="box-tools pull-right">
            </div>
        </div>
        <!-- /.box-header -->
        <div class="box-body">
            <div class="box-body table-responsive no-padding">
                <table class="table table-hover">
                    <tr>
                        <th>Pacman Cycle</th>
                        <th>Feedback</th>
                        <th>In Progress</th>
                        <th>Expectations Not Met</th>
                        <th>Met Expectations</th>
                        <th>Exceeded Expectations</th>
                        <th>Penalty</th>
                    </tr>
                    <tr>
                        <td>Dec 2017</td>
                        <td>Lorem ipsum dolor sit amet, consectetur adipiscing elit. </td>
                        <td>
                            <input type="radio" name="optionsRadios8" id="Radio1" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios8" id="Radio2" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios8" id="Radio3" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios8" id="Radio4" value="option1"></td>
                        <td>-1</td>
                    </tr>
                    <tr>
                        <td>Dec 2017</td>
                        <td>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</td>
                        <td>
                            <input type="radio" name="optionsRadios7" id="Radio5" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios7" id="Radio6" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios7" id="Radio7" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios7" id="Radio8" value="option1"></td>
                        <td>-1</td>
                    </tr>
                    <tr>
                        <td>Dec 2017</td>
                        <td>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</td>
                        <td>
                            <input type="radio" name="optionsRadios6" id="Radio9" value="option1" checked></td>
                        <td>
                            <input type="radio" name="optionsRadios6" id="Radio10" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios6" id="Radio11" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios6" id="Radio12" value="option1"></td>
                        <td>-1</td>
                    </tr>
                    <tr>
                        <td>Dec 2017</td>
                        <td>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</td>
                        <td>
                            <input type="radio" name="optionsRadios5" id="Radio13" value="option1" checked></td>
                        <td>
                            <input type="radio" name="optionsRadios5" id="Radio14" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios5" id="Radio15" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios5" id="Radio16" value="option1"></td>
                        <td>-1</td>
                    </tr>
                </table>
            </div>
        </div>
    </div>

    <!-- /.box-body -->


    <div class="box box-solid  box-success">
        <div class="box-header">
            <i class="fa fa-flag"></i>
            <h3 class="box-title">Completed Tasks</h3>
            <div class="box-tools pull-right">
            </div>
        </div>
        <!-- /.box-header -->
        <div class="box-body">
            <div class="box-body table-responsive no-padding">
                <table class="table table-hover">
                    <tr>
                        <th>Pacman Cycle</th>
                        <th>Feedback</th>
                        <th>In Progress</th>
                        <th>Expectations Not Met</th>
                        <th>Met Expectations</th>
                        <th>Exceeded Expectations</th>
                        <th>Points</th>
                        <%--<th>Completed Date</th>--%>
                    </tr>
                    <tr>
                        <td>Dec 2017</td>
                        <td>Lorem ipsum dolor sit amet, consectetur adipiscing elit. </td>
                        <td>
                            <input type="radio" name="optionsRadios0" id="Radio17" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios0" id="Radio18" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios0" id="Radio19" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios0" id="Radio20" value="option1" checked></td>
                        <td>1</td>
                        <%--<td>10 Dec 2017</td>--%>
                    </tr>
                    <tr>
                        <td>Dec 2017</td>
                        <td>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</td>
                        <td>
                            <input type="radio" name="optionsRadios1" id="Radio21" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios1" id="Radio22" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios1" id="Radio23" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios1" id="Radio24" value="option1" checked></td>
                        <td>1</td>
                        <%--<td>10 Dec 2017</td>--%>
                    </tr>
                    <tr>
                        <td>Dec 2017</td>
                        <td>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</td>
                        <td>
                            <input type="radio" name="optionsRadios2" id="Radio25" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios2" id="Radio26" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios2" id="Radio27" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios2" id="Radio28" value="option1" checked></td>
                        <td>1</td>
                        <%--<td>10 Dec 2017</td>--%>
                    </tr>
                    <tr>
                        <td>Dec 2017</td>
                        <td>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</td>
                        <td>
                            <input type="radio" name="optionsRadios3" id="Radio29" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios3" id="Radio30" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios3" id="Radio31" value="option1"></td>
                        <td>
                            <input type="radio" name="optionsRadios3" id="Radio32" value="option1" checked></td>
                        <td>1</td>
                        <%--<td>10 Dec 2017</td>--%>
                    </tr>
                </table>
            </div>
        </div>

    </div>

    <!-- /.box -->
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

        });
    </script>
    <script>
        function pluginsInitializer() {
            $('.select2').select2({

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

