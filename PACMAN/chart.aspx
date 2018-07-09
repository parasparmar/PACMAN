<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="chart.aspx.cs" Inherits="chart" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>
<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <div class="box">
        <div class="box-body">
            <div class="form-group">
                <div class="col-lg-3">
                    <div class="form-group">
                        <label>Select Manager</label>
                        <div class="input-group">
                            <div class="input-group-addon">
                                <i class="fa fa-calendar-check-o"></i>
                            </div>
                            <%--    <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlReviewPeriod" runat="server">
                            </asp:DropDownList>--%>
                            <%--  <select class="form-control select2" id="ddltype" onchange="fillTypeList();">
                                <option value="0">Please Select</option>
                                <option value="1">Team</option>
                                <option value="2">Role</option>
                                <option value="3">Designation</option>
                            </select>--%>

                            <select class="form-control select2" id="ddlMgr" onchange="fillTypeList('ddlMgr', 'ddlStage');;">
                            </select>

                        </div>
                        <!-- /.input group -->
                    </div>
                </div>
                <asp:Panel ID="pnlIsPacmanDiscussion" runat="server" Visible="true">
                    <div class="col-lg-3">
                        <div class="form-group">
                            <label>Select Reportee</label>
                            <div class="input-group">
                                <div class="input-group-addon">
                                    <i class="fa fa-calendar"></i>
                                </div>
                                <%--  <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlStage" runat="server">
                                </asp:DropDownList>--%>
                                <select class="form-control select2" id="ddlStage" onchange="fillChartbubble();"></select>
                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="form-group">
                            <label>Select Designation</label>
                            <div class="input-group">
                                <div class="input-group-addon">
                                    <i class="fa fa-user"></i>
                                </div>
                                <%--  <asp:DropDownList ItemType="text" CssClass="form-control select2" ID="ddlReportee"
                                    runat="server" AutoPostBack="true">
                                </asp:DropDownList>--%>
                                <select class="form-control select2" id="ddlDesignation"></select>
                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="form-group">
                            <label>Select Role</label>
                            <div class="input-group">
                                <div class="input-group-addon">
                                    <i class="fa fa-user"></i>
                                </div>
                                <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlSPI" runat="server">
                                    <%--<asp:ListItem Enabled="true" Selected="True" Text="Select SPI Status" Value="2"></asp:ListItem>--%>
                                    <asp:ListItem Enabled="true" Text="False" Value="0"></asp:ListItem>
                                    <asp:ListItem Enabled="true" Text="True" Value="1"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </div>
    </div>

    <div class="box">
        <div class="chart-container" style="position: relative; height: 450px; width: 1200px">
            <canvas id="myChart" width="1200" height="450"></canvas>
        </div>
    </div>
    <div class="box">
        <div class="row justify-content-md-center">
            <div class="col-md-6 offset-md-2">
                <table class="table table-responsive table-condensed table-bordered DataTable">
                    <thead>
                        <tr>
                            <td>Employee</td>
                            <td>Pacman</td>
                            <td>Feedback</td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Manoj</td>
                            <td>33</td>
                            <td>33</td>
                        </tr>
                        <tr>
                            <td>Durgesh</td>
                            <td>66</td>
                            <td>66</td>
                        </tr>
                        <tr>
                            <td>Vinod</td>
                            <td>60</td>
                            <td>60</td>
                        </tr>
                        <tr>
                            <td>Vishal</td>
                            <td>45</td>
                            <td>45</td>
                        </tr>
                        <tr>
                            <td>Athang</td>
                            <td>75</td>
                            <td>75</td>
                        </tr>
                        <tr>
                            <td>Prashant</td>
                            <td>20</td>
                            <td>20</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

    <asp:HiddenField ID="hfMgrId" runat="server" />
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <!-- Pace style -->
    <link href="AdminLTE/plugins/pace/pace.min.css" rel="stylesheet" />

    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.bundle.min.js"></script>    
    <!-- PACE -->    
    <script src="AdminLTE/plugins/pace/pace.min.js"></script>
    <script>


        $(document).ready(function () {

            //debugger;
            $(this).ajaxStart(function () {

            });

            $(this).ajaxStop(function () {
                Pace.stop();
            });

            fillTypeList("", "ddlMgr");
        });

        function NineBoxChart(xdata) {

            var ctx = $("#myChart");
            if (xdata != null) {
                ctx.empty();
            }
            var myChart = new Chart(ctx, {
                type: 'bubble',
                data: {
                    labels: "Managers",
                    datasets: xdata
                },
                options: {
                    title: {
                        display: true,
                        text: 'Scores acheived by Managers on PACMAN Tests and Feedback scores'
                    },
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero: true,
                                min: 0,
                                max: 100,
                                stepSize: 33.33,
                                maxTicksLimit: 4
                            },
                            scaleLabel: {
                                display: true,
                                labelString: "Feedback Scores (More is better)"
                            }
                        }],
                        xAxes: [{
                            ticks: {
                                beginAtZero: true,
                                min: 0,
                                max: 100,
                                stepSize: 33.33,
                                maxTicksLimit: 4
                            },
                            scaleLabel: {
                                display: true,
                                labelString: "Pacman Scores (More is better)"
                            }
                        }]
                    },
                    //tooltips: {
                    //callbacks: {
                    //label: function (tooltipItem, data) {
                    //    var dataset = data.datasets[tooltipItem.datasetIndex];
                    //    var index = tooltipItem.index;
                    //    return dataset.labels[index] + ': ' + dataset.data[index];
                    //}
                    //}
                    //},


                }


            });
        }
        function fillTypeList(xFrom, xTo) {
            //debugger;
            ////$(document).ajaxStart(function () { Pace.restart(); });
            //Pace.start();
            var optionSelected = '';
            var params = '';

            if (xFrom != "") {
                //debugger;
                optionSelected = $("[id$='" + xFrom + "'] option:selected").val();
                params = '{"RepMgrCode":"' + optionSelected + '"}';
            }
            else {
                //debugger;
                optionSelected = $("[id$=hfMgrId]").val();
                params = '{"RepMgrCode":"' + optionSelected + '"}';
            }


            if (optionSelected != "" && optionSelected != "0") {
                //debugger;

                var myDropDownList = $("[id$=" + xTo + "]");
                $.ajax({
                    type: "POST",
                    url: "chart.aspx/GetDropDownDataTypeList",
                    data: params,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        //debugger;

                        $("[id$=" + xTo + "]").empty();
                        $.each($.parseJSON(JSON.stringify(data.d)), function () {
                            ////debugger;
                            myDropDownList.append($("<option></option>").val(this['Value']).html(this['Text']));
                            myDropDownList.prop('selectedIndex', 0);
                        });
                        Pace.stop();
                    },
                    failure: function (response) {
                        alert(response.d);
                        //Pace.stop();
                    }
                });
            }

        }
        function fillChartbubble() {
            //debugger;
            var optionSelected = $("[id$=ddlStage] option:selected").val();
            //var params = '{"xtype":"' + optionSelected + '"}';
            var params = '{"stageID":"' + optionSelected + '"}';
            if (optionSelected != "" && optionSelected != "0") {
                //debugger;
                var myDropDownList = $('#ddlStage');
                $.ajax({
                    type: "POST",
                    url: "chart.aspx/GetBubbleChart",
                    data: params,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        //debugger;
                        console.log(data.d);

                        var dynamicColors = function () {
                            var r = Math.floor(Math.random() * 255);
                            var g = Math.floor(Math.random() * 255);
                            var b = Math.floor(Math.random() * 255);
                            return "rgb(" + r + "," + g + "," + b + ")";
                        };
                        var xDataSets = [];

                        for (var i = 0; i < data.d.length; i++) {
                            var xDataSet = {
                                label: data.d[i]["Name"].toString(),
                                backgroundColor: dynamicColors(),
                                borderColor: "rgb(69,70,72)",
                                borderWidth: 1,
                                hoverBorderWidth: 2,
                                hoverRadius: 2,
                                data: [
                                    {
                                        x: data.d[i]["Performance"].toString(),
                                        y: data.d[i]["Competency"].toString(),
                                        r: data.d[i]["Radius"].toString()
                                    }
                                ]
                            };
                            xDataSets.push(xDataSet);
                        }
                        //debugger;
                        var strData = $.parseJSON(JSON.stringify(data.d));
                        NineBoxChart(xDataSets);

                    },
                    failure: function (response) {
                        alert(response.d);
                    }
                });

                FillDesignationList(optionSelected);
            }
        }
        function FillDesignationList(strEmpCode) {
            if (strEmpCode != "" && strEmpCode != "0") {
                //debugger;
                var myDropDownList = $("[id$=ddlDesignation]");
                var params = '{"EmpCode":"' + strEmpCode + '"}';
                $.ajax({
                    type: "POST",
                    url: "chart.aspx/GetFillDesignationList",
                    data: params,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        //debugger;
                        $("[id$=ddlDesignation]").empty();
                        $.each($.parseJSON(JSON.stringify(data.d)), function () {
                            ////debugger;
                            myDropDownList.append($("<option></option>").val(this['Value']).html(this['Text']));
                            myDropDownList.prop('selectedIndex', 0);
                        });
                    },
                    failure: function (response) {
                        alert(response.d);
                    }
                });
            }
        }
        function GetString(results) {
            //debugger;
            for (var i = 0; i < results.length; i++) {
                var xDataSet = {
                    label: results[i]["Name"].toString(),
                    backgroundColor: dynamicColors(),
                    borderColor: "rgb(69,70,72)",
                    radius: 10,
                    borderWidth: 1,
                    hoverBorderWidth: 2,
                    hoverRadius: 5,
                    data: [
                        {
                            x: results[i]["Performance"].toString(),
                            y: results[i]["Competency"].toString(),
                            r: results[i]["Radius"].toString()
                        }
                    ]
                };
                xDataSet.push(site);
            }
            //xStringVal = xStringVal.slice(0,-1);
            //return xStringVal;
        }
        function OnSuccess(response) {
            console.log(response.d);
            alert(response.d);
        }

    </script>
</asp:Content>

