<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucSubTasks.ascx.cs" Inherits="JG_Prospect.Sr_App.Controls.ucSubTasks" %>

<fieldset class="tasklistfieldset">
    <legend>Task List</legend>
    <asp:UpdatePanel ID="upSubTasks" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div id="divSubTaskGrid">
                <asp:GridView ID="gvSubTasks" runat="server" ShowHeaderWhenEmpty="true" EmptyDataRowStyle-HorizontalAlign="Center"
                    HeaderStyle-BackColor="Black" HeaderStyle-ForeColor="White" BackColor="White" EmptyDataRowStyle-ForeColor="Black"
                    EmptyDataText="No sub task available!" CssClass="table" Width="100%" CellSpacing="0" CellPadding="0"
                    AutoGenerateColumns="False" GridLines="Vertical" DataKeyNames="TaskId,InstallId"
                    OnRowDataBound="gvSubTasks_RowDataBound"
                    OnRowCommand="gvSubTasks_RowCommand">
                    <EmptyDataRowStyle ForeColor="White" HorizontalAlign="Center" />
                    <HeaderStyle CssClass="trHeader " />
                    <RowStyle CssClass="FirstRow" />
                    <AlternatingRowStyle CssClass="AlternateRow " />
                    <Columns>
                        <asp:TemplateField HeaderText="List ID" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="60">
                            <ItemTemplate>
                                <asp:Literal ID="ltrlInstallId" runat="server" Text='<%# Eval("InstallId") %>' />
                                <asp:LinkButton ID="lbtnInstallId" runat="server" Text='<%# Eval("InstallId") %>' CommandName="edit-sub-task"
                                    CommandArgument='<%# Container.DataItemIndex  %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Task Description" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                            <ItemTemplate>
                                <%# Eval("Description")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Type" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="85">
                            <ItemTemplate>
                                <asp:Literal ID="ltrlTaskType" runat="server" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="105">
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlStatus" runat="server" AutoPostBack="true" OnSelectedIndexChanged="gvSubTasks_ddlStatus_SelectedIndexChanged" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Priority" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="88">
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlTaskPriority" runat="server" AutoPostBack="true" OnSelectedIndexChanged="gvSubTasks_ddlTaskPriority_SelectedIndexChanged" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Attachments" HeaderStyle-Width="15%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                            <ItemTemplate>
                                <asp:Repeater ID="rptAttachment" OnItemCommand="rptAttachment_ItemCommand" OnItemDataBound="rptAttachment_ItemDataBound" runat="server">
                                    <ItemTemplate>
                                        <small>
                                            <asp:LinkButton ID="lbtnDownload" runat="server" ForeColor="Blue" CommandName="DownloadFile" />
                                            <asp:Literal ID="ltrlSeprator" runat="server" Text=" ," />
                                        </small>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="88">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbtlFeedback" runat="server" Text="Feedback" CommandName="sub-task-feedback"
                                    CommandArgument='<%# Container.DataItemIndex  %>' />
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
                                    OnClick="btnSaveSubTask_Click" />
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</fieldset>

<div class="hide">


    <%--Sub Task Feedback Popup--%>
    <div id="divSubTaskFeedbackPopup" runat="server" title="Sub Task Feedback">
        <asp:UpdatePanel ID="upSubTaskFeedbackPopup" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <fieldset>
                    <legend>
                        <asp:Literal ID="ltrlSubTaskFeedbackTitle" runat="server" /></legend>
                    <table cellspacing="3" cellpadding="3" width="100%">
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
                    </table>
                    <table id="tblAddEditSubTaskFeedback" runat="server" cellspacing="3" cellpadding="3" width="100%">
                        <tr>
                            <td colspan="2">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td width="90" align="right" valign="top">Description:
                            </td>
                            <td>
                                <asp:TextBox ID="txtSubTaskFeedback" runat="server" CssClass="textbox" TextMode="MultiLine" Rows="4" Width="90%" />
                            </td>
                        </tr>
                        <tr>
                            <td align="right" valign="top">Files:
                            </td>
                            <td>
                                <div class="dropzone">
                                    <div class="dz-default dz-message"></div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div class="btn_sec">
                                    <asp:Button ID="btnSaveSubTaskFeedback" runat="server" CssClass="ui-button" Text="Save" OnClientClick="javascript:return false;" />
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

    function ucSubTasks_Initialize() {
        ucSubTasks_ApplyDropZone();
    }

    function copytoListID(sender) {
        var strListID = $.trim($(sender).text());
        if (strListID.length > 0) {
            $('#<%= txtTaskListID.ClientID %>').val(strListID);
        }
    }

    var objSubTaskDropzone;

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
        }

</script>
