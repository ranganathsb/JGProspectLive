using CKEditor.NET;
using JG_Prospect.App_Code;
using JG_Prospect.BLL;
using JG_Prospect.Common.modal;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace JG_Prospect.Sr_App.Controls
{
    public partial class ucTaskWorkSpecifications : System.Web.UI.UserControl
    {
        public delegate Int32 OnInsertTask();
        public OnInsertTask InsertTask;

        public Int32 TaskId
        {
            get
            {
                if (ViewState["TaskId"] == null)
                    return 0;
                return Convert.ToInt32(ViewState["TaskId"]);
            }
            set
            {
                ViewState["TaskId"] = value;
            }
        }

        public bool IsAdminAndItLeadMode
        {
            get
            {
                if (ViewState["IsAdminAndItLeadMode"] == null)
                    return false;
                return Convert.ToBoolean(ViewState["IsAdminAndItLeadMode"]);
            }
            set
            {
                ViewState["IsAdminAndItLeadMode"] = value;
            }
        }

        public Int64? ParentTaskWorkSpecificationId
        {
            get
            {
                if (ViewState["ParentTaskWorkSpecificationId"] == null)
                    return null;
                return Convert.ToInt64(ViewState["ParentTaskWorkSpecificationId"]);
            }
            set
            {
                ViewState["ParentTaskWorkSpecificationId"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            repWorkSpecificationsPager.OnPageIndexChanged += repWorkSpecifications_PageIndexChanged;
        }

        protected void repWorkSpecifications_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                HtmlTableRow trWorkSpecification = e.Item.FindControl("trWorkSpecification") as HtmlTableRow;
                LinkButton lbtnEditWorkSpecification = e.Item.FindControl("lbtnEditWorkSpecification") as LinkButton;
                Literal ltrlCustomId = e.Item.FindControl("ltrlCustomId") as Literal;
                Literal ltrlDescription = e.Item.FindControl("ltrlDescription") as Literal;
                CKEditorControl ckeWorkSpecification = e.Item.FindControl("ckeWorkSpecification") as CKEditorControl;

                LinkButton lbtnAddSubWorkSpecification = e.Item.FindControl("lbtnAddSubWorkSpecification") as LinkButton;
                LinkButton lbtnToggleSubWorkSpecification = e.Item.FindControl("lbtnToggleSubWorkSpecification") as LinkButton;
                PlaceHolder phSubWorkSpecification = e.Item.FindControl("phSubWorkSpecification") as PlaceHolder;

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

                if (repWorkSpecifications_EditIndex.Value == e.Item.ItemIndex.ToString())
                {
                    ltrlCustomId.Visible = true;
                    lbtnEditWorkSpecification.Visible = false;

                    e.Item.FindControl("divViewDescription").Visible = false;
                    e.Item.FindControl("divEditDescription").Visible = true;
                }
                else
                {
                    int intSubTaskWorkSpecificationCount = Convert.ToInt32(drWorkSpecification["SubTaskWorkSpecificationCount"]);

                    if (this.IsAdminAndItLeadMode)
                    {
                        lbtnAddSubWorkSpecification.Visible = (intSubTaskWorkSpecificationCount == 0);
                    }
                    else
                    {
                        lbtnAddSubWorkSpecification.Visible = false;
                    }

                    lbtnToggleSubWorkSpecification.Visible = (intSubTaskWorkSpecificationCount > 0);

                    e.Item.FindControl("divViewDescription").Visible = true;
                    e.Item.FindControl("divEditDescription").Visible = false;
                }

                if (lbtnToggleSubWorkSpecification.CommandName == "show-sub-work-specification")
                {
                    lbtnAddSubWorkSpecification.Visible = this.IsAdminAndItLeadMode;

                    phSubWorkSpecification.Controls.Clear();
                }
                else
                {
                    lbtnAddSubWorkSpecification.Visible = false;
                    ucTaskWorkSpecifications objucTaskWorkSpecifications = LoadControl("~/Sr_App/Controls/ucTaskWorkSpecifications.ascx") as ucTaskWorkSpecifications;
                    objucTaskWorkSpecifications.TaskId = this.TaskId;
                    objucTaskWorkSpecifications.IsAdminAndItLeadMode = this.IsAdminAndItLeadMode;
                    objucTaskWorkSpecifications.ParentTaskWorkSpecificationId = Convert.ToInt64(drWorkSpecification["Id"]);
                    objucTaskWorkSpecifications.FillWorkSpecifications();
                    phSubWorkSpecification.Controls.Add(objucTaskWorkSpecifications);
                }
            }
        }

        protected void repWorkSpecifications_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "edit-work-specification")
            {
                repWorkSpecifications_EditIndex.Value = Convert.ToString(e.CommandArgument);
                FillWorkSpecifications();
            }
            else if (e.CommandName == "cancel-edit-work-specification")
            {
                repWorkSpecifications_EditIndex.Value = "-1";
                FillWorkSpecifications();
            }
            else if (e.CommandName == "save-work-specification")
            {
                #region Update TaskWorkSpecification

                Int32 intRowIndex = Convert.ToInt32(e.CommandArgument);

                Int64 intId = Convert.ToInt64((repWorkSpecifications.Items[intRowIndex].FindControl("hdnId") as HiddenField).Value);

                TaskWorkSpecification objTaskWorkSpecification = GetTaskWorkSpecificationById(intId);

                objTaskWorkSpecification.Description = ((CKEditorControl)repWorkSpecifications.Items[intRowIndex].FindControl("ckeWorkSpecification")).Text;

                // save will revoke freezed status.
                objTaskWorkSpecification.AdminStatus = false;
                objTaskWorkSpecification.TechLeadStatus = false;

                SaveWorkSpecification(objTaskWorkSpecification);

                repWorkSpecifications_EditIndex.Value = "-1";
                FillWorkSpecifications();

                #endregion
            }
            //else if (e.CommandName == "add-sub-work-specification")
            //{
            //    int intItemIndex = Convert.ToInt32(e.CommandArgument);
            //    PlaceHolder phSubWorkSpecification = repWorkSpecifications.Items[intItemIndex].FindControl("phSubWorkSpecification") as PlaceHolder;
            //    HiddenField hdnId = repWorkSpecifications.Items[intItemIndex].FindControl("hdnId") as HiddenField;

            //    ucTaskWorkSpecifications objucTaskWorkSpecifications = LoadControl("~/Sr_App/Controls/ucTaskWorkSpecifications.ascx") as ucTaskWorkSpecifications;
            //    objucTaskWorkSpecifications.TaskId = this.TaskId;
            //    objucTaskWorkSpecifications.IsAdminAndItLeadMode = this.IsAdminAndItLeadMode;
            //    objucTaskWorkSpecifications.ParentTaskWorkSpecificationId = Convert.ToInt64(hdnId.Value);
            //    objucTaskWorkSpecifications.FillWorkSpecifications();
            //    phSubWorkSpecification.Controls.Add(objucTaskWorkSpecifications);
            //}
            else if (e.CommandName == "add-sub-work-specification" || e.CommandName == "show-sub-work-specification")
            {
                int intItemIndex = Convert.ToInt32(e.CommandArgument);
                PlaceHolder phSubWorkSpecification = repWorkSpecifications.Items[intItemIndex].FindControl("phSubWorkSpecification") as PlaceHolder;
                HiddenField hdnId = repWorkSpecifications.Items[intItemIndex].FindControl("hdnId") as HiddenField;
                LinkButton lbtnToggleSubWorkSpecification = e.Item.FindControl("lbtnToggleSubWorkSpecification") as LinkButton;

                ucTaskWorkSpecifications objucTaskWorkSpecifications = LoadControl("~/Sr_App/Controls/ucTaskWorkSpecifications.ascx") as ucTaskWorkSpecifications;
                objucTaskWorkSpecifications.TaskId = this.TaskId;
                objucTaskWorkSpecifications.IsAdminAndItLeadMode = this.IsAdminAndItLeadMode;
                objucTaskWorkSpecifications.ParentTaskWorkSpecificationId = Convert.ToInt64(hdnId.Value);
                objucTaskWorkSpecifications.FillWorkSpecifications();
                phSubWorkSpecification.Controls.Add(objucTaskWorkSpecifications);

                lbtnToggleSubWorkSpecification.CommandName = "hide-sub-work-specification";

                //FillWorkSpecifications();
            }
            else if (e.CommandName == "hide-sub-work-specification")
            {
                int intItemIndex = Convert.ToInt32(e.CommandArgument);
                PlaceHolder phSubWorkSpecification = repWorkSpecifications.Items[intItemIndex].FindControl("phSubWorkSpecification") as PlaceHolder;
                LinkButton lbtnToggleSubWorkSpecification = e.Item.FindControl("lbtnToggleSubWorkSpecification") as LinkButton;

                phSubWorkSpecification.Controls.Clear();

                lbtnToggleSubWorkSpecification.CommandName = "show-sub-work-specification";
            }
        }

        protected void repWorkSpecifications_PageIndexChanged(object sender, EventArgs e)
        {
            repWorkSpecifications_EditIndex.Value = "-1";

            FillWorkSpecifications();
        }

        protected void lbtnInsertWorkSpecification_Click(object sender, EventArgs e)
        {
            btnSaveWorkSpecification_Click(sender, e);
        }

        protected void btnSaveWorkSpecification_Click(object sender, EventArgs e)
        {
            // only admin can update work specification.
            // only admin can update disabled "specs in progress" status by freezing the work specifications.
            if (this.IsAdminAndItLeadMode)
            {
                bool blTaskInserted = false;
                // insert task, if not created yet.
                if (TaskId == 0)
                {
                    blTaskInserted = true;
                    if (InsertTask != null)
                    {
                        TaskId = InsertTask();
                    }
                }

                TaskWorkSpecification objTaskWorkSpecification = new TaskWorkSpecification();
                objTaskWorkSpecification.Id = 0;
                objTaskWorkSpecification.CustomId = ltrlCustomId.Text;
                objTaskWorkSpecification.TaskId = TaskId;
                objTaskWorkSpecification.Description = ckeWorkSpecification.Text;
                objTaskWorkSpecification.Links = string.Empty;
                objTaskWorkSpecification.WireFrame = string.Empty;
                // save will revoke freezed status.
                objTaskWorkSpecification.AdminStatus = false;
                objTaskWorkSpecification.TechLeadStatus = false;

                SaveWorkSpecification(objTaskWorkSpecification);

                // redirect to task generator page or
                // hide popup.
                if (blTaskInserted)
                {
                    RedirectToViewTasks();
                }
                else
                {
                    FillWorkSpecifications();

                    //SetAddEditWorkSpecificationSection(this.TaskWorkSpecificationId);

                    CommonFunction.ShowAlertFromUpdatePanel(this.Page, "Specification updated successfully.");
                }
            }
        }

        public void FillWorkSpecifications()
        {
            string strTaskWorkSpecificationcustomId = string.Empty;

            DataTable dtWorkSpecifications = null;

            if (TaskId == 0)
            {
                dtWorkSpecifications = null;
            }
            else
            {
                DataSet dsWorkSpecifications = TaskGeneratorBLL.Instance.GetTaskWorkSpecifications
                                                                            (
                                                                                TaskId,
                                                                                IsAdminAndItLeadMode,
                                                                                ParentTaskWorkSpecificationId,
                                                                                repWorkSpecificationsPager.PageIndex,
                                                                                repWorkSpecificationsPager.PageSize
                                                                            );
                int intTaskUserFilesCount = 0;
                if (dsWorkSpecifications != null)
                {
                    dtWorkSpecifications = dsWorkSpecifications.Tables[0];
                    intTaskUserFilesCount = Convert.ToInt32(dsWorkSpecifications.Tables[1].Rows[0]["TotalRecordCount"]);

                    if (dtWorkSpecifications.Rows.Count > 0)
                    {
                        strTaskWorkSpecificationcustomId = dtWorkSpecifications.Rows[0]["LastCustomId"].ToString();
                    }
                }
                repWorkSpecificationsPager.FillPager(intTaskUserFilesCount);
            }

            repWorkSpecifications.DataSource = dtWorkSpecifications;
            repWorkSpecifications.DataBind();

            // footer controls
            ltrlCustomId.Text = CommonFunction.GetTaskWorkSpecificationSequence(strTaskWorkSpecificationcustomId);
            ckeWorkSpecification.Text = string.Empty;

            upWorkSpecifications.Update();
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
                objTaskWorkSpecification.Links = Convert.ToString(drTaskWorkSpecification["Links"]);
                objTaskWorkSpecification.WireFrame = Convert.ToString(drTaskWorkSpecification["WireFrame"]);

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

                objTaskWorkSpecification.AdminStatus = Convert.ToBoolean(drTaskWorkSpecification["AdminStatus"]);
                objTaskWorkSpecification.TechLeadStatus = Convert.ToBoolean(drTaskWorkSpecification["TechLeadStatus"]);
                objTaskWorkSpecification.DateCreated = Convert.ToDateTime(drTaskWorkSpecification["DateCreated"]);
                objTaskWorkSpecification.DateUpdated = Convert.ToDateTime(drTaskWorkSpecification["DateUpdated"]);

                #endregion
            }

            return objTaskWorkSpecification;
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

            //#region Update Task and Status

            //// change status only after freezing all specifications.
            //// this will change disabled "specs in progress" status to open on feezing.
            //SetPasswordToFreezeWorkSpecificationUI();

            //// update task status.
            //SaveTask();

            //#endregion
        }

        private void RedirectToViewTasks()
        {
            Response.Redirect("~/sr_app/TaskGenerator.aspx?TaskId=" + TaskId.ToString());
        }

    }
}