﻿using JG_Prospect.Common;
using JG_Prospect.Common.modal;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Hosting;

namespace JG_Prospect.BLL
{
    public static class EmailSchedularManager
    {
        public static void SendScheduledEmails()
        {
            List<EMailSchedularModel> Templates = HTMLTemplateBLL.Instance.GetCurrentScheduledHtmlTemplates();

            if (Templates != null && Templates.Count > 0)
            {
                DataSet Designation = DesignationBLL.Instance.GetAllDesignationsForHumanResource();
                foreach (var template in Templates)
                {
                    if (Designation != null && Designation.Tables.Count > 0 && Designation.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow RowItem in Designation.Tables[0].Rows)
                        {
                            Int32 DesignationId = Convert.ToInt32(RowItem["ID"]);
                            BulkEmail((HTMLTemplates)Enum.Parse(typeof(HTMLTemplates), template.TemplateId.ToString()), DesignationId);
                        }
                    }
                }
            }
        }

        internal static void BulkEmail(HTMLTemplates objHTMLTemplateType, Int32 DesignationId)
        {
            DesignationHTMLTemplate objHTMLTemplate = HTMLTemplateBLL.Instance.GetDesignationHTMLTemplate(objHTMLTemplateType, DesignationId.ToString());

            // Get all install users with statuses, Applicant, Refferal Applcant, InterviewDate
            DataSet dsUser = InstallUserBLL.Instance.GetInstallUsersForBulkEmail(DesignationId);

            if (dsUser != null && dsUser.Tables.Count > 0)
            {
                foreach (DataRow installUser in dsUser.Tables[0].Rows)
                {
                    // Send email to each user.
                    string emailId = String.Empty;
                    string strBody = String.Empty;

                    if (JGApplicationInfo.GetApplicationEnvironment() == "1")
                    {
                        emailId = "error@kerconsultancy.com";
                        strBody = "<h1>Email is intended for Email Address: " + installUser["Email"].ToString() + "</h1><br/><br/>";
                    }
                    else
                    {
                        emailId = installUser["Email"].ToString();
                    }

                    string FName = installUser["FristName"].ToString();
                    string LName = installUser["LastName"].ToString();
                    string Designation = installUser["Designation"].ToString();
                    string fullname = FName + " " + LName;

                    string userName = ConfigurationManager.AppSettings["VendorCategoryUserName"].ToString();
                    string password = ConfigurationManager.AppSettings["VendorCategoryPassword"].ToString();


                    string strHeader = objHTMLTemplate.Header;
                    strBody = String.Concat(strBody, objHTMLTemplate.Body);
                    string strFooter = objHTMLTemplate.Footer;
                    string strsubject = objHTMLTemplate.Subject;

                    strBody = strBody.Replace("#name#", fullname).Replace("#Email#", installUser["Email"].ToString()).Replace("#Phone number#", installUser["Phone"].ToString());

                    strFooter = strFooter.Replace("#Designation#", Designation);

                    strBody = strHeader + strBody + strFooter;

                    List<Attachment> lstAttachments = objHTMLTemplate.Attachments;

                    try
                    {
                        EmailManager.SendEmail(Designation, emailId, strsubject, strBody, lstAttachments);

                        UpdateEmailStatistics(emailId);
                    }
                    catch (Exception ex)
                    {

                    }
                }
            }

        }

        private static void UpdateEmailStatistics(string emailId)
        {
            string logDirectoryPath = AppDomain.CurrentDomain.BaseDirectory + "\\EmailStatistics";

            if (!Directory.Exists(logDirectoryPath))
            {
                Directory.CreateDirectory(logDirectoryPath);
            }

            string path = String.Concat(logDirectoryPath, "\\statistics.txt");

            if (!File.Exists(path))
            {
                using (TextWriter tw = File.CreateText(path))
                {
                    tw.WriteLine(emailId + "  - " + DateTime.Now);
                    tw.Close();
                }
            }
            else if (File.Exists(path))
            {
                using (var tw = new StreamWriter(path, true))
                {
                    tw.WriteLine(emailId + "  - " + DateTime.Now);
                    tw.Close();
                }
            }
        }

    }


}
