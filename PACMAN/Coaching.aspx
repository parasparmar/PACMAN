<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Coaching.aspx.cs" Inherits="Coaching" %>

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
    <!-- bootstrap wysihtml5 - text editor -->
    <%--<link rel="stylesheet" href="AdminLTE/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css">--%>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="index.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="coaching.aspx"><i class="fa fa-graduation-cap"></i>Coaching & Feedback</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-graduation-cap"></span></div>
        <div class="pagetitle">
            <h5>Assign Performance Enhancing Tips and Advice</h5>
            <h1>Coaching & Feedback</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <div class="box box-solid box-primary">
        <div class="box-body">
            <div class="row">
                <div class="col-lg-3 col-md-4 col-sm-6">
                    <div class="form-group">
                        <label for="ddlRole" class="control-label">View As Coach or Self</label>
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-street-view"></i></span>
                            <asp:DropDownList ID="ddlRole" ItemType="text" CssClass="form-control select2" runat="server" AutoPostBack="true">
                                <asp:ListItem Selected="True" Text="Coach" Value="Coach"></asp:ListItem>
                                <asp:ListItem Text="Self" Value="Self"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <!--Role-->
                <div class="col-lg-3 col-md-4 col-sm-6">
                    <div class="form-group">
                        <label for="ddlSelectEmployee" class="control-label">Select Employee</label>
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-user"></i></span>
                            <asp:DropDownList ID="ddlSelectEmployee" ItemType="text" CssClass="form-control select2" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSelectEmployee_SelectedIndexChanged">
                                <asp:ListItem Selected="True" Text="---Please Select---" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <!--Employee-->
            </div>
        </div>
    </div>

    <div class="box box-solid box-primary">
        <div class="box-header">
            <i class="fa fa-pencil"></i>
            <h3 class="box-title"><asp:Literal ID="ltlCoachingInputs" runat="server" Text="Coaching Inputs"></asp:Literal></h3>
            <!-- tools box -->
            <div class="box-tools pull-right">
                <button class="btn btn-box-tool" type="button" data-widget="collapse">
                    <i class="fa fa-minus"></i>
                </button>
            </div>
            <!-- /. tools -->
        </div>
        <div class="box-body">
            <h3>Communication</h3>
            <div class="form-group">
                <asp:HiddenField ID="hfCommunication" runat="server" Value="" />
                <asp:TextBox ID="tbCommunication" TextMode="multiline" Rows="4" runat="server" CssClass="form-control textarea" placeholder="Enter Communication..."></asp:TextBox>
                <asp:RequiredFieldValidator ID="regexCommunication" runat="server" Display="Dynamic" ErrorMessage="Please input Communication Coaching" ForeColor="Orange" ControlToValidate="tbCommunication" ValidationGroup="Communication"></asp:RequiredFieldValidator>                
                <input id="tbCommunicationValidator" disabled="" class="form-control pull-right" type="text" style="width: 150px" placeholder="Word Count : 0">
            </div>
            <h3>Knowledge</h3>
            <div class="form-group">
                <asp:HiddenField ID="hfKnowledge" runat="server" Value="" />
                <asp:TextBox ID="tbKnowledge" TextMode="multiline" Rows="4" runat="server" CssClass="form-control textarea" placeholder="Enter Knowledge..."></asp:TextBox>
                <asp:RequiredFieldValidator ID="regexKnowledge" runat="server" Display="Dynamic" ErrorMessage="Knowledge Description required" ForeColor="Red" ControlToValidate="tbKnowledge" ValidationGroup="Knowledge"></asp:RequiredFieldValidator>                
                <input id="tbKnowledgeValidator" disabled="" class="form-control pull-right" type="text" style="width: 150px" placeholder="Word Count : 0">
            </div>
            <h3>Accuracy</h3>
            <div class="form-group">
                <asp:HiddenField ID="hfAccuracy" runat="server" Value="" />
                <asp:TextBox ID="tbAccuracy" TextMode="multiline" Rows="4" runat="server" CssClass="form-control textarea" placeholder="Enter Accuracy..."></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" Display="Dynamic" ErrorMessage="Accuracy Description required" ForeColor="Red" ControlToValidate="tbAccuracy" ValidationGroup="Accuracy"></asp:RequiredFieldValidator>                
                <input id="tbAccuracyValidator" disabled="" class="form-control pull-right" type="text" style="width: 150px" placeholder="Word Count : 0">
            </div>
            <h3>Timeliness</h3>
            <div class="form-group">
                <asp:HiddenField ID="hfTimeliness" runat="server" Value="" />
                <asp:TextBox ID="tbTimeliness" TextMode="multiline" Rows="4" runat="server" CssClass="form-control textarea" placeholder="Enter Timeliness advice..."></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="Dynamic" ErrorMessage="Timeliness Description required" ForeColor="Red" ControlToValidate="tbTimeliness" ValidationGroup="Timeliness"></asp:RequiredFieldValidator>                
                <input id="tbTimelinessValidator" disabled="" class="form-control pull-right" type="text" style="width: 150px" placeholder="Word Count : 0">
            </div>
            <!-- /.box -->
        </div>
        <div class="box-footer">
            <div class="btn-group pull-right">
                <asp:Button ID="btnDiscard" runat="server" Text="Discard" CssClass="btn btn-default" OnClick="btnDiscard_Click" />
                <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-primary" ValidationGroup="Coaching" OnClick="btnSave_Click" />
            </div>

        </div>
    </div>

    <div class="box box-solid box-primary">
        <div class="box-header">
            <i class="fa fa-book"></i>
            <h3 class="box-title"><asp:Literal ID="ltlPreviousCoachingInputs" runat="server" Text="Previous Coaching"></asp:Literal></h3>
            <div class="box-tools pull-right">
                <button class="btn btn-box-tool" type="button" data-widget="collapse">
                    <i class="fa fa-minus"></i>
                </button>
            </div>
            <!-- /. tools -->
        </div>
        <!-- /.box-header -->
        <div class="box-body table-responsive no-padding">
            <asp:GridView ID="gvCoachingLog" runat="server" CssClass="table table-bordered table-hover"
                AutoGenerateColumns="false" ShowHeaderWhenEmpty="true" DataKeyNames="EmpCode" OnRowCommand="gvCoachingLog_RowCommand" >
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button runat="server" ID="btnBatchID" Text='<%#Eval("BatchID") %>' CssClass="btn btn-flat btn-primary" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:BoundField DataField="ID" HeaderText="ID"></asp:BoundField>
                    <asp:BoundField DataField="EmpCode" HeaderText="EmpCode"></asp:BoundField>
                    <asp:BoundField DataField="Category" HeaderText="Coaching Area"></asp:BoundField>
                    <asp:BoundField DataField="Description" ItemStyle-Width="40%" HeaderText="Coaching Inputs"></asp:BoundField>
                    <asp:BoundField DataField="UpdatedOn" HeaderText="On" DataFormatString="{0:dd-MMM-yyyy hh:mm}"></asp:BoundField>
                    <asp:BoundField DataField="UpdatedBy" HeaderText="By"></asp:BoundField>
                    
                    <%--ID,EmpCode,Category,Description,UpdatedOn,UpdatedBy,Active--%>
                </Columns>
                <EmptyDataTemplate>No Records Available</EmptyDataTemplate>
            </asp:GridView>
            <asp:HiddenField ID="hfMode" Value="Insert" runat="server" />
        </div>
        <!-- /.box-body -->
    </div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <!-- Select2 -->
    <script src="AdminLTE/bower_components/select2/dist/js/select2.full.min.js"></script>
    <script src="Sitel/plugins/bootstrap-toggle/js/bootstrap-toggle.min.js"></script>
    <script src="AdminLTE/bower_components/ckeditor/ckeditor.js"></script>
    <!-- Bootstrap WYSIHTML5 -->
    <script src="AdminLTE/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js"></script>
    <script>
        $(function () {
            // Replace the <textarea id="editor1"> with a CKEditor
            // instance, using default configuration.
            //CKEDITOR.replace('editor1')
            //bootstrap WYSIHTML5 - text editor
            // $('textarea[class*="textarea"]').wysihtml5();
        })
    </script>
</asp:Content>

