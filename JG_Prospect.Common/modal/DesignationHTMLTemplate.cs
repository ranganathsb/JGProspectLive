using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.Common.modal
{
    public class DesignationHTMLTemplate
    {
        public int Id { get; set; }
        public int HTMLTemplatesMaterId { get; set; }
        public string Designation { get; set; }
        public string Subject { get; set; }
        public string Header { get; set; }
        public string Body { get; set; }
        public string Footer { get; set; }
        public DateTime DateUpdated { get; set; }
    }
}
