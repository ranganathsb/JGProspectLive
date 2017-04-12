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
    public class TaskCommentDAL
    {
        private static TaskCommentDAL m_TaskCommentDAL = new TaskCommentDAL();
        public static TaskCommentDAL Instance
        {
            get { return m_TaskCommentDAL; }
            private set { ; }
        }


        public bool InsertTaskComment(TaskComment objTaskComment)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("InsertTaskComment");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Comment", DbType.String, objTaskComment.Comment);
                    database.AddInParameter(command, "@TaskId", DbType.Int64, objTaskComment.TaskId);
                    database.AddInParameter(command, "@ParentCommentId", DbType.Int64, objTaskComment.ParentCommentId);
                    database.AddInParameter(command, "@UserId", DbType.Int32, objTaskComment.UserId);
                    
                    return (database.ExecuteNonQuery(command) > 0);
                }
            }
            catch(Exception ex)
            {
                return false;
            }
        }

        public bool UpdateTaskComment(TaskComment objTaskComment)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UpdateTaskComment");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.String, objTaskComment.Id);
                    database.AddInParameter(command, "@Comment", DbType.String, objTaskComment.Comment);
                    database.AddInParameter(command, "@TaskId", DbType.Int64, objTaskComment.TaskId);
                    database.AddInParameter(command, "@ParentCommentId", DbType.Int64, objTaskComment.ParentCommentId);
                    database.AddInParameter(command, "@UserId", DbType.Int32, objTaskComment.UserId);

                    return (database.ExecuteNonQuery(command) > 0);
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool DeleteTaskComment(TaskComment objTaskComment)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("DeleteTaskComment");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.String, objTaskComment.Id);

                    return (database.ExecuteNonQuery(command) > 0);
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }



    }
}
