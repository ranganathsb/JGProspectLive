using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.Common.modal
{
    public class TaskWorkSpecificationVersions
    {
        public Int64 Id;
        public Int64 TaskWorkSpecificationId;
        public Int32 UserId;
        public bool IsInstallUser;
        public string Content;
        public DateTime DateCreated;
        public TaskWorkSpecification TaskWorkSpecification;
    }
}
