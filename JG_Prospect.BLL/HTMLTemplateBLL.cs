using JG_Prospect.Common;
using JG_Prospect.Common.modal;
using JG_Prospect.DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.BLL
{
    public class HTMLTemplateBLL
    {
        private static HTMLTemplateBLL m_HTMLTemplateBLL = new HTMLTemplateBLL();

        private HTMLTemplateBLL()
        {

        }

        public static HTMLTemplateBLL Instance
        {
            get { return m_HTMLTemplateBLL; }
            set { ; }
        }

        public DataSet GetHTMLTemplates()
        {
            return HTMLTemplateDAL.Instance.GetHTMLTemplates();
        }

        public DesignationHTMLTemplate GetDesignationHTMLTemplate(HTMLTemplates objHTMLTemplates, string strDesignation = null)
        {
            return HTMLTemplateDAL.Instance.GetDesignationHTMLTemplate(objHTMLTemplates, strDesignation);
        }
    }
}
