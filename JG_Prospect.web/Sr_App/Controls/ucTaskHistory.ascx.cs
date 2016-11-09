using JG_Prospect.BLL;
using JG_Prospect.Common.modal;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using JG_Prospect.Common;

namespace JG_Prospect.Sr_App.Controls
{
    public partial class ucTaskHistory : System.Web.UI.UserControl
    {
        public delegate void LoadTaskData(Int64 intTaskId);

        public LoadTaskData LoadTaskData;

        public Int64 TaskId
        {
            get
            {
                if (ViewState["TaskId"] != null)
                {
                    return Convert.ToInt64(ViewState["TaskId"]);
                }
                return 0;
            }
            set
            {
                ViewState["TaskId"] = value;
            }
        }

        public JGConstant.TaskStatus TaskStatus
        {
            get;
            set;
        }

        public bool UserAcceptance
        {
            get;
            set;
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void linkDownLoadFiles_Click(object sender, EventArgs e)
        {
            LinkButton button = (sender as LinkButton);
            DownLoadFileFromServer(button.CommandName, button.CommandArgument);
        }

        protected void gdTaskUsersNotes_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gdTaskUsersNotes.EditIndex = e.NewEditIndex;
            LoadTaskData(TaskId);
        }

        protected void gdTaskUsersNotes_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            TaskUser taskUser = new TaskUser();

            TextBox note = (TextBox)gdTaskUsersNotes.Rows[e.RowIndex].FindControl("txtNotes");
            Label NoteId = (Label)gdTaskUsersNotes.Rows[e.RowIndex].FindControl("lblNoteId");

            hdnNoteId.Value = NoteId.Text;
            taskUser.Notes = note.Text;
            taskUser.UserId = Convert.ToInt32(Session[SessionKey.Key.UserId.ToString()]);
            taskUser.UserFirstName = Session["Username"].ToString();
            taskUser.Id = Convert.ToInt64(hdnNoteId.Value);
            if (!string.IsNullOrEmpty(taskUser.Notes))
                taskUser.FileType = Convert.ToString((int)JGConstant.TaskUserFileType.Notes);
            taskUser.IsCreatorUser = false;
            taskUser.TaskId = TaskId;
            taskUser.Status = Convert.ToInt16(TaskStatus);
            taskUser.UserAcceptance = UserAcceptance;
            TaskGeneratorBLL.Instance.UpadateTaskNotes(ref taskUser);

            gdTaskUsersNotes.EditIndex = -1;
            LoadTaskData(TaskId);
        }

        protected void gdTaskUsersNotes_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gdTaskUsersNotes.EditIndex = -1;
            LoadTaskData(TaskId);
        }

        protected void gdTaskUsers_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gdTaskUsers.EditIndex = e.NewEditIndex;
            LoadTaskData(TaskId);
        }

        protected void gdTaskUsers_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            TaskUser taskUser = new TaskUser();

            TextBox note = (TextBox)gdTaskUsers.Rows[e.RowIndex].FindControl("txtNotes");
            Label NoteId = (Label)gdTaskUsers.Rows[e.RowIndex].FindControl("lblNoteId");

            hdnNoteId.Value = NoteId.Text;
            taskUser.Notes = note.Text;
            taskUser.UserId = Convert.ToInt32(Session[SessionKey.Key.UserId.ToString()]);
            taskUser.UserFirstName = Session["Username"].ToString();
            taskUser.Id = Convert.ToInt64(hdnNoteId.Value);
            if (!string.IsNullOrEmpty(taskUser.Notes))
                taskUser.FileType = Convert.ToString((int)Common.JGConstant.TaskUserFileType.Notes);
            taskUser.IsCreatorUser = false;
            taskUser.TaskId = Convert.ToInt64(TaskId);
            taskUser.Status = Convert.ToInt16(TaskStatus);
            taskUser.UserAcceptance = UserAcceptance;
            TaskGeneratorBLL.Instance.UpadateTaskNotes(ref taskUser);

            gdTaskUsers.EditIndex = -1;
            LoadTaskData(TaskId);
        }

        protected void gdTaskUsers_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gdTaskUsers.EditIndex = -1;
            LoadTaskData(TaskId);
        }

        public void DownLoadFileFromServer(string fileOrinalName, string fileActualFile)
        {
            Response.Clear();
            Response.AppendHeader("content-disposition", "attachment; filename=" + fileOrinalName);
            Response.ContentType = "application/octet-stream";
            Response.WriteFile(Server.MapPath("~/TaskAttachments/" + fileActualFile));
            Response.Flush();
            Response.End();
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }

    }
}