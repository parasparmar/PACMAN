<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="chart.aspx.cs" Inherits="chart" %>


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
                            <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlReviewPeriod" runat="server">
                            </asp:DropDownList>
                        </div>
                        <!-- /.input group -->
                    </div>
                </div>
                <asp:Panel ID="pnlIsPacmanDiscussion" runat="server" Visible="true">
                    <div class="col-lg-3">
                        <div class="form-group">
                            <label>Select Review Stage</label>
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
                            <label>Select Reportee</label>
                            <div class="input-group">
                                <div class="input-group-addon">
                                    <i class="fa fa-user"></i>
                                </div>
                                <asp:DropDownList ItemType="text" CssClass="form-control select2" ID="ddlReportee"
                                    runat="server" AutoPostBack="true">
                                </asp:DropDownList>
                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="form-group">
                            <label>Is SPI</label>
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

</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.bundle.min.js"></script>
    <script>
        $(function () {
            var ctx = $("#myChart");
            var myChart = new Chart(ctx, {
                type: 'bubble',
                data: {
                    labels: "Managers",
                    datasets: [
                        {
                            label: 'Manoj',
                            data: [{ x: 33, y: 33, r: 33 }],
                            backgroundColor: ['rgba(255, 99, 132, 0.2)'],
                            borderColor: ['rgba(255,99,132,1)'],
                            borderWidth: 1
                        }
                        , {
                            label: 'Durgesh',
                            data: [{ x: 66, y: 66, r: 33 }],
                            backgroundColor: ['rgba(54, 162, 235, 0.2)'],
                            borderColor: ['rgba(75, 192, 192, 1)'],
                            borderWidth: 1
                        }
                        , {
                            label: 'Vinod',
                            data: [{ x: 60, y: 60, r: 33 }],
                            backgroundColor: ['rgba(255, 206, 86, 0.2)'],
                            borderColor: ['rgba(255,99,132,1)'],
                            borderWidth: 1
                        }
                        , {
                            label: 'Vishal',
                            data: [{ x: 45, y: 45, r: 33 }],
                            backgroundColor: ['rgba(255, 99, 132, 0.2)'],
                            borderColor: ['rgba(153, 102, 255, 1)'],
                            borderWidth: 1
                        }
                        , {
                            label: 'Athang',
                            data: [{ x: 75, y: 75, r: 33 }],
                            backgroundColor: ['rgba(75, 192, 192, 0.2)'],
                            borderColor: ['rgba(255, 159, 64, 1)'],
                            borderWidth: 1
                        }
                        , {
                            label: 'Prashant',
                            data: [{ x: 20, y: 20, r: 33 }],
                            backgroundColor: ['rgba(255, 99, 132, 0.2)'],
                            borderColor: ['rgba(255, 159, 64, 0.2)'],
                            borderWidth: 1
                        }



                    ]

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

        });
    </script>
</asp:Content>

