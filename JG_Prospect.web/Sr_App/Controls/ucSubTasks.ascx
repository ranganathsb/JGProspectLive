<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucSubTasks.ascx.cs" Inherits="JG_Prospect.Sr_App.Controls.ucSubTasks" %>

<%@ Register TagPrefix="asp" Namespace="Saplin.Controls" Assembly="DropDownCheckBoxes" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Controls/CustomPager.ascx" TagPrefix="uc" TagName="CustomPager" %>

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

    .taskdesc * {
        max-width: 100%;
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

                <div id="divSubTasks_List" runat="server">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table edit-subtask">
                        <asp:Repeater ID="repSubTasks" runat="server" OnItemDataBound="repSubTasks_ItemDataBound">
                            <HeaderTemplate>
                                <thead>
                                    <tr class="trHeader hide">
                                        <th>Task Details
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr id="trItem" runat="server">
                                    <td>
                                        <asp:HiddenField ID="hdnTaskId" runat="server" Value='<%# Eval("TaskId") %>' ClientIDMode="AutoID" />
                                        <asp:HiddenField ID="hdnInstallId" runat="server" Value='<%# Eval("InstallId") %>' ClientIDMode="AutoID" />


                                        <%-- Sub Task Nested Grid STARTS --%>
                                        <table class="subtasklevel" width="100%" cellpadding="0" cellspacing="0" border="0">
                                            <asp:Repeater ID="repSubTasksNested" runat="server" ClientIDMode="AutoID" OnItemDataBound="repSubTasksNested_ItemDataBound">
                                                <HeaderTemplate>
                                                    <tr class="trHeader">
                                                        <th class="subtasklevelheader" width="60">List ID#</th>
                                                        <th class="subtasklevelheader" width="250">Task Description</th>
                                                        <th class="subtasklevelheader">Assigned</th>
                                                        <th class="subtasklevelheader">Attachments, IMGs, Docs, Videos & Recordings</th>
                                                    </tr>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr id="trSubTask" runat="server">
                                                        <td valign="top" class="searchid">
                                                            <asp:HiddenField ID="hdTitle" runat="server" Value='<%# Eval("Title")%>' ClientIDMode="AutoID" />
                                                            <asp:HiddenField ID="hdURL" runat="server" Value='<%# Eval("URL")%>' ClientIDMode="AutoID" />
                                                            <asp:HiddenField ID="hdTaskLevel" runat="server" Value='<%# Eval("TaskLevel")%>' ClientIDMode="AutoID" />
                                                            <asp:HiddenField ID="hdTaskId" runat="server" Value='<%# Eval("TaskId")%>' ClientIDMode="AutoID" />

                                                            <h5>
                                                                <input type="checkbox" name="bulkaction" />
                                                                <asp:LinkButton ID="lbtnInstallId" Style="display: inline;" data-highlighter='<%# Eval("TaskId")%>' CssClass="context-menu"
                                                                    ForeColor="Blue" runat="server" Text='<%# Eval("InstallId") %>' OnClick="EditSubTask_Click"
                                                                    ClientIDMode="AutoID" />


                                                                <asp:LinkButton ID="lbtnInstallIdRemove" data-highlighter='<%# Eval("TaskId")%>' CssClass="context-menu"
                                                                    ForeColor="Blue" runat="server" Text='<%# Eval("InstallId") %>' OnClick="RemoveClick" Visible="false"
                                                                    ClientIDMode="AutoID" />
                                                            </h5>
                                                            <br />
                                                            <asp:Button ID="btnshowdivsub" CssClass="showsubtaskDIV" runat="server" Text="+" />
                                                            <%--<button type="button" id="zfdfdsf" class="showsubtaskDIV" runat="server">+</button>--%>
                                                            <!-- Freezingn Task Part Starts -->
                                                            <table width="100" style="margin-top: 10px;">
                                                                <tr>
                                                                    <td colspan="3" class="noborder" align="center">
                                                                        <asp:LinkButton ID="lbtlFeedback" runat="server" Visible="false" Text="Comment" CommandName="sub-task-feedback"
                                                                            CommandArgument='<%# Container.ItemIndex %>' ClientIDMode="AutoID" /></td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="haligncenter noborder">
                                                                        <asp:CheckBox ID="chkAdmin" runat="server" CssClass="fz fz-admin" ToolTip="Admin" ClientIDMode="AutoID" />
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
                                                                        <asp:CheckBox ID="chkITLead" runat="server" CssClass="fz fz-techlead" ToolTip="IT Lead" ClientIDMode="AutoID" />
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
                                                                        <asp:CheckBox ID="chkUser" runat="server" CssClass="fz fz-user" ToolTip="User" ClientIDMode="AutoID" />
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
                                                                        <asp:HiddenField ID="hdnTaskApprovalId" runat="server" Value='<%# Eval("TaskApprovalId") %>' ClientIDMode="AutoID" />
                                                                        <asp:TextBox ID="txtEstimatedHours" runat="server" data-id="txtEstimatedHours" CssClass="textbox" Width="80"
                                                                            placeholder="Estimate" Text='<%# Eval("TaskApprovalEstimatedHours") %>' ClientIDMode="AutoID" />
                                                                        <br />
                                                                        <asp:TextBox ID="txtPasswordToFreezeSubTask" runat="server" TextMode="Password" data-id="txtPasswordToFreezeSubTask"
                                                                            AutoPostBack="true" CssClass="textbox" Width="80" OnTextChanged="repSubTasksNested_txtPasswordToFreezeSubTask_TextChanged" ClientIDMode="AutoID" />

                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <!-- Freezingn Task Part Starts -->
                                                        </td>
                                                        <td valign="top">
                                                            <div class="divtdetails" style="background-color: white; border-bottom: 1px solid silver; padding: 3px; max-width: 400px;">
                                                                <div id="dvDesc" class="taskdesc" runat="server" style="padding-bottom: 5px; width: 98%; color: black!important;">
                                                                    <%# Server.HtmlDecode(Eval("Description").ToString())%>
                                                                </div>
                                                                <button type="button" id="btnsubtasksave" class="btnsubtask" style="display: none;">Save</button>
                                                            </div>

                                                            <asp:LinkButton ID="lnkAddMoreSubTask" Style="display: inline;" runat="server" ClientIDMode="AutoID" OnClick="lnkAddMoreSubTask_Click">+</asp:LinkButton>
                                                            &nbsp;<a href="#">Comment</a>
                                                        </td>
                                                        <td valign="top">
                                                            <table>
                                                                <tr>
                                                                    <td class="noborder">
                                                                        <h5>Priority</h5>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="noborder">
                                                                        <asp:DropDownList ID="ddlTaskPriority" runat="server" ClientIDMode="AutoID" AutoPostBack="true" OnSelectedIndexChanged="repSubTasksNested_ddlTaskPriority_SelectedIndexChanged" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="noborder">
                                                                        <h5>Assigned</h5>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="noborder">
                                                                        <asp:ListBox ID="ddcbAssigned" runat="server" Width="150" ClientIDMode="AutoID" SelectionMode="Multiple"
                                                                            CssClass="chosen-select" data-placeholder="Select"
                                                                            AutoPostBack="true" OnSelectedIndexChanged="repSubTasksNested_ddcbAssigned_SelectedIndexChanged"></asp:ListBox>
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
                                                                        <asp:DropDownList ID="ddlStatus" runat="server" ClientIDMode="AutoID" AutoPostBack="true" OnSelectedIndexChanged="repSubTasksNested_ddlStatus_SelectedIndexChanged" />
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
                                                        </td>
                                                        <td valign="top">
                                                            <table border="0" class="dropzonetbl" style="width: 100%;">
                                                                <tr>
                                                                    <td>
                                                                        <asp:UpdatePanel ID="upAttachmentsData1" runat="server" UpdateMode="Conditional" ClientIDMode="AutoID">
                                                                            <ContentTemplate>
                                                                                <input id="hdnAttachments1" runat="server" type="hidden" clientidmode="AutoID" />
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
                                                                                <td>
                                                                                    <asp:CheckBox ID="chkUiRequested" runat="server" Text="Ui Requested?" ClientIDMode="AutoID"
                                                                                        Checked='<%# Convert.ToBoolean(Eval("IsUiRequested")) %>'
                                                                                        AutoPostBack="true" OnCheckedChanged="repSubTasksNested_chkUiRequested_CheckedChanged" />
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Repeater ID="rptAttachment" OnItemCommand="rptAttachment_ItemCommand" OnItemDataBound="rptAttachment_ItemDataBound"
                                                                                        runat="server" ClientIDMode="AutoID">
                                                                                        <HeaderTemplate>
                                                                                            <div class="lSSlideOuter sub-task-attachments" style="max-width: 250px;">

                                                                                                <div class="lSSlideWrapper usingCss">
                                                                                                    <ul class="gallery list-unstyled sub-task-attachments-list">
                                                                                        </HeaderTemplate>
                                                                                        <ItemTemplate>
                                                                                            <li id="liImage" runat="server" class="noborder" style="overflow: inherit !important; width: 247px; margin-right: 0px;">
                                                                                                <h5>
                                                                                                    <asp:LinkButton ID="lbtnDownload" runat="server" ForeColor="Blue" CommandName="DownloadFile" ClientIDMode="AutoID" /></h5>
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
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                                <FooterTemplate>
                                                </FooterTemplate>
                                            </asp:Repeater>
                                        </table>
                                        <%-- Sub Task Nested Grid ENDS --%>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                </tbody>
                           
                            </FooterTemplate>
                        </asp:Repeater>
                        <tfoot>
                            <tr class="pagination-ys">
                                <td>
                                    <uc:CustomPager ID="repSubTasks_CustomPager" runat="server" PagerSize="5" />
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
                <div id="divSubTasks_Empty" runat="server">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table edit-subtask">
                        <tr>
                            <td align="center" valign="middle" style="color: black;">No sub task available!
                            </td>
                        </tr>
                    </table>
                </div>

                <asp:Button ID="btnSaveGridAttachment" runat="server"
                    OnClick="btnSaveGridAttachment_Click" Style="display: none;" Text="Save Attachement" />
                <asp:HiddenField ID="hdDropZoneTaskId" runat="server" />
            </div>
            <asp:HiddenField ID="hdnCurrentEditingRow" runat="server" />
            <asp:LinkButton ID="lnkFake" runat="server"></asp:LinkButton>
            <%-- <cc1:ModalPopupExtender ID="mpSubTask" runat="server" PopupControlID="pnlCalendar" TargetControlID="lnkFake"
                    BackgroundCssClass="modalBackground">
                    </cc1:ModalPopupExtender>--%>
        </ContentTemplate>
    </asp:UpdatePanel>
    <%--<asp:UpdatePanel ID="upEditSubTask" runat="server" UpdateMode="Conditional">
                <ContentTemplate>--%>
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
                        <%--<asp:Button ID="btnAddMoreSubtask" runat="server" OnClientClick="javascript:return OnAddMoreSubtaskClick();"
                            TabIndex="5" Text="Submit" CssClass="ui-button"
                            OnClick="btnAddMoreSubtask_Click" ValidationGroup="SubmitSubTask" />--%>
                        <asp:Button ID="btnAddMoreSubtask" runat="server" OnClientClick="javascript:return OnAddMoreSubtaskClick();"
                            TabIndex="5" Text="Submit" CssClass="ui-button" ValidationGroup="SubmitSubTask" />
                    </div>
                    <%-- <asp:Button ID="btnCalClose" runat="server" Height="30px" Width="70px" TabIndex="6"
                                                     OnClick="btnCalClose_Click" Text="Close" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" />--%>
                                </td>
            </tr>
        </table>
    </div>
    <%--    </ContentTemplate>
    </asp:UpdatePanel>--%>


    <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="SubmitSubTask" ShowSummary="False" ShowMessageBox="True" />

    <br />
    <%-- <asp:UpdatePanel ID="upAddSubTask" runat="server" UpdateMode="Conditional">
        <ContentTemplate>--%>
    <div id="divAddSubTask" runat="server">
        <%--<asp:LinkButton ID="lbtnAddNewSubTask" runat="server" Text="Add New Task" ValidationGroup="Submit" OnClick="lbtnAddNewSubTask_Click" />--%>
        <asp:HiddenField ID="hdndesignations" runat="server" Value="" />
        <asp:HiddenField ID="hdnLastSubTaskSequence" runat="server" Value="" />
        <button type="button" id="lbtnAddNewSubTask1" onclick="shownewsubtask()">Add New Task</button>
        <br />
        <asp:ValidationSummary ID="vsSubTask" runat="server" ValidationGroup="vgSubTask" ShowSummary="False" ShowMessageBox="True" />
        <div id="divNEWSubTask" runat="server" class="tasklistfieldset" style="display: none;">
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
                               
                               

                                <asp:DropDownList ID="ddlTaskType" AutoPostBack="false" runat="server" />
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
                        <%-- <asp:UpdatePanel ID="upnlDesignation" runat="server" RenderMode="Inline">
                            <ContentTemplate>
                                Designation <span style="color: red;">*</span>:
                                       
                                       

                                        <asp:DropDownCheckBoxes ID="ddlUserDesignation" runat="server" UseSelectAllNode="false"
                                            AutoPostBack="false">
                                            <Style SelectBoxWidth="195" DropDownBoxBoxWidth="120" DropDownBoxBoxHeight="150" />
                                        </asp:DropDownCheckBoxes>
                                <asp:CustomValidator ID="cvDesignations" runat="server" ValidationGroup="vgSubTask" ErrorMessage="Please Select Designation" Display="None"
                                    ClientValidationFunction="SubTasks_checkDesignations"></asp:CustomValidator>
                            </ContentTemplate>
                        </asp:UpdatePanel>--%>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">Attachment(s):
                               
                               
                                <%--remove this--%>
                        <%--<div style="max-height: 300px; clear: both; background-color: white; overflow-y: auto; overflow-x: hidden;">
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
                                </div>--%>
                        <%--remove end--%>
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
                        <%--<asp:UpdatePanel ID="upAttachmentsData" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>--%>
                        <input id="hdnAttachments" runat="server" type="hidden" />
                        <%--                                    </ContentTemplate>
                                </asp:UpdatePanel>--%>
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
                <tr id="trDateHours" runat="server" style="display: none;">
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
                            <%--<asp:Button ID="btnSaveSubTask" runat="server" Text="Save Sub Task" CssClass="ui-button" ValidationGroup="vgSubTask"
                                        OnClientClick="javascript:return OnSaveSubTaskClick();" OnClick="btnSaveSubTask_Click" />--%>
                            <asp:Button ID="btnSaveSubTask" runat="server" Text="Save Sub Task" CssClass="ui-button" ValidationGroup="vgSubTask"
                                OnClientClick="javascript:return OnSaveSubTaskClick();" />

                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <%--</ContentTemplate>
    </asp:UpdatePanel>--%>
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
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/chosen.jquery.js")%>"></script>


<script type="text/javascript">
    Dropzone.autoDiscover = false;

    $(function () {
        ucSubTasks_Initialize();
    });

    //var prmTaskGenerator = Sys.WebForms.PageRequestManager.getInstance();

    //prmTaskGenerator.add_endRequest(function () {
    //    console.log('end req.');
    //    ucSubTasks_Initialize();

    //    SetUserAutoSuggestion();
    //    SetUserAutoSuggestionUI();
    //});

    //prmTaskGenerator.add_beginRequest(function () {
    //    console.log('begin req.');
    //    DestroyGallery();
    //    DestroyDropzones();
    //    DestroyCKEditors();
    //});


    $(document).ready(function () {
        SetUserAutoSuggestion();
        SetUserAutoSuggestionUI();

        $('#<%=ddlTaskType.ClientID%>').change(function () {
            if ($("#<%=ddlTaskType.ClientID%>").val() == 3) {
                $("#<%=trDateHours.ClientID%>").css({ 'display': "block" });
            }
            else {
                $("#<%=trDateHours.ClientID%>").css({ 'display': "none" });
            }
            return false;
        })
    });

    function shownewsubtask() {
        $("#<%=divNEWSubTask.ClientID%>").css({ 'display': "block" });
        return false;
    }

    var control;
    var isadded = false;

    function pageLoad(sender, args) {

        //For Title
        $(".TitleEdit").each(function (index) {
            $(this).bind("click", function () {
                if (!isadded) {
                    var tid = $(this).attr("data-taskid");
                    var titledetail = $(this).html();
                    var fName = $("<input id=\"txtedittitle\" type=\"text\" value=\"" + titledetail + "\" class=\"editedTitle\" />");
                    $(this).html(fName);
                    $('#txtedittitle').focus();

                    console.log('going to be true in title');
                    isadded = true;
                }
            }).bind('focusout', function () {
                var tid = $(this).attr("data-taskid");
                var tdetail = $('#txtedittitle').val();
                $(this).html(tdetail);
                EditTask(tid, tdetail)
                isadded = false;
            });
        });

        //For Url
        $(".UrlEdit").each(function (index) {
            $(this).bind("click", function () {
                if (!isadded) {
                    var tid = $(this).attr("data-taskid");
                    var titledetail = $(this).html();
                    var fName = $("<input id=\"txtedittitle\" type=\"text\" value=\"" + titledetail + "\" class=\"editedTitle\" />");
                    $(this).html(fName);
                    $('#txtedittitle').focus();

                    console.log('going to be true in url');
                    isadded = true;
                }
                return false;
            }).bind('focusout', function () {
                var tid = $(this).attr("data-taskid");
                var tdetail = $('#txtedittitle').val();

                $(this).html(tdetail);
                EditUrl(tid, tdetail);
                isadded = false;
                return false;
            });
        });

        //For Description
        $(".DescEdit").each(function (index) {
            $(this).bind("click", function () {
                if (!isadded) {
                    var tid = $(this).attr("data-taskid");
                    var titledetail = $(this).html();
                    var fName = $("<textarea id=\"txtedittitle\" style=\"width:100%;\" class=\"editedTitle\" rows=\"10\" >" + titledetail + "</textarea>");
                    $(this).html(fName);
                    SetCKEditorForSubTask('txtedittitle');
                    $('#txtedittitle').focus();
                    control = $(this);

                    console.log('going to be true in desc');
                    isadded = true;

                    var otherInput = $(this).closest('.divtdetails').find('.btnsubtask');
                    $(otherInput).css({ 'display': "block" });
                    $(otherInput).bind("click", function () {
                        updateDesc(GetCKEditorContent('txtedittitle'));
                        $(this).css({ 'display': "none" });
                    });
                }
                return false;
            });
        });

        //For Add Task Button
        $(".showsubtaskDIV").each(function (index) {
            $(this).bind("click", function () {
                var commandName = $(this).attr("data-val-commandName");
                var CommandArgument = $(this).attr("data-val-CommandArgument");

                $("#<%=pnlCalendar.ClientID%>").css({ 'display': "block" });
                $("html, body").animate({ scrollTop: $("#<%=pnlCalendar.ClientID%>").offset().top }, 1500);
                SetTaskDetailsForNew(CommandArgument, commandName);
                return false;
            });
        });
    }

    function updateDesc(htmldata) {
        if (isadded) {
            EditDesc(control.attr("data-taskid"), htmldata);
            isadded = false;
        }
    }

    function ShowAjaxLoader() {
        $('.loading').show();
    }

    function HideAjaxLoader() {
        $('.loading').hide();
    }

    function EditTask(tid, tdetail) {
        ShowAjaxLoader();
        var postData = {
            tid: tid,
            title: tdetail
        };

        $.ajax
        (
            {
                url: '../WebServices/JGWebService.asmx/UpdateTaskTitleById',
                contentType: 'application/json; charset=utf-8;',
                type: 'POST',
                dataType: 'json',
                data: JSON.stringify(postData),
                asynch: false,
                success: function (data) {
                    HideAjaxLoader();
                    alert('Title saved successfully.');
                },
                error: function (a, b, c) {
                    HideAjaxLoader();
                }
            }
        );
    }
    function EditUrl(tid, tdetail) {
        ShowAjaxLoader();
        var postData = {
            tid: tid,
            URL: tdetail
        };

        $.ajax
        (
            {
                url: '../WebServices/JGWebService.asmx/UpdateTaskURLById',
                contentType: 'application/json; charset=utf-8;',
                type: 'POST',
                dataType: 'json',
                data: JSON.stringify(postData),
                asynch: false,
                success: function (data) {
                    HideAjaxLoader();
                    alert('Url saved successfully.');
                },
                error: function (a, b, c) {
                    HideAjaxLoader();
                }
            }
        );
    }
    function EditDesc(tid, tdetail) {
        ShowAjaxLoader();
        var postData = {
            tid: tid,
            Description: tdetail
        };

        $.ajax
        (
            {
                url: '../WebServices/JGWebService.asmx/UpdateTaskDescriptionById',
                contentType: 'application/json; charset=utf-8;',
                type: 'POST',
                dataType: 'json',
                data: JSON.stringify(postData),
                asynch: false,
                success: function (data) {
                    HideAjaxLoader();
                    alert('Description saved successfully.');
                },
                error: function (a, b, c) {
                    HideAjaxLoader();
                }
            }
        );
    }

    function SetTaskDetailsForNew(cmdArg, cName) {
        ShowAjaxLoader();
        var postData = {
            CommandArgument: cmdArg,
            CommandName: cName
        };

        $.ajax
        (
            {
                url: '../WebServices/JGWebService.asmx/GetSubTaskId',
                contentType: 'application/json; charset=utf-8;',
                type: 'POST',
                dataType: 'json',
                data: JSON.stringify(postData),
                asynch: false,
                success: function (data) {
                    HideAjaxLoader();
                    var taskid = GetParameterValues('TaskId');
                    $('#<%=txtInstallId.ClientID%>').val(data.d.txtInstallId);
                    $('#<%=hdParentTaskId.ClientID%>').val(data.d.hdParentTaskId);
                    $('#<%=hdMainParentId.ClientID%>').val(taskid);
                    $('#<%=hdTaskLvl.ClientID%>').val(data.d.hdTaskLvl);
                    $('#<%=hdTaskId.ClientID%>').val(cmdArg);
                },
                error: function (a, b, c) {
                    HideAjaxLoader();
                }
            }
        );
        }


    function OnAddMoreSubtaskClick() {
        ShowAjaxLoader();
        $('#<%=txtTaskDesc.ClientID%>').val(GetCKEditorContent('<%=txtTaskDesc.ClientID%>'));
        if (Page_ClientValidate('SubmitSubTask')) {

            var hdParentTaskId = $('#<%=hdParentTaskId.ClientID%>').val();
            var listID = $('#<%=txtInstallId.ClientID%>').val();
            var txtSubSubTitle = $('#<%=txtSubSubTitle.ClientID%>').val();
            var Priority = $('#<%= drpSubTaskPriority.ClientID %>').val();
            var type = $('#<%= drpSubTaskType.ClientID %>').val();
            var desc = GetCKEditorContent('<%= txtTaskDesc.ClientID %>');
            var designations = $('#<%= hdndesignations.ClientID %>').val();

            var postData = {
                ParentTaskId: hdParentTaskId,
                Title: txtSubSubTitle,
                URL: "",
                Desc: desc,
                Status: "1",
                Priority: Priority,
                DueDate: "",
                TaskHours: "",
                InstallID: listID,
                Attachments: "",
                TaskType: type,
                TaskDesignations: designations,
            };

             $.ajax
            (
                {
                    url: '../WebServices/JGWebService.asmx/AddNewSubTask',
                    contentType: 'application/json; charset=utf-8;',
                    type: 'POST',
                    dataType: 'json',
                    data: JSON.stringify(postData),
                    asynch: false,
                    success: function (data) {
                        console.log(data);
                        HideAjaxLoader();
                        if (data.d) {
                            alert('Task saved successfully.');
                            location.reload();
                        }
                        else {
                            alert('Can not save Task,');
                        }
                    },
                    error: function (a, b, c) {
                        HideAjaxLoader();
                    }
                }
            );
            return false;
        }
    }

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
        if (Page_ClientValidate('vgSubTask')) {
            var taskid = GetParameterValues('TaskId');
            var title = $('#<%= txtSubTaskTitle.ClientID %>').val();
            var url = $('#<%= txtUrl.ClientID %>').val();
            var desc = GetCKEditorContent('<%= txtSubTaskDescription.ClientID %>');
            var status = "1";
            var Priority = $('#<%= ddlSubTaskPriority.ClientID %>').val();
            var DueDate = $('#<%= txtSubTaskDueDate.ClientID %>').val();
            var tHours = $('#<%= txtSubTaskHours.ClientID %>').val();
            var installID = $('#<%= txtTaskListID.ClientID %>').val();
            var Attachments = $('#<%= hdnAttachments.ClientID %>').val();
            var type = $('#<%= ddlTaskType.ClientID %>').val();
            var designaions = $('#<%= hdndesignations.ClientID %>').val();

            var postData = {
                ParentTaskId: taskid,
                Title: title,
                URL: url,
                Desc: desc,
                Status: status,
                Priority: Priority,
                DueDate: DueDate,
                TaskHours: tHours,
                InstallID: installID,
                Attachments: Attachments,
                TaskType: type,
                TaskDesignations: designaions,
            };

            $.ajax
            (
                {
                    url: '../WebServices/JGWebService.asmx/AddNewSubTask',
                    contentType: 'application/json; charset=utf-8;',
                    type: 'POST',
                    dataType: 'json',
                    data: JSON.stringify(postData),
                    asynch: false,
                    success: function (data) {
                        console.log(data);
                        HideAjaxLoader();
                        if (data.d) {
                            alert('Task saved successfully.');
                            location.reload();
                        }
                        else {
                            alert('Problem Occured');
                        }
                    },
                    error: function (a, b, c) {
                        HideAjaxLoader();
                    }
                }
            );

            return false;
        }
    }
    function GetParameterValues(param) {
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
        for (var i = 0; i < url.length; i++) {
            var urlparam = url[i].split('=');
            if (urlparam[0] == param) {
                return urlparam[1];
            }
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

        function ApplySubtaskLinkContextMenu() {

            $(".context-menu").bind("contextmenu", function () {
                var urltoCopy = updateQueryStringParameter(window.location.href, "hstid", $(this).attr('data-highlighter'));
                copyToClipboard(urltoCopy);
                return false;
            });

            ScrollTo($(".yellowthickborder"));

            $(".yellowthickborder").bind("click", function () {
                $(this).removeClass("yellowthickborder");
            });
        }

        // check if user has selected any designations or not.
        function SubTasks_checkDesignations(oSrc, args) {
            //args.IsValid = ($("# input:checked").length > 0);
        }


        //  Created By : Yogesh K
        // To updat element underlying CKEditor before work submited to server.
        function UpdateTaskDescBeforeSubmit(CKEditorId, ButtonId) {
            $(ButtonId).bind('click', function () {
                var editor = CKEDITOR.instances[CKEditorId];

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
  <%--  $('#<%=divSubTask.ClientID%>').hide();--%>

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

        ScrollTo($(divid));
    }
    function hideSubTaskEditView(divid, rowindex) {

        //$('#<%=hdnCurrentEditingRow.ClientID%>').val('');
        // $('.edit-subtask > tbody > tr').eq(rowindex + 2).remove();
        // $(divid).slideUp('slow');
        $('#<%=pnlCalendar.ClientID%>').hide();
        var row = $('.edit-subtask').find('tr').eq(rowindex + 2);

        //alert(row);

        ScrollTo(row);
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
