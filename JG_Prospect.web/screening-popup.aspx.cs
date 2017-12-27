using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using JG_Prospect.BLL;
using System.Data;
using JG_Prospect.App_Code;
using JG_Prospect.Common.modal;
using System.IO;

namespace JG_Prospect
{
    public partial class screening_popup : System.Web.UI.Page
    {
        #region "-- varibles --"
        private Int32 UserId
        {
            get
            {
                if (ViewState["UserId"] == null)
                {
                    return 0;
                }
                else
                {
                    return (Int32)ViewState["UserId"];
                }

            }
            set
            {
                ViewState["UserId"] = value;
            }
        }
        #endregion

        #region "--page methods--"


        protected void Page_Load(object sender, EventArgs e)
        {
            CommonFunction.AuthenticateUser();
            if (!Page.IsPostBack)
            {
                LoadDropDownData();
                LoadUserData();
            }
        }



        #endregion

        #region "-- Control Events --"

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                UpdateUserData();
            }
        }


        #endregion

        #region "--Private Methods-"

        private void LoadDropDownData()
        {
            DataSet dsDesignation = new DataSet();
            dsDesignation = DesignationBLL.Instance.GetAllDesignationsForHumanResource();
            if (dsDesignation != null && dsDesignation.Tables.Count > 0)
            {
                ddlPositionAppliedFor.DataSource = dsDesignation.Tables[0];
                ddlPositionAppliedFor.DataTextField = "DesignationName";
                ddlPositionAppliedFor.DataValueField = "ID";
                ddlPositionAppliedFor.DataBind();
            }

            ddlPositionAppliedFor.Items.Insert(0, new ListItem("Select Position", "0"));

            DataSet dsSource;
            //dsTrade = InstallUserBLL.Instance.getTrades();
            dsSource = InstallUserBLL.Instance.GetSource();

            if (dsSource != null && dsSource.Tables[0].Rows.Count > 0)
            {
                ddlSource.DataSource = dsSource.Tables[0];
                ddlSource.DataTextField = "Source";
                ddlSource.DataValueField = "Id";
                //ddlSource.DataValueField = "Source";
                ddlSource.DataBind();
                ddlSource.Items.Insert(0, new ListItem("Select Source", "0"));
                ddlSource.SelectedIndex = 0;
            }

            DataSet dsCountry;

            dsCountry = CountryBLL.Instance.GetAllCountry();

            if (dsCountry != null && dsCountry.Tables[0].Rows.Count > 0)
            {
                ddlCountry.DataSource = dsCountry.Tables[0];
                ddlCountry.DataTextField = "CountryName";
                ddlCountry.DataValueField = "CountryCode";
                ddlCountry.DataBind();

                //-- SET Default Value
                ddlCountry.SelectedValue = "US";

            }
        }

        private void LoadUserData()
        {
            DataSet dsUserDetails = InstallUserBLL.Instance.getInstallUserDetailsById(Convert.ToInt32(JGSession.LoginUserID));

            if (dsUserDetails != null && dsUserDetails.Tables.Count > 0 && dsUserDetails.Tables[0].Rows.Count > 0)
            {
                DataRow drDetails = dsUserDetails.Tables[0].Rows[0];

                this.UserId = Convert.ToInt32(drDetails["Id"].ToString());

                ListItem PositionAppliedFor = ddlPositionAppliedFor.Items.FindByValue(drDetails["PositionAppliedFor"].ToString());

                if (PositionAppliedFor != null)
                {
                    ddlPositionAppliedFor.SelectedIndex = ddlPositionAppliedFor.Items.IndexOf(PositionAppliedFor);
                }

                ListItem Source = ddlSource.Items.FindByValue(drDetails["Source"].ToString());

                if (Source != null)
                {
                    ddlSource.SelectedIndex = ddlSource.Items.IndexOf(Source);
                }


                txtfirstname.Text = drDetails["FristName"].ToString();
                txtlastname.Text = drDetails["LastName"].ToString();
                txtMiddleInitial.Text = drDetails["NameMiddleInitial"].ToString();

                ListItem Country = ddlCountry.Items.FindByValue(drDetails["CountryCode"].ToString());

                if (Country != null)
                {
                    ddlCountry.SelectedIndex = ddlCountry.Items.IndexOf(Country);
                }

                txtZip.Text = drDetails["Zip"].ToString();
                txtCity.Text = drDetails["City"].ToString();
                txtState.Text = drDetails["State"].ToString();
                txtAddress.Text = drDetails["Address"].ToString();
                txtReasontoLeave.Text = drDetails["LeavingReason"].ToString();
                txtPhone.Text = drDetails["Phone"].ToString();
                txtEmail.Text = drDetails["Email"].ToString();

                if (!String.IsNullOrEmpty(drDetails["IsEmailContactPreference"].ToString()))
                {
                    ContactPreferenceChkEmail.Checked = Convert.ToBoolean(drDetails["IsEmailContactPreference"].ToString());
                }
                if (!String.IsNullOrEmpty(drDetails["IsCallContactPreference"].ToString()))
                {
                    ContactPreferenceChkCall.Checked = Convert.ToBoolean(drDetails["IsCallContactPreference"].ToString());
                }
                if (!String.IsNullOrEmpty(drDetails["IsTextContactPreference"].ToString()))
                {
                    ContactPreferenceChkText.Checked = Convert.ToBoolean(drDetails["IsTextContactPreference"].ToString());
                }
                if (!String.IsNullOrEmpty(drDetails["IsMailContactPreference"].ToString()))
                {
                    ContactPreferenceChkMail.Checked = Convert.ToBoolean(drDetails["IsMailContactPreference"].ToString());
                }

                txtStartDate.Text = drDetails["StartDate"].ToString();


                ListItem EmploymentType = ddlEmpType.Items.FindByValue(drDetails["EmpType"].ToString());

                if (EmploymentType != null)
                {
                    ddlEmpType.SelectedIndex = ddlEmpType.Items.IndexOf(EmploymentType);
                }

                txtSalaryRequirments.Text = drDetails["SalaryReq"].ToString();

                ListItem Employed = rblEmployed.Items.FindByValue(drDetails["CruntEmployement"].ToString());

                if (Employed != null)
                {
                    rblEmployed.SelectedIndex = rblEmployed.Items.IndexOf(Employed);
                }

                ListItem DrugTest = rblDrugTest.Items.FindByValue(drDetails["DrugTest"].ToString());

                if (DrugTest != null)
                {
                    rblDrugTest.SelectedIndex = rblDrugTest.Items.IndexOf(DrugTest);
                }

                ListItem Felony = rblFelony.Items.FindByValue(drDetails["FELONY"].ToString());

                if (Felony != null)
                {
                    rblFelony.SelectedIndex = rblFelony.Items.IndexOf(Felony);
                }

                ListItem WorkedForJMG = rblWorkedForJMG.Items.FindByValue(drDetails["PrevApply"].ToString());

                if (WorkedForJMG != null)
                {
                    rblWorkedForJMG.SelectedIndex = rblWorkedForJMG.Items.IndexOf(WorkedForJMG);
                }

                txtMessageToRecruiter.Text = drDetails["Notes"].ToString();

                if (String.IsNullOrEmpty(drDetails["Picture"].ToString()))
                {
                    imgProfilePic.ImageUrl = "~/Employee/ProfilePictures/default.jpg";

                }
                else
                {
                    hdnprofilePic.Value = drDetails["Picture"].ToString();
                    imgProfilePic.ImageUrl = String.Concat("~/Employee/ProfilePictures/", drDetails["Picture"].ToString());
                }

                if (!String.IsNullOrEmpty(drDetails["ResumePath"].ToString()))
                {
                    hdnResume.Value = drDetails["ResumePath"].ToString();                    
                }

            }
        }

        private void UpdateUserData()
        {
            user objInstallUser = new user();

            objInstallUser.id = Convert.ToInt32(JGSession.LoginUserID);
            objInstallUser.fristname = txtfirstname.Text.Trim();
            objInstallUser.NameMiddleInitial = txtfirstname.Text.Trim();
            objInstallUser.lastname = txtlastname.Text.Trim();
            objInstallUser.email = txtEmail.Text.Trim();
            objInstallUser.phone = hdnPhone.Value;
            objInstallUser.zip = txtZip.Text.Trim();
            objInstallUser.PositionAppliedFor = ddlPositionAppliedFor.SelectedItem.Value;
            objInstallUser.Source = ddlSource.SelectedItem.Text;
            objInstallUser.SourceId = Convert.ToInt32(ddlSource.SelectedItem.Value);
            objInstallUser.CountryCode = ddlCountry.SelectedItem.Value;
            objInstallUser.city = txtCity.Text.Trim();
            objInstallUser.state = txtState.Text.Trim();
            objInstallUser.address = txtAddress.Text.Trim();
            objInstallUser.Reason = txtReasontoLeave.Text.Trim();
            objInstallUser.city = txtCity.Text.Trim();
            objInstallUser.IsEmailContactPreference = ContactPreferenceChkEmail.Checked;
            objInstallUser.IsCallContactPreference = ContactPreferenceChkCall.Checked;
            objInstallUser.IsTextContactPreference = ContactPreferenceChkText.Checked;
            objInstallUser.IsMailContactPreference = ContactPreferenceChkMail.Checked;
            objInstallUser.StartDate = txtStartDate.Text.Trim();
            objInstallUser.EmpType = ddlEmpType.SelectedItem.Value;            
            objInstallUser.SalaryReq = txtSalaryRequirments.Text.Trim();
            objInstallUser.CruntEmployement = rblEmployed.SelectedItem.Value == "0" ?false:true;
            objInstallUser.DrugTest = rblDrugTest.SelectedItem.Value == "0" ? false : true;
            objInstallUser.FELONY = rblFelony.SelectedItem.Value == "0" ? false : true;
            objInstallUser.PrevApply = rblWorkedForJMG.SelectedItem.Value == "0" ? false : true;
            objInstallUser.Notes = txtMessageToRecruiter.Text.Trim();
            objInstallUser.ResumePath = UploadResume();
            objInstallUser.picture = UploadPicture();

            InstallUserBLL.Instance.UpdateUserProfile(objInstallUser);
                        
        }

        private string UploadPicture()
        {
            String fileName = CommonFunction.UploadFile(fupProfilePic, "~/Employee/ProfilePictures");

            if (String.IsNullOrEmpty(fileName))
            {
                fileName = hdnprofilePic.Value;
            }
           
            return fileName;
        }

        private string UploadResume()
        {
            String fileName = CommonFunction.UploadFile(fupResume, "~/Employee/Resume");

            if (string.IsNullOrEmpty(fileName))
            {
                fileName = hdnResume.Value;
            }

            return fileName;
        }


        #endregion

    }
}