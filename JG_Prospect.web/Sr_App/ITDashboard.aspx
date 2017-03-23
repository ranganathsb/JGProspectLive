<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" CodeBehind="ITDashboard.aspx.cs" Inherits="JG_Prospect.Sr_App.ITDashboard" %>

<%@ Register Src="~/Sr_App/LeftPanel.ascx" TagName="LeftPanel" TagPrefix="uc2" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .clsTestMail {
            padding: 20px;
            font-size: 14px;
        }

            .clsTestMail input[type='text'] {
                padding: 5px;
            }

            .clsTestMail input[type='submit'] {
                background: #000;
                color: #fff;
                padding: 5px 7px;
                border: 1px solid #808080;
            }

                .clsTestMail input[type='submit']:hover {
                    background: #fff;
                    color: #000;
                    cursor: pointer;
                }

        .table tr{
            border:solid 1px #fff;
        }

         .modalBackground { 
            background-color:#333333; 
            filter:alpha(opacity=70); 
            opacity:0.7; 
            z-index : 100 !important
        } 
        .modalPopup { 
            background-color:#FFFFFF; 
            border-width:1px; 
            border-style:solid; 
            border-color:#CCCCCC; 
            padding:1px; 
            width:900px; 
            Height:550px; 
            overflow-y:auto;
        }    

        .badge1 {
    padding: 1px 5px 2px;
    font-size: 12px;
    font-weight: bold;
    white-space: nowrap;
    color: #ffffff;
    background-color: #e55456;
    -webkit-border-radius: 9px;
    -moz-border-radius: 9px;
    border-radius: 8px;
    display:inline;
}

        .ui-autocomplete{
            z-index:999999999 !important;
            max-height: 250px;
    overflow-y: auto;
    overflow-x: hidden;
        }
        .pagination-ys {
    padding-left: 0;
    margin: 5px 0;
    border-radius: 4px;
    align-content: flex-end;
    line-height: none !important;
}

    .pagination-ys td {
        border: none !important;
    }

    .pagination-ys table > tbody {
        height: unset !important;
    }

        .pagination-ys table > tbody > tr > td {
            display: inline !important;
            background: none;
            border: none !important;
        }

            .pagination-ys table > tbody > tr > td > a,
            .pagination-ys table > tbody > tr > td > span {
                position: relative;
                float: left;
                padding: 8px 12px;
                line-height: 1.42857143;
                text-decoration: none;
                color: #dd4814;
                background-color: #ffffff;
                border: 1px solid #dddddd;
                margin-left: -1px;
            }

            .pagination-ys table > tbody > tr > td > span {
                position: relative;
                float: left;
                padding: 8px 12px;
                line-height: 1.42857143;
                text-decoration: none;
                margin-left: -1px;
                z-index: 2;
                color: #aea79f;
                background-color: #f5f5f5;
                border-color: #dddddd;
                cursor: default;
            }

            .pagination-ys table > tbody > tr > td:first-child > a,
            .pagination-ys table > tbody > tr > td:first-child > span {
                margin-left: 0;
                border-bottom-left-radius: 4px;
                border-top-left-radius: 4px;
            }

            .pagination-ys table > tbody > tr > td:last-child > a,
            .pagination-ys table > tbody > tr > td:last-child > span {
                border-bottom-right-radius: 4px;
                border-top-right-radius: 4px;
            }

            .pagination-ys table > tbody > tr > td > a:hover,
            .pagination-ys table > tbody > tr > td > span:hover,
            .pagination-ys table > tbody > tr > td > a:focus,
            .pagination-ys table > tbody > tr > td > span:focus {
                color: #97310e;
                background-color: #eeeeee;
                border-color: #dddddd;
            }

    /*.dashboard tr {
        display: flex;
    }

   .pagination-ys td {
        border-spacing: 0px !important;
        flex: 1 auto;
        word-wrap: break-word;
        background: none !important;
        line-height: none !important;
    }

    .dashboard thead tr:after {
        content:'';
        overflow-y: scroll;
        visibility: hidden;
        height: 0;
    }
 
    .dashboard thead th {
        flex: 1 auto;
        display: block;
        background-color: #000 !important;
    }

    .dashboard tbody {
        display: block;
        width: 100%;
        overflow-y: auto;
        height: 370px;
    }*/

table.table tr.trHeader {
    background:none !important;
}

table.table th
{
    border:none;
}
.dashboard tr {
        display: flex;
    }

  .dashboard td {
       border-spacing: 0px !important;
        padding: 3px !important;
        flex: 1 auto;
        word-wrap: break-word;
        background: none !important;
        padding: 3px 0 0 0 !important;
        line-height: none !important;
    }

    .dashboard thead tr:after {
        content: '';
        overflow-y: scroll;
        visibility: hidden;
        height: 0;
    }

    .dashboard thead th {
        flex: 1 auto;
        display: block;
        padding: 0px;
        background-color: #000;
    }


.dashboard thead th:first-child {
border-top-left-radius: 4px;
}
.dashboard thead th:last-child {
border-top-right-radius: 4px;
}

 
 .dashboard tbody {
        display: block;
        width: 100%;
        overflow-y: auto;
        height: 370px;
    }

 .itdashtitle
 {
     margin-left:7px;
 }

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_panel">
        <!-- appointment tabs section start -->
        <ul class="appointment_tab">
            <li><a href="home.aspx" >Sales Calendar</a></li>
            <li><a href="GoogleCalendarView.aspx">Master  Calendar</a></li>
            <li><a class="active" href="ITDashboard.aspx">Operations Calendar</a></li>
            <li><a href="CallSheet.aspx">Call Sheet</a></li>
            <li id="li_AnnualCalender" visible="false" runat="server"><a href="#" runat="server">Annual Event Calendar</a> </li>
        </ul>
        <!-- appointment tabs section end -->
        <h1><b>IT Dashboard</b></h1>
   <%--     <asp:Panel ID="pnlTestEmail" Visible="false" GroupingText="Test E-Mail" runat="server" CssClass="clsTestMail">
            <asp:TextBox ID="txtTestEmail" runat="server"></asp:TextBox>
            <asp:Button ID="btnTestMail" runat="server" Text="Send Mail" OnClick="btnTestMail_Click" />
            <br />
            <asp:Label runat="server" ID="lblMessage"></asp:Label>
        </asp:Panel>--%>

        <asp:UpdatePanel runat="server" ID="upAlerts" UpdateMode="Conditional">
            <ContentTemplate>
              
            <h2 runat="server" id="lblalertpopup">
               Alerts: <asp:LinkButton ID="lblNewCounter" runat="server"   OnClick="lnkNewCounter_Click" ></asp:LinkButton> 
                <asp:Label ID="lblNewCounter0" runat="server"  ></asp:Label> 
                 <asp:LinkButton id="lblFrozenCounter" runat="server" OnClick="lnkFrozenCounter_Click" ></asp:LinkButton>
                <asp:Label id="lblFrozenCounter0" runat="server" ></asp:label>
            </h2>
 
                 <!--  ------- Start DP new/frozen tasks popup ------  -->
              <button id="btnFake" style="display: none" runat="server"></button>
              <cc1:ModalPopupExtender ID="mpNewFrozenTask" runat="server" PopupControlID="pnlNewFrozenTask" TargetControlID="btnFake"
            CancelControlID="btnFake" BackgroundCssClass="modalBackground">
            </cc1:ModalPopupExtender>
                <asp:Panel ID="pnlNewFrozenTask" runat="server" CssClass="modalPopup" align="center" >
                      
                <table id="Table2" runat="server" width="100%">
                    <tr>
                        <td align="left" width="30%">
                            <h2 class="itdashtitle">Partial Frozen Tasks</h2>
                        </td>
                        <td  align="center" width="30%">
                                <table id="Table7" runat="server"  >
                                <tr>
                                    <td>Designation</td><td>Users</td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:DropDownList ID="drpDesigFrozen" runat="server" >
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                            <asp:DropDownList ID="drpUserFrozen" runat="server" >
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td  align="right">
                            <div style="float: left;margin-top:15px;  ">
                                <asp:TextBox ID="txtSearchFrozen" runat="server" CssClass="textbox" placeholder="search users"  />
                                <asp:Button ID="btnSearchFrozen" runat="server" Text="Search" Style="display: none;" class="btnSearc" OnClick="btnSearchFrozen_Click" />

                                Number of Records: 
                                <asp:DropDownList ID="drpPageSizeFrozen" runat="server" AutoPostBack="true"
                                    OnSelectedIndexChanged="drpPageSizeFrozen_SelectedIndexChanged">
                                    <asp:ListItem Text="10" Value="10" />
                                    <asp:ListItem Selected="True" Text="20" Value="20" />
                                    <asp:ListItem Text="30" Value="30" />
                                    <asp:ListItem Text="40" Value="40" />
                                    <asp:ListItem Text="50" Value="50" />
                                </asp:DropDownList>
                            </div>

                        </td>
                    </tr>
                </table>



                    <asp:Label runat="server" ID="Label2"></asp:Label>
                    <asp:GridView ID="grdFrozenTask" runat="server"  OnPreRender ="grdFrozenTask_PreRender"
                          AllowPaging ="true" EmptyDataRowStyle-HorizontalAlign="Center"
                          HeaderStyle-ForeColor="White" BackColor="White" EmptyDataRowStyle-ForeColor="Black"
                            CssClass="table dashboard" AllowCustomPaging="true"
                        EmptyDataText="No Frozen Tasks Found !!" Width="100%" CellSpacing="0" CellPadding="0"
                        AutoGenerateColumns="False" EnableSorting="true" GridLines="Both"   
                        OnPageIndexChanging = "OnPaginggrdFrozenTask"   OnRowDataBound ="grdFrozenTask_RowDataBound"  PageSize = "20" >
                        <RowStyle CssClass="FirstRow" />
                         <HeaderStyle CssClass="trHeader" />
                        <AlternatingRowStyle CssClass="AlternateRow" />
                        <PagerSettings Mode="NumericFirstLast" NextPageText="Next"  PreviousPageText="Previous" Position="Bottom" />
                        <PagerStyle HorizontalAlign="Right"  CssClass="pagination-ys" />
                    <Columns>
                    <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center"  
                        HeaderStyle-Width="100px"  ItemStyle-Width = "100px"  HeaderText = "Due Date">
                        <ItemTemplate>
                            <asp:HiddenField ID="lblTaskIdInPro" runat="server" Value='<%# Eval("TaskId")%>' />
                            <asp:HiddenField ID="lblParentTaskIdInPro" runat="server" Value='<%# Eval("ParentTaskId")%>' />
                            <asp:Label ID="lblDueDate" runat="server"  Text='<%# Eval("DueDate")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center"  
                        HeaderStyle-Width="100px" ItemStyle-Width = "100px"  HeaderText = "Task ID#">
                        <ItemTemplate>
                            <asp:LinkButton ForeColor="Blue" ID="lnkInstallId" runat="server"   Text='<%# Eval("InstallId")%>' data-highlighter='<%# Eval("TaskId")%>'  CssClass="context-menu"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle"   ItemStyle-HorizontalAlign="Justify"  
                        HeaderStyle-Width="300px" ItemStyle-Width = "300px"  HeaderText = "Title">
                        <ItemTemplate>
                            <asp:Label ID="lblDesc" runat="server"
                                Text='<%# Eval("Title")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                   <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center" 
                        HeaderStyle-Width="120px" ItemStyle-Width = "120px"  HeaderText = "Status">
                        <ItemTemplate>
                            <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center" 
                         HeaderStyle-Width="150px"   ItemStyle-Width = "150px"  HeaderText = "Hours">
                        <ItemTemplate>
                             <asp:Label ID="lblHoursLeadInPro" runat="server"  ></asp:Label> <br />
                            <asp:Label ID="lblHoursDevInPro" runat="server"  ></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    </Columns>
              
                    </asp:GridView>    
                    
                  
                <table id="Table5" runat="server" width="100%">
                    <tr>
                        <td align="left" width="30%">
                            <h2 class="itdashtitle">Non Frozen Tasks</h2>
                        </td>
                        <td  align="center" width="30%">
                                <table id="Table6" runat="server"  >
                                <tr>
                                    <td>Designation</td><td>Users</td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:DropDownList ID="drpDesigNew" runat="server"   >
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                            <asp:DropDownList ID="drpUserNew" runat="server" >
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td  align="right">
                             <div style="float: left;margin-top:15px;  ">
                                Number of Records: 
                                <asp:DropDownList ID="drpPageSizeNew" runat="server" AutoPostBack="true"
                                    OnSelectedIndexChanged="drpPageSizeNew_SelectedIndexChanged">
                                    <asp:ListItem Text="10" Value="10" />
                                    <asp:ListItem Selected="True" Text="20" Value="20" />
                                    <asp:ListItem Text="30" Value="30" />
                                    <asp:ListItem Text="40" Value="40" />
                                    <asp:ListItem Text="50" Value="50" />
                                </asp:DropDownList>
                            </div>
                        </td>
                    </tr>
                </table>




                    <asp:Label runat="server" ID="Label3"></asp:Label>
                    <asp:GridView ID="grdNewTask" runat="server"  OnPreRender ="grdNewTask_PreRender"
                          AllowPaging ="true" EmptyDataRowStyle-HorizontalAlign="Center"
                         HeaderStyle-ForeColor="White" BackColor="White" EmptyDataRowStyle-ForeColor="Black"
                           CssClass="table dashboard" AllowCustomPaging="true"
                        EmptyDataText="No Frozen Tasks Found !!" Width="100%" CellSpacing="0" CellPadding="0"
                        AutoGenerateColumns="False" EnableSorting="true" GridLines="Both"   
                        OnPageIndexChanging = "OnPaginggrdNewTask"   OnRowDataBound ="grdNewTask_RowDataBound"  PageSize = "20" >
                         <RowStyle CssClass="FirstRow" />
                         <HeaderStyle CssClass="trHeader" />
                        <AlternatingRowStyle CssClass="AlternateRow" />
                        <PagerSettings Mode="NumericFirstLast" NextPageText="Next"  PreviousPageText="Previous" Position="Bottom" />
                        <PagerStyle HorizontalAlign="Right" CssClass="pagination-ys" />
                    <Columns>
                    <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center" 
                         HeaderStyle-Width="10%"  ItemStyle-Width = "10%"  HeaderText = "Due Date">
                        <ItemTemplate>
                            <asp:HiddenField ID="lblTaskIdInPro" runat="server" Value='<%# Eval("TaskId")%>' />
                            <asp:HiddenField ID="lblParentTaskIdInPro" runat="server" Value='<%# Eval("ParentTaskId")%>' />
                            <asp:Label ID="lblDueDate" runat="server"  Text='<%# Eval("DueDate")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center"  
                        HeaderStyle-Width="10%" ItemStyle-Width = "10%"  HeaderText = "Task ID#">
                        <ItemTemplate>
                            <asp:LinkButton ForeColor="Blue" ID="lnkInstallId" runat="server"   Text='<%# Eval("InstallId")%>' data-highlighter='<%# Eval("TaskId")%>'  CssClass="context-menu"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle"   ItemStyle-HorizontalAlign="Justify" 
                         HeaderStyle-Width="30%" ItemStyle-Width = "30%"  HeaderText = "Title">
                        <ItemTemplate>
                            <asp:Label ID="lblDesc" runat="server"
                                Text='<%# Eval("Title")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                   <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center" 
                        HeaderStyle-Width="20%" ItemStyle-Width = "20%"  HeaderText = "Status">
                        <ItemTemplate>
                            <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center" 
                         HeaderStyle-Width="20%"   ItemStyle-Width = "20%"  HeaderText = "Hours">
                        <ItemTemplate>
                             <asp:Label ID="lblHoursLeadInPro" runat="server"  ></asp:Label> <br />
                            <asp:Label ID="lblHoursDevInPro" runat="server"  ></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    </Columns>
             
                
                    </asp:GridView>    
                    


                    <table border="1" cellspacing="5" cellpadding="5">
                        <tr>
                            <td colspan="2">
                                <asp:Button ID="btnCalClose" runat="server" Height="30px" Width="70px" TabIndex="6" OnClick="btnCalClose_Click" Text="Close" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" />
                            </td>
                        </tr>
                    </table>
                           
                </asp:Panel>
          <!-- --------- End DP -------  -->
            </ContentTemplate>
        </asp:UpdatePanel>
        
         <asp:UpdatePanel ID="UpdatePanel1" runat="server" width="100%" >
          <ContentTemplate>
            
                <table width="100%" >
                    <tr>
                        <td align="left" width="30%">
                            <h2 class="itdashtitle">In Progress, Assigned-Requested</h2>
                        </td>
                        <td  align="center" width="30%">
                                <table id="tblInProgress" runat="server"  >
                                <tr>
                                    <td>Designation</td><td>Users</td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:DropDownList ID="drpDesigInProgress" runat="server"  AutoPostBack="true" OnSelectedIndexChanged="drpDesigInProgress_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                            <asp:DropDownList ID="drpUsersInProgress" runat="server" AutoPostBack="true" OnSelectedIndexChanged="drpUsersInProgress_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td  align="right">

                            <div style="float: left;margin-top:15px;  ">
                                <asp:TextBox ID="txtSearchInPro" runat="server" CssClass="textbox" placeholder="search users" MaxLength="15" />
                                <asp:Button ID="btnSearchInPro" runat="server" Text="Search" Style="display: none;" class="btnSearc" OnClick="btnSearchInPro_Click" />

                                Number of Records: 
                                <asp:DropDownList ID="drpPageSizeInpro" runat="server" AutoPostBack="true"
                                    OnSelectedIndexChanged="drpPageSizeInpro_SelectedIndexChanged">
                                    <asp:ListItem Text="10" Value="10" />
                                    <asp:ListItem Selected="True" Text="20" Value="20" />
                                    <asp:ListItem Text="30" Value="30" />
                                    <asp:ListItem Text="40" Value="40" />
                                    <asp:ListItem Text="50" Value="50" />
                                </asp:DropDownList>
                            </div>
                        </td>
                    </tr>
                </table>


                <asp:Label runat="server" ID="lblMessage"></asp:Label>
                <asp:GridView ID="grdTaskPending" runat="server"  OnPreRender ="grdTaskPending_PreRender"
                          AllowPaging ="true" EmptyDataRowStyle-HorizontalAlign="Center"
                        HeaderStyle-ForeColor="White" BackColor="White" EmptyDataRowStyle-ForeColor="Black"
                          CssClass="table dashboard" AllowCustomPaging="true"
                        EmptyDataText="No Pending Tasks Found !!" Width="100%" CellSpacing="0" CellPadding="0"
                        AutoGenerateColumns="False" EnableSorting="true" GridLines="Both"   
                        OnPageIndexChanging = "OnPagingTaskInProgress"   OnRowDataBound ="grdTaskPending_RowDataBound"  PageSize = "20" >
                        <RowStyle CssClass="FirstRow" />
                         <HeaderStyle CssClass="trHeader " />
                        <AlternatingRowStyle CssClass="AlternateRow " />
                        <PagerSettings Mode="NumericFirstLast" NextPageText="Next"  PreviousPageText="Previous" Position="Bottom" />
                        <PagerStyle HorizontalAlign="Right" CssClass="pagination-ys" />
                    <Columns>
                    <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center"  HeaderStyle-Width="100px"
                         ItemStyle-Width = "100px"  HeaderText = "Due Date">
                        <ItemTemplate>
                            <asp:HiddenField ID="lblTaskIdInPro" runat="server" Value='<%# Eval("TaskId")%>' />
                            <asp:HiddenField ID="lblParentTaskIdInPro" runat="server" Value='<%# Eval("ParentTaskId")%>' />
                            <asp:Label ID="lblDueDate" runat="server"  Text='<%# Eval("DueDate")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center"  HeaderStyle-Width="100px" ItemStyle-Width = "100px"  HeaderText = "Task ID#">
                        <ItemTemplate>
                            <asp:LinkButton ForeColor="Blue" ID="lnkInstallId" runat="server"   Text='<%# Eval("InstallId")%>' data-highlighter='<%# Eval("TaskId")%>'  CssClass="context-menu"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle"   ItemStyle-HorizontalAlign="Justify"  HeaderStyle-Width="300px" ItemStyle-Width = "300px"  HeaderText = "Title">
                        <ItemTemplate>
                            <asp:Label ID="lblDesc" runat="server"
                                Text='<%# Eval("Title")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                   <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center"  HeaderStyle-Width="120px" ItemStyle-Width = "120px"  HeaderText = "Status">
                        <ItemTemplate>
                            <asp:HiddenField ID="lblStatus" runat="server" Value='<%# Eval("Status")%>'></asp:HiddenField>
                            <asp:DropDownList ID="drpStatusInPro" runat="server"  AutoPostBack="true" OnSelectedIndexChanged="drpStatusInPro_SelectedIndexChanged" >
                            </asp:DropDownList>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center"  HeaderStyle-Width="150px"   ItemStyle-Width = "150px"  HeaderText = "Hours">
                        <ItemTemplate>
                             <asp:Label ID="lblHoursLeadInPro" runat="server"  ></asp:Label> <br />
                            <asp:Label ID="lblHoursDevInPro" runat="server"  ></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center"  HeaderStyle-Width="100px" ItemStyle-Width = "100px"  HeaderText = "Approve">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkAdmin" runat="server" />
                            <asp:CheckBox ID="chkITLead" runat="server" />
                            <asp:CheckBox ID="chkUser" runat="server" />

                        </ItemTemplate>
                    </asp:TemplateField>
                    </Columns>
               
                    </asp:GridView>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID = "grdTaskPending" />
            </Triggers>
       </asp:UpdatePanel>
        <h2></h2>
         <asp:UpdatePanel ID="upClosedTask" runat="server">
             <ContentTemplate>
      
                <table width="100%">
                    <tr>
                        <td align="left" width="30%">
                            <h2 class="itdashtitle">Commits, Closed-Billed</h2>
                        </td>
                        <td  align="center" width="30%">
                                <table id="tblClosedTask" runat="server"  >
                                <tr>
                                    <td>Designation</td><td>Users</td>
                                </tr>
                                 <tr>
                                    <td>
                                        <asp:DropDownList ID="drpDesigClosed" runat="server"  AutoPostBack="true" OnSelectedIndexChanged="drpDesigClosed_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                         <asp:DropDownList ID="drpUsersClosed" runat="server" AutoPostBack="true" OnSelectedIndexChanged="drpUsersClosed_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td  align="right">
                             <div style="float: left;margin-top:15px;  ">
                                <asp:TextBox ID="txtSearchClosed" runat="server" CssClass="textbox" placeholder="search users" MaxLength="15" />
                                <asp:Button ID="btnSearchClosed" runat="server" Text="Search" Style="display: none;" class="btnSearc" OnClick="btnSearchClosed_Click" />

                                Number of Records: 
                                <asp:DropDownList ID="drpPageSizeClosed" runat="server" AutoPostBack="true"
                                    OnSelectedIndexChanged="drpPageSizeClosed_SelectedIndexChanged">
                                    <asp:ListItem Text="10" Value="10" />
                                    <asp:ListItem Selected="True" Text="20" Value="20" />
                                    <asp:ListItem Text="30" Value="30" />
                                    <asp:ListItem Text="40" Value="40" />
                                    <asp:ListItem Text="50" Value="50" />
                                </asp:DropDownList>
                            </div>
                        </td>
                    </tr>
                </table>


               <asp:Label runat="server" ID="Label1"></asp:Label>
                <asp:GridView ID="grdTaskClosed" runat="server" 
                     OnPreRender="grdTaskClosed_PreRender"
                    ShowHeaderWhenEmpty="true" AllowPaging ="true" EmptyDataRowStyle-HorizontalAlign="Center"
                    HeaderStyle-ForeColor="White" BackColor="White" EmptyDataRowStyle-ForeColor="Black"
                    EmptyDataText="No Closed Tasks Found !!" CssClass="table dashboard" Width="100%" 
                    CellSpacing="0" CellPadding="0"  AllowCustomPaging="true"
                    AutoGenerateColumns="False" EnableSorting="true" GridLines="Both" OnPageIndexChanging = "OnPagingTaskClosed" 
                    OnRowDataBound ="grdTaskClosed_RowDataBound" PagerStyle-HorizontalAlign="Right"  PageSize = "20" >
                    <HeaderStyle CssClass="trHeader " />
                    <RowStyle CssClass="FirstRow" />
                    <AlternatingRowStyle CssClass="AlternateRow " />
                    <PagerSettings Mode="NumericFirstLast" NextPageText="Next"  PreviousPageText="Previous" Position="Bottom" />
                    <PagerStyle HorizontalAlign="Right" CssClass="pagination-ys"  />
                <Columns>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center"  
                    HeaderStyle-Width="100px"  ItemStyle-Width = "100px"  HeaderText = "Due Date">
                    <ItemTemplate>
                        <asp:HiddenField ID="lblTaskIdClosed" runat="server" Value='<%# Eval("TaskId")%>' />
                        <asp:HiddenField ID="lblParentTaskIdClosed" runat="server" Value='<%# Eval("ParentTaskId")%>' />
                        <asp:Label ID="lblDueDate" runat="server"  Text='<%# Eval("DueDate")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center" 
                     HeaderStyle-Width="100px" ItemStyle-Width = "100px"  HeaderText = "Task ID#">
                    <ItemTemplate>
                        <asp:LinkButton ForeColor="Blue" ID="lnkInstallId" runat="server"   Text='<%# Eval("InstallId")%>' data-highlighter='<%# Eval("TaskId")%>'  CssClass="context-menu"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle"   ItemStyle-HorizontalAlign="Justify" 
                     HeaderStyle-Width="300px" ItemStyle-Width = "300px"  HeaderText = "Title">
                    <ItemTemplate>
                        <asp:Label ID="lblDesc" runat="server"
                            Text='<%# Eval("Title")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
               <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center"  HeaderStyle-Width="120px"  ItemStyle-Width = "120px"  HeaderText = "Status">
                    <ItemTemplate>
                        <asp:HiddenField ID="lblStatus" runat="server" Value='<%# Eval("Status")%>'></asp:HiddenField>
                        <asp:DropDownList ID="drpStatusClosed" runat="server"  AutoPostBack="true" OnSelectedIndexChanged="drpStatusClosed_SelectedIndexChanged" >
                        </asp:DropDownList>
                    </ItemTemplate>
                </asp:TemplateField>
                </Columns>
                </asp:GridView>

            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID = "grdTaskClosed" />
            </Triggers>
        </asp:UpdatePanel>

       <%-- <h2>Personal Prospect Calendar</h2>--%>
       <%-- <div class="calendar" style="margin: 0;">
            <iframe src="../JGCalender/Calender.aspx" width="100%" height="1000" style="border: 0;"></iframe>
        </div>--%>
        <!--<div class="form_panel">
  <div class="calendar" style="margin: 0;">

  <div id="calendarBodyDiv" >
    
  <iframe src="http://localhost:60652/calendar/cal.aspx?eid=jgrove.georgegrove@gmail.com" width="100%" height="1200" style="border:0;" ></iframe>
  
  <%--<iframe src="https://www.Google.com/calendar/embed?src=<%=
    GetCalendarId()%>&ctz=Europe%2FMoscow" style="border: 0" width="800"
height="600" frameborder="0" scrolling="no"></iframe>--%>

  </div>
<%--<asp:Image ID="Image1" runat="server" ImageUrl="~/image/dashboard.png" />--%>

</div> 


</div>-->

    </div>

     

     
    <script  type="text/javascript" >
        var prmTaskGenerator = Sys.WebForms.PageRequestManager.getInstance();

        prmTaskGenerator.add_endRequest(function () {
            SetInProTaskAutoSuggestion();
            SetInProTaskAutoSuggestionUI();

            SetClosedTaskAutoSuggestion();
            SetClosedTaskAutoSuggestionUI();

            SetFrozenTaskAutoSuggestion();
            SetFrozenTaskAutoSuggestionUI();
        });

        $(document).ready(function () {
            SetInProTaskAutoSuggestion();
            SetInProTaskAutoSuggestionUI();

            SetClosedTaskAutoSuggestion();
            SetClosedTaskAutoSuggestionUI();

            SetFrozenTaskAutoSuggestion();
            SetFrozenTaskAutoSuggestionUI();

        });

        $(".context-menu").bind("contextmenu", function () {
            var urltoCopy = updateQueryStringParameter(window.location.href, "hstid", $(this).attr('data-highlighter'));
            copyToClipboard(urltoCopy);
            return false;
        });



        function SetFrozenTaskAutoSuggestion() {

            $("#<%=txtSearchFrozen.ClientID%>").catcomplete({
                delay: 500,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        url: "ajaxcalls.aspx/GetTaskUsers",
                        dataType: "json",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify({ searchterm: request.term }),
                        success: function (data) {
                            // Handle 'no match' indicated by [ "" ] response
                            if (data.d) {

                                response(data.length === 1 && data[0].length === 0 ? [] : JSON.parse(data.d));
                            }
                            // remove loading spinner image.                                
                            $("#<%=txtSearchFrozen.ClientID%>").removeClass("ui-autocomplete-loading");
                        }
                    });
                },
                minLength: 2,
                select: function (event, ui) {
                    $("#<%=btnSearchFrozen.ClientID%>").val(ui.item.value);
                    //TriggerSearch();
                    $('#<%=btnSearchFrozen.ClientID%>').click();
                }
            });
        }

        function SetFrozenTaskAutoSuggestionUI() {

            $.widget("custom.catcomplete", $.ui.autocomplete, {
                _create: function () {
                    this._super();
                    this.widget().menu("option", "items", "> :not(.ui-autocomplete-category)");
                },
                _renderMenu: function (ul, items) {
                    var that = this,
                      currentCategory = "";
                    $.each(items, function (index, item) {
                        var li;
                        if (item.Category != currentCategory) {
                            ul.append("<li class='ui-autocomplete-category'> Search " + item.Category + "</li>");
                            currentCategory = item.Category;
                        }
                        li = that._renderItemData(ul, item);
                        if (item.Category) {
                            li.attr("aria-label", item.Category + " : " + item.label);
                        }
                    });

                }
            });
        }


        function SetClosedTaskAutoSuggestion() {

            $("#<%=txtSearchClosed.ClientID%>").catcomplete({
                delay: 500,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        url: "ajaxcalls.aspx/GetTaskUsers",
                        dataType: "json",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify({ searchterm: request.term }),
                        success: function (data) {
                            // Handle 'no match' indicated by [ "" ] response
                            if (data.d) {

                                response(data.length === 1 && data[0].length === 0 ? [] : JSON.parse(data.d));
                            }
                            // remove loading spinner image.                                
                            $("#<%=txtSearchClosed.ClientID%>").removeClass("ui-autocomplete-loading");
                 }
             });
         },
                minLength: 2,
                select: function (event, ui) {
                    $("#<%=btnSearchClosed.ClientID%>").val(ui.item.value);
                    //TriggerSearch();
                    $('#<%=btnSearchClosed.ClientID%>').click();
                }
            });
        }

        function SetClosedTaskAutoSuggestionUI() {

            $.widget("custom.catcomplete", $.ui.autocomplete, {
                _create: function () {
                    this._super();
                    this.widget().menu("option", "items", "> :not(.ui-autocomplete-category)");
                },
                _renderMenu: function (ul, items) {
                    var that = this,
                      currentCategory = "";
                    $.each(items, function (index, item) {
                        var li;
                        if (item.Category != currentCategory) {
                            ul.append("<li class='ui-autocomplete-category'> Search " + item.Category + "</li>");
                            currentCategory = item.Category;
                        }
                        li = that._renderItemData(ul, item);
                        if (item.Category) {
                            li.attr("aria-label", item.Category + " : " + item.label);
                        }
                    });

                }
            });
        }




        function SetInProTaskAutoSuggestion() {

            $("#<%=txtSearchInPro.ClientID%>").catcomplete({
         delay: 500,
         source: function (request, response) {
             $.ajax({
                 type: "POST",
                 url: "ajaxcalls.aspx/GetTaskUsers",
                 dataType: "json",
                 contentType: "application/json; charset=utf-8",
                 data: JSON.stringify({ searchterm: request.term }),
                 success: function (data) {
                     // Handle 'no match' indicated by [ "" ] response
                     if (data.d) {

                         response(data.length === 1 && data[0].length === 0 ? [] : JSON.parse(data.d));
                     }
                     // remove loading spinner image.                                
                     $("#<%=txtSearchInPro.ClientID%>").removeClass("ui-autocomplete-loading");
                        }
                    });
                },
                minLength: 2,
                select: function (event, ui) {
                    $("#<%=txtSearchInPro.ClientID%>").val(ui.item.value);
                    //TriggerSearch();
                    $('#<%=btnSearchInPro.ClientID%>').click();
                }
            });
        }

        function SetInProTaskAutoSuggestionUI() {

            $.widget("custom.catcomplete", $.ui.autocomplete, {
                _create: function () {
                    this._super();
                    this.widget().menu("option", "items", "> :not(.ui-autocomplete-category)");
                },
                _renderMenu: function (ul, items) {
                    var that = this,
                      currentCategory = "";
                    $.each(items, function (index, item) {
                        var li;
                        if (item.Category != currentCategory) {
                            ul.append("<li class='ui-autocomplete-category'> Search " + item.Category + "</li>");
                            currentCategory = item.Category;
                        }
                        li = that._renderItemData(ul, item);
                        if (item.Category) {
                            li.attr("aria-label", item.Category + " : " + item.label);
                        }
                    });

                }
            });
        }

    </script>
</asp:Content>

