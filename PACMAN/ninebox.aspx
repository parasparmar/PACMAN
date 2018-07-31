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

    <link href="https://cdn.datatables.net/fixedheader/3.1.5/css/fixedHeader.dataTables.min.css" rel="stylesheet" />

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
    <style type="text/css">
        /*.widget-user .widget-user-image {
            position: absolute;
            top: 25%;
            right: 5%;
            margin-left: -45px;
        }*/
    </style>
    <div class="modal fade" id="modalEmployee">
        <div class="modal-dialog" style="width: 80%;">
            <div class="modal-content">
                <div class="box box-widget widget-user-2">
                    <div class="widget-user-header bg-primary">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span></button>
                        <div class="widget-user-image" style="margin-bottom: -8%; overflow: hidden;">
                            <img id="mdUserImage" class="img-circle" src="Sitel/user_images/gsing017_0.jpg" alt="User Avatar" style="height: 65px; width: 65px;">
                        </div>
                        <!-- /.widget-user-image -->
                        <h3 class="widget-user-username" id="mdEmpName"></h3>
                        <h5 class="widget-user-desc" id="mdRepMgr"></h5>
                    </div>
                </div>
                <!-- Custom Tabs -->
                <div class="nav-tabs-custom">
                    <ul class="nav nav-tabs">
                        <li class="active"><a href="#tabPacman" data-toggle="tab">Performance&nbsp&nbsp<span id="spanPacman" class="badge pull-right bg-green">4.5</span></a></li>
                        <li><a href="#tabTest" data-toggle="tab">Test&nbsp&nbsp<span id="spanTest" class="badge pull-right bg-yellow">1.5</span></a></li>
                        <li><a href="#tabCompetency" data-toggle="tab">Competency&nbsp&nbsp<span id="spanCompetency" class="badge pull-right bg-red">1.5</span></a></li>
                    </ul>
                    <div class="tab-content">
                        <div class="tab-pane active" id="tabPacman">
                            <b>PACMAN Ratings</b>
                        </div>
                        <!-- /.tab-pane -->
                        <div class="tab-pane" id="tabTest">
                            <b>Test Scores</b>
                        </div>
                        <!-- /.tab-pane -->
                        <div class="tab-pane" id="tabCompetency" style="overflow-y: scroll; height: 420px; overflow-x: hidden;">
                            <b>Competency Feedback</b>
                            <div id="xxxx"></div>
                        </div>
                        <!-- /.tab-pane -->
                    </div>
                    <!-- /.tab-content -->
                </div>
                <!-- nav-tabs-custom -->
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <!-- /.modal -->
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">


    <script type="text/javascript" src="Sitel/cdn/chartjs/Chart.bundle.min.js"></script>
    <script src="Sitel/cdn/jsontotable/jquery.jsontotable.min.js"></script>

    <script src="https://cdn.datatables.net/fixedheader/3.1.5/js/dataTables.fixedHeader.min.js"></script>

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
            // //debugger;;            

            var params = '{"EMPCODE":"' + optionSelected + '"}';
            if (optionSelected != "" && optionSelected != "0") {
                // //debugger;;   

                $.ajax({
                    type: "POST",
                    url: "ninebox.aspx/GetBubbleChart",
                    data: params,
                    async: true,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (responseData) {
                        //console.log(data.d);
                        //// With Fixed Color palette
                        var xDataSets = [];
                        for (var i = 0; i < responseData.d.length; i++) {
                            var myColor = fixedColorPalette(i);
                            // //debugger;;
                            var xVar = responseData.d[i]["Name"].toString() + " : " + responseData.d[i]["EmpCode"].toString() + " : " + responseData.d[i]["Period"].toString();
                            var xDataSet = {
                                label: xVar,
                                backgroundColor: myColor,
                                hoverBackgroundColor: myColor,
                                hoverRadius: -1,
                                borderColor: myColor,
                                borderWidth: 1,
                                hoverBorderWidth: 2,
                                hoverRadius: 0,//-0.001,
                                hitRadius: 1,
                                data: [
                                    {
                                        x: responseData.d[i]["Performance"],
                                        y: responseData.d[i]["Competency"],
                                        r: responseData.d[i]["Radius"],
                                    }

                                ],
                            };
                            xDataSets.push(xDataSet);
                        }
                        //// //debugger;;
                        ////var strData = $.parseJSON(JSON.stringify(responseData.d));
                        NineBoxChart(xDataSets);
                    },
                    failure: function (responseData) {
                        alert(responseData.d);
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
                            getEmpStats(e, this);
                        },
                        title: {
                            display: false,
                            text: 'Scores acheived by Managers on Performance Tests and Competency'
                        },
                        legend: {
                            display: false,
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
        function getEmpStats(e, me) {
            var element = me.getElementAtEvent(e);
            // If you click on at least 1 element ...
            if (element.length > 0) {

                // Here we get the data linked to the clicked bubble ...
                var Header = me.config.data.datasets[element[0]._datasetIndex].label;
                EmpName = Header.split(":");
                var EmpCode = EmpName[1].trim();
                var Period = EmpName[2].trim();
                var params = '{"empcode":"' + EmpCode + '", "period":"' + Period + '"}';
                // get Employee Stats
                $.ajax({
                    type: "POST",
                    url: "ninebox.aspx/getEmpStatsFromDB",
                    data: params,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (responseData) {
                        //alert(responseData.d);

                        var d = JSON.parse(responseData.d);
                        // //debugger;;
                        $('#mdUserImage').attr('src', 'Sitel/user_images/' + d[0].UserImage);
                        $('#mdEmpName').text(Header);
                        $('#mdRepMgr').text(Header);

                        $('#spanPacman').text(d[0].PacManRating);
                        $('#spanTest').text(d[0].TestScore);
                        $('#spanCompetency').text(d[0].CompetencyRating);

                        $('#tdEmpcode').text(EmpCode);
                        $('#tdName').text(EmpName[0].trim());
                        $('#tdReportingManager').text();

                        $('#modalEmployee').modal('show',
                            function (event) {
                                event.preventDefault();
                            });

                    },
                    failure: function (responseData) {
                        alert(responseData.d);
                    }
                });

                // get Employee Competency
                $.ajax({
                    type: "POST",
                    url: "ninebox.aspx/getEmpCompetencyFromDB",
                    data: params,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (responseData) {
                        //alert(responseData.d);
                        //debugger;;
                        //var d = JSON.parse(responseData.d);
                        //var d = jQuery.parseJSON(responseData.d);
                        //var d = $.parseJSON(JSON.stringify(responseData.d)); //responseData.d;
                        var d = responseData.d;

                        var strTable = '<table id="xCompetenctTable" class="table table-condensed table-bordered table-striped table-hover table-responsive xCompetenctTable" ><thead><tr><th>COMPETENCY</th><th>DESCRIPTION</th><th>COMMENTS</th><th>RATING</th><th>RATING SCALE</th></tr></thead><tbody>';
                        for (var i = 0; i < d.length - 1; i++) {
                            strTable += '<tr><td>' + d[i].COMPETENCY + '</td><td>' + d[i].DESCRIPTION + '</td><td>' + d[i].COMMENTS + '</td><td>' + d[i].RATING + '</td><td>' + d[i].RATINGSCALE + '</td></tr>';

                        }
                        strTable += '</tbody></table>';

                        $('#xxxx').html("");
                        $('#xxxx').append(strTable);
                        pluginsInitializer();
                        //$.jsontotable(responseData.d, { id: '#tabCompetency', header: true, className: 'table table-hover' });

                        //$('#modalEmployee').modal();

                    },
                    failure: function (responseData) {
                        alert(responseData.d);
                    }
                });

            }
        }

        function fillSkillSetBubble(EmpCode, Skill) {
            // //debugger;; 

            var params = '{"EMPCODE":"' + EmpCode + '", "Skill":"' + Skill + '"}';
            if (EmpCode != "" && EmpCode != "0") {
                // //debugger;;    

                $.ajax({
                    type: "POST",
                    url: "ninebox.aspx/GetSkillChart",
                    data: params,
                    async: true,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        // //debugger;;
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
                        //// //debugger;;
                        ////var strData = $.parseJSON(JSON.stringify(data.d));
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
                            duration: 1000,
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
            // //debugger;;
            var dynamicColors = function () {
                var r = Math.floor(Math.random() * 255);
                var g = Math.floor(Math.random() * 255);
                var b = Math.floor(Math.random() * 255);
                return "rgb(" + r + "," + g + "," + b + ")";
            };

            //return palette[l].toString();

            return dynamicColors;
        }

        $(function () {
            pluginsInitializer();
        });
    </script>

    <script>
        function pluginsInitializer() {
            var table = $('.xCompetenctTable').dataTable({
                destroy: true,
                responsive: true,
                fixedHeader: true,
                "sPaginationType": "full_numbers",
                "lengthMenu": [2, 5, 10, 25, 50, 75],
                "aaSortingFixed": [[0, 'asc']],
                "bSort": true,
                //dom: 'Bfrltip',
                "columnDefs": [{ "orderable": false, "targets": 0 }],
            });
            $(".xCompetenctTable").css('width', '');
            //new $.fn.dataTable.FixedHeader(table);
        }


        $(function () {
            pluginsInitializer();
        });
    </script>
</asp:Content>

