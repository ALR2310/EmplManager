<%@ Page Title="" Language="C#" MasterPageFile="~/MyLayout.Master" AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Inherits="GUI.HomePage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Style/homePage.css" />
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="content">
        <%--<div class="homePage">
        </div>--%>


        <iframe src="https://www.sweetsoft.vn/vi/home" class="homePage" id="myIframe"></iframe>

        <script>
            function abc() {
                if (window.location.href === "http://projectctysf.com/trang-chu" || window.location.href === "https://projectctysf.com/trang-chu") {
                    document.querySelector(".search-box").classList.add("hide");
                    console.log("đã ẩn");
                } else {
                    console.log("lỗi");
                }
                console.log("đã gọi");
            }
            abc()
        </script>




    </div>

</asp:Content>
