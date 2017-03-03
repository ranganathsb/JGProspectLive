﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" ValidateRequest="false"
    CodeBehind="edit-html-template.aspx.cs" Inherits="JG_Prospect.Sr_App.edit_html_template" %>

<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_panel">
        <!-- appointment tabs section start -->
        <ul class="appointment_tab">
            <li><a href="Price_control.aspx">Product Line Estimate</a></li>
            <li><a href="Inventory.aspx">Inventory</a></li>
            <li><a href="Maintenace.aspx">Maintainance</a></li>
            <li><a href="html-template-maintainance.aspx">Maintainance New</a></li>
        </ul>
        <!-- appointment tabs section end -->
        <h1>Edit Email Templates</h1>
        <div style="padding:5px;">
            <asp:ValidationSummary ID="vsTemplate" runat="server" ShowMessageBox="true" ShowSummary="false" ValidationGroup="vgTemplate" />
            <asp:UpdatePanel ID="upUpdateTemplate" runat="server">
                <ContentTemplate>
                    <table width="100%">
                        <tr>
                            <%--<td width="80" valign="top">Name:
                            </td>--%>
                            <td>
                                <b>Email Template Name:</b><br />
                                <asp:TextBox ID="txtName" runat="server" ReadOnly="true" Enabled="false" Width="500px" />
                            </td>
                        </tr>
                        <tr>
                          <%--  <td valign="top">Designation:
                            </td>--%>
                            <td>
                              <b> Used For Designation:</b><br />
                                <asp:DropDownList ID="ddlDesignation" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlDesignation_SelectedIndexChanged" />
                                <asp:RequiredFieldValidator ID="rfvDesignation" runat="server" ControlToValidate="ddlDesignation"
                                    InitialValue="0" ValidationGroup="vgTemplate" Display="None"
                                    ErrorMessage="Please select designation." />
                                <br />
                                <small>Save a separate copy, if you want, for individual designations. Master copy will be used if designation specific copy is not available.</small>
                            </td>
                        </tr>
                        <tr id="trMasterCopy" runat="server" visible="false">
                            <td colspan="2" style="font-weight: bold;">We do not have designation specific copy for selected designation. So, we have loaded master copy in fields given below. You can modify and save designation specific copy.
                            </td>
                        </tr>
                        <tr id="trSubject" runat="server">
                            <%--<td valign="top">Subject:
                            </td>--%>
                            <td>
                               <b> Email Subject:</b><br />
                                <asp:TextBox ID="txtSubject" runat="server" MaxLength="3500" Width="90%" />
                                <asp:RequiredFieldValidator ID="rfvSubject" runat="server" ControlToValidate="txtSubject"
                                    InitialValue="" ValidationGroup="vgTemplate" Display="None"
                                    ErrorMessage="Please enter subject." />
                            </td>
                        </tr>
                        <tr>
                            <%--<td valign="top">Header:
                            </td>--%>
                            <td>
                              <b> Email Header: </b><br />
                                <asp:TextBox ID="txtHeader" runat="server" TextMode="MultiLine" Width="90%" />
                                <asp:RequiredFieldValidator ID="rfvHeader" runat="server" ControlToValidate="txtHeader"
                                    InitialValue="" ValidationGroup="vgTemplate" Display="None"
                                    ErrorMessage="Please enter header." />
                            </td>
                        </tr>
                        <tr>
                            <%--<td valign="top">Body:
                            </td>--%>
                            <td>
                               <b> Email Body:</b> <br />
                                <asp:TextBox ID="txtBody" runat="server" TextMode="MultiLine" Width="90%" />
                                <asp:RequiredFieldValidator ID="rfvBody" runat="server" ControlToValidate="txtBody"
                                    InitialValue="" ValidationGroup="vgTemplate" Display="None"
                                    ErrorMessage="Please enter body." />
                            </td>
                        </tr>
                        <tr>
                            <%--<td valign="top">Footer:
                            </td>--%>
                            <td>
                               <b>Email Footer:</b><br />
                                <asp:TextBox ID="txtFooter" runat="server" TextMode="MultiLine" Width="90%" />
                                <asp:RequiredFieldValidator ID="rfvFooter" runat="server" ControlToValidate="txtFooter"
                                    InitialValue="" ValidationGroup="vgTemplate" Display="None"
                                    ErrorMessage="Please enter footer." />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <div class="btn_sec">
                                    <asp:Button ID="btnSaveTemplate" runat="server" Text="Save" OnClick="btnSaveTemplate_Click" ValidationGroup="vgTemplate" />
                                    <asp:Button ID="btnRevertToMaster" runat="server" Text="Revert To Master" OnClick="btnRevertToMaster_Click" />
                                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <script src='<%=Page.ResolveUrl("~/ckeditor/ckeditor.js") %>'></script>

    <script type="text/javascript">

        var prmEmailTemplate = Sys.WebForms.PageRequestManager.getInstance();

        prmEmailTemplate.add_beginRequest(function () {
            DestroyCKEditors();
        });

        prmEmailTemplate.add_endRequest(function () {
            EmailTemplate_Initialize();
        });

        $(document).ready(function () {
            EmailTemplate_Initialize();
        });

        function EmailTemplate_Initialize() {
            SetCKEditor('<%=txtHeader.ClientID%>');
            SetCKEditor('<%=txtBody.ClientID%>');
            SetCKEditor('<%=txtFooter.ClientID%>');
        }
    </script>
</asp:Content>
