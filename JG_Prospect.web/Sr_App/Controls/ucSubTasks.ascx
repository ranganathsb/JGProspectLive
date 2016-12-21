﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucSubTasks.ascx.cs" Inherits="JG_Prospect.Sr_App.Controls.ucSubTasks" %>

<%@ Register TagPrefix="asp" Namespace="Saplin.Controls" Assembly="DropDownCheckBoxes" %>

<link rel="stylesheet" type="text/css" href="../css/lightslider.css">
<script type="text/javascript" src="../js/lightslider.js"></script>
<fieldset class="tasklistfieldset">
    <legend>Task List</legend>
    <asp:UpdatePanel ID="upSubTasks" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div id="divSubTaskGrid">
                <asp:GridView ID="gvSubTasks" runat="server" ShowHeaderWhenEmpty="true" AllowSorting="true" EmptyDataRowStyle-HorizontalAlign="Center"
                    HeaderStyle-BackColor="Black" HeaderStyle-ForeColor="White" BackColor="White" EmptyDataRowStyle-ForeColor="Black"
                    EmptyDataText="No sub task available!" CssClass="table" Width="100%" CellSpacing="0" CellPadding="0"
                    AutoGenerateColumns="False" EnableSorting="true" GridLines="Vertical" DataKeyNames="TaskId,InstallId"
                    OnRowDataBound="gvSubTasks_RowDataBound"
                    OnRowCommand="gvSubTasks_RowCommand"
                    OnSorting="gvSubTasks_Sorting">
                    <EmptyDataRowStyle ForeColor="White" HorizontalAlign="Center" />
                    <HeaderStyle CssClass="trHeader " />
                    <RowStyle CssClass="FirstRow" />
                    <AlternatingRowStyle CssClass="AlternateRow " />
                    <Columns>
                        <asp:TemplateField HeaderText="List ID" HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="60"
                            SortExpression="InstallId">
                            <ItemTemplate>
                                <asp:Literal ID="ltrlInstallId" runat="server" Text='<%# Eval("InstallId") %>' />
                                <h5>
                                    <asp:LinkButton ID="lbtnInstallId" CssClass="context-menu" data-highlighter='<%# Eval("TaskId")%>' ForeColor="Blue" runat="server" Text='<%# Eval("InstallId") %>' CommandName="edit-sub-task"
                                        CommandArgument='<%# Container.DataItemIndex  %>' /></h5>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Task Description" HeaderStyle-HorizontalAlign="Left" ItemStyle-VerticalAlign="Top" ItemStyle-HorizontalAlign="Left"
                            SortExpression="Description">
                            <ItemTemplate>
                                <div style="background-color: white; border-bottom: 1px solid silver; padding: 3px;">
                                    <div style="padding-bottom: 5px;">
                                        <h5>Title:&nbsp;<%# String.IsNullOrEmpty(Eval("Title").ToString())== true ? "N.A." : Eval("Title").ToString() %></h5>
                                    </div>
                                    <div style="padding-bottom: 5px;">
                                        <h5>Url:&nbsp;<a target="_blank" class="bluetext"
                                            href='<%# string.IsNullOrEmpty(Eval("Url").ToString()) == true ? 
                                                                        "javascript:void(0);" : 
                                                                        Eval("Url").ToString()%>'>
                                            <%# String.IsNullOrEmpty(Eval("Url").ToString())== true ? 
                                                                "N.A." : 
                                                                Eval("Url").ToString()%> 
                                        </a>
                                        </h5>
                                    </div>
                                    <div style="padding-bottom: 5px;">
                                        <h5>Description:&nbsp;</h5>
                                        <%# Eval("Description")%>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <%--<asp:TemplateField HeaderText="Task Details" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left" HeaderStyle-Width="105"
                            SortExpression="Status">
                            <ItemTemplate>
                                <div style="padding: 3px;">
                                    <table>
                                        <tr>
                                            <td class="noborder">
                                                <h5>Status</h5>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td class="noborder">
                                                <asp:DropDownList ID="ddlStatus" runat="server" AutoPostBack="true" OnSelectedIndexChanged="gvSubTasks_ddlStatus_SelectedIndexChanged" /></td>
                                        </tr>
                                    </table>
                                    <hr />
                                    <table>
                                        <tr>
                                            <td class="noborder">
                                                <h5>Priority</h5>
                                            </td>
                                            <td class="noborder">
                                                <h5>Type</h5>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="noborder">
                                                <asp:DropDownList ID="ddlTaskPriority" runat="server" AutoPostBack="true" OnSelectedIndexChanged="gvSubTasks_ddlTaskPriority_SelectedIndexChanged" /></td>
                                            <td class="noborder">
                                                <asp:Literal ID="ltrlTaskType" runat="server" Text="N.A." /></td>
                                        </tr>
                                    </table>
                                    <hr />
                                    <table>
                                        <tr>
                                            <td class="noborder" colspan="2">
                                                <h5>Estimated Hours</h5>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="noborder">ITLead
                                            </td>
                                            <td class="noborder">
                                                <%# this.IsAdminMode ? (String.IsNullOrEmpty(Eval("AdminOrITLeadEstimatedHours").ToString())== true? "N.A." : Eval("AdminOrITLeadEstimatedHours").ToString() +" Hour(s)" ): "" %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="noborder">User</td>
                                            <td class="noborder"><%# (String.IsNullOrEmpty(Eval("UserEstimatedHours").ToString())==true? "N.A." : Eval("UserEstimatedHours").ToString() + " Hour(s)") %></td>
                                        </tr>
                                    </table>
                                    <hr />
                                    <table>
                                        <tr>
                                            <td colspan="3" class="noborder">
                                                <h5>Freeze Task</h5>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="redtext haligncenter noborder">
                                                <b>Admin</b>
                                            </td>
                                            <td class="noborder">
                                                <b>Tech Lead</b>
                                            </td>
                                            <td class="bluetext haligncenter noborder">
                                                <b>User</b>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="haligncenter noborder">
                                                <asp:CheckBox ID="chkAdmin" runat="server" CssClass="fz fz-admin" ToolTip="Admin" /></td>
                                            <td class="haligncenter noborder">
                                                <asp:CheckBox ID="chkITLead" runat="server" CssClass="fz fz-techlead" ToolTip="IT Lead" /></td>
                                            <td class="haligncenter noborder">
                                                <asp:CheckBox ID="chkUser" runat="server" CssClass="fz fz-user" ToolTip="User" /></td>
                                        </tr>
                                        <tr style="display: none;">
                                            <td colspan="3">

                                                <asp:HiddenField ID="hdnTaskApprovalId" runat="server" Value='<%# Eval("TaskApprovalId") %>' />
                                                <asp:TextBox ID="txtEstimatedHours" runat="server" data-id="txtEstimatedHours" CssClass="textbox" Width="110"
                                                    placeholder="Estimate" Text='<%# Eval("TaskApprovalEstimatedHours") %>' />
                                                <asp:TextBox ID="txtPasswordToFreezeSubTask" runat="server" TextMode="Password" data-id="txtPasswordToFreezeSubTask"
                                                    AutoPostBack="true" CssClass="textbox" Width="110" OnTextChanged="gvSubTasks_txtPasswordToFreezeSubTask_TextChanged" />


                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3" class="noborder" align="center">
                                                <asp:LinkButton ID="lbtlFeedback" runat="server" Text="Comment" CommandName="sub-task-feedback"
                                                    CommandArgument='<%# Container.DataItemIndex  %>' /></td>
                                        </tr>
                                    </table>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>--%>
                        <%-- <asp:TemplateField HeaderText="Estimated hours" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="88">
                            <ItemTemplate>
                            </ItemTemplate>
                        </asp:TemplateField>--%>
                        <asp:TemplateField HeaderText="Assigned" HeaderStyle-Width="15%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <table>
                                    <tr>
                                        <td class="noborder">
                                            <h5>Priority</h5>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="noborder">
                                            <asp:DropDownList ID="ddlTaskPriority" runat="server" AutoPostBack="true" OnSelectedIndexChanged="gvSubTasks_ddlTaskPriority_SelectedIndexChanged" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="noborder">
                                            <h5>Assigned</h5>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="noborder">
                                            <asp:DropDownCheckBoxes ID="ddcbAssigned" runat="server" UseSelectAllNode="false"
                                                AutoPostBack="true" OnSelectedIndexChanged="gvSubTasks_ddcbAssigned_SelectedIndexChanged">
                                                <Style SelectBoxWidth="100" DropDownBoxBoxWidth="100" DropDownBoxBoxHeight="150" />
                                                <Texts SelectBoxCaption="--Open--" />
                                            </asp:DropDownCheckBoxes>
                                            <asp:Label ID="lblAssigned" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="noborder">
                                            <h5>Status</h5>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="noborder">
                                            <asp:DropDownList ID="ddlStatus" runat="server" AutoPostBack="true" OnSelectedIndexChanged="gvSubTasks_ddlStatus_SelectedIndexChanged" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="noborder">
                                            <h5>Type</h5>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="noborder">
                                            <asp:Literal ID="ltrlTaskType" runat="server" Text="N.A." /></td>
                                    </tr>

                                </table>
                                <table>
                                    <tr>
                                        <td class="noborder" colspan="2">
                                            <h5>Estimated Hours</h5>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="noborder" width="30%"><b>ITLead</b>
                                        </td>
                                        <td class="noborder">
                                            <%# this.IsAdminMode ? (String.IsNullOrEmpty(Eval("AdminOrITLeadEstimatedHours").ToString())== true? "N.A." : Eval("AdminOrITLeadEstimatedHours").ToString() +" Hour(s)" ): "" %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="noborder"><b>User</b></td>
                                        <td class="noborder"><%# (String.IsNullOrEmpty(Eval("UserEstimatedHours").ToString())==true? "N.A." : Eval("UserEstimatedHours").ToString() + " Hour(s)") %></td>
                                    </tr>
                                </table>

                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Attachments" HeaderStyle-Width="15%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left"
                            ItemStyle-VerticalAlign="Top" ItemStyle-Width="20%">
                            <ItemTemplate>
                                <asp:Repeater ID="rptAttachment" OnItemCommand="rptAttachment_ItemCommand" OnItemDataBound="rptAttachment_ItemDataBound" runat="server">
                                    <HeaderTemplate>
                                        <div class="lSSlideOuter sub-task-attachments" style="max-width: 250px;">
                                            <div class="lSSlideWrapper usingCss">
                                                <ul class="gallery list-unstyled cS-hidden sub-task-attachments-list">
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <li id="liImage" runat="server" class="noborder" style="overflow: inherit !important;">

                                            <img id="imgIcon" class="gallery-ele" style="width: 100% !important;" runat="server" src="javascript:void(0);" />
                                            <br />
                                            <h5>
                                                <asp:LinkButton ID="lbtnDownload" runat="server" ForeColor="Blue" CommandName="DownloadFile" /></h5>
                                            <h5>
                                                <asp:Literal ID="ltlUpdateTime" runat="server"></asp:Literal></h5>
                                            <h5>
                                                <asp:Literal ID="ltlCreatedUser" runat="server"></asp:Literal></h5>
                                            <div>
                                                <asp:LinkButton ID="lbtnDelete" runat="server" ClientIDMode="AutoID" ForeColor="Blue" Text="Delete"
                                                    CommandName="delete-attachment" />
                                            </div>
                                        </li>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        </ul>
                                            </div>
                                        </div>
                                    </FooterTemplate>
                                </asp:Repeater>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="88">
                            <ItemTemplate>
                                <table>
                                    <tr>
                                        <td colspan="3" class="noborder" align="center">
                                            <asp:LinkButton ID="lbtlFeedback" runat="server" Text="Comment" CommandName="sub-task-feedback"
                                                CommandArgument='<%# Container.DataItemIndex  %>' /></td>
                                    </tr>
                                    <tr>
                                        <td class="haligncenter noborder">
                                            <asp:CheckBox ID="chkAdmin" runat="server" CssClass="fz fz-admin" ToolTip="Admin" /></td>
                                        <td class="haligncenter noborder">
                                            <asp:CheckBox ID="chkITLead" runat="server" CssClass="fz fz-techlead" ToolTip="IT Lead" /></td>
                                        <td class="haligncenter noborder">
                                            <asp:CheckBox ID="chkUser" runat="server" CssClass="fz fz-user" ToolTip="User" /></td>
                                    </tr>
                                    <tr style="display: none;">
                                        <td colspan="3">
                                            <asp:HiddenField ID="hdnTaskApprovalId" runat="server" Value='<%# Eval("TaskApprovalId") %>' />
                                            <asp:TextBox ID="txtEstimatedHours" runat="server" data-id="txtEstimatedHours" CssClass="textbox" Width="110"
                                                placeholder="Estimate" Text='<%# Eval("TaskApprovalEstimatedHours") %>' />
                                            <asp:TextBox ID="txtPasswordToFreezeSubTask" runat="server" TextMode="Password" data-id="txtPasswordToFreezeSubTask"
                                                AutoPostBack="true" CssClass="textbox" Width="110" OnTextChanged="gvSubTasks_txtPasswordToFreezeSubTask_TextChanged" />
                                        </td>
                                    </tr>
                                </table>
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
            <div id="divAddSubTask" runat="server">
                <asp:LinkButton ID="lbtnAddNewSubTask" runat="server" Text="Add New Task" ValidationGroup="Submit" OnClick="lbtnAddNewSubTask_Click" />
                <br />
                <asp:ValidationSummary ID="vsSubTask" runat="server" ValidationGroup="vgSubTask" ShowSummary="False" ShowMessageBox="True" />
                <div id="divSubTask" runat="server" class="tasklistfieldset" style="display: none;">
                    <asp:HiddenField ID="hdnTaskApprovalId" runat="server" Value="0" />
                    <asp:HiddenField ID="hdnSubTaskId" runat="server" Value="0" />
                    <asp:HiddenField ID="hdnSubTaskIndex" runat="server" Value="-1" />
                    <table class="tablealign fullwidth">
                        <tr>
                            <td>ListID:
                                <asp:TextBox ID="txtTaskListID" runat="server" Enabled="false" />
                                &nbsp;
                                <small>
                                    <a href="javascript:void(0);" style="color: #06c;" onclick="copytoListID(this);">
                                        <asp:Literal ID="listIDOpt" runat="server" />
                                    </a>
                                </small>
                            </td>
                            <td>Type:
                                <asp:DropDownList ID="ddlTaskType" AutoPostBack="true" OnSelectedIndexChanged="ddlTaskType_SelectedIndexChanged" runat="server" />
                                &nbsp;&nbsp;Priority:
                                <asp:DropDownList ID="ddlSubTaskPriority" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>Title <span style="color: red;"></span>:
                                <br />
                                <asp:TextBox ID="txtSubTaskTitle" Text="" runat="server" Width="98%" CssClass="textbox" TextMode="MultiLine" />
                                <asp:RequiredFieldValidator ID="rfvTitle" runat="server" Display="None" ValidationGroup="vgSubTask"
                                    ControlToValidate="txtSubTaskTitle" ErrorMessage="Please enter Task Title." />
                            </td>
                            <td>Url <span style="color: red;"></span>:
                                <br />
                                <asp:TextBox ID="txtUrl" Text="" runat="server" Width="98%" CssClass="textbox" />
                                <asp:RequiredFieldValidator ID="rfvUrl" runat="server" Display="None" ValidationGroup="vgSubTask"
                                    ControlToValidate="txtUrl" ErrorMessage="Please enter Task Url." />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="upnlDesignation" runat="server" RenderMode="Inline">
                                    <ContentTemplate>
                                        Designation <span style="color: red;">*</span>:
                                        <asp:DropDownCheckBoxes ID="ddlUserDesignation" runat="server" UseSelectAllNode="false"
                                            AutoPostBack="true" OnSelectedIndexChanged="ddlUserDesignation_SelectedIndexChanged">
                                            <Style SelectBoxWidth="195" DropDownBoxBoxWidth="120" DropDownBoxBoxHeight="150" />
                                        </asp:DropDownCheckBoxes>
                                        <asp:CustomValidator ID="cvDesignations" runat="server" ValidationGroup="vgSubTask" ErrorMessage="Please Select Designation" Display="None"
                                            ClientValidationFunction="SubTasks_checkDesignations"></asp:CustomValidator>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">Attachment(s):
                                <div style="max-height: 300px; clear: both; background-color: white; overflow-y: auto; overflow-x: hidden;">
                                    <asp:UpdatePanel ID="upnlAttachments" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:Repeater ID="rptSubTaskAttachments" runat="server"
                                                OnItemDataBound="rptSubTaskAttachments_ItemDataBound"
                                                OnItemCommand="rptSubTaskAttachments_ItemCommand">
                                                <HeaderTemplate>
                                                    <ul style="width: 100%; list-style-type: none; margin: 0px; padding: 0px;">
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <li style="margin: 10px; text-align: center; float: left; width: 100px;">
                                                        <asp:LinkButton ID="lbtnDelete" runat="server" ClientIDMode="AutoID" ForeColor="Blue" Text="Delete" CommandArgument='<%#Eval("Id").ToString()+ "|" + Eval("attachment").ToString() %>' CommandName="delete-attachment" />
                                                        <br />
                                                        <img id="imgIcon" class="gallery-ele" runat="server" height="100" width="100" src="javascript:void(0);" />
                                                        <br />
                                                        <small>
                                                            <asp:LinkButton ID="lbtnDownload" runat="server" ForeColor="Blue" CommandName="download-attachment" />
                                                            <br />
                                                            <small><%# Convert.ToDateTime(Eval("UpdatedOn")).ToString("MM/dd/yyyy hh:mm tt") %></small>
                                                        </small>
                                                    </li>
                                                </ItemTemplate>
                                                <FooterTemplate>
                                                    </ul>
                                                                       
                                                </FooterTemplate>
                                            </asp:Repeater>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
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
                        <tr>
                            <td colspan="2">Estimated Hours:
                                <asp:TextBox ID="txtEstimatedHours" runat="server" CssClass="textbox" Width="110" placeholder="Estimate" />
                                <asp:RegularExpressionValidator ID="revEstimatedHours" runat="server" ControlToValidate="txtEstimatedHours" Display="None"
                                    ErrorMessage="Please enter decimal numbers for estimated hours of task." ValidationGroup="vgSubTask"
                                    ValidationExpression="(\d+\.\d{1,2})?\d*" />
                            </td>
                        </tr>
                        <tr id="trDateHours" runat="server" visible="false">
                            <td>Due Date:<asp:TextBox ID="txtSubTaskDueDate" runat="server" CssClass="textbox datepicker" />
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
                                        OnClientClick="javascript:return OnSaveSubTaskClick();" OnClick="btnSaveSubTask_Click" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:HiddenField ID="hdnAdminMode" runat="server" />
</fieldset>

<%--Popup Stars--%>
<div class="hide">

    <%--Sub Task Feedback Popup--%>
    <div id="divSubTaskFeedbackPopup" runat="server" title="Sub Task Feedback">
        <asp:UpdatePanel ID="upSubTaskFeedbackPopup" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <fieldset>
                    <legend>
                        <asp:Literal ID="ltrlSubTaskFeedbackTitle" runat="server" /></legend>
                    <%--<table cellspacing="3" cellpadding="3" width="100%">
                        <tr>
                            <td>
                                <table class="table" cellspacing="0" cellpadding="0" rules="cols" border="1"
                                    style="background-color: White; width: 100%; border-collapse: collapse;">
                                    <tbody>
                                        <tr class="trHeader " style="color: White; background-color: Black;">
                                            <th align="left" scope="col">Description</th>
                                            <th align="center" scope="col" style="width: 15%;">Attachments</th>
                                        </tr>
                                        <tr class="FirstRow">
                                            <td align="left">Feedback for sub task with install Id I.
                                            </td>
                                            <td>&nbsp;</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </table>--%>
                    <table id="tblAddEditSubTaskFeedback" runat="server" cellspacing="3" cellpadding="3" width="100%">
                        <tr>
                            <td colspan="2">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td width="90" align="right" valign="top">Description:
                            </td>
                            <td>
                                <asp:TextBox ID="txtSubtaskComment" runat="server" CssClass="textbox" TextMode="MultiLine" Rows="4" Width="90%" />
                                <asp:RequiredFieldValidator ID="rfvComment" ValidationGroup="comment"
                                    runat="server" ControlToValidate="txtSubtaskComment" ForeColor="Red" ErrorMessage="Please comment" Display="None" />
                                <asp:ValidationSummary ID="vsComment" runat="server" ValidationGroup="comment" ShowSummary="False" ShowMessageBox="True" />
                            </td>
                        </tr>
                        <tr>
                            <td align="right" valign="top">Files:
                            </td>
                            <td>
                                <input id="hdnSubTaskNoteAttachments" runat="server" type="hidden" />
                                <input id="hdnSubTaskNoteFileType" runat="server" type="hidden" />
                                <div id="divSubTaskNoteDropzone" runat="server" class="dropzone work-file-Note">
                                    <div class="fallback">
                                        <input name="file" type="file" multiple />
                                        <input type="submit" value="Upload" />
                                    </div>
                                </div>
                                <div id="divSubTaskNoteDropzonePreview" runat="server" class="dropzone-previews work-file-previews-note">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div class="btn_sec">
                                    <asp:Button ID="btnSaveSubTaskFeedback" runat="server" ValidationGroup="comment" OnClick="btnSaveSubTaskFeedback_Click" CssClass="ui-button" Text="Save" />
                                    <asp:Button ID="btnSaveCommentAttachment" runat="server" OnClick="btnSaveCommentAttachment_Click" Style="display: none;" Text="Save Attachement" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>



</div>


<%--Popup Ends--%>

<script type="text/javascript">
    Dropzone.autoDiscover = false;

    $(function () {
        ucSubTasks_Initialize();
    });

    var prmTaskGenerator = Sys.WebForms.PageRequestManager.getInstance();

    prmTaskGenerator.add_endRequest(function () {
        ucSubTasks_Initialize();
    });

    prmTaskGenerator.add_beginRequest(function () {
        DestroyGallery();
        DestroyDropzones();
        DestroyCKEditors();
    });

    function ucSubTasks_Initialize() {

        ApplySubtaskLinkContextMenu();
        //ApplyImageGallery();

        LoadImageGallery('.sub-task-attachments-list');

        var controlmode = $('#<%=hdnAdminMode.ClientID%>').val().toLowerCase();

        // alert(controlmode);

        if (controlmode == "true") {
            ucSubTasks_ApplyDropZone();
            SetCKEditor('<%=txtSubTaskDescription.ClientID%>');
            SetCKEditor('<%=txtSubTaskTitle.ClientID%>');
        }

    }

    function copytoListID(sender) {
        var strListID = $.trim($(sender).text());
        if (strListID.length > 0) {
            $('#<%= txtTaskListID.ClientID %>').val(strListID);
            ValidatorEnable(document.getElementById('<%=rfvTitle.ClientID%>'), true)
            ValidatorEnable(document.getElementById('<%=rfvUrl.ClientID%>'), true)
        }
    }

    function OnSaveSubTaskClick() {
        $('#<%=txtSubTaskDescription.ClientID%>').val(GetCKEditorContent('<%=txtSubTaskDescription.ClientID%>'));
        $('#<%=txtSubTaskTitle.ClientID%>').val(GetCKEditorContent('<%=txtSubTaskTitle.ClientID%>'));

        SetCKEditor('<%=txtSubTaskDescription.ClientID%>');
        SetCKEditor('<%=txtSubTaskTitle.ClientID%>');

        return Page_ClientValidate('vgSubTask')
    }

    var objSubTaskDropzone, objSubtaskNoteDropzone;

    function ucSubTasks_ApplyDropZone() {
        //remove already attached dropzone.
        if (objSubTaskDropzone) {
            objSubTaskDropzone.destroy();
            objSubTaskDropzone = null;
        }

        if ($("#<%=divSubTaskDropzone.ClientID%>").length > 0) {
            objSubTaskDropzone = new Dropzone("#<%=divSubTaskDropzone.ClientID%>", {
                maxFiles: 5,
                url: "taskattachmentupload.aspx",
                thumbnailWidth: 90,
                thumbnailHeight: 90,
                previewsContainer: 'div#<%=divSubTaskDropzonePreview.ClientID%>',
                init: function () {
                    this.on("maxfilesexceeded", function (data) {
                        alert('you are reached maximum attachment upload limit.');
                    });

                    // when file is uploaded successfully store its corresponding server side file name to preview element to remove later from server.
                    this.on("success", function (file, response) {
                        var filename = response.split("^");
                        $(file.previewTemplate).append('<span class="server_file">' + filename[0] + '</span>');

                        AddAttachmenttoViewState(filename[0] + '@' + file.name, '#<%= hdnAttachments.ClientID %>');
                    });
                }
            });
        }

        //Apply dropzone for comment section.
        if (objSubtaskNoteDropzone) {
            objSubtaskNoteDropzone.destroy();
            objSubTaskNoteDropzone = null;
        }
        objSubTaskNoteDropzone = GetWorkFileDropzone("#<%=divSubTaskNoteDropzone.ClientID%>", '#<%=divSubTaskNoteDropzonePreview.ClientID%>', '#<%= hdnSubTaskNoteAttachments.ClientID %>', '#<%=btnSaveCommentAttachment.ClientID%>');
    }

    function ucSubTasks_OnApprovalCheckBoxChanged(sender) {
        var sender = $(sender);
        if (sender.prop('checked')) {
            sender.closest('tr').next('tr').show();
        }
        else {
            sender.closest('tr').next('tr').hide();
        }
    }

    function ApplySubtaskLinkContextMenu() {

        $(".context-menu").bind("contextmenu", function () {
            var urltoCopy = updateQueryStringParameter(window.location.href, "hstid", $(this).attr('data-highlighter'));
            copyToClipboard(urltoCopy);
            return false;
        });

        if ($(".yellowthickborder").length > 0) {
            $('html, body').animate({
                scrollTop: $(".yellowthickborder").offset().top
            }, 2000);
        }

        $(".yellowthickborder").bind("click", function () {
            $(this).removeClass("yellowthickborder");
        });
    }

    // check if user has selected any designations or not.
    function SubTasks_checkDesignations(oSrc, args) {
        args.IsValid = ($("#<%= ddlUserDesignation.ClientID%> input:checked").length > 0);
    }

</script>
