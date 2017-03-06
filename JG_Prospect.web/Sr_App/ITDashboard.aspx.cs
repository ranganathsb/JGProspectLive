﻿using JG_Prospect.BLL;
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
    public partial class ITDashboard : System.Web.UI.Page
    {
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

                //----------------- Start DP ------------
                FillDesignation();
                lblFrozenCounter0.Visible = false;
                lblNewCounter0.Visible = false;

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
                LoadFilterUsersByDesgination("", drpUsersInProgress);
                LoadFilterUsersByDesgination("", drpUsersClosed);
                LoadFilterUsersByDesgination("", drpUserFrozen);
                LoadFilterUsersByDesgination("", drpUserNew);
                BindTaskInProgressGrid();
                BindTaskClosedGrid();
                BindFrozenTasks();
                BindNewTasks();

                // ----- get new and frozen task counts for current payperiod
                DateTime firstOfThisMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                DateTime firstOfNextMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).AddMonths(1);
                DateTime lastOfThisMonth = firstOfNextMonth.AddDays(-1);
                //DateTime MiddleDate = Convert.ToDateTime("15-" + DateTime.Now.Month + "-" + DateTime.Now.Year);
                DateTime MiddleDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).AddDays(14);
                string strnew = "";
                try
                {
                    SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                    {
                        DataSet result = new DataSet();
                        if (DateTime.Now.Date >= firstOfThisMonth && DateTime.Now.Date <= MiddleDate)
                        {
                            strnew = "select count(TaskId) as cntnew from tbltask where [Status]=1 and (CreatedOn >='" + firstOfThisMonth.ToString("dd-MMM-yyy") + "' and CreatedOn <= '" + MiddleDate.ToString("dd-MMM-yyy") + "') ";
                        }
                        else if (DateTime.Now.Date >= MiddleDate && DateTime.Now.Date <= lastOfThisMonth)
                        {
                            strnew = "select count(TaskId) as cntnew from tbltask where [Status]=1 and (CreatedOn >='" + MiddleDate.ToString("dd-MMM-yyy") + "' and CreatedOn <= '" + lastOfThisMonth.ToString("dd-MMM-yyy") + "') ";
                        }
                        DbCommand command = database.GetSqlStringCommand(strnew);
                        command.CommandType = CommandType.Text;
                        result = database.ExecuteDataSet(command);
                        lblNewCounter.Visible = false;
                        lblNewCounter0.Visible = true;
                        lblNewCounter0.Text = "0";
                        if (result.Tables[0].Rows.Count > 0)
                        {
                            if (result.Tables[0].Rows[0]["cntnew"].ToString() != "0")
                            {
                                lblNewCounter.Visible = true;
                                lblNewCounter0.Visible = false;
                                lblNewCounter.Text = result.Tables[0].Rows[0]["cntnew"].ToString();
                            }
                        }
                        result.Dispose();
                    }
                }
                catch (Exception ex)
                {
                }

                string strfrozen = "";
                try
                {
                    SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                    {
                        DataSet result = new DataSet();

                        if (DateTime.Now.Date >= firstOfThisMonth && DateTime.Now.Date <= MiddleDate)
                        {
                            strfrozen = "select count(a.TaskId) as cntnew from tbltask as a,tbltaskapprovals as b where a.TaskId=b.TaskId and ";
                            strfrozen = strfrozen + "   (DateCreated >='" + firstOfThisMonth.ToString("dd-MMM-yyy") + "' and DateCreated <= '" + MiddleDate.ToString("dd-MMM-yyy") + "') ";
                        }
                        else if (DateTime.Now.Date >= MiddleDate && DateTime.Now.Date <= lastOfThisMonth)
                        {
                            strfrozen = "select count(a.TaskId) as cntnew from tbltask as a,tbltaskapprovals as b where a.TaskId=b.TaskId and ";
                            strfrozen = strfrozen + "   (DateCreated >='" + MiddleDate.ToString("dd-MMM-yyy") + "' and DateCreated <= '" + lastOfThisMonth.ToString("dd-MMM-yyy") + "') ";
                        }
                        DbCommand command = database.GetSqlStringCommand(strfrozen);
                        command.CommandType = CommandType.Text;
                        result = database.ExecuteDataSet(command);

                        lblFrozenCounter.Visible = false;
                        lblFrozenCounter0.Visible = true;
                        lblFrozenCounter0.Text = "0";
                        if (result.Tables[0].Rows.Count > 0)
                        {
                            if (result.Tables[0].Rows[0]["cntnew"].ToString() != "0")
                            {
                                lblFrozenCounter.Visible = true;
                                lblFrozenCounter0.Visible = false;
                                lblFrozenCounter.Text = result.Tables[0].Rows[0]["cntnew"].ToString();
                            }
                        }
                        result.Dispose();
                    }
                }
                catch (Exception ex)
                {
                }

                //----------------- End DP ------------
            }
            lblMessage.Text = "";
        }



        protected void grdTaskPending_PreRender(object sender, EventArgs e)
        {
            GridView gv = (GridView)sender;

            if (gv.Rows.Count > 0)
            {
                gv.UseAccessibleHeader = true;
                gv.HeaderRow.TableSection = TableRowSection.TableHeader;
                gv.FooterRow.TableSection = TableRowSection.TableFooter;
            }

            if (gv.TopPagerRow != null)
            {
                gv.TopPagerRow.TableSection = TableRowSection.TableHeader;
            }
            if (gv.BottomPagerRow != null)
            {
                gv.BottomPagerRow.TableSection = TableRowSection.TableFooter;
            }
        }
        protected void grdTaskClosed_PreRender(object sender, EventArgs e)
        {
            GridView gv = (GridView)sender;

            if (gv.Rows.Count > 0)
            {
                gv.UseAccessibleHeader = true;
                gv.HeaderRow.TableSection = TableRowSection.TableHeader;
                gv.FooterRow.TableSection = TableRowSection.TableFooter;
            }

            if (gv.TopPagerRow != null)
            {
                gv.TopPagerRow.TableSection = TableRowSection.TableHeader;
            }
            if (gv.BottomPagerRow != null)
            {
                gv.BottomPagerRow.TableSection = TableRowSection.TableFooter;
            }
        }
        protected void grdFrozenTask_PreRender(object sender, EventArgs e)
        {
            GridView gv = (GridView)sender;

            if (gv.Rows.Count > 0)
            {
                gv.UseAccessibleHeader = true;
                gv.HeaderRow.TableSection = TableRowSection.TableHeader;
                gv.FooterRow.TableSection = TableRowSection.TableFooter;
            }

            if (gv.TopPagerRow != null)
            {
                gv.TopPagerRow.TableSection = TableRowSection.TableHeader;
            }
            if (gv.BottomPagerRow != null)
            {
                gv.BottomPagerRow.TableSection = TableRowSection.TableFooter;
            }
        }

        protected void grdNewTask_PreRender(object sender, EventArgs e)
        {
            GridView gv = (GridView)sender;

            if (gv.Rows.Count > 0)
            {
                gv.UseAccessibleHeader = true;
                gv.HeaderRow.TableSection = TableRowSection.TableHeader;
                gv.FooterRow.TableSection = TableRowSection.TableFooter;
            }

            if (gv.TopPagerRow != null)
            {
                gv.TopPagerRow.TableSection = TableRowSection.TableHeader;
            }
            if (gv.BottomPagerRow != null)
            {
                gv.BottomPagerRow.TableSection = TableRowSection.TableFooter;
            }
        }

        protected void lnkNewCounter_Click(object sender, EventArgs e)
        {
            mpNewFrozenTask.Show();
        }

        protected void lnkFrozenCounter_Click(object sender, EventArgs e)
        {
            mpNewFrozenTask.Show();
        }

        protected void btnCalClose_Click(object sender, EventArgs e)
        {
            mpNewFrozenTask.Hide();
            //ScriptManager.RegisterStartupScript(this.Page, GetType(), "al1", "$('#lnkNNewCounter').click(function () {callpopupscript();   });", true);

        }
        protected void drpDesigInProgress_SelectedIndexChanged(object sender, EventArgs e)
        {
            string designation = drpDesigInProgress.SelectedValue;
            LoadFilterUsersByDesgination(designation, drpUsersInProgress);
            //SearchTasks(null);
            BindTaskInProgressGrid();
        }
        protected void drpDesigClosed_SelectedIndexChanged(object sender, EventArgs e)
        {
            string designation = drpDesigClosed.SelectedValue;
            LoadFilterUsersByDesgination(designation, drpUsersClosed);
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
        protected void drpUserFrozen_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindFrozenTasks();
        }
        //protected void drpDesigFrozen_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    string designation = drpDesigInProgress.SelectedValue;
        //    LoadFilterUsersByDesgination(designation, drpUserFrozen);
        //    BindFrozenTasks();
        //}
        //protected void drpDesigNew_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    string designation = drpDesigInProgress.SelectedValue;
        //    LoadFilterUsersByDesgination(designation,drpUserNew );
        //    BindNewTasks();
        //}
        protected void drpUserNew_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindNewTasks();
        }

        private void LoadFilterUsersByDesgination(string designation, DropDownList drp)
        {
            DataSet dsUsers;
            // DropDownCheckBoxes ddlAssign = (FindControl("ddcbAssigned") as DropDownCheckBoxes);
            // DropDownList ddlDesignation = (DropDownList)sender;
            dsUsers = TaskGeneratorBLL.Instance.GetInstallUsers(2, designation);
            //drpUsersInProgress.Items.Clear();

            drp.DataSource = dsUsers;
            drp.DataTextField = "FristName";
            drp.DataValueField = "Id";
            drp.DataBind();
            drp.Items.Insert(0, new ListItem("--All--", "0"));
            drp.SelectedIndex = 0;


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


            drpDesigClosed.DataValueField = "Id";
            drpDesigClosed.DataTextField = "DesignationName";
            drpDesigClosed.DataSource = dsDesignation.Tables[0];
            drpDesigClosed.DataBind();
            drpDesigClosed.Items.Insert(0, new ListItem("--All--", "0"));
            drpDesigClosed.SelectedIndex = 0;

            drpDesigFrozen.DataValueField = "Id";
            drpDesigFrozen.DataTextField = "DesignationName";
            drpDesigFrozen.DataSource = dsDesignation.Tables[0];
            drpDesigFrozen.DataBind();
            drpDesigFrozen.Items.Insert(0, new ListItem("--All--", "0"));
            drpDesigFrozen.SelectedIndex = 0;

            drpDesigNew.DataValueField = "Id";
            drpDesigNew.DataTextField = "DesignationName";
            drpDesigNew.DataSource = dsDesignation.Tables[0];
            drpDesigNew.DataBind();
            drpDesigNew.Items.Insert(0, new ListItem("--All--", "0"));
            drpDesigNew.SelectedIndex = 0;
        }

        private void BindNewTasks()
        {
            DateTime firstOfThisMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            DateTime firstOfNextMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).AddMonths(1);
            DateTime lastOfThisMonth = firstOfNextMonth.AddDays(-1);
            //DateTime MiddleDate = Convert.ToDateTime("15-" + DateTime.Now.Month + "-" + DateTime.Now.Year);
            DateTime MiddleDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).AddDays(14);
            string strnew = "";
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DataSet result = new DataSet();

                    if (DateTime.Now.Date >= firstOfThisMonth && DateTime.Now.Date <= MiddleDate)
                    {
                        strnew = "select * from tbltask where [Status]=1 and (CreatedOn >='" + firstOfThisMonth.ToString("dd-MMM-yyy") + "' and CreatedOn <= '" + MiddleDate.ToString("dd-MMM-yyy") + "') ";
                    }
                    else if (DateTime.Now.Date >= MiddleDate && DateTime.Now.Date <= lastOfThisMonth)
                    {
                        strnew = "select * from tbltask where [Status]=1 and (CreatedOn >='" + MiddleDate.ToString("dd-MMM-yyy") + "' and CreatedOn <= '" + lastOfThisMonth.ToString("dd-MMM-yyy") + "') ";
                    }
                    DbCommand command = database.GetSqlStringCommand(strnew);
                    command.CommandType = CommandType.Text;
                    result = database.ExecuteDataSet(command);
                    // if loggedin user is not manager then show tasks assigned to loggedin user only 

                    if (result.Tables[0].Rows.Count > 0)
                    {
                        grdNewTask.DataSource = result;
                        grdNewTask.DataBind();
                    }
                    else
                    {
                        //lblMessage.Text = "No In-Progress Tasks Found !!!";
                        grdNewTask.DataSource = null;
                        grdNewTask.DataBind();
                    }

                    result.Dispose();
                }
            }
            catch (Exception ex)
            {
            }


        }
        private void BindFrozenTasks()
        {
            DateTime firstOfThisMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            DateTime firstOfNextMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).AddMonths(1);
            DateTime lastOfThisMonth = firstOfNextMonth.AddDays(-1);
            //DateTime MiddleDate = Convert.ToDateTime("15-" + DateTime.Now.Month + "-" + DateTime.Now.Year);
            DateTime MiddleDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).AddDays(14);
            string strfrozen = "";
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DataSet result = new DataSet();

                    if (DateTime.Now.Date >= firstOfThisMonth && DateTime.Now.Date <= MiddleDate)
                    {
                        strfrozen = "select a.* from tbltask as a,tbltaskapprovals as b where a.TaskId=b.TaskId and ";
                        strfrozen = strfrozen + "   (DateCreated >='" + firstOfThisMonth.ToString("dd-MMM-yyy") + "' and DateCreated <= '" + MiddleDate.ToString("dd-MMM-yyy") + "') ";
                    }
                    else if (DateTime.Now.Date >= MiddleDate && DateTime.Now.Date <= lastOfThisMonth)
                    {
                        strfrozen = "select a.* from tbltask as a,tbltaskapprovals as b where a.TaskId=b.TaskId and ";
                        strfrozen = strfrozen + "   (DateCreated >='" + MiddleDate.ToString("dd-MMM-yyy") + "' and DateCreated <= '" + lastOfThisMonth.ToString("dd-MMM-yyy") + "') ";
                    }
                    DbCommand command = database.GetSqlStringCommand(strfrozen);
                    command.CommandType = CommandType.Text;
                    result = database.ExecuteDataSet(command);
                    // if loggedin user is not manager then show tasks assigned to loggedin user only 

                    if (result.Tables[0].Rows.Count > 0)
                    {
                        grdFrozenTask.DataSource = result;
                        grdFrozenTask.DataBind();
                    }
                    else
                    {
                        //lblMessage.Text = "No In-Progress Tasks Found !!!";
                        grdFrozenTask.DataSource = null;
                        grdFrozenTask.DataBind();
                    }

                    result.Dispose();
                }
            }
            catch (Exception ex)
            {
            }


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
            if (Convert.ToInt32(drpDesigInProgress.SelectedValue) > 0)
            {
                desigID = Convert.ToInt32(drpDesigInProgress.SelectedValue);
            }

            // if loggedin user is not manager then show tasks assigned to loggedin user only 
            ds = TaskGeneratorBLL.Instance.GetInProgressTasks(userId, desigID);
            if ( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
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
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
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
        protected void OnPaginggrdFrozenTask(object sender, GridViewPageEventArgs e)
        {
            BindFrozenTasks();
            grdFrozenTask.PageIndex = e.NewPageIndex;
            grdFrozenTask.DataBind();
        }

        protected void OnPaginggrdNewTask(object sender, GridViewPageEventArgs e)
        {
            BindNewTasks();
            grdNewTask.PageIndex = e.NewPageIndex;
            grdNewTask.DataBind();
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

                if (lblStatus.Value == "4")
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
                else
                {
                    ////lblStatus.Value = "Open";
                    System.Drawing.Color clr = System.Drawing.ColorTranslator.FromHtml("#f6f1f3");
                    e.Row.BackColor = clr;
                    //e.Row.BorderColor = System.Drawing.Color.Black;
                    //foreach (TableCell cell in e.Row.Cells)
                    //{
                    //    cell.BorderColor = System.Drawing.Color.Black;
                    //}
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
                            for (int i = 0; i < result.Tables[0].Rows.Count; i++)
                            {
                                if (result.Tables[0].Rows[i]["EstimatedHours"] != null && result.Tables[0].Rows[i]["EstimatedHours"] != "")
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
                    drpStatusInPro.DataSource = CommonFunction.GetTaskStatusList();
                    //string[] arrStatus = new string[] { JGConstant.TaskStatus.Open.ToString(),JGConstant.TaskStatus.Requested.ToString(), 
                    //    JGConstant.TaskStatus.Assigned.ToString(), JGConstant.TaskStatus.InProgress.ToString(),
                    //    JGConstant.TaskStatus.Pending.ToString(),  JGConstant.TaskStatus.ReOpened.ToString(),
                    //    JGConstant.TaskStatus.Closed.ToString() ,JGConstant.TaskStatus.SpecsInProgress.ToString(),
                    //    JGConstant.TaskStatus.Deleted.ToString(),JGConstant.TaskStatus.Finished.ToString(),
                    //    JGConstant.TaskStatus.Test.ToString(),JGConstant.TaskStatus.Live.ToString(),JGConstant.TaskStatus.Billed.ToString(),
                    //};
                    //drpStatusInPro.DataSource = FillStatusDropDowns(arrStatus); 
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
                else
                {
                    //----- If user level then show Test,Live,Finished statuses
                    string[] arrStatus = new string[] { JGConstant.TaskStatus.Requested.ToString(), JGConstant.TaskStatus.Assigned.ToString(), JGConstant.TaskStatus.Open.ToString(), JGConstant.TaskStatus.InProgress.ToString(), JGConstant.TaskStatus.Test.ToString(), JGConstant.TaskStatus.Finished.ToString() };
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
                    System.Drawing.Color clr = System.Drawing.ColorTranslator.FromHtml("#f6f1f3");
                    e.Row.BackColor = clr;
                }

                int vTaskId = Convert.ToInt32(lblTaskIdClosed.Value);

                // fill status dropdowns
                //----- If manager level then show all statuses

                string[] arrStatus;
                if ((string)Session["DesigNew"] == "Admin")
                {
                    drpStatusClosed.DataSource = CommonFunction.GetTaskStatusList();
                }
                else if ((string)Session["DesigNew"] == "ITLead" || (string)Session["DesigNew"] == "Office Manager")
                {
                    arrStatus = new string[] { JGConstant.TaskStatus.Open.ToString(),JGConstant.TaskStatus.Requested.ToString(), 
                        JGConstant.TaskStatus.Assigned.ToString(), JGConstant.TaskStatus.InProgress.ToString(),
                        JGConstant.TaskStatus.Pending.ToString(),  JGConstant.TaskStatus.ReOpened.ToString(),
                        JGConstant.TaskStatus.SpecsInProgress.ToString(),
                        JGConstant.TaskStatus.Finished.ToString(),
                        JGConstant.TaskStatus.Test.ToString(),JGConstant.TaskStatus.Live.ToString()
                    };
                    drpStatusClosed.DataSource = FillStatusDropDowns(arrStatus);
                }
                else
                {
                    //----- If user level then show Test,Live,Finished statuses
                    arrStatus = new string[] { JGConstant.TaskStatus.Test.ToString(), JGConstant.TaskStatus.Live.ToString() };
                    drpStatusClosed.DataSource = FillStatusDropDowns(arrStatus);
                }


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

        protected void grdFrozenTask_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Label lblStatus = e.Row.FindControl("lblStatus") as Label;
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

                if (lblStatus.Text == "4")
                {
                    lblStatus.Text = "In Progress";

                }
                else if (lblStatus.Text == "3")
                {
                    lblStatus.Text = "Assigned";
                }
                else if (lblStatus.Text == "2")
                {
                    lblStatus.Text = "Requested";
                }
                else
                {
                    lblStatus.Text = "Open";
                }
            }
        }

        protected void grdNewTask_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Label lblStatus = e.Row.FindControl("lblStatus") as Label;
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

                if (lblStatus.Text == "4")
                {
                    lblStatus.Text = "In Progress";

                }
                else if (lblStatus.Text == "3")
                {
                    lblStatus.Text = "Assigned";
                }
                else if (lblStatus.Text == "2")
                {
                    lblStatus.Text = "Requested";
                }
                else
                {
                    lblStatus.Text = "Open";
                }
            }
        }
        protected void drpStatusInPro_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl_status = (DropDownList)sender;
            GridViewRow row = (GridViewRow)ddl_status.Parent.Parent;
            int idx = row.RowIndex;


            //Retrieve bookid and studentid from Gridview and status(dropdownlist)
            int vTaskId = Convert.ToInt32(((HiddenField)row.Cells[0].FindControl("lblTaskIdInPro")).Value);

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetSqlStringCommand("update  tblTask set [status]=" + ddl_status.SelectedValue + " where TaskId=" + vTaskId);
                    command.CommandType = CommandType.Text;
                    database.ExecuteNonQuery(command);
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
                    database.ExecuteNonQuery(command);
                }

                BindTaskClosedGrid();
            }
            catch (Exception ex)
            {
                // return 0;
                //LogManager.Instance.WriteToFlatFile(ex);
            }
        }
        private System.Web.UI.WebControls.ListItemCollection FillStatusDropDowns(string[] lst)
        {
            ListItemCollection objListItemCollection = new ListItemCollection();
            int enumlen = Enum.GetNames(typeof(JGConstant.TaskStatus)).Length;

            foreach (var item in Enum.GetNames(typeof(JGConstant.TaskStatus)))
            {
                for (int j = 0; j < lst.Length; j++)
                {
                    if (lst[j] == item)
                    {
                        int enumval = (int)Enum.Parse(typeof(JGConstant.TaskStatus), item);
                        objListItemCollection.Add(new ListItem(item, enumval.ToString()));

                        break;
                    }
                }
            }
            return objListItemCollection;
        }
    }
     
}