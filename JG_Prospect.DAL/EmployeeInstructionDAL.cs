using JG_Prospect.Common.modal;
using JG_Prospect.DAL.Database;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.DAL
{
    public class EmployeeInstructionDAL
    {
        private static EmployeeInstructionDAL m_EmployeeInstructionDAL = new EmployeeInstructionDAL();
        public static EmployeeInstructionDAL Instance
        {
            get { return m_EmployeeInstructionDAL; }
            private set { ; }
        }

        
    }
}
