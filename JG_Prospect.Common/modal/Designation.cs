﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.Common.modal
{
    public class Designation
    {
        public int ID { get; set; }
        public string DesignationName { get; set; }
        public bool IsActive { get; set; }
        public int DepartmentID { get; set; }
        public string DepartmentName { get; set; }
    }
}
