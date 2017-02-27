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
              

              <table id="tblInProgress" runat="server">
                <tr>
                    <td>Designation</td>
                    <td>Users</td>

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
                   <%-- <td>
                        <asp:DropDownList ID="drpStatusInProgress" runat="server" AutoPostBack="true" >
                        </asp:DropDownList>
                    </td>
                    <td>
                        <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
                    </td>--%>
                </tr>
            </table>

               <asp:Label runat="server" ID="lblMessage"></asp:Label>
                <asp:GridView ID="grdTaskPending" runat="server" 
                    ShowHeaderWhenEmpty="true" AllowPaging ="true" EmptyDataRowStyle-HorizontalAlign="Center"
                    HeaderStyle-BackColor="Black" HeaderStyle-ForeColor="White" BackColor="White" EmptyDataRowStyle-ForeColor="Black"
                    EmptyDataText="No Pending Tasks Found !!" CssClass="table" Width="95%" CellSpacing="0" CellPadding="0"
                    AutoGenerateColumns="False" EnableSorting="true" GridLines="Vertical"
                    OnPageIndexChanging = "OnPagingTaskInProgress" 
                    OnRowDataBound ="grdTaskPending_RowDataBound"
                    PagerStyle-HorizontalAlign="Right"
                    PagerStyle-CssClass="paging"
                    PageSize = "10" >
                    <HeaderStyle CssClass="trHeader " />
                    <RowStyle CssClass="FirstRow" />
                    <AlternatingRowStyle CssClass="AlternateRow " />
                <Columns>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center"  ItemStyle-Width = "100px"  HeaderText = "Due Date">
                    <ItemTemplate>
                        <asp:HiddenField ID="lblTaskIdInPro" runat="server" Value='<%# Eval("TaskId")%>' />
                        <asp:HiddenField ID="lblParentTaskIdInPro" runat="server" Value='<%# Eval("ParentTaskId")%>' />
                        <asp:Label ID="lblDueDate" runat="server"  Text='<%# Eval("DueDate")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center"  ItemStyle-Width = "100px"  HeaderText = "Task ID#">
                    <ItemTemplate>
                        <asp:LinkButton ForeColor="Blue" ID="lnkInstallId" runat="server"   Text='<%# Eval("InstallId")%>'></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle"   ItemStyle-HorizontalAlign="Justify" ItemStyle-Width = "300px"  HeaderText = "Description">
                    <ItemTemplate>
                        <asp:Label ID="lblDesc" runat="server"
                            Text='<%# Eval("Description")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
               <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center"  ItemStyle-Width = "120px"  HeaderText = "Status">
                    <ItemTemplate>
                        <asp:HiddenField ID="lblStatus" runat="server" Value='<%# Eval("Status")%>'></asp:HiddenField>
                        <asp:DropDownList ID="drpStatusInPro" runat="server"  AutoPostBack="true" OnSelectedIndexChanged="drpStatusInPro_SelectedIndexChanged" >
                        </asp:DropDownList>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center"    ItemStyle-Width = "150px"  HeaderText = "Hours">
                    <ItemTemplate>
                         <asp:Label ID="lblHoursLeadInPro" runat="server"  ></asp:Label> <br />
                        <asp:Label ID="lblHoursDevInPro" runat="server"  ></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center"  ItemStyle-Width = "100px"  HeaderText = "Approve">
                    <ItemTemplate>
                        <asp:CheckBox ID="chkAdmin" runat="server" />
                        <asp:CheckBox ID="chkITLead" runat="server" />
                        <asp:CheckBox ID="chkUser" runat="server" />

                    </ItemTemplate>
                </asp:TemplateField>

                </Columns>
                  <PagerStyle  CssClass = "paging" />
                
                </asp:GridView>
            </ContentTemplate>
            <Triggers>
            <asp:AsyncPostBackTrigger ControlID = "grdTaskPending" />
            </Triggers>
        </asp:UpdatePanel>



        <h2>Commits, Closed-Billed</h2>

         <asp:UpdatePanel ID="UpdatePanel2" runat="server">
          <ContentTemplate>
              
            <table id="tblClosedTask" runat="server">
                <tr>
                    <td>Designation</td>
                    <td>Users</td>

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
                   <%-- <td>
                        <asp:DropDownList ID="drpStatusInProgress" runat="server" AutoPostBack="true" >
                        </asp:DropDownList>
                    </td>
                    <td>
                        <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
                    </td>--%>
                </tr>
            </table>

               <asp:Label runat="server" ID="Label1"></asp:Label>
                <asp:GridView ID="grdTaskClosed" runat="server" 
                    ShowHeaderWhenEmpty="true" AllowPaging ="true" EmptyDataRowStyle-HorizontalAlign="Center"
                    HeaderStyle-BackColor="Black" HeaderStyle-ForeColor="White" BackColor="White" EmptyDataRowStyle-ForeColor="Black"
                    EmptyDataText="No Closed Tasks Found !!" CssClass="table" Width="95%" CellSpacing="0" CellPadding="0"
                    AutoGenerateColumns="False" EnableSorting="true" GridLines="Vertical"
                    OnPageIndexChanging = "OnPagingTaskClosed" 
                    OnRowDataBound ="grdTaskClosed_RowDataBound"
                    PagerStyle-HorizontalAlign="Right"
                    PagerStyle-CssClass="paging"
                    PageSize = "10" >
                    <HeaderStyle CssClass="trHeader " />
                    <RowStyle CssClass="FirstRow" />
                    <AlternatingRowStyle CssClass="AlternateRow " />
                <Columns>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center"  ItemStyle-Width = "100px"  HeaderText = "Due Date">
                    <ItemTemplate>
                        <asp:HiddenField ID="lblTaskIdClosed" runat="server" Value='<%# Eval("TaskId")%>' />
                        <asp:HiddenField ID="lblParentTaskIdClosed" runat="server" Value='<%# Eval("ParentTaskId")%>' />
                        <asp:Label ID="lblDueDate" runat="server"  Text='<%# Eval("DueDate")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center"  ItemStyle-Width = "100px"  HeaderText = "Task ID#">
                    <ItemTemplate>
                        <asp:LinkButton ForeColor="Blue" ID="lnkInstallId" runat="server"   Text='<%# Eval("InstallId")%>'></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle"   ItemStyle-HorizontalAlign="Justify" ItemStyle-Width = "300px"  HeaderText = "Description">
                    <ItemTemplate>
                        <asp:Label ID="lblDesc" runat="server"
                            Text='<%# Eval("Description")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
               <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center"  ItemStyle-Width = "120px"  HeaderText = "Status">
                    <ItemTemplate>
                        <asp:HiddenField ID="lblStatus" runat="server" Value='<%# Eval("Status")%>'></asp:HiddenField>
                        <asp:DropDownList ID="drpStatusClosed" runat="server"  AutoPostBack="true" OnSelectedIndexChanged="drpStatusClosed_SelectedIndexChanged" >
                        </asp:DropDownList>
                    </ItemTemplate>
                </asp:TemplateField>


                </Columns>
                  <PagerStyle  CssClass = "paging" />
                
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
