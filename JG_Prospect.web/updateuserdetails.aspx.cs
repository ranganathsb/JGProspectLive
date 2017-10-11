using JG_Prospect.BLL;
using System;
using System.Data;
using System.IO;
using System.Web;

namespace JG_Prospect
{
    public partial class updateuserdetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string USERID = Request.Form["USERID"];

            if (!string.IsNullOrEmpty(USERID))
            {
                //Check if user exists
                DataSet ds = InstallUserBLL.Instance.getuserdetailsbyId(int.Parse(USERID));
                if (ds.Tables[0].Rows.Count > 0)
                {
                    string dbResumeFile = ds.Tables[0].Rows[0][1].ToString();
                    string dbPicture = ds.Tables[0].Rows[0][0].ToString();

                    HttpPostedFile resume = Request.Files["RESUMEFILE"];
                    if (resume != null && resume.ContentLength > 0)
                    {
                        //Save Resume File                        
                        if (dbResumeFile.Equals(resume.FileName))
                        {
                            var fileName = Path.GetFileName(resume.FileName);
                            var path = Path.Combine(Server.MapPath("~/Employee/Resume/"), fileName);
                            resume.SaveAs(path);
                        }
                    }

                    HttpPostedFile picture = Request.Files["PROFILEPICTURE"];
                    if (picture != null && picture.ContentLength > 0)
                    {
                        //Save Picture File
                        if (dbPicture.Equals(picture.FileName))
                        {
                            var fileName = Path.GetFileName(picture.FileName);
                            var path = Path.Combine(Server.MapPath("~/Employee/ProfilePictures/"), fileName);
                            picture.SaveAs(path);
                        }
                    }
                }
            }
        }
    }
}