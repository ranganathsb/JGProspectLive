﻿#region '--using--'

using JG_Prospect.App_Code;
using JG_Prospect.BLL;
using JG_Prospect.Common;
using JG_Prospect.Common.modal;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

#endregion

namespace JG_Prospect.Sr_App.Controls
{
    public partial class ucSubTasks : System.Web.UI.UserControl
    {
        #region '--Properties--'

        public int TaskId { get; set; }

        public string controlMode { get; set; }

        public bool IsAdminMode { get; set; }

        public String LastSubTaskSequence
        {
            get
            {
                if (ViewState["LastSubTaskSequence"] != null)
                {
                    return ViewState["LastSubTaskSequence"].ToString();
                }
                return string.Empty;
            }
            set
            {
                ViewState["LastSubTaskSequence"] = value;
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

        #endregion

        #region '--Page Events--'

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                FillInitialData();
            }
        }

        #endregion

        #region '--Control Events--'

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

                if (!string.IsNullOrEmpty(DataBinder.Eval(e.Row.DataItem, "TaskType").ToString()))
                {
                    (e.Row.FindControl("ltrlTaskType") as Literal).Text = CommonFunction.GetTaskTypeList().FindByValue(DataBinder.Eval(e.Row.DataItem, "TaskType").ToString()).Text;
                }

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

                    if (controlMode == "0")
                    {
                        ddlTaskPriority.Attributes.Add("SubTaskIndex", e.Row.RowIndex.ToString());
                    }
                    else
                    {
                        ddlTaskPriority.Attributes.Add("TaskId", DataBinder.Eval(e.Row.DataItem, "TaskId").ToString());
                    }
                }

                SetStatusSelectedValue(ddlStatus, DataBinder.Eval(e.Row.DataItem, "Status").ToString());

                if (this.IsAdminMode)
                {
                    e.Row.FindControl("ltrlInstallId").Visible = false;
                }
                else
                {
                    e.Row.FindControl("lbtnInstallId").Visible = false;

                    if (!ddlStatus.SelectedValue.Equals(Convert.ToByte(JGConstant.TaskStatus.ReOpened).ToString()))
                    {
                        ddlStatus.Items.FindByValue(Convert.ToByte(JGConstant.TaskStatus.ReOpened).ToString()).Enabled = false;
                    }
                }

                if (controlMode == "0")
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

                CheckBox chkAdmin = e.Row.FindControl("chkAdmin") as CheckBox;
                CheckBox chkITLead = e.Row.FindControl("chkITLead") as CheckBox;
                CheckBox chkUser = e.Row.FindControl("chkUser") as CheckBox;

                TextBox txtPasswordToFreezeSubTask = e.Row.FindControl("txtPasswordToFreezeSubTask") as TextBox;

                bool blAdminStatus = Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "AdminStatus"));
                bool blTechLeadStatus = Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "TechLeadStatus"));
                bool blOtherUserStatus = Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "OtherUserStatus"));

                chkAdmin.Checked = blAdminStatus;
                chkITLead.Checked = blTechLeadStatus;
                chkUser.Checked = blOtherUserStatus;

                chkAdmin.Enabled = !blAdminStatus;
                chkITLead.Enabled = !blTechLeadStatus;
                chkUser.Enabled = !blOtherUserStatus;
                
                SetFreezeColumnUI(txtPasswordToFreezeSubTask, chkAdmin, chkITLead, chkUser);

                if (chkAdmin.Enabled)
                {
                    chkAdmin.Attributes.Add("onclick", "ucSubTasks_OnApprovalCheckBoxChanged(this);");
                }
                if (chkITLead.Enabled)
                {
                    chkITLead.Attributes.Add("onclick", "ucSubTasks_OnApprovalCheckBoxChanged(this);");
                }
                if (chkUser.Enabled)
                {
                    chkUser.Attributes.Add("onclick", "ucSubTasks_OnApprovalCheckBoxChanged(this);");
                }

                if (blAdminStatus && blTechLeadStatus && blOtherUserStatus) 
                {
                    e.Row.FindControl("ltrlInstallId").Visible = true;
                    e.Row.FindControl("lbtnInstallId").Visible = false;
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

                if (controlMode == "0")
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
            if (controlMode == "0")
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

                SetSubTaskDetails();
            }
        }

        protected void gvSubTasks_ddlTaskPriority_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddlTaskPriority = sender as DropDownList;
            if (controlMode == "0")
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

                SetSubTaskDetails();
            }
        }

        protected void gvSubTasks_txtPasswordToFreezeSubTask_TextChanged(object sender, EventArgs e)
        {
            TextBox txtPassword = sender as TextBox;
            GridViewRow objGridViewRow = txtPassword.Parent.Parent as GridViewRow;

            if (txtPassword != null && !string.IsNullOrEmpty(txtPassword.Text))
            {
                if (!txtPassword.Text.Equals(Convert.ToString(Session["loginpassword"])))
                {
                    CommonFunction.ShowAlertFromUpdatePanel(this.Page, "Sub Task cannot be freezed as password is not valid.");
                }
                else
                {
                    #region Update Task (Freeze, Status)

                    if (objGridViewRow != null)
                    {
                        Task objTask = new Task();

                        objTask.TaskId = Convert.ToInt32(gvSubTasks.DataKeys[objGridViewRow.RowIndex]["TaskId"].ToString());

                        bool blIsAdmin, blIsTechLead, blIsUser;

                        blIsAdmin = blIsTechLead = blIsUser = false;
                        if (HttpContext.Current.Session["DesigNew"].ToString().ToUpper().Equals("ADMIN"))
                        {
                            objTask.AdminUserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                            objTask.IsAdminInstallUser = JGSession.IsInstallUser.Value;
                            objTask.AdminStatus = true;
                            blIsAdmin = true;
                        }
                        else if (HttpContext.Current.Session["DesigNew"].ToString().ToUpper().Equals("ITLEAD"))
                        {
                            objTask.TechLeadUserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                            objTask.IsTechLeadInstallUser = JGSession.IsInstallUser.Value;
                            objTask.TechLeadStatus = true;
                            blIsTechLead = true;
                        }
                        else
                        {
                            objTask.OtherUserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                            objTask.IsOtherUserInstallUser = JGSession.IsInstallUser.Value;
                            objTask.OtherUserStatus = true;
                            blIsUser = true;
                        }

                        TaskGeneratorBLL.Instance.UpdateSubTaskStatusById
                                                    (
                                                        objTask,
                                                        blIsAdmin,
                                                        blIsTechLead,
                                                        blIsUser
                                                    );

                        CommonFunction.ShowAlertFromUpdatePanel(this.Page, "Sub Task freezed successfully.");
                    }

                    #endregion

                    SetSubTaskDetails();
                }
            }
        }

        #endregion

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

        #region '--Methods--'

        protected string SetFreezeColumnUI(TextBox objTextBox, CheckBox chkAdmin, CheckBox chkITLead, CheckBox chkUser)
        {
            string strPlaceholder = string.Empty;
            if (Session["DesigNew"].ToString().ToUpper().Equals("ADMIN"))
            {
                strPlaceholder = "Admin Password";
                chkITLead.Enabled = 
                chkUser.Enabled = false;
            }
            else if (Session["DesigNew"].ToString().ToUpper().Equals("ITLEAD"))
            {
                strPlaceholder = "IT Lead Password";
                chkAdmin.Enabled =
                chkUser.Enabled = false;
            }
            else
            {
                strPlaceholder = "User Password";
                chkAdmin.Enabled =
                chkITLead.Enabled = false;
            }

            objTextBox.Attributes.Add("placeholder", strPlaceholder);
            return strPlaceholder;
        }

        private DataTable GetSubTasks()
        {
            return TaskGeneratorBLL.Instance.GetSubTasks(TaskId, CommonFunction.CheckAdminAndItLeadMode()).Tables[0];
        }

        public void SetSubTaskDetails(List<Task> lstSubtasks)
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
            dtSubtasks.Columns.Add("AdminStatus");
            dtSubtasks.Columns.Add("TechLeadStatus");
            dtSubtasks.Columns.Add("OtherUserStatus");

            foreach (Task objSubTask in lstSubtasks)
            {
                dtSubtasks.Rows.Add(
                                        objSubTask.TaskId, 
                                        objSubTask.Title, 
                                        objSubTask.Description, 
                                        objSubTask.Status, 
                                        objSubTask.DueDate, 
                                        objSubTask.Hours, 
                                        objSubTask.InstallId, 
                                        string.Empty, 
                                        objSubTask.TaskType, 
                                        objSubTask.Attachment, 
                                        objSubTask.TaskPriority, 
                                        objSubTask.AdminStatus,
                                        objSubTask.TechLeadStatus,
                                        objSubTask.OtherUserStatus
                                    );
            }

            gvSubTasks.DataSource = dtSubtasks;
            gvSubTasks.DataBind();

            // do not show freezing option while adding new task.
            gvSubTasks.Columns[6].Visible = false;

            upSubTasks.Update();
        }

        public void SetSubTaskDetails()
        {
            DataTable dtSubTaskDetails = GetSubTasks();
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

        private void FillInitialData()
        {
            FillDropDrowns();

            if (controlMode == "0")
            {
                gvSubTasks.DataSource = this.lstSubTasks;
                gvSubTasks.DataBind();
            }
        }

        private void FillDropDrowns()
        {
            ddlSubTaskStatus.DataSource = CommonFunction.GetTaskStatusList();
            ddlSubTaskStatus.DataTextField = "Text";
            ddlSubTaskStatus.DataValueField = "Value";
            ddlSubTaskStatus.DataBind();
            ddlSubTaskStatus.Items.FindByValue(Convert.ToByte(JGConstant.TaskStatus.SpecsInProgress).ToString()).Enabled = false;

            ddlSubTaskPriority.DataSource = CommonFunction.GetTaskPriorityList();
            ddlSubTaskPriority.DataTextField = "Text";
            ddlSubTaskPriority.DataValueField = "Value";
            ddlSubTaskPriority.DataBind();

            ddlTaskType.DataSource = CommonFunction.GetTaskTypeList();
            ddlTaskType.DataTextField = "Text";
            ddlTaskType.DataValueField = "Value";
            ddlTaskType.DataBind();
        }

        public void SetSubTaskView()
        {
            divAddSubTask.Visible = this.IsAdminMode;
            upAddSubTask.Update();
        }

        public void SaveSubTasks(Int32 intTaskId)
        {
            if (this.lstSubTasks.Any())
            {
                foreach (Task objSubTask in this.lstSubTasks)
                {
                    objSubTask.ParentTaskId = intTaskId;
                    // save task master details to database.
                    hdnSubTaskId.Value = TaskGeneratorBLL.Instance.SaveOrDeleteTask(objSubTask).ToString();

                    UploadUserAttachements(null, Convert.ToInt64(hdnSubTaskId.Value), objSubTask.Attachment, JGConstant.TaskFileDestination.SubTask);
                }
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
            objTask.ParentTaskId = TaskId;
            objTask.Attachment = hdnAttachments.Value;

            if (ddlTaskType.SelectedIndex > 0)
            {
                objTask.TaskType = Convert.ToInt16(ddlTaskType.SelectedValue);
            }

            if (controlMode == "0")
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

                SetSubTaskDetails();
            }
            hdnAttachments.Value = string.Empty;
            ClearSubTaskData();
        }

        public void ClearSubTaskData()
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
            if (ddlSubTaskStatus.Items.Count > 0)
            {
                ddlSubTaskStatus.Items.FindByValue(Convert.ToByte(JGConstant.TaskStatus.Open).ToString()).Selected = true;
                ddlSubTaskStatus.Items.FindByValue(Convert.ToByte(JGConstant.TaskStatus.ReOpened).ToString()).Enabled = true;
            }
            ddlSubTaskPriority.SelectedValue = "0";
            upAddSubTask.Update();
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

        private void UploadUserAttachements(int? taskUpdateId, long TaskId, string attachments, JG_Prospect.Common.JGConstant.TaskFileDestination objTaskFileDestination)
        {
            //User has attached file than save it to database.
            if (!String.IsNullOrEmpty(attachments))
            {
                TaskUser taskUserFiles = new TaskUser();

                if (!string.IsNullOrEmpty(attachments))
                {
                    String[] files = attachments.Split(new char[] { '^' }, StringSplitOptions.RemoveEmptyEntries);

                    foreach (String attachment in files)
                    {
                        String[] attachements = attachment.Split('@');

                        taskUserFiles.Attachment = attachements[0];
                        taskUserFiles.OriginalFileName = attachements[1];
                        taskUserFiles.Mode = 0; // insert data.
                        taskUserFiles.TaskId = TaskId;
                        taskUserFiles.UserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                        taskUserFiles.TaskUpdateId = taskUpdateId;
                        taskUserFiles.UserType = JGSession.IsInstallUser ?? false;
                        taskUserFiles.TaskFileDestination = objTaskFileDestination;
                        TaskGeneratorBLL.Instance.SaveOrDeleteTaskUserFiles(taskUserFiles);  // save task files
                    }
                }
            }
        }

        #endregion
    }
}