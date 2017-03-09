<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" CodeBehind="view-aptitude-test.aspx.cs"
    Inherits="JG_Prospect.Sr_App.view_aptitude_test" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_panel">
        <!-- appointment tabs section start -->
        <ul class="appointment_tab">
            <li><a href="Price_control.aspx">Product Line Estimate</a></li>
            <li><a href="Inventory.aspx">Inventory</a></li>
            <li><a href="Maintenace.aspx">Maintainance</a></li>
            <li><a href="email-template-maintainance.aspx">Maintainance New</a></li>
            <li><a href="manage-aptitude-tests.aspx.aspx">Aptitude Tests</a></li>
        </ul>
        <!-- appointment tabs section end -->
        <h1>Aptitude Test</h1>
        <div>
            <fieldset>
                <legend>Exam Details</legend>
                <table width="100%">
                    <tr>
                        <th width="100">Title:</th>
                        <td colspan="5"><asp:Literal ID="ltrlTitle" runat="server" /> <img id="imgActive" runat="server" /></td>
                    </tr>
                    <tr>
                        <th width="100">Description:</th>
                        <td colspan="5"><asp:Literal ID="ltrlDescription" runat="server" /></td>
                    </tr>
                    <tr>
                        <th width="100">Designation:</th>
                        <td><asp:Literal ID="ltrlDesignation" runat="server" /></td>
                        <th width="80">Duration:</th>
                        <td width="100"><asp:Literal ID="ltrlDuration" runat="server" /></td>
                        <th width="120">Pass Percentage:</th>
                        <td><asp:Literal ID="ltrlPassPercentage" runat="server" /></td>
                    </tr>
                    <tr>
                        <td colspan="6">
                            <strong>Questions:</strong>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Repeater ID="repQuestions" runat="server">
                                <HeaderTemplate>
                                    <table>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td width="10">
                                            <%# (Container.ItemIndex + 1) + "." %>
                                        </td>
                                        <td width="">
                                            <b><%# Eval("Question") %></b>
                                        </td>
                                        <td width="250">
                                            <b>Positive Marks</b> : <%# Eval("PositiveMarks") %> , <b>Negetive Marks</b> : <%# Eval("NegetiveMarks") %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <asp:Repeater ID="repOptions" runat="server" DataSource='<%# GetOptionsByQuestionID(Convert.ToInt64(Eval("QuestionID"))) %>'>
                                                <HeaderTemplate>
                                                    <ol>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <li style="float:left; width: 30%;">
                                                        <span style='<%# IsCorrectAnswer(Convert.ToInt64(Eval("QuestionID")), Convert.ToInt64(Eval("OptionID")))? "font-weight:bold;":"" %>'>
                                                            <%# Eval("OptionText") %>
                                                        </span>
                                                    </li>
                                                </ItemTemplate>
                                                <FooterTemplate>
                                                    </ol>
                                                </FooterTemplate>
                                            </asp:Repeater>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </div>
    </div>
</asp:Content>
