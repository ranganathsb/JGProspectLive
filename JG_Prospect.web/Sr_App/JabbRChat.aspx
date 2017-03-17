<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="JabbRChat.aspx.cs" Inherits="JG_Prospect.Sr_App.JabbRChat" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
    <form name="frmJabbRChatLogin" action="http://chat.jmgrovebuildingsupply.com/account/login?ReturnUrl=%2F" method="post">
        <input type="text" id="username" name="username" value="<%=JG_Prospect.JGSession.UserLoginId.Replace("@",".")%>" placeholder="Username" />
        <input type="password" id="password" name="password" value="<%=JG_Prospect.JGSession.UserPassword%>" class="span10" placeholder="Password" />
    </form>
    <script type="text/javascript">
        //document.frmJabbRChatLogin.submit();
    </script>
</body>
</html>
