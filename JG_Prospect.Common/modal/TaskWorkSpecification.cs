using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.Common.modal
{
    public class TaskWorkSpecification
    {
        public Int64 Id;
        public Int64 TaskId;
        public Int32 UserId;
        public bool IsInstallUser;
        public Int16 Status;
        public string Content;
        public DateTime DateCreated;
        public TaskWorkSpecificationVersions TaskWorkSpecificationVersions;
    }
}
