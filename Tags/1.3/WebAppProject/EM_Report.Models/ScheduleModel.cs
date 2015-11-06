using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EM_Report.Models.RS2005;
using System.ComponentModel.DataAnnotations;

namespace EM_Report.Models
{
    public class ScheduleModel
    {
        private const string STR_DATETIME_VALIDATION = @"/^(?:(?:(?:0?[13578]|1[02])(\/|-|\.)31)\1|(?:(?:0?[1,3-9]|1[0-2])(\/|-|\.)(?:29|30)\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:0?2(\/|-|\.)29\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:(?:0?[1-9])|(?:1[0-2]))(\/|-|\.)(?:0?[1-9]|1\d|2[0-8])\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$/igm";
        public string ScheduleId { get; set; }

        public string ScheduleDefType { get; set; }

        [Range(0, 24, ErrorMessage="Hours: 0 to 24")]
        public short Hour { get; set; }

        [Range(0, 60, ErrorMessage = "Minutes: 0 to 60")]
        public short Minute { get; set; }

        public DaysOfWeekSelector wDaysOfWeek { get; set; }
        public DaysOfWeekSelector mDaysOfWeek { get; set; }

        [Range(0, 999, ErrorMessage = "0 to 999")]
        public int DaysInterval { get; set; }
        [Range(0, 999, ErrorMessage = "0 to 999")]
        public int WeeksInterval { get; set; }

        public MonthsOfYearSelector MonthsOfYear { get; set; }
        public short MonthlyType { get; set; }
        public short WeeksOfMonth { get; set; }
        public string MonthDays { get; set; }

        [Range(1, 12, ErrorMessage = "Start hour: 1 to 12")]
        public short StartHour { get; set; }

        [Range(0, 59, ErrorMessage = "Start minute: 0 to 59")]
        public short StartMinute { get; set; }

        public bool IsAM { get; set; }
        public DateTime StartDate { get; set; }
        public bool HasEndDate { get; set; }
        public DateTime EndDate { get; set; }

        public ScheduleModel()
        {
            Hour = 1;
            Minute = 0;
            wDaysOfWeek = new DaysOfWeekSelector() { Monday = true };
            mDaysOfWeek = new DaysOfWeekSelector() { Monday = true };
            DaysInterval = 1;
            WeeksInterval = 1;
            MonthsOfYear = new MonthsOfYearSelector() { September = true };
            MonthDays = "1, 3-5";
            StartHour = 1;
            HasEndDate = false;
        }
    }
}