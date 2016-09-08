<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" CodeBehind="TaskGenerator.aspx.cs" Inherits="JG_Prospect.Sr_App.TaskGenerator" %>

<%@ Register TagPrefix="asp" Namespace="Saplin.Controls" Assembly="DropDownCheckBoxes" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor" TagPrefix="ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link rel="stylesheet" href="../css/jquery-ui.css" />
    <link href="../css/dropzone/css/basic.css" rel="stylesheet" />
    <link href="../css/dropzone/css/dropzone.css" rel="stylesheet" />
    <script type="text/javascript" src="../js/dropzone.js"></script>
    <div class="right_panel">
        <hr />
        <asp:UpdatePanel ID="upTask" runat="server">
            <ContentTemplate>
                <h1>Task</h1>
                <table id="tblTaskHeader" runat="server" visible="false" class="appointment_tab"
                    style="position: absolute; top: 221px; right: 39px; background-color: #fff;">
                    <tr>
                        <td width="25%" align="left">
                            <asp:LinkButton ID="lbtnDeleteTask" runat="server" OnClick="lbtnDeleteTask_Click" Text="Delete" />
                            &nbsp;&nbsp;Task ID#:
                            <asp:Literal ID="ltrlInstallId" runat="server" /></td>
                        <td align="center">Date Created:
                            <asp:Literal ID="ltrlDateCreated" runat="server" /></td>
                        <td width="25%" align="right">
                            <asp:Literal ID="ltrlAssigningManager" runat="server" /></td>
                    </tr>
                </table>
                <div class="form_panel_custom">
                    <table id="tblAdminTaskView" runat="server" class="tablealign"
                        width="100%" cellspacing="5">
                        <tr>
                            <td width="100">Designation <span style="color: red;">*</span>:</td>
                            <td>
                                <asp:UpdatePanel ID="upnlDesignation" runat="server" RenderMode="Inline">
                                    <ContentTemplate>
                                        <asp:DropDownCheckBoxes ID="ddlUserDesignation" runat="server" UseSelectAllNode="false" AutoPostBack="true" OnSelectedIndexChanged="ddlUserDesignation_SelectedIndexChanged">
                                            <Style SelectBoxWidth="195" DropDownBoxBoxWidth="120" DropDownBoxBoxHeight="150" />
                                            <Items>
                                                <asp:ListItem Text="Admin" Value="Admin"></asp:ListItem>
                                                <asp:ListItem Text="Jr. Sales" Value="Jr. Sales"></asp:ListItem>
                                                <asp:ListItem Text="Jr Project Manager" Value="Jr Project Manager"></asp:ListItem>
                                                <asp:ListItem Text="Office Manager" Value="Office Manager"></asp:ListItem>
                                                <asp:ListItem Text="Recruiter" Value="Recruiter"></asp:ListItem>
                                                <asp:ListItem Text="Sales Manager" Value="Sales Manager"></asp:ListItem>
                                                <asp:ListItem Text="Sr. Sales" Value="Sr. Sales"></asp:ListItem>
                                                <asp:ListItem Text="IT - Network Admin" Value="ITNetworkAdmin"></asp:ListItem>
                                                <asp:ListItem Text="IT - Jr .Net Developer" Value="ITJr.NetDeveloper"></asp:ListItem>
                                                <asp:ListItem Text="IT - Sr .Net Developer" Value="ITSr.NetDeveloper"></asp:ListItem>
                                                <asp:ListItem Text="IT - Android Developer" Value="ITAndroidDeveloper"></asp:ListItem>
                                                <asp:ListItem Text="IT - PHP Developer" Value="ITPHPDeveloper"></asp:ListItem>
                                                <asp:ListItem Text="IT - SEO / BackLinking" Value="ITSEOBackLinking"></asp:ListItem>
                                                <asp:ListItem Text="Installer - Helper" Value="InstallerHelper"></asp:ListItem>
                                                <asp:ListItem Text="Installer - Journeyman" Value="InstallerJourneyman"></asp:ListItem>
                                                <asp:ListItem Text="Installer - Mechanic" Value="InstallerMechanic"></asp:ListItem>
                                                <asp:ListItem Text="Installer - Lead mechanic" Value="InstallerLeadMechanic"></asp:ListItem>
                                                <asp:ListItem Text="Installer - Foreman" Value="InstallerForeman"></asp:ListItem>
                                                <asp:ListItem Text="Commercial Only" Value="CommercialOnly"></asp:ListItem>
                                                <asp:ListItem Text="SubContractor" Value="SubContractor"></asp:ListItem>
                                            </Items>
                                        </asp:DropDownCheckBoxes>
                                        <asp:CustomValidator ID="cvDesignations" runat="server" ValidationGroup="Submit" ErrorMessage="Please Select Designation" Display="None" ClientValidationFunction="checkDesignations"></asp:CustomValidator>
                                        <%--<asp:DropDownList ID="ddlUserDesignation" runat="server" CssClass="textbox" AutoPostBack="True" OnSelectedIndexChanged="txtDesignation_SelectedIndexChanged">
                                </asp:DropDownList>--%>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>Assigned:</td>
                            <td>
                                <asp:UpdatePanel ID="upnlAssigned" runat="server" RenderMode="Inline">
                                    <ContentTemplate>
                                        <asp:DropDownCheckBoxes ID="ddcbAssigned" runat="server" UseSelectAllNode="false"
                                            AutoPostBack="true" OnSelectedIndexChanged="ddcbAssigned_SelectedIndexChanged">
                                            <Style SelectBoxWidth="195" DropDownBoxBoxWidth="120" DropDownBoxBoxHeight="150" />
                                            <Texts SelectBoxCaption="--Open--" />
                                        </asp:DropDownCheckBoxes>
                                    </ContentTemplate>
                                </asp:UpdatePanel>

                                <%--                       <asp:DropDownList ID="ddlAssigned" runat="server" CssClass="textbox" onchange="addRow(this)">
                        <asp:ListItem Text="Darmendra"></asp:ListItem>
                        <asp:ListItem Text="Shabir"></asp:ListItem>
                       </asp:DropDownList>--%>
                  
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" valign="top">Task Title <span style="color: red;">*</span>:<br />
                                <asp:TextBox ID="txtTaskTitle" runat="server" Style="width: 90%" CssClass="textbox"></asp:TextBox>
                                <%--<ajax:Editor ID="txtTaskTitle" Width="100%" Height="20px" runat="server" ActiveMode="Design" AutoFocus="true" />--%>
                                <asp:RequiredFieldValidator ID="rfvTaskTitle" ValidationGroup="Submit"
                                    runat="server" ControlToValidate="txtTaskTitle" ForeColor="Red" ErrorMessage="Please Enter Task Title" Display="None">                                 
                                </asp:RequiredFieldValidator>
                                <asp:HiddenField ID="controlMode" runat="server" />
                                <asp:HiddenField ID="hdnTaskId" runat="server" Value="0" />
                                <br>
                                Task Description <span style="color: red;">*</span>:<br />
                                <asp:TextBox ID="txtDescription" TextMode="MultiLine" runat="server" CssClass="textbox" Width="90%" Rows="10"></asp:TextBox>
                                <%--<ajax:Editor ID="txtDescription" Width="100%" Height="100px" runat="server" ActiveMode="Design" AutoFocus="true" />--%>
                                <asp:RequiredFieldValidator ID="rfvDesc" ValidationGroup="Submit"
                                    runat="server" ControlToValidate="txtDescription" ForeColor="Red" ErrorMessage="Please Enter Task Description" Display="None">                                 
                                </asp:RequiredFieldValidator>
                            </td>
                            <td valign="top">
                                <br />
                                <asp:LinkButton ID="lbtnFinishedWorkFiles" runat="server" Text="Finished Work Files"
                                    OnClick="lbtnFinishedWorkFiles_Click" />&nbsp;&nbsp;
                                <asp:LinkButton ID="lbtnWorkSpecificationFiles" runat="server" Text="Work Specification Files"
                                    OnClick="lbtnWorkSpecificationFiles_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4"></td>
                        </tr>
                        <tr id="trSubTaskList" runat="server">
                            <td colspan="4">
                                <fieldset class="tasklistfieldset">
                                    <legend>Task List</legend>
                                    <asp:UpdatePanel ID="upSubTasks" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <div id="divSubTaskGrid">
                                                <asp:GridView ID="gvSubTasks" runat="server" ShowHeaderWhenEmpty="true" EmptyDataRowStyle-HorizontalAlign="Center"
                                                    HeaderStyle-BackColor="Black" HeaderStyle-ForeColor="White" BackColor="White" EmptyDataRowStyle-ForeColor="Black"
                                                    EmptyDataText="No sub task available!" CssClass="table" Width="100%" CellSpacing="0" CellPadding="0"
                                                    AutoGenerateColumns="False" OnRowDataBound="gvSubTasks_RowDataBound" GridLines="Vertical">
                                                    <EmptyDataRowStyle ForeColor="White" HorizontalAlign="Center" />
                                                    <HeaderStyle CssClass="trHeader " />
                                                    <RowStyle CssClass="FirstRow" />
                                                    <AlternatingRowStyle CssClass="AlternateRow " />
                                                    <Columns>
                                                        <asp:BoundField DataField="InstallId" HeaderText="List ID" HeaderStyle-Width="10%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                                                        <asp:TemplateField HeaderText="Task Description" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                                                            <ItemTemplate>
                                                                <%# Eval("Description") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <%--<asp:TemplateField HeaderText="Due Date" HeaderStyle-Width="11%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                    <ItemTemplate>
                                                        <%#  string.IsNullOrEmpty( Eval("DueDate").ToString() )?string.Empty: Convert.ToDateTime(Eval("DueDate")).ToShortDateString()%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Hrs. Est" HeaderStyle-Width="13%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                    <ItemTemplate>
                                                        <%# Eval("Hours") %>
                                                    </ItemTemplate>
                                                    <HeaderStyle Width="5%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Note Ref:" HeaderStyle-Width="10%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                    <ItemTemplate>
                                                        Note Ref#
                                                    </ItemTemplate>
                                                </asp:TemplateField>--%>
                                                        <asp:TemplateField HeaderText="Type" HeaderStyle-Width="15%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <%# String.IsNullOrEmpty(Eval("TaskType").ToString()) == true ? String.Empty : ddlTaskType.Items.FindByValue( Eval("TaskType").ToString()).Text %>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Status" HeaderStyle-Width="15%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <%# string.Concat(cmbStatus.Items.FindByValue( Eval("Status").ToString()).Text , ":" , Eval("FristName")).Trim().TrimEnd(':') %>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Attachments" HeaderStyle-Width="15%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                                            <ItemTemplate>
                                                                <asp:Repeater ID="rptAttachment" OnItemCommand="rptAttachment_ItemCommand" OnItemDataBound="rptAttachment_ItemDataBound" runat="server">
                                                                    <ItemTemplate>
                                                                        <small>
                                                                            <asp:LinkButton ID="lbtnDownload" runat="server" ForeColor="Blue"
                                                                                CommandName="DownloadFile" /><asp:Literal ID="ltrlSeprator" runat="server" Text=" ," /></small>
                                                                    </ItemTemplate>
                                                                </asp:Repeater>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                    <br />
                                    <asp:UpdatePanel ID="upAddSubTask" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:LinkButton ID="lbtnAddNewSubTask" runat="server" Text="Add New Task" OnClick="lbtnAddNewSubTask_Click" />
                                            <br />
                                            <asp:ValidationSummary ID="vsSubTask" runat="server" ValidationGroup="vgSubTask" ShowSummary="False" ShowMessageBox="True" />
                                            <div id="divSubTask" runat="server" style="display: none;">
                                                <asp:HiddenField ID="hdnSubTaskId" runat="server" Value="0" />
                                                <table class="tablealign fullwidth">
                                                    <tr>
                                                        <td>ListID:
                                                    <asp:TextBox ID="txtTaskListID" runat="server" />
                                                            &nbsp; <small><a href="javascript:void(0);" style="color: #06c;" onclick="copytoListID(this);">
                                                                <asp:Literal ID="listIDOpt" runat="server" />
                                                            </a></small></td>
                                                        <td>Type:
                                                    <asp:DropDownList ID="ddlTaskType" AutoPostBack="true" OnSelectedIndexChanged="ddlTaskType_SelectedIndexChanged" runat="server"></asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr style="display: none;">
                                                        <td colspan="2">Title <span style="color: red;">*</span>:
                            <br />
                                                            <asp:TextBox ID="txtSubTaskTitle" Text="N.A." runat="server" Width="98%" CssClass="textbox" />
                                                            <asp:RequiredFieldValidator ID="rfvSubTaskTitle" Visible="false" ValidationGroup="vgSubTask"
                                                                runat="server" ControlToValidate="txtSubTaskTitle" ForeColor="Red" ErrorMessage="Please Enter Task Title" Display="None" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">Description <span style="color: red;">*</span>:
                            <br />
                                                            <asp:TextBox ID="txtSubTaskDescription" runat="server" CssClass="textbox" TextMode="MultiLine" Rows="5" Width="98%" />
                                                            <asp:RequiredFieldValidator ID="rfvSubTaskDescription" ValidationGroup="vgSubTask"
                                                                runat="server" ControlToValidate="txtSubTaskDescription" ForeColor="Red" ErrorMessage="Please Enter Task Description" Display="None" />
                                                        </td>
                                                    </tr>
                                                    <tr id="trDateHours" runat="server" visible="false">
                                                        <td>Due Date:
                            <asp:TextBox ID="txtSubTaskDueDate" runat="server" CssClass="textbox datepicker" />
                                                        </td>
                                                        <td>Hrs of Task:
                            <asp:TextBox ID="txtSubTaskHours" runat="server" CssClass="textbox" />
                                                            <asp:RegularExpressionValidator ID="revSubTaskHours" runat="server" ControlToValidate="txtSubTaskHours" Display="None"
                                                                ErrorMessage="Please enter decimal numbers for hours of task." ValidationGroup="vgSubTask"
                                                                ValidationExpression="(\d+\.\d{1,2})?\d*" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Attachment(s):<br>
                                                            <input id="hdnAttachments" runat="server" type="hidden" />
                                                            <div id="divSubTaskDropzone" class="dropzone" style="overflow: auto; width: 415px;">
                                                                <div class="fallback">
                                                                    <input name="file" type="file" multiple />
                                                                    <input type="submit" value="Upload" />
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div id="divSubTaskDropzonePreview" class="dropzone-previews">
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <div class="btn_sec">
                                                                <asp:Button ID="btnSaveSubTask" runat="server" Text="Save Sub Task" CssClass="ui-button" ValidationGroup="vgSubTask"
                                                                    OnClick="btnSaveSubTask_Click" />
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </fieldset>
                            </td>
                        </tr>
                        <tr>
                            <td>User Acceptance:</td>
                            <td>
                                <asp:DropDownList ID="ddlUserAcceptance" runat="server" CssClass="textbox">
                                    <asp:ListItem Text="Accept" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Reject" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>Due Date:</td>
                            <td>
                                <asp:TextBox ID="txtDueDate" runat="server" CssClass="textbox datepicker" />
                                <%--<asp:CalendarExtender ID="CEDueDate" runat="server" TargetControlID="txtDueDate"></asp:CalendarExtender>--%>
                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator3" ValidationGroup="Submit"
                            runat="server" ControlToValidate="txtDueDate" ForeColor="Red" ErrorMessage="Please Enter Due Date" Display="None">                                 
                        </asp:RequiredFieldValidator>--%>
                            </td>
                        </tr>
                        <tr>
                            <td>Hrs of Task:</td>
                            <td>
                                <asp:TextBox ID="txtHours" runat="server" CssClass="textbox" />
                                <asp:RegularExpressionValidator ID="revHours" runat="server" ControlToValidate="txtHours" Display="None"
                                    ErrorMessage="Please enter decimal numbers for hours of task." ValidationGroup="Submit" ValidationExpression="(\d+\.\d{1,2})?\d*" />
                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator4" ValidationGroup="Submit"
                            runat="server" ControlToValidate="txtHours" ForeColor="Red" ErrorMessage="Please Enter Hours Of Task" Display="None">                                 
                        </asp:RequiredFieldValidator>--%>
                            </td>
                            <td>Staus:</td>
                            <td>
                                <asp:DropDownList ID="cmbStatus" runat="server" CssClass="textbox">
                                    <%--<asp:ListItem Text="Open" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Assigned" Value="2"></asp:ListItem>
                            <asp:ListItem Text="In Progress" Value="3"></asp:ListItem>
                            <asp:ListItem Text="Pending" Value="4"></asp:ListItem>
                            <asp:ListItem Text="Re-Opened" Value="5"></asp:ListItem>
                            <asp:ListItem Text="Closed" Value="6"></asp:ListItem>--%>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4">
                                <div class="btn_sec">
                                    <asp:Button ID="btnSaveTask" runat="server" Text="Save Task" CssClass="ui-button" ValidationGroup="Submit" OnClick="btnSaveTask_Click" />
                                </div>
                            </td>
                        </tr>
                    </table>
                    <!-- table for userview -->
                    <table id="tblUserTaskView" class="tablealign" style="width: 100%;" cellspacing="5" runat="server">
                        <tr>

                            <td><b>Designation:</b>
                                <asp:Literal ID="ltlTUDesig" runat="server"></asp:Literal>
                            </td>

                            <td><b>Status:</b>
                                <asp:DropDownList ID="ddlTUStatus" AutoPostBack="true" runat="server" CssClass="textbox">
                                    <%--<asp:ListItem Text="Open" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Assigned" Value="2"></asp:ListItem>
                            <asp:ListItem Text="In Progress" Value="3"></asp:ListItem>
                            <asp:ListItem Text="Pending" Value="4"></asp:ListItem>
                            <asp:ListItem Text="Re-Opened" Value="5"></asp:ListItem>
                            <asp:ListItem Text="Closed" Value="6"></asp:ListItem>--%>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top"><b>Task Title:</b>
                                <asp:Literal ID="ltlTUTitle" runat="server"></asp:Literal>
                            </td>
                            <td valign="top">
                                <br />
                                <asp:LinkButton runat="server" Text="Finished Work Files" />&nbsp;&nbsp;
                                <asp:LinkButton runat="server" Text="Work Specification Files" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2"><b>Task Description:</b>
                                <asp:TextBox ID="txtTUDesc" TextMode="MultiLine" ReadOnly="true" Style="width: 100%;" Rows="10" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td><b>User Acceptance:</b>
                                <asp:DropDownList ID="ddlTUAcceptance" AutoPostBack="true" runat="server" CssClass="textbox">
                                    <asp:ListItem Text="Accept" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Reject" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td><b>Due Date:</b>
                                <asp:Literal ID="ltlTUDueDate" runat="server"></asp:Literal></td>
                        </tr>
                        <tr>
                            <td><b>Hrs of Task:</b>
                                <asp:Literal ID="ltlTUHrsTask" runat="server"></asp:Literal></td>
                            <td></td>
                        </tr>
                    </table>
                    <hr />
                    <br />
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="Submit" ShowSummary="False" ShowMessageBox="True" />
                    <asp:UpdatePanel ID="upTaskHistory" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:TabContainer ID="tcTaskHistory" runat="server" ActiveTabIndex="0" AutoPostBack="false">
                                <asp:TabPanel ID="tpTaskHistory_Notes" runat="server" TabIndex="0" CssClass="task-history-tab">
                                    <HeaderTemplate>Notes</HeaderTemplate>
                                    <ContentTemplate>
                                        <div class="grid">
                                            <asp:GridView ID="gdTaskUsers" runat="server" EmptyDataText="No task history available!" ShowHeaderWhenEmpty="true" AutoGenerateColumns="false" Width="100%" HeaderStyle-BackColor="Black" HeaderStyle-ForeColor="White" AllowSorting="false" BackColor="White" PageSize="3" GridLines="Horizontal" OnRowDataBound="gdTaskUsers_RowDataBound" OnRowCommand="gdTaskUsers_RowCommand">
                                                <%--<EmptyDataTemplate>
                    </EmptyDataTemplate>--%>
                                                <Columns>
                                                    <asp:TemplateField ShowHeader="True" HeaderText="User" ControlStyle-ForeColor="White" HeaderStyle-Font-Size="Small"
                                                        ItemStyle-HorizontalAlign="Left">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lbluser" runat="server" Text='<%#String.IsNullOrEmpty(Eval("FristName").ToString())== true ? Eval("UserFirstName").ToString() : Eval("FristName").ToString() %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <ControlStyle ForeColor="Black" />
                                                        <ControlStyle ForeColor="Black" />
                                                        <HeaderStyle Font-Size="Small"></HeaderStyle>
                                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField ShowHeader="True" HeaderText="Date & Time" ControlStyle-ForeColor="White" HeaderStyle-Font-Size="Small"
                                                        ItemStyle-HorizontalAlign="Left">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblupdateDate" runat="server" Text='<%#Eval("UpdatedOn")%>'></asp:Label>
                                                        </ItemTemplate>
                                                        <ControlStyle ForeColor="Black" />
                                                        <ControlStyle ForeColor="Black" />
                                                        <HeaderStyle Font-Size="Small"></HeaderStyle>
                                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField ShowHeader="false" Visible="false" ControlStyle-ForeColor="White" HeaderStyle-Font-Size="Small"
                                                        ItemStyle-HorizontalAlign="Left">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lbluserId" runat="server" Text='<%#Eval("Id")%>' Visible="false"></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <%--<asp:TemplateField ShowHeader="false" Visible="false" ControlStyle-ForeColor="White" HeaderStyle-Font-Size="Small"
                            ItemStyle-HorizontalAlign="Left">
                            <ItemTemplate>
                                <asp:Label ID="lbluserType" runat="server" Text='<%#Eval("UserType")%>' Visible="false"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>--%>
                                                    <asp:TemplateField ShowHeader="True" HeaderText="Notes" ControlStyle-ForeColor="White" HeaderStyle-Font-Size="Small"
                                                        ItemStyle-HorizontalAlign="Left">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblNotes" runat="server" Text='<%#Eval("Notes")%>'></asp:Label>
                                                        </ItemTemplate>
                                                        <ControlStyle ForeColor="Black" />
                                                        <ControlStyle ForeColor="Black" />
                                                        <HeaderStyle Font-Size="Small"></HeaderStyle>
                                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField ShowHeader="True" HeaderText="Status" ControlStyle-ForeColor="White" HeaderStyle-Font-Size="Small"
                                                        ItemStyle-HorizontalAlign="Left">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblStatus" runat="server"></asp:Label>
                                                        </ItemTemplate>
                                                        <ControlStyle ForeColor="Black" />
                                                        <ControlStyle ForeColor="Black" />
                                                        <HeaderStyle Font-Size="Small"></HeaderStyle>
                                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField ShowHeader="True" HeaderText="Files" ControlStyle-ForeColor="White" HeaderStyle-Font-Size="Small"
                                                        ItemStyle-HorizontalAlign="Left">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblFiles" runat="server" Text='<%# Eval("AttachmentCount")%>'></asp:Label>
                                                            <br>
                                                            <asp:LinkButton ID="lbtnAttachment" runat="server" Text="Download" CommandName="DownLoadFiles" CommandArgument='<%# Eval("attachments")%>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                        <ControlStyle ForeColor="Black" />
                                                        <ControlStyle ForeColor="Black" />
                                                        <HeaderStyle Font-Size="Small"></HeaderStyle>
                                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                                    </asp:TemplateField>
                                                </Columns>
                                                <HeaderStyle BackColor="Black" ForeColor="White"></HeaderStyle>
                                            </asp:GridView>
                                            <%-- OnRowDataBound="GridView1_RowDataBound"    OnPageIndexChanging="GridView1_PageIndexChanging" OnRowCommand="GridView1_RowCommand"--%>
                                        </div>
                                        <br />
                                        <table cellspacing="0" cellpadding="0" width="950px" border="1" style="width: 100%; border-collapse: collapse;">
                                            <tr>
                                                <td>Notes:
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtNote" runat="server" TextMode="MultiLine" Width="90%" CssClass="textbox"></asp:TextBox>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td colspan="2">
                                                    <div class="btn_sec">
                                                        <asp:Button ID="btnAddNote" runat="server" Text="Add Note & Files" CssClass="ui-button" OnClick="btnAddNote_Click" />
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </asp:TabPanel>
                                <asp:TabPanel ID="tpTaskHistory_FilesAndDocs" runat="server" TabIndex="0" CssClass="task-history-tab">
                                    <HeaderTemplate>Files & docs</HeaderTemplate>
                                    <ContentTemplate>
                                        HTML Goes here 1
                                    </ContentTemplate>
                                </asp:TabPanel>
                                <asp:TabPanel ID="tpTaskHistory_Images" runat="server" TabIndex="0" CssClass="task-history-tab">
                                    <HeaderTemplate>Images</HeaderTemplate>
                                    <ContentTemplate>
                                        HTML Goes here 3
                                    </ContentTemplate>
                                </asp:TabPanel>
                                <asp:TabPanel ID="tpTaskHistory_Links" runat="server" TabIndex="0" CssClass="task-history-tab">
                                    <HeaderTemplate>Links</HeaderTemplate>
                                    <ContentTemplate>
                                        HTML Goes here 4
                                    </ContentTemplate>
                                </asp:TabPanel>
                                <asp:TabPanel ID="tpTaskHistory_Videos" runat="server" TabIndex="0" CssClass="task-history-tab">
                                    <HeaderTemplate>Videos</HeaderTemplate>
                                    <ContentTemplate>
                                        HTML Goes here 5
                                    </ContentTemplate>
                                </asp:TabPanel>
                                <asp:TabPanel ID="tpTaskHistory_Audios" runat="server" TabIndex="0" CssClass="task-history-tab">
                                    <HeaderTemplate>Audios</HeaderTemplate>
                                    <ContentTemplate>
                                        HTML Goes here 6
                                    </ContentTemplate>
                                </asp:TabPanel>
                            </asp:TabContainer>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

        <div id="divFinishedWorkFiles" runat="server" style="display: none; width: 600px;" title="Finished Work Files">
            <%--Finished Work Files--%>
            <asp:UpdatePanel ID="upFinishedWorkFiles" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <table width="500">
                        <tr>
                            <td>Attachment(s):<br>
                                <table style="width: 100%;">
                                    <tr>
                                        <td>
                                            <asp:Repeater ID="rptWorkFiles" OnItemCommand="rptAttachment_ItemCommand" OnItemDataBound="rptAttachment_ItemDataBound" runat="server">
                                                <HeaderTemplate>
                                                    <table class="table">
                                                        <thead>
                                                            <tr class="trHeader">
                                                                <th>Attachments</th>
                                                                <th>Uploaded By</th>
                                                            </tr>
                                                        </thead>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr class="FirstRow">
                                                        <td><small>
                                                            <asp:LinkButton ID="lbtnDownload" runat="server" ForeColor="Blue"
                                                                CommandName="DownloadFile" /></small>
                                                        </td>
                                                        <td>Justin
                                                        </td>
                                                    </tr>

                                                </ItemTemplate>
                                                <AlternatingItemTemplate>
                                                    <tr class="AlternateRow">
                                                        <td><small>
                                                            <asp:LinkButton ID="lbtnDownload" runat="server" ForeColor="Blue"
                                                                CommandName="DownloadFile" /></small>
                                                        </td>
                                                        <td>Justin
                                                        </td>
                                                    </tr>
                                                </AlternatingItemTemplate>
                                                <FooterTemplate>
                                                    </table>
                                                </FooterTemplate>
                                            </asp:Repeater>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input id="hdnWorkFiles" runat="server" type="hidden" />
                                            <div id="divWorkFile" class="dropzone">
                                                <div class="fallback">
                                                    <input name="WorkFile" type="file" multiple />
                                                    <input type="submit" value="UploadWorkFile" />
                                                </div>
                                            </div>
                                            <div id="divWorkFilePreview" class="dropzone-previews">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr style="display:none;">
                                        <td>
                                            <div class="btn_sec">
                                                <asp:Button ID="btnAddAttachment" runat="server" OnClick="btnAddAttachment_ClicK" Text="Save"
                                                    CssClass="ui-button" />
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <div id="divWorkSpecifications" runat="server" style="display: none; width: 600px;" title="Work Specification Files">
            <%--Work Specification Files--%>
            <asp:UpdatePanel ID="upWorkSpecificationFiles" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <table class="table" width="500">
                        <thead>
                            <tr class="trHeader">
                                <th>Document</th>
                                <th>Modified By</th>
                                <th>Modified Time</th>
                            </tr>
                        </thead>
                        <tr class="FirstRow">
                            <td><a href="#">edit-salesuser-v1.0</a></td>
                            <td>Justin</td>
                            <td>09-07-2016 14:44 p.m.</td>
                        </tr>
                        <tr class="AlternateRow">
                            <td><a href="#">edit-salesuser-v1.0</a></td>
                            <td>Justin</td>
                            <td>09-07-2016 14:44 p.m.</td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <script type="text/javascript">

        $(function () {
            Initialize();
        });

        var prmTaskGenerator = Sys.WebForms.PageRequestManager.getInstance();

        prmTaskGenerator.add_endRequest(function () {
            Initialize();
        });

        function Initialize() {
            ApplyDropZone();
        }

        function ShowPopup(varControlID) {
            $(varControlID).dialog().open();
            //$(varControlID).parent().find('span.ui-dialog-title').html(tasktitle);
        }

        function HidePopup(varControlID) {
            $(varControlID).dialog("close");
        }

        var objMainTaskDropzone, objSubTaskDropzone;
        Dropzone.autoDiscover = false;
        Dropzone.options.dropzoneForm = false;

        //Add uploaded attachment to viewstate of page to save later.
        function AddAttachmenttoViewState(serverfilename, hdnControlID) {

            var attachments;

            if ($(hdnControlID).val()) {
                attachments = $(hdnControlID).val() + serverfilename + "^";
            }
            else {
                attachments = serverfilename + "^";
            }

            $(hdnControlID).val(attachments);
            console.log('file : ' + $(hdnControlID).val());

            // saves attachment.
            $('#<%=btnAddAttachment.ClientID%>').click();
        }

        //Remove file from server once it is removed from dropzone.
        function RemoveTaskAttachmentFromServer(filename) {
            //var param = { serverfilename: filename };
            //$.ajax({
            //    type: "POST",
            //    data: JSON.stringify(param),
            //    url: "taskattachmentupload.aspx/RemoveUploadedattachment",
            //    contentType: "application/json; charset=utf-8",
            //    dataType: "json",
            //    success: OnAttachmentRemoveSuccess,
            //    error: OnAttachmentRemoveError
            //});
        }

        // Once attachement is removed then remove it from viewstate as well to keep correct track of file upload.
        function OnAttachmentRemoveSuccess(data) {
            var result = data.d;
            if (r - esult) {
                RemoveAttachmentFromViewState(result);
            }
        }

        // Once attachement is removed then remove it from viewstate as well to keep correct track of file upload.
        function OnAttachmentRemoveError(data) {
            var result = data.d;
            if (result) {
                console.log(result);
            }
        }

        function RemoveAttachmentFromViewState(filename) {
            console.log($('#<%= hdnAttachments.ClientID %>').val());
            if ($('#<%= hdnAttachments.ClientID %>').val()) {

                //split images added by ^ seperator
                var attachments = $('#<%= hdnAttachments.ClientID %>').val().split("^");

                console.log(attachments);

                if (attachments.length > 0) {
                    //find index of filename and remove it.
                    var index = attachments.indexOf(filename);

                    if (index > -1) {
                        attachments.splice(index, 1);
                    }
                    console.log(attachments);

                    //join remaining attachments.
                    if (attachments.length > 0) {
                        $('#<%= hdnAttachments.ClientID %>').val(attachments.join("^"));
                    }
                    else {
                        $('#<%= hdnAttachments.ClientID %>').val("");
                    }
                }
            }
        }

        function ApplyDropZone() {
            //debugger;
            ////User's drag and drop file attachment related code

            ////remove already attached dropzone.
            //if (objMainTaskDropzone) {
            //    objMainTaskDropzone.destroy();
            //    objMainTaskDropzone = null;
            //}

            objMainTaskDropzone = new Dropzone("div#divWorkFile", {
                maxFiles: 5,
                url: "taskattachmentupload.aspx",
                thumbnailWidth: 90,
                thumbnailHeight: 90,
                previewsContainer: 'div#divWorkFilePreview',
                init: function () {
                    this.on("maxfilesexceeded", function (data) {
                        //var res = eval('(' + data.xhr.responseText + ')');
                        alert('you are reached maximum attachment upload limit.');
                    });

                    // when file is uploaded successfully store its corresponding server side file name to preview element to remove later from server.
                    this.on("success", function (file, response) {
                        var filename = response.split("^");
                        $(file.previewTemplate).append('<span class="server_file">' + filename[0] + '</span>');
                        console.log(file);
                        AddAttachmenttoViewState(filename[0] + '@' + file.name, '#<%= hdnWorkFiles.ClientID %>');
                        //this.removeFile(file);
                    });

                    //when file is removed from dropzone element, remove its corresponding server side file.
                    //this.on("removedfile", function (file) {
                    //    var server_file = $(file.previewTemplate).children('.server_file').text();
                    //    RemoveTaskAttachmentFromServer(server_file);
                    //});

                    // When is added to dropzone element, add its remove link.
                    //this.on("addedfile", function (file) {

                    //    // Create the remove button
                    //    var removeButton = Dropzone.createElement("<a><small>Remove file</smalll></a>");

                    //    // Capture the Dropzone instance as closure.
                    //    var _this = this;

                    //    // Listen to the click event
                    //    removeButton.addEventListener("click", function (e) {
                    //        // Make sure the button click doesn't submit the form:
                    //        e.preventDefault();
                    //        e.stopPropagation();
                    //        // Remove the file preview.
                    //        _this.removeFile(file);
                    //    });

                    //    // Add the button to the file preview element.
                    //    file.previewElement.appendChild(removeButton);
                    //});
                }

            });

            //remove already attached dropzone.
            if (objSubTaskDropzone) {
                objSubTaskDropzone.destroy();
                objSubTaskDropzone = null;
            }

            objSubTaskDropzone = new Dropzone("div#divSubTaskDropzone", {
                maxFiles: 5,
                url: "taskattachmentupload.aspx",
                thumbnailWidth: 90,
                thumbnailHeight: 90,
                previewsContainer: 'div#divSubTaskDropzonePreview',
                init: function () {
                    this.on("maxfilesexceeded", function (data) {
                        //var res = eval('(' + data.xhr.responseText + ')');
                        alert('you are reached maximum attachment upload limit.');
                    });

                    // when file is uploaded successfully store its corresponding server side file name to preview element to remove later from server.
                    this.on("success", function (file, response) {
                        var filename = response.split("^");
                        $(file.previewTemplate).append('<span class="server_file">' + filename[0] + '</span>');
                        console.log(file);
                        AddAttachmenttoViewState(filename[0] + '@' + file.name, '#<%= hdnAttachments.ClientID %>');
                        //this.removeFile(file);
                    });

                    //when file is removed from dropzone element, remove its corresponding server side file.
                    //this.on("removedfile", function (file) {
                    //    var server_file = $(file.previewTemplate).children('.server_file').text();
                    //    RemoveTaskAttachmentFromServer(server_file);
                    //});

                    // When is added to dropzone element, add its remove link.
                    //this.on("addedfile", function (file) {

                    //    // Create the remove button
                    //    var removeButton = Dropzone.createElement("<a><small>Remove file</smalll></a>");

                    //    // Capture the Dropzone instance as closure.
                    //    var _this = this;

                    //    // Listen to the click event
                    //    removeButton.addEventListener("click", function (e) {
                    //        // Make sure the button click doesn't submit the form:
                    //        e.preventDefault();
                    //        e.stopPropagation();
                    //        // Remove the file preview.
                    //        _this.removeFile(file);
                    //    });

                    //    // Add the button to the file preview element.
                    //    file.previewElement.appendChild(removeButton);
                    //});
                }

            });
        }

        // check if user has selected any designations or not.
        function checkDesignations(oSrc, args) {

            var n = $("#<%= ddlUserDesignation.ClientID%> input:checked").length;

            args.IsValid = (n > 0);
        }

        function copytoListID(sender) {
            var strListID = $.trim($(sender).text());
            if (strListID.length > 0) {
                $('#<%= txtTaskListID.ClientID %>').val(strListID);
                }
            }

    </script>
</asp:Content>
