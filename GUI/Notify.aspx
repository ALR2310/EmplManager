<%@ Page Title="" Language="C#" MasterPageFile="~/MyLayout.Master" AutoEventWireup="true" CodeBehind="Notify.aspx.cs" Inherits="GUI.Notify" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="content">
        <asp:GridView ID="EmailGridView" runat="server" AutoGenerateColumns="true"></asp:GridView>

        <asp:Button ID="Button1" runat="server" Text="Button" OnClick="Button1_Click" />
    </div>


</asp:Content>
