using JG_Prospect.BLL;
using JG_Prospect.Common.modal;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;

namespace JG_Prospect.WebServices
{
    /// <summary>
    /// Summary description for JGWebService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class JGWebService : System.Web.Services.WebService
    {

        [WebMethod]
        public object GetTaskWorkSpecifications(Int32 TaskId, bool blIsAdmin, Int64 intParentTaskWorkSpecificationId)
        {
            List<string> strTableData = new List<string>();

            DataSet ds = new DataSet();

            if (intParentTaskWorkSpecificationId == 0)
            {
                ds = TaskGeneratorBLL.Instance.GetTaskWorkSpecifications(TaskId, blIsAdmin, null, 0, null);
            }
            else
            {
                ds = TaskGeneratorBLL.Instance.GetTaskWorkSpecifications(TaskId, blIsAdmin, intParentTaskWorkSpecificationId, 0, null);
            }

            TaskWorkSpecification[] arrTaskWorkSpecification = null;

            string strFirstParentCustomId = "";
            string strLastCustomId = "";
            int intTotalRecordCount = 0;

            if (ds.Tables.Count == 4)
            {
                arrTaskWorkSpecification = new TaskWorkSpecification[ds.Tables[0].Rows.Count];
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    DataRow dr = ds.Tables[0].Rows[i];
                    arrTaskWorkSpecification[i] = new TaskWorkSpecification();
                    arrTaskWorkSpecification[i].Id = Convert.ToInt64(dr["Id"]);
                    arrTaskWorkSpecification[i].CustomId = Convert.ToString(dr["CustomId"]);
                    arrTaskWorkSpecification[i].AdminStatus = Convert.ToBoolean(dr["AdminStatus"]);
                    arrTaskWorkSpecification[i].TechLeadStatus = Convert.ToBoolean(dr["TechLeadStatus"]);
                    arrTaskWorkSpecification[i].Description = Convert.ToString(dr["Description"]);
                    if (!string.IsNullOrEmpty(dr["ParentTaskWorkSpecificationId"].ToString()))
                    {
                        arrTaskWorkSpecification[i].ParentTaskWorkSpecificationId = Convert.ToInt64(dr["ParentTaskWorkSpecificationId"]);
                    }
                    arrTaskWorkSpecification[i].TaskWorkSpecificationsCount = Convert.ToInt32(dr["SubTaskWorkSpecificationCount"]);
                }

                intTotalRecordCount = Convert.ToInt32(ds.Tables[1].Rows[0]["TotalRecordCount"]);

                if (ds.Tables[2].Rows.Count > 0)
                {
                    strFirstParentCustomId = Convert.ToString(ds.Tables[2].Rows[0]["FirstParentCustomId"]);
                }
                if (ds.Tables[3].Rows.Count > 0)
                {
                    strLastCustomId = Convert.ToString(ds.Tables[3].Rows[0]["LastChildCustomId"]);
                }
            }

            string strNextCustomId = string.Empty;

            if (string.IsNullOrEmpty(strFirstParentCustomId) || intParentTaskWorkSpecificationId == 0)
            {
                strNextCustomId = App_Code.CommonFunction.GetTaskWorkSpecificationSequence('A', strLastCustomId);
            }
            // parent list has roman numbering.
            else if (strFirstParentCustomId.Equals("i") || strFirstParentCustomId.Equals("I"))
            {
                strNextCustomId = App_Code.CommonFunction.GetTaskWorkSpecificationSequence('a', strLastCustomId);
            }
            // parent list has alphabetical numbering.
            else
            {
                strNextCustomId = App_Code.CommonFunction.GetTaskWorkSpecificationSequence('I', strLastCustomId, true);
            }

            var result = new
            {
                NextCustomId = strNextCustomId,
                TotalRecordCount = intTotalRecordCount,
                Records = arrTaskWorkSpecification
            };

            return result;
        }

        [WebMethod]
        public bool SaveTaskWorkSpecification(Int64 intId, string strCustomId, string strDescription, Int64 intTaskId, Int64 intParentTaskWorkSpecificationId)
        {
            bool blSuccess = true;

            if (intTaskId > 0)
            {
                TaskWorkSpecification objTaskWorkSpecification = new TaskWorkSpecification();
                objTaskWorkSpecification.Id = intId;
                objTaskWorkSpecification.CustomId = strCustomId;
                objTaskWorkSpecification.TaskId = intTaskId;
                objTaskWorkSpecification.Description = Server.HtmlDecode(strDescription);
                objTaskWorkSpecification.Links = string.Empty;
                objTaskWorkSpecification.WireFrame = string.Empty;
                // save will revoke freezed status.
                objTaskWorkSpecification.AdminStatus = false;
                objTaskWorkSpecification.TechLeadStatus = false;

                if (intParentTaskWorkSpecificationId > 0)
                {
                    objTaskWorkSpecification.ParentTaskWorkSpecificationId = intParentTaskWorkSpecificationId;
                }

                if (objTaskWorkSpecification.Id == 0)
                {
                    TaskGeneratorBLL.Instance.InsertTaskWorkSpecification(objTaskWorkSpecification);
                }
                else
                {
                    TaskGeneratorBLL.Instance.UpdateTaskWorkSpecification(objTaskWorkSpecification);
                }
            }
            else
            {
                blSuccess = false;
            }
            return blSuccess;
        }

        [WebMethod]
        public bool DeleteTaskWorkSpecification(Int64 intId)
        {
            bool blSuccess = false;

            if (TaskGeneratorBLL.Instance.DeleteTaskWorkSpecification(intId) > 0)
            {
                blSuccess = true;
            }

            return blSuccess;
        }
    }
}
