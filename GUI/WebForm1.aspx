<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="GUI.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>
      
    </title>
      <link href="~/Styles/Chat.css" rel="stylesheet"/>
</head>
<body>
    <form id="form1" >
        <div id="chat">
            <div class="message-container">
                <img class="avatar" src="https://static.thenounproject.com/png/5034901-200.png"></img>
                <div class="content">
                    <div class="titles">
                        <span class="name">Admin</span>
                        <span class="date" >3:00AM</span>
                    </div>
                   
                        <span class="message">Hello</span>

                </div>
        
            </div>
            <span class="message">Hello</span>
                <span class="message">Hello</span>

              <div class="message-container user-container">
                <img class="avatar" src="https://static.thenounproject.com/png/5034901-200.png"></img>
                <div class="content">
                    <div class="titles">
                              <span class="date" >3:00AM</span>
                        <span class="name">Admin</span>
                  
                    </div>
                   
                        <span class="message">Hello</span>

                </div>
        
            </div>
        </div>
    </form>
</body>
</html>
