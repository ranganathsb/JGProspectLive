using JG_Prospect.BLL;
using JG_Prospect.Common.modal;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Configuration;
using System.Web;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.Net.Mail;
using JG_Prospect.Common.Logger;
using JG_Prospect.Common;

using JG_Prospect.App_Code;
using System.Collections;
using JG_Prospect.DAL.Database;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System.Data.SqlClient;
using System.Data;
using System.Data.Common;
using JG_Prospect.DAL.Database;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;


namespace JG_Prospect.Sr_App
{
    public partial class home : System.Web.UI.Page
    {
        ErrorLog logManager = new ErrorLog();
        protected void Page_Load(object sender, EventArgs e)
        {
            JG_Prospect.App_Code.CommonFunction.AuthenticateUser();

            if (!Page.IsPostBack)
            {
                //Session["AppType"] = "SrApp";
                //if ((string)Session["usertype"] == "SM" || (string)Session["usertype"] == "SSE" || (string)Session["usertype"] == "MM")
                //{
                //    li_AnnualCalender.Visible = true;
                //}
                //if ((string)Session["usertype"] == "Admin")
                //{
                //    pnlTestEmail.Visible = true;
                //}
                FillDesignation();
                if ((string)Session["DesigNew"] == "ITLead" || (string)Session["DesigNew"] == "Admin" || (string)Session["DesigNew"] == "Office Manager")
                {
                    tblInProgress.Visible = true;
                    tblClosedTask.Visible = true;
                }
                else
                {
                    tblInProgress.Visible = false;
                    tblClosedTask.Visible = false;
                }
                LoadFilterUsersByDesgination("");
                BindTaskInProgressGrid();
                BindTaskClosedGrid();
            }
            lblMessage.Text = "";
        }

        protected void drpDesigInProgress_SelectedIndexChanged(object sender, EventArgs e)
        {
            string designation = drpDesigInProgress.SelectedValue;
            LoadFilterUsersByDesgination(designation);
            //SearchTasks(null);
            BindTaskInProgressGrid();
        }

        protected void drpDesigClosed_SelectedIndexChanged(object sender, EventArgs e)
        {
            string designation = drpDesigClosed.SelectedValue;
            LoadFilterUsersByDesgination(designation);
            //SearchTasks(null);
            BindTaskClosedGrid();
        }
        protected void drpUsersInProgress_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindTaskInProgressGrid();
        }

        protected void drpUsersClosed_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindTaskClosedGrid();
        }
        private void LoadFilterUsersByDesgination(string designation)
        {
            DataSet dsUsers;
            // DropDownCheckBoxes ddlAssign = (FindControl("ddcbAssigned") as DropDownCheckBoxes);
            // DropDownList ddlDesignation = (DropDownList)sender;
            dsUsers = TaskGeneratorBLL.Instance.GetInstallUsers(2, designation);
            //drpUsersInProgress.Items.Clear();
           
            drpUsersInProgress.DataSource = dsUsers;
            drpUsersInProgress.DataTextField = "FristName";
            drpUsersInProgress.DataValueField = "Id";
            drpUsersInProgress.DataBind();
            drpUsersInProgress.Items.Insert(0, new ListItem("--All--", "0"));
            drpUsersInProgress.SelectedIndex = 0;

            drpUsersClosed.DataSource = dsUsers;
            drpUsersClosed.DataTextField = "FristName";
            drpUsersClosed.DataValueField = "Id";
            drpUsersClosed.DataBind();
            drpUsersClosed.Items.Insert(0, new ListItem("--All--", "0"));
            drpUsersClosed.SelectedIndex = 0;

        }

        private void FillDesignation()
        {
            DataSet dsDesignation = DesignationBLL.Instance.GetActiveDesignationByID(0, 1);
            //drpDesigInProgress .Items.Clear();
            
            drpDesigInProgress.DataValueField = "Id";
            drpDesigInProgress.DataTextField = "DesignationName";
            drpDesigInProgress.DataSource = dsDesignation.Tables[0];
            drpDesigInProgress.DataBind();
            drpDesigInProgress.Items.Insert(0, new ListItem("--All--", "0"));
            drpDesigInProgress.SelectedIndex = 0;


            drpDesigClosed .DataValueField = "Id";
            drpDesigClosed.DataTextField = "DesignationName";
            drpDesigClosed.DataSource = dsDesignation.Tables[0];
            drpDesigClosed.DataBind();
            drpDesigClosed.Items.Insert(0, new ListItem("--All--", "0"));
            drpDesigClosed.SelectedIndex = 0;
        }

       private void BindTaskInProgressGrid()
        {
            DataSet ds = new DataSet();

            int userId = 0;
            int desigID = 0;
            if ((string)Session["DesigNew"] == "ITLead" || (string)Session["DesigNew"] == "Admin" || (string)Session["DesigNew"] == "Office Manager")
            {
                userId = 0;
                if (Convert.ToInt32(drpUsersInProgress.SelectedValue) > 0)
                {
                    userId = Convert.ToInt32(drpUsersInProgress.SelectedValue);
                }
            }
            else
            {
                userId = Convert.ToInt16(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
            }
            if(Convert.ToInt32(drpDesigInProgress.SelectedValue)>0)
            {
                desigID = Convert.ToInt32(drpDesigInProgress.SelectedValue);
            }

            // if loggedin user is not manager then show tasks assigned to loggedin user only 
            ds = TaskGeneratorBLL.Instance.GetInProgressTasks(userId, desigID);
            if (ds.Tables[0].Rows.Count > 0)
            {
                grdTaskPending.DataSource = ds;
                grdTaskPending.DataBind();
            }
            else
            {
                //lblMessage.Text = "No In-Progress Tasks Found !!!";
                grdTaskPending.DataSource = null;
                grdTaskPending.DataBind();

            }
        }

        private void BindTaskClosedGrid()
        {
            DataSet ds = new DataSet();

            int userId = 0;
            int desigID = 0;
            if ((string)Session["DesigNew"] == "ITLead" || (string)Session["DesigNew"] == "Admin" || (string)Session["DesigNew"] == "Office Manager")
            {
                userId = 0;
                if (Convert.ToInt32(drpUsersClosed.SelectedValue) > 0)
                {
                    userId = Convert.ToInt32(drpUsersClosed.SelectedValue);
                }
            }
            else
            {
                userId = Convert.ToInt16(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
            }
            if (Convert.ToInt32(drpDesigClosed.SelectedValue) > 0)
            {
                desigID = Convert.ToInt32(drpDesigClosed.SelectedValue);
            }

            // if loggedin user is not manager then show tasks assigned to loggedin user only 
            ds = TaskGeneratorBLL.Instance.GetClosedTasks(userId, desigID);
            if (ds.Tables[0].Rows.Count > 0)
            {
                grdTaskClosed.DataSource = ds;
                grdTaskClosed.DataBind();
            }
            else
            {
                //lblMessage.Text = "No In-Progress Tasks Found !!!";
                grdTaskClosed.DataSource = null;
                grdTaskClosed.DataBind();

            }
        }

        protected void OnPagingTaskInProgress(object sender, GridViewPageEventArgs e)
        {
            BindTaskInProgressGrid();
            
            grdTaskPending.PageIndex = e.NewPageIndex;
            grdTaskPending.DataBind();
        }

        protected void OnPagingTaskClosed(object sender, GridViewPageEventArgs e)
        {
            BindTaskClosedGrid();
            grdTaskClosed.PageIndex = e.NewPageIndex;
            grdTaskClosed.DataBind();
        }

        protected void grdTaskPending_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                HiddenField lblStatus = e.Row.FindControl("lblStatus") as HiddenField;
                Label lblDueDate = e.Row.FindControl("lblDueDate") as Label;
                DropDownList drpStatusInPro = e.Row.FindControl("drpStatusInPro") as DropDownList;
                HiddenField lblTaskIdInPro = e.Row.FindControl("lblTaskIdInPro") as HiddenField;
                Label lblHoursLead = e.Row.FindControl("lblHoursLeadInPro") as Label;
                Label lblHoursDev = e.Row.FindControl("lblHoursDevInPro") as Label;
                LinkButton lnkInstallId = e.Row.FindControl("lnkInstallId") as LinkButton;
                HiddenField lblParentTaskIdInPro = e.Row.FindControl("lblParentTaskIdInPro") as HiddenField;

                lnkInstallId.PostBackUrl = "~/Sr_App/TaskGenerator.aspx?TaskId=" + lblParentTaskIdInPro.Value + "&hstid=" + lblTaskIdInPro.Value;

                if (lblDueDate.Text != "")
                {
                    DateTime dtDue = new DateTime();
                    dtDue = Convert.ToDateTime(lblDueDate.Text);
                    lblDueDate.Text = dtDue.ToString("dd-MMM-yyyy");
                }

                if (lblStatus.Value  == "4")
                {
                    //lblStatus.Value = "In Progress";
                    e.Row.BackColor = System.Drawing.Color.Orange;
                }
                else if (lblStatus.Value == "3")
                {
                    //lblStatus.Value = "Assigned";
                    //lblStatus.ForeColor = System.Drawing.Color.LawnGreen;
                    e.Row.BackColor = System.Drawing.Color.Yellow;
                }
                else if (lblStatus.Value == "2")
                {
                    //lblStatus.Value = "Requested";
                    //lblStatus.ForeColor = System.Drawing.Color.Red;
                    e.Row.BackColor = System.Drawing.Color.Yellow;
                }
                else if (lblStatus.Value == "1")
                {
                    //lblStatus.Value = "Open";
                    e.Row.BackColor = System.Drawing.Color.Transparent;
                }

                try
                {
                    int vTaskId = Convert.ToInt32(lblTaskIdInPro.Value);
                    SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                    {
                        DataSet result = new DataSet();
                        DbCommand command = database.GetSqlStringCommand("select a.* ,b.Designation from tbltaskapprovals as a,tblInstallusers as b where a.UserId=b.Id and  a.TaskId=" + vTaskId);
                        command.CommandType = CommandType.Text;
                        result = database.ExecuteDataSet(command);
                        if (result.Tables[0].Rows.Count > 0)
                        {
                            for(int i=0;i<result.Tables[0].Rows.Count ;i++)
                            {
                                if (result.Tables[0].Rows[i]["EstimatedHours"] != null && result.Tables[0].Rows[i]["EstimatedHours"]!="")
                                {
                                    if (result.Tables[0].Rows[i]["Designation"].ToString() == "ITLead" || result.Tables[0].Rows[i]["Designation"].ToString() == "Admin")
                                    {
                                        lblHoursLead.Text = "ITLead : " + result.Tables[0].Rows[i]["EstimatedHours"].ToString() + " Hrs";
                                    }
                                    else
                                    {
                                        lblHoursDev.Text = "Developer : " + result.Tables[0].Rows[i]["EstimatedHours"].ToString() + " Hrs";
                                    }
                                }
                            }
                        }
                        result.Dispose();
                    }
                }

                catch (Exception ex)
                {
                    // return 0;
                    //LogManager.Instance.WriteToFlatFile(ex);
                }

                // fill status dropdowns
                //----- If manager level then show all statuses
                if ((string)Session["DesigNew"] == "ITLead" || (string)Session["DesigNew"] == "Admin" || (string)Session["DesigNew"] == "Office Manager")
                {
                    //drpStatusInPro.DataSource = CommonFunction.GetTaskStatusList();
                    string[] arrStatus = new string[] { JGConstant.TaskStatus.Open.ToString(),JGConstant.TaskStatus.Requested.ToString(), 
                        JGConstant.TaskStatus.Assigned.ToString(), JGConstant.TaskStatus.InProgress.ToString(),
                        JGConstant.TaskStatus.Pending.ToString(),  JGConstant.TaskStatus.ReOpened.ToString(),
                        JGConstant.TaskStatus.Closed.ToString() ,JGConstant.TaskStatus.SpecsInProgress.ToString(),
                        JGConstant.TaskStatus.Deleted.ToString(),JGConstant.TaskStatus.Finished.ToString(),
                        JGConstant.TaskStatus.Test.ToString(),JGConstant.TaskStatus.Live.ToString(),JGConstant.TaskStatus.Billed.ToString(),
                    };
                    drpStatusInPro.DataSource = FillStatusDropDowns(arrStatus); 
                    drpStatusInPro.DataTextField = "Text";
                    drpStatusInPro.DataValueField = "Value";
                    drpStatusInPro.DataBind();
                    drpStatusInPro.Items.Insert(0, new ListItem("--All--", "0"));
                    
                    for(int i=0;i<drpStatusInPro.Items.Count;i++)
                    {
                        if (drpStatusInPro.Items[i].Text == "Assigned")
                        {
                            drpStatusInPro.Items[i].Attributes.CssStyle.Add("color", "LawnGreen");
                        }
                        if (drpStatusInPro.Items[i].Text == "Requested")
                        {
                            drpStatusInPro.Items[i].Attributes.CssStyle.Add("color", "Red");
                        }

                        if(lblStatus.Value==drpStatusInPro.Items[i].Value)
                        {
                            drpStatusInPro.SelectedIndex = i;
                        }

                    }

                }
                else
                {
                    //----- If user level then show Test,Live,Finished statuses
                    string[] arrStatus = new string[] { JGConstant.TaskStatus.Requested.ToString(), JGConstant.TaskStatus.Assigned.ToString(), JGConstant.TaskStatus.Open.ToString(), JGConstant.TaskStatus.InProgress.ToString(), JGConstant.TaskStatus.Test.ToString(),  JGConstant.TaskStatus.Finished.ToString() };
                    drpStatusInPro.DataSource = FillStatusDropDowns(arrStatus);  //objListItemCollection;
                    drpStatusInPro.DataTextField = "Text";
                    drpStatusInPro.DataValueField = "Value";
                    drpStatusInPro.DataBind();
                    drpStatusInPro.Items.Insert(0, new ListItem("--All--", "0"));
                    for (int i = 0; i < drpStatusInPro.Items.Count; i++)
                    {
                        if (drpStatusInPro.Items[i].Text == "Assigned")
                        {
                            drpStatusInPro.Items[i].Attributes.CssStyle.Add("color", "LawnGreen");
                        }
                        if (drpStatusInPro.Items[i].Text == "Requested")
                        {
                            drpStatusInPro.Items[i].Attributes.CssStyle.Add("color", "Red");
                        }

                        if (lblStatus.Value == drpStatusInPro.Items[i].Value)
                        {
                            drpStatusInPro.SelectedIndex = i;
                        }
                    }
                }
            }
        }


        private System.Web.UI.WebControls.ListItemCollection FillStatusDropDowns(string[] lst)
        {
            ListItemCollection objListItemCollection = new ListItemCollection();
            int enumlen = Enum.GetNames(typeof(JGConstant.TaskStatus)).Length;

            foreach (var item in Enum.GetNames(typeof(JGConstant.TaskStatus)))
            {
                for (int j=0;j<lst.Length ;j++)
                {
                    if(lst[j]==  item)
                    {
                        int enumval =  (int)Enum.Parse(typeof(JGConstant.TaskStatus), item);
                        objListItemCollection.Add(new ListItem(item, enumval.ToString()));
                        
                        break;
                    }
                }
            }
            return objListItemCollection;
        }

        protected void grdTaskClosed_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                HiddenField lblStatus = e.Row.FindControl("lblStatus") as HiddenField;
                Label lblDueDate = e.Row.FindControl("lblDueDate") as Label;
                DropDownList drpStatusClosed = e.Row.FindControl("drpStatusClosed") as DropDownList;
                HiddenField lblTaskIdClosed = e.Row.FindControl("lblTaskIdClosed") as HiddenField;
               
                LinkButton lnkInstallId = e.Row.FindControl("lnkInstallId") as LinkButton;
                HiddenField lblParentTaskIdClosed = e.Row.FindControl("lblParentTaskIdClosed") as HiddenField;

                lnkInstallId.PostBackUrl = "~/Sr_App/TaskGenerator.aspx?TaskId=" + lblParentTaskIdClosed.Value + "&hstid=" + lblTaskIdClosed.Value;

                if (lblDueDate.Text != "")
                {
                    DateTime dtDue = new DateTime();
                    dtDue = Convert.ToDateTime(lblDueDate.Text);
                    lblDueDate.Text = dtDue.ToString("dd-MMM-yyyy");
                }

                if (lblStatus.Value == "7")
                {
                    //lblStatus.Value = "In Progress"
                    e.Row.BackColor = System.Drawing.Color.LightGray;
                }
                else if (lblStatus.Value == "13")
                {
                    //lblStatus.Value = "Assigned";
                    //lblStatus.ForeColor = System.Drawing.Color.LawnGreen;
                    e.Row.BackColor = System.Drawing.Color.Green;
                }
                else if (lblStatus.Value == "9")
                {
                    //lblStatus.Value = "Requested";
                    //lblStatus.ForeColor = System.Drawing.Color.Red;
                    e.Row.BackColor = System.Drawing.Color.Gray;
                }
                else
                {
                    e.Row.BackColor = System.Drawing.Color.Transparent;
                }
                
                int vTaskId = Convert.ToInt32(lblTaskIdClosed.Value);
                    
                // fill status dropdowns
                //----- If manager level then show all statuses

                string[] arrStatus;
                if (  (string)Session["DesigNew"] == "Admin" )
                {
                     arrStatus = new string[] { JGConstant.TaskStatus.Open.ToString(),JGConstant.TaskStatus.Requested.ToString(), 
                        JGConstant.TaskStatus.Assigned.ToString(), JGConstant.TaskStatus.InProgress.ToString(),
                        JGConstant.TaskStatus.Pending.ToString(),  JGConstant.TaskStatus.ReOpened.ToString(),
                        JGConstant.TaskStatus.Closed.ToString() ,JGConstant.TaskStatus.SpecsInProgress.ToString(),
                        JGConstant.TaskStatus.Deleted.ToString(),JGConstant.TaskStatus.Finished.ToString(),
                        JGConstant.TaskStatus.Test.ToString(),JGConstant.TaskStatus.Live.ToString(),JGConstant.TaskStatus.Billed.ToString(),
                    };
                    
                }
                else if ((string)Session["DesigNew"] == "ITLead" ||   (string)Session["DesigNew"] == "Office Manager")
                {
                    arrStatus = new string[] { JGConstant.TaskStatus.Open.ToString(),JGConstant.TaskStatus.Requested.ToString(), 
                        JGConstant.TaskStatus.Assigned.ToString(), JGConstant.TaskStatus.InProgress.ToString(),
                        JGConstant.TaskStatus.Pending.ToString(),  JGConstant.TaskStatus.ReOpened.ToString(),
                        JGConstant.TaskStatus.SpecsInProgress.ToString(),
                        JGConstant.TaskStatus.Finished.ToString(),
                        JGConstant.TaskStatus.Test.ToString(),JGConstant.TaskStatus.Live.ToString()
                    };
                }
                else
                {
                    //----- If user level then show Test,Live,Finished statuses
                    arrStatus = new string[] { JGConstant.TaskStatus.Test.ToString(), JGConstant.TaskStatus.Live.ToString() };
                }

                drpStatusClosed.DataSource = FillStatusDropDowns(arrStatus);  //objListItemCollection;
                drpStatusClosed.DataTextField = "Text";
                drpStatusClosed.DataValueField = "Value";
                drpStatusClosed.DataBind();
                drpStatusClosed.Items.Insert(0, new ListItem("--All--", "0"));
                for (int i = 0; i < drpStatusClosed.Items.Count; i++)
                {

                    if (lblStatus.Value == drpStatusClosed.Items[i].Value)
                    {
                        drpStatusClosed.SelectedIndex = i;
                    }
                }

            }
        }
        protected void drpStatusInPro_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl_status = (DropDownList)sender;
            GridViewRow row = (GridViewRow)ddl_status.Parent.Parent;
            int idx = row.RowIndex;


            //Retrieve bookid and studentid from Gridview and status(dropdownlist)
            int vTaskId =Convert.ToInt32(((HiddenField)row.Cells[0].FindControl("lblTaskIdInPro")).Value);

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetSqlStringCommand("update  tblTask set [status]=" + ddl_status.SelectedValue + " where TaskId=" + vTaskId);
                    command.CommandType = CommandType.Text;
                    database.ExecuteNonQuery (command);
                }

                BindTaskInProgressGrid();
                BindTaskClosedGrid();
            }
            catch (Exception ex)
            {
                // return 0;
                //LogManager.Instance.WriteToFlatFile(ex);
            }
        }

        protected void drpStatusClosed_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl_status = (DropDownList)sender;
            GridViewRow row = (GridViewRow)ddl_status.Parent.Parent;
            int idx = row.RowIndex;

            //Retrieve bookid and studentid from Gridview and status(dropdownlist)
            int vTaskId = Convert.ToInt32(((HiddenField)row.Cells[0].FindControl("lblTaskIdClosed")).Value);

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetSqlStringCommand("update  tblTask set [status]=" + ddl_status.SelectedValue + " where TaskId=" + vTaskId);
                    command.CommandType = CommandType.Text;
                    database.ExecuteNonQuery (command);
                }

                BindTaskClosedGrid();
            }
            catch (Exception ex)
            {
                // return 0;
                //LogManager.Instance.WriteToFlatFile(ex);
            }
        }
        //[System.Web.Services.WebMethod]
        //public static string GetAllScripts(string strScriptId)
        //{
        //    DataSet ds = new DataSet();
        //    int? intScriptId = Convert.ToInt32(strScriptId);
        //    if (strScriptId == "0")
        //        intScriptId = null;
        //    ds = UserBLL.Instance.fetchAllScripts(intScriptId); ;
        //    if (ds != null)
        //    {
        //        if (ds.Tables[0].Rows.Count > 0)
        //        {
        //            return JsonConvert.SerializeObject(ds.Tables[0]);
        //        }
        //        else
        //        {
        //            return string.Empty;
        //        }
        //    }
        //    else
        //        return string.Empty;
        //}

        //[System.Web.Services.WebMethod]
        //public static string ManageScripts(string intMode, string intScriptId, string strScriptName, string strScriptDescription)
        //{
        //    DataSet ds = new DataSet();
        //    PhoneDashboard objPhoneDashboard = new PhoneDashboard();
        //    objPhoneDashboard.intMode = Convert.ToInt32(intMode);
        //    objPhoneDashboard.intScriptId = Convert.ToInt32(intScriptId);
        //    objPhoneDashboard.strScriptName = strScriptName;
        //    objPhoneDashboard.strScriptDescription = strScriptDescription;

        //    ds = UserBLL.Instance.manageScripts(objPhoneDashboard);
        //    if (ds != null)
        //    {
        //        if (ds.Tables[0].Rows.Count > 0)
        //        {
        //            return JsonConvert.SerializeObject(ds.Tables[0]);
        //        }
        //        else
        //        {
        //            return string.Empty;
        //        }
        //    }
        //    else
        //        return string.Empty;
        //}

        //protected void btnTestMail_Click(object sender, EventArgs e)
        //{
        //    if (txtTestEmail.Text != "")
        //        SendEmail(txtTestEmail.Text);
        //}

        //private void SendEmail(string emailId)
        //{
        //    try
        //    {
        //        string strHeader = "<div>Email Header</div>";
        //        string strBody = "<div>Email Body</div>";
        //        string strFooter = "<div>Email Footer</div>";
        //        string strsubject = "Subject - test mail";

        //        string userName = ConfigurationManager.AppSettings["VendorCategoryUserName"].ToString();
        //        string password = ConfigurationManager.AppSettings["VendorCategoryPassword"].ToString();

        //        StringBuilder Body = new StringBuilder();
        //        MailMessage Msg = new MailMessage();
        //        Msg.From = new MailAddress(userName, "JGrove Construction");
        //        Msg.To.Add(emailId);
        //        //Msg.Bcc.Add(new MailAddress("shabbir.kanchwala@straitapps.com", "Shabbir Kanchwala"));
        //        //Msg.CC.Add(new MailAddress("jgrove.georgegrove@gmail.com", "Justin Grove"));

        //        Msg.Subject = strsubject;// "JG Prospect Notification";
        //        Body.Append(strHeader);
        //        Body.Append(strBody);
        //        Body.Append(strFooter);

        //        Msg.Body = Convert.ToString(Body);
        //        Msg.IsBodyHtml = true;// your remote SMTP server IP

        //        SmtpClient sc = new SmtpClient(ConfigurationManager.AppSettings["smtpHost"].ToString(), Convert.ToInt32(ConfigurationManager.AppSettings["smtpPort"].ToString()));

        //        NetworkCredential ntw = new System.Net.NetworkCredential(userName, password);
        //        sc.UseDefaultCredentials = false;
        //        sc.Credentials = ntw;

        //        sc.DeliveryMethod = SmtpDeliveryMethod.Network;
        //        sc.EnableSsl = Convert.ToBoolean(ConfigurationManager.AppSettings["enableSSL"].ToString()); // runtime encrypt the SMTP communications using SSL
        //        try
        //        {
        //            sc.Send(Msg);
        //        }
        //        catch (Exception ex)
        //        {
        //            lblMessage.Text = "failure";
        //            logManager.writeToLog(ex, "Home", Request.ServerVariables["remote_addr"].ToString());
        //        }

        //        Msg = null;
        //        sc.Dispose();
        //        sc = null;
        //        lblMessage.Text = "Successfully Sent to " + emailId;
        //        txtTestEmail.Text = "";
        //    }
        //    catch (Exception ex)
        //    {
        //        lblMessage.Text = "failure";
        //        logManager.writeToLog(ex, "Home", Request.ServerVariables["remote_addr"].ToString());
        //    }
        //}

        //}
    }
}