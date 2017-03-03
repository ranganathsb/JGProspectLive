using JG_Prospect.App_Code;
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
            grdHtmlTemplates.DataSource = HTMLTemplateBLL.Instance.GetHTMLTemplateMasters();
            grdHtmlTemplates.DataBind();
        }

        protected void grdHtmlTemplates_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            
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