<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" CodeBehind="home.aspx.cs" Inherits="JG_Prospect.Sr_App.home" %>

<%@ Register Src="~/Sr_App/LeftPanel.ascx" TagName="LeftPanel" TagPrefix="uc2" %>

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
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_panel">
        <!-- appointment tabs section start -->
        <ul class="appointment_tab">
            <li><a href="home.aspx" class="active">Sales Calendar</a></li>
            <li><a href="GoogleCalendarView.aspx">Master  Calendar</a></li>
            <li><a href="#">Construction Calendar</a></li>
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
        <h2>In Progress, Assigned-Requested</h2>
         <asp:UpdatePanel ID="UpdatePanel1" runat="server">
          <ContentTemplate>
               <asp:Label runat="server" ID="lblMessage"></asp:Label>
                <asp:GridView ID="grdTaskPending" runat="server"  Width = "800px" 
                AutoGenerateColumns = "false" Font-Names = "Arial"
                 CssClass="listgrid" CellPadding="3" CellSpacing="3"
                Font-Size = "11pt" AlternatingRowStyle-BackColor = "#91E8E8" 
                HeaderStyle-BackColor = "gray" AllowPaging ="true"  ShowFooter = "true" 
                OnPageIndexChanging = "OnPagingTaskInProgress" 
                OnRowDataBound ="grdTaskPending_RowDataBound"
                PagerStyle-HorizontalAlign="Right"
                PagerStyle-CssClass="paging"
                PageSize = "10" >
                <Columns>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top" ItemStyle-Width = "150px"  HeaderText = "Due Date">
                    <ItemTemplate>
                        <asp:Label ID="lblDueDate" runat="server"
                        Text='<%# Eval("DueDate")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top"  ItemStyle-Width = "150px"  HeaderText = "Task ID#">
                    <ItemTemplate>
                        <asp:Label ID="lblTaskId" runat="server"
                                Text='<%# Eval("InstallId")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top"   ItemStyle-HorizontalAlign="Justify" ItemStyle-Width = "150px"  HeaderText = "Description">
                    <ItemTemplate>
                        <asp:Label ID="lblDesc" runat="server"
                            Text='<%# Eval("Description")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
               <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top"  ItemStyle-Width = "150px"  HeaderText = "Status">
                    <ItemTemplate>
                        <asp:Label ID="lblStatus" runat="server"
                            Text='<%# Eval("Status")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top"   ItemStyle-Width = "150px"  HeaderText = "Hours">
                    <ItemTemplate>
                        <asp:Label ID="lblHours" runat="server"
                            Text='<%# Eval("Hours")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top"  ItemStyle-Width = "150px"  HeaderText = "Approve">
                    <ItemTemplate>
                        <asp:CheckBox ID="chkAdmin" runat="server" />
                        <asp:CheckBox ID="chkITLead" runat="server" />
                        <asp:CheckBox ID="chkUser" runat="server" />

                    </ItemTemplate>
                </asp:TemplateField>

                </Columns>
                  <PagerStyle  CssClass = "paging" />
                <AlternatingRowStyle BackColor="#cccccc"  />
                </asp:GridView>
            </ContentTemplate>
            <Triggers>
            <asp:AsyncPostBackTrigger ControlID = "grdTaskPending" />
            </Triggers>
        </asp:UpdatePanel>



        <h2>Commits, Closed-Billed</h2>
        <div>
            <table>
                <tr>
                    <td>Designation</td>
                    <td>Users</td>
                    <td>Status</td>
                    <td>Task Title</td>
                </tr>
                <tr>
                    <td>
                        <asp:DropDownList ID="drpDesignation" runat="server">
                            <asp:ListItem Text="Admin" Value="1"></asp:ListItem>
                            <asp:ListItem Text="ITLead" Value="2"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td>
                         <asp:DropDownList ID="drpUsers" runat="server">
                             <asp:ListItem Text="User-A" Value="1"></asp:ListItem>
                             <asp:ListItem Text="User-B" Value="2"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td>
                        <asp:DropDownList ID="drpStatus" runat="server">
                            <asp:ListItem Text="Open" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Requested" Value="2"></asp:ListItem>
                            <asp:ListItem Text="Assigned" Value="3"></asp:ListItem>
                            <asp:ListItem Text="In Progress" Value="4"></asp:ListItem>
                            <asp:ListItem Text="Pending" Value="5"></asp:ListItem>
                            <asp:ListItem Text="Re-Opened" Value="6"></asp:ListItem>
                            <asp:ListItem Text="Finished" Value="10"></asp:ListItem>
                            <asp:ListItem Text="Closed" Value="7"></asp:ListItem>
                            <asp:ListItem Text="Specs In Progress" Value="8"></asp:ListItem>
                            <asp:ListItem Text="Deleted" Value="9"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td>
                        <asp:TextBox ID="txtTitle" runat="server"></asp:TextBox>
                    </td>
                </tr>
            </table>
            
           
            
            
        </div>
         <asp:UpdatePanel ID="UpdatePanel2" runat="server">
          <ContentTemplate>
               <asp:Label runat="server" ID="Label1"></asp:Label>
                <asp:GridView ID="grdTaskClosed" runat="server"  Width = "800px" 
                AutoGenerateColumns = "false" Font-Names = "Arial"
                 CssClass="listgrid" CellPadding="3" CellSpacing="3"
                Font-Size = "11pt" AlternatingRowStyle-BackColor = "#91E8E8" 
                HeaderStyle-BackColor = "gray" AllowPaging ="true"  ShowFooter = "true" 
                OnPageIndexChanging = "OnPagingTaskClosed" 
                OnRowDataBound ="grdTaskClosed_RowDataBound"
                PagerStyle-CssClass="paging"
                PagerStyle-HorizontalAlign="Right"
                PageSize = "10" >
                <Columns>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top"  ItemStyle-Width = "150px"  HeaderText = "Due Date">
                    <ItemTemplate>
                        <asp:Label ID="lblDueDate" runat="server"
                        Text='<%# Eval("DueDate")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top"  ItemStyle-Width = "150px"  HeaderText = "Task ID#">
                    <ItemTemplate>
                        <asp:Label ID="lblTaskId" runat="server"
                                Text='<%# Eval("InstallId")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField ItemStyle-HorizontalAlign="Justify" ItemStyle-VerticalAlign="Top"  HeaderStyle-HorizontalAlign="Center" ItemStyle-Width = "150px"  HeaderText = "Description">
                    <ItemTemplate>
                        <asp:Label ID="lblDesc" runat="server"
                            Text='<%# Eval("Description")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
               <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top"  ItemStyle-Width = "150px"  HeaderText = "Status">
                    <ItemTemplate>
                        <asp:Label ID="lblStatus" runat="server"
                            Text='<%# Eval("Status")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top"  ItemStyle-Width = "150px"  HeaderText = "Hours">
                    <ItemTemplate>
                        <asp:Label ID="lblHours" runat="server"
                            Text='<%# Eval("Hours")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top"  ItemStyle-Width = "150px"  HeaderText = "Approve">
                    <ItemTemplate>
                        <asp:CheckBox ID="chkAdmin" runat="server" />
                        <asp:CheckBox ID="chkITLead" runat="server" />
                        <asp:CheckBox ID="chkUser" runat="server" />

                    </ItemTemplate>
                </asp:TemplateField>

                </Columns>
                  <PagerStyle  CssClass = "paging" />
                <AlternatingRowStyle BackColor="#cccccc"  />
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


</asp:Content>
