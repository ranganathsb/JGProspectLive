using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.Common
{
    public class JGCommon
    {
        public static string GenerateOTP(int length)
        {
            const string valid = "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789011223344556677889900";
            StringBuilder res = new StringBuilder();
            Random rnd = new Random(5);
            while (0 < length--)
            {
                res.Append(valid[rnd.Next(valid.Length)]);
            }
            return res.ToString();
        }

    }

    public class JGApplicationInfo
    {
        public static double GetAcceptiblePrecentage()
        {
            return Convert.ToDouble(ConfigurationManager.AppSettings["AcceptableUserPercentage"]);
        }
        public static Int32 GetJMGCAutoUserID()
        {
            return Convert.ToInt32(ConfigurationManager.AppSettings["JMGCAUTOUSERID"]);
        }
    }
}
