﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using JG_Prospect.DAL;
using JG_Prospect.Common;
using JG_Prospect.Common.modal;
using System.Data;

namespace JG_Prospect.BLL
{
    public class DesignationBLL
    {
        private static DesignationBLL m_DesignationBLL = new DesignationBLL();

        private DesignationBLL()
        {

        }

        public static DesignationBLL Instance
        {
            get { return m_DesignationBLL; }
            set {; }
        }

        public DataSet GetAllDesignationsForHumanResource()
        {
            return DesignationDAL.Instance.GetAllDesignationsForHumanResource();
        }
    }
}