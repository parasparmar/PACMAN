<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ratings.aspx.cs" Inherits="ratings" %>

<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <style>
        body {
            font-family: Verdana;
        }

        .c3-line, .c3-focused {
            stroke-width: 3px !important;
        }

        .c3-bar {
            stroke: white !important;
            stroke-width: 1;
        }

        .c3 text {
            font-size: 12px;
            color: grey;
        }

        .tick line {
            stroke: white;
        }

        .c3-axis path {
            stroke: grey;
        }

        .c3-circle {
            opacity: 1 !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <button id="btnGetOverallData" type="button" class="btn btn-primary" onclick="getOverallData()">Overall Data</button>
    <%--<button id="btnGetDetailedData" type="button" class="btn btn-warning" onclick="getDetailedData()">Overall Detailed Data</button>--%>
    <div id="output">
    </div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <script src="https://cdn.plot.ly/plotly-basic-latest.min.js"></script>
    <script type="text/javascript" src="Sitel/cdn/pivotjs/jquery-ui.min.js"></script>
    <script src="Sitel/cdn/pivotjs/pivot.js"></script>
    <link href="Sitel/cdn/pivotjs/pivot.css" rel="stylesheet" />
    <script src="Sitel/cdn/pivotjs/plotly_renderers.js"></script>

    <script>
        function getOverallData() {
            $.ajax({
                type: "POST",
                url: "ratings.aspx/GetChartData",
                data: '',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    alert("Success : " + response.status);
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
                $("#output").pivotUI(mps, { renderers: renderers });
            }
        }
        function getDetailedData() {
            $.ajax({
                type: "POST",
                url: "ratings.aspx/GetChartDataDetailed",
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
                $("#output").pivotUI(mps, { renderers: renderers });
            }

        }
        $(function () {
            getOverallData();
        });
    </script>

</asp:Content>

