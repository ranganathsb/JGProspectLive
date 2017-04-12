using JG_Prospect.Common.modal;
using JG_Prospect.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.BLL
{
    public class TaskCommentBLL
    {
        private static TaskCommentBLL m_TaskCommentBLL = new TaskCommentBLL();

        public static TaskCommentBLL Instance
        {
            get { return m_TaskCommentBLL; }
            set {; }
        }

        public bool InsertTaskComment(TaskComment objTaskComment)
        {
            return TaskCommentDAL.Instance.InsertTaskComment(objTaskComment);
        }

        public bool UpdateTaskComment(TaskComment objTaskComment)
        {
            return TaskCommentDAL.Instance.UpdateTaskComment(objTaskComment);
        }

        public bool DeleteTaskComment(TaskComment objTaskComment)
        {
            return TaskCommentDAL.Instance.DeleteTaskComment(objTaskComment);
        }
    }
}
