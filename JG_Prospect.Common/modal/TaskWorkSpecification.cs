using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.Common.modal
{
    [Serializable]
    public partial class TaskWorkSpecification
    {
        public TaskWorkSpecification()
        {
            TaskWorkSpecifications = new List<TaskWorkSpecification>();
        }

        public List<TaskWorkSpecification> TaskWorkSpecifications;

        public long Id { get; set; }
        public long? ParentTaskWorkSpecificationId { get; set; }
        public string CustomId { get; set; }
        public long TaskId { get; set; }
        public string Description { get; set; }
        public string Links { get; set; }
        public string WireFrame { get; set; }
        public int? AdminUserId { get; set; }
        public int? TechLeadUserId { get; set; }
        public bool? IsAdminInstallUser { get; set; }
        public bool? IsTechLeadInstallUser { get; set; }
        public bool AdminStatus { get; set; }
        public bool TechLeadStatus { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime DateUpdated { get; set; }
        public DateTime? AdminStatusUpdated { get; set; }
        public DateTime? TechLeadStatusUpdated { get; set; }
        public string AdminUsername { get; set; }
        public string AdminUserFirstname { get; set; }
        public string AdminUserLastname { get; set; }
        public string AdminUserEmail { get; set; }
        public string TechLeadUsername { get; set; }
        public string TechLeadUserFirstname { get; set; }
        public string TechLeadUserLastname { get; set; }
        public string TechLeadUserEmail { get; set; }


    }
}
