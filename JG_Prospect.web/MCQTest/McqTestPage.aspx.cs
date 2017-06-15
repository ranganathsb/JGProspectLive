using System;
using System.Data;
using System.Drawing;
using JG_Prospect.BLL;
using JG_Prospect.Common;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Collections;
using System.Collections.Generic;
using JG_Prospect.Common.modal;
using System.Net.Mail;
using System.IO;
using JG_Prospect.App_Code;
using System.Globalization;
using System.Web;

namespace JG_Prospect.MCQTest
{
    public partial class McqTestPage : System.Web.UI.Page
    {
        #region "-- Properties --"

        public int UserID
        {
            get
            {
                int intUserID = 0;
                if (ViewState["UserID"] != null)
                {
                    Int32.TryParse(ViewState["UserID"].ToString(), out intUserID);
                }
                return intUserID;
            }
            set
            {
                ViewState["UserID"] = value;
            }
        }
        public int CurrentExamID
        {
            get
            {
                int ExamID = 0;
                if (ViewState["CEXAMID"] != null)
                {
                    Int32.TryParse(ViewState["CEXAMID"].ToString(), out ExamID);
                }
                return ExamID;
            }
            set
            {
                ViewState["CEXAMID"] = value;
            }
        }

        public int NextExamSeq
        {
            get
            {
                int ExamID = 0;
                if (ViewState["NEXAMID"] != null)
                {
                    Int32.TryParse(ViewState["NEXAMID"].ToString(), out ExamID);
                }
                return ExamID;
            }
            set
            {
                ViewState["NEXAMID"] = value;
            }
        }

        public int CurrentQuestion
        {
            get
            {
                int QueID = 0;
                if (ViewState["CQID"] != null)
                {
                    Int32.TryParse(ViewState["CQID"].ToString(), out QueID);
                }
                return QueID;
            }
            set
            {
                ViewState["CQID"] = value;
            }
        }

        public int NextQuestion
        {
            get
            {
                int QueID = 0;
                if (ViewState["NQID"] != null)
                {
                    Int32.TryParse(ViewState["NQID"].ToString(), out QueID);
                }
                return QueID;
            }
            set
            {
                ViewState["NQID"] = value;
            }
        }
        public int TotalQuestions
        {
            get
            {
                int QueID = 0;
                if (ViewState["TQ"] != null)
                {
                    Int32.TryParse(ViewState["TQ"].ToString(), out QueID);
                }
                return QueID;
            }
            set
            {
                ViewState["TQ"] = value;
            }
        }

        public int TotalExams
        {
            get
            {
                int QueID = 0;
                if (ViewState["TEX"] != null)
                {
                    Int32.TryParse(ViewState["TEX"].ToString(), out QueID);
                }
                return QueID;
            }
            set
            {
                ViewState["TEX"] = value;
            }
        }

        public String ExamsGiven
        {
            get
            {
                String strExamsGiven = String.Empty;
                if (ViewState["EXAMGiven"] != null)
                {
                    strExamsGiven = ViewState["EXAMGiven"].ToString();
                }
                return strExamsGiven;
            }
            set
            {
                ViewState["EXAMGiven"] = value;
            }

        }

        /// <summary>
        /// Stores user question with QuestionID as a Key
        /// Value (seperated by '-'):- 1. User Answer 2. Correct Answer 3. Positive Marks  4. Negative Marks
        /// </summary>
        public Dictionary<int, string> ExamAttempted
        {
            get
            {
                Dictionary<int, string> ExamAttempt = new Dictionary<int, string>();
                if (ViewState["EXATEMP"] != null)
                {
                    ExamAttempt = (Dictionary<int, string>)ViewState["EXATEMP"];
                }
                return ExamAttempt;
            }
            set
            {
                ViewState["EXATEMP"] = value;
            }

        }

        public int DesignationID
        {
            get
            {
                int intDesignID = 0;
                if (ViewState["DesignID"] != null)
                {
                    Int32.TryParse(ViewState["DesignID"].ToString(), out intDesignID);
                }
                return intDesignID;
            }
            set
            {
                ViewState["DesignID"] = value;
            }

        }

        public String DesignationName
        {
            get
            {
                String strDesign = String.Empty;
                if (ViewState["DGName"] != null)
                {
                    strDesign = ViewState["DGName"].ToString();
                }
                return strDesign;
            }
            set
            {
                ViewState["DGName"] = value;
            }

        }

        #endregion

        #region "-- Page Methods --"
        protected void Page_Load(object sender, EventArgs e)
        {
            //Display Page Timer.
            SetTimerOnPage();
            if (!Page.IsPostBack)
            {
                if (Session["ID"] != null)
                    if (Session["ID"].ToString() != "")
                    {
                        UserID = Convert.ToInt32(Session["ID"]);
                        populateExams();
                        //populateLabel();
                        //populatePerformanceArea();
                    }
            }
        }

        #endregion

        #region "-- Control Events --"


        protected void btnCancelTest_Click(object sender, EventArgs e)
        {
            LogoutUser(false);

        }
        protected void btnTakeTest_Click(object sender, EventArgs e)
        {
            StartExam();
        }

        protected void rptQuestions_ItemCommand(object source, RepeaterCommandEventArgs e)
        {

            if (e.CommandName == "LoadQuestion")
            {
                SetQuestionUI(e.Item);

            }
        }

        protected void rblQuestionOptions_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Get user attempted answer
            String Answer = rblQuestionOptions.SelectedItem.Value;
            String correctAnswer = hdnCorrectAnswer.Value;
            String PMarks = hdnPMarks.Value;
            String NMarks = hdnNMarks.Value;


            // Check user's attempts
            Dictionary<int, string> dicExamAttempted = this.ExamAttempted;

            // if user has already attempted question than update its answer.
            if (dicExamAttempted.ContainsKey(this.CurrentQuestion))
            {
                // Store QuestionID,User Answer, Correct Answer, Positive Marks, Negative Marks
                dicExamAttempted[this.CurrentQuestion] = String.Concat(Answer, "-", correctAnswer, "-", PMarks, "-", NMarks);
            }
            else // else add new attempted question
            {
                // Store QuestionID,User Answer, Correct Answer, Positive Marks, Negative Marks
                dicExamAttempted.Add(this.CurrentQuestion, String.Concat(Answer, "-", correctAnswer, "-", PMarks, "-", NMarks));

            }

            this.ExamAttempted = dicExamAttempted;

            MarkQuestionAsAttempted();

            LoadNextQuestion();

            CheckExamCompletion();

        }

        protected void btnEndExam_Click(object sender, EventArgs e)
        {
            CountExamResultandReset();
        }


        protected void rptExams_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            //Result data available
            if (DataBinder.Eval(e.Item.DataItem, "MarksEarned") != null && !String.IsNullOrEmpty(DataBinder.Eval(e.Item.DataItem, "MarksEarned").ToString()))
            {
                Label lblMarks = (Label)e.Item.FindControl("lblMarks");
                Label lblPercentage = (Label)e.Item.FindControl("lblPercentage");
                Label lblResult = (Label)e.Item.FindControl("lblResult");

                lblMarks.Text = String.Concat("Marks Obtained: ", DataBinder.Eval(e.Item.DataItem, "MarksEarned").ToString(), "/", DataBinder.Eval(e.Item.DataItem, "TotalMarks").ToString());
                lblPercentage.Text = String.Concat("Percentage Obtained: ", DataBinder.Eval(e.Item.DataItem, "Aggregate").ToString());

                if (Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "ExamPerformanceStatus").ToString()) > 0)
                {
                    lblResult.CssClass = "greentext";
                    lblResult.Text = "Pass";
                }
                else
                {
                    lblResult.CssClass = "redtext";
                    lblResult.Text = "Fail";
                }
            }
        }

        #endregion

        #region "-- Private Methods --"

        private void AssignedTaskToUser(int UserId, UInt64 TaskId, UInt64 ParentTaskId, String TaskTitle, String InstallId)
        {
            string ApplicantId = UserID.ToString();

            // save (insert / delete) assigned users.

            // save assigned user a TASK.
            bool isSuccessful = TaskGeneratorBLL.Instance.SaveTaskAssignedToMultipleUsers(TaskId, ApplicantId);

            // Change task status to assigned = 3.
            if (isSuccessful)
                UpdateTaskStatus(TaskId, Convert.ToUInt16(JGConstant.TaskStatus.Assigned));

            SendEmailToAssignedUsers(ApplicantId, ParentTaskId.ToString(), TaskId.ToString(), TaskTitle, InstallId);

        }

        private void UpdateTaskStatus(UInt64 taskId, UInt16 Status)
        {
            Task task = new Task();
            task.TaskId = Convert.ToInt32(taskId);
            task.Status = Status;

            int result = TaskGeneratorBLL.Instance.UpdateTaskStatus(task);    // save task master details

        }

        private void SendEmailToAssignedUsers(string strInstallUserIDs, string strTaskId, string strSubTaskId, string strTaskTitle, String InstallId)
        {
            try
            {
                //string strHTMLTemplateName = "Task Generator Auto Email";
                //DataSet dsEmailTemplate = AdminBLL.Instance.GetEmailTemplate(strHTMLTemplateName, 108);

                DesignationHTMLTemplate objHTMLTemplate = HTMLTemplateBLL.Instance.GetDesignationHTMLTemplate(HTMLTemplates.Task_Generator_Auto_Email, JGSession.DesignationId.ToString());

                foreach (string userID in strInstallUserIDs.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
                {
                    DataSet dsUser = TaskGeneratorBLL.Instance.GetInstallUserDetails(Convert.ToInt32(userID));

                    string emailId = dsUser.Tables[0].Rows[0]["Email"].ToString();
                    string FName = dsUser.Tables[0].Rows[0]["FristName"].ToString();
                    string LName = dsUser.Tables[0].Rows[0]["LastName"].ToString();
                    string fullname = FName + " " + LName;

                    //string strHeader = dsEmailTemplate.Tables[0].Rows[0]["HTMLHeader"].ToString();
                    //string strBody = dsEmailTemplate.Tables[0].Rows[0]["HTMLBody"].ToString();
                    //string strFooter = dsEmailTemplate.Tables[0].Rows[0]["HTMLFooter"].ToString();
                    //string strsubject = dsEmailTemplate.Tables[0].Rows[0]["HTMLSubject"].ToString();
                    string strHeader = objHTMLTemplate.Header;
                    string strBody = objHTMLTemplate.Body;
                    string strFooter = objHTMLTemplate.Footer;
                    string strsubject = objHTMLTemplate.Subject;

                    strsubject = strsubject.Replace("#ID#", strTaskId);
                    strsubject = strsubject.Replace("#TaskTitleID#", strTaskTitle);
                    strsubject = strsubject.Replace("#TaskTitle#", strTaskTitle);

                    strBody = strBody.Replace("#ID#", strTaskId);
                    strBody = strBody.Replace("#TaskTitleID#", strTaskTitle);
                    strBody = strBody.Replace("#TaskTitle#", strTaskTitle);
                    strBody = strBody.Replace("#Fname#", fullname);
                    strBody = strBody.Replace("#email#", emailId);

                    strBody = strBody.Replace("#Designation(s)#", this.DesignationName);
                    strBody = strBody.Replace("#TaskLink#", string.Format(
                                                                            "{0}?TaskId={1}&hstid={2}",
                                                                            string.Concat(
                                                                                            Request.Url.Scheme,
                                                                                            Uri.SchemeDelimiter,
                                                                                            Request.Url.Host,
                                                                                            "/Sr_App/TaskGenerator.aspx"
                                                                                         ),
                                                                            strTaskId,
                                                                            strSubTaskId
                                                                        )
                                            );

                    strBody = strHeader + strBody + strFooter;

                    string strHTMLTemplateName = "Task Generator Auto Email";
                    DataSet dsEmailTemplate = AdminBLL.Instance.GetEmailTemplate(strHTMLTemplateName, 108);
                    List<Attachment> lstAttachments = new List<Attachment>();
                    // your remote SMTP server IP.
                    for (int i = 0; i < dsEmailTemplate.Tables[1].Rows.Count; i++)
                    {
                        string sourceDir = Server.MapPath(dsEmailTemplate.Tables[1].Rows[i]["DocumentPath"].ToString());
                        if (File.Exists(sourceDir))
                        {
                            Attachment attachment = new Attachment(sourceDir);
                            attachment.Name = Path.GetFileName(sourceDir);
                            lstAttachments.Add(attachment);
                        }
                    }

                    CommonFunction.SendEmail(HTMLTemplates.Task_Generator_Auto_Email.ToString(), emailId, strsubject, strBody, lstAttachments);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("{0} Exception caught.", ex);
            }
        }

        private void LoadNextQuestion()
        {
            int repeaterItemIndex = 0;

            // If next question is set then load its detail, else load by default first question.
            if (this.NextQuestion > 0)
            {
                repeaterItemIndex = this.NextQuestion;
            }

            RepeaterItem rptQuestionItem = rptQuestions.Items[repeaterItemIndex];

            SetQuestionUI(rptQuestionItem);
        }

        private void populateExams()
        {
            DataTable dsExams = AptitudeTestBLL.Instance.GetExamsByUserID(UserID);
            if (dsExams != null && dsExams.Rows.Count > 0)
            {

                this.TotalExams = dsExams.Rows.Count;
                this.DesignationID = Convert.ToInt32(dsExams.Rows[0]["DesignationID"].ToString());
                this.DesignationName = Convert.ToString(dsExams.Rows[0]["Designation"].ToString());

                rptExams.DataSource = dsExams;
                rptExams.DataBind();
                upnlMainExams.Update();
            }
        }

        private void populateLabel()
        {
            DataTable examsNotWrittenYet = AptitudeTestBLL.Instance.GetExamByExamID(Enums.Aptitude_ExamType.DotNet, UserID);

            if (examsNotWrittenYet.Rows.Count == 0)
            {
                Label1.ForeColor = Color.DarkBlue;
                Label1.Text = "";
            }
            else
            {
                string buff = "<table class='tblExamStartup' bgcolor=white>";

                foreach (DataRow ExamRow in examsNotWrittenYet.Rows)
                {
                    //if (Enums.Aptitude_ExamType.DotNet.GetHashCode() == (int)ExamRow["ExamType"])
                    {
                        String url = "StartExam";
                        buff += "<tr><td>Click on following link to Start Exam ";
                        buff += "</Br></Br></Br>";
                        buff += "<b><a href=" + url + ".aspx?exam_id=" + ExamRow["ExamID"].ToString() + ">" + ExamRow["ExamTitle"] + "</a></b></td>";
                        buff += "</tr>";
                        buff += "<tr><td> </Br></Br>" + ExamRow["ExamDescription"] + "</td>";
                        buff += "</Br></Br></Br></tr>";
                    }

                    buff += "</table>";
                    Label1.Text = buff;
                }
            }

        }

        private void SetExamSectionViews()
        {
            divTakeExam.Visible = false;
            divExamSection.Visible = true;
        }

        private void LoadQuestionsForExam()
        {
            DataTable questionTable = AptitudeTestBLL.Instance.GetQuestionsForExamByID(this.CurrentExamID.ToString());
            rptQuestions.DataSource = questionTable;

            rptQuestions.DataBind();

            //Set Exam Timeout Values in 
            SetExamTimerSessionValues(questionTable);

            SetTimerOnPage();

        }

        private void SetTimerOnPage()
        {
            // if exam start registration time available.
            if (JGSession.ExamTimerSetTime != null && divExamSection.Visible == true)
            {
                // Subtract Registered time from time now will yeild total time taken so far.
                TimeSpan TimeTaken = DateTime.Now.Subtract(Convert.ToDateTime(JGSession.ExamTimerSetTime));

                // Subtract total exam alloted time from time taken will yeild Time left to give exam.
                Double MilliSecondLeft = (JGSession.CurrentExamTime * 60000) - TimeTaken.TotalMilliseconds;

                //TODO: If timeup then call time up methods.

                // If time left to give exam then show that time.
                if (MilliSecondLeft > 0)
                {
                    int secondLeft = Convert.ToInt32(MilliSecondLeft * 0.001);
                    hdnTimeLeft.Value = secondLeft.ToString();
                    //ScriptManager.RegisterStartupScript(this,this.Page.GetType(), "timerDisplay", "startExamTimer(" + secondLeft.ToString() + ");", true); 
                }

            }
        }

        private void SetExamTimerSessionValues(DataTable questionTable)
        {
            // Set when exam time started.
            JGSession.ExamTimerSetTime = DateTime.Now;
            JGSession.CurrentExamTime = Convert.ToInt32(questionTable.Rows[0]["ExamDuration"]);

        }

        private void SetQuestionUI(RepeaterItem e)
        {
            LinkButton hypQuestion = (LinkButton)e.FindControl("hypQuestion");

            //hypQuestion.CssClass = "greentext";

            int QuestionID = Convert.ToInt32(hypQuestion.CommandArgument);

            String Question = ((Literal)(e.FindControl("ltlQuestionText"))).Text;

            this.CurrentQuestion = QuestionID;

            // Set next question to load, if it reaches last question, set it to first question.
            this.NextQuestion = e.ItemIndex == rptQuestions.Items.Count - 1 == true ? 0 : e.ItemIndex + 1;

            ltlQuesNo.Text = String.Concat("Q", (e.ItemIndex + 1).ToString());
            ltlQuestionTitle.Text = Question;

            hdnPMarks.Value = ((HiddenField)(e.FindControl("hdnPMarks"))).Value;
            hdnNMarks.Value = ((HiddenField)(e.FindControl("hdnNMarks"))).Value;

            SetAnswerOptions(QuestionID);

            SetCorrectAnswer(QuestionID);
        }

        private void SetAnswerOptions(int QuestionID)
        {
            DataTable optionData = AptitudeTestBLL.Instance.GetQuestionsoptionByQustionID(QuestionID);

            rblQuestionOptions.DataSource = optionData;
            rblQuestionOptions.DataTextField = "OptionText";
            rblQuestionOptions.DataValueField = "OptionID";

            rblQuestionOptions.DataBind();

            //if question is already attempted, set answer earlier given as preselected.
            if (this.ExamAttempted.ContainsKey(QuestionID))
            {
                String attemptedanswer = getUserAttemptedAnswerFromString(this.ExamAttempted[QuestionID]);

                ListItem answer = rblQuestionOptions.Items.FindByValue(attemptedanswer);

                if (answer != null)
                {
                    rblQuestionOptions.SelectedIndex = rblQuestionOptions.Items.IndexOf(answer);
                }

            }
        }

        /// <summary>
        /// Return Attempted answer from Value
        /// (seperated by '-'): 1. User Answer 2. Correct Answer 3. Positive Marks  4. Negative Marks
        /// </summary>
        /// <param name="examAttemptString"></param>
        /// <returns>1. User Answer</returns>
        private string getUserAttemptedAnswerFromString(string examAttemptString)
        {
            return (examAttemptString.Split(new char[] { '-' }, StringSplitOptions.RemoveEmptyEntries))[0];
        }

        /// <summary>
        /// Return Correct answer from Value
        /// (seperated by '-'): 1. User Answer 2. Correct Answer 3. Positive Marks  4. Negative Marks
        /// </summary>
        /// <param name="examAttemptString"></param>
        /// <returns>2. Correct Answer</returns>
        private string getCorrectAnswerFromString(string examAttemptString)
        {
            return (examAttemptString.Split(new char[] { '-' }, StringSplitOptions.RemoveEmptyEntries))[1];
        }

        /// <summary>
        /// Return Positive mark from Value
        /// (seperated by '-'): 1. User Answer 2. Correct Answer 3. Positive Marks  4. Negative Marks
        /// </summary>
        /// <param name="examAttemptString"></param>
        /// <returns>3. Positive Marks</returns>
        private string getPMarkForAnswerFromString(string examAttemptString)
        {
            return (examAttemptString.Split(new char[] { '-' }, StringSplitOptions.RemoveEmptyEntries))[2];
        }

        /// <summary>
        /// Return Negative mark from Value
        /// (seperated by '-'): 1. User Answer 2. Correct Answer 3. Positive Marks  4. Negative Marks
        /// </summary>
        /// <param name="examAttemptString"></param>
        /// <returns> 4. Negative Marks</returns>
        private string getNMarkForAnswerFromString(string examAttemptString)
        {
            return (examAttemptString.Split(new char[] { '-' }, StringSplitOptions.RemoveEmptyEntries))[3];
        }

        private void SetCorrectAnswer(int questionID)
        {
            DataTable correctAnswerData = AptitudeTestBLL.Instance.GetcorrectAnswerByQuestionID(questionID);
            if (correctAnswerData.Rows.Count > 0)
            {
                hdnCorrectAnswer.Value = correctAnswerData.Rows[0]["OptionID"].ToString();
            }
        }

        private void CheckExamCompletion()
        {
            // if user has attempted all questions.   
            if (this.ExamAttempted.Count == rptQuestions.Items.Count)
            {
                divEndExam.Visible = true;
            }
        }

        private void MarkQuestionAsAttempted()
        {

            int ItemIndex = this.NextQuestion - 1;

            if (ItemIndex < 0)// if last question in repeater then bydefault next question will be 0.
            {
                ItemIndex = rptQuestions.Items.Count - 1;
            }
            RepeaterItem item = rptQuestions.Items[ItemIndex];

            LinkButton hypQuestion = (LinkButton)item.FindControl("hypQuestion");

            if (hypQuestion != null)
            {
                hypQuestion.CssClass = "redtext";
            }
        }

        private void CountExamResultandReset()
        {
            Dictionary<int, string> examAttempted = this.ExamAttempted;

            double markScored = 0;
            double TotalMarks = 0;
            foreach (KeyValuePair<int, string> question in examAttempted)
            {
                int attemptedAnswer = Convert.ToInt32(getUserAttemptedAnswerFromString(question.Value));
                int correctAnswer = Convert.ToInt32(getCorrectAnswerFromString(question.Value));
                int PMark = Convert.ToInt32(getPMarkForAnswerFromString(question.Value));
                int NMark = Convert.ToInt32(getNMarkForAnswerFromString(question.Value));

                TotalMarks = TotalMarks + PMark;

                //if user has attempted correct answer then increase mark obtained.
                if (attemptedAnswer == correctAnswer)
                {
                    markScored = markScored + PMark;
                }
                else // if question has negative marking, minus, negative marks from users marks obtained.
                {
                    if (NMark > 0)
                    {
                        markScored = markScored - NMark;
                    }
                }

            }

            double percentageObtained = 0.0;
            percentageObtained = getUserPassingPercentage(TotalMarks, markScored);

            UpdateUserExamSummary((int)markScored, (int)TotalMarks, percentageObtained, this.CurrentExamID, this.UserID);

            ResetExamParameter();
        }

        private void ResetExamParameter()
        {

            this.ExamsGiven = String.Concat(this.ExamsGiven, this.CurrentExamID.ToString(), ",");

            this.CurrentQuestion = 0;
            this.ExamAttempted = null;
            this.NextQuestion = 0;
            this.CurrentExamID = 0;
            JGSession.ExamTimerSetTime = null;
            JGSession.CurrentExamTime = 0;

            String userExamsGiven = this.ExamsGiven;

            string[] exams = userExamsGiven.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

            bool isAllExamGiven = false;
            double overAllPercentageScored = 0;

            overAllPercentageScored = AptitudeTestBLL.Instance.GetExamsResultByUserID(UserID, ref isAllExamGiven);


            if (isAllExamGiven)// if user has finished attempting all available designation exams then check pass or fail result.
            {
                //All exams finished.

                // If obtained aggregated percentage is less than acceptable level, user is unfit to join JG.
                if (overAllPercentageScored < JGApplicationInfo.GetAcceptiblePrecentage())
                {
                    //Set User status as rejected.
                    UpdateUserStatusAsRejectedWithReason(UserID);
                    LogoutUser(true);

                }
                else // User is pass into our application.
                {
                    //Get latest task to be assigned for user's designation.
                    DataSet dsTaskToBeAssigned = TaskGeneratorBLL.Instance.GetDesignationTaskToAssignWithSequence(this.DesignationID, true);

                    if (dsTaskToBeAssigned != null && dsTaskToBeAssigned.Tables.Count > 0 && dsTaskToBeAssigned.Tables[0].Rows.Count > 0)
                    {
                        // Assign automatic task to user.
                        AssignedTaskToUser(UserID, Convert.ToUInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["TaskId"]), Convert.ToUInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["ParentTaskId"]), Convert.ToString(dsTaskToBeAssigned.Tables[0].Rows[0]["Title"]), Convert.ToString(dsTaskToBeAssigned.Tables[0].Rows[0]["InstallId"]));

                        //Update automatic task sequence  assignment
                        InsertAssignedTaskSequenceInfo(Convert.ToInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["TaskId"]), this.DesignationID, Convert.ToInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["AvailableSequence"]), true);

                        SetInterviewDateNTime();

                        SetExamPassedMessage(dsTaskToBeAssigned.Tables[0].Rows[0]["InstallId"].ToString(), dsTaskToBeAssigned.Tables[0].Rows[0]["Title"].ToString(), Convert.ToInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["TaskId"]), Convert.ToInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["ParentTaskId"]));

                        ScriptManager.RegisterStartupScript(this, this.Page.GetType(), "ExamPassed", "showExamPassPopup();", true);
                    }
                }

            }
            else
            {
                //Load exam with result again.
                populateExams();

                //Start next pending exam.
                StartExam();
            }


        }

        private void SetInterviewDateNTime()
        {

            int dayDifference = 5;

            DateTime InterviewDate = DateTime.Now.AddDays(dayDifference);
            DateTime FirstInterviewDate, SecondInterviewDate;
            TimeSpan InterviewTime, FirstInterviewTime, SecondInterviewTime;

            // Check Interview day of week, it should be only Monday, Wednesday, Friday
            // Monday - Friday Interview Time - 10 AM IST and Wednesday Interview Time - 8 PM IST
            switch (InterviewDate.DayOfWeek)
            {
                case DayOfWeek.Monday:
                    FirstInterviewDate = InterviewDate.AddDays(1);// First Interview Date Option - Wednesday                    
                    SecondInterviewDate = InterviewDate.AddDays(3);// Second Interview Date Option - Friday 
                    InterviewTime = SecondInterviewTime = new TimeSpan(10, 00, 00);

                    FirstInterviewTime = new TimeSpan(20, 00, 00);

                    break;

                case DayOfWeek.Friday:
                    FirstInterviewDate = InterviewDate.AddDays(2);// First Interview Date Option - Monday                    
                    SecondInterviewDate = InterviewDate.AddDays(4);// Second Interview Date Option - Wednesday                    

                    InterviewTime = FirstInterviewTime = new TimeSpan(10, 00, 00);
                    SecondInterviewTime = new TimeSpan(20, 00, 00);
                    break;

                case DayOfWeek.Wednesday:
                    FirstInterviewDate = InterviewDate.AddDays(1);// First Interview Date Option - Friday                    
                    SecondInterviewDate = InterviewDate.AddDays(4);// second Interview Date Option - Monday                    

                    InterviewTime = new TimeSpan(20, 00, 00);

                    SecondInterviewTime = FirstInterviewTime = new TimeSpan(10, 00, 00);
                    break;

                case DayOfWeek.Sunday:
                    InterviewDate = InterviewDate.AddDays(1);// Default Interview Date Option - Monday                    
                    FirstInterviewDate = InterviewDate.AddDays(2);// First Interview Date Option - Wednesday                    
                    SecondInterviewDate = InterviewDate.AddDays(4);// Second Interview Date Option - Friday                    

                    InterviewTime = SecondInterviewTime = new TimeSpan(10, 00, 00);

                    FirstInterviewTime = new TimeSpan(20, 00, 00);

                    break;
                case DayOfWeek.Tuesday:
                    InterviewDate = InterviewDate.AddDays(1); // Default Interview Date Option - Wednesday
                    FirstInterviewDate = InterviewDate.AddDays(2);// First Interview Date Option - Friday                    
                    SecondInterviewDate = InterviewDate.AddDays(4);// Second Interview Date Option - Monday

                    InterviewTime = new TimeSpan(20, 00, 00);
                    SecondInterviewTime = FirstInterviewTime = new TimeSpan(10, 00, 00);

                    break;
                case DayOfWeek.Thursday:
                    InterviewDate = InterviewDate.AddDays(1);// Default Interview Date Option - Friday                    
                    FirstInterviewDate = InterviewDate.AddDays(3);// First Interview Date Option - Monday                    
                    SecondInterviewDate = InterviewDate.AddDays(5);// Second Interview Date Option - Wednesday                    

                    InterviewTime = FirstInterviewTime = new TimeSpan(10, 00, 00);

                    SecondInterviewTime = new TimeSpan(20, 00, 00);

                    break;
                case DayOfWeek.Saturday:
                    InterviewDate = InterviewDate.AddDays(2);// Default Interview Date Option - Monday                    
                    FirstInterviewDate = InterviewDate.AddDays(3);// First Interview Date Option - Wednesday                    
                    SecondInterviewDate = InterviewDate.AddDays(5);// Second Interview Date Option - Friday                    

                    InterviewTime = SecondInterviewTime = new TimeSpan(10, 00, 00);

                    FirstInterviewTime = new TimeSpan(20, 00, 00);
                    break;
                default:
                    InterviewTime = FirstInterviewTime = SecondInterviewTime = new TimeSpan(10, 00, 00);
                    FirstInterviewDate = SecondInterviewDate = InterviewDate;
                    break;

            }

            InterviewDate = InterviewDate.Date + InterviewTime;
            FirstInterviewDate = FirstInterviewDate + FirstInterviewTime;
            SecondInterviewDate = SecondInterviewDate + SecondInterviewTime;

            //ltlDefaultInterviewDateTime.Text = InterviewDate.ToString("MM/dd/yyyy h:mm tt", CultureInfo.InvariantCulture);
            ddlInterviewDTOptions.Items.Add(new ListItem(InterviewDate.ToString("MM/dd/yyyy h:mm tt", CultureInfo.InvariantCulture)));
            ddlInterviewDTOptions.Items.Add(new ListItem(FirstInterviewDate.ToString("MM/dd/yyyy h:mm tt", CultureInfo.InvariantCulture)));
            ddlInterviewDTOptions.Items.Add(new ListItem(SecondInterviewDate.ToString("MM/dd/yyyy h:mm tt", CultureInfo.InvariantCulture)));

            ddlInterviewDTOptions.SelectedIndex = 0;

        }

        private void LogoutUser(bool isFailed)
        {
            //Logout user and clear its session value.
            Session["ID"] = null;
            Session.Clear();
            Session.Abandon();
            String ScriptString = "redirectParentToLoginPage('" + Page.ResolveUrl("~/stafflogin.aspx") + (isFailed == true ? "?UF=1" : String.Empty) + "');";
            ScriptManager.RegisterStartupScript(this, this.Page.GetType(), "ExamPassed", ScriptString, true);
        }

        private void InsertAssignedTaskSequenceInfo(long TaskId, int DesignationID, long AssignedSequence, bool IsTechTask)
        {
            TaskGeneratorBLL.Instance.InsertAssignedDesignationTaskWithSequence(DesignationID, IsTechTask, AssignedSequence, TaskId, this.UserID);
        }

        private void SetExamPassedMessage(String InstallId, String TaskTitle, Int64 TaskId, Int64 ParentTaskId)
        {
            SetInterviewDateNTime();
            ltlUDesg.Text = this.DesignationName;
            ltlTaskInstallID.Text = InstallId;
            ltlTaskTitle.Text = TaskTitle;
            hypTaskLink.HRef = String.Concat(HttpContext.Current.Request.Url.Host, "/Sr_App/ITDashboard.aspx?TaskId=", TaskId.ToString(), "&hstid=", ParentTaskId);
        }
        private void FillUserDetailsForConfirmation()
        {
            DataSet dsUserDetails = InstallUserBLL.Instance.getuserdetails(UserID);
        }

        private void UpdateUserStatusAsRejectedWithReason(int userID)
        {
            InstallUserBLL.Instance.ChangeUserStatusToReject(Convert.ToInt32(JGConstant.InstallUserStatus.Rejected), DateTime.Now.Date, DateTime.Now.ToShortTimeString(), JGApplicationInfo.GetJMGCAutoUserID(), Convert.ToInt32(Session["ID"]), "Didn't Passed apptitude test.");
        }

        //Update User Exam Summary.
        private void UpdateUserExamSummary(int markScored, int totalMarks, double percentageObtained, int currentExam, int userID)
        {
            AptitudeTestBLL.Instance.InsertPerformance(UserID, CurrentExamID, markScored, totalMarks, percentageObtained, 0);
        }

        private double getUserPassingPercentage(double totalMakrs, double markScored)
        {
            //set total Marks to 1 to avoid divide by zero error.
            totalMakrs = totalMakrs <= 0 ? 1 : totalMakrs;
            return Math.Round((markScored / totalMakrs) * 100.00, 2);

        }

        private void StartExam()
        {
            // Start very first exam.
            if (this.NextExamSeq == 0)
            {
                this.CurrentExamID = Convert.ToInt32(((Literal)rptExams.Items[0].FindControl("ltlExamId")).Text);
                this.NextExamSeq = 1;// fetch next exam from repeater item index.
            }
            else
            {
                this.CurrentExamID = Convert.ToInt32(((Literal)rptExams.Items[this.NextExamSeq].FindControl("ltlExamId")).Text);

                this.NextExamSeq = this.NextExamSeq + 1;
            }

            SetExamSectionViews();
            LoadQuestionsForExam();
            LoadNextQuestion();
        }


        #endregion

        protected void btnConfirm_Click(object sender, EventArgs e)
        {

        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {

        }
    }
}