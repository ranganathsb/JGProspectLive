﻿using JG_Prospect.App_Code;
using JG_Prospect.BLL;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JG_Prospect.Sr_App
{
    public partial class email_template_maintainance : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CommonFunction.AuthenticateUser();

            if (!IsPostBack)
            {
                FillHtmlTemplates();
            }
        }

        private void FillHtmlTemplates()
        {
            DataSet dsHtmlTemplates = HTMLTemplateBLL.Instance.GetHTMLTemplateMasters();
            if (dsHtmlTemplates != null && dsHtmlTemplates.Tables.Count > 0)
            {
                DataView dvHtmlTemplates = dsHtmlTemplates.Tables[0].DefaultView;

                dvHtmlTemplates.RowFilter = string.Format("[Type] = {0}", Convert.ToByte(Common.HTMLTemplateTypes.AutoEmailTemplate));
                grdTemplates_AutoEmail.DataSource = dvHtmlTemplates.ToTable();
                grdTemplates_AutoEmail.DataBind();


                dvHtmlTemplates.RowFilter = string.Format("[Type] = {0}", Convert.ToByte(Common.HTMLTemplateTypes.Template));
                repTemplates_Template.DataSource = dvHtmlTemplates.ToTable();
                repTemplates_Template.DataBind();
            }
        }

        [WebMethod]
        public static string GetCompanyAddress()
        {
            DataSet ds = new DataSet();
            string result = string.Empty;
            ds = AdminBLL.Instance.GetCompanyAddress();
            result = JsonConvert.SerializeObject(ds);
            return result;
        }
        [WebMethod]
        public static string UpdateCompanyAddress(string Id, string Address, string City, string State, string ZipCode)
        {
            string result = string.Empty;
            int AddressId = int.Parse(Id);
            result = AdminBLL.Instance.UpdateCompanyAddress(AddressId, Address, City, State, ZipCode);
            return result;
        }
    }
}