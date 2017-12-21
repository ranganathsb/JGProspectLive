using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.Common
{
    public static class Extensions
    {
        /// <summary>
        /// Converts UTC DateTime to EST DateTime
        /// </summary>
        /// <param name="dateTime"></param>
        /// <returns></returns>
        public static DateTime ToEST(this DateTime dateTime)
        {
            DateTime utcDateTime = DateTime.Parse(dateTime.ToString(), CultureInfo.InvariantCulture, DateTimeStyles.RoundtripKind);
            TimeZoneInfo easternTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time");
            return TimeZoneInfo.ConvertTimeFromUtc(utcDateTime, easternTimeZone);
        }
    }
}
