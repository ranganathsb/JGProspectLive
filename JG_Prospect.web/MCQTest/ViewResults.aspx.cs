using JG_Prospect.BLL;
using JG_Prospect.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JG_Prospect.MCQTest
{
    public partial class ViewResults : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Put user code to initialize the page here

            String ExamID = (String)Session["exam_id"];
            long totalMarks = (long)Session["TotalMarks"];
            long marksEarned = (long)Session["MarksEarned"];
            lblMarksEarned.Text = marksEarned.ToString();
            lblTotalMarks.Text = totalMarks.ToString();
            float percentage = ((float)marksEarned / totalMarks) * 100;
            if (percentage < 0)
                percentage = 0.00F;
            lblPercentage.Text = percentage.ToString("0.00");

            // Here code to insert into Performance Index database
            //StudentPerformanceTableAdapter studentPerformance = new StudentPerformanceTableAdapter();
            //ExamTableAdapter examAdapter = new ExamTableAdapter();

            //String status = "FINISHED";
            //ExamOMaticSchema.ExamRow examDetails = examAdapter.GetData().FindByExamID(int.Parse(ExamID));
            //ExamPerformanceStatus examPerformanceStatus = ExamPerformanceStatus.Pass;
            //if (examDetails.PassPercentage == 0)
            //    examPerformanceStatus = ExamPerformanceStatus.NoStatus;
            //else
            //{
            //    if (percentage < examDetails.PassPercentage)
            //    {
            //        examPerformanceStatus = ExamPerformanceStatus.Fail;
            //        status = "<font color=red>FAILED</font>";
            //    }
            //    else
            //        status = "<font color=green>PASSED</font>";
            //}
            //lblStatus.Text = status;

            int InstallUserID = 0;
            int.TryParse(Session["ID"].ToString(), out InstallUserID);

            //Session.RemoveAll();
            //Session.Abandon();

            int examPerformance = 0;

            DataTable examDetails = AptitudeTestBLL.Instance.GetMCQ_ExamByID(int.Parse(ExamID)).Tables[0];
            var passingPercent = Convert.ToDouble(string.IsNullOrEmpty(Convert.ToString(examDetails.Rows[0]["PassPercentage"])) ? "0" : Convert.ToString(examDetails.Rows[0]["PassPercentage"]));
            if (percentage < passingPercent)
            {
                //fail
                InstallUserBLL.Instance.UpdateInstallUserStatus((Convert.ToInt32(JGConstant.InstallUserStatus.Rejected).ToString()), InstallUserID);
                examPerformance = Convert.ToInt32(JGConstant.ExamPerformanceStatus.Fail);
                Page.ClientScript.RegisterStartupScript(this.Page.GetType(), "alert", String.Concat("alert('Unfortunately you did NOT pass the apptitude test for the designation you applied for. If you feel you reached this message in error you will need to contact a JG MNGR represenative to unlock your account and allow you to take another test. Thank you for applying with JMG');"), true);

                Session.Clear();
                Session["LogOut"] = 1;
                //Response.Redirect("~/login.aspx");
            }
            else
            {
                //pass
                examPerformance = Convert.ToInt32(JGConstant.ExamPerformanceStatus.Pass);
                Page.ClientScript.RegisterStartupScript(this.Page.GetType(), "alert", String.Concat("alert('Congratulations! You have passed the apptitude test for the designation you applied for. To continue the Hiring process fill out the remaining following fields and confirm the default given date and time to speak with a hiring manager for instructions for the final step of the hiring process.  You will be contacted to confirm that date and time is acceptable with the hiring manager. You will login to the application to have your Video/Voice/chat \"Interview Date Meeting\"');"), true);
            }

            AptitudeTestBLL.Instance.InsertPerformance(InstallUserID, int.Parse(ExamID), (int)marksEarned, (int)totalMarks, percentage, examPerformance);
        }
    }
}