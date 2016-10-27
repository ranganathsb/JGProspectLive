<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucTaskWorkSpecifications.ascx.cs" Inherits="JG_Prospect.Sr_App.Controls.ucTaskWorkSpecifications" %>

<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<%@ Register Src="~/Controls/CustomPager.ascx" TagPrefix="uc1" TagName="CustomPager" %>

<asp:UpdatePanel ID="upWorkSpecifications" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <table width="100%" cellspacing="0" cellpadding="0" class="table">
            <thead>
                <tr class="trHeader">
                    <th>Id</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <asp:HiddenField ID="repWorkSpecifications_EditIndex" runat="server" Value="-1" />
                <asp:Repeater ID="repWorkSpecifications" runat="server"
                    OnItemDataBound="repWorkSpecifications_ItemDataBound"
                    OnItemCommand="repWorkSpecifications_ItemCommand">
                    <ItemTemplate>
                        <tr id="trWorkSpecification" runat="server" class="">
                            <td>
                                <asp:HiddenField ID="hdnId" runat="server" Value='<%#Eval("Id")%>' />
                                <small>
                                    <asp:LinkButton ID="lbtnEditWorkSpecification" runat="server" ForeColor="Blue" ClientIDMode="AutoID"
                                        CommandName="edit-work-specification" Text='<%#Eval("CustomId")%>' CommandArgument='<%# Container.ItemIndex%>' />
                                    <asp:Literal ID="ltrlCustomId" runat="server" Text='<%#Eval("CustomId") %>' />
                                </small>
                            </td>
                            <td>
                                <div id="divViewDescription" runat="server" style="background-color: white; min-height: 20px; margin: 3px; padding: 3px;">
                                    <div style="margin-bottom: 10px;">
                                        <asp:Literal ID="ltrlDescription" runat="server" />
                                    </div>
                                    <asp:LinkButton ID="lbtnAddSubWorkSpecification" runat="server" ClientIDMode="AutoID" Text="Add Sub Section" 
                                        CommandName="add-sub-work-specification" CommandArgument='<%# Container.ItemIndex %>' />&nbsp;&nbsp;<asp:LinkButton 
                                        ID="lbtnToggleSubWorkSpecification" runat="server" ClientIDMode="AutoID" Text="View Sub Section" 
                                        CommandName="show-sub-work-specification" CommandArgument='<%# Container.ItemIndex %>' />
                                    <asp:PlaceHolder ID="phSubWorkSpecification" runat="server" />
                                </div>
                                <div id="divEditDescription" runat="server">
                                    <CKEditor:CKEditorControl ID="ckeWorkSpecification" runat="server" Height="200" BasePath="~/ckeditor" />
                                    <br />
                                    <asp:LinkButton ID="lbtnSaveWorkSpecification" runat="server" ClientIDMode="AutoID" Text="Save"
                                        CommandName="save-work-specification" CommandArgument='<%# Container.ItemIndex %>' />&nbsp;&nbsp;<asp:LinkButton
                                            ID="lbtnCancelEditing" runat="server" ClientIDMode="AutoID" Text="Cancel" CommandName="cancel-edit-work-specification" />
                                </div>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
            <tfoot>
                <tr class="FirstRow">
                    <td>
                        <small>
                            <asp:Literal ID="ltrlCustomId" runat="server" Text='<%#Eval("CustomId") %>' />
                        </small>
                    </td>
                    <td>
                        <CKEditor:CKEditorControl ID="ckeWorkSpecification" runat="server" Height="200" BasePath="~/ckeditor" Visible="true" />
                        <br />
                        <asp:LinkButton ID="lbtnInsertWorkSpecification" runat="server" Text="Add" ClientIDMode="AutoID" CausesValidation="false"
                            OnClick="lbtnInsertWorkSpecification_Click" />
                    </td>
                </tr>
                <tr class="pager">
                    <td colspan="2">
                        <uc1:CustomPager ID="repWorkSpecificationsPager" runat="server" PageSize="5" PagerSize="10" />
                    </td>
                </tr>
            </tfoot>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
