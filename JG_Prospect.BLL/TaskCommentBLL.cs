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
    }
}
