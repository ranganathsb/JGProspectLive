using JG_Prospect.App_Code;
using JG_Prospect.BLL;
using JG_Prospect.Common.modal;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JG_Prospect.Sr_App
{
    public partial class add_edit_aptitude_test : System.Web.UI.Page
    {
        DataTable dtExam = null;
        DataTable dtQuestions = null;
        DataTable dtOptions = null;

        public Int64 ExamID
        {
            get
            {

                if (string.IsNullOrEmpty(Request.QueryString["ExamID"]))
                {
                    return 0;
                }

                return Convert.ToInt64(Request.QueryString["ExamID"]);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            CommonFunction.AuthenticateUser();

            if (!IsPostBack)
            {
                FillddlDesignation();

                if (this.ExamID > 0)
                {
                    ltrlPageHeader.Text = "Edit Aptitude Test";

                    DataSet dsExam = AptitudeTestBLL.Instance.GetMCQ_ExamByID(this.ExamID);

                    if (dsExam != null && dsExam.Tables.Count > 0)
                    {
                        dtExam = dsExam.Tables[0];

                        if (dtExam.Rows.Count > 0)
                        {
                            txtTitle.Text = Convert.ToString(dtExam.Rows[0]["ExamTitle"]);
                            txtDescription.Text = Convert.ToString(dtExam.Rows[0]["ExamDescription"]);
                            txtDuration.Text = Convert.ToString(dtExam.Rows[0]["ExamDuration"]);
                            txtPassPercentage.Text = Convert.ToString(dtExam.Rows[0]["PassPercentage"]);
                            chkActive.Checked = Convert.ToBoolean(dtExam.Rows[0]["IsActive"]);
                            ddlDesignation.SelectedValue = Convert.ToString(dtExam.Rows[0]["DesignationID"]);

                            if (dsExam.Tables.Count > 1)
                            {
                                dtQuestions = dsExam.Tables[1];

                                if (dsExam.Tables.Count > 2)
                                {
                                    dtOptions = dsExam.Tables[2];
                                }

                                repQuestions.DataSource = dtQuestions;
                                repQuestions.DataBind();
                            }
                        }
                    }
                }
                else
                {
                    ltrlPageHeader.Text = "Add Aptitude Test";
                }
            }
        }

        protected DataTable GetOptionsByQuestionID(Int64 intQuestionID)
        {
            if (dtOptions != null)
            {
                DataView dvOptions = dtOptions.DefaultView;

                dvOptions.RowFilter = string.Format("QuestionID = {0}", intQuestionID);

                return dvOptions.ToTable();
            }

            return null;
        }

        protected bool IsCorrectAnswer(Int64 intQuestionID, Int64 intOptionID)
        {
            if (dtOptions != null)
            {
                DataView dvQuestions = dtQuestions.DefaultView;

                dvQuestions.RowFilter = string.Format("QuestionID = {0} AND AnswerOptionID = {1}", intQuestionID, intOptionID);

                return (dvQuestions.ToTable().Rows.Count == 1);
            }

            return false;
        }

        private void FillddlDesignation()
        {
            List<Designation> lstDesignations = DesignationBLL.Instance.GetAllDesignation();
            if (lstDesignations != null && lstDesignations.Any())
            {
                ddlDesignation.DataSource = lstDesignations;
                ddlDesignation.DataTextField = "DesignationName";
                ddlDesignation.DataValueField = "ID";
                ddlDesignation.DataBind();
            }
            ddlDesignation.Items.Insert(0, new ListItem("--All--", "0"));
        }

        protected void btnSaveExam_Click(object sender, EventArgs e)
        {

        }
    }
}