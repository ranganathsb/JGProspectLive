﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucSubTasks.ascx.cs" Inherits="JG_Prospect.Sr_App.Controls.ucSubTasks" %>

<%@ Register TagPrefix="asp" Namespace="Saplin.Controls" Assembly="DropDownCheckBoxes" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<link rel="stylesheet" type="text/css" href="../css/lightslider.css">
<script type="text/javascript" src="../js/lightslider.js"></script>

<style type="text/css">
    .subtasklevel {
        border: 0px;
    }

    .installidright {
        text-align: right;
        width: 80px;
        display: block;
        padding-right: 5px;
    }

    .installidcenter {
        text-align: center;
        width: 80px;
        display: block;
        padding-right: 5px;
    }

    .installidleft {
        text-align: left;
        width: 80px;
        display: block;
    }

    .subtasklevelheader {
        border: none;
    }

    .taskdesc a {
        text-decoration: underline;
        color: blue;
    }

    .modalBackground {
        background-color: #333333;
        filter: alpha(opacity=70);
        opacity: 0.7;
        z-index: 100 !important;
    }
    /*.modalPopup { 
            background-color:#FFFFFF; 
            border-width:1px; 
            border-style:solid; 
            border-color:#CCCCCC; 
            padding:1px; 
            width:100%; 
            Height:450px; 
            
        }*/

    /*.lSGallery 
   {
       width:400px;
       background-color:aqua;
       overflow:hidden;
   }
    .lSGallery li
   {
       width:40px!important;
   }*/
    .form_panel_custom ul {
        margin: 0px !important;
    }

    .dropzonetbl td {
        border: none !important;
        border-right: none !important;
    }

    .sub-task-attachments-list {
        height: 270px !important;
    }
</style>

<fieldset class="tasklistfieldset">
    <legend>Task List</legend>
    <asp:UpdatePanel ID="upSubTasks" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div id="divSubTaskGrid">
                <div style="float: left; margin-top: 15px;">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="textbox" placeholder="search users" MaxLength="15" />
                    <asp:Button ID="btnSearch" runat="server" Text="Search" Style="display: none;" class="btnSearc" OnClick="btnSearch_Click" />

                    Number of Records: 
                                <asp:DropDownList ID="drpPageSize" runat="server" AutoPostBack="true"
                                    OnSelectedIndexChanged="drpPageSize_SelectedIndexChanged">
                                    <asp:ListItem Text="5" Value="5" />
                                    <asp:ListItem Text="10" Value="10" />
                                    <asp:ListItem Text="15" Value="15" />
                                    <asp:ListItem Text="20" Value="20" />
                                    <asp:ListItem Text="25" Value="25" />
                                </asp:DropDownList>
                </div>

                <asp:GridView ID="gvSubTasks" runat="server" ShowHeaderWhenEmpty="true" AllowSorting="true" EmptyDataRowStyle-HorizontalAlign="Center"
                    HeaderStyle-ForeColor="White" BackColor="White" EmptyDataRowStyle-ForeColor="Black"
                    EmptyDataText="No sub task available!" CssClass="table edit-subtask" Width="100%" CellSpacing="0" CellPadding="0"
                    AutoGenerateColumns="False" EnableSorting="true" GridLines="Vertical" DataKeyNames="TaskId,InstallId"
                    OnRowDataBound="gvSubTasks_RowDataBound" AllowPaging="true" OnPreRender="gvSubTasks_PreRender"
                    OnPageIndexChanging="OnPagingGvSubTasks" AllowCustomPaging="true"
                    OnRowCommand="gvSubTasks_RowCommand" PageSize="5"
                    OnSorting="gvSubTasks_Sorting">
                    <EmptyDataRowStyle ForeColor="White" HorizontalAlign="Center" />
                    <HeaderStyle CssClass="trHeader " />
                    <RowStyle CssClass="FirstRow" />
                    <PagerSettings Mode="NumericFirstLast" Visible="true" NextPageText="Next" PreviousPageText="Previous" Position="Bottom" />
                    <PagerStyle HorizontalAlign="Left" CssClass="pagination-ys" />
                    <AlternatingRowStyle CssClass="AlternateRow " />
                    <Columns>
                        <asp:TemplateField HeaderText="Task Details" HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="60"
                            SortExpression="InstallId">
                            <HeaderTemplate>
                                <span style="float: left;">Action-ID#</span>
                                <a href="#" style="color: white;">Task Details</a>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:Literal ID="ltrlInstallId" Visible="false" runat="server" Text='<%# Eval("InstallId") %>' />
                                <asp:Label ID="lblTaskId" Visible="false" runat="server" Text='<%# Eval("TaskId")%>'></asp:Label>
                                <asp:Label ID="lblInstallId" Text='<%# Eval("InstallId") %>' runat="server" Visible="false" />
                                <!-- Sub-Sub Task Grid Starts -->

                                <!-- Sub-Sub Task Grid Starts -->
                                <asp:GridView OnRowDataBound="gvSubTasksLevels_RowDataBound"
                                    ID="gvSubTasksLevels" runat="server" AutoGenerateColumns="false"
                                    CssClass="subtasklevel" BorderColor="Transparent" Width="500px" BorderStyle="None">
                                    <Columns>
                                        <asp:TemplateField HeaderStyle-CssClass="subtasklevelheader" HeaderText="List ID#" HeaderStyle-HorizontalAlign="Left" ItemStyle-VerticalAlign="Top"
                                            HeaderStyle-Width="80"
                                            SortExpression="InstallId">
                                            <ItemTemplate>
                                                <asp:HiddenField ID="hdTitle" runat="server" Value='<%# Eval("Title")%>'></asp:HiddenField>
                                                <asp:HiddenField ID="hdURL" runat="server" Value='<%# Eval("URL")%>'></asp:HiddenField>
                                                <asp:HiddenField ID="hdTaskLevel" runat="server" Value='<%# Eval("TaskLevel")%>'></asp:HiddenField>
                                                <asp:HiddenField ID="hdTaskId" runat="server" Value='<%# Eval("TaskId")%>'></asp:HiddenField>
                                                <h5>
                                                    <input type="checkbox" name="bulkaction" />
                                                    <asp:LinkButton ID="lbtnInstallId" Style="display: inline;" data-highlighter='<%# Eval("TaskId")%>' CssClass="context-menu"
                                                        ForeColor="Blue" runat="server" Text='<%# Eval("InstallId") %>' OnClick="EditSubTask_Click" />
                                                    <%--  <asp:LinkButton ID="lbtnInstallIdRemove" data-highlighter='<%# Eval("TaskId")%>' CssClass="context-menu"onmousedown="ClipBoard('Hi');"OnClientClick="ClipBoard('Hi');"
                                                      '<%# string.Concat(Eval("InstallId"), " ", Eval("Title"))%>'oncontextmenu="ShowMenu('contextMenu',event);""javascript:return ClipBoard('Hi');"
                                                        ForeColor="Blue" runat="server" Text='<%# Eval("InstallId") %>' OnClick="RemoveClick" />--%>
                                                    <asp:LinkButton ID="lbtnInstallIdRemove" data-highlighter='<%# string.Format( Eval("ParentTaskInstallId") + " - " + Eval("InstallId") + " - " + Eval("Title") + "?" + Eval("TaskId"))%>'
                                                        CssClass="context-menu"
                                                        ForeColor="Blue" runat="server" Text='<%# Eval("InstallId") %>' OnClick="RemoveClick" />

                                                    <%--<a id="lnkLink" style="display: none;">'<%# string.Format( Eval("ParentTaskInstallId") + " - " + Eval("InstallId") + " : " + Eval("Title"))%>'</a>
                                                    <a id="lnkTaskId" style="display: none;">'<%# Eval("TaskId")%>'</a>
                                                    <a id="lnkParentTaskInstallId" style="display: none;">'<%# Eval("ParentTaskInstallId")%>'</a>
                                                    <a id="lnkTaskName" style="display: none;">'<%# string.Format(Eval("InstallId").ToString() + "-" + Eval("Title").ToString()) %>'</a>--%>
                                                    <div style="display: none;" id="contextMenu" onmousedown="HideMenu('contextMenu');"
                                                        onmouseup="HideMenu('contextMenu');" class="detailItem" oncontextmenu="ShowMenu('contextMenu',event);">
                                                        <table border="0" cellpadding="0" cellspacing="0"
                                                            style="border: thin solid #808080; cursor: default;" width="80px"
                                                            bgcolor="White">
                                                            <tr>
                                                                <td>
                                                                    <%-- <asp:LinkButton ID="lnkCopyLink" runat="server" class="ContextItem"onmousedown="ClipBoard();"
                                                                        onmousedown='<%# String.Format("ClipBoard(\"{0}\");" , Eval("InstallId").ToString() + "-" + Eval("Title").ToString()) %>'
                                                                        onmouseout="HideMenu('contextMenu');">Copy Link</asp:LinkButton>--%>
                                                                    <asp:LinkButton ID="lnkCopyLink" runat="server" onmousedown="ClipBoard();"
                                                                        data-highlighter='<%# string.Format( Eval("ParentTaskInstallId") + " - " + Eval("InstallId") + " : " + Eval("Title"))%>'
                                                                        onmouseout="HideMenu('contextMenu');">Copy Link</asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </h5>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderStyle-CssClass="subtasklevelheader" HeaderText="Task Description" HeaderStyle-HorizontalAlign="Left" ItemStyle-VerticalAlign="Top" ItemStyle-HorizontalAlign="Left"
                                            SortExpression="Description">
                                            <ItemTemplate>
                                                <div style="background-color: white; border-bottom: 1px solid silver; padding: 3px; max-width: 400px;">
                                                    <div id="dvDesc" class="taskdesc" runat="server" style="padding-bottom: 5px; width: 98%;">

                                                        <%# Server.HtmlDecode(Eval("Description").ToString())%>
                                                    </div>

                                                </div>
                                                <asp:LinkButton ID="lnkAddMoreSubTask" Style="display: inline;" runat="server"
                                                    OnClick="lnkAddMoreSubTask_Click">+</asp:LinkButton>
                                                &nbsp;<a href="#">Comment</a>
                                            </ItemTemplate>
                                        </asp:TemplateField>


                                    </Columns>
                                </asp:GridView>
                                <!-- Sub-Sub Task Grid Ends -->
                                <!-- Freezingn Task Part Starts -->

                                <table style="float: left; margin-top: -80px;">
                                    <tr>
                                        <td colspan="3" class="noborder" align="center">
                                            <asp:LinkButton ID="lbtlFeedback" runat="server" Visible="false" Text="Comment" CommandName="sub-task-feedback"
                                                CommandArgument='<%# Container.DataItemIndex  %>' /></td>
                                    </tr>
                                    <tr>
                                        <td class="haligncenter noborder">
                                            <asp:CheckBox ID="chkAdmin" runat="server" CssClass="fz fz-admin" ToolTip="Admin" />
                                            <div id="divAdmin" runat="server" visible="false">
                                                <asp:HyperLink ForeColor="Red" runat="server" NavigateUrl='<%# Eval("AdminUserId", Page.ResolveUrl("CreateSalesUser.aspx?id={0}")) %>'>
                                                    <%# 
                                                        string.Concat(
                                                                        string.IsNullOrEmpty(Eval("AdminUserInstallId").ToString())?
                                                                            Eval("AdminUserId") : 
                                                                            Eval("AdminUserInstallId"),
                                                                        "<br/>",
                                                                        string.IsNullOrEmpty(Eval("AdminUserFirstName").ToString())== true? 
                                                                            Eval("AdminUserFirstName").ToString() : 
                                                                            Eval("AdminUserFirstName").ToString(),
                                                                        " ", 
                                                                        Eval("AdminUserLastName").ToString()
                                                                    )
                                                    %>
                                                </asp:HyperLink>
                                                <span><%#String.Format("{0:M/d/yyyy}", Eval("AdminStatusUpdated"))%></span>&nbsp<span style="color: red"><%#String.Format("{0:hh:mm:ss tt}", Eval("AdminStatusUpdated"))%></span>&nbsp<span>(EST)</span>
                                            </div>
                                        </td>
                                        <td class="haligncenter noborder">
                                            <asp:CheckBox ID="chkITLead" runat="server" CssClass="fz fz-techlead" ToolTip="IT Lead" />
                                            <div id="divITLead" runat="server" visible="false">
                                                <asp:HyperLink ForeColor="Black" runat="server" NavigateUrl='<%# Eval("TechLeadUserId", Page.ResolveUrl("CreateSalesUser.aspx?id={0}")) %>'>
                                                    <%# 
                                                        string.Concat(
                                                                        string.IsNullOrEmpty(Eval("TechLeadUserInstallId").ToString())?
                                                                            Eval("TechLeadUserId") : 
                                                                            Eval("TechLeadUserInstallId"),
                                                                        "<br/>",
                                                                        string.IsNullOrEmpty(Eval("TechLeadUserFirstName").ToString())== true? 
                                                                            Eval("TechLeadUserFirstName").ToString() : 
                                                                            Eval("TechLeadUserFirstName").ToString(),
                                                                        " ", 
                                                                        Eval("TechLeadUserLastName").ToString()
                                                                    )
                                                    %>
                                                </asp:HyperLink>
                                                <span><%#String.Format("{0:M/d/yyyy}", Eval("TechLeadStatusUpdated"))%></span>&nbsp<span style="color: red"><%#String.Format("{0:hh:mm:ss tt}", Eval("TechLeadStatusUpdated"))%></span>&nbsp<span>(EST)</span>
                                            </div>
                                        </td>
                                        <td class="haligncenter noborder">
                                            <asp:CheckBox ID="chkUser" runat="server" CssClass="fz fz-user" ToolTip="User" />
                                            <div id="divUser" runat="server" visible="false">
                                                <asp:HyperLink ForeColor="Blue" runat="server" NavigateUrl='<%# Eval("TechLeadUserId", Page.ResolveUrl("CreateSalesUser.aspx?id={0}")) %>'>
                                                    <%# 
                                                        string.Concat(
                                                                        string.IsNullOrEmpty(Eval("OtherUserInstallId").ToString())?
                                                                            Eval("OtherUserId") : 
                                                                            Eval("OtherUserInstallId"),
                                                                        "<br/>",
                                                                        string.IsNullOrEmpty(Eval("OtherUserFirstName").ToString())== true? 
                                                                            Eval("OtherUserFirstName").ToString() : 
                                                                            Eval("OtherUserFirstName").ToString(),
                                                                        " ", 
                                                                        Eval("OtherUserLastName").ToString()
                                                                    )
                                                    %>
                                                </asp:HyperLink>
                                                <span><%#String.Format("{0:M/d/yyyy}", Eval("OtherUserStatusUpdated"))%></span>&nbsp<span style="color: red"><%#String.Format("{0:hh:mm:ss tt}", Eval("OtherUserStatusUpdated"))%></span>&nbsp<span>(EST)</span>
                                            </div>
                                        </td>
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

                                <!-- Freezingn Task Part Starts -->
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" Width="60px" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Assigned" HeaderStyle-Width="15%" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="Left" ItemStyle-VerticalAlign="Top">
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
                                            <%--<asp:DropDownCheckBoxes ID="ddcbAssigned" runat="server" UseSelectAllNode="false"
                                                AutoPostBack="true" OnSelectedIndexChanged="gvSubTasks_ddcbAssigned_SelectedIndexChanged">
                                                <Style SelectBoxWidth="100" DropDownBoxBoxWidth="100" DropDownBoxBoxHeight="150" />
                                                <Texts SelectBoxCaption="--Open--" />
                                            </asp:DropDownCheckBoxes>--%>
                                            <asp:ListBox ID="ddcbAssigned" runat="server" Width="150" SelectionMode="Multiple"
                                                CssClass="chosen-select" data-placeholder="Select"
                                                AutoPostBack="true" OnSelectedIndexChanged="gvSubTasks_ddcbAssigned_SelectedIndexChanged"></asp:ListBox>
                                            <asp:HiddenField ID="hdnActiveUserIds" runat="server" />
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
                                    <tr style="display: none;">
                                        <td class="noborder">
                                            <h5>Type</h5>
                                        </td>
                                    </tr>
                                    <tr style="display: none;">
                                        <td class="noborder">
                                            <asp:Literal ID="ltrlTaskType" runat="server" Text="N.A." /></td>
                                    </tr>

                                </table>
                                <table style="display: none;">
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
                            <HeaderStyle HorizontalAlign="Center" Width="15%" />
                            <ItemStyle HorizontalAlign="Left" VerticalAlign="Top" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Attachments, IMGs, Docs, Videos & Recordings" HeaderStyle-Width="15%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left"
                            ItemStyle-VerticalAlign="Top" ItemStyle-Width="30%">
                            <ItemTemplate>

                                <table border="0" class="dropzonetbl" style="width: 100%;">
                                    <tr>
                                        <td>
                                            <asp:UpdatePanel ID="upAttachmentsData1" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <input id="hdnAttachments1" runat="server" type="hidden" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                            <div id="divSubTaskDropzone1" style="width: 250px;" onclick="javascript:SetHiddenTaskId('<%# Eval("TaskId")%>');"
                                                class="dropzone dropzonetask dropzonJgStyle">
                                                <div class="fallback">
                                                    <input name="file" type="file" multiple />
                                                    <%-- <input type="submit" value="Upload"     />--%>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div id="divSubTaskDropzonePreview1" runat="server" class="dropzone-previews">
                                            </div>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>

                                            <table border="0" class="dropzonetbl" style="width: 100%;">
                                                <tr>
                                                    <td style="width: 40%;">
                                                        <asp:CheckBox ID="chkUiRequested" runat="server" Text="Ui Requested?"
                                                            Checked='<%# Convert.ToBoolean(Eval("IsUiRequested")) %>'
                                                            AutoPostBack="true" OnCheckedChanged="gvSubTasks_chkUiRequested_CheckedChanged" />
                                                    </td>
                                                    <td>
                                                        <asp:Repeater ID="rptAttachment" OnItemCommand="rptAttachment_ItemCommand" OnItemDataBound="rptAttachment_ItemDataBound" runat="server">
                                                            <HeaderTemplate>
                                                                <div class="lSSlideOuter sub-task-attachments" style="max-width: 250px;">

                                                                    <div class="lSSlideWrapper usingCss">
                                                                        <ul class="gallery list-unstyled sub-task-attachments-list">
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <li id="liImage" runat="server" class="noborder" style="overflow: inherit !important; width: 247px; margin-right: 0px;">
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
                                                                    <br />
                                                                    <img id="imgIcon" class="gallery-ele" style="width: 100% !important;" runat="server" src="javascript:void(0);" />


                                                                </li>
                                                            </ItemTemplate>
                                                            <FooterTemplate>
                                                                </ul>
                                                                        </div>
                                        
                                                                    </div>
                                                            </FooterTemplate>
                                                        </asp:Repeater>

                                                        <img id="defaultimgIcon" class="gallery-ele" width="247" height="185" runat="server" src="javascript:void(0);" />

                                                    </td>

                                                </tr>
                                            </table>
                                        </td>

                                    </tr>

                                </table>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" Width="15%" />
                            <ItemStyle HorizontalAlign="Left" VerticalAlign="Top" Width="30%" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="88">
                            <ItemTemplate>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" Width="88px" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

                <asp:Button ID="btnSaveGridAttachment" runat="server"
                    OnClick="btnSaveGridAttachment_Click" Style="display: none;" Text="Save Attachement" />
                <asp:HiddenField ID="hdDropZoneTaskId" runat="server" />
            </div>
            <asp:HiddenField ID="hdnCurrentEditingRow" runat="server" />
            <asp:LinkButton ID="lnkFake" runat="server"></asp:LinkButton>
            <%-- <cc1:ModalPopupExtender ID="mpSubTask" runat="server" PopupControlID="pnlCalendar" TargetControlID="lnkFake"
                    BackgroundCssClass="modalBackground">
                    </cc1:ModalPopupExtender>--%>

            <div id="pnlCalendar" runat="server" align="center" class="tasklistfieldset" style="display: none;">
                <table border="1" cellspacing="5" cellpadding="5" width="90%">
                    <tr>
                        <td>ListID:
                            <asp:TextBox ID="txtInstallId" runat="server"></asp:TextBox>
                        </td>

                        <td>Sub Title <span style="color: red;">*</span>:
                            <asp:TextBox ID="txtSubSubTitle" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ValidationGroup="SubmitSubTask"
                                runat="server" ControlToValidate="txtSubSubTitle" ForeColor="Red"
                                ErrorMessage="Please Enter Task Title" Display="None"> </asp:RequiredFieldValidator>
                        </td>

                        <td>Priority <span style="color: red;">*</span>:
                            <asp:DropDownList ID="drpSubTaskPriority" runat="server" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" Display="None" ValidationGroup="SubmitSubTask"
                                ControlToValidate="drpSubTaskPriority" ErrorMessage="Please enter Task Priority." />
                        </td>

                        <td>Type <span style="color: red;">*</span>: 
                            <asp:DropDownList ID="drpSubTaskType" runat="server" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" Display="None" ValidationGroup="SubmitSubTask"
                                ControlToValidate="drpSubTaskType" ErrorMessage="Please enter Task Type." />
                        </td>
                    </tr>
                    <tr>
                        <td>Task Description <span style="color: red;">*</span>:
                                                <br />
                            <asp:TextBox ID="txtTaskDesc" runat="server" CssClass="textbox" TextMode="MultiLine" Rows="5" Width="98%" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ValidationGroup="SubmitSubTask"
                                runat="server" ControlToValidate="txtTaskDesc" ForeColor="Red"
                                ErrorMessage="Please Enter Task Description" Display="None"> </asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:HiddenField ID="txtMode" runat="server" />
                            <asp:HiddenField ID="hdParentTaskId" runat="server" />
                            <asp:HiddenField ID="hdMainParentId" runat="server" />
                            <asp:HiddenField ID="hdTaskLvl" runat="server" />
                            <asp:HiddenField ID="hdTaskId" runat="server" />
                            <div class="btn_sec">
                                <asp:Button ID="btnAddMoreSubtask" runat="server"
                                    TabIndex="5" Text="Submit" CssClass="ui-button"
                                    OnClick="btnAddMoreSubtask_Click" ValidationGroup="SubmitSubTask" />
                            </div>
                            <%-- <asp:Button ID="btnCalClose" runat="server" Height="30px" Width="70px" TabIndex="6"
                                                     OnClick="btnCalClose_Click" Text="Close" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" />--%>
                        </td>
                    </tr>
                </table>

            </div>


        </ContentTemplate>
    </asp:UpdatePanel>


    <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="SubmitSubTask" ShowSummary="False" ShowMessageBox="True" />

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
                            <td>Type <span style="color: red;">*</span>:
                                <asp:DropDownList ID="ddlTaskType" AutoPostBack="true" OnSelectedIndexChanged="ddlTaskType_SelectedIndexChanged" runat="server" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Display="None" ValidationGroup="vgSubTask"
                                    ControlToValidate="ddlTaskType" ErrorMessage="Please enter Task Type." />
                                &nbsp;&nbsp;Priority <span style="color: red;">*</span>:
                                <asp:DropDownList ID="ddlSubTaskPriority" runat="server" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" Display="None" ValidationGroup="vgSubTask"
                                    ControlToValidate="ddlSubTaskPriority" ErrorMessage="Please enter Task Priority." />
                            </td>
                        </tr>
                        <tr>
                            <td>Title <span style="color: red;">*</span>:
                                <br />
                                <asp:TextBox ID="txtSubTaskTitle" Text="" runat="server" Width="98%" CssClass="textbox" TextMode="SingleLine" />
                                <asp:RequiredFieldValidator ID="rfvTitle" runat="server" Display="None" ValidationGroup="vgSubTask"
                                    ControlToValidate="txtSubTaskTitle" ErrorMessage="Please enter Task Title." />
                            </td>
                            <td>Url <span style="color: red;">*</span>:
                                <br />
                                <asp:TextBox ID="txtUrl" Text="" runat="server" Width="98%" CssClass="textbox" />
                                <asp:RequiredFieldValidator ID="rfvUrl" runat="server" Display="None" ValidationGroup="vgSubTask"
                                    ControlToValidate="txtUrl" ErrorMessage="Please enter Task Url." />
                            </td>
                        </tr>
                        <tr runat="server" visible="false">
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
                                <asp:UpdatePanel ID="upAttachmentsData" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <input id="hdnAttachments" runat="server" type="hidden" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
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
                                <asp:Button ID="btnSaveSubTaskAttachment" runat="server" OnClick="btnSaveSubTaskAttachment_Click" Style="display: none;" Text="Save Attachement" />
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
    <asp:HiddenField ID="hdnParentTaskInstallId" runat="server" />
</div>


<%--Popup Ends--%>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/chosen.jquery.js")%>"></script>


<script type="text/javascript">


    Dropzone.autoDiscover = false;

    $(function () {
        ucSubTasks_Initialize();

    });

    var prmTaskGenerator = Sys.WebForms.PageRequestManager.getInstance();

    prmTaskGenerator.add_endRequest(function () {
        console.log('end req.');
        ucSubTasks_Initialize();

        SetUserAutoSuggestion();
        SetUserAutoSuggestionUI();
    });

    prmTaskGenerator.add_beginRequest(function () {
        console.log('begin req.');
        DestroyGallery();
        DestroyDropzones();
        //DestroyCKEditors();
    });


    $(document).ready(function () {
        SetUserAutoSuggestion();
        SetUserAutoSuggestionUI();
    });




    function SetUserAutoSuggestion() {

        $("#<%=txtSearch.ClientID%>").catcomplete({
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
                        $("#<%=txtSearch.ClientID%>").removeClass("ui-autocomplete-loading");
                    }
                });
            },
            minLength: 2,
            select: function (event, ui) {
                $("#<%=btnSearch.ClientID%>").val(ui.item.value);
                //TriggerSearch();
                $('#<%=btnSearch.ClientID%>').click();
            }
        });
    }

    function SetUserAutoSuggestionUI() {

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

    function ucSubTasks_Initialize() {

        ChosenDropDown();

        ApplySubtaskLinkContextMenu();
        //ApplyImageGallery();

        LoadImageGallery('.sub-task-attachments-list');

        //----------- start DP -----
        GridDropZone();
        //----------- end DP -----

        var controlmode = $('#<%=hdnAdminMode.ClientID%>').val().toLowerCase();

        if (controlmode == "true") {
            ucSubTasks_ApplyDropZone();
            SetCKEditor('<%=txtSubTaskDescription.ClientID%>', txtSubTaskDescription_Blur);
            UpdateTaskDescBeforeSubmit('<%=txtSubTaskDescription.ClientID%>', '#<%=btnSaveSubTask.ClientID%>');


            SetCKEditor('<%=txtTaskDesc.ClientID%>', txtTaskDesc_Blur);
            UpdateTaskDescBeforeSubmit('<%=txtTaskDesc.ClientID%>', '#<%=btnAddMoreSubtask.ClientID%>');


            $('#<%=txtInstallId.ClientID%>').bind('keypress', function (e) {
                return false;
            });

            $('#<%=txtInstallId.ClientID%>').bind('keydown', function (e) {
                if (e.keyCode === 8 || e.which === 8) {
                    return false;
                }
            });

        }
    }

    function txtSubTaskDescription_Blur(editor) {
        if ($('#<%=hdnSubTaskId.ClientID%>').val() != '0') {
            if (Page_ClientValidate('vgSubTask') && confirm('Do you wish to save description?')) {
                $('#<%=btnSaveSubTask.ClientID%>').click();
            }
        }
    }

    function OnSaveSubTaskClick() {
        return Page_ClientValidate('vgSubTask');
    }

    function copytoListID(sender) {
        var strListID = $.trim($(sender).text());
        if (strListID.length > 0) {
            $('#<%= txtTaskListID.ClientID %>').val(strListID);
            ValidatorEnable(document.getElementById('<%=rfvTitle.ClientID%>'), true)
            ValidatorEnable(document.getElementById('<%=rfvUrl.ClientID%>'), true)
        }
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

                        if ($('#<%=btnSaveSubTaskAttachment.ClientID%>').length > 0) {
                            // saves attachment.
                            $('#<%=btnSaveSubTaskAttachment.ClientID%>').click();
                            //this.removeFile(file);
                        }
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

    var CopyLink = "";

    function ApplySubtaskLinkContextMenu() {
        $(".context-menu").bind("contextmenu", function () {

            //var urltoCopy = updateQueryStringParameter(window.location.href, "hstid", $(this).attr('data-highlighter'));
            //  copyToClipboard($(this).attr('data-highlighter'));
            //alert($(this).attr('data-highlighter'));
            event.preventDefault();

            ShowMenu('contextMenu', event);

            var linkText = $(this).attr('data-highlighter').split("?");
            
            CopyLink = linkText[0] + " : " + window.location.href.split("=")[0] + "=" + linkText[1];

            //alert(CopyLink);

            //alert(window.clipboardData.getData('Text'));
            //if (clipboardData) {
            //    //alert(window.clipboardData.getData('Text'));
            //    window.clipboardData.clearData('Text');
            //    //alert(window.clipboardData.getData('Text'));
            //}
            //ClipBoard($(this).attr('data-highlighter'));
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

    /////////////////////

    //window.addEventListener('copy', function (evt) {
    //    alert("hello");
    //    console.log(evt.clipboardData.getData('text/plain'));
    //    alert(evt.clipboardData.getData('text/plain'));
    //});

    //var isclicked = 0;
    // To copy Text Ctrl + C
    function ClipBoard() {

        // For Chrome
        var input = document.createElement('textarea');
        document.body.appendChild(input);
        input.value = CopyLink;
        //input.focus();
        input.select();
        document.execCommand('Copy');
        input.remove();

        // For IE
        clipboardData.setData("Text", CopyLink);


        //alert(clipboardData.getData("text"));

        //alert(isclicked);

        //isclicked = 1;

        //alert("Get" + window.clipboardData.getData('Text'));

        //alert("set " + CopyLink);
        //$(".csslnkCopyLink").bind("lnkCopyLink", function () {

        //alert("hiiii");
        //alert($(this).attr('data-highlighter'));

        //document.getElementById('lnkLink').href = window.location.href.split("=")[0] + "=" + document.getElementById('lnkTaskId').text.replace("'", "").replace("'", "");

        //alert(document.getElementById('lnkLink').text);
        //alert(document.getElementById('lnkLink').href);

        //window.clipboardData.setData("Text", lnkLink.text + " : " + lnkLink.href);
        // return false;
        //});
        //alert($(this).attr('data-highlighter'));
        //var a = "<a href='www.google.com'>" + Txt + "</a>";
        //var temp = document.createElement('div');
        //temp.innerHTML = a;
        //var htmlObject = temp.firstChild;
        //alert(Txt);

        //window.clipboardData.setData("Text", Txt);
        //alert(a);//<button onclick="ClipBoard('')";>Copy to Clipboard</button>
        //alert(temp);
        //alert(htmlObject);
        //alert(htmlObject.find("#box").html());

        //var str = Txt;
        //var result = str.link("https://www.google.com");
        //document.getElementById("demo").innerHTML = result;ltrlInstallId
        //var a = document.getElementById("demo");
        //a.setAttribute("href", "https://www.google.com");
        //alert("Text: " + Txt);

        //var h = document.getElementById('lnkParentTaskInstallId').text.replace("'", "").replace("'", "");
        //$(this).getElementById('lnkLink').href = window.location.href.split("=")[0] + "=" + $(this).getElementById('lnkTaskId').text.replace("'", "").replace("'", "");
        //window.clipboardData.setData("Text", $(this).getElementById('lnkLink').text + " : " + $(this).getElementById('lnkLink').href);
        //var contents = $('#lnkLink')[0].id;
        //alert(contents);
        //alert(taskId);
        //document.getElementById('lnkLink').href = taskId;
        //alert(h);
        //alert(document.getElementById('lnkTaskName').text);
        //document.getElementById('lnkLink').text = h + " - " + document.getElementById('lnkTaskName').text;

        ////alert("hi");
        ////alert(document.getElementById('lnkLink').text);
        ////lnkLink.href = window.location.href.split("=")[0] + "=" + document.getElementById('lnkTaskId').text.replace("'", "").replace("'", "");

        ////alert(lnkLink.text);
        ////alert(lnkLink.href);

        ////window.clipboardData.setData("Text", lnkLink.text + " : " + lnkLink.href);
        //////////document.getElementById('lnkLink').href = window.location.href.split("=")[0] + "=" + document.getElementById('lnkTaskId').text.replace("'", "").replace("'", "");
        //"=" + document.getElementById('lnkTaskId').text.replace("'", "").replace("'", "");
        //////alert(document.getElementById('lnkLink').href);
        //////alert(document.getElementById('lnkLink').text);
        //////window.clipboardData.clearData('Text');
        //////window.clipboardData.setData("Text", document.getElementById('lnkLink').text + " : " + document.getElementById('lnkLink').href);
        //alert(window.clipboardData.getData('Text'));

        //e.preventDefault();
        //window.clipboardData.setData("Text/uri-list", document.getElementById("demo").innerHTML);
        //window.clipboardData.getData("application/javascript");
        //var selectedHtml = window.clipboardData.getData('text/html');
        //alert(selectedHtml);
        //pasteClipboardData(selectedHtml);
        //e.clipboardData.setData("Text", selectedHtml);

        //HideMenu('contextMenu');
    }

    function ShowMenu(control, e) {
        var posx = e.clientX + window.pageXOffset + 'px'; //Left Position of Mouse Pointer
        var posy = e.clientY + window.pageYOffset + 'px'; //Top Position of Mouse Pointer
        document.getElementById(control).style.position = 'absolute';
        document.getElementById(control).style.display = 'inline';
        document.getElementById(control).style.left = posx;
        document.getElementById(control).style.top = posy;
    }
    function HideMenu(control) {

        document.getElementById(control).style.display = 'none';
    }

    ////////////////////
    // check if user has selected any designations or not.
    function SubTasks_checkDesignations(oSrc, args) {
        args.IsValid = ($("#<%= ddlUserDesignation.ClientID%> input:checked").length > 0);
    }


    //  Created By : Yogesh K
    // To updat element underlying CKEditor before work submited to server.
    function UpdateTaskDescBeforeSubmit(CKEditorId, ButtonId) {
        $(ButtonId).bind('click', function () {
            var editor = CKEDITOR.instances[CKEditorId];
            console.log(editor);
            if (editor) {
                editor.updateElement();
            }
        });
    }


    //----------- Start DP ---------

    function SetHiddenTaskId(vId) {
        $('#<%=hdDropZoneTaskId.ClientID%>').val(vId);
    }


    $('#<%=pnlCalendar.ClientID%>').hide();
    $('#<%=divSubTask.ClientID%>').hide();

    function txtTaskDesc_Blur(editor) {
        //if ($('#<%=hdnSubTaskId.ClientID%>').val() != '0') {
        <%--if (confirm('Do you wish to save description?')) {
            $('#<%=btnAddMoreSubtask.ClientID%>').click();
        }--%>
        // }
    }

    function showSubTaskEditView(divid, rowindex) {

        var html = $('<tr>').append($('<td colspan="5">').append($(divid)));

        $('.edit-subtask > tbody > tr').eq(rowindex + 1).after(html);

        $(divid).slideDown('slow');

        $('html, body').animate({
            scrollTop: $(divid).offset().top - 100
        }, 2000);


    }
    function hideSubTaskEditView(divid, rowindex) {

        //$('#<%=hdnCurrentEditingRow.ClientID%>').val('');
        // $('.edit-subtask > tbody > tr').eq(rowindex + 2).remove();
        // $(divid).slideUp('slow');
        $('#<%=pnlCalendar.ClientID%>').hide();
        var row = $('.edit-subtask').find('tr').eq(rowindex + 2);

        //alert(row);

        if (row.length) {
            $('html, body').animate({
                scrollTop: row.offset().top - 100
            }, 2000);
        }
    }

    function GridDropZone() {
        Dropzone.autoDiscover = false;

        $(".dropzonetask").each(function () {
            // debugger;
            var objSubTaskDropzone1;

            $(this).dropzone({
                maxFiles: 5,
                url: "taskattachmentupload.aspx",
                thumbnailWidth: 90,
                thumbnailHeight: 90,
                init: function () {
                    dzClosure = this;

                    this.on("maxfilesexceeded", function (data) {
                        alert('you are reached maximum attachment upload limit.');
                    });

                    // when file is uploaded successfully store its corresponding server side file name to preview element to remove later from server.
                    this.on("success", function (file, response) {
                        // Success coding goes here

                        var filename = response.split("^");
                        $(file.previewTemplate).append('<span class="server_file">' + filename[0] + '</span>');

                        AddAttachmenttoViewState(filename[0] + '@' + file.name, '#<%= hdnAttachments.ClientID %>');

                        if ($('#<%=btnSaveGridAttachment.ClientID%>').length > 0) {
                            // saves attachment.
                            $('#<%=btnSaveGridAttachment.ClientID%>').click();
                            //this.removeFile(file);
                        }
                    });
                }
            });
        });
    }

    //--------------- End DP ---------------

</script>
