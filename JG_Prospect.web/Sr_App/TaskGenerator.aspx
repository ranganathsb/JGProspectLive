﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" CodeBehind="TaskGenerator.aspx.cs"
    Inherits="JG_Prospect.Sr_App.TaskGenerator" ValidateRequest="false" EnableEventValidation="false" %>

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
                            <td style="width: 40%;">Designation <span style="color: red;">*</span>: 
                               
                               

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
                            <td>Assigned:    
                               
                               

                                <asp:UpdatePanel ID="upnlAssigned" runat="server" RenderMode="Inline">
                                    <ContentTemplate>
                                        <asp:DropDownCheckBoxes ID="ddcbAssigned" runat="server" UseSelectAllNode="false"
                                            AutoPostBack="true" OnSelectedIndexChanged="ddcbAssigned_SelectedIndexChanged">
                                            <Style SelectBoxWidth="195" DropDownBoxBoxWidth="120" DropDownBoxBoxHeight="150" />
                                            <Texts SelectBoxCaption="--Open--" />
                                        </asp:DropDownCheckBoxes>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <span style="padding-left:20px;">
                                    <asp:CheckBox ID="chkTechTask" runat="server" Checked="false" Text=" Tech Task" />
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td class="valigntop">Task Title <span style="color: red;">*</span>:<br />
                                <asp:TextBox ID="txtTaskTitle" runat="server" Style="width: 90%" CssClass="textbox"></asp:TextBox>
                                <%--<ajax:Editor ID="txtTaskTitle" Width="100%" Height="20px" runat="server" ActiveMode="Design" AutoFocus="true" />--%>
                                <asp:RequiredFieldValidator ID="rfvTaskTitle" ValidationGroup="Submit"
                                    runat="server" ControlToValidate="txtTaskTitle" ForeColor="Red" ErrorMessage="Please Enter Task Title" Display="None">                                 
                                </asp:RequiredFieldValidator>
                                <asp:HiddenField ID="controlMode" runat="server" />
                                <asp:HiddenField ID="hdnTaskId" runat="server" Value="0" />
                            </td>
                            <td class="valigntop">
                                <table>
                                    <tr>
                                        <td style="width: 30%;" class="valigntop">
                                            <asp:LinkButton ID="lbtnWorkSpecificationFiles" runat="server" Text="Work Specification Files"
                                                ValidationGroup="Submit" OnClick="lbtnWorkSpecificationFiles_Click" />
                                        </td>
                                        <td class="valigntop">
                                            <asp:LinkButton ID="lbtnFinishedWorkFiles" runat="server" Text="Finished Work Files"
                                                OnClick="lbtnFinishedWorkFiles_Click" />&nbsp;&nbsp;
                                           
                                            <br />
                                            <div id="divWorkFileAdmin" class="dropzone work-file">
                                                <div class="fallback">
                                                    <input name="WorkFile" type="file" multiple />
                                                    <input type="submit" value="UploadWorkFile" />
                                                </div>
                                            </div>
                                            <div id="divWorkFileAdminPreview" class="dropzone-previews work-file-previews">
                                            </div>

                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">Task Description <span style="color: red;">*</span>:<br />
                                <asp:TextBox ID="txtDescription" TextMode="MultiLine" runat="server" CssClass="textbox" Width="98%" Rows="10"></asp:TextBox>
                                <%--<ajax:Editor ID="txtDescription" Width="100%" Height="100px" runat="server" ActiveMode="Design" AutoFocus="true" />--%>
                                <asp:RequiredFieldValidator ID="rfvDesc" ValidationGroup="Submit"
                                    runat="server" ControlToValidate="txtDescription" ForeColor="Red" ErrorMessage="Please Enter Task Description" Display="None">                                 
                                </asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr id="trSubTaskList" runat="server">
                            <td colspan="2">
                                <fieldset class="tasklistfieldset">
                                    <legend>Task List</legend>
                                    <asp:UpdatePanel ID="upSubTasks" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <div id="divSubTaskGrid">
                                                <asp:GridView ID="gvSubTasks" runat="server" ShowHeaderWhenEmpty="true" EmptyDataRowStyle-HorizontalAlign="Center"
                                                    HeaderStyle-BackColor="Black" HeaderStyle-ForeColor="White" BackColor="White" EmptyDataRowStyle-ForeColor="Black"
                                                    EmptyDataText="No sub task available!" CssClass="table" Width="100%" CellSpacing="0" CellPadding="0"
                                                    AutoGenerateColumns="False" GridLines="Vertical" DataKeyNames="TaskId"
                                                    OnRowDataBound="gvSubTasks_RowDataBound"
                                                    OnRowCommand="gvSubTasks_RowCommand">
                                                    <EmptyDataRowStyle ForeColor="White" HorizontalAlign="Center" />
                                                    <HeaderStyle CssClass="trHeader " />
                                                    <RowStyle CssClass="FirstRow" />
                                                    <AlternatingRowStyle CssClass="AlternateRow " />
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="List ID" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="10%">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lbtnEditSubTask" runat="server" CommandName="edit-sub-task" Text='<%# Eval("InstallId") %>'
                                                                    CommandArgument='<%# Container.DataItemIndex  %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Task Description" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                                                            <ItemTemplate>
                                                                <%# Eval("Description")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Type" HeaderStyle-Width="15%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <%# String.IsNullOrEmpty(Eval("TaskType").ToString()) == true ? String.Empty : ddlTaskType.Items.FindByValue( Eval("TaskType").ToString()).Text %>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Status" HeaderStyle-Width="15%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <asp:DropDownList ID="ddlStatus" runat="server" AutoPostBack="true" OnSelectedIndexChanged="gvSubTasks_ddlStatus_SelectedIndexChanged" />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Priority" HeaderStyle-Width="15%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <asp:DropDownList ID="ddlTaskPriority" runat="server" AutoPostBack="true" OnSelectedIndexChanged="gvSubTasks_ddlTaskPriority_SelectedIndexChanged" />
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
                                            <div id="divSubTask" runat="server" class="tasklistfieldset" style="display: none;">
                                                <asp:HiddenField ID="hdnSubTaskId" runat="server" Value="0" />
                                                <asp:HiddenField ID="hdnSubTaskIndex" runat="server" Value="-1" />
                                                <table class="tablealign fullwidth">
                                                    <tr>
                                                        <td>ListID:
                                                           
                                                            <asp:TextBox ID="txtTaskListID" runat="server" />
                                                            &nbsp; <small><a href="javascript:void(0);" style="color: #06c;" onclick="copytoListID(this);">
                                                                <asp:Literal ID="listIDOpt" runat="server" />
                                                            </a></small></td>
                                                        <td>Type:
                                                           
                                                            <asp:DropDownList ID="ddlTaskType" AutoPostBack="true" OnSelectedIndexChanged="ddlTaskType_SelectedIndexChanged" runat="server"></asp:DropDownList>

                                                            &nbsp;&nbsp;
                                                            Priority:
                                                                   
                                                           

                                                            <asp:DropDownList ID="ddlSubTaskPriority" runat="server" />
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
                                                    <tr>
                                                        <td>Attachment(s):<br>
                                                            <input id="hdnAttachments" runat="server" type="hidden" />
                                                            <div id="divSubTaskDropzone" runat="server" class="dropzone">
                                                                <div class="fallback">
                                                                    <input name="file" type="file" multiple />
                                                                    <input type="submit" value="Upload" />
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div id="divSubTaskDropzonePreview" runat="server" class="dropzone-previews">
                                                            </div>
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
                                                    <tr id="trSubTaskStatus" runat="server" visible="false">
                                                        <td>Status:
                                                           
                                                            <asp:DropDownList ID="ddlSubTaskStatus" runat="server" />
                                                        </td>
                                                        <td>&nbsp;
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
                            <td colspan="2" align="left">Staus:
                               
                                <asp:DropDownList ID="cmbStatus" runat="server" CssClass="textbox" />
                                &nbsp;&nbsp;Priority:&nbsp;<asp:DropDownList ID="ddlTaskPriority" runat="server" CssClass="textbox" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
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
                                </asp:DropDownList>
                                &nbsp;&nbsp;
                               
                                <b>Priority:</b>
                                <asp:Literal ID="ltrlTaskPriority" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td class="valigntop"><b>Task Title:</b>
                                <asp:Literal ID="ltlTUTitle" runat="server"></asp:Literal>
                            </td>
                            <td class="valigntop">
                                <br />
                                <asp:LinkButton ID="lbtnFinishedWorkFiles1" runat="server" Text="Finished Work Files"
                                    OnClick="lbtnFinishedWorkFiles_Click" />&nbsp;&nbsp;
                               
                               

                                <asp:LinkButton ID="lbtnWorkSpecificationFiles1" runat="server" Text="Work Specification Files"
                                    OnClick="lbtnWorkSpecificationFiles_Click" />
                                <br />
                                <br />
                                <div>
                                    <div id="divWorkFileUser" class="dropzone work-file">
                                        <div class="fallback">
                                            <input name="WorkFile" type="file" multiple />
                                            <input type="submit" value="UploadWorkFile" />
                                        </div>
                                    </div>
                                    <div id="divWorkFileUserPreview" class="dropzone-previews work-file-previews">
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2"><b>Task Description:</b>
                                <asp:TextBox ID="txtTUDesc" TextMode="MultiLine" ReadOnly="true" Style="width: 100%;" Rows="10" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <fieldset class="tasklistfieldset">
                                    <legend>Task List</legend>
                                    <div>
                                        <asp:GridView ID="gvSubTasks1" runat="server" ShowHeaderWhenEmpty="true" EmptyDataRowStyle-HorizontalAlign="Center"
                                            HeaderStyle-BackColor="Black" HeaderStyle-ForeColor="White" BackColor="White" EmptyDataRowStyle-ForeColor="Black"
                                            EmptyDataText="No sub task available!" CssClass="table" Width="100%" CellSpacing="0" CellPadding="0"
                                            AutoGenerateColumns="False" GridLines="Vertical" DataKeyNames="TaskId"
                                            OnRowDataBound="gvSubTasks_RowDataBound"
                                            OnRowCommand="gvSubTasks_RowCommand">
                                            <EmptyDataRowStyle ForeColor="White" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="trHeader " />
                                            <RowStyle CssClass="FirstRow" />
                                            <AlternatingRowStyle CssClass="AlternateRow " />
                                            <Columns>
                                                <asp:TemplateField HeaderText="List ID" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="10%">
                                                    <ItemTemplate>
                                                        <%# Eval("InstallId") %>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Task Description" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                                                    <ItemTemplate>
                                                        <%# Eval("Description")%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Type" HeaderStyle-Width="15%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                    <ItemTemplate>
                                                        <%# String.IsNullOrEmpty(Eval("TaskType").ToString()) == true ? String.Empty : ddlTaskType.Items.FindByValue( Eval("TaskType").ToString()).Text %>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Status" HeaderStyle-Width="15%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                    <ItemTemplate>
                                                        <asp:DropDownList ID="ddlStatus" runat="server" AutoPostBack="true" OnSelectedIndexChanged="gvSubTasks_ddlStatus_SelectedIndexChanged" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Priority" HeaderStyle-Width="15%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                    <ItemTemplate>
                                                        <%# String.IsNullOrEmpty(Eval("TaskPriority").ToString()) == true ? String.Empty : ddlSubTaskPriority.Items.FindByValue( Eval("TaskPriority").ToString()).Text %>
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
                                </fieldset>
                            </td>
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
                <%--This is a client side hidden section and It is used to trigger server event from java script code.--%>
                <div class="hide">
                    <input id="hdnWorkFiles" runat="server" type="hidden" />
                    <asp:Button ID="btnAddAttachment" runat="server" OnClick="btnAddAttachment_ClicK" Text="Save"
                        CssClass="ui-button" />
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <%--Popup Starts--%>
    <div class="hide">
        <div id="divWorkSpecifications" runat="server">
            <asp:UpdatePanel ID="upWorkSpecificationFiles" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:TabContainer ID="tcWorkSpecification" runat="server" ActiveTabIndex="0" AutoPostBack="false">
                        <asp:TabPanel ID="tpWorkSpecification" runat="server" TabIndex="0" CssClass="">
                            <HeaderTemplate>Work Specifications</HeaderTemplate>
                            <ContentTemplate>
                                <asp:UpdatePanel ID="upWorkSpecification" runat="server" UpdateMode="Always">
                                    <ContentTemplate>
                                        <table class="table" width="100%">
                                            <tr id="trWorkSpecification" runat="server">
                                                <td>
                                                    <table width="100%">
                                                        <tr>
                                                            <td align="right">
                                                                <a href="javascript:void(0);" onclick="javascript:AcceptAllChanges();">Accept</a>&nbsp;
                                                                <a href="javascript:void(0);" onclick="javascript:RejectAllChanges();">Reject</a>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox ID="txtWorkSpecification" runat="server" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div style="height:25px;">
                                                        <div style="float: left; text-align: left; min-width: 200px;">
                                                            <asp:LinkButton ID="lbtnDownloadWorkSpecificationFilePreview" runat="server"
                                                                Text="Download Preview" OnClick="lbtnDownloadWorkSpecificationFilePreview_Click" />&nbsp;
                                                           
                                                            <asp:LinkButton ID="lbtnDownloadWorkSpecificationFile" runat="server"
                                                                Text="Download" OnClick="lbtnDownloadWorkSpecificationFile_Click" />
                                                        </div>
                                                        <div style="float: right; text-align: right; color: gray; min-width: 200px;">
                                                            <asp:Literal ID="ltrlLastCheckedInBy" runat="server" /><asp:Literal ID="ltrlLastVersionUpdateBy" runat="server" />
                                                            <br />
                                                            <asp:TextBox ID="txtPasswordToFreezeSpecification" runat="server" TextMode="Password" 
                                                                    placeholder="password to freeze" CssClass="textbox" Width="150" style="margin-top: 10px;" />
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table width="100%">
                                                        <tr>
                                                            <td align="left">User Acceptance:
                                                                <asp:DropDownList ID="ddlUserAcceptance" runat="server" CssClass="textbox">
                                                                    <asp:ListItem Text="Accept" Value="1"></asp:ListItem>
                                                                    <asp:ListItem Text="Reject" Value="0"></asp:ListItem>
                                                                </asp:DropDownList>
                                                            </td>
                                                            <td align="left">Due Date:
                                                               
                                                                <asp:TextBox ID="txtDueDate" runat="server" CssClass="textbox datepicker" Width="120" />

                                                                <asp:Literal ID="ltlTUDueDate" runat="server" />
                                                            </td>
                                                            <td align="right">Hrs of Task:
                                                               
                                                                <asp:TextBox ID="txtHours" runat="server" CssClass="textbox" Width="100" />
                                                                <asp:RegularExpressionValidator ID="revHours" runat="server" ControlToValidate="txtHours" Display="None"
                                                                    ErrorMessage="Please enter decimal numbers for hours of task." ValidationGroup="Submit" ValidationExpression="(\d+\.\d{1,2})?\d*" />

                                                                <asp:Literal ID="ltlTUHrsTask" runat="server" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr id="trWorkSpecificationSave" runat="server">
                                                <td>
                                                    <div class="btn_sec">
                                                        <asp:Button ID="btnSaveWorkSpecification" runat="server" Text="Save" CssClass="ui-button"
                                                            OnClientClick="javascript:SetContentInTextbox();"
                                                            OnClick="btnSaveWorkSpecification_Click" ValidationGroup="Submit" />
                                                        <asp:HiddenField ID="hdnWorkSpecificationId" runat="server" Value="0" />
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:PostBackTrigger ControlID="lbtnDownloadWorkSpecificationFile" />
                                        <asp:PostBackTrigger ControlID="lbtnDownloadWorkSpecificationFilePreview" />
                                    </Triggers>
                                </asp:UpdatePanel>
                            </ContentTemplate>
                        </asp:TabPanel>
                        <asp:TabPanel ID="tpWorkSpecificationAttachments" runat="server" TabIndex="0" CssClass="">
                            <HeaderTemplate>Attachment(s)</HeaderTemplate>
                            <ContentTemplate>
                                <asp:UpdatePanel ID="upWorkSpecificationAttachments" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <asp:GridView ID="grdWorkFiles" runat="server" CssClass="table" Width="100%" CellSpacing="0" CellPadding="0"
                                            GridLines="Vertical" AutoGenerateColumns="false" AllowPaging="true" ShowFooter="true" PageSize="10"
                                            PagerSettings-Position="Bottom"
                                            OnRowDataBound="grdWorkFiles_RowDataBound"
                                            OnPageIndexChanging="grdWorkFiles_PageIndexChanging"
                                            OnRowCommand="grdWorkFiles_RowCommand">
                                            <Columns>
                                                <asp:TemplateField HeaderText="Attachments">
                                                    <ItemTemplate>
                                                        <small>
                                                            <asp:LinkButton ID="lbtnDownload" runat="server" ForeColor="Blue"
                                                                CommandName="DownloadFile" /></small>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Uploaded By" ControlStyle-Width="200px">
                                                    <ItemTemplate>
                                                        <%#Eval("FirstName") %>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                            <HeaderStyle CssClass="trHeader" />
                                            <RowStyle CssClass="FirstRow" />
                                            <AlternatingRowStyle CssClass="AlternateRow" />
                                        </asp:GridView>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </ContentTemplate>
                        </asp:TabPanel>
                    </asp:TabContainer>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <div id="divFinishedWorkFiles" runat="server" title="Finished Work Files">
            <asp:UpdatePanel ID="upFinishedWorkFiles" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <table width="500">
                        <tr>
                            <td>In progress...
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <%--Popup Ends--%>
    <%--<script type="text/javascript" src="../js/jquery-migrate-1.0.0.js"></script>--%>
    <script type="text/javascript" src='../js/ice/lib/rangy/rangy-core.js'></script>
    <script type="text/javascript" src='../js/ice/src/polyfills.js'></script>
    <script type="text/javascript" src='../js/ice/src/ice.js'></script>
    <script type="text/javascript" src='../js/ice/src/dom.js'></script>
    <script type="text/javascript" src='../js/ice/src/icePlugin.js'></script>
    <script type="text/javascript" src='../js/ice/src/icePluginManager.js'></script>
    <script type="text/javascript" src='../js/ice/src/bookmark.js'></script>
    <script type="text/javascript" src='../js/ice/src/selection.js'></script>
    <script type="text/javascript" src='../js/ice/src/plugins/IceAddTitlePlugin/IceAddTitlePlugin.js'></script>
    <script type="text/javascript" src='../js/ice/src/plugins/IceCopyPastePlugin/IceCopyPastePlugin.js'></script>
    <script type="text/javascript" src='../js/ice/src/plugins/IceEmdashPlugin/IceEmdashPlugin.js'></script>
    <script type="text/javascript" src='../js/ice/src/plugins/IceSmartQuotesPlugin/IceSmartQuotesPlugin.js'></script>
    <script type="text/javascript" src="../js/ice/lib/tinymce/jscripts/tiny_mce/tiny_mce.js"></script>
    <script type="text/javascript">
        var intUserId = <%=Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]%>;
        var strUserName = '<%=Session[JG_Prospect.Common.SessionKey.Key.Username.ToString()]%>';

        var txtWorkSpecification = '<%=txtWorkSpecification.ClientID%>';
        
        function LoadTinyMce() {
            tinymce.init({
                mode: "exact",
                elements: txtWorkSpecification,
                theme: "advanced",
                plugins: 'ice,icesearchreplace',
                //theme_advanced_buttons1: "formatselect,|,removeformat,visualaid,|bold,italic,underline,|,bullist,numlist,|,undo,redo,code,|,search,replace,|styleselect,|,ice_togglechanges,ice_toggleshowchanges,iceacceptall,icerejectall,iceaccept,icereject",
                theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,bullist,numlist,|,outdent,indent",
                theme_advanced_buttons2 : "undo,redo,|,sub,sup,|,charmap,|,link,unlink,anchor,image,cleanup,code,|,help",
                theme_advanced_buttons3 : "iceaccept,icereject",
                theme_advanced_toolbar_location: "top",
                theme_advanced_toolbar_align: "left",
                extended_valid_elements: "p,span[*],delete[*],insert[*]",
                ice: {
                    user: { name: strUserName, id: intUserId },
                    preserveOnPaste: 'p,a[href],i,em,b,span',
                    deleteTag: 'delete',
                    insertTag: 'insert'
                },
                height: '350',
                width:'100%'
            });
        }

        function setUserMCE(el) {
            var name = 'J Grove';
            var id = 22;
            tinymce.execCommand('ice_changeuser', { id: id, name: name });
        }

        function AcceptAllChanges(){
            tinymce.execCommand('iceacceptall');
        }

        function RejectAllChanges(){
            tinymce.execCommand('icerejectall');
        }

        function SetContentInTextbox(){
            if($('#'+txtWorkSpecification).length > 0) {
                $('#'+txtWorkSpecification).val(""+tinymce.get(txtWorkSpecification).getContent());
            }
        }
    </script>
    <script type="text/javascript">

        Dropzone.autoDiscover = false;

        $(function () {
            Initialize();
            LoadTinyMce();
        });

        var prmTaskGenerator = Sys.WebForms.PageRequestManager.getInstance();

        prmTaskGenerator.add_endRequest(function () {
            Initialize();
        });

        function Initialize() {
            ApplyDropZone();
            LoadTinyMce();
        }

        function ShowPopup(varControlID) {
            var objDialog = $(varControlID).dialog({ width: "700px", height: "auto" });
            // this will enable postback from dialog buttons.
            objDialog.parent().appendTo(jQuery("form:first"));
        }

        function ShowPopupWithTitle(varControlID,strTitle) {
            var objDialog = $(varControlID).dialog({ width: "700px", height: "auto" });
            $('.ui-dialog-title').html(strTitle);
            // this will enable postback from dialog buttons.
            objDialog.parent().appendTo(jQuery("form:first"));
        }

        function HidePopup(varControlID) {
            $(varControlID).dialog("close");
        }

        // check if user has selected any designations or not.
        function checkDesignations(oSrc, args) {
            args.IsValid = ($("#<%= ddlUserDesignation.ClientID%> input:checked").length > 0);
        }

        function copytoListID(sender) {
            var strListID = $.trim($(sender).text());
            if (strListID.length > 0) {
                $('#<%= txtTaskListID.ClientID %>').val(strListID);
            }
        }

        function AddAttachmenttoViewState(serverfilename, hdnControlID) {

            var attachments;

            if ($(hdnControlID).val()) {
                attachments = $(hdnControlID).val() + serverfilename + "^";
            }
            else {
                attachments = serverfilename + "^";
            }

            $(hdnControlID).val(attachments);
        }

        function RemoveAttachmentFromViewState(filename) {

            if ($('#<%= hdnAttachments.ClientID %>').val()) {

                //split images added by ^ seperator
                var attachments = $('#<%= hdnAttachments.ClientID %>').val().split("^");

                if (attachments.length > 0) {
                    //find index of filename and remove it.
                    var index = attachments.indexOf(filename);

                    if (index > -1) {
                        attachments.splice(index, 1);
                    }

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

        var objWorkFileDropzone, objSubTaskDropzone;
        //Dropzone.autoDiscover = false;
        //Dropzone.options.dropzoneForm = false;

        function ApplyDropZone() {
            //debugger;
            ////User's drag and drop file attachment related code

            //remove already attached dropzone.
            if (objWorkFileDropzone) {
                objWorkFileDropzone.destroy();
                objWorkFileDropzone = null;
            }
            objWorkFileDropzone = GetWorkFileDropzone("div.work-file", 'div.work-file-previews');

            //remove already attached dropzone.
            if (objSubTaskDropzone) {
                objSubTaskDropzone.destroy();
                objSubTaskDropzone = null;
            }

            if($("#<%=divSubTaskDropzone.ClientID%>").length > 0) {
                objSubTaskDropzone = new Dropzone("#<%=divSubTaskDropzone.ClientID%>", {
                    maxFiles: 5,
                    url: "taskattachmentupload.aspx",
                    thumbnailWidth: 90,
                    thumbnailHeight: 90,
                    previewsContainer: 'div#<%=divSubTaskDropzonePreview.ClientID%>',
                    init: function () {
                        this.on("maxfilesexceeded", function (data) {
                            //var res = eval('(' + data.xhr.responseText + ')');
                            alert('you are reached maximum attachment upload limit.');
                        });

                        // when file is uploaded successfully store its corresponding server side file name to preview element to remove later from server.
                        this.on("success", function (file, response) {
                            var filename = response.split("^");
                            $(file.previewTemplate).append('<span class="server_file">' + filename[0] + '</span>');

                            AddAttachmenttoViewState(filename[0] + '@' + file.name, '#<%= hdnAttachments.ClientID %>');
                            console.log($('#<%= hdnAttachments.ClientID %>').val());
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
        }

        function GetWorkFileDropzone(strDropzoneSelector, strPreviewSelector) {
            return new Dropzone(strDropzoneSelector,
                {
                    maxFiles: 5,
                    url: "taskattachmentupload.aspx",
                    thumbnailWidth: 90,
                    thumbnailHeight: 90,
                    previewsContainer: strPreviewSelector,
                    init: function () {
                        this.on("maxfilesexceeded", function (data) {
                            //var res = eval('(' + data.xhr.responseText + ')');
                            alert('you are reached maximum attachment upload limit.');
                        });

                        // when file is uploaded successfully store its corresponding server side file name to preview element to remove later from server.
                        this.on("success", function (file, response) {
                            var filename = response.split("^");
                            $(file.previewTemplate).append('<span class="server_file">' + filename[0] + '</span>');

                            AddAttachmenttoViewState(filename[0] + '@' + file.name, '#<%= hdnWorkFiles.ClientID %>');

                            // saves attachment.
                            $('#<%=btnAddAttachment.ClientID%>').click(); console.log('clicked');
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

            //Remove file from server once it is removed from dropzone.
            //function RemoveTaskAttachmentFromServer(filename) {
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
            //}

            // Once attachement is removed then remove it from viewstate as well to keep correct track of file upload.
            //function OnAttachmentRemoveSuccess(data) {
            //    var result = data.d;
            //    if (r - esult) {
            //        RemoveAttachmentFromViewState(result);
            //    }
            //}

            //// Once attachement is removed then remove it from viewstate as well to keep correct track of file upload.
            //function OnAttachmentRemoveError(data) {
            //    var result = data.d;
            //    if (result) {
            //        console.log(result);
            //    }
            //}

    </script>
</asp:Content>
