<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucTaskHistory.ascx.cs" Inherits="JG_Prospect.Sr_App.Controls.ucTaskHistory" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<div>
    <asp:UpdatePanel ID="upTaskHistory" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:TabContainer ID="tcTaskHistory" runat="server" ActiveTabIndex="0" AutoPostBack="false">
                <asp:TabPanel ID="tpTaskHistory_All" runat="server" TabIndex="0">
                    <HeaderTemplate>All</HeaderTemplate>
                    <ContentTemplate>
                        <div class="grid">
                            <asp:UpdatePanel ID="upTaskUsers" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <asp:GridView ID="gdTaskUsers" runat="server"
                                        EmptyDataText="No task history available!"
                                        ShowHeaderWhenEmpty="true"
                                        AutoGenerateColumns="false"
                                        Width="100%"
                                        HeaderStyle-BackColor="Black"
                                        HeaderStyle-ForeColor="White"
                                        AllowSorting="false"
                                        BackColor="White"
                                        PageSize="3"
                                        GridLines="Horizontal"
                                        OnRowDataBound="gdTaskUsers_RowDataBound"
                                        OnRowCommand="gdTaskUsers_RowCommand"
                                        OnRowEditing="gdTaskUsers_RowEditing"
                                        OnRowUpdating="gdTaskUsers_RowUpdating"
                                        OnRowCancelingEdit="gdTaskUsers_RowCancelingEdit">
                                        <%--<EmptyDataTemplate>
                                                                </EmptyDataTemplate>--%>

                                        <EmptyDataRowStyle ForeColor="White" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="trHeader " />
                                        <RowStyle CssClass="FirstRow" BorderStyle="Solid" />
                                        <AlternatingRowStyle CssClass="AlternateRow " />
                                        <Columns>
                                            <asp:TemplateField ShowHeader="True" Visible="false" HeaderText="Note Id" ControlStyle-ForeColor="White"
                                                HeaderStyle-Font-Size="Small" HeaderStyle-Width="10%"
                                                ItemStyle-HorizontalAlign="Left">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblNoteId" runat="server" Text='<%#Eval("ID")%>'></asp:Label>
                                                </ItemTemplate>
                                                <ControlStyle ForeColor="Black" />
                                                <ControlStyle ForeColor="Black" />
                                                <HeaderStyle Font-Size="Small"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                            </asp:TemplateField>
                                            <asp:TemplateField ShowHeader="True" HeaderText="User" ControlStyle-ForeColor="White"
                                                HeaderStyle-Font-Size="Small" HeaderStyle-Width="20%"
                                                ItemStyle-HorizontalAlign="Left">
                                                <ItemTemplate>
                                                    <asp:HyperLink runat="server" NavigateUrl='<%# Eval("UserId", "CreateSalesUser.aspx?id={0}") %>'
                                                        Text='<%# string.Concat(String.IsNullOrEmpty(Eval("FristName").ToString())== true ? Eval("UserFirstName").ToString() : Eval("FristName").ToString() , " -", Eval("UserId")) %>' />
                                                </ItemTemplate>
                                                <ControlStyle ForeColor="Black" />
                                                <ControlStyle ForeColor="Black" />
                                                <HeaderStyle Font-Size="Small"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                            </asp:TemplateField>
                                            <asp:TemplateField ShowHeader="True" HeaderText="Date & Time" ControlStyle-ForeColor="White"
                                                HeaderStyle-Font-Size="Small" HeaderStyle-Width="10%"
                                                ItemStyle-HorizontalAlign="Left">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblupdateDate" runat="server" Text='<%#Eval("UpdatedOn")%>'></asp:Label>
                                                </ItemTemplate>
                                                <ControlStyle ForeColor="Black" />
                                                <ControlStyle ForeColor="Black" />
                                                <HeaderStyle Font-Size="Small"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Notes" ControlStyle-ForeColor="White" HeaderStyle-Font-Size="Small"
                                                ItemStyle-HorizontalAlign="Left" HeaderStyle-Width="50%">
                                                <ItemTemplate>
                                                    <div>
                                                        <asp:Label ID="lblNotes" runat="server" Text='<%#Eval("Notes")%>'></asp:Label>
                                                    </div>
                                                    <div>
                                                        <asp:ImageButton ID="imgFile" runat="server" ImageUrl='<%#Eval("Attachment")%>'
                                                            Width="120px" Height="120px" Style="cursor: pointer" OnClientClick="return LoadDiv(this.src);" />
                                                    </div>
                                                    <div>
                                                        <asp:LinkButton ID="linkOriginalfileName" runat="server" Text='<%#Eval("AttachmentOriginal")%>'
                                                            CommandName="viewFile" CommandArgument='<%# Eval("Attachment")%>'></asp:LinkButton>
                                                        <asp:Label ID="lableOriginalfileName" runat="server" Text='<%#Eval("AttachmentOriginal")%>'></asp:Label>
                                                    </div>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="txtNotes" runat="server" Text='<%#Eval("Notes") %>' TextMode="MultiLine" Width="90%" CssClass="textbox"></asp:TextBox>
                                                </EditItemTemplate>
                                                <ControlStyle ForeColor="Black" />
                                                <ControlStyle ForeColor="Black" />
                                                <HeaderStyle Font-Size="Small"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                            </asp:TemplateField>

                                            <%--<asp:TemplateField ShowHeader="True" ControlStyle-ForeColor="White" HeaderStyle-Font-Size="Small"
                                                                            ItemStyle-HorizontalAlign="Left" HeaderStyle-Width="10%">
                                                                            <ItemTemplate>
                                                                                   
                                                                            </ItemTemplate>
                                                                            <ControlStyle ForeColor="Black" />
                                                                            <ControlStyle ForeColor="Black" />
                                                                            <HeaderStyle Font-Size="Small"></HeaderStyle>
                                                                            <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                                                        </asp:TemplateField>--%>

                                            <asp:TemplateField ShowHeader="True" HeaderText="Status"
                                                ControlStyle-ForeColor="White" HeaderStyle-Font-Size="Small" Visible="false"
                                                ItemStyle-HorizontalAlign="Left">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblStatus" runat="server"></asp:Label>
                                                </ItemTemplate>
                                                <ControlStyle ForeColor="Black" />
                                                <ControlStyle ForeColor="Black" />
                                                <HeaderStyle Font-Size="Small"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                            </asp:TemplateField>

                                            <asp:TemplateField ShowHeader="True" HeaderText="Status"
                                                ControlStyle-ForeColor="White" HeaderStyle-Font-Size="Small" Visible="false"
                                                ItemStyle-HorizontalAlign="Left">
                                                <ItemTemplate>
                                                    <asp:Label ID="lableFileType" runat="server" Text='<%#Eval("FileType")%>'></asp:Label>
                                                </ItemTemplate>
                                                <ControlStyle ForeColor="Black" />
                                                <ControlStyle ForeColor="Black" />
                                                <HeaderStyle Font-Size="Small"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderStyle-Width="10%">
                                                <EditItemTemplate>
                                                    <asp:Button ID="ButtonUpdate" runat="server" CommandName="Update" Text="Update" />
                                                    <asp:Button ID="ButtonCancel" runat="server" CommandName="Cancel" Text="Cancel" />
                                                </EditItemTemplate>
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="linkDownLoadFiles" runat="server" Text="Download" CommandName="DownLoadFiles" CommandArgument='<%# Eval("Attachment")%>'></asp:LinkButton>
                                                    <asp:Button ID="ButtonEdit" runat="server" CommandName="Edit" Text="Edit" />
                                                </ItemTemplate>
                                                <ControlStyle ForeColor="Black" />
                                                <ControlStyle ForeColor="Black" />
                                                <HeaderStyle Font-Size="Small"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                            </asp:TemplateField>

                                        </Columns>
                                        <HeaderStyle BackColor="Black" ForeColor="White"></HeaderStyle>
                                    </asp:GridView>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel ID="tpTaskHistory_Notes" runat="server" TabIndex="0">
                    <HeaderTemplate>Notes</HeaderTemplate>

                    <ContentTemplate>
                        <div>
                            <div class="grid">
                                <asp:GridView ID="gdTaskUsersNotes" runat="server"
                                    EmptyDataText="No task not history available!"
                                    ShowHeaderWhenEmpty="true"
                                    AutoGenerateColumns="false"
                                    Width="100%"
                                    HeaderStyle-BackColor="Black"
                                    HeaderStyle-ForeColor="White"
                                    AllowSorting="false"
                                    BackColor="White"
                                    PageSize="3"
                                    GridLines="Horizontal"
                                    OnRowEditing="gdTaskUsersNotes_RowEditing"
                                    OnRowUpdating="gdTaskUsersNotes_RowUpdating"
                                    OnRowCancelingEdit="gdTaskUsersNotes_RowCancelingEdit"
                                    OnRowDataBound="gdTaskUsersNotes_RowDataBound">

                                    <EmptyDataRowStyle ForeColor="White" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="trHeader " />
                                    <RowStyle CssClass="FirstRow" BorderStyle="Solid" />
                                    <AlternatingRowStyle CssClass="AlternateRow " />

                                    <Columns>
                                        <asp:TemplateField ShowHeader="True" Visible="false" HeaderText="Note Id" ControlStyle-ForeColor="White"
                                            HeaderStyle-Font-Size="Small" HeaderStyle-Width="10%"
                                            ItemStyle-HorizontalAlign="Left">
                                            <ItemTemplate>
                                                <asp:Label ID="lblNoteId" runat="server" Text='<%#Eval("ID")%>'></asp:Label>
                                            </ItemTemplate>
                                            <ControlStyle ForeColor="Black" />
                                            <ControlStyle ForeColor="Black" />
                                            <HeaderStyle Font-Size="Small"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                        </asp:TemplateField>

                                        <asp:TemplateField ShowHeader="True" HeaderText="User" ControlStyle-ForeColor="White"
                                            HeaderStyle-Font-Size="Small" HeaderStyle-Width="20%"
                                            ItemStyle-HorizontalAlign="Left">
                                            <ItemTemplate>
                                                <asp:HyperLink runat="server" NavigateUrl='<%# Eval("UserId", "CreateSalesUser.aspx?id={0}") %>'
                                                    Text='<%# string.Concat(String.IsNullOrEmpty(Eval("FristName").ToString())== true ? Eval("UserFirstName").ToString() : Eval("FristName").ToString() , " -", Eval("UserId")) %>' />
                                            </ItemTemplate>
                                            <ControlStyle ForeColor="Black" />
                                            <ControlStyle ForeColor="Black" />
                                            <HeaderStyle Font-Size="Small"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                        </asp:TemplateField>

                                        <asp:TemplateField ShowHeader="True" HeaderText="Date & Time" ControlStyle-ForeColor="White"
                                            HeaderStyle-Font-Size="Small" HeaderStyle-Width="10%"
                                            ItemStyle-HorizontalAlign="Left">
                                            <ItemTemplate>
                                                <asp:Label ID="lblupdateDate" runat="server" Text='<%#Eval("UpdatedOn")%>'></asp:Label>
                                            </ItemTemplate>
                                            <ControlStyle ForeColor="Black" />
                                            <ControlStyle ForeColor="Black" />
                                            <HeaderStyle Font-Size="Small"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Employee Name" HeaderStyle-Width="50%">
                                            <ItemTemplate>
                                                <asp:Label ID="lblNotes" runat="server" Text='<%#Eval("Notes") %>'></asp:Label>
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <asp:TextBox ID="txtNotes" runat="server" Text='<%#Eval("Notes") %>' TextMode="MultiLine" Width="90%" CssClass="textbox"></asp:TextBox>
                                            </EditItemTemplate>
                                            <ControlStyle ForeColor="Black" />
                                            <ControlStyle ForeColor="Black" />
                                            <HeaderStyle Font-Size="Small"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderStyle-Width="10%">
                                            <EditItemTemplate>
                                                <asp:Button ID="ButtonUpdate" runat="server" CommandName="Update" Text="Update" />
                                                <asp:Button ID="ButtonCancel" runat="server" CommandName="Cancel" Text="Cancel" />
                                            </EditItemTemplate>
                                            <ItemTemplate>
                                                <asp:Button ID="ButtonEdit" runat="server" CommandName="Edit" Text="Edit" />
                                            </ItemTemplate>
                                            <ControlStyle ForeColor="Black" />
                                            <ControlStyle ForeColor="Black" />
                                            <HeaderStyle Font-Size="Small"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                        </asp:TemplateField>

                                    </Columns>
                                    <HeaderStyle BackColor="Black" ForeColor="White"></HeaderStyle>
                                </asp:GridView>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel ID="tpTaskHistory_FilesAndDocs" runat="server" TabIndex="0" CssClass="task-history-tab">
                    <HeaderTemplate>Files & docs</HeaderTemplate>
                    <ContentTemplate>
                        <div>
                            <asp:Repeater ID="reapeaterLogDoc" runat="server">
                                <ItemTemplate>
                                    <div style="width: 200px; height: 200px; float: left;">


                                        <div style="text-align: center;">
                                            <asp:Label ID="linkOriginalfileName" runat="server" Text='<%#Eval("AttachmentOriginal")%>' CommandName="viewFile" CommandArgument='<%# Eval("Attachment")%>'></asp:Label>
                                        </div>
                                        <div style="text-align: center;">
                                            <asp:Image ID="imgDoc" runat="server" ImageUrl='<%#Eval("FilePath")%>'
                                                Width="120px" Height="120px" />
                                            <asp:Label ID="lblMessage" ForeColor="Red" runat="server" Visible="false" />
                                        </div>
                                        <div style="text-align: center;">
                                            <%--<asp:LinkButton ID="linkDownLoadFiles" runat="server" Text="Download" CommandName="DownLoadFiles" CommandArgument='<%# Eval("Attachment")%>'></asp:LinkButton>--%>

                                            <asp:LinkButton ID="linkDownLoadFiles" OnClick="linkDownLoadFiles_Click"
                                                runat="server" Text="Download" CommandName='<%#Eval("AttachmentOriginal")%>' CommandArgument='<%# Eval("Attachment")%>'></asp:LinkButton>

                                        </div>
                                        <div style="text-align: center;">
                                            <asp:Label ID="lblDate" runat="server" Text='<%#Eval("UpdatedOn")%>'></asp:Label>
                                        </div>

                                        <div style="display: none">
                                            <asp:Label ID="lableFileExtension" runat="server" Text='<%#Eval("FileType")%>' Visible="false"></asp:Label>
                                        </div>
                                    </div>

                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel ID="tpTaskHistory_Images" runat="server" TabIndex="0" CssClass="task-history-tab">
                    <HeaderTemplate>Images</HeaderTemplate>
                    <ContentTemplate>
                        <div>
                            <asp:Repeater ID="reapeaterLogImages" runat="server">
                                <ItemTemplate>
                                    <div style="width: 200px; height: 200px; float: left;">


                                        <div style="text-align: center;">
                                            <asp:LinkButton ID="linkOriginalfileName" runat="server" Text='<%#Eval("AttachmentOriginal")%>' CommandName="viewFile" CommandArgument='<%# Eval("Attachment")%>'></asp:LinkButton>
                                        </div>
                                        <div style="text-align: center;">
                                            <asp:ImageButton ID="imgImages" runat="server" ImageUrl='<%#Eval("FilePath")%>'
                                                Width="120px" Height="120px" Style="cursor: pointer" OnClientClick="return LoadDiv(this.src);" />
                                            <asp:Label ID="lblMessage" ForeColor="Red" runat="server" Visible="false" />
                                        </div>
                                        <div style="text-align: center;">
                                            <%--<asp:LinkButton ID="linkDownLoadFiles" runat="server" Text="Download" CommandName="DownLoadFiles" CommandArgument='<%# Eval("Attachment")%>'></asp:LinkButton>--%>

                                            <asp:LinkButton ID="linkDownLoadFiles" OnClick="linkDownLoadFiles_Click"
                                                runat="server" Text="Download" CommandName='<%#Eval("AttachmentOriginal")%>' CommandArgument='<%# Eval("Attachment")%>'></asp:LinkButton>

                                        </div>
                                        <div style="text-align: center;">
                                            <asp:Label ID="lblDate" runat="server" Text='<%#Eval("UpdatedOn")%>'></asp:Label>
                                        </div>

                                        <div style="display: none">
                                            <asp:Label ID="lableFileType" runat="server" Text='<%#Eval("FileType")%>' Visible="false"></asp:Label>
                                        </div>
                                    </div>

                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel ID="tpTaskHistory_Links" runat="server" TabIndex="0" CssClass="task-history-tab" Visible="false">
                    <HeaderTemplate>Links</HeaderTemplate>
                    <ContentTemplate>
                        HTML Goes here 4
                                   
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel ID="tpTaskHistory_Videos" runat="server" TabIndex="0" CssClass="task-history-tab">
                    <HeaderTemplate>Videos</HeaderTemplate>
                    <ContentTemplate>
                        <div>
                            <asp:Repeater ID="reapeaterLogVideoc" runat="server" OnItemCommand="reapeaterLogImages_ItemCommand">
                                <ItemTemplate>
                                    <div style="width: 200px; height: 200px; float: left;">
                                        <div style="text-align: center;">
                                            <asp:LinkButton runat="server" Text='<%#Eval("AttachmentOriginal")%>' ID="linkOriginalfileName" CommandName="viewFile"
                                                OnClientClick='<%# string.Format("return ViewDetails({0}, \"{1}\", \"{2}\", \"{3}\");", Eval("Id"), Eval("Attachment"), Eval("AttachmentOriginal"), Eval("FileType")) %>'
                                                CommandArgument='<%# Eval("Attachment")%>'>
                                            </asp:LinkButton>
                                        </div>
                                        <div style="text-align: center;">
                                            <asp:Image ID="imgImages" runat="server" ImageUrl='<%#Eval("FilePath")%>'
                                                Width="120px" Height="120px" />
                                            <asp:Label ID="lblMessage" ForeColor="Red" runat="server" Visible="false" />
                                        </div>
                                        <div style="text-align: center;">
                                            <%-- <asp:LinkButton ID="linkDownLoadFiles" runat="server" Text="Download" CommandName="DownLoadFiles" CommandArgument='<%# Eval("Attachment")%>'></asp:LinkButton>--%>

                                            <asp:LinkButton ID="linkDownLoadFiles" OnClick="linkDownLoadFiles_Click"
                                                runat="server" Text="Download" CommandName='<%#Eval("AttachmentOriginal")%>' CommandArgument='<%# Eval("Attachment")%>'></asp:LinkButton>

                                        </div>
                                        <div style="text-align: center;">
                                            <asp:Label ID="lblDate" runat="server" Text='<%#Eval("UpdatedOn")%>'></asp:Label>
                                        </div>

                                        <div style="display: none">
                                            <asp:Label ID="lableFileType" runat="server" Text='<%#Eval("FileType")%>' Visible="false"></asp:Label>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel ID="tpTaskHistory_Audios" runat="server" TabIndex="0" CssClass="task-history-tab">
                    <HeaderTemplate>Audios</HeaderTemplate>
                    <ContentTemplate>
                        <div>
                            <asp:Repeater ID="reapeaterLogAudio" runat="server"
                                OnItemCommand="reapeaterLogImages_ItemCommand">
                                <ItemTemplate>
                                    <div style="width: 200px; height: 200px; float: left;">
                                        <div style="text-align: center;">
                                            <%-- <asp:LinkButton ID="linkOriginalfileName" runat="server" Text='<%#Eval("AttachmentOriginal")%>' 
                                                                                    CommandName="viewFile" CommandArgument='<%# Eval("Attachment")%>'></asp:LinkButton>--%>

                                            <asp:LinkButton runat="server" Text='<%#Eval("AttachmentOriginal")%>' ID="linkOriginalfileName" CommandName="viewFile"
                                                OnClientClick='<%# string.Format("return ViewDetails({0}, \"{1}\", \"{2}\", \"{3}\");", Eval("Id"), Eval("Attachment"), Eval("AttachmentOriginal"), Eval("FileType")) %>'
                                                CommandArgument='<%# Eval("Attachment")%>'>
                                            </asp:LinkButton>

                                        </div>
                                        <div style="text-align: center;">
                                            <asp:Image ID="imgImages" runat="server" ImageUrl='<%#Eval("FilePath")%>'
                                                Width="120px" Height="120px" />
                                            <asp:Label ID="lblMessage" ForeColor="Red" runat="server" Visible="false" />
                                        </div>
                                        <div style="text-align: center;">
                                            <%--<asp:LinkButton ID="linkDownLoadFiles" runat="server" Text="Download" CommandName="DownLoadFiles" CommandArgument='<%# Eval("Attachment")%>'></asp:LinkButton>--%>

                                            <asp:LinkButton ID="linkDownLoadFiles" OnClick="linkDownLoadFiles_Click"
                                                runat="server" Text="Download" CommandName='<%#Eval("AttachmentOriginal")%>' CommandArgument='<%# Eval("Attachment")%>'>
                                            </asp:LinkButton>

                                        </div>
                                        <div style="text-align: center;">
                                            <asp:Label ID="lblDate" runat="server" Text='<%#Eval("UpdatedOn")%>'></asp:Label>
                                        </div>

                                        <div style="display: none">
                                            <asp:Label ID="lableFileType" runat="server" Text='<%#Eval("FileType")%>' Visible="false"></asp:Label>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>

                        </div>
                    </ContentTemplate>
                </asp:TabPanel>
            </asp:TabContainer>

            <div style="margin-top: 5px" id="divTableNote" runat="server">
                <div>
                    <div>
                        <div>
                            <table style="width: 100%">
                                <tr>
                                    <td style="width: 50px">
                                        <asp:Label runat="server"> Notes:</asp:Label>
                                    </td>
                                    <td style="width: 95%">
                                        <asp:TextBox ID="txtNote" runat="server" TextMode="MultiLine" Width="90%" CssClass="textbox" ValidationGroup="Validation"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorName" runat="server" ControlToValidate="txtNote"
                                            Display="None" ErrorMessage="Please Enter Note" ValidationGroup="Validation"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>

                <div id="divAddNoteOrImage" runat="server">
                    <table style="width: 100%">
                        <tr>
                            <td style="width: 50%">
                                <div class="btn_sec" style="text-align: right;">
                                    <asp:Button ID="btnAddNote" runat="server" Text="Save" CssClass="ui-button" OnClick="btnAddNote_Click" ValidationGroup="Validation" />
                                    <asp:ValidationSummary ID="ValidationSummary2" runat="server" ShowMessageBox="True"
                                        ShowSummary="False" ValidationGroup="Validation" />
                                </div>
                            </td>
                            <td style="width: 50%">
                                <table style="width: 100%">
                                    <tr>
                                        <td style="width: 10%">
                                            <asp:ImageButton ImageUrl="~/img/paperclip.png" Height="30px" Width="30px" runat="server" ID="imgBtnLogFiles" OnClientClick="Javascript:return showNotesUploadControl(1);" />
                                        </td>

                                        <td style="width: 50%; display: none" id="tdLogFiles">
                                            <div>
                                                <table style="width: 100%">
                                                    <tr>
                                                        <td style="text-align: right">
                                                            <div id="divNoteDropzone" runat="server" class="dropzone work-file-Note">
                                                                <div class="fallback">
                                                                    <input name="file" type="file" multiple />
                                                                    <input type="submit" value="Upload" />
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td style="text-align: left">
                                                            <table>
                                                                <tr>

                                                                    <td>
                                                                        <div id="divNoteDropzonePreview" runat="server" class="dropzone-previews work-file-previews-note">
                                                                        </div>
                                                                    </td>

                                                                    <td style="visibility: hidden">
                                                                        <div class="btn_sec" style="text-align: right;">
                                                                            <asp:Button ID="btnUploadLogFiles" runat="server" Text="Upload File" CssClass="ui-button" OnClick="btnUploadLogFiles_Click" ValidationGroup="Submit" />
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
