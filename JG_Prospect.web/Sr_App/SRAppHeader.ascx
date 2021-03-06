﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SRAppHeader.ascx.cs" Inherits="JG_Prospect.Sr_App.SRAppHeader" %>
<%@ Register Src="~/Controls/TaskGenerator.ascx" TagPrefix="uc1" TagName="TaskGenerator" %>

<!--tabs jquery-->
<%--<script type="text/javascript" src="../js/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/jquery.ui.widget.js"></script>
<!--tabs jquery ends-->
<script type="text/javascript">
    $(function () {
        // Tabs
        $('#tabs').tabs();
    });
		</script>
<style type="text/css">
.ui-widget-header {
	border: 0;
	background:none/*{bgHeaderRepeat}*/;
	color: #222/*{fcHeader}*/;
}
</style>--%>
<style>
    #divTask {
        
        height: 265px;
    }

        #divTask:hover {
            
        }
    /*#divTask:hover > nav {
            position:fixed;
        }*/
    #test a {
        color: red;
    }

    

    .img-Profile {
        border-radius: 50%;
        width: 77px;
        height: 76px;
    }

    .ProfilImg .caption {
    opacity: 0.6;
    position: absolute;
    /* height: 28px; */
    width: 75px;
    bottom: 3px;
    padding: 1px 0px;
    color: #ffffff;
    background: #1f211f;
    text-align: center;
    font-weight: normal;
    left: 1px;
}
    #ViewTab ul {
        position: absolute;
        top: 415px;
        margin-right: 19px;
    }
    .content_panel{
        margin-top:46px;
    }
    .search_google input[type=text]{
        margin-top: 97px;
    }
    .tasklist{
        width: 100% !important;
        margin-left: 0px !important;
    }
    /*.ProfilImg:hover .caption {
        opacity: 0.6;
    }*/
</style>
<script>

</script>
<div class="header">
    <%--<img src="../img/logo.png" alt="logo" width="88" height="89" class="logo" />--%>
    <table style="width: 100%">
        <tr>
            <td style="height: 265px; width: 225px">
                <div class="logo" style="font-weight: bold; color: red;">
                    <img src="../img/logo.png" alt="logo" width="88" height="89"><br>
                    <%--<hr style="width: 68%;">--%>
                    <span style="font-size: 13px;">JMGC LLC - #001</span><hr style="width: 68%;">
                    <br>
                    <span style="color: white;">72 E Lancaster Ave </span>
                    <br>
                    <span>Malvern, PA 19355</span><br>
                    <span style="color: white;">HR: (215)483-3098 EXT#4</span><br>
                    <span style="background-color: yellow;"></span>
                </div>
            </td>
            <td>
                <div id="divTask">
                    <uc1:TaskGenerator runat="server" ID="TaskGenerator" />
                </div>
            </td>
            <td style="width: 392px"></td>
        </tr>
    </table>    
    
    <div class="user_panel">
        <div class="ProfilImg">
            <asp:Image CssClass="img-Profile" ID="imgProfile" runat="server" />
            <asp:HyperLink class="caption" runat="server" ID="hLnkEditProfil" Text="Edit"></asp:HyperLink>
        </div>
            Welcome! 
        <span>
            <asp:Label ID="lbluser" runat="server" Text="User"></asp:Label>
            
            <asp:Button ID="btnlogout" runat="server" Text="Logout" CssClass="cancel" ValidationGroup="header" OnClick="btnlogout_Click" />
        </span>
        <span><asp:Label ID="lblDesignation" runat="server" Text="" CssClass="designation-container"></asp:Label></span>
        <ul>
            <li><a href="home.aspx">Home</a></li>
            <li>|</li>
            <li><a href='<%=Page.ResolveUrl("~/changepassword.aspx")%>'>Change Password</a></li>
            <li>|</li>
            <li><input type="text" placeholder="Search" class="search-box"/></li>
        </ul>
        <ul style="margin-top: 14px;">
            <li><a href="#" onclick="InitiateBlankChat(this,'all')" class="red-text">All</a></li>
            <li>&nbsp;&nbsp;|&nbsp;&nbsp;</li>
            <!--Email with # of unread msgs and new font-->
            <li id="test"><a id="hypEmail" class="clsPhoneLink" onclick="InitiateBlankChat(this, 'email')" runat="server" style="color: white;">Emails<label id="emailUnreadCount" class="badge badge-error">0</label><label id="lblUnRead" class="badge badge-error hide"></label></a></li>
            <li>&nbsp;&nbsp;|&nbsp;&nbsp;</li>
            <li><a id="idPhoneLink" runat="server" class="clsPhoneLink" href="/Sr_App/autodialer.aspx">Phone / Vmail(0)<label id="lblNewCounter" class="badge badge-error">10</label><label id="lblUnRead" class="badge badge-error hide"></label></a></a></li>
            <li>&nbsp;&nbsp;|&nbsp;&nbsp;</li>
            <li><a id="hypChat" href="#" class="clsPhoneLink" onclick="InitiateBlankChat(this, 'chat');">Chat <label id="chatUnreadCount" style="display:none;" class="badge badge-error"></label><label class="badge badge-error hide"></label></a></a></li>
        </ul>
    </div>
    <div class="header-msg">
        <div class="no-user">Loading Online Users...</div>
    </div>
</div>
<!--nav section-->
<div class="nav">
    <ul>
        <%--<li>Toggle Menu</li>--%>
        <li><a href="home.aspx">Home</a></li>
        <li><a href="new_customer.aspx">Add Customer</a></li>
        <%-- <li><a href="view_customer.aspx">Review / Edit Customer Estimate</a></li>--%>
        <li><a href="ProductEstimate.aspx">Product Estimate</a></li>
        <li><a href="SalesReort.aspx">Sales Report</a></li>
        <%--<li><a href="Vendors.aspx">Vendor Master</a></li>--%>
        <li id="Li_Jr_app" runat="server" visible="true"><a href="~/home.aspx" runat="server"
            id="Jr_app">Junior App</a></li>
        <li id="Li_Installer" runat="server" visible="true"><a href="~/Installer/InstallerHome.aspx" runat="server"
            id="A1">Installer</a></li>


        <%-- <li><a href="/EditUser.aspx" runat="server" id="edituser">EditUser</a></li>
  <li><a href="/Accounts/newuser.aspx" runat="server" id ="newuser">CreateUser</a></li>--%>
    </ul>
</div>
<script type="text/javascript">
    function SetEmailCounts() {

        $.ajax({
            type: "POST",
            url: "ajaxcalls.aspx/GetEmailCounters",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (data) {
                console.log(data);
                if (data.d) {
                    var counters = JSON.parse(data.d);
                    console.log(counters);
                    if (counters) {
                        $('#lblNewCounter').html(counters.newone);
                        $('#lblNewCounter').show();
                        $('#lblUnRead').html("Unread: " + counters.unread);
                    }
                    //response(data.length === 1 && data[0].length === 0 ? [] : JSON.parse(data.d));
                }
            }
        });
    }

    function OpenChatWindow() {
        
        $('<img />').attr({
            src: '/img/ajax-loader.gif',
            id: 'chatprogress'
        }).appendTo($('#hypChat'));

        $.ajax({
            type: "POST",
            url: "ajaxcalls.aspx/LogintoChat",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (data) {
                console.log(data);
                if (data.d) {
                    var counters = JSON.parse(data.d);
                    console.log(counters);
                    if (counters == "1") {
                        window.open('/Sr_App/JabbRChat.aspx', "JMG - Chat", "width=600,height=600,scrollbars=yes");
                    }
                    else {
                        alert('Couldn\'t Login to Chat application right now, Please try again later.');
                    }
                }
                else {
                    alert('Couldn\'t Login to Chat application right now, Please try again later.');
                }
                $('#hypChat').html('Chat');
            },
            error: function () {
                $('#hypChat').html('Chat');
            }
        });

    }
</script>
