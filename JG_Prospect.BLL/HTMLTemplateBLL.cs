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

        public DataSet GetHTMLTemplateMasters(Int32 TemplateUsedFor)
        {
            return HTMLTemplateDAL.Instance.GetHTMLTemplateMasters(TemplateUsedFor);
        }

        public HTMLTemplatesMaster GetHTMLTemplateMasterById(HTMLTemplates objHTMLTemplates)
        {
            return HTMLTemplateDAL.Instance.GetHTMLTemplateMasterById(objHTMLTemplates);
        }

        public DesignationHTMLTemplate GetDesignationHTMLTemplate(HTMLTemplates objHTMLTemplates, string strDesignation)
        {
            return HTMLTemplateDAL.Instance.GetDesignationHTMLTemplate(objHTMLTemplates, strDesignation);
        }

        public bool SaveDesignationHTMLTemplate(DesignationHTMLTemplate objDesignationHTMLTemplate, byte? intMasterCategory)
        {
            return HTMLTemplateDAL.Instance.SaveDesignationHTMLTemplate(objDesignationHTMLTemplate, intMasterCategory);
        }

        public bool DeleteDesignationHTMLTemplate(HTMLTemplates objHTMLTemplates, string strDesignation)
        {
            return HTMLTemplateDAL.Instance.DeleteDesignationHTMLTemplate(objHTMLTemplates, strDesignation);
        }

        public bool UpdateHTMLTemplateFromId(Int32 TemplateId, String FromID) {
            return HTMLTemplateDAL.Instance.UpdateHTMLTemplateFromId(TemplateId ,FromID);
        }
        public bool UpdateHTMLTemplateSubject(Int32 TemplateId, String Subject) {
            return HTMLTemplateDAL.Instance.UpdateHTMLTemplateSubject(TemplateId, Subject);
        }

        public bool UpdateHTMLTemplateTriggerText(Int32 TemplateId, String TriggerText)
        {
            return HTMLTemplateDAL.Instance.UpdateHTMLTemplateTriggerText(TemplateId, TriggerText);
        }

        public bool UpdateHTMLTemplateFreQuency(Int32 TemplateId, Int32 FrequencyInDays, DateTime FrequencyStartDate, DateTime FrequenchTime)
        {
            return HTMLTemplateDAL.Instance.UpdateHTMLTemplateFreQuency(TemplateId, FrequencyInDays,FrequencyStartDate,FrequenchTime);

        }
    }
}
