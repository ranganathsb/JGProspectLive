<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" CodeBehind="email-template-maintainance.aspx.cs" 
    Inherits="JG_Prospect.Sr_App.email_template_maintainance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:GridView ID="grdHtmlTemplates" runat="server"  AutoGenerateColumns="true" DataKeyNames="Id"
        CssClass="table" Width="100%" CellSpacing="0" CellPadding="0" GridLines="Vertical">
        <EmptyDataRowStyle ForeColor="White" HorizontalAlign="Center" />
        <HeaderStyle CssClass="trHeader " />
        <RowStyle CssClass="FirstRow" BorderStyle="Solid" />
        <AlternatingRowStyle CssClass="AlternateRow " />
        <Columns>

        </Columns>
    </asp:GridView>
</asp:Content>
