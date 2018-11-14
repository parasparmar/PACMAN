<%@ Page Title="ExceptionApproval" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ExceptionApproval.aspx.cs" Inherits="ExceptionApproval" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
    <style>        
        .red {
            color: red;
        }

        .content-wrapper {
            min-height: 897.76px !important;
        }        
        .left {
            /*float:left;*/
            width: 100%;
        }

        .right {
            /*float:right;*/
            width: 100%;
        }

        .label {
            border: 2px solid black;
        }

        .lds-dual-ring {
            display: inline-block;
            width: 64px;
            height: 64px;
        }

            .lds-dual-ring:after {
                content: " ";
                display: block;
                width: 46px;
                height: 46px;
                margin: 1px;
                border-radius: 50%;
                border: 5px solid #f9f3f4;
                border-top-color: rgb(249, 243, 244);
                border-right-color: rgb(249, 243, 244);
                border-bottom-color: rgb(249, 243, 244);
                border-left-color: rgb(249, 243, 244);
                /*border-color: #d54141 transparent #d54141 transparent;*/
                border-color: #ece1e1 transparent #efe4e4 transparent;
                animation: lds-dual-ring 1.2s linear infinite;
                position: absolute;
                left: 50%;
                top: 45%;
                z-index: 99999;
            }        
        .tooltip.top .tooltip-inner {
            background-color: black !important;
            color: #fff !important;
            text-align: left;
            max-width: 500px;
            z-index: 1000 !important;
            opacity: 1 !important;
            filter: alpha(opacity=100)
        }

        .tooltip.in {
            opacity: 1 !important;
            filter: alpha(opacity=100);
        }
    </style>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server" ChildrenAsTriggers="false">
    <ol class="breadcrumb">
        <li><a href="Summary.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="ExceptionApproval.aspx"><i class="fa fa-toggle-on"></i>ExceptionApproval</a></li>
    </ol>
    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-toggle-on"></span></div>
        <div class="pagetitle">
            <h5>Review Exceptions request</h5>
            <h1>Approve/Deny Exceptions</h1>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <div class="row">
        <div class="col-md-12">
            <div class="box box-solid box-primary" style="height: auto;">
                <div class="box-header with-border">
                    <h4 class="box-title">Select</h4>
                </div>
                <div class="box-body">
                    <div class="row">
                        <asp:Panel CssClass="col-md-12" ID="pnlAmIRvwMgr" Visible="true" runat="server">
                            <div class="col-md-6">
                                <label for="ddlReviewPeriod" aria-label="Reporting Manager List">Review Period</label>
                                <div class="form-group">
                                    <select id="ddlReviewPeriod" class="col-md-6 form-control" style="width: 100%;" onchange="FillAccounts();">
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label id="lblAccount" for="ddlAccount" aria-label="Filter Account At This Stage">Filter Accounts</label>
                                <div class="form-group">
                                    <select id="ddlAccount" class="col-md-6 form-control" style="width: 100%;" onchange="FillList();">
                                    </select>
                                </div>
                            </div>

                        </asp:Panel>
                        <!-- pnlAmIRvwMgr-->
                        <div class="col-md-12">
                            <h4>Pending Exception Log</h4>
                            <textarea id="MyHiddenResponse" style="display: none;">[{ "": "<div style='display:table;width:50%;'><div style='display:table-cell;vertical-align:middle;text-align:center;'>No Record(s) Found</div></div>" },]
</textarea>

                            <div id="gvApprLeaveLog"></div>
                            <input id="selectedAccount" type="hidden" value="" />
                        </div>
                        <!-- Leave Log-->
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="progress" class="modal">
        <div class="lds-dual-ring"></div>
    </div>
</asp:Content>

<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <link href="Sitel/cdn/excel-bootstrap-table-filter/excel-bootstrap-table-filter-style.css" rel="stylesheet" />
    <script src="Sitel/cdn/excel-bootstrap-table-filter/excel-bootstrap-table-filter-bundle.min.js"></script>
    <script src="Sitel/cdn/jsontotable/Json2Table.js"></script>
    <script type="text/javascript">
        $(function () {
            FillReviewPeriod();
        });
        function FillReviewPeriod() {
            $.ajax({
                type: "POST",
                url: "ExceptionApproval.aspx/GetAllReviewPeriod",
                //data: params,
                dataType: "json",
                async: true,
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    $('#ddlReviewPeriod').html('');
                    var items = [];
                    $.each(response.d, function () {
                        items.push("<option value=" + this.PeriodID + ">" + this.Period + "</option>");
                    });
                    $('#ddlReviewPeriod').html(items);
                    FillAccounts();
                },
                error: function (errormessage) {
                    alert(errormessage.responseText);
                    //$("#progress").hide();
                }
            })
        }
        function FillAccounts() {
            var Month = $('#ddlReviewPeriod :selected').val();
            var params = '{"Month":"' + Month + '"}';
            //if (EmpCode != "" && EmpCode != "0") {
            $.ajax({
                type: "POST",
                url: "ExceptionApproval.aspx/GetPendingAccountList",
                data: params,
                dataType: "json",
                async: true,
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    $('#ddlAccount').html('');
                    var items = [];
                    $.each(response.d, function () {
                        items.push("<option value=" + this.AccountID + ">" + this.Account + "</option>");
                    });
                    $('#ddlAccount').html(items);
                    FillList();
                },
                error: function (errormessage) {
                    alert(errormessage.responseText);
                }
            })
            //}
        }
        function FillList() {
            $('#progress').show();
            var Month = $('#ddlReviewPeriod :selected').val();

            var Account = $('#ddlAccount :selected').val();
            $('#selectedAccount').val(Account);
            var params = '{"Month":"' + Month + '", "Account":"' + Account + '"}';

            $.ajax({
                type: "POST",
                url: "ExceptionApproval.aspx/GetList",
                data: params,
                dataType: "json",
                async: true,
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    var xDT = 1;
                    if (response.d == "[]") {
                        response.d = $('#MyHiddenResponse').val();
                        xDT = 0;
                    }
                    xConvertJsonToTableBind(response.d, xDT);
                    //$('[data-toggle="tooltip"]').tooltip({ 'background-color': 'black','z-index':'100', 'width':'500px', 'opacity':'1' });
                    $('[data-toggle="tooltip"]').tooltip();



                    //$('.tooltip.top .tooltip-inner').css({'background-color': 'red','z-index':'1000', 'width':'500px', 'opacity':'1' });
                    $('#progress').hide();
                },
                error: function (errormessage) {
                    alert(errormessage.responseText);
                }
            });
        }
        function ApproveException(ID, RaisedBy, Account, LOB_A, KPI, notes) {
            //alert($('#ddlReviewPeriod option:selected').text());
            var Status = 1
            var params = '{"ID":"' + ID + '", "Status":"' + Status + '", "RaisedBy":"' + RaisedBy + '", "Account":"' + Account + '", "LOB_A":"' + LOB_A + '", "KPI":"' + KPI + '", "notes":"' + notes + '"}';
            //if (EmpCode != "" && EmpCode != "0") {
            $('#selectedAccount').val(Account);
            $.ajax({
                type: "POST",
                url: "ExceptionApproval.aspx/UpdateException",
                data: params,
                dataType: "json",
                async: true,
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    var xDT = 1;
                    if (response.d == "[]") {
                        response.d = $('#MyHiddenResponse').val();
                        xDT = 0;
                    }
                    xConvertJsonToTableBind(response.d, xDT);
                    //$('#progress').hide();
                    toastA();
                    //FillList();
                    FillAccounts();
                },
                error: function (errormessage) {
                    alert(errormessage.responseText);
                    //$("#progress").hide();
                }
            })
            debugger;
            $('#ddlAccount').val(Account);
            //}
        }
        function DeclineException(ID, RaisedBy, Account, LOB_A, KPI, notes) {
            //alert($('#ddlReviewPeriod option:selected').text());
            var Status = 0
            var params = '{"ID":"' + ID + '", "Status":"' + Status + '", "RaisedBy":"' + RaisedBy + '", "Account":"' + Account + '", "LOB_A":"' + LOB_A + '", "KPI":"' + KPI + '", "notes":"' + notes + '"}';
            $('#selectedAccount').val(Account);
            $.ajax({
                type: "POST",
                url: "ExceptionApproval.aspx/UpdateException",
                data: params,
                dataType: "json",
                async: true,
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    var xDT = 1;
                    if (response.d == "[]") {
                        response.d = $('#MyHiddenResponse').val();
                        xDT = 0;
                    }
                    xConvertJsonToTableBind(response.d, xDT);
                    //$('#progress').hide();
                    toastD();
                    // FillList();
                    FillAccounts();
                },
                error: function (errormessage) {
                    alert(errormessage.responseText);
                    //$("#progress").hide();
                }
            })
            debugger;
            $('#ddlAccount').val(Account);

        }
        function xConvertJsonToTableBind(xVal, xDT) {
            //debugger;
            xConvertJsonToTable('gvApprLeaveLog', xVal, 'xtbl', 'table table-bordered table-hover table-condensed table-responsive datatable', 'Download', xDT);
            //$('#xtbl > thead > tr:first-child').each(function () {
            //    var xTD = 0;

            //    $(this).find('th').each(function () {
            //        if (xTD >= 8) {
            //            $(this).hide();
            //        }
            //        xTD = xTD + 1;
            //    });
            //});

            //$('#xtbl > tbody > tr').each(function () {
            //    var xTD = 0;
            //    $(this).find('td').each(function () {
            //        if (xTD >= 8) {
            //            $(this).hide();
            //        }
            //        xTD = xTD + 1;
            //    });
            //});
        }
        function xConvertJsonToTable(ResultDiv, objectArray, tableId, tableClassName, linkText, xDataTable) {
            //alert($('#xID').val());
            //var objectArray = $('#xID').val();
            //var objectArray = '[{ key1: "val1", key2: "val2", key3: { tableId: "tblIdNested1", tableClassName: "clsNested", linkText: "Download", data: [{ subkey1: "subval1", subkey2: "subval2", subkey3: "subval3" }] } }]'; 
            var x = ConvertJsonToTable(eval(objectArray), tableId, tableClassName, linkText);
            //debugger;
            $('#' + ResultDiv).html("");
            $('#' + ResultDiv).append(x);

            if (xDataTable == 1) {
                $('#' + tableId).DataTable({
                    //"AutoWidth": false,
                    "columnDefs": [
                        {
                            //"targets": [8, 9, 10, 11, 12],//,17],
                            //"visible": false
                        }
                    ]
                });
            }
        }
        function toastA() {
            toastr.success('Exception Approved');//, 'Success'
            toastr.options = {
                "showDuration": "0",
                "hideDuration": "0",
                "timeOut": "1000",
                "extendedTimeOut": "0",
            }
        }
        function toastD() {
            toastr.success('Exception Declined');//, 'Success'
            toastr.options = {
                "showDuration": "0",
                "hideDuration": "0",
                "timeOut": "1000",
                "extendedTimeOut": "0",
            }
        }
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

