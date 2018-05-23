<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="maintenance.aspx.cs" Inherits="maintenance" %>


<asp:Content ID="Content3" ContentPlaceHolderID="leftmenu" runat="Server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <div class="lockscreen-wrapper">
        <div class="lockscreen-logo">
            <a href="#"><b>PACMAN</b></a>
            <div class="lockscreen-name">
                <asp:Literal ID="ltlempName" runat="server" Text="is undergoing scheduled maintenance."></asp:Literal>
            </div>
            <!-- User name -->


        </div>
    </div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
</asp:Content>

