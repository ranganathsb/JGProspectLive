using System;
using System.Collections.Generic;
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

    }
}
