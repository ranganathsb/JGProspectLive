using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.Common.modal
{
    [Serializable]
    public partial class TaskComment
    {
        public long Id { get; set; }
        public string Comment { get; set; }
        public long TaskId { get; set; }
        public long? ParentCommentId { get; set; }
        public int UserId { get; set; }
        public DateTime DateCreated { get; set; }
    }
}
