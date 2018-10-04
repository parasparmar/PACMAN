<%@ Page Title="My PACMAN" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="pivot.aspx.cs" Inherits="pivot" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>

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
    <div class="box-body">
        <button id="btnGetOverallData" type="button" class="btn btn-primary" onclick="getOverallData()">Refresh Data</button>
        <!-- PivotJS chart-->
        <div class="chart tab-pane active" id="grace-pivot" style="position: relative; min-height: 300px">
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <!-- jQuery 3 -->    
    <script src="Sitel/cdn/pivotjs/jquery-ui.min.js"></script>
    <link href="Sitel/cdn/pivotjs/pivot.css" rel="stylesheet" />
    <script src="Sitel/cdn/pivotjs/pivot.min.js"></script>
    <script src="Sitel/cdn/pivotjs/plotly-basic-latest.min.js"></script>
    <script src="Sitel/cdn/pivotjs/plotly_renderers.js"></script>

    <script>
        $(function () {
            getOverallData();
        });

        function getOverallData() {
            var PeriodId = 9;
            $.ajax({
                type: "POST",
                url: "pivot.aspx/GetChartData",
                data: "{PeriodId:'" + PeriodId + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    //alert("Success : " + response.status);
                    OnSuccessDrawChart(response.d);
                },
                failure: function (response) {
                    alert("failure : " + response.status);
                },
                error: function (response) {
                    alert("error : " + response.status);
                }
            });


            function OnSuccessDrawChart(mps) {

                var derivers = $.pivotUtilities.derivers;
                var renderers = $.extend($.pivotUtilities.renderers, $.pivotUtilities.plotly_renderers);

                $("#grace-pivot").pivotUI(mps, {
                    renderers: renderers,
                    cols: ["FinalRating"], rows: ["Role"],
                    rendererName: "Table",
                    rowOrder: "value_a_to_z",

                });


                ////$("#grace-pivot").pivotUI(mps, { renderers: renderers });
            }
        }
        function getDetailedData() {
            $.ajax({
                type: "POST",
                url: "pivot.aspx/GetChartDataDetailed",
                data: '',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    //alert("Success : " + response.status);
                    OnSuccessDrawChart(response.d);
                },
                failure: function (response) {
                    alert("failure : " + response.status);
                },
                error: function (response) {
                    alert("error : " + response.status);
                }
            });


            function OnSuccessDrawChart(mps) {
                var derivers = $.pivotUtilities.derivers;
                var renderers = $.extend($.pivotUtilities.renderers,
                    $.pivotUtilities.plotly_renderers);
                $("#grace-pivot").pivotUI(mps, { renderers: renderers });
            }

        }
    </script>
</asp:Content>
