using JG_Prospect.Common;
using JG_Prospect.Common.modal;
using JG_Prospect.DAL.Database;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.DAL
{
    public class HTMLTemplateDAL
    {
        public static HTMLTemplateDAL m_HTMLTemplateDAL = new HTMLTemplateDAL();

        private HTMLTemplateDAL()
        {

        }

        public static HTMLTemplateDAL Instance
        {
            get { return m_HTMLTemplateDAL; }
            private set { ; }
        }

        public DataSet GetHTMLTemplates()
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetHTMLTemplates");
                    command.CommandType = CommandType.StoredProcedure;
                    return database.ExecuteDataSet(command);
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DesignationHTMLTemplate GetDesignationHTMLTemplate(HTMLTemplates objHTMLTemplates, string strDesignation = null)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetDesignationHTMLTemplate");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.Int16, (byte)objHTMLTemplates);
                    if (!string.IsNullOrEmpty(strDesignation))
                    {
                        database.AddInParameter(command, "@Designation", DbType.String, strDesignation);
                    }

                    DataSet dsHTMLTemplate = database.ExecuteDataSet(command);
                    DesignationHTMLTemplate objHTMLTemplate = null;
                    if (
                        dsHTMLTemplate != null && 
                        dsHTMLTemplate.Tables.Count > 0 && 
                        dsHTMLTemplate.Tables[0].Rows.Count > 0
                       )
                    {
                        DataRow dr = dsHTMLTemplate.Tables[0].Rows[0];

                        objHTMLTemplate = new DesignationHTMLTemplate();

                        objHTMLTemplate.Id = Convert.ToInt32(dr["Id"]);
                        objHTMLTemplate.HTMLTemplatesMasterId = Convert.ToInt32(dr["HTMLTemplatesMasterId"]);
                        objHTMLTemplate.Subject = Convert.ToString(dr["Subject"]);
                        objHTMLTemplate.Header = Convert.ToString(dr["Header"]);
                        objHTMLTemplate.Body = Convert.ToString(dr["Body"]);
                        objHTMLTemplate.Footer = Convert.ToString(dr["Footer"]);
                        objHTMLTemplate.DateUpdated = Convert.ToDateTime(dr["DateUpdated"]);
                    }

                    return objHTMLTemplate;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
}
