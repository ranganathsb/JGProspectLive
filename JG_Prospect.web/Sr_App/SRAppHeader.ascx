<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SRAppHeader.ascx.cs" Inherits="JG_Prospect.Sr_App.SRAppHeader" %>
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
        width: 80%;
        height: 150px;
    }

        #divTask:hover {
            height: 100%;
            position: absolute;
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
        height: 28px;
        width: 75px;
        bottom: 0px;
        padding: 2px 0px;
        color: #ffffff;
        background: #1f211f;
        text-align: center;
        font-weight: bold;
        left: 2px;
    }

    /*.ProfilImg:hover .caption {
        opacity: 0.6;
    }*/
</style>
<script>

</script>
<div class="header">
    <img src="../img/logo.png" alt="logo" width="88" height="89" class="logo" />
    <div id="divTask">
        <uc1:TaskGenerator runat="server" ID="TaskGenerator" />
    </div>
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
            <!--Email with # of unread msgs and new font-->
            <li id="test"><a id="hypEmail" runat="server" style="color: white;" target="_blank">Emails<label id="lblNewCounter" class="badge badge-error">0</label><label id="lblUnRead" class="badge badge-error hide"></label></a></li>
            <li>&nbsp;&nbsp;|&nbsp;&nbsp;</li>
            <li><a id="idPhoneLink" runat="server" class="clsPhoneLink" onclick="GetPhoneDiv()">Phone / Vmail(0)<label id="lblNewCounter" class="badge badge-error">10</label><label id="lblUnRead" class="badge badge-error hide"></label></a></a></li>
            <li>&nbsp;&nbsp;|&nbsp;&nbsp;</li>
            <li><a id="hypChat" href="#" onclick="javascript:OpenChatWindow();">Chat <label id="lblNewCounter" class="badge badge-error">10</label><label class="badge badge-error hide"></label></a></a></li>
        </ul>
    </div>
    <div class="header-msg">
        <div class="row">
            <div class="user-image">
                <div class="img">
                    <img src="http://web.jmgrovebuildingsupply.com/Employee/ProfilePictures/201712181154322015-01-15%2019.43.23.jpg" /></div>
                <div class="status-icon"></div>
                <div class="installid"><a href="#">ITSTE-A0002 </a></div>
            </div>
            <div class="contents">
                <div class="top"><div class="name">Abhishek Girwalkar</div><div class="time">12/25/17</div></div>                
                <div class="msg-container">
                    <div class="tick">
                        <img src="../img/blue-tick.png" />
                    </div>
                    <div class="msg">Lorem Ipsum is simply dummy text</div>
                    <div class="counter">3</div>
                </div>
            </div>
            <div class="caller">
                <div class="phone"><i class="fa fa-phone" aria-hidden="true"></i></div>
                <div class="email"><i class="fa fa-envelope" aria-hidden="true"></i></div>
                <div class="video"><i class="fa fa-video-camera" aria-hidden="true"></i></div>
            </div>
        </div>
        <div class="row">
            <div class="user-image">
                <div class="img">
                    <img src="http://web.jmgrovebuildingsupply.com/Employee/ProfilePictures/201711110441571119837_519951461410702_1811777035_o.jpg" /></div>
                <div class="status-icon"></div>
                <div class="installid"><a href="#">ADM-A0064 </a></div>
            </div>
            <div class="contents">
                <div class="top"><div class="name">Johanna C</div><div class="time">12/25/17</div></div>                
                <div class="msg-container">
                    <div class="tick">
                        <img src="../img/blue-tick.png" />
                    </div>
                    <div class="msg">Lorem Ipsum is simply dummy text</div>
                    <div class="counter">3</div>
                </div>
            </div>
            <div class="caller">
                <div class="phone"><i class="fa fa-phone" aria-hidden="true"></i></div>
                <div class="email"><i class="fa fa-envelope" aria-hidden="true"></i></div>
                <div class="video"><i class="fa fa-video-camera" aria-hidden="true"></i></div>
            </div>
        </div>
        <div class="row">
            <div class="user-image">
                <div class="img">
                    <img src="http://web.jmgrovebuildingsupply.com/Employee/ProfilePictures/20171109173026IMG-20151119-WA0000%201.jpg" /></div>
                <div class="status-icon"></div>
                <div class="installid"><a href="#">AREC-A0059</a></div>
            </div>
            <div class="contents">
                <div class="top"><div class="name">SARU KAUSHISH</div><div class="time">12/25/17</div></div>                
                <div class="msg-container">
                    <div class="tick">
                        <img src="../img/blue-tick.png" />
                    </div>
                    <div class="msg">Lorem Ipsum is simply dummy text</div>
                    <div class="counter">3</div>
                </div>
            </div>
            <div class="caller">
                <div class="phone"><i class="fa fa-phone" aria-hidden="true"></i></div>
                <div class="email"><i class="fa fa-envelope" aria-hidden="true"></i></div>
                <div class="video"><i class="fa fa-video-camera" aria-hidden="true"></i></div>
            </div>
        </div>
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
