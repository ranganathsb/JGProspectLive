using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JG_Prospect
{
    public partial class screening_intermediate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Request.QueryString.Count > 0 && !String.IsNullOrEmpty(Request.QueryString["returnurl"]))
                {
                    String returnURL = Page.ResolveClientUrl(HttpUtility.UrlDecode(String.Concat("~/",Request.QueryString["returnurl"].ToString())));
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "Javascript", String.Concat("javascript:showScreeningPopup('", returnURL, "');"),true);
                }
            }
        }
    }
}