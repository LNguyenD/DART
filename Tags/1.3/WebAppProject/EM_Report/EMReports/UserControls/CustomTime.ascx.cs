using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EM_Report.EMReports.UserControls
{
    public partial class CustomTime : System.Web.UI.UserControl
    {
        public enum DaySegment { AM, PM };
        public int Hour { get { return int.Parse(txtHour.Value); } set { txtHour.Value = value.ToString(); } }
        public int Minute { get { return int.Parse(txtMinute.Value); } set { txtMinute.Value = value.ToString(); } }
        public DaySegment Segment { get { return radAM.Checked ? DaySegment.AM : DaySegment.PM; } 
            set {
                if (value == DaySegment.AM)
                    radAM.Checked = true;
                else
                    radPM.Checked = true;

            } 
        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
}