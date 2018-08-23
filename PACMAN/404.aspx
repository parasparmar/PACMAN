<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="404.aspx.cs" Inherits="_404" %>

<asp:Content ID="One" ContentPlaceHolderID="pageheader" runat="server"></asp:Content>
<asp:Content ID="Two" ContentPlaceHolderID="headPlaceHolder" runat="server"></asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <!-- Main content -->
    <section class="content">
        <div class="error-page text-center">
            <h2 class="headline text-navy" style="float: none !important"><i class="fa fa-unlink text-navy"></i>Error!</h2>
            <div class="clearfix"></div>
            <div class="padding-10">
                <h3 class="text-center">This error has been logged.</h3>
                <!-- /.error-content -->
                <p class="text-center">
                    Please choose from these options.
                </p>
            </div>
        </div>
        <div class="row">
            <div class="col-md-4">
                <h4 class="text-center">Take me <a href="index.aspx">Home!</a></h4>
            </div>
            <div class="col-md-4">
                <h4 class="text-center"><a href="mailto:iaccess_support@sitel.com"><asp:LinkButton ID="ltlFlagForFollowUp" runat="server" Text=""></asp:LinkButton></a></h4>
                <asp:Button ID="btnErrorMessage" runat="server" CssClass="btn btn-default center-block" Text="I'd Appreciate A Follow Up!" OnClick="btnErrorMessage_Click"></asp:Button>
            </div>
            <div class="col-md-4">
                <h4 class="text-center"><a href="index.aspx">I'll Retry!</a></h4>
            </div>
        </div>
        <!-- /.error-page -->
    </section>
    <!-- /.content -->
</asp:Content>


