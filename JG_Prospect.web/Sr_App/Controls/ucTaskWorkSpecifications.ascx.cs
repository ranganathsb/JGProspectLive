#region '--Using--'

using System;

#endregion

namespace JG_Prospect.Sr_App.Controls
{
    public partial class ucTaskWorkSpecifications : System.Web.UI.UserControl
    {
        #region '--Members--'


        #endregion

        #region '--Properties--'

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

        #endregion

        #region '--Page Events--'

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        #endregion

        #region '--Control Events--'

        #endregion

        #region '--Methods--'

        protected string GetPasswordPlaceholder()
        {
            string strPlaceholder = string.Empty;
            if (Session["DesigNew"].ToString().ToUpper().Equals("ADMIN"))
            {
                strPlaceholder = "Admin Password";
            }
            else if (Session["DesigNew"].ToString().ToUpper().Equals("ITLEAD"))
            {
                strPlaceholder = "IT Lead Password";
            }
            else
            {
                strPlaceholder = "User Password";
            }
            return strPlaceholder;
        }

        protected string GetPasswordCheckBoxChangeEvent(bool blAdmin,bool blITLead,bool blUser)
        {
            string strOnChange = "javascript: return false;";
            if (Session["DesigNew"].ToString().ToUpper().Equals("ADMIN"))
            {
                if (blAdmin)
                {
                    strOnChange = "javascript: OnApprovalCheckBoxChanged(this);";
                }
            }
            else if (Session["DesigNew"].ToString().ToUpper().Equals("ITLEAD"))
            {
                if (blITLead)
                {
                    strOnChange = "javascript: OnApprovalCheckBoxChanged(this);";
                }
            }
            else if(blUser)
            {
                strOnChange = "javascript: OnApprovalCheckBoxChanged(this);";
            }
            return strOnChange;
        }

        #endregion
    }
}