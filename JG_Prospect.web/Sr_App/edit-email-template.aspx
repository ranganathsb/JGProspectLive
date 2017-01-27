<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" CodeBehind="edit-email-template.aspx.cs" 
    Inherits="JG_Prospect.Sr_App.edit_email_template" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_panel">
        <asp:ValidationSummary ID="vsTemplate" runat="server" ShowMessageBox="true" ShowSummary="false" ValidationGroup="vgTemplate" />
        <table width="100%">
            <tr>
                <td>
                    Name:
                </td>
                <td>
                    <asp:TextBox ID="txtName" runat="server" ReadOnly="true" Enabled="false" />
                </td>
            </tr>
            <tr>
                <td>
                    Designation:
                </td>
                <td>
                    <asp:DropDownList ID="ddlDesignation" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlDesignation_SelectedIndexChanged" />
                    <asp:RequiredFieldValidator ID="rfvDesignation" runat="server" ControlToValidate="ddlDesignation" 
                        InitialValue="" ValidationGroup="vgTemplate" Display="None"
                        ErrorMessage="Please enter designation." />
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <small>Save a separate copy, if you want, for individual designations. Master copy will be used if designation specific copy is not available.</small>
                </td>
            </tr>
            <tr id="trMasterCopy" runat="server" visible="false">
                <td colspan="2">
                    We do not have designation specific copy for selected designation. So, we have loaded master copy in fields given below. You can modify and save designation specific copy.
                </td>
            </tr>
            <tr>
                <td>
                    Subject:
                </td>
                <td>
                    <asp:TextBox ID="txtSubject" runat="server" MaxLength="3500" />
                    <asp:RequiredFieldValidator ID="rfvSubject" runat="server" ControlToValidate="txtSubject" 
                        InitialValue="" ValidationGroup="vgTemplate" Display="None"
                        ErrorMessage="Please enter subject." />
                </td>
            </tr>
            <tr>
                <td>
                    Header:
                </td>
                <td>
                    <asp:TextBox ID="txtHeader" runat="server" TextMode="MultiLine" />
                    <asp:RequiredFieldValidator ID="rfvHeader" runat="server" ControlToValidate="txtHeader" 
                        InitialValue="" ValidationGroup="vgTemplate" Display="None"
                        ErrorMessage="Please enter header." />
                </td>
            </tr>
            <tr>
                <td>
                    Body:
                </td>
                <td>
                    <asp:TextBox ID="txtBody" runat="server" TextMode="MultiLine" />
                    <asp:RequiredFieldValidator ID="rfvBody" runat="server" ControlToValidate="txtBody" 
                        InitialValue="" ValidationGroup="vgTemplate" Display="None"
                        ErrorMessage="Please enter body." />
                </td>
            </tr>
            <tr>
                <td>
                    Footer:
                </td>
                <td>
                    <asp:TextBox ID="txtFooter" runat="server" TextMode="MultiLine" />
                    <asp:RequiredFieldValidator ID="rfvFooter" runat="server" ControlToValidate="txtFooter" 
                        InitialValue="" ValidationGroup="vgTemplate" Display="None"
                        ErrorMessage="Please enter footer." />
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <div class="">
                        <asp:Button ID="btnSaveTemplate" runat="server" Text="Save" OnClick="btnSaveTemplate_Click" ValidationGroup="vgTemplate" />
                        <asp:Button ID="btnRevertToMaster" runat="server" Text="Revert To Master" OnClick="btnRevertToMaster_Click" />
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" />
                    </div>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
