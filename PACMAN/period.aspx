<%@ Page Title="My PACMAN" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="period.aspx.cs" Inherits="period" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>


<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
</asp:Content>


<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="Summary.aspx"><i class=""></i>Home</a></li>
        <li class="active"><a href="/PMS_ReviewMaster.aspx"><i class="fa fa-list-alt"></i>Period</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-hourglass-half"></span></div>
        <div class="pagetitle">
            <h5>Set Pacman Period</h5>
            <h1>Period</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">

    <asp:UpdatePanel ID="UpdatePanel1" runat="server" EnableViewState="true" UpdateMode="Conditional">
        <ContentTemplate>

            <div class="box box-primary">
                <div class="box-body">
                    <div class="form-group">

                        <div class="col-lg-3">
                            <div class="form-group">
                                <label>Select Year</label>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-calendar"></i>
                                    </div>
                                    <asp:TextBox ID="tbYear" CssClass="form-control datepicker" runat="server"></asp:TextBox>                           
                                </div>
                                <asp:RequiredFieldValidator ID="tbYearValidator" runat="server" ErrorMessage="Year is required" ForeColor="Red" ControlToValidate="tbYear" ValidationGroup="SubmitPeriod"></asp:RequiredFieldValidator>
                                <!-- /.input group -->
                            </div>
                        </div>

                        <div class="col-lg-3">
                            <div class="form-group">
                                <label>Select From Date</label>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-calendar"></i>
                                    </div>
                                    <asp:TextBox ID="tbFromDate" CssClass="form-control datepicker" runat="server"></asp:TextBox>
                                </div>
                                <asp:RequiredFieldValidator ID="tbFromDateValidator" runat="server" ErrorMessage="FromDate is required" ForeColor="Red" ControlToValidate="tbFromDate" ValidationGroup="SubmitPeriod"></asp:RequiredFieldValidator>
                                <!-- /.input group -->
                            </div>
                        </div>

                        <div class="col-lg-3">
                            <div class="form-group">
                                <label>Select To Date</label>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-calendar"></i>
                                    </div>
                                    <asp:TextBox ID="tbToDate" CssClass="form-control datepicker" runat="server"></asp:TextBox>
                                </div>
                                <asp:RequiredFieldValidator ID="tbToDateValidator" runat="server" ErrorMessage="ToDate is required" ForeColor="Red" ControlToValidate="tbToDate" ValidationGroup="SubmitPeriod"></asp:RequiredFieldValidator>
                                <!-- /.input group -->
                            </div>
                        </div>

                        <div class="col-lg-3">
                            <div class="form-group">
                                <label>Period For</label>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-user"></i>
                                    </div>
                                    <asp:TextBox ID="tbText" CssClass="form-control" runat="server"></asp:TextBox>
                                </div>
                                <asp:RequiredFieldValidator ID="tbTextValidator" runat="server" ErrorMessage="Period Description is required" ForeColor="Red" ControlToValidate="tbText" ValidationGroup="SubmitPeriod"></asp:RequiredFieldValidator>
                                <!-- /.input group -->
                            </div>
                        </div>

                        <div class="col-lg-3">
                            <div class="form-group">
                                <label>Max Grace</label>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-user"></i>
                                    </div>
                                    <asp:TextBox ID="tbgrace" CssClass="form-control" runat="server"></asp:TextBox>
                                </div>
                                <asp:RequiredFieldValidator ID="tbgraceValidator" runat="server" ErrorMessage="Grace is required" Display="Dynamic" ForeColor="Red" ControlToValidate="tbgrace" ValidationGroup="SubmitPeriod"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="tbgraceExpressionValidator" ControlToValidate="tbgrace" runat="server"
                                 ErrorMessage="enter proper expression" ForeColor="Red" Display="Dynamic" ValidationExpression="^[0-5]{0,1}(\.[0-9]{1,2})?$" ValidationGroup="SubmitPeriod"></asp:RegularExpressionValidator> 
                                <!-- /.input group -->
                            </div>
                        </div>

                        <div class="col-lg-3">
                            <div class="form-group">
                                <label>Phase</label>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-user"></i>
                                    </div>
                                    <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlPhase" runat="server">
                                    </asp:DropDownList>
                                </div>
                                <%--<asp:RequiredFieldValidator ID="ddlPhaseValidator" runat="server" ErrorMessage="Phase is required" ForeColor="Red" ControlToValidate="ddlPhase" ValidationGroup="SubmitPeriod"></asp:RequiredFieldValidator>--%>
                                <asp:RequiredFieldValidator ID="ddlPhaseValidator" runat="server" ControlToValidate="ddlPhase" 
                            InitialValue=0 ErrorMessage="Phase is required" ForeColor="Red"  ValidationGroup="SubmitPeriod"></asp:RequiredFieldValidator>
                                <!-- /.input group -->
                            </div>
                        </div>
                        <div class="col-lg-3">
                            <div class="form-group">
                                <label>Active</label>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-user"></i>
                                    </div>
                                    <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlActive" runat="server">
                                        <%--<asp:ListItem Enabled="true" Selected="True" Text="Select SPI Status" Value="2"></asp:ListItem>--%>
                                        <asp:ListItem Enabled="true" Text="select status" Value="-1" ></asp:ListItem>
                                        <asp:ListItem Enabled="true" Text="True" Value="1"></asp:ListItem>
                                        <asp:ListItem Enabled="true" Text="False" Value="0"></asp:ListItem>                                   
                                    </asp:DropDownList>
                                </div>
                                <asp:RequiredFieldValidator ID="ddlActiveValidator" runat="server" InitialValue="-1" ErrorMessage="Active Status is required" ForeColor="Red" ControlToValidate="ddlActive" ValidationGroup="SubmitPeriod"></asp:RequiredFieldValidator>
                                <!-- /.input group -->
                            </div>
                        </div>
                        <div class="col-lg-3">
                            <div class="form-group">
                                <label style="color: white">&nbsp</label>
                                <div class="input-group">
                                   <%-- <div class="input-group-addon">
                                        <i class="fa fa-user"></i>
                                    </div>--%>
                                     <asp:Button ID="btn_submitPeriod" CssClass="btn btn-primary" runat="server" Text="Submit" Width="400%" OnClick="btn_submitPeriod_Click" ValidationGroup="SubmitPeriod" CausesValidation="true"/><%-- --%>
                                </div>
                              
                                <!-- /.input group -->
                            </div>
                        </div>

                        <div class="col-lg-3">
                            <div class="form-group">
                                <%--<label style="color: white">&nbsp</label>--%>
                                <div class="input-group">
                                   <%-- <div class="input-group-addon">
                                        <i class="fa fa-user"></i>
                                    </div>--%>
                                     <asp:TextBox ID="tbPeriodID" CssClass="form-control" runat="server" Visible="false" ></asp:TextBox>
                                </div>
                              
                                <!-- /.input group -->
                            </div>
                        </div>
                    </div>
                </div>
                <%--<div class="box-footer">
                    <asp:Button ID="btn_submitPeriod" CssClass="btn btn-primary pull-right" runat="server" Text="Submit" OnClick="btn_submitPeriod_Click" />
                </div>--%>
            </div>

            <div class="box box-solid box-primary" style="height: auto;">
                <div class="box-header with-border">
                    <h4 class="box-title">View all Periods</h4>
                    <%--                           <div class="box-tools pull-right">
                                <button class="btn btn-box-tool" type="button" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                            </div>--%>
                </div>
                <div class="box-body">
                    <div class="form-group">
                        <asp:GridView ID="gv_PeriodList" runat="server" CssClass="table table-condensed table-responsive display compact hover stripe" AutoGenerateColumns="false"
                             ShowHeader="true" Style="border: none" OnRowCommand="gv_PeriodList_RowCommand" OnPreRender="gv_PreRender">
                            <Columns>
                                <asp:TemplateField HeaderText="Select" HeaderStyle-CssClass="mid">
                                    <ItemTemplate>
                                        <asp:Button ID="btn_Select" runat="server" CssClass="btn btn-xs btn-primary" CommandArgument='<%#Eval("PeriodID") %>' Text="Select"/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="PeriodID" HeaderText="PeriodID" />
                                <asp:BoundField DataField="Year" HeaderText="Year" />
                                <asp:BoundField DataField="FromDate" HeaderText="From Date" />
                                <asp:BoundField DataField="ToDate" HeaderText="ToDate" />
                                <asp:BoundField DataField="PeriodFor" HeaderText="Period For" />
                                <asp:BoundField DataField="MaxGrace" HeaderText="Max Grace" />
                                <asp:BoundField DataField="Phase" HeaderText="Phase" />
                                <asp:BoundField DataField="Active" HeaderText="Active" />
                            </Columns>
                            <EmptyDataTemplate>
                                <h5>No period generated.</h5>
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
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">

    <script>
        $('#tbFromDate').datepicker({
            format: 'dd-MM-yyyy',
            //orientation: "bottom auto",
            autoclose: true
        });
        $('#tbToDate').datepicker({
            format: 'dd-MM-yyyy',
            autoclose: true
        });

        var d = new Date();
        var startYear = d.getFullYear();
        var endYear = d.getFullYear() + 2;

        $('#tbYear').datepicker({
            format: 'yyyy',
            viewMode: "years",
            minViewMode: "years",
            startDate: "startYear",
            //endDate: "endYear",
            autoclose: true
        });

        $("[class*='datepicker']").datepicker({
            autoclose: true
        })
    </script>

</asp:Content>
