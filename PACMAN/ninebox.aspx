<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ninebox.aspx.cs" Inherits="ninebox" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>
<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="index.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="pacman.aspx">
            <img src="sitel/img/performance-360_bw.png" style="height: 10px" alt="" />PACMAN</a></li>
    </ol>
    <div class="pageheader">
        <div class="pageicon">
            <img src="sitel/img/performance-360_bw.png" style="height: 60px" alt="" />
        </div>
        <div class="pagetitle">
            <h5>Scores acheived by Managers on Performance Tests and Competency</h5>
            <h1>Nine Box</h1>
        </div>
    </div>
    <!--pageheader-->
    <style type="text/css">
        .modal {
            background: rgba(0,0,0,.7) !important;
        }

        .clscustomcenter {
            width: 0%;
            margin: 20% auto;
            padding: 10px;
            opacity: 1;
            z-index: 1000;
        }

            .clscustomcenter img {
                border-radius: 5px;
            }

            .clscustomcenter .clsloadtxt {
                display: block;
                padding-top: 12px;
                color: #fff;
                letter-spacing: 1px;
            }
    </style>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <div class="box">
        <div class="box-body">
            <div class="form-group">
                <div class="col-lg-3">
                    <div class="form-group">
                        <label>Drilldown : Reporting Manager</label>
                        <div class="input-group">
                            <div class="input-group-addon">
                                <i class="fa fa-calendar-check-o"></i>
                            </div>
                            <asp:DropDownList ItemType="text" CssClass="form-control select2" ID="ddlMgr" runat="server"
                                OnSelectedIndexChanged="ddlMgr_SelectedIndexChanged" AutoPostBack="true">
                            </asp:DropDownList>
                        </div>
                        <!-- /.input group -->
                    </div>
                </div>
                <asp:Panel ID="pnlIsPacmanDiscussion" runat="server" Visible="false">
                    <div class="col-lg-3">
                        <div class="form-group">
                            <label>Select Reportee</label>
                            <div class="input-group">
                                <div class="input-group-addon">
                                    <i class="fa fa-calendar"></i>
                                </div>
                                <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlStage" runat="server">
                                </asp:DropDownList>
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
                                <asp:DropDownList ItemType="text" CssClass="form-control select2" ID="ddlDesignation"
                                    runat="server" AutoPostBack="true">
                                </asp:DropDownList>
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
    <asp:ListView ID="lvMGR" runat="server">
        <LayoutTemplate>
            <div class="row" id="itemPlaceholderContainer" runat="server">
                <div class="col-md-6" id="itemPlaceholder" runat="server">
                </div>
            </div>
        </LayoutTemplate>
        <ItemTemplate>
            <div class="col-md-6" runat="server">
                <div class="box box-primary" runat="server">
                    <div class="box-header with-border" runat="server">
                        <h3 class="box-title" runat="server"><%#Eval("NAME") %> (
                            <label id="lblEmpID"><%#Eval("EMPCODE") %></label>
                            )</h3>
                        <div class="box-tools pull-right" runat="server">
                            <button type="button" class="btn btn-box-tool" data-widget="collapse" runat="server">
                                <i class="fa fa-minus" runat="server"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body" style="height: 300px; width: 600px" runat="server">
                        <div class="chart-container" runat="server">
                            <canvas id="mgrChart<%#Eval("EMPCODE") %>" class="mgrChart<%#Eval("EMPCODE") %>" style="height: 300px; width: 600px"></canvas>

                        </div>
                    </div>
                    <!-- /.box-body  -->
                    <%--<div class="box-footer">
                        <div class="progress progress-sm">
                            <progress id="mgrChartAnimationProgress<%#Eval("EMPCODE") %>" class="progress-bar progress-bar-primary progress-bar-striped" role="progressbar" max="1" value="0" style="width: 100%"></progress>
                        </div>
                    </div>--%>
                </div>
                <!-- /.box -->
            </div>
        </ItemTemplate>
    </asp:ListView>
    <asp:ListView ID="lvSkill" runat="server">
        <LayoutTemplate>
            <div class="row" id="itemPlaceholderContainer" runat="server">
                <div class="col-md-6" id="itemPlaceholder" runat="server">
                </div>
            </div>
        </LayoutTemplate>
        <ItemTemplate>
            <div class="col-md-6" runat="server">
                <div class="box box-default box-solid">
                    <div class="box-header with-border">
                        <h3 class="box-title">Department : <%#Eval("Skillset") %></h3>
                        <div class="box-tools pull-right">
                            <button type="button" class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="chart-container">
                            <canvas id="skillChart<%#Eval("SkillsetID") %>" class="skillChart<%#Eval("SkillsetID") %>" style="height: 300px; width: 600px"></canvas>
                        </div>
                    </div>
                    <!-- /.box-body  -->
                </div>
                <!-- /.box -->
            </div>
        </ItemTemplate>
    </asp:ListView>
    <div id="progress" class="modal">
        <div class="clscustomcenter">
            <img src="AdminLTE/bower_components/ckeditor/plugins/mathjax/images/loader.gif" />
            <span class="clsloadtxt">processing....</span>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">


    <script type="text/javascript" src="Sitel/cdn/chartjs/Chart.bundle.min.js"></script>
    <script type="text/javascript">
        $(function () {

            $('#progress').show();
            var EMPCODE = $('#lblEmpID').text();
            $('[class*="mgrChart"]').each(function () {
                var id = $(this).prop('id');
                id = id.replace("mgrChart", "");
                if (parseInt(id) > 0) {
                    fillChartbubble(id);
                }
            });
            $('[class*="skillChart"]').each(function () {
                var id = $(this).prop('id');
                id = id.replace("skillChart", "");
                if (parseInt(id) > 0 && parseInt(EMPCODE) > 0) {
                    //Fill the charts with skill based charts
                    fillSkillSetBubble(EMPCODE, id);
                }

            });

            $('#progress').hide();
        });
        function fillChartbubble(optionSelected) {
            //debugger;            

            var params = '{"EMPCODE":"' + optionSelected + '"}';
            if (optionSelected != "" && optionSelected != "0") {
                //debugger;   

                $.ajax({
                    type: "POST",
                    url: "ninebox.aspx/GetBubbleChart",
                    data: params,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {

                        //console.log(data.d);


                        //// With Fixed Color palette
                        var xDataSets = [];
                        for (var i = 0; i < data.d.length; i++) {
                            var myColor = fixedColorPalette(i);
                            var xDataSet = {
                                label: data.d[i]["Name"].toString(),
                                backgroundColor: myColor,
                                hoverBackgroundColor: myColor,
                                //hoverRadius: -1,
                                borderColor: myColor,
                                //borderWidth: 1,
                                hoverBorderWidth: 2,
                                hoverRadius: 0,//-0.001,
                                // hitRadius: 1,
                                data: [
                                    {
                                        x: data.d[i]["Performance"],
                                        y: data.d[i]["Competency"],
                                        r: data.d[i]["Radius"],
                                    }

                                ],
                                //hoverRadius: 1,
                                //hitRadius: 1,
                            };
                            xDataSets.push(xDataSet);
                        }
                        ////debugger;
                        var strData = $.parseJSON(JSON.stringify(data.d));
                        NineBoxChart(xDataSets);
                    },
                    failure: function (response) {
                        alert(response.d);
                    }
                });
            }
            function NineBoxChart(xdata) {
                var ctx = $("#mgrChart" + optionSelected);
                //var progress = $("mgrChartAnimationProgress" + optionSelected);
                if (xdata != null) {
                    ctx.empty();

                }
                var myChart = new Chart(ctx, {
                    type: 'bubble',
                    data: {
                        labels: "Managers",
                        datasets: xdata,
                        //hoverRadius: 0,
                    },

                    options: {
                        events: ['click'],
                        onClick: function (e) {
                            //debugger;
                           
                            var element = this.getElementAtEvent(e);
                           
                            // If you click on at least 1 element ...
                            if (element.length > 0) {
                                // Logs it
                                console.log(element[0]);

                                // Here we get the data linked to the clicked bubble ...
                                var datasetLabel = this.config.data.datasets[element[0]._datasetIndex].label;
                                // data gives you `x`, `y` and `r` values
                                var data = this.config.data.datasets[element[0]._datasetIndex].data[element[0]._index];
                                alert(datasetLabel + ", " + data);
                            }
                        },

                        title: {
                            display: false,
                            text: 'Scores acheived by Managers on Performance Tests and Competency'
                        },
                        legend: {
                            display: true,
                            position: 'right'
                        },
                        animation: {
                            duration: 2500,
                            //onProgress: function (animation) {
                            //    progress.val(animation.currentStep / animation.numSteps);
                            //}
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
                                    labelString: "Competency (More is better)"
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
                                    labelString: "Performance (More is better)"
                                }
                            }]
                        },
                        backgroundColor: 'pink'
                    },
                });

            }
        }
        function fillSkillSetBubble(EmpCode, Skill) {
            //debugger; 

            var params = '{"EMPCODE":"' + EmpCode + '", "Skill":"' + Skill + '"}';
            if (EmpCode != "" && EmpCode != "0") {
                //debugger;    

                $.ajax({
                    type: "POST",
                    url: "ninebox.aspx/GetSkillChart",
                    data: params,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        //debugger;
                        //console.log(data.d);


                        var xDataSets = [];
                        for (var i = 0; i < data.d.length; i++) {
                            var myColor = fixedColorPalette(i);
                            var xDataSet = {
                                label: data.d[i]["Name"].toString(),
                                backgroundColor: myColor,
                                hoverBackgroundColor: myColor,
                                //hoverRadius: -1,
                                borderColor: myColor,
                                //borderWidth: 1,
                                hoverBorderWidth: 1,
                                hoverRadius: 0,//-0.001,
                                // hitRadius: 1,
                                data: [
                                    {
                                        x: data.d[i]["Performance"],
                                        y: data.d[i]["Competency"],
                                        r: data.d[i]["Radius"],
                                    }

                                ],
                                //hoverRadius: 1,
                                //hitRadius: 1,
                            };
                            xDataSets.push(xDataSet);
                        }
                        ////debugger;
                        var strData = $.parseJSON(JSON.stringify(data.d));
                        NineBoxChart(xDataSets);
                    },
                    failure: function (response) {
                        alert(response.d);
                    }
                });
            }
            function NineBoxChart(xdata) {
                var ctx = $("#skillChart" + Skill);
                var progress = $("skillChartAnimationProgress" + Skill);
                if (xdata != null) {
                    ctx.empty();
                }
                var myChart = new Chart(ctx, {
                    type: 'bubble',
                    data: {
                        labels: "Managers",
                        datasets: xdata,
                        //hoverRadius: 0,
                    },
                    options: {
                        title: {
                            display: false,
                            text: 'Scores acheived by Managers on Performance Tests and Competency'
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
                                    labelString: "Competency (More is better)"
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
                                    labelString: "Performance (More is better)"
                                }
                            }]
                        },
                        legend: {
                            display: false
                        },
                        animation: {
                            duration: 2500,
                            //onProgress: function (animation) {                                
                            //    progress.val(animation.currentStep / animation.numSteps);
                            //}
                        },

                    },
                });
            }
        }
        function fixedColorPalette(i) {
            //var palette = [
            //    "rgba(54, 109, 209, 1)",
            //    "rgba(103, 158, 2, 1)",
            //    "rgba(163, 212, 68, 1)",
            //    "rgba(206, 235, 129, 1)",
            //    "rgba(242, 255, 181, 1)",
            //    "rgba(105, 22, 3, 1)",
            //    "rgba(158, 68, 34, 1)",
            //    "rgba(212, 132, 84, 1)",
            //    "rgba(235, 181, 127, 1)",
            //    "rgba(255, 226, 170, 1)",
            //];
            //var l = palette.length - 1;

            //l = Math.abs(l - i);
            //debugger;
            var dynamicColors = function () {
                var r = Math.floor(Math.random() * 255);
                var g = Math.floor(Math.random() * 255);
                var b = Math.floor(Math.random() * 255);
                return "rgb(" + r + "," + g + "," + b + ")";
            };

            //return palette[l].toString();

            return dynamicColors;
        }
    </script>
</asp:Content>

