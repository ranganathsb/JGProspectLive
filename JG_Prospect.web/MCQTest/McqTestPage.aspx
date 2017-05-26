<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" CodeBehind="McqTestPage.aspx.cs" Inherits="JG_Prospect.MCQTest.McqTestPage" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <link href="../css/screen.css" rel="stylesheet" media="screen" type="text/css" />
    <link href="../css/jquery-ui.css" rel="stylesheet" />

    <style>
        .tblResult {
            text-align-last: auto;
            width: 100%;
            padding: 50px;
        }

            .tblResult tr td {
                background: url('../img/line.png') repeat-x 50% bottom;
                padding: 10px 15px 12px 15px;
            }

        .tblExamStartup {
            width: 100%;
            padding: 50px;
        }
    </style>
</head>
<body style="background: none;">
    <form id="form1" method="post" runat="server">
        <div>
            <ajaxToolkit:ToolkitScriptManager ID="scmExam" runat="server" AsyncPostBackTimeout="360000">
                <Services>
                </Services>
            </ajaxToolkit:ToolkitScriptManager>
            <asp:UpdateProgress ID="upnlProgress" class="examProgress" runat="server">
                <ProgressTemplate>
                    ...Loading
                </ProgressTemplate>
            </asp:UpdateProgress>
        </div>
        <h2>Thank you for applying JMGrove, This is timebound test, so once you start the test you will not be able to Stop/Restart/Pause the test.</h2>
        <div id="divExams" style="text-align: center; align-items: center; border: 2px solid #e55456; margin: 0 0 5px 0;">
            <h6>Click on Take Test button link to start exam</h6>
            <!-- Repeater to load exam titles -->

            <asp:UpdatePanel ID="upnlMainExams" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Repeater ID="rptExams" runat="server" OnItemDataBound="rptExams_ItemDataBound">
                        <HeaderTemplate>
                            <table>
                                <tbody>
                                    <tr class="trHeader">
                                        <th>
                                            <h5>Exam  </h5>
                                        </th>

                                        <th>
                                            <h5>Duration</h5>
                                        </th>
                                        <th>
                                            <h5>Result</h5>
                                        </th>
                                    </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <asp:Literal ID="ltlExamId" runat="server" Visible="false" Text='<%#Eval("ExamID")%>'></asp:Literal><strong><%#Eval("ExamTitle")%></strong></td>
                                <td><%#Eval("ExamDuration")%> Mins</td>
                                <td>
                                   <asp:Label ID="lblMarks" runat="server"></asp:Label><br />
                                   <asp:Label ID="lblPercentage" runat="server"></asp:Label><br />
                                    <asp:Label ID="lblResult" runat="server"></asp:Label>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </tbody>
                    </table>
                        </FooterTemplate>
                    </asp:Repeater>
                </ContentTemplate>
            </asp:UpdatePanel>

        </div>
        <div id="divTakeExam" runat="server" style="text-align: center;">
            <asp:Button ID="btnTakeTest" Text="Take Test" CssClass="ui-button" runat="server" OnClick="btnTakeTest_Click" />
            <asp:Button ID="btnCancelTest" runat="server" Text="Cancel Test" CssClass="ui-button" />
        </div>

        <div id="divExamSection" runat="server" visible="false" class="mcqquesMain">

            <asp:UpdatePanel ID="upnlExamSection" runat="server" UpdateMode="Conditional">
                <ContentTemplate>

                    <!-- Questions Section Start-->
                    <asp:Repeater ID="rptQuestions" runat="server" OnItemCommand="rptQuestions_ItemCommand">
                        <HeaderTemplate>
                            <ul>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <li class="mcqques">
                                <asp:LinkButton ID="hypQuestion" runat="server" CommandName="LoadQuestion" Text='<%#String.Concat("Q",(Container.ItemIndex + 1).ToString()) %>' CommandArgument='<%#Eval("QuestionID") %>'></asp:LinkButton>
                                <asp:Literal ID="ltlQuestionText" runat="server" Visible="false" Text='<%#Eval("Question") %>' />
                                <asp:HiddenField ID="hdnPMarks" runat="server" Value='<%#Eval("PositiveMarks") %>' />
                                <asp:HiddenField ID="hdnNMarks" runat="server" Value='<%#Eval("NegetiveMarks") %>' />
                            </li>

                        </ItemTemplate>
                        <FooterTemplate>
                            </ul>
                        </FooterTemplate>

                    </asp:Repeater>
                    <!-- Questions Section Ends-->
                    <div id="divQues" class="mcqQuestion">
                        <asp:Literal ID="ltlQuesNo" runat="server"></asp:Literal>
                        <asp:Literal ID="ltlQuestionTitle" runat="server"></asp:Literal>
                        <asp:RadioButtonList ID="rblQuestionOptions" AutoPostBack="true" runat="server" OnSelectedIndexChanged="rblQuestionOptions_SelectedIndexChanged"></asp:RadioButtonList>
                        <asp:HiddenField ID="hdnPMarks" runat="server" />
                        <asp:HiddenField ID="hdnNMarks" runat="server" />
                        <asp:HiddenField ID="hdnCorrectAnswer" runat="server" />
                    </div>

                    <div id="divEndExam" class="endExam" visible="false" runat="server">
                        <asp:Button ID="btnEndExam" runat="server" CssClass="ui-button" OnClick="btnEndExam_Click" Text="Submit Exam/View Result" />
                    </div>

                </ContentTemplate>
            </asp:UpdatePanel>

        </div>
        <div class="hide">
            <p class="hide">
                <asp:Label ID="Label1" runat="server" BackColor="RosyBrown"></asp:Label>
            </p>
            <p>
                <asp:Label ID="lblSPI" runat="server" Text=""></asp:Label>
            </p>

        </div>

    </form>
</body>
</html>
