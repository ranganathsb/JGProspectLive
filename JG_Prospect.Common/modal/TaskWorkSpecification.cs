using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.Common.modal
{
    [Serializable]
    public class TaskWorkSpecification
    {
        public long Id { get; set; }
        public string CustomId { get; set; }
        public long TaskId { get; set; }
        public string Description { get; set; }
        public string Links { get; set; }
        public string WireFrame { get; set; }
        public int UserId { get; set; }
        public bool IsInstallUser { get; set; }
        public bool AdminStatus { get; set; }
        public bool TechLeadStatus { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime DateUpdated { get; set; }
    }
}
