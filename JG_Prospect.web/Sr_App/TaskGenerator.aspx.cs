#region "-- using --"

using JG_Prospect.BLL;
using JG_Prospect.Common;
using JG_Prospect.Common.modal;
using Saplin.Controls;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.Net.Mail;
using System.Globalization;
using System.Configuration;
using Ionic.Zip;
using JG_Prospect.App_Code;
using System.Web.Services;
using Newtonsoft.Json;
using System.Linq;
using System.Web.UI.HtmlControls;
using CKEditor.NET;

#endregion

namespace JG_Prospect.Sr_App
{
    public partial class TaskGenerator : System.Web.UI.Page
    {
        #region "--Members--"

        string strSubtaskSeq = "sbtaskseq";

        #endregion

        #region "--Properties--"

        /// <summary>
        /// Set control view mode.
        /// </summary>
        public bool IsAdminMode
        {
            get
            {
                bool returnVal = false;

                if (ViewState["AMODE"] != null)
                {
                    returnVal = Convert.ToBoolean(ViewState["AMODE"]);
                }

                return returnVal;
            }
            set
            {
                ViewState["AMODE"] = value;
            }
        }

        /// <summary>
        /// Set control view mode.
        /// </summary>
        public bool IsAdminAndItLeadMode
        {
            get
            {
                bool returnVal = false;

                if (ViewState["AIMODE"] != null)
                {
                    returnVal = Convert.ToBoolean(ViewState["AIMODE"]);
                }

                return returnVal;
            }
            set
            {
                ViewState["AIMODE"] = value;
            }
        }

        public int TaskCreatedBy
        {
            get
            {
                if (ViewState["TaskCreatedBy"] == null)
                {
                    return 0;
                }
                return Convert.ToInt32(ViewState["TaskCreatedBy"]);
            }
            set
            {
                ViewState["TaskCreatedBy"] = value;
            }
        }

        public String LastSubTaskSequence
        {
            get
            {
                String val = string.Empty;

                if (ViewState[strSubtaskSeq] != null && !string.IsNullOrEmpty(ViewState[strSubtaskSeq].ToString()))
                {
                    val = ViewState[strSubtaskSeq].ToString();
                }
                return val;
            }
            set
            {
                ViewState[strSubtaskSeq] = value;
            }
        }

        private List<Task> lstSubTasks
        {
            get
            {
                if (ViewState["lstSubTasks"] == null)
                {
                    ViewState["lstSubTasks"] = new List<Task>();
                }
                return (List<Task>)ViewState["lstSubTasks"];
            }
            set
            {
                ViewState["lstSubTasks"] = value;
            }
        }

        private DataTable dtTaskUserFiles
        {
            get
            {
                if (ViewState["dtTaskUserFiles"] == null)
                {
                    DataTable dt = new DataTable();
                    dt.Columns.Add("attachment");
                    dt.Columns.Add("FirstName");
                    ViewState["dtTaskUserFiles"] = dt;
                }
                return (DataTable)ViewState["dtTaskUserFiles"];
            }
            set
            {
                ViewState["dtTaskUserFiles"] = value;
            }
        }

        #endregion

        #region "--Page Events--"

        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.gdTaskUsers);

            if (!IsPostBack)
            {
                this.IsAdminMode = CommonFunction.CheckAdminMode();
                this.IsAdminAndItLeadMode = CommonFunction.CheckAdminAndItLeadMode();

                clearAllFormData();

                SetTaskView();

                FillDropdowns();

                this.LastSubTaskSequence = string.Empty;

                // edit mode, if task id is provided in query string parameter.
                if (!string.IsNullOrEmpty(Request.QueryString["TaskId"]))
                {
                    controlMode.Value = "1";
                    hdnTaskId.Value = Request.QueryString["TaskId"].ToString();
                    LoadTaskData(hdnTaskId.Value);
                }
                else
                {
                    controlMode.Value = "0";

                    // set default specs in progress status for It Leads.
                    if (this.IsAdminAndItLeadMode)
                    {
                        ListItem objSpecsInProgress = cmbStatus.Items.FindByValue(Convert.ToByte(JGConstant.TaskStatus.SpecsInProgress).ToString());
                        objSpecsInProgress.Enabled = true;
                        objSpecsInProgress.Selected = true;
                        cmbStatus.Enabled = false;
                    }
                }
            }

            objucTaskWorkSpecifications.TaskId = Convert.ToInt32(hdnTaskId.Value);
            objucTaskWorkSpecifications.IsAdminAndItLeadMode = this.IsAdminAndItLeadMode;
        }

        #endregion

        #region "--Control Events--"

        protected void ddlUserDesignation_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadUsersByDesgination();

            ddcbAssigned_SelectedIndexChanged(sender, e);

            ddlUserDesignation.Texts.SelectBoxCaption = "Select";

            foreach (ListItem item in ddlUserDesignation.Items)
            {
                if (item.Selected)
                {
                    ddlUserDesignation.Texts.SelectBoxCaption = item.Text;
                    break;
                }
            }
        }

        protected void ddcbAssigned_SelectedIndexChanged(object sender, EventArgs e)
        {
            #region 'Commented as Not needed'
            /*
            if (controlMode.Value == "0")
            {
                DataSet dsUsers = new DataSet();
                DataSet tempDs;
                List<string> SelectedUsersID = new List<string>();
                List<string> SelectedUsers = new List<string>();
                foreach (System.Web.UI.WebControls.ListItem item in ddcbAssigned.Items)
                {
                    if (item.Selected)
                    {
                        SelectedUsersID.Add(item.Value);
                        SelectedUsers.Add(item.Text);
                        tempDs = TaskGeneratorBLL.Instance.GetInstallUserDetails(Convert.ToInt32(item.Value));
                        dsUsers.Merge(tempDs);
                    }
                }
                if (dsUsers.Tables.Count != 0)
                {
                    gdTaskUsers.DataSource = dsUsers;
                    gdTaskUsers.DataBind();
                }
                else
                {
                    gdTaskUsers.DataSource = null;
                    gdTaskUsers.DataBind();
                }
            } 
            */
            #endregion

            ddcbAssigned.Texts.SelectBoxCaption = "--Open--";

            foreach (ListItem item in ddcbAssigned.Items)
            {
                if (item.Selected)
                {
                    ddcbAssigned.Texts.SelectBoxCaption = item.Text;
                    break;
                }
            }
        }

        protected void rptAttachment_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DownloadFile")
            {
                string[] files = e.CommandArgument.ToString().Split(new char[] { '@' }, StringSplitOptions.RemoveEmptyEntries);

                DownloadUserAttachment(files[0].Trim(), files[1].Trim());
            }
        }

        protected void rptAttachment_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                string file = Convert.ToString(e.Item.DataItem);

                string[] files = file.Split(new char[] { '@' }, StringSplitOptions.RemoveEmptyEntries);

                LinkButton lbtnAttchment = (LinkButton)e.Item.FindControl("lbtnDownload");

                if (files[1].Length > 13)// sort name with ....
                {
                    lbtnAttchment.Text = String.Concat(files[1].Substring(0, 12), "..");
                    lbtnAttchment.Attributes.Add("title", files[1]);

                    ScriptManager.GetCurrent(this.Page).RegisterPostBackControl(lbtnAttchment);
                }
                else
                {
                    lbtnAttchment.Text = files[1];
                }

                lbtnAttchment.CommandArgument = file;
            }
        }

        protected void btnSaveTask_Click(object sender, EventArgs e)
        {
            InsertUpdateTask();

            RedirectToViewTasks(null);
        }

        protected void lbtnDeleteTask_Click(object sender, EventArgs e)
        {
            DeletaTask(hdnTaskId.Value);
            ScriptManager.RegisterStartupScript((sender as Control), this.GetType(), "HidePopup", "CloseTaskPopup();", true);
        }

        #region '--Sub Tasks--'

        #region '--gvSubTasks--'

        protected void gvSubTasks_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DropDownList ddlStatus = e.Row.FindControl("ddlStatus") as DropDownList;
                ddlStatus.DataSource = CommonFunction.GetTaskStatusList();
                ddlStatus.DataTextField = "Text";
                ddlStatus.DataValueField = "Value";
                ddlStatus.DataBind();
                ddlStatus.Items.FindByValue(Convert.ToByte(JGConstant.TaskStatus.SpecsInProgress).ToString()).Enabled = false;

                DropDownList ddlTaskPriority = e.Row.FindControl("ddlTaskPriority") as DropDownList;
                if (ddlTaskPriority != null)
                {
                    ddlTaskPriority.DataSource = CommonFunction.GetTaskPriorityList();
                    ddlTaskPriority.DataTextField = "Text";
                    ddlTaskPriority.DataValueField = "Value";
                    ddlTaskPriority.DataBind();

                    if (!string.IsNullOrEmpty(DataBinder.Eval(e.Row.DataItem, "TaskPriority").ToString()))
                    {
                        ddlTaskPriority.SelectedValue = DataBinder.Eval(e.Row.DataItem, "TaskPriority").ToString();
                    }

                    if (controlMode.Value == "0")
                    {
                        ddlTaskPriority.Attributes.Add("SubTaskIndex", e.Row.RowIndex.ToString());
                    }
                    else
                    {
                        ddlTaskPriority.Attributes.Add("TaskId", DataBinder.Eval(e.Row.DataItem, "TaskId").ToString());
                    }
                }

                SetStatusSelectedValue(ddlStatus, DataBinder.Eval(e.Row.DataItem, "Status").ToString());

                if (!this.IsAdminMode)
                {
                    if (!ddlStatus.SelectedValue.Equals(Convert.ToByte(JGConstant.TaskStatus.ReOpened).ToString()))
                    {
                        ddlStatus.Items.FindByValue(Convert.ToByte(JGConstant.TaskStatus.ReOpened).ToString()).Enabled = false;
                    }
                }

                if (controlMode.Value == "0")
                {
                    ddlStatus.Attributes.Add("SubTaskIndex", e.Row.RowIndex.ToString());
                }
                else
                {
                    ddlStatus.Attributes.Add("TaskId", DataBinder.Eval(e.Row.DataItem, "TaskId").ToString());
                }

                if (!string.IsNullOrEmpty(DataBinder.Eval(e.Row.DataItem, "attachment").ToString()))
                {
                    string attachments = DataBinder.Eval(e.Row.DataItem, "attachment").ToString();
                    string[] attachment = attachments.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

                    Repeater rptAttachments = (Repeater)e.Row.FindControl("rptAttachment");
                    rptAttachments.DataSource = attachment;
                    rptAttachments.DataBind();
                }
            }
        }

        protected void gvSubTasks_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.Equals("edit-sub-task"))
            {
                ClearSubTaskData();

                hdnSubTaskId.Value = "0";
                hdnSubTaskIndex.Value = "-1";

                if (controlMode.Value == "0")
                {
                    hdnSubTaskIndex.Value = e.CommandArgument.ToString();

                    Task objTask = this.lstSubTasks[Convert.ToInt32(hdnSubTaskIndex.Value)];

                    txtTaskListID.Text = objTask.InstallId.ToString();
                    txtSubTaskTitle.Text = Server.HtmlDecode(objTask.Title);
                    txtSubTaskDescription.Text = Server.HtmlDecode(objTask.Description);

                    if (objTask.TaskType.HasValue && ddlTaskType.Items.FindByValue(objTask.TaskType.Value.ToString()) != null)
                    {
                        ddlTaskType.SelectedValue = objTask.TaskType.Value.ToString();
                    }

                    txtSubTaskDueDate.Text = CommonFunction.FormatToShortDateString(objTask.DueDate);
                    txtSubTaskHours.Text = objTask.Hours;
                    ddlSubTaskStatus.SelectedValue = objTask.Status.ToString();
                    if (objTask.TaskPriority.HasValue)
                    {
                        ddlSubTaskPriority.SelectedValue = objTask.TaskPriority.Value.ToString();
                    }
                }
                else
                {
                    hdnSubTaskId.Value = gvSubTasks.DataKeys[Convert.ToInt32(e.CommandArgument)]["TaskId"].ToString();

                    DataSet dsTaskDetails = TaskGeneratorBLL.Instance.GetTaskDetails(Convert.ToInt32(hdnSubTaskId.Value));

                    DataTable dtTaskMasterDetails = dsTaskDetails.Tables[0];

                    txtTaskListID.Text = dtTaskMasterDetails.Rows[0]["InstallId"].ToString();
                    txtSubTaskTitle.Text = Server.HtmlDecode(dtTaskMasterDetails.Rows[0]["Title"].ToString());
                    txtSubTaskDescription.Text = Server.HtmlDecode(dtTaskMasterDetails.Rows[0]["Description"].ToString());

                    ListItem item = ddlTaskType.Items.FindByValue(dtTaskMasterDetails.Rows[0]["TaskType"].ToString());

                    if (item != null)
                    {
                        ddlTaskType.SelectedIndex = ddlTaskType.Items.IndexOf(item);
                    }

                    txtSubTaskDueDate.Text = CommonFunction.FormatToShortDateString(dtTaskMasterDetails.Rows[0]["DueDate"]);
                    txtSubTaskHours.Text = dtTaskMasterDetails.Rows[0]["Hours"].ToString();
                    ddlSubTaskStatus.SelectedValue = dtTaskMasterDetails.Rows[0]["Status"].ToString();
                    if (!this.IsAdminMode)
                    {
                        if (!ddlSubTaskStatus.SelectedValue.Equals(Convert.ToByte(JGConstant.TaskStatus.ReOpened).ToString()))
                        {
                            ddlSubTaskStatus.Items.FindByValue(Convert.ToByte(JGConstant.TaskStatus.ReOpened).ToString()).Enabled = false;
                        }
                    }
                    trSubTaskStatus.Visible = true;
                    if (!string.IsNullOrEmpty(dtTaskMasterDetails.Rows[0]["TaskPriority"].ToString()))
                    {
                        ddlSubTaskPriority.SelectedValue = dtTaskMasterDetails.Rows[0]["TaskPriority"].ToString();
                    }
                }

                upAddSubTask.Update();

                ScriptManager.RegisterStartupScript(this.Page, this.Page.GetType(), "slid down sub task", "$('#" + divSubTask.ClientID + "').slideDown('slow');", true);
            }
            else if (e.CommandName.Equals("sub-task-feedback"))
            {
                ltrlSubTaskFeedbackTitle.Text = "Sub Task : " + gvSubTasks.DataKeys[Convert.ToInt32(e.CommandArgument)]["InstallId"].ToString();

                if (this.IsAdminMode)
                {
                    tblAddEditSubTaskFeedback.Visible = true;
                }
                else
                {
                    tblAddEditSubTaskFeedback.Visible = false;
                }
                upSubTaskFeedbackPopup.Update();
                ScriptManager.RegisterStartupScript(
                                                    (sender as Control),
                                                    this.GetType(),
                                                    "ShowPopup",
                                                    string.Format(
                                                                    "ShowPopup(\"#{0}\");",
                                                                    divSubTaskFeedbackPopup.ClientID
                                                                ),
                                                    true
                                              );
            }
        }

        protected void gvSubTasks_ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddlStatus = sender as DropDownList;
            if (controlMode.Value == "0")
            {
                this.lstSubTasks[Convert.ToInt32(ddlStatus.Attributes["SubTaskIndex"].ToString())].Status = Convert.ToInt32(ddlStatus.SelectedValue);

                SetSubTaskDetails(this.lstSubTasks);
            }
            else
            {
                TaskGeneratorBLL.Instance.UpdateTaskStatus
                                            (
                                                new Task()
                                                {
                                                    TaskId = Convert.ToInt32(ddlStatus.Attributes["TaskId"].ToString()),
                                                    Status = Convert.ToInt32(ddlStatus.SelectedValue)
                                                }
                                            );

                SetSubTaskDetails(TaskGeneratorBLL.Instance.GetSubTasks(Convert.ToInt32(hdnTaskId.Value)).Tables[0]);
            }
        }

        protected void gvSubTasks_ddlTaskPriority_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddlTaskPriority = sender as DropDownList;
            if (controlMode.Value == "0")
            {
                if (ddlTaskPriority.SelectedValue == "0")
                {
                    this.lstSubTasks[Convert.ToInt32(ddlTaskPriority.Attributes["SubTaskIndex"].ToString())].TaskPriority = null;
                }
                else
                {
                    this.lstSubTasks[Convert.ToInt32(ddlTaskPriority.Attributes["SubTaskIndex"].ToString())].TaskPriority = Convert.ToByte(ddlTaskPriority.SelectedValue);
                }

                SetSubTaskDetails(this.lstSubTasks);
            }
            else
            {
                Task objTask = new Task();
                objTask.TaskId = Convert.ToInt32(ddlTaskPriority.Attributes["TaskId"].ToString());
                if (ddlTaskPriority.SelectedValue == "0")
                {
                    objTask.TaskPriority = null;
                }
                else
                {
                    objTask.TaskPriority = Convert.ToByte(ddlTaskPriority.SelectedItem.Value);
                }
                TaskGeneratorBLL.Instance.UpdateTaskPriority(objTask);

                SetSubTaskDetails(TaskGeneratorBLL.Instance.GetSubTasks(Convert.ToInt32(hdnTaskId.Value)).Tables[0]);
            }
        }

        #endregion

        protected void lbtnAddNewSubTask_Click(object sender, EventArgs e)
        {
            ClearSubTaskData();
            string[] subtaskListIDSuggestion = CommonFunction.getSubtaskSequencing(this.LastSubTaskSequence);
            if (subtaskListIDSuggestion.Length > 0)
            {
                if (subtaskListIDSuggestion.Length > 1)
                {
                    if (String.IsNullOrEmpty(subtaskListIDSuggestion[1]))
                    {
                        txtTaskListID.Text = subtaskListIDSuggestion[0];

                    }
                    else
                    {
                        txtTaskListID.Text = subtaskListIDSuggestion[1];
                        listIDOpt.Text = subtaskListIDSuggestion[0];

                    }

                }
                else
                {
                    txtTaskListID.Text = subtaskListIDSuggestion[0];
                    //listIDOpt.Text = subtaskListIDSuggestion[0];
                }
            }
            ScriptManager.RegisterStartupScript(this.Page, this.Page.GetType(), "slid down sub task", "$('#" + divSubTask.ClientID + "').slideDown('slow');", true);
        }

        protected void ddlTaskType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlTaskType.SelectedValue == Convert.ToInt16(JGConstant.TaskType.Enhancement).ToString())
            {
                trDateHours.Visible = true;
            }
            else
            {
                trDateHours.Visible = false;
            }
            ScriptManager.RegisterStartupScript(this.Page, this.Page.GetType(), "slid down sub task", "$('#" + divSubTask.ClientID + "').slideDown('slow');", true);
        }

        protected void btnSaveSubTask_Click(object sender, EventArgs e)
        {
            SaveSubTask();
            ScriptManager.RegisterStartupScript(this.Page, this.Page.GetType(), "slid up sub task", "$('#" + divSubTask.ClientID + "').slideUp('slow');", true);
        }

        #endregion

        #region '--Task History--'

        protected void btnAddNote_Click(object sender, EventArgs e)
        {
            SaveTaskNotesNAttachments();
            hdnAttachments.Value = "";
        }

        protected void gdTaskUsers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (String.IsNullOrEmpty(DataBinder.Eval(e.Row.DataItem, "attachments").ToString()))
                {
                    LinkButton lbtnAttachment = (LinkButton)e.Row.FindControl("lbtnAttachment");
                    lbtnAttachment.Visible = false;
                }

                Label lblStatus = (Label)e.Row.FindControl("lblStatus");

                int TaskStatus = Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Status"));
                lblStatus.Text = CommonFunction.GetTaskStatusList().FindByValue(TaskStatus.ToString()).Text;
            }
        }

        protected void gdTaskUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DownLoadFiles")
            {
                // Allow download only if files are attached.
                if (!String.IsNullOrEmpty(e.CommandArgument.ToString()))
                {
                    DownloadUserAttachments(e.CommandArgument.ToString());
                }
            }

        }

        #endregion

        #region '--Work Specification Section--'

        protected void lbtnShowWorkSpecificationSection_Click(object sender, EventArgs e)
        {
            FillWorkSpecificationAttachments();

            upWorkSpecificationSection.Update();

            ScriptManager.RegisterStartupScript(
                                                    (sender as Control),
                                                    this.GetType(),
                                                    "ShowPopup",
                                                    string.Format(
                                                                    "Initialize_WorkSpecifications();ShowPopup(\"#{0}\");ShowPopup(\"#{1}\");",
                                                                    divWorkSpecificationSection.ClientID,
                                                                    divFinishedWorkFiles.ClientID
                                                                ),
                                                    true
                                              );
        }

        protected void lbtnShowFinishedWorkFiles_Click(object sender, EventArgs e)
        {
            FillWorkSpecificationAttachments();

            upWorkSpecificationSection.Update();

            ScriptManager.RegisterStartupScript(
                                                    (sender as Control),
                                                    this.GetType(),
                                                    "ShowPopup",
                                                    string.Format(
                                                                    "Initialize_WorkSpecifications();ShowPopup(\"#{0}\");ShowPopup(\"#{1}\");",
                                                                    divFinishedWorkFiles.ClientID,
                                                                    divWorkSpecificationSection.ClientID
                                                                ),
                                                    true
                                              );
        }

        #region Work Specifications

        protected void repWorkSpecifications_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                HtmlTableRow trWorkSpecification = e.Item.FindControl("trWorkSpecification") as HtmlTableRow;
                LinkButton lbtnEditWorkSpecification = e.Item.FindControl("lbtnEditWorkSpecification") as LinkButton;
                Literal ltrlCustomId = e.Item.FindControl("ltrlCustomId") as Literal;
                Literal ltrlDescription = e.Item.FindControl("ltrlDescription") as Literal;
                CKEditorControl ckeWorkSpecification = e.Item.FindControl("ckeWorkSpecification") as CKEditorControl;

                if (e.Item.ItemType == ListItemType.Item)
                {
                    trWorkSpecification.Attributes.Add("class", "FirstRow");
                }
                else
                {
                    trWorkSpecification.Attributes.Add("class", "AlternateRow");
                }

                DataRowView drWorkSpecification = e.Item.DataItem as DataRowView;

                ltrlDescription.Text = HttpUtility.HtmlDecode(drWorkSpecification["Description"].ToString());
                ltrlDescription.Text = (new System.Text.RegularExpressions.Regex(@"(<[\w\s\=\""\-\/\:\:]*/>)|(<[\w\s\=\""\-\/\:\:]*>)|(</[\w\s\=\""\-\/\:\:]*>)")).Replace(ltrlDescription.Text, " ").Trim();

                ckeWorkSpecification.Text = HttpUtility.HtmlDecode(drWorkSpecification["Description"].ToString());

                if (this.IsAdminAndItLeadMode)
                {
                    if (!string.IsNullOrEmpty(drWorkSpecification["AdminStatus"].ToString()))
                    {
                        // do not allow edit for specifications freezed by both.
                        if (Convert.ToBoolean(drWorkSpecification["AdminStatus"]) && Convert.ToBoolean(drWorkSpecification["TechLeadStatus"]))
                        {
                            lbtnEditWorkSpecification.Visible = false;
                        }
                        else
                        {
                            ltrlCustomId.Visible = false;
                        }
                    }
                    else
                    {
                        ltrlCustomId.Visible =
                        lbtnEditWorkSpecification.Visible = false;
                    }
                }
                else
                {
                    lbtnEditWorkSpecification.Visible = false;
                }
            }
        }

        protected void txtPasswordToFreezeSpecification_TextChanged(object sender, EventArgs e)
        {
            if (this.IsAdminAndItLeadMode)
            {
                #region Freeze Based On Password

                TextBox txtPassword = sender as TextBox;

                if (txtPassword != null && !string.IsNullOrEmpty(txtPassword.Text))
                {
                    if (!txtPassword.Text.Equals(Convert.ToString(Session["loginpassword"])))
                    {
                        CommonFunction.ShowAlertFromUpdatePanel(this, "Specification cannot be freezed as password is not valid.");
                    }
                    else
                    {
                        // Freeze all specifications
                        TaskWorkSpecification objTaskWorkSpecification = new TaskWorkSpecification();
                        objTaskWorkSpecification.TaskId = Convert.ToInt64(hdnTaskId.Value);

                        bool blIsAdmin, blIsTechLead, blIsUser;

                        blIsAdmin = blIsTechLead = blIsUser = false;
                        if (HttpContext.Current.Session["DesigNew"].ToString().ToUpper().Equals("ITLEAD"))
                        {
                            objTaskWorkSpecification.TechLeadUserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                            objTaskWorkSpecification.IsTechLeadInstallUser = JGSession.IsInstallUser.Value;
                            objTaskWorkSpecification.TechLeadStatus = true;
                            blIsAdmin = true;
                        }
                        else if (HttpContext.Current.Session["DesigNew"].ToString().ToUpper().Equals("ADMIN"))
                        {
                            objTaskWorkSpecification.AdminUserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                            objTaskWorkSpecification.IsAdminInstallUser = JGSession.IsInstallUser.Value;
                            objTaskWorkSpecification.AdminStatus = true;
                            blIsTechLead = true;
                        }
                        else
                        {
                            objTaskWorkSpecification.OtherUserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                            objTaskWorkSpecification.IsOtherUserInstallUser = JGSession.IsInstallUser.Value;
                            objTaskWorkSpecification.OtherUserStatus = true;
                            blIsUser = true;
                        }



                        TaskGeneratorBLL.Instance.UpdateTaskWorkSpecificationStatusByTaskId
                                                    (
                                                        objTaskWorkSpecification,
                                                        blIsAdmin,
                                                        blIsTechLead,
                                                        blIsUser
                                                    );

                        CommonFunction.ShowAlertFromUpdatePanel(this, "Specification freezed successfully.");
                    }
                }

                #endregion

                #region Update Task and Status

                // change status only after freezing all specifications.
                // this will change disabled "specs in progress" status to open on feezing.
                SetPasswordToFreezeWorkSpecificationUI();

                // update task status.
                SaveTask();

                #endregion
            }
        }

        #endregion

        #region Work Specification Attachments

        protected void grdWorkSpecificationAttachments_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                string file = Convert.ToString(DataBinder.Eval(e.Item.DataItem, "attachment"));

                string[] files = file.Split(new char[] { '@' }, StringSplitOptions.RemoveEmptyEntries);

                LinkButton lbtnAttchment = (LinkButton)e.Item.FindControl("lbtnDownload");

                if (files[1].Length > 40)// sort name with ....
                {
                    lbtnAttchment.Text = String.Concat(files[1].Substring(0, 40), "..");
                    lbtnAttchment.Attributes.Add("title", files[1]);
                }
                else
                {
                    lbtnAttchment.Text = files[1];
                }
                ScriptManager.GetCurrent(this.Page).RegisterPostBackControl(lbtnAttchment);
                lbtnAttchment.CommandArgument = file;

                ((HtmlImage)e.Item.FindControl("imgIcon")).Src = "../TaskAttachments/" + files[0].Trim();
            }
        }

        protected void grdWorkSpecificationAttachments_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "download-attachment")
            {
                string[] files = e.CommandArgument.ToString().Split(new char[] { '@' }, StringSplitOptions.RemoveEmptyEntries);

                DownloadUserAttachment(files[0].Trim(), files[1].Trim());
            }
            else if (e.CommandName == "delete-attachment")
            {
                DeleteWorkSpecificationFile(e.CommandArgument.ToString());
            }
        }

        private void DeleteWorkSpecificationFile(string parameter)
        {
            // Seperate DB Id and Filename from parameter.
            string[] parameters = parameter.Split('|');

            if (parameter.Length > 0)
            {
                string id = parameters[0];
                string[] fileNames = parameters[1].Split('@');//Id

                TaskUser taskUserFiles = new TaskUser();

                //Remove file from database
                bool blnFileDeletedFromDb = TaskGeneratorBLL.Instance.DeleteTaskUserFile(Convert.ToInt64(id));  // save task files

                //if file removed from database, remove from server file system.
                if (fileNames.Length > 0 && blnFileDeletedFromDb)
                {
                    string filetodelete = fileNames[0];
                    DeletefilefromServer(filetodelete);
                }

            }

            //Reload records.
            FillWorkSpecificationAttachments();
        }

        private void DeletefilefromServer(string filetodelete)
        {
            if (!String.IsNullOrEmpty(filetodelete))
            {
                var originalDirectory = new DirectoryInfo(Server.MapPath("~/TaskAttachments"));


                string pathString = System.IO.Path.Combine(originalDirectory.ToString(), filetodelete);

                bool isExists = System.IO.File.Exists(pathString);

                if (isExists)
                    File.Delete(pathString);


            }


        }

        protected void btnAddAttachment_ClicK(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(hdnWorkFiles.Value))
            {
                if (controlMode.Value == "0")
                {
                    #region '-- Save To Viewstate --'

                    foreach (string strAttachment in hdnWorkFiles.Value.Split('^'))
                    {
                        DataRow drTaskUserFiles = dtTaskUserFiles.NewRow();
                        drTaskUserFiles["attachment"] = strAttachment;
                        drTaskUserFiles["FirstName"] = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.Username.ToString()]);
                        dtTaskUserFiles.Rows.Add(drTaskUserFiles);
                    }

                    #endregion
                }
                else
                {
                    #region '-- Save To Database --'

                    UploadUserAttachements(null, Convert.ToInt32(hdnTaskId.Value), hdnWorkFiles.Value, JGConstant.TaskFileDestination.WorkSpecification);

                    FillWorkSpecificationAttachments();
                    #endregion
                }

                hdnWorkFiles.Value = "";
            }
        }

        protected void grdWorkSpecificationAttachments_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string file = Convert.ToString(DataBinder.Eval(e.Row.DataItem, "attachment"));

                string[] files = file.Split(new char[] { '@' }, StringSplitOptions.RemoveEmptyEntries);

                LinkButton lbtnAttchment = (LinkButton)e.Row.FindControl("lbtnDownload");

                if (files[1].Length > 40)// sort name with ....
                {
                    lbtnAttchment.Text = String.Concat(files[1].Substring(0, 40), "..");
                    lbtnAttchment.Attributes.Add("title", files[1]);
                }
                else
                {
                    lbtnAttchment.Text = files[1];
                }
                ScriptManager.GetCurrent(this.Page).RegisterPostBackControl(lbtnAttchment);
                lbtnAttchment.CommandArgument = file;
            }
        }

        protected void grdWorkSpecificationAttachments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DownloadFile")
            {
                string[] files = e.CommandArgument.ToString().Split(new char[] { '@' }, StringSplitOptions.RemoveEmptyEntries);

                DownloadUserAttachment(files[0].Trim(), files[1].Trim());
            }
        }

        #endregion

        #endregion

        #endregion

        #region "--Private Methods--"

        private void RedirectToViewTasks(object o)
        {
            Response.Redirect("~/sr_app/TaskGenerator.aspx?TaskId=" + hdnTaskId.Value);
        }

        private string getSingleValueFromCommaSeperatedString(string commaSeperatedString)
        {
            String strReturnVal;

            if (commaSeperatedString.Contains(","))
            {
                strReturnVal = String.Concat(commaSeperatedString.Substring(0, commaSeperatedString.IndexOf(",")), "..");
            }
            else
            {
                strReturnVal = commaSeperatedString;
            }

            return strReturnVal;
        }

        /// <summary>
        /// To load Designation to popup dropdown
        /// </summary>
        private void FillDropdowns()
        {
            BindTaskTypeDropDown();

            cmbStatus.DataSource = CommonFunction.GetTaskStatusList();
            cmbStatus.DataTextField = "Text";
            cmbStatus.DataValueField = "Value";
            cmbStatus.DataBind();
            cmbStatus.Items.FindByValue(Convert.ToByte(JGConstant.TaskStatus.SpecsInProgress).ToString()).Enabled = false;

            ddlSubTaskStatus.DataSource = CommonFunction.GetTaskStatusList();
            ddlSubTaskStatus.DataTextField = "Text";
            ddlSubTaskStatus.DataValueField = "Value";
            ddlSubTaskStatus.DataBind();
            ddlSubTaskStatus.Items.FindByValue(Convert.ToByte(JGConstant.TaskStatus.SpecsInProgress).ToString()).Enabled = false;

            ddlTaskPriority.DataSource = CommonFunction.GetTaskPriorityList();
            ddlTaskPriority.DataTextField = "Text";
            ddlTaskPriority.DataValueField = "Value";
            ddlTaskPriority.DataBind();

            ddlSubTaskPriority.DataSource = CommonFunction.GetTaskPriorityList();
            ddlSubTaskPriority.DataTextField = "Text";
            ddlSubTaskPriority.DataValueField = "Value";
            ddlSubTaskPriority.DataBind();

            ddlTUStatus.DataSource = CommonFunction.GetTaskStatusList();
            ddlTUStatus.DataTextField = "Text";
            ddlTUStatus.DataValueField = "Value";
            ddlTUStatus.DataBind();
            ddlTUStatus.Items.FindByValue(Convert.ToByte(JGConstant.TaskStatus.SpecsInProgress).ToString()).Enabled = false;
        }

        private void BindTaskTypeDropDown()
        {
            ddlTaskType.DataSource = CommonFunction.GetTaskTypeList();

            ddlTaskType.DataTextField = "Text";
            ddlTaskType.DataValueField = "Value";
            ddlTaskType.DataBind();
        }

        private void DeletaTask(string TaskId)
        {
            TaskGeneratorBLL.Instance.DeleteTask(Convert.ToUInt64(TaskId));
            hdnTaskId.Value = string.Empty;
            RedirectToViewTasks(null);
        }

        private void doSearch(object sender, EventArgs e)
        {

        }

        private void UpdateTaskStatus(Int32 taskId, UInt16 Status)
        {
            Task task = new Task();
            task.TaskId = taskId;
            task.Status = Status;

            int result = TaskGeneratorBLL.Instance.UpdateTaskStatus(task);    // save task master details

            RedirectToViewTasks(null);

            String AlertMsg;

            if (result > 0)
            {
                AlertMsg = "Status changed successfully!";

            }
            else
            {
                AlertMsg = "Status change was not successfull, Please try again later.";
            }

            CommonFunction.ShowAlertFromUpdatePanel(this.Page, AlertMsg);

        }

        private string GetInstallIdFromDesignation(string designame)
        {
            string prefix = "";
            switch (designame)
            {
                case "Admin":
                    prefix = "ADM";
                    break;
                case "Jr. Sales":
                    prefix = "JSL";
                    break;
                case "Jr Project Manager":
                    prefix = "JPM";
                    break;
                case "Office Manager":
                    prefix = "OFM";
                    break;
                case "Recruiter":
                    prefix = "REC";
                    break;
                case "Sales Manager":
                    prefix = "SLM";
                    break;
                case "Sr. Sales":
                    prefix = "SSL";
                    break;
                case "IT - Network Admin":
                    prefix = "ITNA";
                    break;
                case "IT - Jr .Net Developer":
                    prefix = "ITJN";
                    break;
                case "IT - Sr .Net Developer":
                    prefix = "ITSN";
                    break;
                case "IT - Android Developer":
                    prefix = "ITAD";
                    break;
                case "IT - PHP Developer":
                    prefix = "ITPH";
                    break;
                case "IT - SEO / BackLinking":
                    prefix = "ITSB";
                    break;
                case "Installer - Helper":
                    prefix = "INH";
                    break;
                case "Installer – Journeyman":
                    prefix = "INJ";
                    break;
                case "Installer – Mechanic":
                    prefix = "INM";
                    break;
                case "Installer - Lead mechanic":
                    prefix = "INLM";
                    break;
                case "Installer – Foreman":
                    prefix = "INF";
                    break;
                case "Commercial Only":
                    prefix = "COM";
                    break;
                case "SubContractor":
                    prefix = "SBC";
                    break;
                default:
                    prefix = "TSK";
                    break;
            }
            return prefix;
        }

        private void LoadUsersByDesgination()
        {
            DataSet dsUsers;

            // DropDownCheckBoxes ddlAssign = (FindControl("ddcbAssigned") as DropDownCheckBoxes);
            // DropDownList ddlDesignation = (DropDownList)sender;

            string designations = GetSelectedDesignationsString();

            dsUsers = TaskGeneratorBLL.Instance.GetInstallUsers(2, designations);

            ddcbAssigned.Items.Clear();
            ddcbAssigned.DataSource = dsUsers;
            ddcbAssigned.DataTextField = "FristName";
            ddcbAssigned.DataValueField = "Id";
            ddcbAssigned.DataBind();

            HighlightInterviewUsers(dsUsers.Tables[0], ddcbAssigned, null);
        }

        private void HighlightInterviewUsers(DataTable dtUsers, DropDownCheckBoxes ddlUsers, DropDownList ddlFilterUsers)
        {
            if (dtUsers.Rows.Count > 0)
            {
                var rows = dtUsers.AsEnumerable();

                //get all users comma seperated ids with interviewdate status
                String InterviewDateUsers = String.Join(",", (from r in rows where (r.Field<string>("Status") == "InterviewDate" || r.Field<string>("Status") == "Interview Date") select r.Field<Int32>("Id").ToString()));

                // for each userid find it into user dropdown list and apply red color to it.
                foreach (String user in InterviewDateUsers.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
                {
                    ListItem item;

                    if (ddlUsers != null)
                    {
                        item = ddlUsers.Items.FindByValue(user);
                    }
                    else
                    {
                        item = ddlFilterUsers.Items.FindByValue(user);
                    }

                    if (item != null)
                    {
                        item.Attributes.Add("style", "color:red;");
                    }
                }

            }
        }

        private string GetSelectedDesignationsString()
        {
            String returnVal = string.Empty;
            StringBuilder sbDesignations = new StringBuilder();

            foreach (ListItem item in ddlUserDesignation.Items)
            {
                if (item.Selected)
                {
                    sbDesignations.Append(String.Concat(item.Text, ","));
                }
            }

            if (sbDesignations.Length > 0)
            {
                returnVal = sbDesignations.ToString().Substring(0, sbDesignations.ToString().Length - 1);
            }

            return returnVal;
        }

        /// <summary>
        /// Get all designations from department to which user's designation belongs to.
        /// Ex. if user has designation IT - Network Admin , here all IT related task will be listed.
        /// </summary>
        /// <param name="UserDesignation"></param>
        /// <returns></returns>
        private string GetUserDepartmentAllDesignations(string UserDesignation)
        {
            string returnString = string.Empty;
            const string ITDesignations = "IT - Network Admin,IT - Jr .Net Developer,IT - Sr .Net Developer,IT - Android Developer,IT - PHP Developer,IT - SEO / BackLinking";

            if (UserDesignation.Contains("IT"))
            {
                returnString = ITDesignations;
            }
            else
            {
                returnString = UserDesignation;
            }

            return returnString;
        }

        /// <summary>
        /// To clear the popup details after save
        /// </summary>
        private void clearAllFormData()
        {
            this.TaskCreatedBy = 0;
            this.lstSubTasks = null;
            txtTaskTitle.Text = string.Empty;
            txtDescription.Text = string.Empty;
            ddlUserDesignation.ClearSelection();
            ddlUserDesignation.Texts.SelectBoxCaption = "Select";
            ddcbAssigned.Items.Clear();
            ddcbAssigned.Texts.SelectBoxCaption = "--Open--";
            cmbStatus.ClearSelection();
            ddlUserAcceptance.ClearSelection();
            ddlTaskPriority.SelectedValue = "0";
            txtDueDate.Text = string.Empty;
            txtHours.Text = string.Empty;
            gdTaskUsers.DataSource = null;
            gdTaskUsers.DataBind();
            txtNote.Text = string.Empty;
            hdnTaskId.Value = "0";
            controlMode.Value = "0";
        }

        private void ClearSubTaskData()
        {
            hdnSubTaskId.Value = "0";
            hdnSubTaskIndex.Value = "-1";
            txtTaskListID.Text = string.Empty;
            txtSubTaskTitle.Text =
            txtSubTaskDescription.Text =
            txtSubTaskDueDate.Text =
            txtSubTaskHours.Text = string.Empty;
            if (ddlTaskType.Items.Count > 0)
            {
                ddlTaskType.SelectedIndex = 0;
            }
            trSubTaskStatus.Visible = false;
            ddlSubTaskStatus.Items.FindByValue(Convert.ToByte(JGConstant.TaskStatus.Open).ToString()).Selected = true;
            ddlSubTaskStatus.Items.FindByValue(Convert.ToByte(JGConstant.TaskStatus.ReOpened).ToString()).Enabled = true;
            ddlSubTaskPriority.SelectedValue = "0";
            upAddSubTask.Update();
        }

        private void InsertUpdateTask()
        {
            // save task master details
            SaveTask();

            if (controlMode.Value == "0")
            {
                // save task description as a first note.
                txtNote.Text = txtDescription.Text;
                SaveTaskNotesNAttachments();
            }

            // save assgined designation.
            SaveTaskDesignations();

            // save details of users to whom task is assgined.
            SaveAssignedTaskUsers(ddcbAssigned, (JGConstant.TaskStatus)Convert.ToByte(cmbStatus.SelectedItem.Value));

            if (controlMode.Value == "0")
            {
                foreach (DataRow drTaskUserFiles in this.dtTaskUserFiles.Rows)
                {
                    UploadUserAttachements(null, Convert.ToInt64(hdnTaskId.Value), Convert.ToString(drTaskUserFiles["attachment"]), JGConstant.TaskFileDestination.Task);
                }
            }

            if (this.lstSubTasks.Any())
            {
                foreach (Task objSubTask in this.lstSubTasks)
                {
                    objSubTask.ParentTaskId = Convert.ToInt32(hdnTaskId.Value);
                    // save task master details to database.
                    hdnSubTaskId.Value = TaskGeneratorBLL.Instance.SaveOrDeleteTask(objSubTask).ToString();

                    UploadUserAttachements(null, Convert.ToInt64(hdnSubTaskId.Value), objSubTask.Attachment, JGConstant.TaskFileDestination.SubTask);
                }
            }

            if (controlMode.Value == "0")
            {
                CommonFunction.ShowAlertFromUpdatePanel(this.Page, "Task created successfully!");
            }
            else
            {
                CommonFunction.ShowAlertFromUpdatePanel(this.Page, "Task updated successfully!");
            }
        }

        /// <summary>
        /// Save task master details, user information and user attachments.
        /// Created By: Yogesh Keraliya
        /// </summary>
        private void SaveTask()
        {
            int userId = Convert.ToInt16(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
            Task objTask = new Task();
            objTask.TaskId = Convert.ToInt32(hdnTaskId.Value);
            objTask.Title = Server.HtmlEncode(txtTaskTitle.Text);
            objTask.Description = Server.HtmlEncode(txtDescription.Text);
            objTask.Status = Convert.ToUInt16(cmbStatus.SelectedItem.Value);
            if (ddlTaskPriority.SelectedValue == "0")
            {
                objTask.TaskPriority = null;
            }
            else
            {
                objTask.TaskPriority = Convert.ToByte(ddlTaskPriority.SelectedItem.Value);
            }
            objTask.DueDate = txtDueDate.Text;
            objTask.Hours = txtHours.Text;
            objTask.CreatedBy = userId;
            objTask.Mode = Convert.ToInt32(controlMode.Value);
            objTask.InstallId = GetInstallIdFromDesignation(ddlUserDesignation.SelectedItem.Text);
            objTask.IsTechTask = chkTechTask.Checked;

            Int64 ItaskId = TaskGeneratorBLL.Instance.SaveOrDeleteTask(objTask);    // save task master details

            if (controlMode.Value == "0")
            {
                hdnTaskId.Value = ItaskId.ToString();
            }
        }

        private void SaveSubTask()
        {
            Task objTask = null;
            if (hdnSubTaskIndex.Value == "-1")
            {
                objTask = new Task();
                objTask.TaskId = Convert.ToInt32(hdnSubTaskId.Value);
            }
            else
            {
                objTask = this.lstSubTasks[Convert.ToInt32(hdnSubTaskIndex.Value)];
            }

            if (objTask.TaskId > 0)
            {
                objTask.Mode = 1;
            }
            else
            {
                objTask.Mode = 0;
            }

            objTask.Title = txtSubTaskTitle.Text;
            objTask.Description = txtSubTaskDescription.Text;
            objTask.Status = Convert.ToInt32(ddlSubTaskStatus.SelectedValue);
            if (ddlSubTaskPriority.SelectedValue == "0")
            {
                objTask.TaskPriority = null;
            }
            else
            {
                objTask.TaskPriority = Convert.ToByte(ddlSubTaskPriority.SelectedItem.Value);
            }
            objTask.DueDate = txtSubTaskDueDate.Text;
            objTask.Hours = txtSubTaskHours.Text;
            objTask.CreatedBy = Convert.ToInt16(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
            //task.InstallId = GetInstallIdFromDesignation(ddlUserDesignation.SelectedItem.Text);
            objTask.InstallId = txtTaskListID.Text.Trim();
            objTask.ParentTaskId = Convert.ToInt32(hdnTaskId.Value);
            objTask.Attachment = hdnAttachments.Value;

            if (ddlTaskType.SelectedIndex > 0)
            {
                objTask.TaskType = Convert.ToInt16(ddlTaskType.SelectedValue);
            }

            if (controlMode.Value == "0")
            {
                if (hdnSubTaskIndex.Value == "-1")
                {
                    this.lstSubTasks.Add(objTask);
                }
                else
                {
                    this.lstSubTasks[Convert.ToInt32(hdnSubTaskIndex.Value)] = objTask;
                }

                SetSubTaskDetails(this.lstSubTasks);

                if (!string.IsNullOrEmpty(txtTaskListID.Text))
                {
                    this.LastSubTaskSequence = txtTaskListID.Text.Trim();
                }
            }
            else
            {
                // save task master details to database.
                if (hdnSubTaskId.Value == "0")
                {
                    hdnSubTaskId.Value = TaskGeneratorBLL.Instance.SaveOrDeleteTask(objTask).ToString();
                }
                else
                {
                    TaskGeneratorBLL.Instance.SaveOrDeleteTask(objTask);
                }

                UploadUserAttachements(null, Convert.ToInt64(hdnSubTaskId.Value), objTask.Attachment, JGConstant.TaskFileDestination.SubTask);
                SetSubTaskDetails(TaskGeneratorBLL.Instance.GetSubTasks(Convert.ToInt32(hdnTaskId.Value)).Tables[0]);
            }
            hdnAttachments.Value = string.Empty;
            ClearSubTaskData();
        }

        private void SetSubTaskDetails(List<Task> lstSubtasks)
        {
            // TaskId,Title, [Description], [Status], DueDate,Tasks.[Hours], Tasks.CreatedOn, Tasks.InstallId, Tasks.CreatedBy, @AssigningUser AS AssigningManager
            DataTable dtSubtasks = new DataTable();
            dtSubtasks.Columns.Add("TaskId");
            dtSubtasks.Columns.Add("Title");
            dtSubtasks.Columns.Add("Description");
            dtSubtasks.Columns.Add("Status");
            dtSubtasks.Columns.Add("DueDate");
            dtSubtasks.Columns.Add("Hours");
            dtSubtasks.Columns.Add("InstallId");
            dtSubtasks.Columns.Add("FristName");
            dtSubtasks.Columns.Add("TaskType");
            dtSubtasks.Columns.Add("attachment");
            dtSubtasks.Columns.Add("TaskPriority");

            foreach (Task objSubTask in lstSubtasks)
            {
                dtSubtasks.Rows.Add(objSubTask.TaskId, objSubTask.Title, objSubTask.Description, objSubTask.Status, objSubTask.DueDate, objSubTask.Hours, objSubTask.InstallId, string.Empty, objSubTask.TaskType, objSubTask.Attachment, objSubTask.TaskPriority);
            }

            gvSubTasks.DataSource = dtSubtasks;
            gvSubTasks.DataBind();
            upSubTasks.Update();
        }

        private void SaveTaskDesignations()
        {
            //if task id is available to save its note and attachement.
            if (hdnTaskId.Value != "0")
            {
                String designations = GetSelectedDesignationsString();
                if (!string.IsNullOrEmpty(designations))
                {
                    int indexofComma = designations.IndexOf(',');
                    int copyTill = indexofComma > 0 ? indexofComma : designations.Length;

                    string designationcode = GetInstallIdFromDesignation(designations.Substring(0, copyTill));

                    TaskGeneratorBLL.Instance.SaveTaskDesignations(Convert.ToUInt64(hdnTaskId.Value), designations, designationcode);
                }
            }
        }

        /// <summary>
        /// Save user's to whom task is assigned. 
        /// </summary>
        private void SaveAssignedTaskUsers(DropDownCheckBoxes ddcbAssigned, JGConstant.TaskStatus objTaskStatus)
        {
            //if task id is available to save its note and attachement.
            if (hdnTaskId.Value != "0")
            {
                string strUsersIds = string.Empty;

                foreach (ListItem item in ddcbAssigned.Items)
                {
                    if (item.Selected)
                    {
                        strUsersIds = strUsersIds + (item.Value + ",");
                    }
                }

                // removes any extra comma "," from the end of the string.
                strUsersIds = strUsersIds.TrimEnd(',');

                // save (insert / delete) assigned users.
                bool isSuccessful = TaskGeneratorBLL.Instance.SaveTaskAssignedUsers(Convert.ToUInt64(hdnTaskId.Value), strUsersIds);

                // send email to selected users.
                if (strUsersIds.Length > 0)
                {
                    if (isSuccessful)
                    {
                        // Change task status to assigned = 3.
                        if (objTaskStatus == JGConstant.TaskStatus.Open || objTaskStatus == JGConstant.TaskStatus.Requested)
                        {
                            UpdateTaskStatus(Convert.ToInt32(hdnTaskId.Value), Convert.ToUInt16(JGConstant.TaskStatus.Assigned));
                        }

                        SendEmailToAssignedUsers(strUsersIds);
                    }
                }
                // send email to all users of the department as task is assigned to designation, but not to any specific user.
                //else
                //{
                //    string strUserIDs = "";

                //    foreach (ListItem item in ddcbAssigned.Items)
                //    {
                //        strUserIDs += string.Concat(item.Value, ",");
                //    }

                //    SendEmailToAssignedUsers(strUserIDs.TrimEnd(','));
                //}
            }
        }

        ///// <summary>
        ///// Save user's to whom task is assigned. 
        ///// </summary>
        //private void SaveAssignedTaskUsers()
        //{
        //    //if task id is available to save its note and attachement.
        //    if (hdnTaskId.Value != "0")
        //    {
        //        Boolean? isCreatorUser = null;

        //        foreach (ListItem item in ddcbAssigned.Items)
        //        {
        //            if (item.Selected)
        //            {
        //                // Save task notes and user information, returns TaskUpdateId for reference to add in user attachments.
        //                Int32 TaskUpdateId = SaveTaskNote(Convert.ToInt64(hdnTaskId.Value), isCreatorUser, Convert.ToInt32(item.Value), item.Text);
        //            }

        //        }


        //    }

        //}

        /// <summary>
        /// Save task note and attachment added by user.
        /// </summary>
        private void SaveTaskNotesNAttachments()
        {
            //if task id is available to save its note and attachement.
            if (hdnTaskId.Value != "0")
            {
                Boolean? isCreatorUser = null;

                //if it is task is created than control mode will be 0 and Admin user has created task.
                if (controlMode.Value == "0")
                {
                    isCreatorUser = true;
                }

                // Save task notes and user information, returns TaskUpdateId for reference to add in user attachments.
                Int32 TaskUpdateId = SaveTaskNote(Convert.ToInt64(hdnTaskId.Value), isCreatorUser, null, string.Empty);

                // Save task related user's attachment.
                UploadUserAttachements(TaskUpdateId, null, string.Empty, JGConstant.TaskFileDestination.TaskNote);

                LoadTaskData(hdnTaskId.Value);

                txtNote.Text = string.Empty;

                //clearAllFormData();

                // Refresh task list on top header.
                //SearchTasks(null);

                //if (controlMode.Value == "0")
                //{
                //    ScriptManager.RegisterStartupScript(this.Page, GetType(), "al", "alert('Task created successfully');", true);
                //}
                //else
                //{
                //   ScriptManager.RegisterStartupScript(this.Page, GetType(), "al", "alert('Task updated successfully');", true);
                //}

            }
        }

        private void UploadUserAttachements(int? taskUpdateId, long? TaskId, string attachments, JG_Prospect.Common.JGConstant.TaskFileDestination objTaskFileDestination)
        {
            //User has attached file than save it to database.
            if (!String.IsNullOrEmpty(attachments))
            {
                TaskUser taskUserFiles = new TaskUser();
                String[] files;

                if (!string.IsNullOrEmpty(attachments))
                {
                    files = attachments.Split(new char[] { '^' }, StringSplitOptions.RemoveEmptyEntries);
                }
                else
                {
                    files = hdnAttachments.Value.Split(new char[] { '^' }, StringSplitOptions.RemoveEmptyEntries);
                }


                foreach (String attachment in files)
                {
                    String[] attachements = attachment.Split('@');

                    taskUserFiles.Attachment = attachements[0];
                    taskUserFiles.OriginalFileName = attachements[1];
                    taskUserFiles.Mode = 0; // insert data.
                    taskUserFiles.TaskId = TaskId ?? Convert.ToInt64(hdnTaskId.Value);
                    taskUserFiles.UserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                    taskUserFiles.TaskUpdateId = taskUpdateId;
                    taskUserFiles.UserType = JGSession.IsInstallUser ?? false;
                    taskUserFiles.TaskFileDestination = objTaskFileDestination;
                    TaskGeneratorBLL.Instance.SaveOrDeleteTaskUserFiles(taskUserFiles);  // save task files
                }
            }
        }

        /// <summary>
        /// Save task user information.
        /// </summary>
        /// <param name="Designame"></param>
        /// <param name="ItaskId"></param>
        private Int32 SaveTaskNote(long ItaskId, Boolean? IsCreated, Int32? UserId, String UserName)
        {
            Int32 TaskUpdateId = 0;

            TaskUser taskUser = new TaskUser();

            if (UserId == null)
            {
                // Take logged in user's id for logging note in database.
                taskUser.UserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                taskUser.UserFirstName = Session["Username"].ToString();
            }
            else
            {
                taskUser.UserId = Convert.ToInt32(UserId);
                taskUser.UserFirstName = UserName;
            }



            //taskUser.UserType = userType.Text;
            taskUser.Notes = txtNote.Text;

            // if user has just created task then send entry with iscreator= true to distinguish record from other user's log.

            if (IsCreated != null)
            {
                taskUser.IsCreatorUser = true;
            }
            else
            {
                taskUser.IsCreatorUser = false;
            }

            taskUser.TaskId = ItaskId;

            taskUser.Status = Convert.ToInt16(cmbStatus.SelectedItem.Value);

            int userAcceptance = Convert.ToInt32(ddlUserAcceptance.SelectedItem.Value);

            taskUser.UserAcceptance = Convert.ToBoolean(userAcceptance);

            TaskGeneratorBLL.Instance.SaveOrDeleteTaskNotes(ref taskUser);

            TaskUpdateId = Convert.ToInt32(taskUser.TaskUpdateId);

            //for (int i = 0; i < gdTaskUsers.Rows.Count; i++)
            //{

            //    TaskUser taskUser = new TaskUser();
            //    Label userID = (Label)gdTaskUsers.Rows[i].Cells[1].FindControl("lbluserId");
            //    Label userType = (Label)gdTaskUsers.Rows[i].Cells[1].FindControl("lbluserType");
            //    Label notes = (Label)gdTaskUsers.Rows[i].Cells[1].FindControl("lblNotes");
            //    taskUser.UserId = Convert.ToInt32(userID.Text);
            //    //taskUser.UserType = userType.Text;
            //    taskUser.Notes = notes.Text;
            //    taskUser.TaskId = ItaskId;

            //    taskUser.Status = Convert.ToInt16(cmbStatus.SelectedItem.Value);
            //    int userAcceptance = Convert.ToInt32(ddlUserAcceptance.SelectedItem.Value);
            //    taskUser.UserAcceptance = Convert.ToBoolean(userAcceptance);
            //    TaskGeneratorBLL.Instance.SaveOrDeleteTaskUser(ref taskUser);

            //    TaskUpdateId = taskUser.TaskUpdateId;

            //    //Inform user by email about task assgignment.
            //    //SendEmail(Designame, taskUser.UserId); // send auto email to selected users

            //}

            return TaskUpdateId;
        }

        private void SendEmailToAssignedUsers(string strInstallUserIDs)
        {
            try
            {
                string strHTMLTemplateName = "Task Generator Auto Email";
                DataSet dsEmailTemplate = AdminBLL.Instance.GetEmailTemplate(strHTMLTemplateName, 108);
                foreach (string userID in strInstallUserIDs.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
                {
                    DataSet dsUser = TaskGeneratorBLL.Instance.GetInstallUserDetails(Convert.ToInt32(userID));

                    string emailId = dsUser.Tables[0].Rows[0]["Email"].ToString();
                    string FName = dsUser.Tables[0].Rows[0]["FristName"].ToString();
                    string LName = dsUser.Tables[0].Rows[0]["LastName"].ToString();
                    string fullname = FName + " " + LName;

                    string strHeader = dsEmailTemplate.Tables[0].Rows[0]["HTMLHeader"].ToString();
                    string strBody = dsEmailTemplate.Tables[0].Rows[0]["HTMLBody"].ToString();
                    string strFooter = dsEmailTemplate.Tables[0].Rows[0]["HTMLFooter"].ToString();
                    string strsubject = dsEmailTemplate.Tables[0].Rows[0]["HTMLSubject"].ToString();

                    strBody = strBody.Replace("#Fname#", fullname);
                    strBody = strBody.Replace("#TaskLink#", string.Format("{0}?TaskId={1}", Request.Url.ToString().Split('?')[0], hdnTaskId.Value));

                    strBody = strHeader + strBody + strFooter;

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
                    CommonFunction.SendEmail(strHTMLTemplateName, emailId, strsubject, strBody, lstAttachments);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("{0} Exception caught.", ex);
            }
        }

        private void LoadTaskData(string TaskId)
        {
            DataSet dsTaskDetails = TaskGeneratorBLL.Instance.GetTaskDetails(Convert.ToInt32(TaskId));

            DataTable dtTaskMasterDetails = dsTaskDetails.Tables[0];

            DataTable dtTaskDesignationDetails = dsTaskDetails.Tables[1];

            DataTable dtTaskAssignedUserDetails = dsTaskDetails.Tables[2];

            DataTable dtTaskNotesDetails = dsTaskDetails.Tables[3];

            DataTable dtSubTaskDetails = dsTaskDetails.Tables[4];

            SetSubTaskSectionView(true);

            SetMasterTaskDetails(dtTaskMasterDetails);
            SetTaskDesignationDetails(dtTaskDesignationDetails);
            SetTaskAssignedUsers(dtTaskAssignedUserDetails);
            SetTaskUserNNotesDetails(dtTaskNotesDetails);
            SetSubTaskDetails(dtSubTaskDetails);
            //FillrptWorkFiles(dsTaskDetails.Tables[5]);

            SetTaskPopupTitle(TaskId, dtTaskMasterDetails);

            SetPasswordToFreezeWorkSpecificationUI();
        }

        private void FillWorkSpecificationAttachments()
        {
            DataTable dtTaskUserFiles = null;

            if (controlMode.Value == "0")
            {
                dtTaskUserFiles = this.dtTaskUserFiles;
            }
            else
            {
                DataSet dsTaskUserFiles = TaskGeneratorBLL.Instance.GetTaskUserFiles(Convert.ToInt32(hdnTaskId.Value), JGConstant.TaskFileDestination.WorkSpecification, null, null);
                if (dsTaskUserFiles != null)
                {
                    dtTaskUserFiles = dsTaskUserFiles.Tables[0];
                    //Convert.ToInt32(dsTaskUserFiles.Tables[1].Rows[0]["TotalRecordCount"]);
                }
            }

            grdWorkSpecificationAttachments.DataSource = dtTaskUserFiles;
            grdWorkSpecificationAttachments.DataBind();

            upnlAttachments.Update();
        }

        private void SetSubTaskSectionView(bool blnView)
        {
            trSubTaskList.Visible = blnView;
        }

        private void SetTaskPopupTitle(String TaskId, DataTable dtTaskMasterDetails)
        {
            // If its admin then add delete button else not delete button for normal users.
            lbtnDeleteTask.Visible = this.IsAdminMode;
            ltrlInstallId.Text = dtTaskMasterDetails.Rows[0]["InstallId"].ToString();
            ltrlDateCreated.Text = CommonFunction.FormatDateTimeString(dtTaskMasterDetails.Rows[0]["CreatedOn"]);

            if (dtTaskMasterDetails.Rows[0]["AssigningManager"] != null && !String.IsNullOrEmpty(dtTaskMasterDetails.Rows[0]["AssigningManager"].ToString()))
            {
                ltrlAssigningManager.Text = string.Concat("Created By: ", dtTaskMasterDetails.Rows[0]["AssigningManager"].ToString());
            }

            tblTaskHeader.Visible = true;
        }

        private void SetTaskAssignedUsers(DataTable dtTaskAssignedUserDetails)
        {
            String firstAssignedUser = String.Empty;
            foreach (DataRow row in dtTaskAssignedUserDetails.Rows)
            {

                ListItem item = ddcbAssigned.Items.FindByValue(row["UserId"].ToString());

                if (item != null)
                {
                    item.Selected = true;

                    if (string.IsNullOrEmpty(firstAssignedUser))
                    {
                        firstAssignedUser = item.Text;
                    }
                }
            }

            if (!String.IsNullOrEmpty(firstAssignedUser))
            {
                ddcbAssigned.Texts.SelectBoxCaption = firstAssignedUser;
            }
            else
            {
                ddcbAssigned.Texts.SelectBoxCaption = "--Open--";
            }
        }

        private void SetTaskDesignationDetails(DataTable dtTaskDesignationDetails)
        {
            String firstDesignation = string.Empty;
            if (this.IsAdminMode)
            {
                foreach (DataRow row in dtTaskDesignationDetails.Rows)
                {

                    ListItem item = ddlUserDesignation.Items.FindByText(row["Designation"].ToString());

                    if (item != null)
                    {
                        item.Selected = true;

                        if (string.IsNullOrEmpty(firstDesignation))
                        {
                            firstDesignation = item.Text;
                        }
                    }
                }

                ddlUserDesignation.Texts.SelectBoxCaption = firstDesignation;

                LoadUsersByDesgination();
            }
            else
            {
                StringBuilder designations = new StringBuilder(string.Empty);

                foreach (DataRow row in dtTaskDesignationDetails.Rows)
                {
                    designations.Append(String.Concat(row["Designation"].ToString(), ","));
                }

                ltlTUDesig.Text = String.IsNullOrEmpty(designations.ToString()) == true ? string.Empty : designations.ToString().Substring(0, designations.ToString().Length - 1);
            }
        }

        private void SetTaskUserNNotesDetails(DataTable dtTaskUserDetails)
        {
            gdTaskUsers.DataSource = dtTaskUserDetails;
            gdTaskUsers.DataBind();
        }

        private void SetSubTaskDetails(DataTable dtSubTaskDetails)
        {
            gvSubTasks1.DataSource = dtSubTaskDetails;
            gvSubTasks1.DataBind();

            gvSubTasks.DataSource = dtSubTaskDetails;
            gvSubTasks.DataBind();
            upSubTasks.Update();

            if (dtSubTaskDetails.Rows.Count > 0)
            {
                this.LastSubTaskSequence = dtSubTaskDetails.Rows[dtSubTaskDetails.Rows.Count - 1]["InstallId"].ToString();
            }
            else
            {
                this.LastSubTaskSequence = String.Empty;
            }
        }

        private void SetMasterTaskDetails(DataTable dtTaskMasterDetails)
        {
            this.TaskCreatedBy = Convert.ToInt32(dtTaskMasterDetails.Rows[0]["CreatedBy"]);
            chkTechTask.Checked = Convert.ToBoolean(dtTaskMasterDetails.Rows[0]["IsTechTask"]);
            if (this.IsAdminMode)
            {
                txtTaskTitle.Text = Server.HtmlDecode(dtTaskMasterDetails.Rows[0]["Title"].ToString());
                txtDescription.Text = Server.HtmlDecode(dtTaskMasterDetails.Rows[0]["Description"].ToString());

                //Get selected index of task status
                ListItem item = cmbStatus.Items.FindByValue(dtTaskMasterDetails.Rows[0]["Status"].ToString());

                if (item != null)
                {
                    item.Enabled = true;
                    cmbStatus.SelectedIndex = cmbStatus.Items.IndexOf(item);

                    // disable dropdown and do not allow user to change status
                    // status will be changed only after freezing the specifications.
                    if (item.Value == Convert.ToByte(JGConstant.TaskStatus.SpecsInProgress).ToString())
                    {
                        cmbStatus.Enabled = false;
                    }
                    else
                    {
                        cmbStatus.Enabled = true;
                    }
                }
                else
                {
                    cmbStatus.SelectedIndex = 0;
                }

                item = ddlTaskPriority.Items.FindByValue(dtTaskMasterDetails.Rows[0]["TaskPriority"].ToString());

                if (item != null)
                {
                    ddlTaskPriority.SelectedIndex = ddlTaskPriority.Items.IndexOf(item);
                }
                else
                {
                    ddlTaskPriority.SelectedIndex = 0;
                }

                txtDueDate.Text = CommonFunction.FormatToShortDateString(dtTaskMasterDetails.Rows[0]["DueDate"]);
                txtHours.Text = dtTaskMasterDetails.Rows[0]["Hours"].ToString();

                //hide user view table.
                tblUserTaskView.Visible = false;
            }
            else
            {
                //hide admin view table.
                tblAdminTaskView.Visible = false;
                toggleValidators(false);

                ltlTUTitle.Text = dtTaskMasterDetails.Rows[0]["Title"].ToString();
                txtTUDesc.Text = dtTaskMasterDetails.Rows[0]["Description"].ToString();

                //Get selected index of task status
                ListItem item = ddlTUStatus.Items.FindByValue(dtTaskMasterDetails.Rows[0]["Status"].ToString());

                if (item != null)
                {
                    item.Enabled = true;
                    ddlTUStatus.SelectedIndex = ddlTUStatus.Items.IndexOf(item);

                    // disable dropdown and do not allow user to change status
                    // status will be changed only after freezing the specifications.
                    if (item.Value == Convert.ToByte(JGConstant.TaskStatus.SpecsInProgress).ToString())
                    {
                        ddlTUStatus.Enabled = false;
                    }
                    else
                    {
                        ddlTUStatus.Enabled = true;
                    }
                }
                else
                {
                    ddlTUStatus.SelectedIndex = 0;
                }

                if (!string.IsNullOrEmpty(dtTaskMasterDetails.Rows[0]["TaskPriority"].ToString()))
                {
                    ltrlTaskPriority.Text = ((JGConstant.TaskPriority)Convert.ToByte(dtTaskMasterDetails.Rows[0]["TaskPriority"])).ToString();
                }
                ltlTUDueDate.Text = CommonFunction.FormatToShortDateString(dtTaskMasterDetails.Rows[0]["DueDate"]);
                ltlTUHrsTask.Text = dtTaskMasterDetails.Rows[0]["Hours"].ToString();
            }
            // ddlUserDesignation.SelectedValue = dtTaskMasterDetails.Rows[0]["Designation"].ToString();
            //LoadUsersByDesgination();
        }

        private void toggleValidators(bool flag)
        {
            rfvTaskTitle.Visible = flag;
            rfvDesc.Visible = flag;
            cvDesignations.Visible = flag;
        }

        private void DownloadUserAttachments(String CommaSeperatedFiles)
        {
            string[] files = CommaSeperatedFiles.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

            //var archive = Server.MapPath("~/TaskAttachments/archive.zip");
            //var temp = Server.MapPath("~/TaskAttachments/temp");

            //// clear any existing archive
            //if (System.IO.File.Exists(archive))
            //{
            //    System.IO.File.Delete(archive);
            //}

            //// empty the temp folder
            //Directory.EnumerateFiles(temp).ToList().ForEach(f => System.IO.File.Delete(f));

            //// copy the selected files to the temp folder
            //foreach (var file in files)
            //{
            //    System.IO.File.Copy(file, Path.Combine(temp, Path.GetFileName(file)));
            //}

            //// create a new archive
            //ZipFile.CreateFromDirectory(temp, archive);

            using (ZipFile zip = new ZipFile())
            {
                foreach (var file in files)
                {
                    string filePath = Server.MapPath("~/TaskAttachments/" + file);
                    zip.AddFile(filePath, "files");
                }

                Response.Clear();
                Response.AddHeader("Content-Disposition", "attachment; filename=DownloadedFile.zip");
                Response.ContentType = "application/zip";
                zip.Save(Response.OutputStream);

                Response.End();


            }
        }

        private void DownloadUserAttachment(String File, String OriginalFileName)
        {
            Response.Clear();
            Response.ContentType = "application/octet-stream";
            Response.AppendHeader("Content-Disposition", String.Concat("attachment; filename=", OriginalFileName));
            Response.WriteFile(Server.MapPath("~/TaskAttachments/" + File));
            Response.Flush();
            Response.End();
        }

        private void SetTaskView()
        {
            if (this.IsAdminMode)
            {
                tblAdminTaskView.Visible = true;
                tblUserTaskView.Visible = false;

                gvSubTasks.DataSource = this.lstSubTasks;
                gvSubTasks.DataBind();
            }
            else
            {
                tblAdminTaskView.Visible = false;
                tblUserTaskView.Visible = true;
            }
        }

        private TaskWorkSpecification GetTaskWorkSpecificationById(Int64 intTaskWorkSpecificationId)
        {
            TaskWorkSpecification objTaskWorkSpecification = null;

            DataSet dsTaskWorkSpecification = TaskGeneratorBLL.Instance.GetTaskWorkSpecificationById(intTaskWorkSpecificationId);

            if (
                dsTaskWorkSpecification != null &&
                dsTaskWorkSpecification.Tables.Count > 0 &&
                dsTaskWorkSpecification.Tables[0].Rows.Count > 0
               )
            {
                DataRow drTaskWorkSpecification = dsTaskWorkSpecification.Tables[0].Rows[0];

                #region Store TaskWorkSpecification In ViewState

                objTaskWorkSpecification = new TaskWorkSpecification();
                objTaskWorkSpecification.Id = Convert.ToInt64(drTaskWorkSpecification["Id"]);
                objTaskWorkSpecification.CustomId = Convert.ToString(drTaskWorkSpecification["CustomId"]);
                objTaskWorkSpecification.TaskId = Convert.ToInt64(drTaskWorkSpecification["TaskId"]);
                objTaskWorkSpecification.Description = Convert.ToString(drTaskWorkSpecification["Description"]);

                if (!string.IsNullOrEmpty(Convert.ToString(drTaskWorkSpecification["AdminUserId"])))
                {
                    objTaskWorkSpecification.AdminUserId = Convert.ToInt32(drTaskWorkSpecification["AdminUserId"]);
                    objTaskWorkSpecification.IsAdminInstallUser = Convert.ToBoolean(drTaskWorkSpecification["IsAdminInstallUser"]);
                    objTaskWorkSpecification.AdminUsername = Convert.ToString(drTaskWorkSpecification["AdminUsername"]);
                    objTaskWorkSpecification.AdminUserFirstname = Convert.ToString(drTaskWorkSpecification["AdminUserFirstName"]);
                    objTaskWorkSpecification.AdminUserLastname = Convert.ToString(drTaskWorkSpecification["AdminUserLastName"]);
                    objTaskWorkSpecification.AdminUserEmail = Convert.ToString(drTaskWorkSpecification["AdminUserEmail"]);
                }

                if (!string.IsNullOrEmpty(Convert.ToString(drTaskWorkSpecification["TechLeadUserId"])))
                {
                    objTaskWorkSpecification.AdminUserId = Convert.ToInt32(drTaskWorkSpecification["TechLeadUserId"]);
                    objTaskWorkSpecification.IsAdminInstallUser = Convert.ToBoolean(drTaskWorkSpecification["IsTechLeadInstallUser"]);
                    objTaskWorkSpecification.TechLeadUsername = Convert.ToString(drTaskWorkSpecification["TechLeadUsername"]);
                    objTaskWorkSpecification.TechLeadUserFirstname = Convert.ToString(drTaskWorkSpecification["TechLeadUserFirstName"]);
                    objTaskWorkSpecification.TechLeadUserLastname = Convert.ToString(drTaskWorkSpecification["TechLeadUserLastName"]);
                    objTaskWorkSpecification.TechLeadUserEmail = Convert.ToString(drTaskWorkSpecification["TechLeadUserEmail"]);
                }

                if (!string.IsNullOrEmpty(Convert.ToString(drTaskWorkSpecification["OtherUserId"])))
                {
                    objTaskWorkSpecification.OtherUserId = Convert.ToInt32(drTaskWorkSpecification["OtherUserId"]);
                    objTaskWorkSpecification.IsOtherUserInstallUser = Convert.ToBoolean(drTaskWorkSpecification["IsOtherUserInstallUser"]);
                    objTaskWorkSpecification.OtherUsername = Convert.ToString(drTaskWorkSpecification["OtherUsername"]);
                    objTaskWorkSpecification.OtherUserFirstname = Convert.ToString(drTaskWorkSpecification["OtherUserFirstName"]);
                    objTaskWorkSpecification.OtherUserLastname = Convert.ToString(drTaskWorkSpecification["OtherUserLastName"]);
                    objTaskWorkSpecification.OtherUserEmail = Convert.ToString(drTaskWorkSpecification["OtherUserEmail"]);
                }

                objTaskWorkSpecification.AdminStatus = Convert.ToBoolean(drTaskWorkSpecification["AdminStatus"]);
                objTaskWorkSpecification.TechLeadStatus = Convert.ToBoolean(drTaskWorkSpecification["TechLeadStatus"]);
                objTaskWorkSpecification.OtherUserStatus = Convert.ToBoolean(drTaskWorkSpecification["OtherUserStatus"]);
                objTaskWorkSpecification.DateCreated = Convert.ToDateTime(drTaskWorkSpecification["DateCreated"]);
                objTaskWorkSpecification.DateUpdated = Convert.ToDateTime(drTaskWorkSpecification["DateUpdated"]);

                #endregion
            }

            return objTaskWorkSpecification;
        }

        private void SetPasswordToFreezeWorkSpecificationUI()
        {
            // show link to download working copy for preview for admin users only.
            if (this.IsAdminAndItLeadMode)
            {
                txtITLeadPasswordToFreezeSpecificationMain.Visible =
                txtITLeadPasswordToFreezeSpecificationPopup.Visible =
                txtAdminPasswordToFreezeSpecificationMain.Visible =
                txtAdminPasswordToFreezeSpecificationPopup.Visible = true;

                DataSet dsTaskSpecificationStatus = TaskGeneratorBLL.Instance.GetPendingTaskWorkSpecificationCount(Convert.ToInt32(hdnTaskId.Value));

                // change status only after freezing all specifications.
                // this will change disabled "specs in progress" status to open on feezing.
                if (
                    Convert.ToInt32(dsTaskSpecificationStatus.Tables[0].Rows[0]["TotalRecordCount"]) == 0 ||
                    Convert.ToInt32(dsTaskSpecificationStatus.Tables[1].Rows[0]["PendingRecordCount"]) > 0
                   )
                {
                    //trWorkSpecificationEditor.Visible =
                    //trWorkSpecificationSave.Visible = true;
                    //trWorkSpecificationContent.Visible = false;
                    SetStatusSelectedValue(cmbStatus, Convert.ToByte(JGConstant.TaskStatus.SpecsInProgress).ToString());
                }
                else
                {
                    //trWorkSpecificationSave.Visible =
                    //trWorkSpecificationEditor.Visible = false;
                    //trWorkSpecificationContent.Visible = true;

                    SetStatusSelectedValue(cmbStatus, Convert.ToByte(JGConstant.TaskStatus.Open).ToString());
                }

                if (HttpContext.Current.Session["DesigNew"].ToString().ToUpper().Equals("ITLEAD"))
                {
                    txtAdminPasswordToFreezeSpecificationMain.AutoPostBack =
                    txtAdminPasswordToFreezeSpecificationPopup.AutoPostBack = false;
                }
                else
                {
                    txtITLeadPasswordToFreezeSpecificationMain.AutoPostBack =
                    txtITLeadPasswordToFreezeSpecificationPopup.AutoPostBack = false;
                }

                if (dsTaskSpecificationStatus.Tables[2].Rows.Count > 0)
                {
                    string strLinkText = string.Empty;

                    #region Prepare Profile Links And Password

                    if (Convert.ToBoolean(dsTaskSpecificationStatus.Tables[2].Rows[0]["AdminStatus"].ToString()))
                    {
                        strLinkText += string.Format(
                                                    "<a href='CreatesalesUser.aspx?id={0}' target='_blank' style='margin-right:10px;'>{1} #{0} : {2}</a>",
                                                    dsTaskSpecificationStatus.Tables[2].Rows[0]["AdminUserId"].ToString(),
                                                    string.Concat
                                                            (
                                                                dsTaskSpecificationStatus.Tables[2].Rows[0]["AdminUserFirstName"].ToString(),
                                                                " ",
                                                                dsTaskSpecificationStatus.Tables[2].Rows[0]["AdminUserLastName"].ToString()
                                                            ),
                                                    Convert.ToDateTime(dsTaskSpecificationStatus.Tables[2].Rows[0]["AdminStatusUpdated"]).ToString("MM/dd/yyyy hh:mm tt")
                                                   );

                        txtAdminPasswordToFreezeSpecificationMain.Visible =
                        txtAdminPasswordToFreezeSpecificationPopup.Visible = false;
                    }

                    if (Convert.ToBoolean(dsTaskSpecificationStatus.Tables[2].Rows[0]["TechLeadStatus"].ToString()))
                    {
                        strLinkText += string.Format(
                                                       "<a href='CreatesalesUser.aspx?id={0}' target='_blank' style='margin-right:10px;'>{1} #{0} : {2}</a>",
                                                       dsTaskSpecificationStatus.Tables[2].Rows[0]["TechLeadUserId"].ToString(),
                                                       string.Concat
                                                               (
                                                                   dsTaskSpecificationStatus.Tables[2].Rows[0]["TechLeadUserFirstName"].ToString(),
                                                                   " ",
                                                                   dsTaskSpecificationStatus.Tables[2].Rows[0]["TechLeadUserLastName"].ToString()
                                                               ),
                                                        Convert.ToDateTime(dsTaskSpecificationStatus.Tables[2].Rows[0]["TechLeadStatusUpdated"]).ToString("MM/dd/yyyy hh:mm tt")
                                                    );

                        txtITLeadPasswordToFreezeSpecificationMain.Visible =
                        txtITLeadPasswordToFreezeSpecificationPopup.Visible = false;
                    }

                    #endregion

                    ltrlFreezedSpecificationByUserLinkMain.Text =
                    ltrlFreezedSpecificationByUserLinkPopup.Text = strLinkText;
                }
                else
                {
                    ltrlFreezedSpecificationByUserLinkMain.Text =
                    ltrlFreezedSpecificationByUserLinkPopup.Text = string.Empty;
                }
            }
            else
            {
                //trWorkSpecificationEditor.Visible =
                //trWorkSpecificationSave.Visible =
                //tblAddEditWorkSpecification.Visible = false;
                //trWorkSpecificationContent.Visible = true;
            }
        }

        private void SaveWorkSpecification(TaskWorkSpecification objTaskWorkSpecification)
        {
            #region Insert TaskWorkSpecification

            if (objTaskWorkSpecification.Id == 0)
            {
                TaskGeneratorBLL.Instance.InsertTaskWorkSpecification(objTaskWorkSpecification);
            }
            else
            {
                TaskGeneratorBLL.Instance.UpdateTaskWorkSpecification(objTaskWorkSpecification);
            }

            #endregion

            #region Update Task and Status

            // change status only after freezing all specifications.
            // this will change disabled "specs in progress" status to open on feezing.
            SetPasswordToFreezeWorkSpecificationUI();

            // update task status.
            SaveTask();

            #endregion
        }

        private void SetStatusSelectedValue(DropDownList ddlStatus, string strValue)
        {
            ddlStatus.ClearSelection();

            ListItem objListItem = ddlStatus.Items.FindByValue(strValue);
            if (objListItem != null)
            {
                if (objListItem.Value == Convert.ToByte(JGConstant.TaskStatus.SpecsInProgress).ToString())
                {
                    ddlStatus.Enabled = false;
                }
                else
                {
                    ddlStatus.Enabled = true;
                }
                objListItem.Enabled = true;
                objListItem.Selected = true;
            }
        }

        #endregion
    }
}