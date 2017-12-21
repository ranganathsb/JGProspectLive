<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="screening-popup.aspx.cs" Inherits="JG_Prospect.screening_popup" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
   
    <link href="css/popup.css" rel="stylesheet" />
    <link rel="stylesheet" href="css/jquery-ui.css" />
   
</head>
<body>
    <form id="form1" runat="server">
        <div class="profiletitle">
            <h2>Complete your profile</h2>
            <p><span class="redtext">*</span><label>All fields are mandatory</label></p>
        </div>
        <div class="clear">

        </div>
        <div class="profilediv">
            <table class="profiletable">
                <tr>
                    <td>Position applying for: <span class="redtext">*</span><br />
                        <asp:DropDownList ID="ddlPositionAppliedFor" CssClass="emp-ddl" TabIndex="1" AppendDataBoundItems="true" runat="server" ClientIDMode="Static" AutoPostBack="false">
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvPositionApplied" runat="server" ControlToValidate="ddlPositionAppliedFor"
                            ValidationGroup="vgQuickSave" ForeColor="Red" Display="Dynamic" CssClass="emp-ddl" ErrorMessage="Please Select Designation"
                            InitialValue="-1"></asp:RequiredFieldValidator>
                    </td>
                    <td>Source: <span class="redtext">*</span><br />
                        <asp:DropDownList ID="ddlSource" CssClass="emp-ddl" runat="server" AutoPostBack="false" TabIndex="2">
                        </asp:DropDownList></td>
                </tr>
                <tr>
                    <td>
                        <asp:TextBox ID="txtfirstname" CssClass="emp-txtbox" Placeholder="First Name*" runat="server" MaxLength="40" autocomplete="off" EnableViewState="false" AutoCompleteType="None" TabIndex="3"></asp:TextBox><asp:TextBox ID="txtMiddleInitial" Placeholder="I*" runat="server" CssClass="emp-txtbox emp-txtboxsmall" MaxLength="3" TabIndex="4"></asp:TextBox></td>
                    <td>
                        <asp:TextBox ID="txtlastname" CssClass="emp-txtbox" Placeholder="Last Name*" runat="server" MaxLength="40" autocomplete="off"
                            TabIndex="5"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <asp:DropDownList ID="ddlCountry" CssClass="emp-ddl" runat="server" TabIndex="6"></asp:DropDownList></td>
                </tr>
                <tr>
                    <td>
                        <asp:TextBox ID="txtZip" CssClass="emp-txtbox" Placeholder="Zip*" runat="server" MaxLength="10" TabIndex="7"></asp:TextBox></td>
                    <td>
                        <asp:TextBox ID="txtCity" CssClass="emp-txtbox" Placeholder="City*" runat="server" MaxLength="50" TabIndex="8"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>
                        <asp:TextBox ID="txtState" CssClass="emp-txtbox" Placeholder="State*" runat="server" MaxLength="50" TabIndex="9"></asp:TextBox></td>
                    <td></td>
                </tr>
                <tr>
                    <td><br />
                        <asp:TextBox ID="txtAddress" CssClass="emp-mltxtbox" Placeholder="Address*" runat="server" TextMode="MultiLine" TabIndex="10"></asp:TextBox></td>
                    <td>Reason for leaving your current job(if applicable) : <span class="redtext">*</span><br />
                        <asp:TextBox ID="txtReasontoLeave" CssClass="emp-mltxtbox" runat="server" MaxLength="50" TextMode="MultiLine" TabIndex="11"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>
                        <asp:TextBox ID="txtPhone" CssClass="emp-txtbox" ValidationGroup="vgQuickSave" TabIndex="12" Placeholder="Phone * - Ex. (111)-111-1111" runat="server"></asp:TextBox></td>
                    <td>
                        <asp:TextBox ID="txtEmailQs" CssClass="emp-txtbox" ValidationGroup="vgQuickSave" Placeholder="Email*" TabIndex="13" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <table>
                            <tr>
                                <td>Contact Preference<span class="redtext">*</span>
                                </td>
                                <td>
                                    <asp:CheckBox ID="ContactPreferenceChkEmail" TabIndex="14" runat="server" Checked="true" Text="Email" />
                                </td>
                                <td>
                                    <asp:CheckBox ID="ContactPreferenceChkCall" TabIndex="15" runat="server" Text="Call" />
                                </td>
                                <td>
                                    <asp:CheckBox ID="ContactPreferenceChkText" TabIndex="16" runat="server" Text="Text" />
                                </td>
                                <td>
                                    <asp:CheckBox ID="ContactPreferenceChkMail" TabIndex="17" runat="server" Text="Mail" />
                                </td>
                            </tr>
                        </table>
                    </td>

                </tr>
                <tr>
                    <td>
                        <asp:TextBox ID="txtStartDate" CssClass="emp-txtbox date" Placeholder="Available Start Date*" TabIndex="18" onkeypress="return false" runat="server"></asp:TextBox></td>
                    <td>Job Type: <span class="redtext">*</span><br />
                        <asp:DropDownList ID="ddlEmpType" CssClass="emp-ddl" runat="server" TabIndex="19" AutoPostBack="false">
                            <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                            <asp:ListItem Text="Temp" Value="6"></asp:ListItem>
                            <asp:ListItem Text="Internship" Value="5"></asp:ListItem>
                            <asp:ListItem Text="Part Time - Remote" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Part Time - Onsite" Value="3"></asp:ListItem>
                            <asp:ListItem Text="Full Time - Remote" Value="2"></asp:ListItem>
                            <asp:ListItem Text="Full Time - Onsite" Value="4"></asp:ListItem>
                            <asp:ListItem Text="Full Time Hourly" Value="Full Time Hourly"></asp:ListItem>
                            <asp:ListItem Text="Full Time Salary" Value="Full Time Salary"></asp:ListItem>
                            <asp:ListItem Text="Part Time" Value="Part Time"></asp:ListItem>
                            <asp:ListItem Text="Sub" Value="7"></asp:ListItem>
                        </asp:DropDownList></td>
                </tr>
                <tr>
                    <td>Salary Requirements<span class="redtext">*</span><asp:TextBox ID="txtSalaryRequirments" CssClass="emp-txtbox" TabIndex="20" runat="server"></asp:TextBox></td>
                    <td>Are you currently employed?<span class="redtext">*</span><asp:RadioButtonList ID="rblEmployed" RepeatDirection="Horizontal" RepeatLayout="Flow" TabIndex="21" runat="server">
                        <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                        <asp:ListItem Text="No" Value="0"></asp:ListItem>
                    </asp:RadioButtonList></td>
                </tr>
                <tr>
                    <td>Will you be able to pass a drug test and background check?<span class="redtext">*</span><asp:RadioButtonList ID="rblDrugTest" RepeatDirection="Horizontal" RepeatLayout="Flow" TabIndex="22" runat="server">
                        <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                        <asp:ListItem Text="No" Value="0"></asp:ListItem>
                    </asp:RadioButtonList></td>
                    <td>Have you ever plead guilty to a Felony or been convicted of crime?<span class="redtext">*</span><asp:RadioButtonList ID="rblFelony" RepeatDirection="Horizontal" RepeatLayout="Flow" TabIndex="23" runat="server">
                        <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                        <asp:ListItem Text="No" Value="0"></asp:ListItem>
                    </asp:RadioButtonList></td>
                </tr>
                <tr>
                    <td>Have you ever plead guilty to a Felony or been convicted of crime?<span class="redtext">*</span><asp:RadioButtonList ID="rblWorkedForJMG" RepeatDirection="Horizontal" RepeatLayout="Flow" TabIndex="24" runat="server">
                        <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                        <asp:ListItem Text="No" Value="0"></asp:ListItem>
                    </asp:RadioButtonList></td>
                    <td>
                        <asp:TextBox ID="txtMessageToRecruiter" CssClass="emp-mltxtbox" Placeholder="Message to Recruiter*" runat="server" TextMode="MultiLine" RepeatDirection="Horizontal" RepeatLayout="Flow" TabIndex="25"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Attach resume with References<span class="redtext">*</span><br />
                        <asp:FileUpload ID="fupResume" TabIndex="26" runat="server" />
                        <br />
                        <span class="text-small text-disabled">(resume size should be less than 2MB , extention allowed: pdf|doc|txt|gif|jpg|png|jpeg)</span>
                    </td>
                    <td>Attach profile picture<span class="redtext">*</span><br />
                        <asp:FileUpload ID="fupProfilePic" TabIndex="27" runat="server" />
                        <br />
                        <span class="text-small text-disabled">(resume size should be less than 2MB , extention allowed: pdf|doc|txt|gif|jpg|png|jpeg)</span>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <input type="submit" value="Submit" class="InputBtn" />
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
